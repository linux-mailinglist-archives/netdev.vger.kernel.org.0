Return-Path: <netdev+bounces-7026-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62AC1719520
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF124281682
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48280D513;
	Thu,  1 Jun 2023 08:12:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE0ABE7F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:12:06 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2085.outbound.protection.outlook.com [40.107.22.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094E912F;
	Thu,  1 Jun 2023 01:12:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKZ7VRvQARdBrRHQCo02/rZssRxCE9MtZSdmrFgoSUFJ8v6EoesRD5gWby6oxbbQxT8vuIv7ZZR2LRV8eyI065yvGi8A9TcY8jsr4h0IO3OWXHEUBCPDZfxL9lz+Tm/EEB58ysTYpSLP5uAeIT456fbiWNTIs2+Aky1uiTzc6zcpLUzGZ89lrYzFjXztCXoFWlE+jFIBkdvmxj13N9SS4XHB8w/f2imYs78Ia49Of/zMOX94kX6ATQ1BjqSNCxoDMYJeD/1Xp7ymy2WNO+84+hLkWKjZkv4KDOIPDXtK39FP0Hr/eYk6a/kJkoYuUCbcMzp7bJl0G3KEic7L71RjRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jilFZmG1Bfom4yOTIX/1xudHi3d/zUFB/dxf3A/NdDc=;
 b=OaR+fqMJVubQim3D8VOzZTQH0mi3bttI2TdlzEWeK3Qq/UzJr366voY6gbBNJl3YbtbOL0/k39RArWwR1nS/37Wc4q6l2ou/F+qnME8nylM6vUE3er5JGj41hIoADNzUKYKiL+XBfKOCvT70Yzplcg3KWGVoX2HWrXKGykHbrE6Jmkemg6yiCFkAo8sMcA0jUjaLrnFFWmiPh55F7PAukuSPzc+vdvpWbHQ37/ouPBwJuw39nj21EGxoCL1muYaMaunGab6UzcEqOd4wkLNbGXnd0STJnCXGnu9zOBtErOuBN7R4eXrd8mvGNKoLPcKHDq1c/kzgFrNEm65FlqsiKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jilFZmG1Bfom4yOTIX/1xudHi3d/zUFB/dxf3A/NdDc=;
 b=ga6ReZbFFHXe6/Y0/2N/p7vm4HG/lFVmdEUYiXwlIKAa9M4eHU1e45fLQvMwQb2JrnPFEOE0R07oT/0tluaSswN/3d8Tc3BOhviuhK4VgdhuA3pGbg2cCRnxX/qxynua7rmu3VPBW61La/cZsgDEWtFymjDQFpfJcumlVVPDfhU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DBAPR04MB7399.eurprd04.prod.outlook.com (2603:10a6:10:1a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Thu, 1 Jun
 2023 08:12:01 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 08:12:01 +0000
Date: Thu, 1 Jun 2023 11:11:56 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
	Liu Peibao <liupeibao@loongson.cn>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: Re: [PATCH pci] PCI: don't skip probing entire device if first fn OF
 node has status = "disabled"
Message-ID: <20230601081156.zyymihd565fscuha@skbuf>
References: <20230531165819.phx7uwlgtvnt3tvb@skbuf>
 <ZHetDo5PozWdtrxP@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHetDo5PozWdtrxP@bhelgaas>
X-ClientProxiedBy: FR3P281CA0190.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DBAPR04MB7399:EE_
X-MS-Office365-Filtering-Correlation-Id: cd8df577-436d-4dd7-566b-08db6277dfea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yDVa2oWlWbkAA03QlQOLglL7nLWEhTSrjHwOoNoqV2dzMTCDq3cDbRfiuQ4oQxABe5ccjaQb1bZFsmztGC+2dHjN0z7Ftd2CbW39pJiG0v+fb8IY6NxsNX6fg/dkgAMM+x2Y+gqEB3dTgOmV8l8vlwUIQceIE8fhlnMKR4Dw/fsD+fS5ODdGml/WOs3Lq7eL8O41RE0Pzm8SVEsOqCK9XLVLVb7fc2vV/nXn8ida6fQkwl6SA9iCwJE9YneF0IN4C/TVqJWFw39/HhZ+Ztun8LJrSxDPW6D+bQ4LPSHSW+r+wHaElOXjQwRx73BbMAFL6J2Uclxh1vQH453SQYmtPxhpVssLk7TWh83E3Ibc23i/WiT+OVZ8rIOTnUz3eRu+gj6Ivj6PwSGcaZxLI8SbSk9L2bVXCDhx50V6RcE6PRxz0GBGnwJy++nAvV3Zz0Rduyw3QmoBrfKiO4me7EBcOf7hnsdWE9iuiqB2qGr8as3cStZFDoZFJmcjBCm6hMwc6tzZe0h3BH24R+QiEsktDkIGebOR5QMdtlvYCNMTMK30SQlEaAUNAwPWHSGOsr4y
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199021)(33716001)(38100700002)(86362001)(66899021)(8936002)(8676002)(41300700001)(7416002)(5660300002)(26005)(44832011)(1076003)(6506007)(6512007)(9686003)(66556008)(2906002)(186003)(83380400001)(6666004)(66476007)(316002)(6486002)(66946007)(478600001)(54906003)(4326008)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0vN4br9sQRWld9dGsUGbryiCTnjqU42L3od8TKm5llxaWeP+8da/U56/UPc9?=
 =?us-ascii?Q?x2dwe7t5rV0RAMer98Lb9XLPhksbbkQbznFrCJgDdHU9Gc3TCYvpuWB8mn8E?=
 =?us-ascii?Q?rxNGchjVj75on291OXpl90ktWmJ3lM6m4qR+hMWQ5b59UWPL9qfeuoWWFD7e?=
 =?us-ascii?Q?+tjZjbihOMqwExv9lOOB5wodHph2ar5omad6mwrhgv05LS+Qk9o4I0mYr501?=
 =?us-ascii?Q?uLJQaLZQpTFkHQNzmbVfLPMJa6CORB0mqBDlCHlJeJEtX7dGLJONMRBosmYF?=
 =?us-ascii?Q?cnFnVjybBugWC/H8zz5nFPhIRrmAhvasRUWeREbEvAE9tUxZf3WIR9e466yf?=
 =?us-ascii?Q?u4tfABA4GrGy2IMX9q3iFYJIEpSbtN7sQtQUQ1kPxnjhJ30WfWQ9005HoqAI?=
 =?us-ascii?Q?FXmvpeFqih3vZyJyAnPaCixowyJwPqDAmDOMKVGcrs7cpxT3mbTD3ga7G2Se?=
 =?us-ascii?Q?mZpBczZvz7mHfpUanvvKVS/ELZlUe/vTrz+3RJqsFH2uVMCzIJ8sLvBMEu5y?=
 =?us-ascii?Q?a1W911yoJDzMeksjqFC9MfTltQt+Fw3K98v/VPqKycH8a0lBYZqrzqGPSZyV?=
 =?us-ascii?Q?/BzYflHOCEt/so8blVYe6nztvqRgbA7GZtMFtd38kiWIcMec62L/6kOu/gYm?=
 =?us-ascii?Q?UBVnI6x1SvuwPpFPOordhXQpaWNX0noHDq9+W0qhImjozmuveiic/G6iVHHn?=
 =?us-ascii?Q?Q+w6/xm8u72nHpoinl9IJifzEZ+slnv3Pf5ayDLv131zELBSrAisDRAcpCln?=
 =?us-ascii?Q?y9sQVV42LQ7BdRm0gcxsXmAEXuwvHKMHd+FEJ0mgYn7kw/xdBJY6h0750ZZa?=
 =?us-ascii?Q?p61xWhagpztM3oBvKsAP0owIAjWFh5g4hRhfB21rO7MDjYQO7MQYXId3qstb?=
 =?us-ascii?Q?7Mxh8JE8RuNYuxcy8wGIBo9+cr2PCLFrx3jKNEfVbGWz8C4R4Az4zwJwIXyH?=
 =?us-ascii?Q?ARV4pwLwdAxrJxlB+tyoGEqEtNL4QyEdA+jXMK7R4JPnop6WCcgFIfxQY2fq?=
 =?us-ascii?Q?OPwiFE5EmXazajaMr9zAJ7xFg/Qhf8O0EqMAQGftP2hnE4l2VehxJ1PUaioI?=
 =?us-ascii?Q?tkFQgBrIEd5hpPEBxBeoqaqvhPqKO49KLgZ9ur2TSJWFHDnW2boU3NfbYgeE?=
 =?us-ascii?Q?EmwJd5CGDQduj0OD+Ti+L6ZLlRWWj7PZRF3F6xO5W1RW/R6XW3nTLSCqgxe+?=
 =?us-ascii?Q?xo+6ahLtZjffmREQQMZ1LA1uYlbTJrQPEcqOwbnlMW6dat7BtdcW3nk1Yl6Y?=
 =?us-ascii?Q?0EYglDcbz01jf8/6oSkXweJR8qnu4sbYe40krFDNi5zOwxZ4gSICUtBF0tPJ?=
 =?us-ascii?Q?KGlF6Mye+uT2c40FJpPv2sXs2WjGoovGgp7mWeA/hGN3Y1yF68w3Wkhy9viw?=
 =?us-ascii?Q?ytthETNZeBnUMfWmq2Cylh/pNSca2tvas/3U7FfEq2PaYDsADllA4TvauoOF?=
 =?us-ascii?Q?6vjFdwVhoz34NHkDQTBJPk5eM7y5py5HV2/F5rwkojq3XIelYeZz6Av8u8mU?=
 =?us-ascii?Q?uRfuh09taCE0XApoZPZq/88BNFru2Tnql5GomSu5g8TuIqRMRK4zCI8Q3a3x?=
 =?us-ascii?Q?Pesnvm/cDr5qEXTAVDEtR8mrtp8wbCtenwDUVOp4eDG5y4Tg8Q8rzL1TZALG?=
 =?us-ascii?Q?sA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8df577-436d-4dd7-566b-08db6277dfea
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 08:12:01.3156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2mwEiYylBgTrneKSI4Gpqo57he/KkFL/UMCXj2UjKrxRfxcBshlDgMuWpnEAzewIupyG41bREBq8/pTkMvbAfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 03:24:46PM -0500, Bjorn Helgaas wrote:
> I guess I should have asked "what bad things happen without this patch
> and without the DT 'disabled' status"?

Well, now that you put it this way, I do realize that things are not so
ideal for me.

Our drivers for the functions of this device were already checking for
of_device_is_available() during probe. So, reverting the core PCIe
patch, they would still not register a network interface, which is good.

However (and this is the bad part), multiple functions of this PCIe
device unfortunately share a common memory, which is not zeroized by
hardware, and so, to avoid multi-bit ECC errors, it must be zeroized by
software, using some memory space accesses from all functions that have
access to that shared memory (every function zeroizes its piece of it).
This, sadly, includes functions which have status = "disabled". See
commit 3222b5b613db ("net: enetc: initialize RFS/RSS memories for unused
ports too").

What we used to do was start probing a bit in enetc_pf_probe(), enable
the memory space, zeroize our part of the shared memory, then check
of_device_is_available() and finally, we disable the memory space again
and exit probing with -ENODEV.

That is not possible anymore with the core patch, because the PCIe core
will not probe our disabled functions at all anymore.

The ENETC is not a hot-pluggable PCIe device. It uses Enhanced Allocation
to essentially describe on-chip memory spaces, which are always present.
So presumably, a different system-level solution to initialize those
shared memories (U-Boot?) may be chosen, if implementing this workaround
in Linux puts too much pressure on the PCIe core and the way in which it
does things. Initially I didn't want to do this in prior boot stages
because we only enable the RCEC in Linux, nothing is broken other than
the spurious AER messages, and, you know.. the kernel may still run
indefinitely on top of bootloaders which don't have the workaround applied.
So working around it in Linux avoids one dependency.

