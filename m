Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFB21EC45E
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 23:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgFBVcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 17:32:53 -0400
Received: from hs2.cadns.ca ([149.56.24.197]:39421 "EHLO hs2.cadns.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgFBVcx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 17:32:53 -0400
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
        by hs2.cadns.ca (Postfix) with ESMTPSA id 5DA4F8169D2
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 17:32:16 -0400 (EDT)
Authentication-Results: hs2.cadns.ca;
        spf=pass (sender IP is 209.85.208.42) smtp.mailfrom=sriram.chadalavada@mindleap.ca smtp.helo=mail-ed1-f42.google.com
Received-SPF: pass (hs2.cadns.ca: connection is authenticated)
Received: by mail-ed1-f42.google.com with SMTP id o26so13444edq.0
 for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 14:32:16 -0700 (PDT)
X-Gm-Message-State: AOAM533Bq7/uUNOWXF2bI2k1kClmVA2D9zg2fYtwdTs/E75n4D/K8ZFv
 dBSVcMPjzpeEd3/YyoNiTFW8IlMRcj8dJD6+1Nc=
X-Google-Smtp-Source: ABdhPJwcNHeu0Es1+UeauFvxQvr4Q1wg+jqcqVPdOf4oZ5tUky8kvf4eacv7+ihqVURUZTOhlYgFpenU3f/3yJe3Yhk=
X-Received: by 2002:aa7:cc84:: with SMTP id p4mr27629545edt.157.1591133535180;
 Tue, 02 Jun 2020 14:32:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAOK2joHWb4ha1hv-Pz+we+TKqgJGdQArJsikMBNknc4HvZp4nA@mail.gmail.com>
 <20200527022038.GJ782807@lunn.ch>
 <CAOK2joHQb-ObphUz2e0O6AToZEnXLcV=VBY8jSU9TsLZqVUoTQ@mail.gmail.com>
 <20200527130330.GA793752@lunn.ch>
 <CAOK2joGx6AQLr65=NbP2xbjeLoKqRLEZftacOi0U1QsAS7Z6rQ@mail.gmail.com>
In-Reply-To: <CAOK2joGx6AQLr65=NbP2xbjeLoKqRLEZftacOi0U1QsAS7Z6rQ@mail.gmail.com>
From:   Sriram Chadalavada <sriram.chadalavada@mindleap.ca>
Date:   Tue, 2 Jun 2020 17:32:03 -0400
X-Gmail-Original-Message-ID: <CAOK2joEXxKizropqhDwnApKM9KsE2NDuYyMnR=VRn_ULwZC+uw@mail.gmail.com>
Message-ID: <CAOK2joEXxKizropqhDwnApKM9KsE2NDuYyMnR=VRn_ULwZC+uw@mail.gmail.com>
Subject: Fwd: Debugging DSA networking 5.4.42 kernel crash
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-PPP-Message-ID: <20200602213216.6772.57912@hs2.cadns.ca>
X-PPP-Vhost: mindleap.ca
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On OpenWRT 5.4.42 kernel on an imx6, I'm seeing a kernel crash when
loading builtin modules of igb driver and mv88e6xxx driver over PCI
bus. I've searched for the messages in the kernel code and Google but
its all over the place. What does this backtrace mean?

 Modules linked in:
[    2.631594][   T28] CPU: 2 PID: 28 Comm: kworker/u8:1 Not tainted
5.4.42 #0
[    2.631599][   T28] Hardware name: Freescale i.MX6 Quad/DualLite
(Device Tree)
 2.670498][   T32] Workqueue: events_unbound async_run_entry_fn
[    2.676560][   T32] [<80016424>] (unwind_backtrace) from
[<80012a84>] (show_stack+0x10/0x14)
[    2.685057][   T32] [<80012a84>] (show_stack) from [<8053cb30>]
(dump_stack+0x90/0xa4)
[    2.693033][   T32] [<8053cb30>] (dump_stack) from [<800241fc>]
(__warn+0xbc/0xd8)
[    2.700636][   T32] [<800241fc>] (__warn) from [<80024268>]
(warn_slowpath_fmt+0x50/0x94)
[    2.708849][   T32] [<80024268>] (warn_slowpath_fmt) from
[<8004331c>] (__request_module+0xac/0x37c)
[    2.718020][   T32] [<8004331c>] (__request_module) from
[<802eaeac>] (phy_request_driver_module+0x118/0x158)
[    2.727967][   T32] [<802eaeac>] (phy_request_driver_module) from
[<802ec4ac>] (phy_device_create+0x1e4/0x204)
[    2.737997][   T32] [<802ec4ac>] (phy_device_create) from
[<802ec628>] (get_phy_device+0x15c/0x1b0)
[    2.747098][   T32] [<802ec628>] (get_phy_device) from [<803d7ab4>]
(of_mdiobus_register_phy+0x74/0x170)
[    2.756615][   T32] [<803d7ab4>] (of_mdiobus_register_phy) from
[<803d8040>] (of_mdiobus_register+0x120/0x32c)
[    2.766665][   T32] [<803d8040>] (of_mdiobus_register) from
[<802ef248>] (mv88e6xxx_mdio_register+0xdc/0x190)
[    2.776617][   T32] [<802ef248>] (mv88e6xxx_mdio_register) from
[<802f10ac>] (mv88e6xxx_probe+0x618/0x714)
[    2.786305][   T32] [<802f10ac>] (mv88e6xxx_probe) from
[<802edaf8>] (mdio_probe+0x30/0x54)
[    2.794699][   T32] [<802edaf8>] (mdio_probe) from [<8027a034>]
(really_probe+0x1f0/0x364)
[    2.802996][   T32] [<8027a034>] (really_probe) from [<8027a328>]
(driver_probe_device+0x60/0x170)
[    2.811986][   T32] [<8027a328>] (driver_probe_device) from
[<802785c0>] (bus_for_each_drv+0x70/0x94)
[    2.821231][   T32] [<802785c0>] (bus_for_each_drv) from
[<80279dd4>] (__device_attach+0xb4/0x11c)
[    2.830218][   T32] [<80279dd4>] (__device_attach) from
[<802791d8>] (bus_probe_device+0x84/0x8c)
[    2.839117][   T32] [<802791d8>] (bus_probe_device) from
[<802768d0>] (device_add+0x36c/0x614)
[    2.847759][   T32] [<802768d0>] (device_add) from [<802edb9c>]
(mdio_device_register+0x24/0x48)
[    2.856582][   T32] [<802edb9c>] (mdio_device_register) from
[<803d81b4>] (of_mdiobus_register+0x294/0x32c)
[    2.866367][   T32] [<803d81b4>] (of_mdiobus_register) from
[<8032ccc8>] (igb_probe+0x1088/0x13cc)
[    2.875385][   T32] [<8032ccc8>] (igb_probe) from [<8021f010>]
(pci_device_probe+0xd4/0x15c)
[    2.883862][   T32] [<8021f010>] (pci_device_probe) from
[<8027a034>] (really_probe+0x1f0/0x364)
[    2.892676][   T32] [<8027a034>] (really_probe) from [<8027a328>]
(driver_probe_device+0x60/0x170)
[    2.901663][   T32] [<8027a328>] (driver_probe_device) from
[<802785c0>] (bus_for_each_drv+0x70/0x94)
[    2.910910][   T32] [<802785c0>] (bus_for_each_drv) from
[<80279dd4>] (__device_attach+0xb4/0x11c)
[    2.919917][   T32] [<80279dd4>] (__device_attach) from
[<80213bbc>] (pci_bus_add_device+0x44/0x90)
[    2.928995][   T32] [<80213bbc>] (pci_bus_add_device) from
[<80213c34>] (pci_bus_add_devices+0x2c/0x70)
[    2.938420][   T32] [<80213c34>] (pci_bus_add_devices) from
[<80213c68>] (pci_bus_add_devices+0x60/0x70)
[    2.948007][   T32] ---[ end trace c8de08d4ca07a3ea ]---

with this device tree :
            &pcie {
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_pcie>;
        reset-gpio =<&reset_ic 0 1>;
        child-reset-gpios = <&reset_ic 3 1
                        &reset_ic 2 1
                        &reset_ic 1 1>;
        #gpio-cells = <3>;
        status = "okay";
        fsl,max-link-speed = <2>;

        /*
         * PCI bridge: PLX Technology, Inc. PEX 8605 PCI Express
4-port Gen2 Switch
         * Port 0 to CPU, Port 1 to igb and ports 2 and 3 are accessible through
         * the half and full size mini PCIe slots on the board.
         */
        pcie@1,0 {
                /* Connection to CPU */
                status = "okay";
                fsl,max-link-speed = <2>;
        };

        pcie@2,1 {
                /* Connection to Intel Gigabit Ethernet Controller*/
                status = "okay";
                fsl,max-link-speed = <1>;
                pcie@3,0 {
                        /* The igb */
                        status = "okay";
                        fsl,max-link-speed = <1>;
                        eth0: igb0 {
                                compatible = "intel,igb";
                                /*pinctrl-names = "default";
                                pinctrl-0 = <&pinctrl_enet>;*/
                                phy-mode = "mii";
                                phy-handle = <&eth0>;
                                phy-reset-gpios = <&reset_ic 4 GPIO_ACTIVE_LOW>;
                                phy-reset-duration = <100>;
                                status = "okay";

                                mdio {
                                        #address-cells = <1>;
                                        #size-cells = <0>;
                                        status = "okay";

                                        switch: switch@0 {
                                                compatible ="marvell,mv88e6085";
                                                reg = <0>;
                                                dsa,member = <0 0>;
                                                eeprom-length = <512>;
                                                interrupt-parent = <&gpio2>;
                                                interrupts =
<31IRQ_TYPE_LEVEL_LOW>;
                                                interrupt-controller;
                                                #interrupt-cells = <2>;

                                                ports {
                                                        #address-cells = <1>;
                                                        #size-cells = <0>;

                                                        port@0 {
                                                                reg = <0>;
                                                                label = "port0";

phy-handle = <&switchphy0>;
                                                        };

                                                        port@1 {
                                                                reg = <1>;
                                                                label = "port1";

phy-handle = <&switchphy1>;
                                                        };

                                                        port@2 {
                                                                reg = <2>;
                                                                label = "port0";

phy-handle = <&switchphy2>;
                                                        };

                                                        port@5 {
                                                                reg = <5>;
                                                                label = "cpu";

ethernet = <&eth0>;
                                                        };
                                                };

                                                mdio {
                                                        #address-cells = <1>;
                                                        #size-cells = <0>;
                                                        switchphy0:switchphy@0 {
                                                                reg = <0>;

interrupt-parent = <&switch>;

interrupts =<0 IRQ_TYPE_LEVEL_HIGH>;
                                                        };

                                                        switchphy1:switchphy@1 {
                                                                reg = <1>;

interrupt-parent = <&switch>;

interrupts =<1 IRQ_TYPE_LEVEL_HIGH>;
                                                        };

                                                        switchphy2:switchphy@2 {
                                                                reg = <2>;

interrupt-parent = <&switch>;

interrupts =<2 IRQ_TYPE_LEVEL_HIGH>;
                                                        };
                                                };
                                        };
                                };
