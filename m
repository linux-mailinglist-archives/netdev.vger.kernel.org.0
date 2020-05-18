Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAFA1D7F66
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgERQ65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:58:57 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:34494 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgERQ64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 12:58:56 -0400
Received: from [192.168.254.4] (unknown [50.34.197.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id DFE0A13C2B0;
        Mon, 18 May 2020 09:58:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com DFE0A13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1589821136;
        bh=6ZIoXbMXxw4WcnY1CZ2nowts+dksxVL0SXCsldVPTmw=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=cZyh3hBAu8T8moMyFlKqCPnzpUBdR7y8+DBRg8oaujckvLRpCCDXOWp8OScV1IHQm
         GLqxMSe21UIlDQO6gJL+/t+/IKiS5KfclPRc/R5dyCipAw9AQAgN7XXp93sgA4xLV1
         qtLwBDyzpjYQZdanGM+aoyiOwHQFYlvaQT7MSZnQ=
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-13-mcgrof@kernel.org>
 <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
 <20200518165154.GH11244@42.do-not-panic.com>
Cc:     jeyu@kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        rostedt@goodmis.org, mingo@redhat.com, aquini@redhat.com,
        cai@lca.pw, dyoung@redhat.com, bhe@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, gpiccoli@canonical.com,
        pmladek@suse.com, tiwai@suse.de, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <4ad0668d-2de9-11d7-c3a1-ad2aedd0c02d@candelatech.com>
Date:   Mon, 18 May 2020 09:58:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20200518165154.GH11244@42.do-not-panic.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/18/2020 09:51 AM, Luis Chamberlain wrote:
> On Sat, May 16, 2020 at 03:24:01PM +0200, Johannes Berg wrote:
>> On Fri, 2020-05-15 at 21:28 +0000, Luis Chamberlain wrote:> module_firmware_crashed
>>
>> You didn't CC me or the wireless list on the rest of the patches, so I'm
>> replying to a random one, but ...
>>
>> What is the point here?
>>
>> This should in no way affect the integrity of the system/kernel, for
>> most devices anyway.
>
> Keyword you used here is "most device". And in the worst case, *who*
> knows what other odd things may happen afterwards.
>
>> So what if ath10k's firmware crashes? If there's a driver bug it will
>> not handle it right (and probably crash, WARN_ON, or something else),
>> but if the driver is working right then that will not affect the kernel
>> at all.
>
> Sometimes the device can go into a state which requires driver removal
> and addition to get things back up.

It would be lovely to be able to detect this case in the driver/system
somehow!  I haven't seen any such cases recently, but in case there is
some common case you see, maybe we can think of a way to detect it?

>
>> So maybe I can understand that maybe you want an easy way to discover -
>> per device - that the firmware crashed, but that still doesn't warrant a
>> complete kernel taint.
>
> That is one reason, another is that a taint helps support cases *fast*
> easily detect if the issue was a firmware crash, instead of scraping
> logs for driver specific ways to say the firmware has crashed.

You can listen for udev events (I think that is the right term),
and find crashes that way.  You get the actual crash info as well.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
