Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9B161D9DD
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 13:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiKEMXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 08:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKEMXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 08:23:37 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4605FCDC
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 05:23:35 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id a11-20020a05600c2d4b00b003cf6f5fd9f1so4630548wmg.2
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 05:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uK1nzf3tTKnihuX4kVsAOEZsoAhrZI2sFhUdscDrplg=;
        b=ABeJh2tKwmBHOvsAAv3GplqJ4DlE/RcIOTN6laxkeTalh1FNRu9BSNBB6Af/XoyHdP
         WLK02Y9rJS7yJI2FdsBxpkLtL/kF90S214GIe9FUN3aOIy0ZLhaX6LDEPMyd7Exw7XfY
         NfmGDk/1b0G+cY5toGI4p1lXCfczObJbABB9iGyUtq21AESEeVpK/ep1EST4Tnstb/XO
         7LUL262vLmR4DhZMSWmIfXWiR+x7MP/OnbD+h+OMFhIEm89lK0/6CWa3WtVrDucZnYQv
         4IHi2BFwteLYzDgUQye3at6xQxOSKc8s/fVTMGCLunVI7rV/3YuXkAk/HD4TdljCKeZ4
         yT3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uK1nzf3tTKnihuX4kVsAOEZsoAhrZI2sFhUdscDrplg=;
        b=lIt07BUWN95ul+MeMF63oSgjLHlqi1vgRfRPowhgpyN2Jov8aT3k0PG7IbZuGc81qY
         n04IAmPRZQ7UDrq0ctzoJt9Z+ajCfwelEOP8AfrFjbml4qKDrrmoVbmhylfQLZtZpdEb
         LjkDGNGgp7yzZ7LJBTjw7LsCMezycWFy6urPU/ZoeFJwZEZxOGXTLbhLMCg+bTDWvLsX
         g8LyHrwhRFMRDXAQwNF6+LaCwg32zNkVFi2UnhceyWk4jdSBYceLMOWpLBGibF+HkWeH
         BupMs4jcSfUCdz2AY7j+kb99pivQpGgniYXZqFxcilyZb23v0lNz9x+KA1YXVDKrj6lS
         icxA==
X-Gm-Message-State: ACrzQf1GH3ZkqYQuVSFJwDL02bwrffIFuXFHgQBAGmWrHtSUXUeUfw18
        W4HB48sRp+ww6T8vztwctIr8Y9iBcOA7tw==
X-Google-Smtp-Source: AMsMyM4CVz9bE8MXciEH5u+H/tH3g8JkXEl4G1sv04ZvqeH7G9S9E3HbQtE4WORAF62fDiWHOXP5Sg==
X-Received: by 2002:a05:600c:3510:b0:3cf:8443:e8c with SMTP id h16-20020a05600c351000b003cf84430e8cmr15066176wmq.164.1667651013764;
        Sat, 05 Nov 2022 05:23:33 -0700 (PDT)
Received: from zbpt9gl1 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id b18-20020a056000055200b00236545edc91sm1970600wrf.76.2022.11.05.05.23.32
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Nov 2022 05:23:33 -0700 (PDT)
From:   <piergiorgio.beruto@gmail.com>
To:     <netdev@vger.kernel.org>
Subject: Potential issue with PHYs connected to the same MDIO bus and different MACs
Date:   Sat, 5 Nov 2022 13:23:36 +0100
Message-ID: <022c01d8f111$6e6e2580$4b4a7080$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdjxEWqoGmCIQqTJTDqWWBaf51RC7Q==
Content-Language: en-us
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
I am struggling with a problem and I would kindly ask if someone could shed
some light on this potential issue.

I'm using Linux 5.19.12 on the Altera socfpga ARMv7 platform (custom board).
My HW setup comprises three identical Ethernet PHYs, all attached to the
same MDIO bus belonging to one of the stmmac MACs embedded in the SoC.
Using the proper DTS configuration I was able to connect two PHYs each to
its own stmmac (the SoC has two embedded MACs), sharing the same MDIO bus.
Additionally, I'm able to communicate via MDIO with all three PHYs using the
proper ioctls, therefore I assume my HW is OK.

Now, to use the third PHY I added a MAC IP in the FPGA (Altera Triple Speed
MAC) for which a Linux driver already exists (altera_tse). However, unless I
connect the PHY to the dedicated TSE mdio bus (which requires HW
modifications), I get an error saying that the driver could not connect to
the PHY. I assumed this could be a conflict between the phylink interface
(used by STMMAC) and the "plain" PHY of APIs used by the TSE driver (which
seems a bit old).

I then decided to use a different MAC IP for which I'm writing a driver
using the phylink interface.
I got stuck at a point where the function "phy_attach_direct" in
phy_device.c gives an Oops (see log below).

Doing some debug, it seems that the NULL pointer comes from
dev->dev.parent->driver.
The "parent" pointer seems to reference the SoC BUS which the MAC IP belongs
to.

Any clue of what I might be doing wrong? I also think it is possible that
the problem I saw with the altera_tse driver could have something in common
with this? The MAC would be located inside the bus as well.

My DTS looks like this (just listing the relevant parts):

{
   SoC {
        gmac1 {
           // This is the stmmac which has all the PHYs attached.
           phy-handle=<&phy1>
            ...
           mdio {
              phy1 {
                 ...
              }
            
              phy2 {
                 ...
              }

              phy3 {
                 .
              }
         } // mdio
      } // gmac1

      gmac0 {
         phy-handle=<&phy2>
         ...
      }

      bridge {
          ...
         myMAC {
            phy-handle=<&phy3>
            ...
         }
      }
   } // Soc
}

One more information: I can clearly see from the log my PHYs being scanned
and enumerated. So again, I don't think the problem relates to the PHYs.

This is the Oops log.

8<--- cut here ---
[ 36.823689] Unable to handle kernel NULL pointer dereference at virtual
address 00000008
[ 36.832018] [00000008] *pgd=00000000
[ 36.835783] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[ 36.841090] Modules linked in: onsemi_tmac(O)
[ 36.845452] CPU: 0 PID: 240 Comm: ifconfig Tainted: G O
5.19.12-centurion3-1.0.3.0 #10
[ 36.854646] Hardware name: Altera SOCFPGA
[ 36.858644] PC is at phy_attach_direct+0x98/0x328
[ 36.863357] LR is at phy_attach_direct+0x8c/0x328
[ 36.868057] pc : [<c051f218>] lr : [<c051f20c>] psr: 600d0013
[ 36.874304] sp : d0eedd58 ip : 00000000 fp : d0eede78
[ 36.879513] r10: c162e000 r9 : 00000000 r8 : 00000000
[ 36.884722] r7 : 00000002 r6 : c0d58520 r5 : cfdf3730 r4 : c1752000
[ 36.891230] r3 : 00000000 r2 : 0f5a3000 r1 : 00000000 r0 : c06e186e
[ 36.897738] Flags: nZCv IRQs on FIQs on Mode SVC_32 ISA ARM Segment user
[ 36.904855] Control: 10c5387d Table: 015d404a DAC: 00000055
[ 36.910583] Register r0 information: non-slab/vmalloc memory
[ 36.916238] Register r1 information: NULL pointer
[ 36.920933] Register r2 information: non-paged memory
[ 36.925974] Register r3 information: NULL pointer
[ 36.930667] Register r4 information: slab kmalloc-1k start c1752000 pointer
offset 0 size 1024
[ 36.939278] Register r5 information: non-slab/vmalloc memory
[ 36.944925] Register r6 information: slab kmalloc-512 start c0d58400
pointer offset 288 size 512
[ 36.953705] Register r7 information: non-paged memory
[ 36.958746] Register r8 information: NULL pointer
[ 36.963440] Register r9 information: NULL pointer
[ 36.968133] Register r10 information: slab kmalloc-4k start c162e000
pointer offset 0 size 4096
[ 36.976827] Register r11 information: 2-page vmalloc region starting at
0xd0eec000 allocated at kernel_clone+0x8c/0x1bc
[ 36.987595] Register r12 information: NULL pointer
[ 36.992376] Process ifconfig (pid: 240, stack limit = 0xa94bafcf)
[ 36.998455] Stack: (0xd0eedd58 to 0xd0eee000)
[ 37.002807] dd40: c0f4d300 cfdf3730
[ 37.010964] dd60: c1752000 00000000 bf001200 00000000 00008914 c039d9d0
c1633800 00000000
[ 37.019120] dd80: 00000000 c1633824 bf001200 bf000378 c1633800 c1633800
00000003 c1633800
[ 37.027276] dda0: 00000000 c044ec54 c1633800 00000000 c1633800 00000000
c1633800 00001043
[ 37.035431] ddc0: 00000000 00001002 00000041 c044ef58 c1633800 00001043
00000000 00008914
[ 37.043578] dde0: c1633800 d0eede68 00000000 00001002 c1730a0c c044ef80
00000000 d0eede68
[ 37.051734] de00: c1633800 c1730a00 c1730a0c c04db608 000000bf 00000100
ffffffff 00000014
[ 37.059890] de20: d0eede68 d0eede68 00000003 004c1043 004cb0c8 bea1be94
b6f05d28 65cdff6b
[ 37.068045] de40: 00000000 00008914 bea1bca4 bea1bca4 00008914 00000003
c168e4c0 c166a6c0
[ 37.076200] de60: 00000000 c04ddd7c 31687465 00000000 00000000 00000000
004c1043 004cb0c8
[ 37.084356] de80: bea1be94 b6f05d28 c0943580 c04453c0 00008913 d0eedee4
c0943580 c0445448
[ 37.092511] dea0: 00008913 bea1bca4 00000003 c168e4c0 bea1bca4 00000020
00000000 65cdff6b
[ 37.100668] dec0: 00000000 c12ded00 00008914 c04301a0 d0eededf c168e4c0
00000254 01000080
[ 37.108823] dee0: 004cb794 31687465 00000000 00000000 00000000 004c1002
004cb0c8 bea1be94
[ 37.116979] df00: b6f05d28 65cdff6b c12ded00 c166a6c0 bea1bca4 c01e0268
c12ded00 c01e0c00
[ 37.125134] df20: 00000000 c15c85fc c1744ffc 00000000 c0100218 d0eedfb0
b6d72340 c168e4c0
[ 37.133290] df40: c1745000 c01544fc d0eedfb0 c010bb90 00000000 00000003
c092d63c 00000004
[ 37.141445] df60: 00000003 00000007 b6d72340 d0eedfb0 c0908fa0 c082f044
bea1be94 65cdff6b
[ 37.149601] df80: b6f06000 004d4c53 bea1bca4 004ff078 00000036 c0100218
c168e4c0 00000036
[ 37.157756] dfa0: 00000000 c0100040 004d4c53 bea1bca4 00000003 00008914
bea1bca4 bea1bc50
[ 37.165911] dfc0: 004d4c53 bea1bca4 004ff078 00000036 bea1be8c bea1bf7a
00000015 00000000
[ 37.174065] dfe0: 005001f0 bea1bc38 00437484 b6db7d74 200a0010 00000003
00000000 00000000
[ 37.182221] phy_attach_direct from phylink_fwnode_phy_connect+0xa4/0xdc
[ 37.188932] phylink_fwnode_phy_connect from tmac_open+0x44/0x9c
[onsemi_tmac]
[ 37.196160] tmac_open [onsemi_tmac] from __dev_open+0x110/0x128
[ 37.202180] __dev_open from __dev_change_flags+0x168/0x17c
[ 37.207758] __dev_change_flags from dev_change_flags+0x14/0x44
[ 37.213680] dev_change_flags from devinet_ioctl+0x2ac/0x5fc
[ 37.219349] devinet_ioctl from inet_ioctl+0x1ec/0x214
[ 37.224494] inet_ioctl from sock_ioctl+0x14c/0x3c4
[ 37.229383] sock_ioctl from vfs_ioctl+0x20/0x38
[ 37.234013] vfs_ioctl from sys_ioctl+0x24c/0x840
[ 37.238727] sys_ioctl from ret_fast_syscall+0x0/0x4c
[ 37.243782] Exception stack(0xd0eedfa8 to 0xd0eedff0)
[ 37.248830] dfa0: 004d4c53 bea1bca4 00000003 00008914 bea1bca4 bea1bc50
[ 37.256987] dfc0: 004d4c53 bea1bca4 004ff078 00000036 bea1be8c bea1bf7a
00000015 00000000
[ 37.265140] dfe0: 005001f0 bea1bc38 00437484 b6db7d74
[ 37.270186] Code: ebfff67a e5963314 e59f0264 e5933038 (e5931008)
[ 37.281284] ---[ end trace 0000000000000000 ]---

Thank you in advance for any help you could provide!

Kind Regards,
Piergiorgio


