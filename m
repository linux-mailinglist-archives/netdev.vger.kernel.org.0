Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FACB6B6193
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 23:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjCKWuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 17:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCKWuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 17:50:02 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302384DBEE;
        Sat, 11 Mar 2023 14:49:56 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p26so5624056wmc.4;
        Sat, 11 Mar 2023 14:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678574994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bkV0Ptjy0Dz5QJ7EV3y7DvnwCVLG8sUOZv9fnCXhrDw=;
        b=VAd7nxnhdlyArvCJLh+mlWIPSG207Zb0OgXFR7h5DpmcFz1428cqswRdkL5/qJOoPj
         E8/T8SBvWllDnAN05hoJ30xU03PXA7e0dUImtsZVvbC6v4ggQnUMo3LukMWePxNFXlFc
         5mL+PY5h9rUA0IB87YZLJnDFOf9PdJJUuMtY5DCBowUktH7G8kEsQvSy5F34B3NeXTax
         /TKV2qgJqZv4lhIthesn4ZvC9cd+/0oEeyaBPfsqukDvFFPrmCjZSvy0cxwbNFtefeB+
         N/2PqWT5Auc/k2/FHiLpOHhexGjP+6SsLvTvyRIc/wc7I6NQhpUCNX6WYVen/5C1hc5p
         HoXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678574994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bkV0Ptjy0Dz5QJ7EV3y7DvnwCVLG8sUOZv9fnCXhrDw=;
        b=f+u264s5fzcSCXxdVZishAojU7gNcmFZsW5oakQISqyoRsy9tXTnQTktMmOnmwJoST
         +6GMMoWpLrkmpd0ht1zfRsooAlTYJr59RjnsMIF3MObn9rUvlGd3Wtenib37L0GW+wtB
         7oLa5nXiSBB51VdIHDvf8ucKWfC71jxfdVn3TCHuKao4MCkc9zAZxyXFzKWJB38TC4H4
         ksk3YwfmglU7CJy0C2m8mPdNcUBKnSg29/dCtkzX1uICZensmLLl1cZPlXT+a8iqYFJ9
         nTIEwCsqy5letRzemkXKNWImWNpTspor5+uIpfOHpZzSijQf4dPouYnCe71vHNjBPgDP
         mqDw==
X-Gm-Message-State: AO0yUKXHn1/A27HUB1p2IRn/W0JTQTgMBatBeB+sbrN6Sn+2VEfYXEls
        tzXdnBif3tPIIrlWZUmjafg=
X-Google-Smtp-Source: AK7set+khla00mTGywXTluZdN0QsuonjZNGi9YH93ube7yMO+7vne4BxVAPDq1ffG5YK9kxOmwvNFQ==
X-Received: by 2002:a05:600c:4709:b0:3eb:3998:36f1 with SMTP id v9-20020a05600c470900b003eb399836f1mr6684421wmo.41.1678574994198;
        Sat, 11 Mar 2023 14:49:54 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id q11-20020a05600c46cb00b003ebf73acf9asm4895779wmo.3.2023.03.11.14.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 14:49:53 -0800 (PST)
Date:   Sun, 12 Mar 2023 00:49:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: dsa: mv88e6xxx: move call to
 mv88e6xxx_mdios_register()
Message-ID: <20230311224951.kqcihlralwehfvaj@skbuf>
References: <20230311203132.156467-1-klaus.kudielka@gmail.com>
 <20230311203132.156467-3-klaus.kudielka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311203132.156467-3-klaus.kudielka@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 09:31:31PM +0100, Klaus Kudielka wrote:
> Call the rather expensive mv88e6xxx_mdios_register() at the beginning of
> mv88e6xxx_setup(). This avoids the double call via mv88e6xxx_probe()
> during boot.
> 
> For symmetry, call mv88e6xxx_mdios_unregister() at the end of
> mv88e6xxx_teardown().
> 
> Link: https://lore.kernel.org/lkml/449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com/
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
> ---

While testing this, I've noticed the following behavior change:

Before:

[root@mox:~] # echo d0032004.mdio-mii:10 > /sys/bus/mdio_bus/drivers/mv88e6085/unbind
[   37.721017] mvneta d0040000.ethernet eth1: Link is Down
[   37.753726] mv88e6085 d0032004.mdio-mii:10: Link is Down
[   37.820017] mvneta d0040000.ethernet eth1: configuring for inband/2500base-x link mode
[   37.832283] br-lan: port 15(lan9) entered disabled state
[   37.839832] mv88e6085 d0032004.mdio-mii:11 lan9 (unregistering): left allmulticast mode
[   37.848312] mv88e6085 d0032004.mdio-mii:11 lan9 (unregistering): left promiscuous mode
[   37.857217] br-lan: port 15(lan9) entered disabled state
[   37.980930] br-lan: port 4(lan10) entered disabled state
[   37.990154] mv88e6085 d0032004.mdio-mii:11 lan10 (unregistering): left allmulticast mode
[   37.999789] mv88e6085 d0032004.mdio-mii:11 lan10 (unregistering): left promiscuous mode
[   38.009964] br-lan: port 4(lan10) entered disabled state
[   38.074450] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control off
[   38.145795] br-lan: port 9(lan11) entered disabled state
[   38.154846] mv88e6085 d0032004.mdio-mii:11 lan11 (unregistering): left allmulticast mode
[   38.163108] mv88e6085 d0032004.mdio-mii:11 lan11 (unregistering): left promiscuous mode
[   38.174113] br-lan: port 9(lan11) entered disabled state
[   38.295503] br-lan: port 8(lan12) entered disabled state
[   38.302618] mv88e6085 d0032004.mdio-mii:11 lan12 (unregistering): left allmulticast mode
[   38.311413] mv88e6085 d0032004.mdio-mii:11 lan12 (unregistering): left promiscuous mode
[   38.313492] mvneta d0040000.ethernet eth1: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   38.320112] br-lan: port 8(lan12) entered disabled state
[   38.447383] br-lan: port 11(lan13) entered disabled state
[   38.455120] mv88e6085 d0032004.mdio-mii:11 lan13 (unregistering): left allmulticast mode
[   38.463506] mv88e6085 d0032004.mdio-mii:11 lan13 (unregistering): left promiscuous mode
[   38.471844] br-lan: port 11(lan13) entered disabled state
[   38.594434] br-lan: port 7(lan14) entered disabled state
[   38.603800] mv88e6085 d0032004.mdio-mii:11 lan14 (unregistering): left allmulticast mode
[   38.612364] mv88e6085 d0032004.mdio-mii:11 lan14 (unregistering): left promiscuous mode
[   38.623454] br-lan: port 7(lan14) entered disabled state
[   38.768376] br-lan: port 12(lan15) entered disabled state
[   38.777887] mv88e6085 d0032004.mdio-mii:11 lan15 (unregistering): left allmulticast mode
[   38.786217] mv88e6085 d0032004.mdio-mii:11 lan15 (unregistering): left promiscuous mode
[   38.797857] br-lan: port 12(lan15) entered disabled state
[   38.917267] br-lan: port 13(lan16) entered disabled state
[   38.925746] mv88e6085 d0032004.mdio-mii:11 lan16 (unregistering): left allmulticast mode
[   38.934446] mv88e6085 d0032004.mdio-mii:11 lan16 (unregistering): left promiscuous mode
[   38.945312] br-lan: port 13(lan16) entered disabled state
[   39.069639] br-lan: port 14(lan17) entered disabled state
[   39.081410] mv88e6085 d0032004.mdio-mii:12 lan17 (unregistering): left allmulticast mode
[   39.089837] mv88e6085 d0032004.mdio-mii:12 lan17 (unregistering): left promiscuous mode
[   39.100781] br-lan: port 14(lan17) entered disabled state
[   39.223137] br-lan: port 10(lan18) entered disabled state
[   39.233085] mv88e6085 d0032004.mdio-mii:12 lan18 (unregistering): left allmulticast mode
[   39.241622] mv88e6085 d0032004.mdio-mii:12 lan18 (unregistering): left promiscuous mode
[   39.254700] br-lan: port 10(lan18) entered disabled state
[   39.387595] br-lan: port 16(lan19) entered disabled state
[   39.397380] mv88e6085 d0032004.mdio-mii:12 lan19 (unregistering): left allmulticast mode
[   39.405610] mv88e6085 d0032004.mdio-mii:12 lan19 (unregistering): left promiscuous mode
[   39.414477] br-lan: port 16(lan19) entered disabled state
[   39.553161] br-lan: port 19(lan20) entered disabled state
[   39.563735] mv88e6085 d0032004.mdio-mii:12 lan20 (unregistering): left allmulticast mode
[   39.572041] mv88e6085 d0032004.mdio-mii:12 lan20 (unregistering): left promiscuous mode
[   39.583348] br-lan: port 19(lan20) entered disabled state
[   39.729103] br-lan: port 21(lan21) entered disabled state
[   39.740827] mv88e6085 d0032004.mdio-mii:12 lan21 (unregistering): left allmulticast mode
[   39.749034] mv88e6085 d0032004.mdio-mii:12 lan21 (unregistering): left promiscuous mode
[   39.761613] br-lan: port 21(lan21) entered disabled state
[   39.899226] br-lan: port 22(lan22) entered disabled state
[   39.911133] mv88e6085 d0032004.mdio-mii:12 lan22 (unregistering): left allmulticast mode
[   39.919496] mv88e6085 d0032004.mdio-mii:12 lan22 (unregistering): left promiscuous mode
[   39.933251] br-lan: port 22(lan22) entered disabled state
[   40.058741] br-lan: port 17(lan23) entered disabled state
[   40.071843] mv88e6085 d0032004.mdio-mii:12 lan23 (unregistering): left allmulticast mode
[   40.080206] mv88e6085 d0032004.mdio-mii:12 lan23 (unregistering): left promiscuous mode
[   40.089036] br-lan: port 17(lan23) entered disabled state
[   40.208448] br-lan: port 20(lan24) entered disabled state
[   40.217382] mv88e6085 d0032004.mdio-mii:12 lan24 (unregistering): left allmulticast mode
[   40.225825] mv88e6085 d0032004.mdio-mii:12 lan24 (unregistering): left promiscuous mode
[   40.235116] br-lan: port 20(lan24) entered disabled state
[   40.359605] br-lan: port 18(sfp) entered disabled state
[   40.368026] mv88e6085 d0032004.mdio-mii:12 sfp (unregistering): left allmulticast mode
[   40.376478] mv88e6085 d0032004.mdio-mii:12 sfp (unregistering): left promiscuous mode
[   40.385737] br-lan: port 18(sfp) entered disabled state
[   40.711724] br-lan: port 3(lan5) entered disabled state
[   40.720036] mv88e6085 d0032004.mdio-mii:10 lan5 (unregistering): left allmulticast mode
[   40.730173] mv88e6085 d0032004.mdio-mii:10 lan5 (unregistering): left promiscuous mode
[   40.739818] br-lan: port 3(lan5) entered disabled state
[   40.855396] br-lan: port 1(lan6) entered disabled state
[   40.865954] mv88e6085 d0032004.mdio-mii:10 lan6 (unregistering): left allmulticast mode
[   40.874118] mv88e6085 d0032004.mdio-mii:10 lan6 (unregistering): left promiscuous mode
[   40.883157] br-lan: port 1(lan6) entered disabled state
[   40.993874] br-lan: port 6(lan7) entered disabled state
[   41.004674] mv88e6085 d0032004.mdio-mii:10 lan7 (unregistering): left allmulticast mode
[   41.012759] mv88e6085 d0032004.mdio-mii:10 lan7 (unregistering): left promiscuous mode
[   41.021973] br-lan: port 6(lan7) entered disabled state
[   41.147908] br-lan: port 2(lan8) entered disabled state
[   41.164809] mv88e6085 d0032004.mdio-mii:10 lan8 (unregistering): left allmulticast mode
[   41.172993] mvneta d0040000.ethernet eth1: left allmulticast mode
[   41.180723] mv88e6085 d0032004.mdio-mii:10 lan8 (unregistering): left promiscuous mode
[   41.188867] mvneta d0040000.ethernet eth1: left promiscuous mode
[   41.196805] br-lan: port 2(lan8) entered disabled state
[   41.389524] mv88e6085 d0032004.mdio-mii:11: Link is Down
[   41.411254] mv88e6085 d0032004.mdio-mii:11: Link is Down
[   41.424522] mv88e6085 d0032004.mdio-mii:12: Link is Down
[   41.432260] mv88e6085 d0032004.mdio-mii:10: Link is Down
[   41.449181] mv88e6085 d0032004.mdio-mii:10: Link is Down
[   41.466744] DSA: tree 0 torn down
[   41.470409] ------------[ cut here ]------------
[   41.473484] mvneta d0040000.ethernet eth1: Link is Down
[   41.475035] WARNING: CPU: 0 PID: 527 at net/dsa/dsa.c:1467 dsa_switch_release_ports+0x104/0x124
[   41.488960] Modules linked in:
[   41.492032] CPU: 0 PID: 527 Comm: bash Not tainted 6.3.0-rc1-00419-g0cfa74813653 #1837
[   41.499959] Hardware name: CZ.NIC Turris Mox Board (DT)
[   41.505186] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   41.512156] pc : dsa_switch_release_ports+0x104/0x124
[   41.517224] lr : dsa_switch_release_ports+0xb8/0x124
[   41.522201] sp : ffff80000b95bb40
[   41.525518] x29: ffff80000b95bb40 x28: ffff000003de10c0 x27: 0000000000000000
[   41.532676] x26: 0000000000000000 x25: 0000000000000000 x24: ffff000002dca420
[   41.539832] x23: ffff0000014e6530 x22: ffff000001732080 x21: dead000000000100
[   41.546989] x20: dead000000000122 x19: ffff000002048c00 x18: ffffffffffffffff
[   41.554146] x17: ffff000000001088 x16: ffff0000000010a8 x15: ffff000003cc4400
[   41.561302] x14: ffff000003cc0000 x13: ffff000003d4ec00 x12: ffff000003d5c800
[   41.568459] x11: ffff000001ab1400 x10: ffff000003d4ec00 x9 : ffff000003d5c800
[   41.575616] x8 : ffff000003d5c000 x7 : ffff000003cc1000 x6 : ffff000003ccd000
[   41.582772] x5 : ffff00003fdb4bc8 x4 : ffff00000154bb80 x3 : ffff000002048db0
[   41.589927] x2 : ffff00000d414310 x1 : ffff000002047200 x0 : ffff000002047000
[   41.597084] Call trace:
[   41.599535]  dsa_switch_release_ports+0x104/0x124
[   41.604252]  dsa_unregister_switch+0x3c/0x1dc
[   41.608624]  mv88e6xxx_remove+0x38/0xd4
[   41.612477]  mdio_remove+0x24/0x44
[   41.615895]  device_remove+0x70/0x80
[   41.619483]  device_release_driver_internal+0x1c8/0x224
[   41.624717]  device_driver_detach+0x18/0x24
[   41.628910]  unbind_store+0xb4/0xb8
[   41.632407]  drv_attr_store+0x24/0x38
[   41.636087]  sysfs_kf_write+0x44/0x54
[   41.639767]  kernfs_fop_write_iter+0x118/0x1a8
[   41.644223]  vfs_write+0x220/0x2ac
[   41.647642]  ksys_write+0x68/0xf4
[   41.650971]  __arm64_sys_write+0x1c/0x28
[   41.654909]  invoke_syscall+0x48/0x114
[   41.658675]  el0_svc_common.constprop.0+0x44/0xf4
[   41.663393]  do_el0_svc+0x3c/0xa8
[   41.666723]  el0_svc+0x2c/0x84
[   41.669794]  el0t_64_sync_handler+0xbc/0x138
[   41.674079]  el0t_64_sync+0x190/0x194
[   41.677753] ---[ end trace 0000000000000000 ]---
[root@mox:~] #
[root@mox:~] # echo d0032004.mdio-mii:10 > /sys/bus/mdio_bus/drivers/mv88e6085/bind
[   45.726662] mv88e6085 d0032004.mdio-mii:10: switch 0x3900 detected: Marvell 88E6390, revision 1
[   45.779097] hwmon hwmon17: temp1_input not attached to any thermal zone
[   45.808776] hwmon hwmon18: temp1_input not attached to any thermal zone
[   45.839631] hwmon hwmon19: temp1_input not attached to any thermal zone
[   45.869180] hwmon hwmon20: temp1_input not attached to any thermal zone
[   45.899697] hwmon hwmon21: temp1_input not attached to any thermal zone
[   45.928903] hwmon hwmon22: temp1_input not attached to any thermal zone
[   45.959586] hwmon hwmon23: temp1_input not attached to any thermal zone
[   45.988847] hwmon hwmon24: temp1_input not attached to any thermal zone
[   49.970220] mv88e6085 d0032004.mdio-mii:11: configuring for inband/2500base-x link mode
[   50.015750] mv88e6085 d0032004.mdio-mii:11: configuring for inband/2500base-x link mode
[   50.064071] mv88e6085 d0032004.mdio-mii:12: configuring for inband/2500base-x link mode
[   50.102876] mv88e6085 d0032004.mdio-mii:10: configuring for inband/2500base-x link mode
[   50.150218] mv88e6085 d0032004.mdio-mii:10: configuring for inband/2500base-x link mode
[   50.230357] mv88e6085 d0032004.mdio-mii:11: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   50.231843] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   50.257245] mv88e6085 d0032004.mdio-mii:11 lan9 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:01] driver [Marvell 88E6390 Family] (irq=49)
[   50.373610] mvneta d0040000.ethernet eth1: configuring for inband/2500base-x link mode
[   50.452087] br-lan: port 1(lan9) entered blocking state
[   50.471697] br-lan: port 1(lan9) entered disabled state
[   50.481060] mv88e6085 d0032004.mdio-mii:11 lan9: entered allmulticast mode
[   50.484440] mv88e6085 d0032004.mdio-mii:11 lan10 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:02] driver [Marvell 88E6390 Family] (irq=50)
[   50.490871] mvneta d0040000.ethernet eth1: entered allmulticast mode
[   50.530591] mv88e6085 d0032004.mdio-mii:11: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   50.536104] mv88e6085 d0032004.mdio-mii:12: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   50.865533] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control off
[   50.875162] mv88e6085 d0032004.mdio-mii:11 lan9: entered promiscuous mode
[   50.886696] mvneta d0040000.ethernet eth1: entered promiscuous mode
[   51.083401] mv88e6085 d0032004.mdio-mii:11 lan9: configuring for phy/gmii link mode
[   51.096880] 8021q: adding VLAN 0 to HW filter on device lan9
[   51.102754] mvneta d0040000.ethernet eth1: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   51.155874] mv88e6085 d0032004.mdio-mii:11 lan11 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:03] driver [Marvell 88E6390 Family] (irq=51)
[   51.225848] br-lan: port 2(lan10) entered blocking state
[   51.235552] br-lan: port 2(lan10) entered disabled state
[   51.248346] mv88e6085 d0032004.mdio-mii:11 lan10: entered allmulticast mode
[   51.263013] mv88e6085 d0032004.mdio-mii:11 lan12 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:04] driver [Marvell 88E6390 Family] (irq=52)
[   51.337646] mv88e6085 d0032004.mdio-mii:11 lan10: entered promiscuous mode
[   51.367192] mv88e6085 d0032004.mdio-mii:11 lan10: configuring for phy/gmii link mode
[   51.377318] 8021q: adding VLAN 0 to HW filter on device lan10
[   51.422902] br-lan: port 3(lan11) entered blocking state
[   51.428430] br-lan: port 3(lan11) entered disabled state
[   51.434594] mv88e6085 d0032004.mdio-mii:11 lan11: entered allmulticast mode
[   51.448983] mv88e6085 d0032004.mdio-mii:11 lan13 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:05] driver [Marvell 88E6390 Family] (irq=53)
[   51.521087] mv88e6085 d0032004.mdio-mii:11 lan11: entered promiscuous mode
[   51.552308] br-lan: port 4(lan12) entered blocking state
[   51.559650] br-lan: port 4(lan12) entered disabled state
[   51.566144] mv88e6085 d0032004.mdio-mii:11 lan12: entered allmulticast mode
[   51.630102] mv88e6085 d0032004.mdio-mii:11 lan12: entered promiscuous mode
[   51.653711] mv88e6085 d0032004.mdio-mii:11 lan14 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:06] driver [Marvell 88E6390 Family] (irq=54)
[   51.688979] mv88e6085 d0032004.mdio-mii:11 lan11: configuring for phy/gmii link mode
[   51.706125] 8021q: adding VLAN 0 to HW filter on device lan11
[   51.727184] mv88e6085 d0032004.mdio-mii:11 lan12: configuring for phy/gmii link mode
[   51.749191] 8021q: adding VLAN 0 to HW filter on device lan12
[   51.801295] mv88e6085 d0032004.mdio-mii:11 lan15 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:07] driver [Marvell 88E6390 Family] (irq=55)
[   51.820563] br-lan: port 6(lan13) entered blocking state
[   51.831605] br-lan: port 6(lan13) entered disabled state
[   51.847661] mv88e6085 d0032004.mdio-mii:11 lan13: entered allmulticast mode
[   51.924452] mv88e6085 d0032004.mdio-mii:11 lan13: entered promiscuous mode
[   51.943098] br-lan: port 7(lan14) entered blocking state
[   51.949179] br-lan: port 7(lan14) entered disabled state
[   51.955109] mv88e6085 d0032004.mdio-mii:11 lan14: entered allmulticast mode
[   52.010030] mv88e6085 d0032004.mdio-mii:11 lan14: entered promiscuous mode
[   52.031024] mv88e6085 d0032004.mdio-mii:11 lan13: configuring for phy/gmii link mode
[   52.042527] 8021q: adding VLAN 0 to HW filter on device lan13
[   52.049926] mv88e6085 d0032004.mdio-mii:11 lan14: configuring for phy/gmii link mode
[   52.061526] 8021q: adding VLAN 0 to HW filter on device lan14
[   52.102945] mv88e6085 d0032004.mdio-mii:11 lan16 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:08] driver [Marvell 88E6390 Family] (irq=56)
[   52.189198] br-lan: port 8(lan15) entered blocking state
[   52.202644] mv88e6085 d0032004.mdio-mii:12 lan17 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:01] driver [Marvell 88E6390 Family] (irq=74)
[   52.210074] br-lan: port 8(lan15) entered disabled state
[   52.229499] mv88e6085 d0032004.mdio-mii:11 lan15: entered allmulticast mode
[   52.287388] mv88e6085 d0032004.mdio-mii:11 lan15: entered promiscuous mode
[   52.319320] mv88e6085 d0032004.mdio-mii:11 lan15: configuring for phy/gmii link mode
[   52.333146] 8021q: adding VLAN 0 to HW filter on device lan15
[   52.375188] br-lan: port 9(lan17) entered blocking state
[   52.383668] br-lan: port 9(lan17) entered disabled state
[   52.386852] mv88e6085 d0032004.mdio-mii:12 lan18 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:02] driver [Marvell 88E6390 Family] (irq=75)
[   52.399564] mv88e6085 d0032004.mdio-mii:12 lan17: entered allmulticast mode
[   52.531264] mv88e6085 d0032004.mdio-mii:12 lan17: entered promiscuous mode
[   52.571744] mv88e6085 d0032004.mdio-mii:12 lan17: configuring for phy/gmii link mode
[   52.582555] 8021q: adding VLAN 0 to HW filter on device lan17
[   52.617336] br-lan: port 10(lan16) entered blocking state
[   52.627497] br-lan: port 10(lan16) entered disabled state
[   52.639499] mv88e6085 d0032004.mdio-mii:11 lan16: entered allmulticast mode
[   52.654812] mv88e6085 d0032004.mdio-mii:12 lan19 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:03] driver [Marvell 88E6390 Family] (irq=76)
[   52.727451] mv88e6085 d0032004.mdio-mii:11 lan16: entered promiscuous mode
[   52.749241] mv88e6085 d0032004.mdio-mii:11 lan16: configuring for phy/gmii link mode
[   52.769102] 8021q: adding VLAN 0 to HW filter on device lan16
[   52.847596] br-lan: port 11(lan18) entered blocking state
[   52.853190] br-lan: port 11(lan18) entered disabled state
[   52.864701] mv88e6085 d0032004.mdio-mii:12 lan18: entered allmulticast mode
[   52.875730] mv88e6085 d0032004.mdio-mii:12 lan20 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:04] driver [Marvell 88E6390 Family] (irq=77)
[   52.940090] mv88e6085 d0032004.mdio-mii:12 lan18: entered promiscuous mode
[   52.960187] br-lan: port 12(lan19) entered blocking state
[   52.965771] br-lan: port 12(lan19) entered disabled state
[   52.972149] mv88e6085 d0032004.mdio-mii:12 lan19: entered allmulticast mode
[   53.033452] mv88e6085 d0032004.mdio-mii:12 lan19: entered promiscuous mode
[   53.042979] mv88e6085 d0032004.mdio-mii:12 lan21 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:05] driver [Marvell 88E6390 Family] (irq=78)
[   53.063899] mv88e6085 d0032004.mdio-mii:12 lan18: configuring for phy/gmii link mode
[   53.086934] 8021q: adding VLAN 0 to HW filter on device lan18
[   53.098869] mv88e6085 d0032004.mdio-mii:12 lan19: configuring for phy/gmii link mode
[   53.110717] 8021q: adding VLAN 0 to HW filter on device lan19
[   53.169864] br-lan: port 13(lan20) entered blocking state
[   53.181878] br-lan: port 13(lan20) entered disabled state
[   53.188626] mv88e6085 d0032004.mdio-mii:12 lan20: entered allmulticast mode
[   53.266205] mv88e6085 d0032004.mdio-mii:12 lan22 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:06] driver [Marvell 88E6390 Family] (irq=79)
[   53.270450] mv88e6085 d0032004.mdio-mii:12 lan20: entered promiscuous mode
[   53.307190] mv88e6085 d0032004.mdio-mii:12 lan20: configuring for phy/gmii link mode
[   53.318235] 8021q: adding VLAN 0 to HW filter on device lan20
[   53.332453] br-lan: port 14(lan21) entered blocking state
[   53.343194] br-lan: port 14(lan21) entered disabled state
[   53.348806] mv88e6085 d0032004.mdio-mii:12 lan21: entered allmulticast mode
[   53.429093] mv88e6085 d0032004.mdio-mii:12 lan21: entered promiscuous mode
[   53.471739] mv88e6085 d0032004.mdio-mii:12 lan23 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:07] driver [Marvell 88E6390 Family] (irq=80)
[   53.496476] mv88e6085 d0032004.mdio-mii:12 lan21: configuring for phy/gmii link mode
[   53.517362] 8021q: adding VLAN 0 to HW filter on device lan21
[   53.564612] br-lan: port 15(lan22) entered blocking state
[   53.583445] br-lan: port 15(lan22) entered disabled state
[   53.599707] mv88e6085 d0032004.mdio-mii:12 lan22: entered allmulticast mode
[   53.612478] mv88e6085 d0032004.mdio-mii:12 lan24 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:08] driver [Marvell 88E6390 Family] (irq=81)
[   53.669529] mv88e6085 d0032004.mdio-mii:12 lan22: entered promiscuous mode
[   53.707140] mv88e6085 d0032004.mdio-mii:12 lan22: configuring for phy/gmii link mode
[   53.729702] 8021q: adding VLAN 0 to HW filter on device lan22
[   53.755344] br-lan: port 16(lan23) entered blocking state
[   53.767553] br-lan: port 16(lan23) entered disabled state
[   53.775773] mv88e6085 d0032004.mdio-mii:12 lan23: entered allmulticast mode
[   53.790471] mv88e6085 d0032004.mdio-mii:10 lan1 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:01] driver [Marvell 88E6390 Family] (irq=109)
[   53.883258] mv88e6085 d0032004.mdio-mii:12 lan23: entered promiscuous mode
[   53.943810] mv88e6085 d0032004.mdio-mii:12 lan23: configuring for phy/gmii link mode
[   53.962953] 8021q: adding VLAN 0 to HW filter on device lan23
[   53.982300] br-lan: port 17(lan24) entered blocking state
[   53.986586] mv88e6085 d0032004.mdio-mii:10 lan2 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:02] driver [Marvell 88E6390 Family] (irq=110)
[   53.987803] br-lan: port 17(lan24) entered disabled state
[   54.023728] mv88e6085 d0032004.mdio-mii:12 lan24: entered allmulticast mode
[   54.118192] mv88e6085 d0032004.mdio-mii:12 lan24: entered promiscuous mode
[   54.152984] br-lan: port 18(sfp) entered blocking state
[   54.158381] br-lan: port 18(sfp) entered disabled state
[   54.164875] mv88e6085 d0032004.mdio-mii:12 sfp: entered allmulticast mode
[   54.203816] mv88e6085 d0032004.mdio-mii:10 lan3 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:03] driver [Marvell 88E6390 Family] (irq=111)
[   54.237187] mv88e6085 d0032004.mdio-mii:12 sfp: entered promiscuous mode
[   54.302042] mv88e6085 d0032004.mdio-mii:12 lan24: configuring for phy/gmii link mode
[   54.317588] 8021q: adding VLAN 0 to HW filter on device lan24
[   54.345478] mv88e6085 d0032004.mdio-mii:10 lan4 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:04] driver [Marvell 88E6390 Family] (irq=112)
[   54.374576] mv88e6085 d0032004.mdio-mii:12 sfp: configuring for inband/sgmii link mode
[   54.387213] 8021q: adding VLAN 0 to HW filter on device sfp
[   54.466574] mv88e6085 d0032004.mdio-mii:10 lan5 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:05] driver [Marvell 88E6390 Family] (irq=113)
[   54.581861] mv88e6085 d0032004.mdio-mii:10 lan6 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:06] driver [Marvell 88E6390 Family] (irq=114)
[   54.694224] br-lan: port 19(lan5) entered blocking state
[   54.702342] br-lan: port 19(lan5) entered disabled state
[   54.706426] mv88e6085 d0032004.mdio-mii:10 lan7 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:07] driver [Marvell 88E6390 Family] (irq=115)
[   54.719456] mv88e6085 d0032004.mdio-mii:10 lan5: entered allmulticast mode
[   54.805299] mv88e6085 d0032004.mdio-mii:10 lan5: entered promiscuous mode
[   54.847452] mv88e6085 d0032004.mdio-mii:10 lan5: configuring for phy/gmii link mode
[   54.860356] 8021q: adding VLAN 0 to HW filter on device lan5
[   54.903071] br-lan: port 20(lan6) entered blocking state
[   54.910567] mv88e6085 d0032004.mdio-mii:10 lan8 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:08] driver [Marvell 88E6390 Family] (irq=116)
[   54.915191] br-lan: port 20(lan6) entered disabled state
[   54.947313] mv88e6085 d0032004.mdio-mii:10 lan6: entered allmulticast mode
[   55.044280] mv88e6085 d0032004.mdio-mii:10 lan6: entered promiscuous mode
[   55.068103] DSA: tree 0 setup
[root@mox:~] # [   55.077021] br-lan: port 21(lan7) entered blocking state
[   55.082611] br-lan: port 21(lan7) entered disabled state
[   55.088099] mv88e6085 d0032004.mdio-mii:10 lan7: entered allmulticast mode
[   55.159610] mv88e6085 d0032004.mdio-mii:10 lan7: entered promiscuous mode
[   55.180719] mv88e6085 d0032004.mdio-mii:10 lan6: configuring for phy/gmii link mode
[   55.199403] 8021q: adding VLAN 0 to HW filter on device lan6
[   55.217016] mv88e6085 d0032004.mdio-mii:10 lan7: configuring for phy/gmii link mode
[   55.240582] 8021q: adding VLAN 0 to HW filter on device lan7
[   55.280988] br-lan: port 22(lan8) entered blocking state
[   55.287822] br-lan: port 22(lan8) entered disabled state
[   55.310211] mv88e6085 d0032004.mdio-mii:10 lan8: entered allmulticast mode
[   55.401384] mv88e6085 d0032004.mdio-mii:10 lan8: entered promiscuous mode
[   55.422163] mv88e6085 d0032004.mdio-mii:10 lan8: configuring for phy/gmii link mode
[   55.432540] 8021q: adding VLAN 0 to HW filter on device lan8

After:

[root@mox:~] # echo d0032004.mdio-mii:10 > /sys/bus/mdio_bus/drivers/mv88e6085/unbind
[   38.804609] mvneta d0040000.ethernet eth1: Link is Down
[   38.836428] mv88e6085 d0032004.mdio-mii:10: Link is Down
[   38.889785] mvneta d0040000.ethernet eth1: configuring for inband/2500base-x link mode
[   38.901639] br-lan: port 8(lan9) entered disabled state
[   38.910936] mv88e6085 d0032004.mdio-mii:11 lan9 (unregistering): left allmulticast mode
[   38.919629] mv88e6085 d0032004.mdio-mii:11 lan9 (unregistering): left promiscuous mode
[   38.928331] br-lan: port 8(lan9) entered disabled state
[   39.055518] br-lan: port 9(lan10) entered disabled state
[   39.065432] mv88e6085 d0032004.mdio-mii:11 lan10 (unregistering): left allmulticast mode
[   39.073638] mv88e6085 d0032004.mdio-mii:11 lan10 (unregistering): left promiscuous mode
[   39.084682] br-lan: port 9(lan10) entered disabled state
[   39.208318] br-lan: port 11(lan11) entered disabled state
[   39.216703] mv88e6085 d0032004.mdio-mii:11 lan11 (unregistering): left allmulticast mode
[   39.226718] mv88e6085 d0032004.mdio-mii:11 lan11 (unregistering): left promiscuous mode
[   39.236526] br-lan: port 11(lan11) entered disabled state
[   39.353892] br-lan: port 13(lan12) entered disabled state
[   39.362550] mv88e6085 d0032004.mdio-mii:11 lan12 (unregistering): left allmulticast mode
[   39.371017] mv88e6085 d0032004.mdio-mii:11 lan12 (unregistering): left promiscuous mode
[   39.379166] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control off
[   39.383217] br-lan: port 13(lan12) entered disabled state
[   39.499262] br-lan: port 14(lan13) entered disabled state
[   39.508069] mv88e6085 d0032004.mdio-mii:11 lan13 (unregistering): left allmulticast mode
[   39.516340] mv88e6085 d0032004.mdio-mii:11 lan13 (unregistering): left promiscuous mode
[   39.527685] br-lan: port 14(lan13) entered disabled state
[   39.616462] mvneta d0040000.ethernet eth1: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   39.659343] br-lan: port 12(lan14) entered disabled state
[   39.668230] mv88e6085 d0032004.mdio-mii:11 lan14 (unregistering): left allmulticast mode
[   39.676632] mv88e6085 d0032004.mdio-mii:11 lan14 (unregistering): left promiscuous mode
[   39.685443] br-lan: port 12(lan14) entered disabled state
[   39.815777] br-lan: port 10(lan15) entered disabled state
[   39.824398] mv88e6085 d0032004.mdio-mii:11 lan15 (unregistering): left allmulticast mode
[   39.835182] mv88e6085 d0032004.mdio-mii:11 lan15 (unregistering): left promiscuous mode
[   39.845693] br-lan: port 10(lan15) entered disabled state
[   39.961538] br-lan: port 6(lan16) entered disabled state
[   39.968551] mv88e6085 d0032004.mdio-mii:11 lan16 (unregistering): left allmulticast mode
[   39.977177] mv88e6085 d0032004.mdio-mii:11 lan16 (unregistering): left promiscuous mode
[   39.986103] br-lan: port 6(lan16) entered disabled state
[   40.111558] br-lan: port 7(lan17) entered disabled state
[   40.119316] mv88e6085 d0032004.mdio-mii:12 lan17 (unregistering): left allmulticast mode
[   40.127718] mv88e6085 d0032004.mdio-mii:12 lan17 (unregistering): left promiscuous mode
[   40.136304] br-lan: port 7(lan17) entered disabled state
[   40.267200] br-lan: port 15(lan18) entered disabled state
[   40.276068] mv88e6085 d0032004.mdio-mii:12 lan18 (unregistering): left allmulticast mode
[   40.284374] mv88e6085 d0032004.mdio-mii:12 lan18 (unregistering): left promiscuous mode
[   40.297224] br-lan: port 15(lan18) entered disabled state
[   40.412665] br-lan: port 17(lan19) entered disabled state
[   40.422518] mv88e6085 d0032004.mdio-mii:12 lan19 (unregistering): left allmulticast mode
[   40.430923] mv88e6085 d0032004.mdio-mii:12 lan19 (unregistering): left promiscuous mode
[   40.440107] br-lan: port 17(lan19) entered disabled state
[   40.575203] br-lan: port 16(lan20) entered disabled state
[   40.584693] mv88e6085 d0032004.mdio-mii:12 lan20 (unregistering): left allmulticast mode
[   40.593283] mv88e6085 d0032004.mdio-mii:12 lan20 (unregistering): left promiscuous mode
[   40.604576] br-lan: port 16(lan20) entered disabled state
[   40.723334] br-lan: port 22(lan21) entered disabled state
[   40.733063] mv88e6085 d0032004.mdio-mii:12 lan21 (unregistering): left allmulticast mode
[   40.741597] mv88e6085 d0032004.mdio-mii:12 lan21 (unregistering): left promiscuous mode
[   40.750194] br-lan: port 22(lan21) entered disabled state
[   40.887041] br-lan: port 18(lan22) entered disabled state
[   40.898166] mv88e6085 d0032004.mdio-mii:12 lan22 (unregistering): left allmulticast mode
[   40.906445] mv88e6085 d0032004.mdio-mii:12 lan22 (unregistering): left promiscuous mode
[   40.917863] br-lan: port 18(lan22) entered disabled state
[   41.029860] br-lan: port 19(lan23) entered disabled state
[   41.045441] mv88e6085 d0032004.mdio-mii:12 lan23 (unregistering): left allmulticast mode
[   41.053984] mv88e6085 d0032004.mdio-mii:12 lan23 (unregistering): left promiscuous mode
[   41.062165] br-lan: port 19(lan23) entered disabled state
[   41.183529] br-lan: port 20(lan24) entered disabled state
[   41.191691] mv88e6085 d0032004.mdio-mii:12 lan24 (unregistering): left allmulticast mode
[   41.202474] mv88e6085 d0032004.mdio-mii:12 lan24 (unregistering): left promiscuous mode
[   41.213187] br-lan: port 20(lan24) entered disabled state
[   41.343226] br-lan: port 21(sfp) entered disabled state
[   41.353702] mv88e6085 d0032004.mdio-mii:12 sfp (unregistering): left allmulticast mode
[   41.361862] mv88e6085 d0032004.mdio-mii:12 sfp (unregistering): left promiscuous mode
[   41.373883] br-lan: port 21(sfp) entered disabled state
[   41.711189] br-lan: port 2(lan5) entered disabled state
[   41.718668] mv88e6085 d0032004.mdio-mii:10 lan5 (unregistering): left allmulticast mode
[   41.726822] mv88e6085 d0032004.mdio-mii:10 lan5 (unregistering): left promiscuous mode
[   41.735694] br-lan: port 2(lan5) entered disabled state
[   41.839825] br-lan: port 1(lan6) entered disabled state
[   41.848471] mv88e6085 d0032004.mdio-mii:10 lan6 (unregistering): left allmulticast mode
[   41.856891] br-lan: port 1(lan6) entered disabled state
[   41.967016] br-lan: port 3(lan7) entered disabled state
[   41.975475] mv88e6085 d0032004.mdio-mii:10 lan7 (unregistering): left allmulticast mode
[   41.983747] mv88e6085 d0032004.mdio-mii:10 lan7 (unregistering): left promiscuous mode
[   41.992881] br-lan: port 3(lan7) entered disabled state
[   42.097753] br-lan: port 5(lan8) entered disabled state
[   42.119958] mv88e6085 d0032004.mdio-mii:10 lan8 (unregistering): left allmulticast mode
[   42.129234] mvneta d0040000.ethernet eth1: left allmulticast mode
[   42.136958] mv88e6085 d0032004.mdio-mii:10 lan8 (unregistering): left promiscuous mode
[   42.147736] br-lan: port 5(lan8) entered disabled state
[   42.349669] mv88e6085 d0032004.mdio-mii:11: Link is Down
[   42.366276] mv88e6085 d0032004.mdio-mii:11: Link is Down
[   42.380199] mv88e6085 d0032004.mdio-mii:12: Link is Down
[   42.392167] mv88e6085 d0032004.mdio-mii:10: Link is Down
[   42.409683] mv88e6085 d0032004.mdio-mii:10: Link is Down
[   42.446979] mvneta d0040000.ethernet eth1: Link is Down
[   42.474927] DSA: tree 0 torn down
[   42.480891] ------------[ cut here ]------------
[   42.485536] WARNING: CPU: 0 PID: 514 at net/dsa/dsa.c:1467 dsa_switch_release_ports+0x104/0x124
[   42.494256] Modules linked in:
[   42.497323] CPU: 0 PID: 514 Comm: bash Not tainted 6.3.0-rc1-00420-g2294a2b78aab #1838
[   42.505242] Hardware name: CZ.NIC Turris Mox Board (DT)
[   42.510466] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   42.517428] pc : dsa_switch_release_ports+0x104/0x124
[   42.522485] lr : dsa_switch_release_ports+0xb8/0x124
[   42.527455] sp : ffff80000bb8bb40
[   42.530769] x29: ffff80000bb8bb40 x28: ffff000008620100 x27: 0000000000000000
[   42.537917] x26: 0000000000000000 x25: 0000000000000000 x24: ffff000003c75b20
[   42.545061] x23: ffff0000014e6530 x22: ffff0000011c3280 x21: dead000000000100
[   42.552203] x20: dead000000000122 x19: ffff000001a3c000 x18: 0000000000000000
[   42.559342] x17: ffff8000359ea000 x16: ffff800008000000 x15: 00003387f15ac440
[   42.566484] x14: 000000000000034e x13: 000000000000034e x12: 0000000000000000
[   42.573626] x11: 0000000000000002 x10: 0000000000000a10 x9 : ffff80000bb8b920
[   42.580764] x8 : ffff000008620b70 x7 : ffff00003fdad080 x6 : 0000000000000000
[   42.587900] x5 : 0000000000000000 x4 : ffff00000159f000 x3 : ffff000001a3c1b0
[   42.595033] x2 : ffff00000cca2a10 x1 : ffff000001a3c600 x0 : ffff000001a3c400
[   42.602169] Call trace:
[   42.604610]  dsa_switch_release_ports+0x104/0x124
[   42.609314]  dsa_unregister_switch+0x3c/0x1dc
[   42.613670]  mv88e6xxx_remove+0x38/0xcc
[   42.617507]  mdio_remove+0x24/0x44
[   42.620909]  device_remove+0x70/0x80
[   42.624482]  device_release_driver_internal+0x1c8/0x224
[   42.629703]  device_driver_detach+0x18/0x24
[   42.633882]  unbind_store+0xb4/0xb8
[   42.637366]  drv_attr_store+0x24/0x38
[   42.641028]  sysfs_kf_write+0x44/0x54
[   42.644692]  kernfs_fop_write_iter+0x118/0x1a8
[   42.649132]  vfs_write+0x220/0x2ac
[   42.652535]  ksys_write+0x68/0xf4
[   42.655848]  __arm64_sys_write+0x1c/0x28
[   42.659769]  invoke_syscall+0x48/0x114
[   42.663519]  el0_svc_common.constprop.0+0x44/0xf4
[   42.668220]  do_el0_svc+0x3c/0xa8
[   42.671533]  el0_svc+0x2c/0x84
[   42.674589]  el0t_64_sync_handler+0xbc/0x138
[   42.678857]  el0t_64_sync+0x190/0x194
[   42.682517] ---[ end trace 0000000000000000 ]---
[root@mox:~] #
[root@mox:~] # echo d0032004.mdio-mii:10 > /sys/bus/mdio_bus/drivers/mv88e6085/bind
[   46.422669] mv88e6085 d0032004.mdio-mii:10: switch 0x3900 detected: Marvell 88E6390, revision 1
[   46.489176] hwmon hwmon1: temp1_input not attached to any thermal zone
[   46.524493] hwmon hwmon2: temp1_input not attached to any thermal zone
[   46.553035] hwmon hwmon3: temp1_input not attached to any thermal zone
[   46.583877] hwmon hwmon4: temp1_input not attached to any thermal zone
[   46.612746] hwmon hwmon5: temp1_input not attached to any thermal zone
[   46.639241] hwmon hwmon6: temp1_input not attached to any thermal zone
[   46.665703] hwmon hwmon7: temp1_input not attached to any thermal zone
[   46.692378] hwmon hwmon8: temp1_input not attached to any thermal zone
[   48.006414] hwmon hwmon9: temp1_input not attached to any thermal zone
[   48.036281] hwmon hwmon10: temp1_input not attached to any thermal zone
[   48.064983] hwmon hwmon11: temp1_input not attached to any thermal zone
[   48.096309] hwmon hwmon12: temp1_input not attached to any thermal zone
[   48.127129] hwmon hwmon13: temp1_input not attached to any thermal zone
[   48.154166] hwmon hwmon14: temp1_input not attached to any thermal zone
[   48.186455] hwmon hwmon15: temp1_input not attached to any thermal zone
[   48.215419] hwmon hwmon16: temp1_input not attached to any thermal zone
[   49.529431] hwmon hwmon17: temp1_input not attached to any thermal zone
[   49.569771] hwmon hwmon18: temp1_input not attached to any thermal zone
[   49.599289] hwmon hwmon19: temp1_input not attached to any thermal zone
[   49.626658] hwmon hwmon20: temp1_input not attached to any thermal zone
[   49.653364] hwmon hwmon21: temp1_input not attached to any thermal zone
[   49.679977] hwmon hwmon22: temp1_input not attached to any thermal zone
[   49.706853] hwmon hwmon23: temp1_input not attached to any thermal zone
[   49.733373] hwmon hwmon24: temp1_input not attached to any thermal zone
[   51.050045] mv88e6085 d0032004.mdio-mii:11: configuring for inband/2500base-x link mode
[   51.096080] mv88e6085 d0032004.mdio-mii:11: configuring for inband/2500base-x link mode
[   51.131924] mv88e6085 d0032004.mdio-mii:12: configuring for inband/2500base-x link mode
[   51.177483] mv88e6085 d0032004.mdio-mii:10: configuring for inband/2500base-x link mode
[   51.246005] mv88e6085 d0032004.mdio-mii:11: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   51.254672] mv88e6085 d0032004.mdio-mii:12: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   51.264481] mv88e6085 d0032004.mdio-mii:10: configuring for inband/2500base-x link mode
[   51.334825] mv88e6085 d0032004.mdio-mii:11: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   51.351383] mv88e6085 d0032004.mdio-mii:11 lan9 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:01] driver [Marvell 88E6390 Family] (irq=0)
[   51.366620] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:01: Error -22 requesting IRQ 0, falling back to polling
[   51.374704] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   51.470694] mvneta d0040000.ethernet eth1: configuring for inband/2500base-x link mode
[   51.558411] mv88e6085 d0032004.mdio-mii:11 lan10 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:02] driver [Marvell 88E6390 Family] (irq=0)
[   51.573814] br-lan: port 1(lan9) entered blocking state
[   51.579842] br-lan: port 1(lan9) entered disabled state
[   51.586826] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:02: Error -22 requesting IRQ 0, falling back to polling
[   51.600573] mv88e6085 d0032004.mdio-mii:11 lan9: entered allmulticast mode
[   51.609008] mvneta d0040000.ethernet eth1: entered allmulticast mode
[   51.711634] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control off
[   51.946590] mvneta d0040000.ethernet eth1: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   51.986923] mv88e6085 d0032004.mdio-mii:11 lan9: entered promiscuous mode
[   52.183922] mv88e6085 d0032004.mdio-mii:11 lan9: configuring for phy/gmii link mode
[   52.200261] 8021q: adding VLAN 0 to HW filter on device lan9
[   52.255175] mv88e6085 d0032004.mdio-mii:11 lan11 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:03] driver [Marvell 88E6390 Family] (irq=0)
[   52.271877] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:03: Error -22 requesting IRQ 0, falling back to polling
[   52.339247] br-lan: port 2(lan10) entered blocking state
[   52.347745] br-lan: port 2(lan10) entered disabled state
[   52.359752] mv88e6085 d0032004.mdio-mii:11 lan10: entered allmulticast mode
[   52.362991] mv88e6085 d0032004.mdio-mii:11 lan12 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:04] driver [Marvell 88E6390 Family] (irq=0)
[   52.403737] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:04: Error -22 requesting IRQ 0, falling back to polling
[   52.447808] mv88e6085 d0032004.mdio-mii:11 lan10: entered promiscuous mode
[   52.464334] mv88e6085 d0032004.mdio-mii:11 lan10: configuring for phy/gmii link mode
[   52.473971] 8021q: adding VLAN 0 to HW filter on device lan10
[   52.520231] br-lan: port 3(lan11) entered blocking state
[   52.527540] br-lan: port 3(lan11) entered disabled state
[   52.543823] mv88e6085 d0032004.mdio-mii:11 lan11: entered allmulticast mode
[   52.554906] mv88e6085 d0032004.mdio-mii:11 lan13 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:05] driver [Marvell 88E6390 Family] (irq=0)
[   52.579696] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:05: Error -22 requesting IRQ 0, falling back to polling
[   52.635883] mv88e6085 d0032004.mdio-mii:11 lan11: entered promiscuous mode
[   52.660433] mv88e6085 d0032004.mdio-mii:11 lan11: configuring for phy/gmii link mode
[   52.675020] 8021q: adding VLAN 0 to HW filter on device lan11
[   52.689600] br-lan: port 5(lan12) entered blocking state
[   52.695733] br-lan: port 5(lan12) entered disabled state
[   52.701810] mv88e6085 d0032004.mdio-mii:11 lan12: entered allmulticast mode
[   52.758164] mv88e6085 d0032004.mdio-mii:11 lan12: entered promiscuous mode
[   52.792135] mv88e6085 d0032004.mdio-mii:11 lan14 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:06] driver [Marvell 88E6390 Family] (irq=0)
[   52.814987] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:06: Error -22 requesting IRQ 0, falling back to polling
[   52.846618] mv88e6085 d0032004.mdio-mii:11 lan12: configuring for phy/gmii link mode
[   52.865396] 8021q: adding VLAN 0 to HW filter on device lan12
[   52.895353] br-lan: port 6(lan13) entered blocking state
[   52.903767] br-lan: port 6(lan13) entered disabled state
[   52.907000] mv88e6085 d0032004.mdio-mii:11 lan15 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:07] driver [Marvell 88E6390 Family] (irq=0)
[   52.915774] mv88e6085 d0032004.mdio-mii:11 lan13: entered allmulticast mode
[   52.943877] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:07: Error -22 requesting IRQ 0, falling back to polling
[   53.002152] mv88e6085 d0032004.mdio-mii:11 lan13: entered promiscuous mode
[   53.048087] br-lan: port 7(lan14) entered blocking state
[   53.053553] br-lan: port 7(lan14) entered disabled state
[   53.059981] mv88e6085 d0032004.mdio-mii:11 lan14: entered allmulticast mode
[   53.117176] mv88e6085 d0032004.mdio-mii:11 lan14: entered promiscuous mode
[   53.134838] mv88e6085 d0032004.mdio-mii:11 lan16 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:08] driver [Marvell 88E6390 Family] (irq=0)
[   53.136717] mv88e6085 d0032004.mdio-mii:11 lan13: configuring for phy/gmii link mode
[   53.160616] 8021q: adding VLAN 0 to HW filter on device lan13
[   53.180549] mv88e6085 d0032004.mdio-mii:11 lan14: configuring for phy/gmii link mode
[   53.181492] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:08: Error -22 requesting IRQ 0, falling back to polling
[   53.205198] 8021q: adding VLAN 0 to HW filter on device lan14
[   53.258192] br-lan: port 8(lan15) entered blocking state
[   53.264295] br-lan: port 8(lan15) entered disabled state
[   53.270825] mv88e6085 d0032004.mdio-mii:11 lan15: entered allmulticast mode
[   53.308478] mv88e6085 d0032004.mdio-mii:12 lan17 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:01] driver [Marvell 88E6390 Family] (irq=0)
[   53.332894] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:01: Error -22 requesting IRQ 0, falling back to polling
[   53.362336] mv88e6085 d0032004.mdio-mii:11 lan15: entered promiscuous mode
[   53.394967] mv88e6085 d0032004.mdio-mii:11 lan15: configuring for phy/gmii link mode
[   53.413092] 8021q: adding VLAN 0 to HW filter on device lan15
[   53.437052] br-lan: port 9(lan16) entered blocking state
[   53.442766] br-lan: port 9(lan16) entered disabled state
[   53.449676] mv88e6085 d0032004.mdio-mii:11 lan16: entered allmulticast mode
[   53.482618] mv88e6085 d0032004.mdio-mii:12 lan18 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:02] driver [Marvell 88E6390 Family] (irq=0)
[   53.503606] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:02: Error -22 requesting IRQ 0, falling back to polling
[   53.514217] mv88e6085 d0032004.mdio-mii:11 lan16: entered promiscuous mode
[   53.581203] mv88e6085 d0032004.mdio-mii:11 lan16: configuring for phy/gmii link mode
[   53.602100] 8021q: adding VLAN 0 to HW filter on device lan16
[   53.622550] br-lan: port 10(lan17) entered blocking state
[   53.632553] br-lan: port 10(lan17) entered disabled state
[   53.634931] mv88e6085 d0032004.mdio-mii:12 lan19 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:03] driver [Marvell 88E6390 Family] (irq=0)
[   53.638085] mv88e6085 d0032004.mdio-mii:12 lan17: entered allmulticast mode
[   53.669142] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:03: Error -22 requesting IRQ 0, falling back to polling
[   53.793816] mv88e6085 d0032004.mdio-mii:12 lan17: entered promiscuous mode
[   53.838369] mv88e6085 d0032004.mdio-mii:12 lan17: configuring for phy/gmii link mode
[   53.855828] 8021q: adding VLAN 0 to HW filter on device lan17
[   53.875716] br-lan: port 11(lan18) entered blocking state
[   53.881724] br-lan: port 11(lan18) entered disabled state
[   53.893398] mv88e6085 d0032004.mdio-mii:12 lan18: entered allmulticast mode
[   53.941693] mv88e6085 d0032004.mdio-mii:12 lan20 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:04] driver [Marvell 88E6390 Family] (irq=0)
[   53.956882] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:04: Error -22 requesting IRQ 0, falling back to polling
[   53.987315] mv88e6085 d0032004.mdio-mii:12 lan18: entered promiscuous mode
[   54.046508] mv88e6085 d0032004.mdio-mii:12 lan18: configuring for phy/gmii link mode
[   54.061458] 8021q: adding VLAN 0 to HW filter on device lan18
[   54.079503] br-lan: port 12(lan19) entered blocking state
[   54.085866] br-lan: port 12(lan19) entered disabled state
[   54.095757] mv88e6085 d0032004.mdio-mii:12 lan19: entered allmulticast mode
[   54.108930] mv88e6085 d0032004.mdio-mii:12 lan21 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:05] driver [Marvell 88E6390 Family] (irq=0)
[   54.131527] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:05: Error -22 requesting IRQ 0, falling back to polling
[   54.173638] mv88e6085 d0032004.mdio-mii:12 lan19: entered promiscuous mode
[   54.218351] mv88e6085 d0032004.mdio-mii:12 lan19: configuring for phy/gmii link mode
[   54.233271] 8021q: adding VLAN 0 to HW filter on device lan19
[   54.255099] br-lan: port 13(lan20) entered blocking state
[   54.264237] br-lan: port 13(lan20) entered disabled state
[   54.269931] mv88e6085 d0032004.mdio-mii:12 lan20: entered allmulticast mode
[   54.279282] mv88e6085 d0032004.mdio-mii:12 lan22 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:06] driver [Marvell 88E6390 Family] (irq=0)
[   54.305516] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:06: Error -22 requesting IRQ 0, falling back to polling
[   54.351628] mv88e6085 d0032004.mdio-mii:12 lan20: entered promiscuous mode
[   54.402348] mv88e6085 d0032004.mdio-mii:12 lan20: configuring for phy/gmii link mode
[   54.421263] 8021q: adding VLAN 0 to HW filter on device lan20
[   54.441993] br-lan: port 14(lan21) entered blocking state
[   54.448516] br-lan: port 14(lan21) entered disabled state
[   54.458881] mv88e6085 d0032004.mdio-mii:12 lan23 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:07] driver [Marvell 88E6390 Family] (irq=0)
[   54.459628] mv88e6085 d0032004.mdio-mii:12 lan21: entered allmulticast mode
[   54.495541] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:07: Error -22 requesting IRQ 0, falling back to polling
[   54.567612] mv88e6085 d0032004.mdio-mii:12 lan21: entered promiscuous mode
[   54.606367] mv88e6085 d0032004.mdio-mii:12 lan21: configuring for phy/gmii link mode
[   54.629169] 8021q: adding VLAN 0 to HW filter on device lan21
[   54.647230] br-lan: port 15(lan22) entered blocking state
[   54.653435] br-lan: port 15(lan22) entered disabled state
[   54.661655] mv88e6085 d0032004.mdio-mii:12 lan22: entered allmulticast mode
[   54.701320] mv88e6085 d0032004.mdio-mii:12 lan24 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:08] driver [Marvell 88E6390 Family] (irq=0)
[   54.727607] Marvell 88E6390 Family !soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:08: Error -22 requesting IRQ 0, falling back to polling
[   54.762586] mv88e6085 d0032004.mdio-mii:12 lan22: entered promiscuous mode
[   54.818703] mv88e6085 d0032004.mdio-mii:12 lan22: configuring for phy/gmii link mode
[   54.842280] 8021q: adding VLAN 0 to HW filter on device lan22
[   54.873775] br-lan: port 16(lan23) entered blocking state
[   54.878870] mv88e6085 d0032004.mdio-mii:10 lan1 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:01] driver [Marvell 88E6390 Family] (irq=74)
[   54.881198] br-lan: port 16(lan23) entered disabled state
[   54.902156] mv88e6085 d0032004.mdio-mii:12 lan23: entered allmulticast mode
[   54.991600] mv88e6085 d0032004.mdio-mii:12 lan23: entered promiscuous mode
[   55.038614] mv88e6085 d0032004.mdio-mii:12 lan23: configuring for phy/gmii link mode
[   55.053400] 8021q: adding VLAN 0 to HW filter on device lan23
[   55.082782] mv88e6085 d0032004.mdio-mii:10 lan2 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:02] driver [Marvell 88E6390 Family] (irq=75)
[   55.087578] br-lan: port 17(sfp) entered blocking state
[   55.107472] br-lan: port 17(sfp) entered disabled state
[   55.119607] mv88e6085 d0032004.mdio-mii:12 sfp: entered allmulticast mode
[   55.207898] mv88e6085 d0032004.mdio-mii:12 sfp: entered promiscuous mode
[   55.272930] mv88e6085 d0032004.mdio-mii:12 sfp: configuring for inband/sgmii link mode
[   55.291891] 8021q: adding VLAN 0 to HW filter on device sfp
[   55.314907] mv88e6085 d0032004.mdio-mii:10 lan3 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:03] driver [Marvell 88E6390 Family] (irq=76)
[   55.360945] br-lan: port 18(lan24) entered blocking state
[   55.368135] br-lan: port 18(lan24) entered disabled state
[   55.373769] mv88e6085 d0032004.mdio-mii:12 lan24: entered allmulticast mode
[   55.415355] mv88e6085 d0032004.mdio-mii:10 lan4 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:04] driver [Marvell 88E6390 Family] (irq=77)
[   55.464866] mv88e6085 d0032004.mdio-mii:12 lan24: entered promiscuous mode
[   55.489734] mv88e6085 d0032004.mdio-mii:12 lan24: configuring for phy/gmii link mode
[   55.518331] 8021q: adding VLAN 0 to HW filter on device lan24
[   55.598464] mv88e6085 d0032004.mdio-mii:10 lan5 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:05] driver [Marvell 88E6390 Family] (irq=78)
[   55.726605] mv88e6085 d0032004.mdio-mii:10 lan6 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:06] driver [Marvell 88E6390 Family] (irq=79)
[   55.830780] mv88e6085 d0032004.mdio-mii:10 lan7 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:07] driver [Marvell 88E6390 Family] (irq=80)
[   55.863759] br-lan: port 19(lan5) entered blocking state
[   55.879407] br-lan: port 19(lan5) entered disabled state
[   55.895855] mv88e6085 d0032004.mdio-mii:10 lan5: entered allmulticast mode
[   55.970325] mv88e6085 d0032004.mdio-mii:10 lan5: entered promiscuous mode
[   56.006674] mv88e6085 d0032004.mdio-mii:10 lan5: configuring for phy/gmii link mode
[   56.021562] 8021q: adding VLAN 0 to HW filter on device lan5
[   56.049425] br-lan: port 20(lan6) entered blocking state
[   56.059407] br-lan: port 20(lan6) entered disabled state
[   56.065732] mv88e6085 d0032004.mdio-mii:10 lan6: entered allmulticast mode
[   56.107164] mv88e6085 d0032004.mdio-mii:10 lan8 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:08] driver [Marvell 88E6390 Family] (irq=81)
[   56.148899] mv88e6085 d0032004.mdio-mii:10 lan6: entered promiscuous mode
[   56.169682] mv88e6085 d0032004.mdio-mii:10 lan6: configuring for phy/gmii link mode
[   56.186204] 8021q: adding VLAN 0 to HW filter on device lan6
[   56.197980] DSA: tree 0 setup
[root@mox:~] # [   56.233149] br-lan: port 21(lan8) entered blocking state
[   56.243372] br-lan: port 21(lan8) entered disabled state
[   56.251785] mv88e6085 d0032004.mdio-mii:10 lan8: entered allmulticast mode
[   56.352539] mv88e6085 d0032004.mdio-mii:10 lan8: entered promiscuous mode
[   56.381913] mv88e6085 d0032004.mdio-mii:10 lan8: configuring for phy/gmii link mode
[   56.400609] 8021q: adding VLAN 0 to HW filter on device lan8
[   56.449215] br-lan: port 22(lan7) entered blocking state
[   56.455394] br-lan: port 22(lan7) entered disabled state
[   56.461549] mv88e6085 d0032004.mdio-mii:10 lan7: entered allmulticast mode
[   56.552179] mv88e6085 d0032004.mdio-mii:10 lan7: entered promiscuous mode
[   56.580896] mv88e6085 d0032004.mdio-mii:10 lan7: configuring for phy/gmii link mode
[   56.593237] 8021q: adding VLAN 0 to HW filter on device lan7

[ ignore the WARN_ON()s - some mdb entries notified by the bridge seem
  to be leaking ]

instead I am noticing that the internal PHYs of switch d0032004.mdio-mii:11 and
d0032004.mdio-mii:12 are failing in phy_request_interrupt() - request_threaded_irq()
returns -EINVAL.

I haven't studied yet why that is. This happens with arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts,
which doesn't describe the switch PHY interrupts in the DTS. I don't know more yet.

There's nothing worth mentioning in the boot log prior to my unbind/bind commands.
