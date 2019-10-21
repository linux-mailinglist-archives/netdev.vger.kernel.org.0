Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95440DEE9E
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbfJUOBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:01:04 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:51700 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbfJUOBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:01:04 -0400
Received: from [192.168.1.47] (unknown [50.34.216.97])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id A377D137563;
        Mon, 21 Oct 2019 07:01:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com A377D137563
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1571666463;
        bh=TC0IC7ijVgH9EVtRApZTiGeFe1tzHYJg6SGZj3JD57E=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=dB9W91qhjuh+ZefuIByWJyo92qyfGQjN7Ueu0zjVFermwckAaik1XLfzrxBbMV14O
         Y8rhWNATIjDSg9KiPv1imIYSGJKhO2yb5M/ZN1AQ+TD/HMkfWGbVDbUqi/AzoJeolO
         c15E661Rx/PoWdnGtBrkm/EoSyvy755xltPfPqG8=
Subject: Re: WARNING at net/mac80211/sta_info.c:1057
 (__sta_info_destroy_part2())
To:     =?UTF-8?Q?Tomislav_Po=c5=beega?= <pozega.tomislav@gmail.com>,
        kvalo@codeaurora.org
References: <87lfuuln5n.fsf@tynnyri.adurom.net>
 <1571584320-29816-1-git-send-email-pozega.tomislav@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, davem@davemloft.net,
        torvalds@linux-foundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <073b0ffb-187b-659e-0967-23ae44c5c660@candelatech.com>
Date:   Mon, 21 Oct 2019 07:01:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1571584320-29816-1-git-send-email-pozega.tomislav@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/20/2019 08:12 AM, Tomislav Požega wrote:
>> -11 is -EAGAIN which would mean that the HTC credits have run out some
>>  reason for the WMI command:
>>
>> if (ep->tx_credits < credits) {
>>         ath10k_dbg(ar, ATH10K_DBG_HTC,
>>                 "htc insufficient credits ep %d required %d available %d\n",
>>                 eid, credits, ep->tx_credits);
>>         spin_unlock_bh(&htc->tx_lock);
>>         ret = -EAGAIN;
>>         goto err_pull;
>> }
>>
>> Credits can run out, for example, if there's a lot of WMI command/event
>> activity and are not returned during the 3s wait, firmware crashed or
>> problems with the PCI bus.
>
> Hi
>
> Can this occur if the target memory is not properly allocated?

I have only seen this on wave-1 cards, and it is usually paired with situations
where the wave-1 stops doing WMI related interrupts properly as best as I can
understand.  If I force the firmware to poll instead of waiting for irqs, then
WMI communication will work for a while...I have not implemented that on the
driver side though, so I still see these WMI timeout issues.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
