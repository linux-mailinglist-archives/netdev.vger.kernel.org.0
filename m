Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF136DB0EC
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjDGQup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjDGQun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:50:43 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2067.outbound.protection.outlook.com [40.107.22.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85623BDD7
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 09:50:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U74mabV2UgsfjTRezYU9ahwH/ZXvGs7o/xUjY0X3eqQedCGznkvnYSZymDMpNj9IK82U+N7stMKxrYqhfPec+uqd4y1KyNljIeDpEwmzVzhqMBhpC7dfJG0F2A0zqi+7rdQqznwEghPg8iXn96D/tiY968QV1pAhQAjihGrIiHEHDfgQ6AHAp4jnYs+a1bOhHNg+PSzi9PsCvwQRf8skcEiO5NS6kx2ChOS2GU3dVP3J212N3G8C8wakBjDK9PwyIvKrOD1cN9BDYhaef52ev6beMPlsu3lyDdh5MdXd/Ff7/x/Fwfysaqt6BU3d3BJnqN2Z5jt71IvDrfyGAjDquQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yey/jsJJhwT3G2f+lmgWiKADanYJ57H+tHxXtoyB7dY=;
 b=Ui73tq4n3VrYAAMmsoVbv8216bjotiYm7omPZuDfmLaGLhquJlhPyVWXMWEw/q7wq+Tma73f85rmyHD/aODBeznuCDUAneuADYj/jyMy9QjF8xPEBuopOezpSKiipagWtix3kqVndWfJDj767NdOtHfYxWN5AugmfX1Q+pjxeUotMNuSb+J/xOBGkRqaCJD8WliKHvrSKdo7oYJciVfUBPREK8fGJEArOSKBlsTXktSMB2SGNt2zCM8+/pbFWr2bTrKTh2bx3lMCT6FpAdsuZ3nSI86V4EV0rmt9JLTLZgU4DKabYESGpOI+bUtW8hyrh3dNMyQbXz2tdZ/kd8Eb0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yey/jsJJhwT3G2f+lmgWiKADanYJ57H+tHxXtoyB7dY=;
 b=o2HlgzASh4hE3OgBzIK6L4tpOXYnjFZyN8wrlWvDTZi6j747y4J0XRH+ka5u5pNv7ew5AAp4ILXf5p7q6Z+zeCaMlUvz0V1Ax2IPT68V6NWPMXHJ5AQu2o6aWdrk/SyDqRf5ab0gDYh+WSqNuvR6J/Eu+qq0v3/ivz5lo3yzhGw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8215.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Fri, 7 Apr
 2023 16:50:38 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Fri, 7 Apr 2023
 16:50:38 +0000
Date:   Fri, 7 Apr 2023 19:50:34 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de,
        Russell King <rmk+kernel@armlinux.org.uk>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: dts: imx51: ZII: Add missing phy-mode
Message-ID: <20230407165034.qvmx7algembpsona@skbuf>
References: <20230407152503.2320741-1-andrew@lunn.ch>
 <20230407152503.2320741-2-andrew@lunn.ch>
 <20230407154159.upribliycphlol5u@skbuf>
 <b5e96d31-6290-44e5-b829-737e40f0ef35@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5e96d31-6290-44e5-b829-737e40f0ef35@lunn.ch>
X-ClientProxiedBy: AM0PR04CA0046.eurprd04.prod.outlook.com
 (2603:10a6:208:1::23) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: 70967b77-0290-4edd-9f36-08db378836e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N5ws3N3dxBtV4DB2ZTbiJIMG6x2bh4zQgTrnMOEcsYZaRFezv+s7C/eC2Ue0OMxwWp+46fxRdrhLAIfVXFbR6Q9DHfMZ/kNWSp5OdnlUuzKc57UKvpzcKpdYiIIKtvj5oPqA50uibShzTtiV4gl7R/ug1xwoyQ1FRV3vlY0QNG52/GANjgSLOHVxX87TaIGH71IpQDEnGzlOHBzGJ0IcBmI7BiXu2Qf9KrWM+IDLkgw9G4INNEsdtSkW3iixPYI4lDtALxPSWhqWdfzgIDkVxxmlyTU1tvyvLBomLztRDH+60IorSoVo0PVCjPynAY7qWacb0x72hCDlmDCbKsgj6ns9GfWxDC/RS3EEbi5vl3aBuFSI8KdcP2V8K3nEYq/vaM2eyfG/YrXhsSVn0c1NfjupMJh3lqazPyEhl3BkH4YPNm4a4IEAOPsMJzEcC5/S26FcyUGB8/El8DH0RWAxAMO/GM/9ql7RMFns0oTQgjFBlpJERsLCJ+N533jyqkcLdxDJ24D/gZHU50C6g26+jKSCI8YgvLc7pj2Jklua0T7NhSin+9kiIsCZfWfmZB3+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199021)(38100700002)(54906003)(316002)(83380400001)(33716001)(86362001)(478600001)(186003)(66946007)(66556008)(66476007)(8676002)(6916009)(4326008)(26005)(9686003)(2906002)(6512007)(6506007)(1076003)(6666004)(44832011)(5660300002)(6486002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E2m6qA1Xynmi238cvMsFXDDD5RpRkkc3SkRm4JtMhDmH5CbmPfF+SxCyNT42?=
 =?us-ascii?Q?Ua8+SjZSYthm1nEPQpaHYayKOAfdB5VZek/ylILcESoUk1OOeWiYKhgkCIkv?=
 =?us-ascii?Q?kAoeTLaccCN6LzlJgD9MbPaD5kAV7O/xffmSeL2SLkO5qWCeLX0d3BNwI+va?=
 =?us-ascii?Q?GVNAsoKaYGHW2yomzvfWFPT9nXSRh6bfckVi1oR2X1xEYnGafCuMlIPM+ecP?=
 =?us-ascii?Q?4fOep0OzZxVTc8ymhhezySTFZwl6p0i25P12ZYlO0MWpGSdyS4m5N4FlEech?=
 =?us-ascii?Q?5H7HR9leplkJIiT7XPp9m15GZzbbKuGkijYW3ddWoHrK40fxSqAcBAMdjbx7?=
 =?us-ascii?Q?ONR/nVC+H1ysczVq2/nRyJMEBCtgXn4Nr9tVCSx5pWBrujrpuMr32VvVMyte?=
 =?us-ascii?Q?HzAVfcY21d9pEL30aRiBbXgaxUN5NKySjorzKLOxa/Ko6F3N5Ef753elQPAc?=
 =?us-ascii?Q?NeRTPpZ5Tg45ioY9KuhSnVWnqhoswyNTyAUoxUfY2hRaXAXWLXmDUrhLDPYn?=
 =?us-ascii?Q?X2UIelf4W9Ifj85wlsgaKWNx7FwibUYigEmaFsB8WG6tbsaVSCs15kpKr72j?=
 =?us-ascii?Q?xfa9wybj9keXHbqtAVhnl480c8LvBc6KAq/kjv3p3LCHI9sid0O6nj/YGk52?=
 =?us-ascii?Q?EVuCMjuODxfdq7bT+uDVOHfVdjrKQa53+Uvbe0orlx7tk8jDQscves4YMbTP?=
 =?us-ascii?Q?gBK4cHJbXPYzan0aGDT6WrIABje/m4e0avXGiusNYXO2LDinXTLXJ/jQHJeO?=
 =?us-ascii?Q?jbLLsMGMws6fS2FEUjQxYe7bhJFix5gdyaKo83B+ffQkNXgQtuPsHgZOI3Jd?=
 =?us-ascii?Q?XZ9uABncYzlggAka7QJGdl+TVMUog3/2zAl4fYG+LmHnPF09EEWBhrKMSunk?=
 =?us-ascii?Q?3v5FNbCL7SGDgg7Bbv7Ioqdd0pvEWLZXJUM7K3sNBMrnzpjEXxcXtiEzPQA3?=
 =?us-ascii?Q?18FK1TzJtiYJOwUvxe88UgYFrUu1OXu1yUrdHVqfvsEchQOLR/blSofYJv4p?=
 =?us-ascii?Q?uHI1USFdUpjtUSeERenYXV6+8cwbVtkUOT6JI/WnkHd966+lUkOzfef7Xg5D?=
 =?us-ascii?Q?aZ/WvLX9LDD9ZFXN3JzCuvXHjDqmfTQSunQA1OTYAlic3e3oxd7ZyBaenqL2?=
 =?us-ascii?Q?/zj8FK7W8YfHsC+KM1Ns9NJKLNegqDAj9v63TQgn4Gmi6MVfbtHMPnn7RYX4?=
 =?us-ascii?Q?XZxDsSoevmPCjN/hvSKDM7Www0YtY/OewlLR93uuvi+fpzdrls6ymKVCeg3J?=
 =?us-ascii?Q?8z0DqK0KeFLbnFFccp5QnYgA9BQrymRo54h6KcBFKN68Kzf8Pq/LiNOfiMoM?=
 =?us-ascii?Q?cvVWkHIlMru0dhm4fb8j1a+IIIwJP8NZJhzSDetgLf0CIa90bumsppaaej5i?=
 =?us-ascii?Q?RY2Dge+jlH4U2bg4zeVy3d2QXNZEJt+rsC9ZIkMjd+PzjGaqWLUf9zwJzkMC?=
 =?us-ascii?Q?NMD2syc1XLwoAlXOm51GIwCX+PSkr5sH8p777Ap/2wvUWNwBdaCajtgQzX2x?=
 =?us-ascii?Q?WOWO50xC7Rb4lCs63tJLy9+BhwMj/UouJcYODD1NVZ9Hu/IwtqXC2O8MU6O/?=
 =?us-ascii?Q?Tjfhnd06VrpCDIHh1TCF39e7n83UMc4qe9Mzv8G6wfczZ9ywlR2Bktvw43GQ?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70967b77-0290-4edd-9f36-08db378836e0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 16:50:38.0703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h8OPl6X4w7YU2+4rfg5GGAYkW2FM99frMyf11ABUHyoIOvMiPAHDebBqGhm1HSUhCBgcIk2Xec+IDps3WI89pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8215
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 06:10:31PM +0200, Andrew Lunn wrote:
> On Fri, Apr 07, 2023 at 06:41:59PM +0300, Vladimir Oltean wrote:
> > On Fri, Apr 07, 2023 at 05:25:01PM +0200, Andrew Lunn wrote:
> > > The DSA framework has got more picky about always having a phy-mode
> > > for the CPU port. The imx51 Ethernet supports MII, and RMII. Set the
> > > switch phy-mode based on how the SoC Ethernet port has been
> > > configured.
> > > 
> > > Additionally, the cpu label has never actually been used in the
> > > binding, so remove it.
> > > 
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > > ---
> > 
> > In theory, an MII MAC-to-MAC connection should have phy-mode = "mii" on
> > one end and phy-mode = "rev-mii" on the other, right?
> 
> In theory, yes. As far as i understand, it makes a difference to where
> the clock comes from. rev-mii is a clock provider i think.
> 
> But from what i understand of the code, and the silicon, this property
> is going to be ignored, whatever value you give it. phy-mode is only
> used and respected when the port can support 1000Base-X, SGMII, and
> above, or use its built in PHY. For MII, GMII, RMII, RGMII the port
> setting is determined by strapping resistors.

If it's ignored, even better, one more reason to make it rev-mii and
not mii, no compatibility concerns with the driver not understanding the
difference...

> The DSA core however does care that there is a phy-mode, even if it is
> ignored. I hope after these patches land we can turn that check into
> enforce mode, and that then unlocks Russell to make phylink
> improvement.
> 
> 	Andrew
>
