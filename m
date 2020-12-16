Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8402DC965
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 00:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgLPXKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 18:10:21 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:35624 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgLPXKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 18:10:20 -0500
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id A261713C2B3;
        Wed, 16 Dec 2020 15:09:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com A261713C2B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1608160162;
        bh=/3Uae07xIrwndcefgfPL21WKSJH9zPfnI0neeSwSAB0=;
        h=To:From:Subject:Date:From;
        b=WFRAH0W+S/U34+Qiy93GuiIF1yXKymR41/RttDYFxHuwtf1EhVeEJjJL6nK1UH8Jc
         x+Su3yh04hFX5R68yWnK6PjyN702n+nX4HwG1wx6aN12f0LapGBB0Z1jb0TYNd39T+
         bgGworydp6eZiYZ5BbDjfvKIM5t9ZeQ78LXjRgL8=
To:     netdev <netdev@vger.kernel.org>, edumazet@google.com
From:   Ben Greear <greearb@candelatech.com>
Subject: net: tso: add UDP segmentation support: adds regression for ax200
 upload
Organization: Candela Technologies
Message-ID: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
Date:   Wed, 16 Dec 2020 15:09:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Eric,

The patch below evidently causes TCP throughput to be about 50Mbps instead of 700Mbps
when using ax200 to upload tcp traffic.

When I disable TSO, performance goes back up to around 700Mbps.

I recall ~5 years ago we had similar TCP related performance issues with ath10k.
I vaguely recall that there might be some driver-level socket pacing tuning value, but I cannot
find the right thing to search for.  Is this really a thing?  If so, maybe it will
be a way to resolve this issue?

See this more thorough bug report:

https://bugzilla.kernel.org/show_bug.cgi?id=209913

Patch description:
net: tso: add UDP segmentation support
Note that like TCP, we do not support additional encapsulations,
and that checksums must be offloaded to the NIC.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
