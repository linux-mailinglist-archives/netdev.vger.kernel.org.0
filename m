Return-Path: <netdev+bounces-6177-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0387150B6
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 22:48:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F092280F50
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 20:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 346BB1094D;
	Mon, 29 May 2023 20:48:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA71C2F3
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 20:48:16 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D729C7;
	Mon, 29 May 2023 13:48:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+NF1NQLIO+2xuEmdMyZeDzCRbAsOvC7O3Zlf/RtiBT20WCXw7oN90o57e8iiFfuyNnqXDCYG5ZrOYylRTQJZrT07PnVZFJSGwYSnqn5UvvI0DxI8vwHFi177bovGTaDxaspxdf67uRbY3AwOTU0HowDWHFTdA5kpDii3R3pLMhifig9Emho1H7EjcwOsh5Hnj1f+pjGNahWA0DSLHC/FsHZXzcilLe2ldkkG0+Aic0B7A1eqEJpVcTCfOYz57IgdB4KvNcEN1HiIApwwQoXKB1MGh/Io3hsV/Mc7oVcADDYyXzRmXBIQ6QB0MqnwINx0a40iyez+7Jd8rcrMIZOFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yh+HjzpDilKdeOeetgB5Qv2okDjMkRled+EY/Gc3QXo=;
 b=lw0yAVxHPM9jYxYDnlm7KM67Ui7AxnV5kSDmMhO/dxxNM3L/VtAWKdyntLndELM36+kPpAPkDVzT3cs4i0g4iBzayElkwmx8eXK5cXp4jb7CmSfwuEa0SmgXB/1+s1m3SLoPWvCjt/VRWtIhw1fbl8cI2hlOzOSU9t7ylfD+jGz/s1R4TKlOEbIMrWjd28py4PqguL7UNT9idNaCvdtLrCbxiMZyXHnlRwNtva6yfijtOB6mKHSEKC9ZejjtiQuHoViWpP5rOjQDn3LikalmwlHgvIPdRRY60lA3rvBELVKoqONmiZgsCyhkTpXFsZmYgP6xu1EHIGmIF3DsxccWZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yh+HjzpDilKdeOeetgB5Qv2okDjMkRled+EY/Gc3QXo=;
 b=OY7ycAKz5riNfRaCLGq7lh8YDqu9DePip6ZUFFn/vh/TnfMHepDhFlY1a8N+59h4K0m7bnwJutl7Zhm4toznPc2MCsqljw/CMWtOQ6ZqDXgI3dEZCoXI+J0i0PIN/n0ER/wNGDUZF+nGcG8pgK9L2Vy3X0W/bdmPtMpwEfSB42M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DBBPR04MB7884.eurprd04.prod.outlook.com (2603:10a6:10:1f2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Mon, 29 May
 2023 20:48:12 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 20:48:11 +0000
Date: Mon, 29 May 2023 23:48:07 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Cc: netdev@vger.kernel.org, Rob Herring <robh@kernel.org>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pci] PCI: don't skip probing entire device if first fn OF
 node has status = "disabled"
Message-ID: <20230529204807.z2th6cilnrbzj2e2@skbuf>
References: <20230521115141.2384444-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230521115141.2384444-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: VI1PR0102CA0096.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::37) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DBBPR04MB7884:EE_
X-MS-Office365-Filtering-Correlation-Id: d3a1f2c2-8a79-477e-79f7-08db6086043b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1AACoHPbsNk6s6Wi87sRbx8R6TQ9mI9uSBMGeQ1U4BEsI7MXg46RWxNbbx3qNTp6S2VepqSg9Zpsc6i1HUmwng+a+EsEfOuVF8ViphKYq5c4TEFeHyod+pfiA/UO4zG96HGe4khuNSm19LoEh1YIuv270VFM5QolPLRVQ07PjG+Wwuz4KW37+aMc1+t9tW1KtUCNmjjfXmcksHAJUqmJ6gkVm05ukjmZSyIGf4fgKWXWsdZZXM/OW2cVPRRSAdYYSKQBkgiHQvVCS1X4st9MyS9z0QCVM7uTBCPMzm9FKzIOjUdqQ6ykwK40p+YFFU0zIjq83Fn3jY6yQumxZ/kbzI/KP3BRgnrUJUVa8GhNsrBMXPpiJDvjvK2mfh8uLPpDVQen+DPa+CMYGuv8voz0QdHTihvXnPAkeQJuh1Kq6+h1EKHO2VllmpRj6NY6eaZAh/fBDARnc9TOLByx3eHRTxRQp7hrfWah2AzqaTuDZTO7ixqJvwmFPzTeQyVX1WJGkHtAVcfD83SJUNx1Z3awIBFVq8P9Ha5U+ZQsKT3PwZbkAmnwwdBZHXE5NbTJnm4I
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199021)(478600001)(54906003)(8676002)(8936002)(44832011)(5660300002)(2906002)(33716001)(86362001)(66556008)(4326008)(6916009)(66476007)(66946007)(316002)(38100700002)(41300700001)(186003)(6512007)(9686003)(6506007)(26005)(1076003)(6486002)(6666004)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eLYGi/MPDLcd87XDSae2QkEdbZLFTuXE2buw53iVXU66j/rahNuPpqfVZo0b?=
 =?us-ascii?Q?mC1NDqG9sVb+LYrSQuHGl17wRbMYfUJ1+8bW+R4HKQ8dDPMbS0gpkjXK1wkx?=
 =?us-ascii?Q?JHEJ7NiLBRiZt5c4eox+hmgYHS69pBF8vbAopqG9tdv4mXH71pY8emoteI8f?=
 =?us-ascii?Q?VNViKlcFbS8jAwUJ+WsM2+RpgTyxvc4e4MIZ+LT9zOdNEfRiaKYDLlfZjL/c?=
 =?us-ascii?Q?TMMZh/NqXBJfBoz5G17t3w4RtewjzrITae8OokELT57c/13Z7Ub4soK4K3lE?=
 =?us-ascii?Q?ccVU+kTDCqk+JH8hx/v29BWWcah7yPzEER+ofipTpHb2PpA9cO6GvUSOX1ny?=
 =?us-ascii?Q?ifdf+3vX2DybOPBUaWGfrnJu99Ep9rfQBQPmFqzm2U8GtWm939SIYzVQzpy6?=
 =?us-ascii?Q?jXi3M9Us1gDy3Bm0PGIWJNdQ7Kv82fLiuQa4alt8BEKlzuCH+i7dTQ+2vQKr?=
 =?us-ascii?Q?qbOtFcUeUXtMf5/NkYoeB/Jcz5kZjO8RgxGwN8QcQq0DhwmtzqrSf99wQ2Az?=
 =?us-ascii?Q?EA6Ztq/Gb6BZIFs1X5LQSRnR0wD2Rc+W8vcnu8tX8BwwMtb56qwVa19xfCAw?=
 =?us-ascii?Q?RQ3NSNu+LtZWpQHRsbyU4iKWYvaIi0JF3Id+xESRlZNQDdYDZsKF9GBP51TI?=
 =?us-ascii?Q?VEuhjuqU9Hw+xytwO/2IWKoETD4cInzHWgHInR4fgV34ZEvzTQOILqA/+HN6?=
 =?us-ascii?Q?5GtUaYUtGN4bCAVbX7o65+dcNNFrTzlque9G3QszfOtoCcOyvZtMkmo0hdjX?=
 =?us-ascii?Q?hijsg9cCc9C5rkN4KD+UUwPeQdg7nAn5Vqq4/inHa+ngfCo7kzn5zQLsWVSr?=
 =?us-ascii?Q?dJYECoVG+GLxhapbWHwZ1o6Q6zjFZH8ktf/nZB/kRbaAL6zNKQqQ1x3XDIs9?=
 =?us-ascii?Q?roRvUavomY8+gGUR5jgcjLrbq6WuuPVoBOjhiqhLGd5B6JBTqQrejnnigd+/?=
 =?us-ascii?Q?FmfhgZqk4oRXNjSIUQEGPLy7vmM0eodAXOMGo5MohOYDHOvupeSKyuETTvtD?=
 =?us-ascii?Q?0UTpsCCCSRauuGJ4ChEuntmYArKeGM5gbv9z/ryGmRIlXyWQ2VN/5yP0LzlC?=
 =?us-ascii?Q?0FLT9/2wwxEH0m4o7qzWyTgl6qkkgCvzFwnwSEw1LoVbedjYcE7zZJmKvBtL?=
 =?us-ascii?Q?M9kk5P9Dg3dmZvC+PGJqjsfiN9WYdg+o2bwa26G9HSjmh8ksajuZ8KBq0jgM?=
 =?us-ascii?Q?NVocS584DSQtKFFwzJXzeXut1b+a7lYi/kiiNTK4ajhA9M+xTUkgMx+ac91p?=
 =?us-ascii?Q?cPvHYWAsC0RnX5tbkA7O+H+qUgD7cqpyqdJmzP2VtijTS4CQmnIwVTojedLm?=
 =?us-ascii?Q?cC3rtNAgO+BckMaAkbscyOuXJzo/hKEIk0Ip9m1gLM/dsfmGex+siZfoS1fu?=
 =?us-ascii?Q?O4nsAyOR1TRUPLii5hSkcUsqZ6CsHvVZ93dsxV2AyndYxtQgu2CeZ5Bo08bS?=
 =?us-ascii?Q?P4N2t+dQN+/jGodSNJ3dvKhe1RiAp40lv27mtw4LMEJdZf3nFUHZ9+2a3iM4?=
 =?us-ascii?Q?1lBKgYx5fScnesnt/p190tto9euo6hYrNUYll5dVC7YbMYwntgPPkdVZYMtf?=
 =?us-ascii?Q?ooZp9NhMh3JsuFMh4u1C22QPJ7WcowcBLDpqmCHz6U4OvRWTvQlcwWGsYCWD?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a1f2c2-8a79-477e-79f7-08db6086043b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 20:48:11.8035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d17Vi5XTX1odm0nnPrpv9+stoOkuQkTKCaOumSrQ6FQ+Ao0H5uxGDAn2z3idVl+QxiKVDpHG4JsgLXxuYFFYMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7884
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Bjorn,

On Sun, May 21, 2023 at 02:51:41PM +0300, Vladimir Oltean wrote:
> pci_scan_child_bus_extend() calls pci_scan_slot() with devfn
> (bus:device:function) being a multiple of 8, i.e. for each unique
> device.
> 
> pci_scan_slot() has logic to say that if the function 0 of a device is
> absent, the entire device is absent and we can skip the other functions
> entirely. Traditionally, this has meant that pci_bus_read_dev_vendor_id()
> returns an error code for that function.
> 
> However, since the blamed commit, there is an extra confounding
> condition: function 0 of the device exists and has a valid vendor id,
> but it is disabled in the device tree. In that case, pci_scan_slot()
> would incorrectly skip the entire device instead of just that function.
> 
> Such is the case with the NXP LS1028A SoC, which has an ECAM
> for embedded Ethernet (see pcie@1f0000000 in
> arm64/boot/dts/freescale/fsl-ls1028a.dtsi). Each Ethernet port
> represents a function within the ENETC ECAM, with function 0 going
> to ENETC Ethernet port 0, connected to SERDES port 0 (SGMII or USXGMII).
> 
> When using a SERDES protocol such as 0x9999, all 4 SERDES lanes go to
> the Ethernet switch (function 5 on this ECAM) and none go to ENETC
> port 0. So, ENETC port 0 needs to have status = "disabled", and embedded
> Ethernet takes place just through the other functions (fn 2 is the DSA
> master, fn 3 is the MDIO controller, fn 5 is the DSA switch etc).
> Contrast this with other SERDES protocols like 0x85bb, where the switch
> takes up a single SERDES lane and uses the QSGMII protocol - so ENETC
> port 0 also gets access to a SERDES lane.
> 
> Therefore, here, function 0 being unused has nothing to do with the
> entire PCI device being unused.
> 
> Add a "bool present_but_skipped" which is propagated from the caller
> of pci_set_of_node() all the way to pci_scan_slot(), so that it can
> distinguish an error reading the ECAM from a disabled device in the
> device tree.
> 
> Fixes: 6fffbc7ae137 ("PCI: Honor firmware's device disabled status")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Do you have some comments here?

Thanks,
Vladimir

