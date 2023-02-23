Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C89A6A0D7D
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 17:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbjBWQBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 11:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbjBWQB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 11:01:28 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C875193F;
        Thu, 23 Feb 2023 08:01:21 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pVE23-0007wG-N0; Thu, 23 Feb 2023 17:01:19 +0100
Message-ID: <c7a7e21a-0eac-8e84-aa8e-59ba4116e6af@leemhuis.info>
Date:   Thu, 23 Feb 2023 17:01:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US, de-DE
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     ath11k <ath11k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>,
        mani@kernel.org
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: [regression] Bug 217070 - ath11k: QCA6390: Regression on 6.2-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1677168082;ee9f2f80;
X-HE-SMSGID: 1pVE23-0007wG-N0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

I noticed a regression report in bugzilla.kernel.org. As many (most?)
kernel developer don't keep an eye on it, I decided to forward it by
mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=217070 :

>  mani@kernel.org 2023-02-22 08:43:15 UTC
> 
> Hi,
> 
> With the firmware from linux-firmware and vendor SDK, ath11k used to
> work on kernel v5.19-rc6 but it is now failing on kernel v6.2-rc1.
> 
> dmesg of the failure with firmware from linux-firmware:
> 
> [   33.224148] ath11k_pci 0000:01:00.0: Adding to iommu group 1
> [   33.238000] ath11k_pci 0000:01:00.0: BAR 0: assigned [mem 0x40300000-0x403fffff 64bit]
> [   33.238260] ath11k_pci 0000:01:00.0: enabling device (0140 -> 0142)
> [   33.275898] ath11k_pci 0000:01:00.0: MSI vectors: 32
> [   33.276053] ath11k_pci 0000:01:00.0: qca6390 hw2.0
> [   35.901819] ath11k_pci 0000:01:00.0: chip_id 0x0 chip_family 0xb board_id 0xff soc_id 0xffffffff
> [   35.902011] ath11k_pci 0000:01:00.0: fw_version 0x10121492 fw_build_timestamp 2021-11-04 11:23 fw_build_id 
> [   38.134029] ath11k_pci 0000:01:00.0: failed to receive control response completion, polling..
> [   39.173898] ath11k_pci 0000:01:00.0: ctl_resp never came in (-110)
> [   39.174022] ath11k_pci 0000:01:00.0: failed to connect to HTC: -110
> [   39.280618] ath11k_pci 0000:01:00.0: failed to start core: -110
> 
> dmesg of the failure with firmware from vendor SDK:
> 
> [   33.294291] ath11k_pci 0000:01:00.0: Adding to iommu group 1
> [   33.295671] ath11k_pci 0000:01:00.0: BAR 0: assigned [mem 0x40300000-0x403fffff 64bit]
> [   33.299223] ath11k_pci 0000:01:00.0: enabling device (0140 -> 0142)
> [   33.338562] ath11k_pci 0000:01:00.0: MSI vectors: 32
> [   33.338711] ath11k_pci 0000:01:00.0: qca6390 hw2.0
> [   38.506850] ath11k_pci 0000:01:00.0: ignore reset dev flags 0x8000
> [   38.507181] ath11k_pci 0000:01:00.0: failed to power up mhi: -110
> [   38.520546] ath11k_pci 0000:01:00.0: failed to start mhi: -110
> [   38.520665] ath11k_pci 0000:01:00.0: failed to power up :-110
> [   38.554297] ath11k_pci 0000:01:00.0: failed to create soc core: -110
> [   38.554424] ath11k_pci 0000:01:00.0: failed to init core: -110
> [   38.888539] ath11k_pci: probe of 0000:01:00.0 failed with error -110
> 
> [tag] [reply] [−]
> Private
> Comment 1 mani@kernel.org 2023-02-22 08:45:27 UTC
> 
> Host platform is Thundercomm T55 board based on Qualcomm SDX55 SoC (ARM32).

See the ticket for more details.


[TLDR for the rest of this mail: I'm adding this report to the list of
tracked Linux kernel regressions; the text you find below is based on a
few templates paragraphs you might have encountered already in similar
form.]

BTW, let me use this mail to also add the report to the list of tracked
regressions to ensure it's doesn't fall through the cracks:

#regzbot introduced: v5.19-rc6..v6.2-rc1
https://bugzilla.kernel.org/show_bug.cgi?id=217070
#regzbot title: net: wireless: ath11k: QCA6390
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (e.g. the buzgzilla ticket and maybe this mail as well, if
this thread sees some discussion). See page linked in footer for details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
