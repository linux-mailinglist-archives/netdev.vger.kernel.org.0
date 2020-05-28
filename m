Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C0A1E656F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 17:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404195AbgE1PFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 11:05:07 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:51180 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404113AbgE1PFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 11:05:06 -0400
Received: from [192.168.254.4] (unknown [50.34.197.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 5B2E413C2B1;
        Thu, 28 May 2020 08:04:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 5B2E413C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1590678305;
        bh=9g+FCmpd9OQjTJwKS27K2q+crvDzOJovnY57n0BUHgU=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=RkOhEUVBrFFr2x1i0YwgKrYn+IMWGOJR18vuwFKT09ljz6AsZel52gm9GmnWdZRYL
         TIz0oB1Gek4KcDj13Qw9QdStM+9Rqg5IW3QkKkPkrcunbbd0iEYbdBmSy48ZmdMH4T
         vki6KnaompqoM3Ut2kdpDH60l11gmNBsjB1E+ZTA=
Subject: Re: [PATCH v3 0/8] kernel: taint when the driver firmware crashes
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200526145815.6415-1-mcgrof@kernel.org>
 <20200526154606.6a2be01f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20200526230748.GS11244@42.do-not-panic.com>
 <20200526163031.5c43fc1d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20200527031918.GU11244@42.do-not-panic.com>
 <20200527143642.5e4ffba0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20200528142705.GQ11244@42.do-not-panic.com>
Cc:     jeyu@kernel.org, davem@davemloft.net, michael.chan@broadcom.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        derosier@gmail.com, keescook@chromium.org, daniel.vetter@ffwll.ch,
        will@kernel.org, mchehab+samsung@kernel.org, vkoul@kernel.org,
        mchehab+huawei@kernel.org, robh@kernel.org, mhiramat@kernel.org,
        sfr@canb.auug.org.au, linux@dominikbrodowski.net,
        glider@google.com, paulmck@kernel.org, elver@google.com,
        bauerman@linux.ibm.com, yamada.masahiro@socionext.com,
        samitolvanen@google.com, yzaikin@google.com, dvyukov@google.com,
        rdunlap@infradead.org, corbet@lwn.net, dianders@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <58639bf9-b67c-0cbb-d4c0-69c4e400daff@candelatech.com>
Date:   Thu, 28 May 2020 08:04:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20200528142705.GQ11244@42.do-not-panic.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/28/2020 07:27 AM, Luis Chamberlain wrote:
> On Wed, May 27, 2020 at 02:36:42PM -0700, Jakub Kicinski wrote:
>> On Wed, 27 May 2020 03:19:18 +0000 Luis Chamberlain wrote:
>>> I read your patch, and granted, I will accept I was under the incorrect
>>> assumption that this can only be used by networking devices, however it
>>> the devlink approach achieves getting userspace the ability with
>>> iproute2 devlink util to query a device health, on to which we can peg
>>> firmware health. But *this* patch series is not about health status and
>>> letting users query it, its about a *critical* situation which has come up
>>> with firmware requiring me to reboot my system, and the lack of *any*
>>> infrastructure in the kernel today to inform userspace about it.
>>>
>>> So say we use netlink to report a critical health situation, how are we
>>> informing userspace with your patch series about requring a reboot?
>>
>> One of main features of netlink is pub/sub model of notifications.
>>
>> Whatever you imagine listening to your uevent can listen to
>> devlink-health notifications via devlink.
>>
>> In fact I've shown this off in the RFC patches I sent to you, see
>> the devlink mon health command being used.
>
> Yes but I looked at iputils2 devlink and seems I made an incorrect
> assumption this can only be used for a network device rather than
> a struct device.
>
> I'll take a second look.

Hello Jakub,

I'm thinking about something similar to what Luis is proposing, but in
my case I'd like to report just when the driver knows the hardware is gone
and cannot be recovered, like when this is reported:

[ 2548.851832] WARNING: CPU: 3 PID: 98 at backports-4.19.98-1/net/mac80211/util.c:2040 ieee80211_reconfig+0x98/0xb64 [mac80211]
[ 2548.856020] Hardware became unavailable during restart.

I'd like to be able to tie this into a watch-dog program to allow automatic reboot
of the system soon after this event is seen, for instance.

Could you post your devlink RFC patches somewhere public?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
