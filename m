Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35C1699303
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 12:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjBPLU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 06:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjBPLU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 06:20:27 -0500
Received: from mail.kernel-space.org (unknown [IPv6:2a01:4f8:c2c:5a84::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B00B37736
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 03:20:22 -0800 (PST)
Received: from ziongate (localhost [127.0.0.1])
        by ziongate (OpenSMTPD) with ESMTP id d61b2bde;
        Thu, 16 Feb 2023 11:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=kernel-space.org; h=
        message-id:date:mime-version:subject:to:cc:references:from
        :in-reply-to:content-type:content-transfer-encoding; s=default;
         bh=cdR/j3vsuj7Ue3S7Sa4y8yyv66U=; b=ovD9FAeQ/p4xljgU9e1LG5DzhRbR
        cTv3dWcMmX8TvQPyU9qF+uNT3zRQ5NdODxeYqDCEt5wSben1O1qjozY2nse/C1pq
        IvcYwWt6Pq5VquYD0TOF+lMhdcOooZuEkvibwZyHkRsuQSc+DGN7BDPv6T5HJf7b
        Exty5HyR8nC4SCk=
DomainKey-Signature: a=rsa-sha1; c=simple; d=kernel-space.org; h=
        message-id:date:mime-version:subject:to:cc:references:from
        :in-reply-to:content-type:content-transfer-encoding; q=dns; s=
        default; b=Jltxbjf/YTKH7fcF5nxbpjH/iRpAfbDm8GRctNsmz1Z7HL7HRWIxK
        FHMhDEHW2HBrpl1tah/6koWyom1hxxcBD9/AUs9P0DkRLf+0g4jMVT/LAEoqX/CS
        5qKkF5dBoXKNaA6CoLNetDVko1FDBnbSlbyIM70qLksyPT6su3yK38=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1676546420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5oOudQCCvyGO5QxDtt6SPs3RKXTUPRs1FYAlugRpso4=;
        b=uBBGoXupOKS94dS2fsrW7Kt87LSz+z2XROLFPw0+mSglPXyge6CWoNuyFhTWQdWtC1vXc7
        5ck0Zv+wF1/dmsJyOA0CRwAEg6FvqvzO7w7vL8F5WQsN1VPiEDfxTFD9X6Dt1W6qW6DutR
        6PqjXY3eN+sVFM7CYlJsa3p3ajD+zIc=
Received: from [192.168.0.2] (host-87-15-216-95.retail.telecomitalia.it [87.15.216.95])
        by ziongate (OpenSMTPD) with ESMTPSA id 2ee81474 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 16 Feb 2023 11:20:19 +0000 (UTC)
Message-ID: <7e379c00-ceb8-609e-bb6d-b3a7d83bbb07@kernel-space.org>
Date:   Thu, 16 Feb 2023 12:20:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: mv88e6321, dual cpu port
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
References: <Y7yIK4a8mfAUpQ2g@lunn.ch>
 <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org>
 <20230110222246.iy7m7f36iqrmiyqw@skbuf> <Y73ub0xgNmY5/4Qr@lunn.ch>
 <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
 <20230123112828.yusuihorsl2tyjl3@skbuf>
 <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
 <20230123191844.ltcm7ez5yxhismos@skbuf> <Y87pLbMC4GRng6fa@lunn.ch>
 <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
 <Y8/jrzhb2zoDiidZ@lunn.ch>
From:   Angelo Dureghello <angelo@kernel-space.org>
In-Reply-To: <Y8/jrzhb2zoDiidZ@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 24/01/23 2:57 PM, Andrew Lunn wrote:

 > With todays mainline i would do:
 >
 > So set eth0 as DSA master port.
 >
 > Create a bridge br0 with ports 0, 1, 2.
 > Create a bridge br1 with ports 3, 4, 6.
 >
 > You don't actually make use of the br1 interface in Linux, it just
 > needs to be up. You can think of eth1 being connected to an external
 > managed switch.
 >
 > 	Andrew

i upgraded to kernel 5.15.32, tried your option above.

In my initial request i inverted port 5
and 6 but i think this shouldn't matter.

Still data passes all trough port6, even when i ping from
host PC to port4. I was expecting instead to see port5
statistics increasing.

This is the script and the scheme i need:

#!/bin/sh
#
# Configuration:
#                                       +---- port0
#              br0 eth0  <->   port 6  -+---- port1
#                                       +---- port2
#
#                                       +---- port3
#              br1 eth1  <-> --------- -+-----port4
#                                       +---- port5
#
# tested, port4 ping, data passes always from port 6
#

ip link set eth0 up
ip link set eth1 up

# bring up the slave interfaces
ip link set port0 up
ip link set port1 up
ip link set port2 up
ip link set port3 up
ip link set port4 up
ip link set port5 up

# create bridge
ip link add name br0 type bridge
ip link add name br1 type bridge

# add ports to bridge
ip link set dev port0 master br0
ip link set dev port1 master br0
ip link set dev port2 master br0

ip link set dev port3 master br1
ip link set dev port4 master br1
ip link set dev port5 master br1

# configure the bridge
ip addr add 192.0.2.1/25 dev br0
ip addr add 192.0.2.129/25 dev br1

# bring up the bridge
ip link set dev br0 up
ip link set dev br1 up

And device tree:

&fec1 {
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_fec1>;
	phy-mode = "rgmii";
	/* fsl,magic-packet; */
	tx-internal-delay-ps = <2000>;
	rx-internal-delay-ps = <2000>;

	status = "okay";

	fixed-link {
		speed = <1000>;
		full-duplex;
	};

	mdio {
		#address-cells = <1>;
		#size-cells = <0>;

		switch1: switch1@1d {
			compatible = "marvell,mv88e6085";
			reg = <0x1d>;
			interrupt-parent = <&lsio_gpio3>;
			interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
			interrupt-controller;
			#interrupt-cells = <2>;

			ports {
				#address-cells = <1>;
				#size-cells = <0>;

				port@0 {
					reg = <0>;
					label = "port0";
					phy-mode = "1000base-x";
					managed = "in-band-status";
					sfp = <&sfp_0>;
				};
				port@1 {
					reg = <1>;
					label = "port1";
					phy-mode = "1000base-x";
					managed = "in-band-status";
					sfp = <&sfp_1>;
				};
				/* This is phyenet0 now */
				port@2 {
					reg = <2>;
					label = "port2";
					phy-handle = <&switchphy2>;
				};
				port@6 {
					/* wired to cpu fec1 */
					reg = <6>;
					label = "cpu";
					ethernet = <&fec1>;
					phy-mode = "rgmii";
					fixed-link {
						speed = <1000>;
						full-duplex;
					};
				};
				port@3 {
					/* phy is internal to the switch */
					reg = <3>;
					label = "port3";
					phy-handle = <&switchphy3>;
				};
				port@4 {
					/* phy is internal to the switch */
					reg = <4>;
					label = "port4";
					phy-handle = <&switchphy4>;
				};
				port@5 {
					/* wired to cpu fec2 */
					reg = <5>;
					label = "port5";
					phy-mode = "rmii";
					fixed-link {
						speed = <100>;
						full-duplex;
					};
				};
			};

			mdio {
				#address-cells = <1>;
				#size-cells = <0>;

				switchphy2: switchphy@2 {
					reg = <0x2>;
				};

				switchphy3: switchphy@3 {
					reg = <0x3>;
				};

				switchphy4: switchphy@4 {
					reg = <0x4>;
				};
			};
		};
	};
};

In any hint, welcome,

Thanks a lot,
-- 
Angelo Dureghello
+++ kernelspace +++
+E: angelo AT kernel-space.org
+W: www.kernel-space.org
