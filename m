Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CFD304A03
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731799AbhAZFTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:19:10 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:44700 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730021AbhAYPgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:36:13 -0500
Received: from [192.168.254.6] (unknown [50.34.179.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 915FF13C2B3;
        Mon, 25 Jan 2021 07:18:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 915FF13C2B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1611587900;
        bh=HOrugnLXiwYa+8bEkPG/ZERWTD5lVnnhU8PLBJeM5PY=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=CPUH9OiflsvhosANjkIiLKp2E5mRBI+Mslr5Zb567q8l/BJuz577p8bOwCbTaeJY2
         qM3HHcDgLLODGw8s99S/kPZq5ugxlELMSHcN46yTYRKtVun2yt1/TO60o1TswNB2Y5
         zb+icEWXQp3QcmneUpxIrO+IzlCWEe/y7XMKXn6o=
Subject: Re: VRF: ssh port forwarding between non-vrf and vrf interface.
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
References: <7dcd75bb-b934-e482-2e84-740c5c80efe0@candelatech.com>
 <2dbd0ccb-9209-5682-0ae2-207cc02086ab@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <2ce42f10-8884-074e-9992-edd29db22d5d@candelatech.com>
Date:   Mon, 25 Jan 2021 07:18:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <2dbd0ccb-9209-5682-0ae2-207cc02086ab@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/21 8:02 AM, David Ahern wrote:
> On 1/22/21 8:45 AM, Ben Greear wrote:
>> Hello,
>>
>> I have a system with a management interface that is not in any VRF, and
>> then I have
>> a port that *is* in a VRF.  I'd like to be able to set up ssh port
>> forwarding so that
>> when I log into the system on the management interface it will
>> automatically forward to
>> an IP accessible through the VRF interface.
>>
>> Is there a way to do such a thing?
>>
> 
> For a while I had a system setup with eth0 in a management VRF and setup
> to do NAT and port forwarding of incoming ssh connections, redirecting
> to VMs running in a different namespace. Crossing VRFs with netfilter
> most likely will not work without some development. You might be able to
> do it with XDP - rewrite packet headers and redirect. That too might
> need a bit of development depending on the netdevs involved.
> 

Maybe easier to improve ssh so that it could specify a netdev to bind to when
making the call to the redirected destination?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
