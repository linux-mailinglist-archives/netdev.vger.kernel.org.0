Return-Path: <netdev+bounces-1819-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD2B56FF35F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89C3A281790
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DA319E57;
	Thu, 11 May 2023 13:48:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C181F946
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:48:15 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2063.outbound.protection.outlook.com [40.107.6.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250A7D9
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:48:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7kiGWh+UWQbpI/IXCPEmvTeDAgAh2l8OJ2mm+vamdHW5vNjpums6eWFBhX1T8GONHlSJA1WCYhCy6QzlZYuQgM+CqaLYnSPTjTC9LIBYlhWqIzd5LVsqHTQRnvG2Zgpzkopi0zhG0G7oy7MYp+RVUvV1Y9nhZqZhl8vZNICp3cZ7QhydwBabGw1pY9iazlYd1Ibj6PHLgzaJtrAIO7POZhN49oijG3ym11CJKDdDbPTuIVGzAAjId5nsFNEp/IgT7jRK+u/N2wyIoFPCGD+La9jTkANsGwbWmlYwVODVYAIsT5az2F4kjbyQ6wuU8aRocapzaGdy+RoCFC5YBGeUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEfnHtmd7l+wR2psRuhuFX1Pua9vBFDL5JHz6YIArgs=;
 b=SSD4N9KJCkvlxmsF3hASOGkTIyJ3+WVp+meKpab20GoIIEn3N9s+NPSim0kk/R/Abo3h1uwlH758dxAqBEic/Tw42eY94c0eR5mYertngCKaQRFrJu6UKOD7KN03uTm7rADbiHpXafg8hS6mTBYEzSi/4ytNgngg1paL/B7NxEdCyR9WRWnl8Z0euWAE3xyy+/CFlmBUn5uhbvRxA/95kfDYllRNZcYbqJ6YZnl9Fm/DZNqd4b2dw6Nd5aDKlmKtNruWFqBOA6hevEWevtnh+I1xRhDu+8nytsBuH1vAUhZYP8uBk0ySuQWf9W8R7pkbgQdTM2BlhGR11ghPU1F4zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEfnHtmd7l+wR2psRuhuFX1Pua9vBFDL5JHz6YIArgs=;
 b=SVcSi8MDaGBJuqkklJjITDynqUQoLqNgSp9l7WWvhIPEatEeA5pyfQ/ID9wGTe9WJqw9K1aqMFNCXkPwwFIx6uSdDnMD+Wzxx5Mv2ZRsY9exQEtAN0261D6eDwenQboIIiSlcL4Y27dT/fP/UTC3+dUBcTFyFzdoqQYk+02ZnK4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM8PR04MB7809.eurprd04.prod.outlook.com (2603:10a6:20b:242::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21; Thu, 11 May
 2023 13:48:11 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 13:48:11 +0000
Date: Thu, 11 May 2023 16:48:07 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 4/5] net: Let the active time stamping
 layer be selectable.
Message-ID: <20230511134807.v4u3ofn6jvgphqco@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-5-kory.maincent@bootlin.com>
 <20230406173308.401924-5-kory.maincent@bootlin.com>
 <20230429175807.wf3zhjbpa4swupzc@skbuf>
 <20230502130525.02ade4a8@kmaincent-XPS-13-7390>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230502130525.02ade4a8@kmaincent-XPS-13-7390>
X-ClientProxiedBy: FR2P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM8PR04MB7809:EE_
X-MS-Office365-Filtering-Correlation-Id: 89e2007f-b532-4fe8-8bb7-08db52265c4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wMd6M0lO8RYX5QVWTRd57GYCCkpqFlRnfg3C+nbZFMnKt9VUsxAqn4yt1j8Sui9tzsGUoeNIWBM80qnr4W7N48W/zK0pd3z71bXuXzglupUvM01LFu27weXd6vJOYkcJkSXqI88uiBrvrgwdQ3kOsf2LfresQ1HX8uyXLFHNTBtJSszmzwtZGyCGoMdo80HAkE7BgvJjkdyTMJxWzENUZYJ0sHdPkPixVIakYsqe3eV32vTe4489Z4DYkdStBWoESLfFVUhqsEaaP6iL32xl2K6IFZTVFnCfexnoVhODx+aRlVN83hPSZVO8OeJjQeRMljfMwDMq6eQ5dsZkx0ePBcOa/VpOBe2MgqpG2C2B5L7NHu5D5XnU71hZLo7WKsLh3giLGEJPb69rSxLoB2KmUtYVm11jAjGliPGQP+0wETA1A7szoDskuHaoustHuhhhYyTr8JzI3ZwJbmlqR37TCQOwDoyUdqVAEPVOAPTLvDfsvAQo1u5MiaAY9G6RdCacQrAUSJc6r0jxq6ybWceMrg9iMHJmON5J63ILNwzAPexbNY+BzNa09cLtxAYdUb5J
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(346002)(136003)(376002)(39860400002)(396003)(451199021)(38100700002)(83380400001)(2906002)(86362001)(1076003)(6512007)(478600001)(26005)(6506007)(9686003)(186003)(6666004)(6486002)(41300700001)(7416002)(5660300002)(44832011)(8936002)(8676002)(4326008)(66946007)(66476007)(6916009)(66556008)(33716001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?F7jOI3aA7ajTYFs0lTRt89xpXRMBBrjLJdHFwLypfTEbEj+J+RHvyXQCSR?=
 =?iso-8859-1?Q?cV74a0XqI4G7DOlj2U1UXZZOrSvFcLw3qmcfIXdpRjV4oiS70aymkh1Q+b?=
 =?iso-8859-1?Q?p9DzZurprvslL5ccTM/KF13/HjR7asq38xo4AcLGMHmNvJ/vA/vP9aPYjo?=
 =?iso-8859-1?Q?eZDvOW6yrpPpr5t3jl/eGowBMSE8S65M6Q9gV/Do7aDgpd+7rM55UAwJl/?=
 =?iso-8859-1?Q?DpXHTGPlfuBAtuTSJqgZaP2OLa9RT1HHF2UJx3jiL4bQOsrMCgs2c1jeTd?=
 =?iso-8859-1?Q?BuOWeG7Uc4567RLdURHVEA3bm5G26I4I++nKtkX+n4SnDK5ARXTHgYe/BL?=
 =?iso-8859-1?Q?ZcAPopYic9Ox/TahqohMzXzXBIhf1CS8/q0d4kQtQXKwyI1QArKLHvuS3o?=
 =?iso-8859-1?Q?JvGJegCj0AZKj/lZqc3MjtLolEjBauHFoTqYklBY0pnMFmjv8hi6MN3S2n?=
 =?iso-8859-1?Q?H7b72vS7q7XoqHKggMMXE4E+nAIlhLCGyY6RwxwOBL7vjsHYqFzG2Tz7WN?=
 =?iso-8859-1?Q?MJ29351I2Y53PuHv68LmD9fMMEWofNhKBQBraKY+Wh+KDl7a8cwpFalS/e?=
 =?iso-8859-1?Q?tKgPej1GSJL+R5ch54KeH3n4YhfvXneRr5ZAEgod5n6ymEM/0vZyuwioUe?=
 =?iso-8859-1?Q?RR4wSZy1hfHfZDQKqZWdkk6GUvqMQ1t6nfDoPJcLBfdvp1LHWhku7JvBlz?=
 =?iso-8859-1?Q?eTK9SAga09JGTVxAiiX8MHLBluEbMskM0GbtGPnbdnmiMkG9tsWmHTB7Z5?=
 =?iso-8859-1?Q?AJA5Kh13v3v0m3+VWgvY2KbGhVMLHYqjMw0AcGpcmowIoOvEFiUXJmMUEC?=
 =?iso-8859-1?Q?eIBpYUuLnBrU0KRwE1Dc/pbg9G4atUcN3F7Z7iinHrJqXEPw3eJPYBn4D/?=
 =?iso-8859-1?Q?LA6NisgY3LnD+Zu0Tm49B6yhVmVtONJaNKbhBvZROZo7nuCgj1qJQRLguJ?=
 =?iso-8859-1?Q?v8wDEcD+R5p13Z0MqjaaVKCOpRnp+DtvqY8EyUV4/JR446hKDPT2ksw1n3?=
 =?iso-8859-1?Q?jRyBfS3Uyb4nzv5vMOlYMBycfcV4OpKseVvzmJ/lxW0q+i6sNKo/VQyx23?=
 =?iso-8859-1?Q?Lfl93Z+r0VrcZo/K+qAB+vdFkAdlDams3QIq7899eVtaBTY+sBDHxEurWn?=
 =?iso-8859-1?Q?yTegQBE8tAs0XrBuudAiXY9ua/zPo7yc+1uFzIeLV/GRWGS3ZR3ZpyaERd?=
 =?iso-8859-1?Q?+pRyGlKkE+lUtTq3Hy8onJYOZ7ZF3w4obSI2zVTI4u5iBXlpg/dIiKyw8p?=
 =?iso-8859-1?Q?ibszyZCDGp5y7N4kmvxgaKi3BG+Ce/jdVWTwaRzc3PGwZ2ssLEqMO6MKL3?=
 =?iso-8859-1?Q?TRVrGqjGuXjK43kIu9XNmZJbWgqQ5aKIlv9fi+0LVk3g3aJLENMKeTfxcH?=
 =?iso-8859-1?Q?m6DuK/GWsOvQI0KhrWrA4AqEdzM4OtcSoQMAFA7/FoAHBLei0qGg3BAiA1?=
 =?iso-8859-1?Q?/Q//LiR2mR9eLUULdQIWmRMEDwQCexN+Sy6tdsrICiKDXkjdvp6mlcXaFz?=
 =?iso-8859-1?Q?Yzccg3QzooKlhvxkHO8+SPxEI/05cP4XXzqAT5OpJaeLBwzjDYTo7+UYI/?=
 =?iso-8859-1?Q?Retgy+IRAPNCRhZ1bIkO3XL0aku5HPNEyBff4gbSgxovWdkUrHhp5GINvC?=
 =?iso-8859-1?Q?KJpotzOcMizJXFrMOy82pqG7FlskQVC/BqgnOwA364puwTvek4Vhsm0A?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e2007f-b532-4fe8-8bb7-08db52265c4b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 13:48:11.5322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uRWww9lkjJ7SQPPrN2tX7R9rNWv92c8zq+3/7PapA6VFv0YoUeZQC94y5js3rwccR6dHZLFPBhviC+t79MIQJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7809
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 01:05:25PM +0200, Köry Maincent wrote:
> On Sat, 29 Apr 2023 20:58:07 +0300
> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> 
> Thanks for the review and sorry for the coding style issues, I forgot to run the
> checkpatch script.
> 
> > >  
> > >  #if IS_ENABLED(CONFIG_MACSEC)
> > > @@ -2879,6 +2885,7 @@ enum netdev_cmd {
> > >  	NETDEV_OFFLOAD_XSTATS_REPORT_DELTA,
> > >  	NETDEV_XDP_FEAT_CHANGE,
> > >  	NETDEV_PRE_CHANGE_HWTSTAMP,
> > > +	NETDEV_CHANGE_HWTSTAMP,  
> > 
> > Don't create new netdev notifiers with no users. Also,
> > NETDEV_PRE_CHANGE_HWTSTAMP has disappered.
> 
> Ok, right you move it on to dsa stub. What do you think of our case, should we
> continue with netdev notifier? 

I don't know.

AFAIU, the plan forward with this patch set is that, if the active
timestamping layer is the PHY, phy_mii_ioctl() gets called and the MAC
driver does not get notified in any way of that. That is an issue
because if it's a switch, it will want to trap PTP even if it doesn't
timestamp it, and with this proposal it doesn't get a chance to do that.

What is your need for this? Do you have this scenario? If not, just drop
this part from the patch.

Jakub, you said "nope" to netdev notifiers, what would you suggest here
instead? ndo_change_ptp_traps()?

> Just some thought:
> Maybe we could create a PHC_ID 0xXY where X is the layer and Y the PHCs number
> in this layer, but what will append if there is two MACs consecutively?
> Also in case of several MACs or PHYs in serial
> netdev->selected_timestamping_layer is inappropriate. 
> 
> Maybe using it like 0xABC where A is the MAC number, B the PHY number and C
> the PHC number in the device.
> For example if we select the second MAC and its third PHC, PHC_ID will be
> 0x203. Or if we select the second PHC of the PHY it will be 0x012.

I think the kernel has (or can have) enough information to deduce the
timestamping layer from just the PHC number, everything else is redundant
information (also, what's "MAC number"? what is "PHY number"? how can
user space correlate them to anything?).

If you want to design an UAPI where individual PHCs present in the
timestamping list of a netdev can individually have timestamping turned
on or off (for a future where a socket can communicate hardware
timestamps from multiple PHCs to user space in an identifiable way),
then that is fine by me and maybe even a good idea. Just be aware that
the current kernel will have to deny more than a single active
timestamping PHC for now, because of the lack of hwtstamp identification
in the SO_TIMESTAMPING API.

