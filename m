Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2613D5A26B1
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbiHZLPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbiHZLO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:14:58 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D641EEF1;
        Fri, 26 Aug 2022 04:14:54 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oRXIa-0004eZ-2C; Fri, 26 Aug 2022 13:14:52 +0200
Message-ID: <31cceaa5-2684-1aa8-61c6-c1be2d563bb0@leemhuis.info>
Date:   Fri, 26 Aug 2022 13:14:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Content-Language: en-US
Cc:     Vorpal <kernelbugs@vorpal.se>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Kalle Valo <kvalo@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     Gregory Greenman <gregory.greenman@intel.com>
Subject: [regression] Bug 216397 - Kernel 5.19 with NetworkManager and iwd:
 Wifi reconnect on resume is broken
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1661512494;f88e6eba;
X-HE-SMSGID: 1oRXIa-0004eZ-2C
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

I noticed a regression report in bugzilla.kernel.org that afaics nobody
acted upon since it was reported. That's why I decided to forward it by
mail to those that afaics should handle this. I was a bit unsure whom to
sent this to and in the end went with "iwlwifi maintainer, with wireless
and MAC80211 maintainer in CC".

To quote from https://bugzilla.kernel.org/show_bug.cgi?id=216397 :

>  Vorpal 2022-08-22 16:35:21 UTC
> 
> Created attachment 301630 [details]
> Relevant journalctl.txt
> 
> After upgrading to kernel 5.19 (Arch Linux kernel, which is minimally modified, but I tested a few alternative kernels too, such as zen), wifi reconnect on resume is broken when using NetworkManager + iwd.
> 
> When downgrading to 5.18 or linux-lts (5.15.62), auto reconnect starts working again.
> 
> When switching NetworkManager to use wpa_supplicant auto reconnect starts working on newer kernel again.
> 
> Manual reconnection works using iwd+new kernel.
> 
> Hardware:
> * Lenovo Thinkpad T480 with "Intel Corporation Wireless 8265 / 8275 (rev 78)" (according to lspci).
> * Access point is a Asus AC-68U running the Asus Merlin Firmware.
> 
> I have another laptop, with Atheros wifi and the same Arch Linux with NM + iwd setup. It does not suffer from this problem. This appears to be specific to this hardware.
> 
> I have attached the relevant fragment of dmesg/journalctl (MAC addresses and SSID changed for privacy).
> 
> Additional info:
> * Arch Linux package version(s):
> - linux-5.19.3.arch1-1 (also affects 5.19.2 at least)
> - networkmanager-1.38.4-1
> - iwd-1.29-1 (broken)
> - wpa_supplicant-2:2.10-5 (works)
> 
> Steps to reproduce:
> 1. Suspend computer with iwlwifi using NetworkManager + iwd
> 2. After computer has gone to sleep, wake it up
> 3. Observe failure to reconnect to wifi network that was connected before.
> 
> I do not know if this is a kernel bug, IWD bug or Network Manager bug. Perhaps it is just how they interact.
> 
> Distro bug report: https://bugs.archlinux.org/task/75670

See the ticket for details and further comments.

Please look into the issue if you're among the main recipients of this
mail (and not just CCed). I hope I picked the right people to sent this
to, if not just let everyone know (and apologies for getting it wrong!).

Anyway, to ensure this is not forgotten lets get this tracked by the the
Linux kernel regression tracking bot:

#regzbot introduced: v5.18..v5.19
https://bugzilla.kernel.org/show_bug.cgi?id=216397
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply -- ideally with also
telling regzbot about it, as explained here:
https://linux-regtracking.leemhuis.info/tracked-regression/

Reminder for developers: When fixing the issue, add 'Link:' tags
pointing to the report in bugzilla, as the kernel's documentation calls
for; above page explains why this is important for tracked regressions.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
