Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0FA60E5B9
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 18:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbiJZQs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 12:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbiJZQsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 12:48:50 -0400
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2110.outbound.protection.outlook.com [40.107.103.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B767CFE903;
        Wed, 26 Oct 2022 09:48:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AppHJgxFSCI3TqiYm/0EsJicNkaAlSFd+7I3DwCA+ZO3qZSa4Rv8SrR0fauKdi+L6m6P2Q/XK/fuNTi980gCrX2c9boJSScK4TXgDNZj2SgQpcHbx2VdihTMMD+p/f5P4MvQOc3k5gTHqsrE4O26WIWArWA/J3+pxsx+aJSjQ7p+TpR++OSVX3DMGmVpWWTnTdsAo7DSLg/BWHYkl6W7ySpJaT+UNSvFPg+uskaxT+siOiWC9U3AYBuLvqJXIGq6s/jZu/hbPA7t/gc8HkCaQ9oCrW5aNDSqk9kxAXj0NVYKjlDbLs5K1muEmCXpOpLFAaVQ//tBpU/vOAoY9QLCNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SpiK7yip1z8BavcW84Erh8rxBs5tmamxORWX032jlY=;
 b=HZUvg37PLARHhzI9rTpCLdNZ2/YbO6VodpcqHWI1diVlwkTDhD9jBcKdsPe+2eLuFYrsi7oeyp4NFrFCSMJOrHL28jLxjXz3gIuGccQOalkzb2rSvaYeg6bgOYEtu1Z3l5P0iGWp+UrgZg1jI8eqVBt4EV6hsTlwWrujl5FHf3JuVttXQeIWJFqFlkHxDjqzc9tvcJw/YxN3IlTc7FKdI1K1D6Vn65aH42dvQ13AFrOu2uI4Ls86r7wmn5SQSGM0REBK8MAbL9Nu/ln2omoXDujKFvlqWY3Onc9SfXdOXtND6ANdJHD11z6tqAa/J3ptGG8QjSP1Clh4Wk1edmA78A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 217.111.95.7) smtp.rcpttodomain=microchip.com smtp.mailfrom=arri.de;
 dmarc=none action=none header.from=arri.de; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrigroup.onmicrosoft.com; s=selector1-arrigroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SpiK7yip1z8BavcW84Erh8rxBs5tmamxORWX032jlY=;
 b=Gx+xtkgkBqfFTRHWbFE5cslHQlGPAH7JjhE5uIMqb/er+/6VfsTfQfmcAraGZ714WP7i1SMtgDuViCTNbq3xEWIBtgCRYRnKwQaxBkjhfFkGwhfwYgHaY39L/dkdnjCS7plSiutNyPLUoGKYX8O5ZsGFTmDc2UuVqTsZY5BCLB8=
Received: from AS9PR01CA0021.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:540::27) by AM9PR07MB7107.eurprd07.prod.outlook.com
 (2603:10a6:20b:2d3::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.13; Wed, 26 Oct
 2022 16:48:43 +0000
Received: from AM0EUR02FT020.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:20b:540:cafe::ed) by AS9PR01CA0021.outlook.office365.com
 (2603:10a6:20b:540::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28 via Frontend
 Transport; Wed, 26 Oct 2022 16:48:43 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 217.111.95.7)
 smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arri.de;
Received-SPF: Fail (protection.outlook.com: domain of arri.de does not
 designate 217.111.95.7 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.111.95.7; helo=mta.arri.de;
Received: from mta.arri.de (217.111.95.7) by
 AM0EUR02FT020.mail.protection.outlook.com (10.13.54.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5769.14 via Frontend Transport; Wed, 26 Oct 2022 16:48:43 +0000
Received: from N95HX1G2.arri.de (192.168.54.45) by mta.arri.de (10.10.18.5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.32; Wed, 26 Oct
 2022 18:48:42 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     <ceggers@arri.de>, <Arun.Ramadoss@microchip.com>,
        <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>, <b.hutchman@gmail.com>
Subject: Re: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support for LAN937x switch
Date:   Wed, 26 Oct 2022 18:47:53 +0200
Message-ID: <20221026164753.13866-1-ceggers@arri.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <d8459511785de2f6d503341ce5f87c6e6064d7b5.camel@microchip.com>
References: <d8459511785de2f6d503341ce5f87c6e6064d7b5.camel@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [192.168.54.45]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0EUR02FT020:EE_|AM9PR07MB7107:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ca0d98e-3524-49d1-8391-08dab771f172
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lt2vjgo3vp810f85pUnzu6HlMT7VlqM1oFVqMnkbYmOmhkrlO3Tr7r9SEuZVPyB83/qADjwQaMwSRfS+FRFZzFGJFpM406F5dHDJDEmpleQkwK2gDjB+Rb/g+JkZ78mkO7tjqojvNWNmzrt37XauRoWW2EFLHe4J+zu/xfynQAg7s2bHwZ1wcmHbfgAmikepmAEiwYIGu4WvtAlF5BBljZWGGdRmxtgpI1T91DqjmCKJlP6Yv6oobb8lBs7JrXxOzL6+NRwf1mSC6r0Qrl6yqXFtSaPJ4v5jM9sY1fwHZAVsnsSj/Ty7LdKIQ2C586bisjIlSEnvTmpWAOYXW6W003mTyoLn73t6IoH3eN0VAVYedIckgMywsUDK0tNfr+cdknCsBVGC4QhThki1zH7LoVjtrW/xo/+Qk/1LUneFq+s+xBXGpXenaGr7B3YewdPLHqfVeDAKycjuKH4jLjUDipau82vtiBLC4Ukv2bCB1GWQIfebEZl5F6FB24adJ2XtPcLP2jeIMlspQTzxdldg55jgPnQgFM/kYY7Az4TIsVDWMVUFgoO9CidtMG8AmttPhkZZRgzYguoSENl8aNzgzVHEqrpAmFom0kseu/uAqJpZ0llha1mZ2MqwEYbJ6cWyQlyGyoEXl0DOlPrj28rFXcJs4TpzLRahbOfvc3p6DTvxCyEoaIqGPxAvBQ6ieQRusK/XQFy9Rp5q+CvfA+ebR8qwvtc6GiDJkx/DecWVVJoUXR38uywCGLoTse86aoW2Z4qKlr3Ws8b4pQvhIEm9FT9SEoXSXVdHUwN/xsWKgtQtpjsdPANRpxpkt9MytEY0
X-Forefront-Antispam-Report: CIP:217.111.95.7;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(376002)(346002)(396003)(136003)(451199015)(46966006)(36840700001)(107886003)(26005)(6666004)(7696005)(2616005)(82310400005)(2906002)(36860700001)(1076003)(36756003)(186003)(4001150100001)(54906003)(5660300002)(316002)(4326008)(110136005)(478600001)(83380400001)(16526019)(8676002)(30864003)(70586007)(70206006)(336012)(41300700001)(40480700001)(86362001)(8936002)(82740400003)(450100002)(426003)(81166007)(47076005)(356005)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 16:48:43.6035
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca0d98e-3524-49d1-8391-08dab771f172
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.7];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource: AM0EUR02FT020.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR07MB7107
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun, hi Vladimir,

On Tuesday, 18 October 2022, 15:42:41 CEST, Arun.Ramadoss@microchip.com wrote:
> ...
> Thanks Vladimir. I will wait for Christian feedback.
> 
> Hi Christian,
> To test this patch on KSZ9563, we need to increase the number of
> interrupts port_nirqs in KSZ9893 from 2 to 3. Since the chip id of
> KSZ9893 and KSZ9563 are same, I had reused the ksz_chip_data same for
> both chips. But this chip differ with number of port interrupts. So we
> need to update it. We are generating a new patch for adding the new
> element in the ksz_chip_data for KSZ9563.
> For now, you can update the code as below for testing the patch

today I hard first success with your patch series on KSZ9563! ptp4l reported
delay measurements between switch port 1 and the connected Meinberg clock:

> ptp4l[75.590]: port 2: new foreign master ec4670.fffe.0a9dcc-1
> ptp4l[79.590]: selected best master clock ec4670.fffe.0a9dcc
> ptp4l[79.590]: updating UTC offset to 37
> ptp4l[79.591]: port 2: LISTENING to UNCALIBRATED on RS_SLAVE
> ptp4l[81.114]: port 2: delay timeout
> ptp4l[81.117]: delay   filtered        338   raw        338
> ptp4l[81.118]: port 2: minimum delay request interval 2^1
> ptp4l[81.434]: port 1: announce timeout
> ptp4l[81.434]: config item lan0.udp_ttl is 1
> ptp4l[81.436]: config item (null).dscp_event is 0
> ptp4l[81.437]: config item (null).dscp_general is 0
> ptp4l[81.437]: selected best master clock ec4670.fffe.0a9dcc
> ptp4l[81.438]: updating UTC offset to 37
> ptp4l[81.843]: master offset         33 s0 freq   +6937 path delay       338
> ptp4l[82.844]: master offset         26 s2 freq   +6930 path delay       338
> ptp4l[82.844]: port 2: UNCALIBRATED to SLAVE on MASTER_CLOCK_SELECTED
> ptp4l[83.844]: master offset         32 s2 freq   +6962 path delay       338
> ptp4l[84.844]: master offset          3 s2 freq   +6943 path delay       338
> ptp4l[85.844]: master offset        -14 s2 freq   +6927 path delay       338
> ptp4l[86.042]: port 2: delay timeout
> ptp4l[86.045]: delay   filtered        336   raw        335
> ptp4l[86.211]: port 2: delay timeout
> ptp4l[86.213]: delay   filtered        335   raw        331
> ptp4l[86.844]: master offset          3 s2 freq   +6939 path delay       335
> ptp4l[87.847]: master offset         -7 s2 freq   +6930 path delay       335

As a next step I'll try to configure the external output for 1PPS. Is this
already implemented in your patches? The file /sys/class/ptp/ptp2/n_periodic_outputs
shows '0' on my system.

BTW: Which is the preferred delay measurement which I shall test (E2E/P2P)? I
started with E2E is this was configured in the hardware and needs no 1-step
time stamping, but I had to add PTP_MSGTYPE_DELAY_REQ in ksz_port_txtstamp().

On Tuesday, 25 October 2022, 05:41:26 CEST, Arun.Ramadoss@microchip.com wrote:
> On Sun, 2022-10-23 at 22:15 +0200, Christian Eggers wrote:
> > ...
> > After applying the patch series, I had some trouble with linking. I
> > had
> > configured nearly everything as a module:
> > 
> > CONFIG_PTP_1588_CLOCK=m
> > CONFIG_NET_DSA=m
> > CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON=m [ksz_switch.ko]
> > CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C=m
> > CONFIG_NET_DSA_MICROCHIP_KSZ_PTP=y [builtin]
> > 
> > With this configuration, kbuild doesn't even try to compile
> > ksz_ptp.c:
> > 
> > ERROR: modpost: "ksz_hwtstamp_get"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_hwtstamp_set"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_port_txtstamp"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_ptp_clock_register"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_port_deferred_xmit"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_ptp_clock_unregister"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_ptp_irq_free"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_tstamp_reconstruct"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_get_ts_info"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_ptp_irq_setup"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > 
> > After setting all of the above to 'y', the build process works (but I
> > would prefer
> > being able to build as modules). 
> 
> May be this is due to kconfig of config_ksz_ptp  defined bool instead
> of tristate. Do I need to change the config_ksz_ptp to tristate in
> order to compile as modules?
I'm not an expert for kbuild and cannot tell whether it's allowed to use
bool options which depend on tristate options. At least ksz_ptp.c is compiled
by kbuild if tristate is used. But I needed to add additional EXPORT_SYMBOL()
statements for all non-static functions (see below) for successful linking.

I'm unsure whether it makes sense to build ksz_ptp as a separate module.
Perhaps it should be (conditionally) added to ksz_switch.ko.

On Tuesday, 18 October 2022, 08:44:04 CEST, Arun.Ramadoss@microchip.com wrote:
> I had developed this patch set to add gPTP support for LAN937x based on
> the Christian eggers patch for KSZ9563.
Maybe this could be mentioned somewhere (e.g. extra line in file header of
ksz_ptp.c).  It took a lot of effort (for me) to get this initially running
(e.g. due to limited documentation / support by Microchip).  But I'm quite happy
that this is continued now as it is likely that I'll need PTP support for the
KSZ9563 soon.

For KSZ9563, we will need support for 1-step time stamping as two-step
is not possible.

I've stashed all my local changes into an additional patch (see below).
Please feel free to integrate this into your series.  As soon I get 1PPS
running, I'll continue testing.  Note that I'll be unavailable between Friday
and next Tuesday.

regards,
Christian
---
 drivers/net/dsa/microchip/Kconfig       |  2 +-
 drivers/net/dsa/microchip/ksz9477_i2c.c |  2 +
 drivers/net/dsa/microchip/ksz_common.c  |  2 +-
 drivers/net/dsa/microchip/ksz_ptp.c     | 13 +++++-
 net/dsa/tag_ksz.c                       | 60 +++++++++++++++++++++++--
 5 files changed, 73 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index 1e9712ff64e2..ac34c01f39a6 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -22,7 +22,7 @@ config NET_DSA_MICROCHIP_KSZ_SPI
 	  Select to enable support for registering switches configured through SPI.
 
 config NET_DSA_MICROCHIP_KSZ_PTP
-	bool "Support for the PTP clock on the KSZ9563/LAN937x Ethernet Switch"
+	tristate "Support for the PTP clock on the KSZ9563/LAN937x Ethernet Switch"
 	depends on NET_DSA_MICROCHIP_KSZ_COMMON && PTP_1588_CLOCK
 	help
 	  This enables support for timestamping & PTP clock manipulation
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 3763930dc6fc..7eb7d887bf43 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -41,6 +41,8 @@ static int ksz9477_i2c_probe(struct i2c_client *i2c,
 	if (i2c->dev.platform_data)
 		dev->pdata = i2c->dev.platform_data;
 
+	dev->irq = i2c->irq;
+
 	ret = ksz_switch_register(dev);
 
 	/* Main DSA driver may not be started yet. */
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 889b3d398def..679c66f1e420 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1266,7 +1266,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
-		.port_nirqs = 2,
+		.port_nirqs = 3,
 		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index d11a490a6c87..6e6814286dec 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -68,6 +68,7 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
 
 	return 0;
 }
+EXPORT_SYMBOL(ksz_get_ts_info);
 
 int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
 {
@@ -90,6 +91,7 @@ int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
 	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
 		-EFAULT : 0;
 }
+EXPORT_SYMBOL(ksz_hwtstamp_get);
 
 static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
 				   struct hwtstamp_config *config)
@@ -106,7 +108,7 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
 	case HWTSTAMP_TX_OFF:
 		prt->hwts_tx_en = false;
 		break;
-	case HWTSTAMP_TX_ON:
+	case HWTSTAMP_TX_ONESTEP_P2P:
 		prt->hwts_tx_en = true;
 		break;
 	default:
@@ -162,6 +164,7 @@ int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 	mutex_unlock(&ptp_data->lock);
 	return ret;
 }
+EXPORT_SYMBOL(ksz_hwtstamp_set);
 
 void ksz_port_txtstamp(struct dsa_switch *ds, int port,
 		       struct sk_buff *skb)
@@ -187,6 +190,7 @@ void ksz_port_txtstamp(struct dsa_switch *ds, int port,
 	ptp_msg_type = ptp_get_msgtype(hdr, type);
 
 	switch (ptp_msg_type) {
+	case PTP_MSGTYPE_DELAY_REQ:
 	case PTP_MSGTYPE_PDELAY_REQ:
 	case PTP_MSGTYPE_PDELAY_RESP:
 	case PTP_MSGTYPE_SYNC:
@@ -202,6 +206,7 @@ void ksz_port_txtstamp(struct dsa_switch *ds, int port,
 
 	KSZ_SKB_CB(skb)->clone = clone;
 }
+EXPORT_SYMBOL(ksz_port_txtstamp);
 
 /* These are function related to the ptp clock info */
 static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
@@ -436,6 +441,7 @@ ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp)
 
 	return timespec64_to_ktime(ts);
 }
+EXPORT_SYMBOL(ksz_tstamp_reconstruct);
 
 static void ksz_ptp_txtstamp_skb(struct ksz_device *dev,
 				 struct ksz_port *prt, struct sk_buff *skb)
@@ -479,6 +485,7 @@ void ksz_port_deferred_xmit(struct kthread_work *work)
 
 	kfree(xmit_work);
 }
+EXPORT_SYMBOL(ksz_port_deferred_xmit);
 
 static const struct ptp_clock_info ksz_ptp_caps = {
 	.owner		= THIS_MODULE,
@@ -524,6 +531,7 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
 	ptp_clock_unregister(ptp_data->clock);
 	return ret;
 }
+EXPORT_SYMBOL(ksz_ptp_clock_register);
 
 void ksz_ptp_clock_unregister(struct dsa_switch *ds)
 {
@@ -535,6 +543,7 @@ void ksz_ptp_clock_unregister(struct dsa_switch *ds)
 
 	ptp_clock_unregister(ptp_data->clock);
 }
+EXPORT_SYMBOL(ksz_ptp_clock_unregister);
 
 static irqreturn_t ksz_ptp_msg_thread_fn(int irq, void *dev_id)
 {
@@ -734,6 +743,7 @@ int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
 
 	return ret;
 }
+EXPORT_SYMBOL(ksz_ptp_irq_setup);
 
 void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p)
 {
@@ -749,6 +759,7 @@ void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p)
 
 	irq_domain_remove(ptpirq->domain);
 }
+EXPORT_SYMBOL(ksz_ptp_irq_free);
 
 MODULE_AUTHOR("Arun Ramadoss <arun.ramadoss@microchip.com>");
 MODULE_DESCRIPTION("PTP support for KSZ switch");
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 582add3398d3..e7680718b478 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -251,17 +251,69 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9477);
 #define KSZ9893_TAIL_TAG_OVERRIDE	BIT(5)
 #define KSZ9893_TAIL_TAG_LOOKUP		BIT(6)
 
+/* Time stamp tag is only inserted if PTP is enabled in hardware. */
+static void ksz9893_xmit_timestamp(struct sk_buff *skb)
+{
+//	struct sk_buff *clone = KSZ9477_SKB_CB(skb)->clone;
+//	struct ptp_header *ptp_hdr;
+//	unsigned int ptp_type;
+	u32 tstamp_raw = 0;
+	put_unaligned_be32(tstamp_raw, skb_put(skb, KSZ9477_PTP_TAG_LEN));
+}
+
+/* Defer transmit if waiting for egress time stamp is required.  */
+static struct sk_buff *ksz9893_defer_xmit(struct dsa_port *dp,
+					  struct sk_buff *skb)
+{
+	struct ksz_tagger_data *tagger_data = ksz_tagger_data(dp->ds);
+	struct ksz_tagger_private *priv = ksz_tagger_private(dp->ds);
+	void (*xmit_work_fn)(struct kthread_work *work);
+	struct sk_buff *clone = KSZ_SKB_CB(skb)->clone;
+	struct ksz_deferred_xmit_work *xmit_work;
+	struct kthread_worker *xmit_worker;
+
+	if (!clone)
+		return skb;  /* no deferred xmit for this packet */
+
+	xmit_work_fn = tagger_data->xmit_work_fn;
+	xmit_worker = priv->xmit_worker;
+
+	if (!xmit_work_fn || !xmit_worker)
+		return NULL;
+
+	xmit_work = kzalloc(sizeof(*xmit_work), GFP_ATOMIC);
+	if (!xmit_work)
+		return NULL;
+
+	kthread_init_work(&xmit_work->work, xmit_work_fn);
+	/* Increase refcount so the kfree_skb in dsa_slave_xmit
+	 * won't really free the packet.
+	 */
+	xmit_work->dp = dp;
+	xmit_work->skb = skb_get(skb);
+
+	kthread_queue_work(xmit_worker, &xmit_work->work);
+
+	return NULL;
+}
+
 static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct ksz_tagger_private *priv;
 	u8 *addr;
 	u8 *tag;
 
+	priv = ksz_tagger_private(dp->ds);
+
+	/* Tag encoding */
+	if (test_bit(KSZ_HWTS_EN, &priv->state))
+		ksz9893_xmit_timestamp(skb);
+
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
 		return NULL;
 
-	/* Tag encoding */
 	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
 	addr = skb_mac_header(skb);
 
@@ -270,7 +322,7 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 	if (is_link_local_ether_addr(addr))
 		*tag |= KSZ9893_TAIL_TAG_OVERRIDE;
 
-	return skb;
+	return ksz9893_defer_xmit(dp, skb);
 }
 
 static const struct dsa_device_ops ksz9893_netdev_ops = {
@@ -278,7 +330,9 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_KSZ9893,
 	.xmit	= ksz9893_xmit,
 	.rcv	= ksz9477_rcv,
-	.needed_tailroom = KSZ_INGRESS_TAG_LEN,
+	.connect = ksz_connect,
+	.disconnect = ksz_disconnect,
+	.needed_tailroom = KSZ_INGRESS_TAG_LEN + KSZ9477_PTP_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(ksz9893_netdev_ops);
-- 
2.35.3

