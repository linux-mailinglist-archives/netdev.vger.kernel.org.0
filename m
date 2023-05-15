Return-Path: <netdev+bounces-2621-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A367A702BC4
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F8EB281209
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2B7C2E4;
	Mon, 15 May 2023 11:48:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8092EBE7E
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:48:19 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2075.outbound.protection.outlook.com [40.107.7.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56B819BF;
	Mon, 15 May 2023 04:48:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUmBwooaab1lMeFS1Rvo0IJKesWeIrdLhJy3onjF2XIqH3k7jgbxEG4A32MIMSYE/f+jl7KOFs0zKo3gqeu573hMW3VG2Ss+D+NMMFWnO0NviWynQdpEU5bPpUyjk9jsTEiZH1YMkaeJx6DhMAaKYs9kApkV/QjBNXfNKKktaag/OkjNGuUaeoBnK6PiN3B0VDWEc47dDzhpd5KAx4A9fKluoGFdgNqnqD3kOZO5gy0BVRGt5B/5v2pMz9uwHqkDF3Xpd2qS3VBI1kwJdcn38npx7wWt6+fBZ8UDaMLwtF4KBDjYMXJol0nB9BmaSkZDF4jaXAyr5p/RUMLdXlt4Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0rZ3ucFHwPgRxv7g8mNwktBFsq9bls9pyTcJoIvxjo=;
 b=EiG7d9jW1iKkih36ENaeK9XGoXR6cjMchoaIUO4FY2K5wg08gy5TNZqWuv3J4HMljZaQ7yyeZ7/izi7pM2xkBH9jZ8V8gfDCIsOTUD4+G7XM8J73oM06kZ9TscYbukzDg6YM1DubNdtqujCkiBbhrcv/xfLQVQu5fS9H+OYUp2yK+b8fscwiXUdTCi50Z8Ydpte13e1dBhF6a2MgbP34VkACHw+FuIkcNWKX+aXTFdDHJRSeAEeONbVoiIo3i0fDjOIYupAUxTxX7E/nLZMkI6g6jEJhhIaac8khGfZi6Am7IwtB6l86MxPqITKaagnM9Dmv3OoJCKBgE+mXyI+YlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0rZ3ucFHwPgRxv7g8mNwktBFsq9bls9pyTcJoIvxjo=;
 b=RBuWX+XrOqJBBN8PovXT8Yq7wVSpo0qRK5NM/1ilS2An3FUPqiCFT0xHZN8x32hyhg2igc109CCSj/euyjr/6PllEcLIqODR/DU852VsBK62ktuMlF07H1+Q9Sz3mJD3ArV/9cZ6vxEa84ta80Zw4dDRye9gEZcsk+MBosoYihI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB9977.eurprd04.prod.outlook.com (2603:10a6:800:1d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 11:48:13 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 11:48:13 +0000
Date: Mon, 15 May 2023 14:48:09 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Mark Brown <broonie@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rafael@kernel.org,
	Colin Foster <colin.foster@in-advantage.com>,
	Lee Jones <lee@kernel.org>, davem@davemloft.net,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: Re: [RFC 7/7] net: pcs: Drop the TSE PCS driver
Message-ID: <20230515114809.d4jzhiazymfqajbj@skbuf>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
 <20230324093644.464704-8-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324093644.464704-8-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: AM4PR0302CA0015.eurprd03.prod.outlook.com
 (2603:10a6:205:2::28) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB9977:EE_
X-MS-Office365-Filtering-Correlation-Id: 88e399e5-dfb3-49a0-9385-08db553a434c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WFpKkdy4ijk5RLycU1yxPkRS2VADKHqtPCnqL7Ze0BagOCwNP8RFD16f8T9ZTfsXU+0dIrHzr3zVRpxpFhdn5YUQMbaEtZsuvnCvaoelXF2liLfdfiez8Dns/aBHuCNdM0lVF6nJAbKgtRzfO+TqkiakGmVrnbj5gTQcRHNMEsKEizA/Ev+CRzErQm1lhYLVJnFoncwA/Ri8rAu70PEMkdWkfU2f/oFcpvSbEUdG+/zDyvl8Xqz04GApvFzfQSBlGM2QOgEgjUa45ybOH3PvyKipB/uZ50YWf/BnWooM5TMxw1U+oMKhnKvX+c+OvOfDMDmW3NQEgxP+J2e4wC4NlA3YXh8XOHhQ/UmcuhDKwM1uauzrFdDYBTNriKuG5fmMUkABILeA0jghzRVSJSX0RMOTHnWPA3byEyGtV9cN6n5+tOvclt8v9ndJzrPzN66Zh30hjkQXiAksPVV+pBnoV1Px0dfZRmQMbpRqzZrORPmkdI9jAh9TEbIBBzaihsA5E66u/JoeYjaebsGApGG+VkM/pjKr53tkOQS5T4yTA/wIGYwv1p1yYX8LuPFCDZ16
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199021)(66946007)(66476007)(66556008)(6666004)(8936002)(83380400001)(6512007)(26005)(6506007)(6486002)(1076003)(6916009)(4326008)(8676002)(7416002)(2906002)(5660300002)(316002)(38100700002)(41300700001)(44832011)(86362001)(54906003)(478600001)(33716001)(186003)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+ChVDA8VAwRu/I5pFzIZCizKMXbxwHZLnWSBbOddPV4OlEFOhAhuVrE4K8yh?=
 =?us-ascii?Q?ixtOK2ioQDEEUvTbCVtxianyvRMFPMoyGmgxdBgnyM5Ygjx1r08fv6nl2Ul/?=
 =?us-ascii?Q?B0PW/IZRSWYGGmWLxs1q64nfDEpBpmmfgsd5E4oSkfR3cAcyaV5nTPOFxWnA?=
 =?us-ascii?Q?naLTskLQJ2+0XYIL4ljfAAWgpehqSEKbQTJa1CyDF6jWnUQR8+dGjDu3FBqE?=
 =?us-ascii?Q?zL55t1qwfeEeWnXMyYKsoyF70OZ+wq6I789AtF9JEwcjKMf40J3bhMcQKT5D?=
 =?us-ascii?Q?GiPn/FX7BqLtS7L3h+fvRYo/WsCGjTaVK3DZdffzKQRmg2H4wCauWR3Jr1at?=
 =?us-ascii?Q?mlsSQklRHSedfTctr5epUXgiuekiSgKKc98Xf3kwCG6951XD83ysQrN4PTRV?=
 =?us-ascii?Q?RjmrrQUQ29QmXdaCzmocnht96SdIUmMIEW3kd2s7CHDWn6aXmtJ6Yt1bBttz?=
 =?us-ascii?Q?urz7mkism+9OTtzZUsbd5pjVe820GHOIjLZExxkMzO8OhPiF2rLO+1tdaLQu?=
 =?us-ascii?Q?kEdsIM0OO3Yf1jjqH2TQlPPufkHuMaFBsC1g09VGwK/6e8/WvDQIKNXjj4NS?=
 =?us-ascii?Q?e7rpQT7MkyO0r5+bihYD5WXHjlALxYt+LxHVZwwQAG2aBmVtGdiwNcqeqjt8?=
 =?us-ascii?Q?Ouvtg8mpg6jz3ouUcO3Mcm49+9666v0yjx6Uyr04gncKJFqz8HFH54/iu6RL?=
 =?us-ascii?Q?H/iujplbVSJWDFx6jUiz/tlMBvQhrqDBKmvAqjT+Ue4wZpe5DN7Zk3LjDG/Z?=
 =?us-ascii?Q?HtNhxhgKVFFgIzHVEksMJ74p5bfGeXJS+pPyIKSlzL91s5zBGskHkyLrtHIK?=
 =?us-ascii?Q?jikzP7OtjUwnz7skdT9toU3/XeiZhhwIFFGXPxd0sL8UHiv2SZkvBViTu4hL?=
 =?us-ascii?Q?rAiflUIDS+3iL7th61iC7tTMnXlIMSvge9wQ/5SIPwhNaoU3l4rWbrmSSouR?=
 =?us-ascii?Q?N9qtDwtJB4CmXq+i9ugYjcqYYMbUeUXH93/JTDaBOeUlkDHzUgJFDfP23nNE?=
 =?us-ascii?Q?tleMZXw8l2SgSiBhuMYZZDaiHde9DNhOWIICHHsSBT/kqKGIqTKpZebd1Vph?=
 =?us-ascii?Q?vvHmzzOlO1WSHqvqHW9aBog59lxDpDklx2dUc7zlfkxTA1oplpWn01Wf/tDj?=
 =?us-ascii?Q?bt5jt2fSNOqXIbECn95crgAjj4yi4wbMDUATnlRaMkfDzwWZP2+Z4G68962/?=
 =?us-ascii?Q?JDaz5n8F6hTd/8p/Q3BtX8J9m/IPm1UT8/e/b/iLyLHv7hbCXBU/Pmxz/GaP?=
 =?us-ascii?Q?x8VWC0bv7mVCUrPX/k1orb9hV3Fp3am0DTg7c8glf1r/c93sZjYMy4iu70Vd?=
 =?us-ascii?Q?qnI/AQ+Y4EPwidJJBBloJ1omGISuOhJSx0a67nQvgCB87hpr9nyL395UnKGx?=
 =?us-ascii?Q?RFH0zBwRitX9Q4LQLdywl42nMuEzHxwn7LkP8gp/4hC8r4OOwKsfzdz+r9NX?=
 =?us-ascii?Q?EXXATQFaLn7yfyPBSlYlGK0d4umVF6G1HJtx1eZbkrizRDitiexdCsG5jxge?=
 =?us-ascii?Q?vQ5C+/pY/ov+MSmpEuPzoSHNjqJ8xV2fTTcpcKfh+3MHuMsGlOJMpuK/WWA8?=
 =?us-ascii?Q?kFeiBo5S0NQHVhd584o4/Vtk7xrpnI9S7kjezvV7RMGf/5aAHO61s3r48uMm?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88e399e5-dfb3-49a0-9385-08db553a434c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 11:48:13.0406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ELUwMl18mkZyFHApPDwHdDGbT0FNtQAAbz9jW+dAMbrmDj0c4Iw0GQOxZ4GgHEQIIDycZzQMB7HWO9cz+AAOsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB9977
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Maxime,

On Fri, Mar 24, 2023 at 10:36:44AM +0100, Maxime Chevallier wrote:
> Now that we can easily create a mdio-device that represents a
> memory-mapped device that exposes an MDIO-like register layout, we don't
> need the Altera TSE PCS anymore, since we can use the Lynx PCS instead.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> -static int tse_pcs_reset(struct altera_tse_pcs *tse_pcs)
> -{
> -	u16 bmcr;
> -
> -	/* Reset PCS block */
> -	bmcr = tse_pcs_read(tse_pcs, MII_BMCR);
> -	bmcr |= BMCR_RESET;
> -	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
> -
> -	return read_poll_timeout(tse_pcs_read, bmcr, (bmcr & BMCR_RESET),
> -				 10, SGMII_PCS_SW_RESET_TIMEOUT, 1,
> -				 tse_pcs, MII_BMCR);
> -}

I just noticed this difference between the Lynx PCS and Altera TSE PCS
drivers. The Lynx driver doesn't reset the PCS, and if it did, it would
wait until the opposite condition from yours would be true: BMCR_RESET
should clear: "!(bmcr & BMCR_RESET)".

Is your reset procedure correct, I wonder?

