Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3EA5F32E5
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 16:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388189AbfKGPYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 10:24:11 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:43182 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbfKGPYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 10:24:11 -0500
Received: from [192.168.1.47] (unknown [50.34.216.97])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id A4F4413C358;
        Thu,  7 Nov 2019 07:24:09 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com A4F4413C358
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1573140251;
        bh=51W91Kw2UqEb8Wlp1490MubzBtLUcquzz36+dIa/yk8=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=MLjoN28EsJ7Hcrq5iM3T9oJvb3rV4Ko1evC6v41M1C1VxFkNS9bml8tMltAtqXLBn
         kfvP/Q95avdsMtK5oWprw9vOTXtUs1W11hsFbL8z4sgdCNWO2r0sNR14LpKng3IeRT
         r37iAX7JwcSVkDbw9zxUGpSVfE7XdpZEhIyUWU4U=
Subject: Re: [PATCH net-next] ath10k: fix RX of frames with broken FCS in
 monitor mode
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>
References: <20191105164932.11799-1-linus.luessing@c0d3.blue>
 <927cea69-7afc-5c35-df8d-9813392e8928@candelatech.com>
 <20191107140149.GB19482@otheros>
Cc:     =?UTF-8?Q?Linus_L=c3=bcssing?= <ll@simonwunderlich.de>,
        ath10k@lists.infradead.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <6ca7e338-d14d-49f6-f51c-600856b59767@candelatech.com>
Date:   Thu, 7 Nov 2019 07:24:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20191107140149.GB19482@otheros>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/07/2019 06:03 AM, Linus Lüssing wrote:
> On Tue, Nov 05, 2019 at 09:19:20AM -0800, Ben Greear wrote:
>> Thanks for adding the counter.  Since it us u32, I doubt you need the spin lock
>> below?
>
> Ok, I can remove the spin-lock.
>
> Just for clarification though, if I recall correctly then an increment operator
> is not guaranteed to work atomically. But you think it's unlikely
> to race with a concurrent ++ and therefore it's fine for just a debug counter?
> (and if it were racing, it'd just be a missed +1)

I think it is fine to be off-by-one, and u32 is atomic so you would never read a really
weird number, like you can if u64 is non-atomically being incremented.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
