Return-Path: <netdev+bounces-1891-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04D436FF687
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:56:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21B2A1C20FCB
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E6FA656;
	Thu, 11 May 2023 15:56:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCEC629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:56:51 +0000 (UTC)
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2043.outbound.protection.outlook.com [40.107.247.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DF465B0
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:56:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJvK2WWHy75S4+nyhk31chayPq6TxREr5oP6lxX5RcgIcIuZqU+KKGW/1Uw0aTUPY6Ay8TMIlp5fbxJ+REfueFzcNqaJhYr8f5ciSl043l8dCxOU2O+hN7JNCq8LsaH/sZElWCNs/JPs5jEqT6NLz2aj3z36dJWU827ZfsjKNYzyqdoutEIdBWADFgDvuUNcLq4UzTPsaWhfl+jQ5C9Rq7nTSCDiFgzH/fW5H/JOgale1SE1kNfc9OkB7jQ/GLSiph+14gC2O2qcrUkJeylSSvrZtTzbN2gB8q6vDOBdMilpIw6KoEeqrjvrRfJ6wFOoZykKj2c8ykaJiaAhBwLuHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2pMu88c2pIipx22QXmDPZBzszup3En4lkB6VqirLz0=;
 b=GJrhoNON7vk+bHLh0qiGAL8BFFkBBHpSda37AQDlGPb6UmlB3RZD+Nfaxr6vPaXsD5GINzSezGR79JJrHS4JPM7t81v9Jc/vkAiphJfEmcEKGHeMBAoda2JZ89Qmw2ArIUW3Tdb005cQXWz1M0nkSKh1Oh8SxRjEV1Sh06IEmqvq0n+tcUdbzB6gwEEFE+c2Jru1GH8cIyIhN29G5+2RyWWsXzGpfaIDGDbDCkSEPT7jA/duATQfGLccVSL4JULbTxaf3DF0LY4pI6sWfZrmm+XUopCsmirJZ8ivv2q+WTAOstKNPsKAmYOTuDXGBr10ubzxaW/Fvh3zawSCJ8+b5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2pMu88c2pIipx22QXmDPZBzszup3En4lkB6VqirLz0=;
 b=kYRMvp6uFQn2SRK4XlXu4usTnQLPblFfwZo+JUG+D4Ldk3/hFu7GZP7ONW15JY+DfD0QHeuKrkoT5WnDWMEeVwO5jzXzdnFPhgdB+EeQlGaWJgNpH29iKoOoR2PVDxi28yCMmhZh6jygu7x25GuV5Brk14jymaMG0H/ubqGwGqA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7422.eurprd04.prod.outlook.com (2603:10a6:800:1af::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21; Thu, 11 May
 2023 15:56:44 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 15:56:43 +0000
Date: Thu, 11 May 2023 18:56:40 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 4/5] net: Let the active time stamping
 layer be selectable.
Message-ID: <20230511155640.3nqanqpczz5xwxae@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-5-kory.maincent@bootlin.com>
 <20230406173308.401924-5-kory.maincent@bootlin.com>
 <20230429175807.wf3zhjbpa4swupzc@skbuf>
 <20230502130525.02ade4a8@kmaincent-XPS-13-7390>
 <20230511134807.v4u3ofn6jvgphqco@skbuf>
 <20230511083620.15203ebe@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230511083620.15203ebe@kernel.org>
X-ClientProxiedBy: BE1P281CA0058.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7422:EE_
X-MS-Office365-Filtering-Correlation-Id: 26c5dc73-0e1e-49ab-ee75-08db52385124
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5kwi7YlUG/12RBN/OrJcTADIUMBvTB6FUsBkQJ84OZZF1vmMKzBLQfKphBEpq1uDmtJVAVvR8EUOMjkuplQnsm1Vczpk/n+LWNpt6GTM/4mYCORW60Z5CnfJ2nBNc+DZpBpMNOnI4LFBRy4xaqRGfdJ25BWpxO+/2E1oNoIvIbgG/ZNXJCyhSNu3AyNM+69mRyYX2TI1m8+CEQ1y5lH7IOVm6xL5TottRdZZ5zjf3/AKlSCTr7dwyGu7X/Qezk2m1InyMof8BlBfXLeLpmYjEr1TURg3FdSQAN2BAeybMYGUSKAIvH+Dx1JeGMm6slogait0ZP9mFqTHlw5ZH+a9/HD2DLNV7MDCyK0ysWVyTvlBXxBrGglPX5F4czT/+XV1oL7jlDDjbDiDi18DT8hIed1/MN7DkMoAZz159AaitK7keTvFYqocpFOZFjpZRUGFJs4U6kldHnGJPZugVdZwZM55IFLURhq8jy8LbdrHfzBi8cIv1xzVI93mHaU7JWzcKunb7yJPixVHOtWzn0drbJ2E+kv1+uZspj/i46VLOPPwUzrpT2acI7ceuvvyV2TO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199021)(6506007)(26005)(1076003)(9686003)(6486002)(6512007)(7416002)(478600001)(5660300002)(8676002)(44832011)(8936002)(86362001)(6916009)(4326008)(66946007)(66476007)(66556008)(33716001)(38100700002)(41300700001)(2906002)(66574015)(83380400001)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?+aF6/xbM6WShtErTR3Pq0STivrqcAVwPHoXVbW6L6zcoeXw0mX/9O4yoyQ?=
 =?iso-8859-1?Q?hjlRgHLb0sc8x2conwG78InaSfyDXAajoeqMgN3tQFu6FbKafqPJ+rEaum?=
 =?iso-8859-1?Q?Gdabugbtndn0jAEO5APgJLfDHfFUZxZMyEKmb/hPe0sdbqSH4zYcMxJhG5?=
 =?iso-8859-1?Q?oddQmH0xj9WsnvtrTlmJuPIOK/kUJI+zdvq8y1iRJLFDUGXLxVSfMRV/Gi?=
 =?iso-8859-1?Q?xKQJpJkDGOBqSZtli9VGghauAp9C2nJWqNEQXAic+DJ8GOAt9SdJu6ucXQ?=
 =?iso-8859-1?Q?tNiTMJ3lMiIrnDfwzRyjksPH0EOGooK3NXHjsQWHhz6dwrqpnJbsOZkwnr?=
 =?iso-8859-1?Q?Zoa8J43ESnW2kYxNQhGKU22zsnLFt6DU8jw6ELFIyzNDOXWjmUzxbGrI2S?=
 =?iso-8859-1?Q?bbRXxKyMwUZQLxyxG0ewtB9wo3LTsYbKNGJvnQldhd3GN5DSA3DdZD2dI7?=
 =?iso-8859-1?Q?ggsLtGof5Uqa4yMtmeFfjRF7HAj0n7AsN1W3QoBswt5K6OuRKs88LswTf1?=
 =?iso-8859-1?Q?WP1L0qH5hpWGj56gYLBuH466ncsRcbdT+1UY+dSEQ0vQ7nQxgTwPpWlamB?=
 =?iso-8859-1?Q?mqf4mQC7MZyXbMie6D10EI9FUhKCrx42PzzAQrD1eRaqhlvlta8mQeYU8A?=
 =?iso-8859-1?Q?/OsyQOWDiN6hDNI6xTkBiTz8ck64wKeksOwJl1heXfICMfOh1lr2IgLy+4?=
 =?iso-8859-1?Q?BaTJlPq/EtRUgzjs5SxOATdJDchz+wVLuTnDWUcVtZh08wYinnXQZngsGF?=
 =?iso-8859-1?Q?MEybryiZrK7vELp+H/0CZn9qpYqB/Ar4KQCc5acBeo9xLoEF7fa2e2Cnbh?=
 =?iso-8859-1?Q?T4DPh4ac9SA8l7uHq2PZ+ZANM87xhwMVwamP7MJQtk9cue78fQRZSqFbRK?=
 =?iso-8859-1?Q?pkSz0Rr3lPBwObozttKByndNTUODPSzQAiUgX7q3k2+s1vxCSWth9iDFRP?=
 =?iso-8859-1?Q?PSYLBkj8aTHjgzs9I40kYK+fGrY86PGarjjp1v8CPFUXC/YDQiKinzLVok?=
 =?iso-8859-1?Q?ETseUW6lp/0QDuJO9Py2boFeRWGkuPreQaaZXsqIjW9Q5qlTETafMJrIPf?=
 =?iso-8859-1?Q?QNmw8L0XhyZXbdfkmKmwb4HzsRK9tLj3+OTvDdRdod1mllS1vXSXoj6BfS?=
 =?iso-8859-1?Q?vIi8qEibNH/nMstj96jcE4LJrkTIdnkHGXjW/Lf5rc5EOMvFd37BCA6f0V?=
 =?iso-8859-1?Q?xALjNWMElwnOFDUUEgWdhq8km0NQ008M4MYfFrECa4ETx1X7Z8ozihpXPu?=
 =?iso-8859-1?Q?eOEhXcjPEWoADO4HHAObV//AJ6LTU+bTQvnGJ+dz4XhlD+t8U4/qT401/V?=
 =?iso-8859-1?Q?2pW+IrUOssRgfinpnWSeYgK8Ya8IwlGDc6orZzmsLyEVjthW1/oXMOkG56?=
 =?iso-8859-1?Q?2cwpv7HN8TguTHcQ5CRe4DVMkqEDzCFvnwOnT+wh0VWXV+fQVJ8DTScXEG?=
 =?iso-8859-1?Q?xWhHPd4W3CqQJcHVZemMopLgr2wLz3DTalRetXFqsH06veLyI/snwqTD6e?=
 =?iso-8859-1?Q?71WDJ5VtyQHqtS+UHY8k0cLdY/DIIhy1mCraDNFEeu015JzfiplgTe310I?=
 =?iso-8859-1?Q?uYraHKo0CJLouhwK+/rmN5FBhuuf2x4YaPjTzUVm91dq/HAQzaYJPPCNpL?=
 =?iso-8859-1?Q?rXNLvKIsm2S0yDPsZTwDk78rGE3ohD30yeNKreNuPBwSG6uxNgwfwOBw?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c5dc73-0e1e-49ab-ee75-08db52385124
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 15:56:43.7593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UHdfxqUbNH0z7B80f6gNbSiV1qm/SnHOeL/SW7swCjP2FwXJm8QHlO2w5V528YXXKcmd1YrnY3PlnKMPJYFCNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7422
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:36:20AM -0700, Jakub Kicinski wrote:
> On Thu, 11 May 2023 16:48:07 +0300 Vladimir Oltean wrote:
> > > Ok, right you move it on to dsa stub. What do you think of our case, should we
> > > continue with netdev notifier?   
> > 
> > I don't know.
> > 
> > AFAIU, the plan forward with this patch set is that, if the active
> > timestamping layer is the PHY, phy_mii_ioctl() gets called and the MAC
> > driver does not get notified in any way of that. That is an issue
> > because if it's a switch, it will want to trap PTP even if it doesn't
> > timestamp it, and with this proposal it doesn't get a chance to do that.
> > 
> > What is your need for this? Do you have this scenario? If not, just drop
> > this part from the patch.
> > 
> > Jakub, you said "nope" to netdev notifiers, what would you suggest here
> > instead? ndo_change_ptp_traps()?
> 
> More importantly "monolithic" drivers have DMA/MAC/PHY all under 
> the NDO so assuming that SOF_PHY_TIMESTAMPING implies a phylib PHY
> is not going to work.
> 
> We need a more complex calling convention for the NDO.

It's the first time I become aware of the issue of PHY timestamping in
monolithic drivers that don't use phylib, and it's actually a very good
point. I guess that input gives a clearer set of constraints for Köry to
design an API where the selected timestamping layer is maybe passed to
ndo_hwtstamp_set() and MAC drivers are obliged to look at it.

OTOH, a complaint about the current ndo_eth_ioctl() -> phy_mii_ioctl()
code path was that phylib PHY drivers need to have the explicit blessing
from the MAC driver in order to enable timestamping. This patch set
attempts to circumvent that, and you're basically saying that it shouldn't.

