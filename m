Return-Path: <netdev+bounces-1976-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B5066FFD18
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:18:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E33C51C210BF
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E93EA1773A;
	Thu, 11 May 2023 23:18:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9DC3FE3
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:18:10 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2071.outbound.protection.outlook.com [40.107.21.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C50159F4
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:18:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIGrJRYuO18gzKICJz9qs+QvgqRgywsCfADua9BgFVOucSFxIqw4gkEejd3AbUUS6vSdgZoRfdsxyWyH2Kq6VwmOWQ3F5Vl1CgNDIHe4ZjFTPGS5VBe8NrjFzHlr7MyeiYARUXe7kA9lXHRWWvr95MGwaSEVJciWamIxfb7v+4fjjb9HAUeKkxS9MHndUqD1kxDuBYew4mJwF6NddhUca5kYV2SxbO7QS9RX2kioGKinvjH/2Eh4R+nGgRf4u7Shl0QsAbeJI1kny8+R2odV7xu2VZ40AcsKemiCDsfZloWB4SAx/waNYzMzySSlKsZuYhf0v3HCJYOdz6ls+k3bqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0Ocu7OCkXLOQZQ9uIjk11aQe8pI4k3shSCIyNnG26w=;
 b=nZHq6A+1IyF3mQwus63B+eSTTkDXt7FETZMwINHZgTwuHt7DQop57PamRC4kGfg5gcrJPz4ENjgdcBP99O40gPlyvc02Vx6APER62h59CVlP5OwB1OkKXpX5bl1gbQ5I1LnWcySXO1OM+8BswgOpbc0QftD63TV+Y3qkVTReYKhrzMUtfiK1YlfK23IU5Ylot08h2MW0cVBDMpHyBIAnx32bo2GipHjHDaK/X6dM7pIiDnNsmgV1Xi35YFN2103OEmesus96ckksFHSyQURC/ORuN4rZ2XKF9HLCuCvd69yaJQnuT3+HLgBCcq43DtFawajxjHF4QupynOviDl+mzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0Ocu7OCkXLOQZQ9uIjk11aQe8pI4k3shSCIyNnG26w=;
 b=klQz70Hi0uJ7lNYbhBYrwyXlLMQ6IZtZSpgXhtn6uGRzs5XZqg2fvGqK+VPdGL5ZyzMX46tjuyIbKaaI/OxJ+nQ/pzakUrBhTH6CZb/skryjXBrkWfIU7ob/N6zx/JOZmCMV5YKLSiV4GpkuQT8rPoQWrLwwt0l5V3y31yuCd8w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7990.eurprd04.prod.outlook.com (2603:10a6:20b:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21; Thu, 11 May
 2023 23:18:07 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 23:18:06 +0000
Date: Fri, 12 May 2023 02:18:03 +0300
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
Message-ID: <20230511231803.oylnku5iiibgnx3z@skbuf>
References: <20230406173308.401924-5-kory.maincent@bootlin.com>
 <20230406173308.401924-5-kory.maincent@bootlin.com>
 <20230429175807.wf3zhjbpa4swupzc@skbuf>
 <20230502130525.02ade4a8@kmaincent-XPS-13-7390>
 <20230511134807.v4u3ofn6jvgphqco@skbuf>
 <20230511083620.15203ebe@kernel.org>
 <20230511155640.3nqanqpczz5xwxae@skbuf>
 <20230511092539.5bbc7c6a@kernel.org>
 <20230511205435.pu6dwhkdnpcdu3v2@skbuf>
 <20230511160845.730688af@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230511160845.730688af@kernel.org>
X-ClientProxiedBy: BE1P281CA0261.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:86::7) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7990:EE_
X-MS-Office365-Filtering-Correlation-Id: 1351566d-aff3-4977-0ce5-08db5275fa5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zDfsxpXgyw9Dy+u7Dh/Yi6rkFBZ5nNx+BBOaKrMIrYD93+upkNdqtajqYw0kDBWAXobFl5evTu0FVXqapxWqxe5uBqTGzd9YLgDdu4G0qh+EzSq3sYO1Cb+BaMSPCJTzM03xA0IEJt6jxVmac5cXsvmwDudhQNiHt3Me6x3UEoZSN8ogoH3zG2TkCReDKzFItqxnitWdrPhPgo0UNNlnr/6DpNnNtBsX1jfPW82S0ORfPuP5BDHioZ0wgBPvCpAoxob1ooH1u3y7YEM82wDmse4lz8HPFhITnjTPnOBk/x2jlfsUitIsepPbsH0/PV+uSVosmWH01OJ0XBIqVp8QOh4o4zoqyKO8xXz+973dNR88N+Mer22Bo8fJmhHtrdd/L+5jjrbfLbs1Y1iXR92Tx9nTXAKASWBZrsPIAzVN5FrKAHgqK+JVi8JYtV5AFIEupzPpnz8NRT77nvP/V+K0g5hxTwkP73IrKf0gkynN5MSI1tbx/3AoUdxG7J5TIZ5YO6PpDkQ4T+xklOhYmwNUMA+ADvQzVA4b+wJncqrczo/2QJdFEAaj67tP090gTtV0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199021)(6506007)(41300700001)(26005)(38100700002)(44832011)(5660300002)(9686003)(6512007)(8936002)(1076003)(7416002)(66574015)(6666004)(8676002)(83380400001)(6486002)(186003)(2906002)(86362001)(478600001)(4326008)(33716001)(316002)(6916009)(66556008)(66476007)(66946007)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?nH97fFremdomvsNlMQDOwJKsj18mjp5i7CSZMiYKnNQt2yrIJSU/06PvL+?=
 =?iso-8859-1?Q?sOV/sm46fDmHTSOpt/FDws5caFcTO+28QrtjESTv2ZHifeJD5cQ3f324cI?=
 =?iso-8859-1?Q?drCOhjLbXsEMikiGDva2lhmYdgFw0P6JU7h+lfgKF3nF5bCJx7nT6W+XQO?=
 =?iso-8859-1?Q?qkwVx64y9Kn1ybg2iFhgYU4zhK7tXYMZxSshKc1uEFD623bUNGQz0yegSG?=
 =?iso-8859-1?Q?YFhiXPzy1uBtyvV54n49zPjjGG/rXhCm3nGDSGGSgoASBjtaCWbVCTKYFh?=
 =?iso-8859-1?Q?vwr98RBvqw0abRinbhcEog8SJoUENXFK/A7PLzeS+D3drqPocYYikO0V6w?=
 =?iso-8859-1?Q?7GDK3mtrH1afFQIZ/Pc9B9Uu/WbCL8wCNxsOUgF0Sb7qbrg7rph1p5v9ix?=
 =?iso-8859-1?Q?aNIC0+zGl47wQGv5GByQWWHhivoke0bsXa4lABS+TAu/Ld1HwjRTdYOjLp?=
 =?iso-8859-1?Q?FifDk5v5l6JQZSF6wtKFysisTkOohLsdPiUnbdvttHWzFDJDAmQetTnVP/?=
 =?iso-8859-1?Q?Rza8wvXAE24isns5Es5cdTHWpn0tbee5OU5WswiMtw4N9Zxv2+CswEKYZq?=
 =?iso-8859-1?Q?V5uGqeBdEuaHbnPjcdPxFkf3k7GD03qCMwCMfMYgcWA2B5F7iD3J8dp3Wf?=
 =?iso-8859-1?Q?WfC4+IA6eQhHdXmLiT19qZzNTz9Go6j+FDeJOBAZ+qcnJb6KdTF/O1ULyF?=
 =?iso-8859-1?Q?ZmbRYSsfHtFo+UaQKip/qHuODOB2h4if50vxjQHhvQe9yBIglvRyv72fVH?=
 =?iso-8859-1?Q?x7WkVI24Pt6CR3J6gCkFhQi9nmHK9NnXozJ23ns37zZZS9rvhEe3TGscSk?=
 =?iso-8859-1?Q?m2FdcEx4JZ/PDtER6yBoqTZEDHd65Fa7rm7Vf7uIKaWoCNLECU7wSU3hII?=
 =?iso-8859-1?Q?PcUBdIWPbP2notP31kraq1hCPNTWj5pv6ZCkoTU8E2Twf7CKtYxBHH0h1D?=
 =?iso-8859-1?Q?STh+2KfwNUIFR56pWN4dFr56WaZtqrfNvA5arHUaBT9Dssh8hRUGCIpJvf?=
 =?iso-8859-1?Q?+CMlPi2xW3TpXM/uB6bWGggnYUOvIUJiqgO0UpJewEmyWHMqNOSXpqhBHj?=
 =?iso-8859-1?Q?lG+WOLbM0ydBpchsEhxTYJJDLj8ikS94YHzTCgc306IqY9fMM1l+G0z7Ix?=
 =?iso-8859-1?Q?AagA9ry4lCeGFMvzjADVShGZMzyF8lUui39ZVMD40aDctfLfap+1SJ/euS?=
 =?iso-8859-1?Q?ONjXYgEf4exJNwheG9CJJajFeulB3DwDTPC8bVI5E8ZcElMldae+e/PJxV?=
 =?iso-8859-1?Q?8XkZkLbTa3nvNtg/L6q2b6vpASnCx7jbhg896trwwYQe3oxFgEgjlqNEib?=
 =?iso-8859-1?Q?5gKZizciagOeOsa8UfyGmFOG8Z/tb5i+cdotC+TniaIF5N/nuh1oQ8cuo7?=
 =?iso-8859-1?Q?qCyVMC/lVMCG15IXu8gOxRctr6vkEmk/cH9N8dnoC42hQyXXhsHtcHlKiN?=
 =?iso-8859-1?Q?zebXbmew3R6HJonQh4ovJLYN5c/47CiA9r0ygGYnGx9A1XHqgBQtrQV3GS?=
 =?iso-8859-1?Q?M3LIoDd3QFXEGbYwX+9kH10WOJtB6DQOJ7BJwasebbJdkr6gC1T1OJItSf?=
 =?iso-8859-1?Q?iTTava9nKvxpwWE/Bi4eKHrVzFiWvYO/t9jbGGLeVldLXjvuVWXWmfyuSi?=
 =?iso-8859-1?Q?a0SMSOzyd3goPm0juaJMyxaLzyyGRFDjyMExgG87b/rulJXtzhDUdDYQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1351566d-aff3-4977-0ce5-08db5275fa5c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 23:18:06.9284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TO90vrA+jFzYaOAo9eF8s+wkPKw72peQ2ciDfA+pThWriRBI7XcJFHZoDAZzwx6gJLU/ssgpFxmx1lNhEFqVmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7990
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 04:08:45PM -0700, Jakub Kicinski wrote:
> I think it's worth calling out that we may be touching most / all
> drivers anyway to transition them from the IOCTL NDO to a normal
> timestamp NDO.

Right, and figuring out how to deal with PHY timestamping in the new API
is "step 1.5" between creating that new API (Maxim's patch set) and
making the timestamping layer selectable (Köry's patch set).

> > But OTOH, if a macro-driver like DSA declares its interest in receiving
> > all timestamping requests, but then that particular DSA switch returns
> > -EOPNOTSUPP in the ndo_hwtstamp_set() handler, it would be silly for the
> > core to still "force the entry" and call phy_mii_ioctl() anyway - because
> > we know that's going to be broken.
> > 
> > So with "NDO returns -EOPNOTSUPP", I hope you don't mean *that* NDO
> > (ndo_hwtstamp_set()) but a previously unnamed one that serves the same
> > purpose as the capability bit - ndo_hey_are_you_interested_in_this_hwtstamp_request().
> > In that case, yes - with -EOPNOTSUPP we're back to "yolo".
> 
> Why can't we treat ndo_hwtstamp_set() == -EOPNOTSUPP as a signal 
> to call the PHY? ndo_hwtstamp_set() does not exist, we can give
> it whatever semantics we want.

Hmm, because if we do that, bridged DSA switch ports without hardware
timestamping support and without logic to trap PTP to the CPU will just
spew those PTP frames with PHY hardware timestamps everywhere, instead
of just telling the user hey, the configuration isn't supported?

