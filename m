Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAF064BFCD
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 23:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbiLMW7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 17:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236509AbiLMW7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 17:59:42 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F96C2;
        Tue, 13 Dec 2022 14:59:41 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id y4so4943143ljc.9;
        Tue, 13 Dec 2022 14:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=STFi6H+MBU8VigS8FZFWUA3ZkDfUTV68jyE1RodUQ9k=;
        b=nnvukaeMDUXHfGbsjIPmvmNUy7a7j5YVH7VnRTc86Uw9vuwJWyJ2WMHkVTnWQo5HVX
         xIoUeKixNsHX95e0QkGcdOpZAIYWm//8tD/MR7LTi2BlFi6xjWMF3SQwZrU2E+YLadMQ
         CJt/IN9/+yu+hMnIOaa7tihajEE0VhO3jLWimiJrNmIFSxxcHqR8ldE5vQeuD4BjMsti
         TGNO7KjN+U5wUOm9d05eYrZF2AHRzJuA22jX4LZ2DETok99HT9ZU5eXQLYeNKeJWnpVS
         Ew9xcS6/N0IrA4XNruIWz0Nt1wugh7cZ5QduSyJ3jF6G1TOy+5Ffsfu3+ZVhVvIHDwmP
         aRkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=STFi6H+MBU8VigS8FZFWUA3ZkDfUTV68jyE1RodUQ9k=;
        b=4uCTmNj/U9FOSTg7q9EpL+thV9J+W1PzVS9Qy2VAxcj+pmqcFvhHxLVGo6hYlYXTkM
         iZEh6wAUfPVTQNwIZaBZK30+eyaw0NHtj1+I4t4H40rAUgQzbTB8giokhqxHpGq1lbcM
         pn+iDddltsFl92mCLsceyZdNcpyBHnzyT8b69YPSuBAx9bKr5yLdEWImeoymoc9q9TPP
         vgf5UPaL9ZtDogf5PFoSELGRlx74EpvbKladEtocuH9K6LqAIiumzmJJDy5gUs1kyHSI
         uoe4GpO7ljg/JV304hUQlG4urFzQazZLEz/iQOFODNl/e8owhqErRI5WHHNBUSkL9vqD
         eu0w==
X-Gm-Message-State: ANoB5pk8otuORiDo/iFINK5s297sWjIMpwon7VM2SFiNpdnXmLT2ATuQ
        +mOhNi2TH0vFjVUhhgX+3uk=
X-Google-Smtp-Source: AA0mqf62+cbLSzoob4lgSmFNFAAzpJrxxl1oe6wVF1FNgso/5S/fbJELw27opsloyNoHcNPc2o/1Mw==
X-Received: by 2002:a05:651c:98d:b0:278:e5ce:f551 with SMTP id b13-20020a05651c098d00b00278e5cef551mr5245599ljq.10.1670972379307;
        Tue, 13 Dec 2022 14:59:39 -0800 (PST)
Received: from user-PC.. ([176.221.215.212])
        by smtp.gmail.com with ESMTPSA id bf12-20020a2eaa0c000000b002773ac59697sm436501ljb.0.2022.12.13.14.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 14:59:38 -0800 (PST)
From:   Maksim Kiselev <bigunclemax@gmail.com>
To:     bigunclemax@gmail.com
Cc:     fido_max@inbox.ru, mw@semihalf.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Subject: Locking mv88e6xxx_reg_lock twice leads deadlock for 88E6176 switch
Date:   Wed, 14 Dec 2022 01:58:55 +0300
Message-Id: <20221213225856.1506850-1-bigunclemax@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject: Locking mv88e6xxx_reg_lock twice leads deadlock for 88E6176 switch

Hello, friends.

I have a device with Marvell 88E6176 switch. 
After 'mv88e6xxx: fix speed setting for CPU/DSA ports (cc1049ccee20)'commit was applied to
mainline kernel I faced with a problem that switch driver stuck at 'mv88e6xxx_probe' function.

I made some investigations and found that 'mv88e6xxx_reg_lock' called twice from the same thread which leads to deadlock.

I added logs to 'mv88e6xxx_reg_lock' and 'mv88e6xxx_reg_unlock' functions to see what happened.

So, first lock called from mv88e6xxx_setup:

static int mv88e6xxx_setup(struct dsa_switch *ds)
{
    ...

	if (mv88e6xxx_has_pvt(chip))
		ds->max_num_bridges = MV88E6XXX_MAX_PVT_SWITCHES -
				      ds->dst->last_switch - 1;

	mv88e6xxx_reg_lock(chip);

And second lock called from mv88e6352_phylink_get_caps (only for port 4):
static void mv88e6352_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
				       struct phylink_config *config)
{
    ...

	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
				   MAC_1000FD;

	/* Port 4 supports automedia if the serdes is associated with it. */
	if (port == 4) {
        dump_stack(); // I added this to see where we came from
		mv88e6xxx_reg_lock(chip);


Here is kernel log with my debug output and call stack right before secondary lock:

[    5.801203] mv88e6085 mdio@2d24000:0c: switch 0x1760 detected: Marvell 88E6176, revision 1
[    5.950236] >>>>> (mv88e6xxx_reg_lock|797) from mv88e6xxx_mdio_read+0x54/0xfc [mv88e6xxx] thread_id: 287
[    5.952884] >>>>> (mv88e6xxx_reg_unlock|804) from mv88e6xxx_mdio_read+0x88/0xfc [mv88e6xxx] thread_id: 287
[    5.969373] >>>>> (mv88e6xxx_reg_lock|797) from mv88e6xxx_setup+0x5c/0x550 [mv88e6xxx] thread_id: 287
[    6.023785] >>>>> (mv88e6xxx_reg_lock|797) from mv88e6xxx_g1_irq_thread_work+0x28/0x124 [mv88e6xxx] thread_id: 315

[    6.069185] Backtrace: 
[    6.069206]  dump_backtrace from show_stack+0x18/0x1c
[    6.069266]  r7:f1221aa4 r6:00000004 r5:600b0013 r4:c08d684d
[    6.069279]  show_stack from dump_stack_lvl+0x48/0x54
[    6.069315]  dump_stack_lvl from dump_stack+0x14/0x1c
[    6.069351]  r5:f1221ab4 r4:c1e40040
[    6.069363]  dump_stack from mv88e6352_phylink_get_caps+0x58/0x164 [mv88e6xxx]
[    6.069645]  mv88e6352_phylink_get_caps [mv88e6xxx] from mv88e6xxx_get_caps+0x2c/0x4c [mv88e6xxx]
[    6.070106]  r7:c1ff31c0 r6:00000004 r5:c1ff31c0 r4:f1221aa4
[    6.070118]  mv88e6xxx_get_caps [mv88e6xxx] from mv88e6xxx_setup_port+0x84/0x60c [mv88e6xxx]
[    6.070575]  r7:c1ff31c0 r6:00000004 r5:c1e40040 r4:bf16e510
[    6.070588]  mv88e6xxx_setup_port [mv88e6xxx] from mv88e6xxx_setup+0x3e0/0x550 [mv88e6xxx]
[    6.071048]  r9:c1083600 r8:c1e40e04 r7:00000004 r6:c1ff31c0 r5:c1e40040 r4:bf16e510
[    6.071062]  mv88e6xxx_setup [mv88e6xxx] from dsa_register_switch+0x738/0xba8 [dsa_core]
[    6.071451]  r8:c23395c8 r7:c1ff31c0 r6:c23395c0 r5:c1ff31c0 r4:00000000
[    6.071464]  dsa_register_switch [dsa_core] from mv88e6xxx_probe+0x640/0x6a8 [mv88e6xxx]
[    6.071835]  r10:c1164000 r9:bf171a2c r8:ef7f00f8 r7:00000000 r6:00000000 r5:c1e40040
[    6.071851]  r4:c13ea000
[    6.071862]  mv88e6xxx_probe [mv88e6xxx] from mdio_probe+0x34/0x50
[    6.072133]  r10:c1164000 r9:c1e6a5b8 r8:bf173c4c r7:00000000 r6:bf173000 r5:c13ea000
[    6.072149]  r4:bf173000
[    6.072160]  mdio_probe from really_probe+0x14c/0x2b8
[    6.072206]  r5:c13ea000 r4:00000000
[    6.072218]  really_probe from __driver_probe_device+0xcc/0xe0
[    6.072260]  r7:00000039 r6:c13ea000 r5:bf173000 r4:c13ea000
[    6.072273]  __driver_probe_device from driver_probe_device+0x40/0xbc
[    6.072312]  r5:c13ea000 r4:c0cbdbc0
[    6.072324]  driver_probe_device from __driver_attach+0xf0/0x104
[    6.072367]  r7:c0c7c790 r6:bf173000 r5:c13ea000 r4:00000000
[    6.072380]  __driver_attach from bus_for_each_dev+0x70/0xb4
[    6.072434]  r7:c0c7c790 r6:c04e87e8 r5:bf173000 r4:c13ea000
[    6.072446]  bus_for_each_dev from driver_attach+0x20/0x28
[    6.072507]  r6:00000000 r5:c1e6a580 r4:bf173000
[    6.072520]  driver_attach from bus_add_driver+0xbc/0x1cc
[    6.072574]  bus_add_driver from driver_register+0xb4/0xfc
[    6.072633]  r9:bf102000 r8:bf173c4c r7:f1221ea0 r6:c1ff8800 r5:bf173c40 r4:bf173000
[    6.072647]  driver_register from mdio_driver_register+0x34/0x68
[    6.072696]  r5:bf173c40 r4:bf173000
[    6.072708]  mdio_driver_register from mdio_module_init+0x14/0x1000 [mv88e6xxx]
[    6.072976]  r5:bf173c40 r4:c0c88000
[    6.072988]  mdio_module_init [mv88e6xxx] from do_one_initcall+0x6c/0x1d8
[    6.073239]  do_one_initcall from do_init_module+0x48/0x1c4
[    6.073292]  r10:0000000c r9:00000000 r8:bf173c4c r7:f1221ea0 r6:c1ff8800 r5:bf173c40
[    6.073308]  r4:bf173c40
[    6.073319]  do_init_module from load_module+0x1558/0x1698
[    6.073362]  r6:00000000 r5:bf173c40 r4:f1221f28
[    6.073374]  load_module from sys_finit_module+0xdc/0xec
[    6.073423]  r10:0000017b r9:c1164000 r8:c020029c r7:0000017b r6:0000000f r5:b6edbee8
[    6.073439]  r4:00000000
[    6.073450]  sys_finit_module from ret_fast_syscall+0x0/0x4c
[    6.073485] Exception stack(0xf1221fa8 to 0xf1221ff0)
[    6.073515] 1fa0:                   00020000 00000000 0000000f b6edbee8 00000000 004a3420
[    6.073544] 1fc0: 00020000 00000000 00000000 0000017b 004a96a8 beb9292c 00000000 004a3420
[    6.073567] 1fe0: beb92820 beb92810 b6ed5294 b6b98c30
[    6.073589]  r6:00000000 r5:00000000 r4:00020000

[    6.073658] >>>>> (mv88e6xxx_reg_lock|797) from mv88e6352_phylink_get_caps+0x60/0x164 [mv88e6xxx] thread_id: 287
