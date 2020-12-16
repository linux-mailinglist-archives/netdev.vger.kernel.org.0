Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A86C2DC9C7
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbgLQAAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:00:36 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:36462 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgLQAAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 19:00:36 -0500
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 6E4C213C2B0;
        Wed, 16 Dec 2020 15:59:55 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 6E4C213C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1608163195;
        bh=ba474zonrNTBOCRoHWQRZYqbP/gxznsMC6EdKcy5IoU=;
        h=Subject:From:To:References:Date:In-Reply-To:From;
        b=E87g9AqcM9yZjf0O3wiQjCloQpARFVqZcPPlsYvQbhISQ/skvSS7yRmCaXhX6VsJ2
         PDv+T1agn38KAHV04exJyOSZB7tNDcrLZ4nYF6pqwq1DmOGeYKU9s7ikBpr0cIpEw/
         j21hiJX+r2lNiYqVpv8mSEoeKp39MkZYKzyGIg+0=
Subject: Re: net: tso: add UDP segmentation support: adds regression for ax200
 upload
From:   Ben Greear <greearb@candelatech.com>
To:     netdev <netdev@vger.kernel.org>, edumazet@google.com
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
Organization: Candela Technologies
Message-ID: <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com>
Date:   Wed, 16 Dec 2020 15:59:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/20 3:09 PM, Ben Greear wrote:
> Hello Eric,
> 
> The patch below evidently causes TCP throughput to be about 50Mbps instead of 700Mbps
> when using ax200 to upload tcp traffic.
> 
> When I disable TSO, performance goes back up to around 700Mbps.

As a followup, when I revert the patch, upload speed goes to ~900Mbps,
so even better than just disabling TSO (I left TSO enabled after reverting the patch).

Thanks,
Ben

> 
> I recall ~5 years ago we had similar TCP related performance issues with ath10k.
> I vaguely recall that there might be some driver-level socket pacing tuning value, but I cannot
> find the right thing to search for.  Is this really a thing?  If so, maybe it will
> be a way to resolve this issue?
> 
> See this more thorough bug report:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=209913
> 
> Patch description:
> net: tso: add UDP segmentation support
> Note that like TCP, we do not support additional encapsulations,
> and that checksums must be offloaded to the NIC.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Thanks,
> Ben
> 

