Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D484D8A60
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 18:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237288AbiCNRHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 13:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiCNRHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 13:07:02 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365853D1E0
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 10:05:52 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n15so14118481plh.2
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 10:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=IfKu246HPWJWqkCQznegkb7XFAqlce5OC+kFdjAQt3E=;
        b=Q5Ia7aiuxulJoNoOS5aPL3ORCwoI5XZxVbrVWIPm3W+lPE7RnthJ1trCvUNPBETD00
         RmflYXXr9R0CrDgR3DJTc6HiQ26qALdQacnef/qSy/QGlb5EMkmvHBDmK6npHdMep+D0
         4Ib59pYcUuoIl3y6UdZZgZpYJ5V1LuisvIn7xAorRw2ti0AMoKm0ARTehObwVyS3KY+b
         oj2FgPscPEB4suqy+XvAY/urhGXSkxBgJsb/HZjP+ozBdf+AKoSQ5XgillX8ujkZtyga
         eC9tS9JUdvpzO1zmv8ickxHQ+vwHN1jiluc2Jx+qI+CW/Poqzt/2HXRM0n8kETQm97dt
         fE1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=IfKu246HPWJWqkCQznegkb7XFAqlce5OC+kFdjAQt3E=;
        b=GaivnmeKj1EcjfeumStT6n9NZD8QPgIDpxyInYOn4HRBRM0IaCwSNmg1QiVetWyBC8
         Dgu4ntZ5xxSGOd4FPkXSvBXVJ/PRCM8NGGkXd68W4igrfI51Oa0t90qSIXx53TOoVOTd
         k/NAE/6uA6NbEviG/D+5Pcn6/DlBiMFc6cd6l1LM04ETgMHczZw9tSD/CZXMqKFTCMFd
         782mwjiHmVOKe4zvuO8M4+dylD2p2f93sYZAxjWPt1rN6Hzf/KwDSjtq30LvEXLudrWS
         XsOeopZrdYB8iFZBTolNmCiTRU+ibqtG9jB1EgjPn7i2yxF75fdA4i9eIdMVItv61x85
         ap/g==
X-Gm-Message-State: AOAM532lrqQPA6TPxUsv/zP5iE6Z1in4eATOVsp+hu7PS4rs79we/Joc
        kjf8lkWy/upk0IXb0xiakKioE2HqYS7nEA==
X-Google-Smtp-Source: ABdhPJx4mksN1g+lzPZfEPI7VA6HFbbFR9MiOs2oN1u74gVd76f4VfdlKYv0wleaNpu/X27UMb6tMw==
X-Received: by 2002:a17:90b:1bc5:b0:1bf:1c96:66ac with SMTP id oa5-20020a17090b1bc500b001bf1c9666acmr132323pjb.167.1647277551634;
        Mon, 14 Mar 2022 10:05:51 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id c34-20020a630d22000000b0034cb89e4695sm16968124pgl.28.2022.03.14.10.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 10:05:51 -0700 (PDT)
Date:   Mon, 14 Mar 2022 10:05:48 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jason@zx2c4.com
Cc:     wireguard@lists.zx2c4.com, netdev@vger.kernel.org
Subject: Fw: [Bug 215682] New: Long iperf test of wireguard interface causes
 kernel panic
Message-ID: <20220314100548.35026ad0@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 14 Mar 2022 16:51:08 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215682] New: Long iperf test of wireguard interface causes kernel panic


https://bugzilla.kernel.org/show_bug.cgi?id=215682

            Bug ID: 215682
           Summary: Long iperf test of wireguard interface causes kernel
                    panic
           Product: Networking
           Version: 2.5
    Kernel Version: 5.15.27
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: alexey.kv@gmail.com
        Regression: No

I have setup of two Rock64 SBC which I connected via lan and created a
wireguard interface on it to do some benchmarking with iperf3. After long run
(~3 days) on one instance following kernel panic was observed:

[266706.637097] Kernel panic - not syncing: stack-protector: Kernel stack is
corrupted in: netif_receive_skb_list_internal+0x2b0/0x2b0       
[266706.638171] CPU: 3 PID: 9861 Comm: kworker/3:0 Tainted: G         C       
5.15.27-rockchip64 #trunk
[266706.638999] Hardware name: Pine64 Rock64 (DT)
[266706.639406] Workqueue: wg-crypt-wg0 wg_packet_decrypt_worker [wireguard]
[266706.640084] Call trace:
[266706.640316]  dump_backtrace+0x0/0x200
[266706.640686]  show_stack+0x18/0x28
[266706.640997]  dump_stack_lvl+0x68/0x84
[266706.641348]  dump_stack+0x18/0x34
[266706.641661]  panic+0x164/0x35c
[266706.641955]  __stack_chk_fail+0x3c/0x40
[266706.642309]  netif_receive_skb_list+0x0/0x158
[266706.642711]  gro_normal_list.part.159+0x20/0x40
[266706.643129]  napi_complete_done+0xc0/0x1e8
[266706.643512]  wg_packet_rx_poll+0x45c/0x8c0 [wireguard]
[266706.644000]  __napi_poll+0x38/0x230
[266706.644324]  net_rx_action+0x284/0x2c8
[266706.644675]  _stext+0x160/0x3f8
[266706.644986]  do_softirq+0xa8/0xb8
[266706.645297]  __local_bh_enable_ip+0xac/0xb8
[266706.645682]  _raw_spin_unlock_bh+0x34/0x60
[266706.646059]  wg_packet_decrypt_worker+0x50/0x1a8 [wireguard]
[266706.646589]  process_one_work+0x20c/0x4c8
[266706.646961]  worker_thread+0x48/0x478
[266706.647300]  kthread+0x138/0x150
[266706.647599]  ret_from_fork+0x10/0x20
[266706.647931] SMP: stopping secondary CPUs
[266706.648297] Kernel Offset: disabled
[266706.648615] CPU features: 0x00001001,00000846
[266706.649009] Memory Limit: none
[266706.649293] ---[ end Kernel panic - not syncing: stack-protector: Kernel
stack is corrupted in: netif_receive_skb_list_internal+0x2b0/0x2b0 ]---

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
