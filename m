Return-Path: <netdev+bounces-1960-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F3836FFB91
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:02:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C56A1C2107C
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24DEB14ABC;
	Thu, 11 May 2023 21:02:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF8520691
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 21:02:43 +0000 (UTC)
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2078.outbound.protection.outlook.com [40.107.104.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7112B6A76
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:02:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNV2cYfuEHfUHlzekPZ1RuVvV5RRX9+Zi0Sabc3053B1aME8GPn+7fbpP6EcSbp+hx2WmgVfqvje9Wn0um8axQDIiav3vN815pb/wS40ACjm9R9GtTGkoSRZV9+5X30xus5A2+Oq0a/aQIgmzsTl9EoT+4Pd80X+bZnQVfgJogbQzeaZJCYjVgCj6MtOzugyGuvtn7OyRsL4uknJTpzMemj9evbLFh/d8RNCbtIqt7hdDzUGm53Fft/zRKRmPnbw6Dx4J1Tv/wGu5aOHozq2zX5tUI9JMSZBGUcOMEu4JFNpnmo7ge+CE+KD9eaKThjc5MVGjnksniOoiMmCKOItGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dpxjk6PYfYp6NXN6jOtJb/rMV70ojFijvN5v9HA5VhQ=;
 b=N8SmnvxihGFV4wwTFEaZUE+IIl5QXqLLshEloB4E5PRMERy0WoJ199esO+TQLEYbzF/3dEaAhwhr7BujvssionBwp5/PuVjoRILGbmW3eNhuf9Tgbdjv0rhzkR2MxUFJMlAscK/0oab+K9TQ9m4Y00MB7zuLmrHKIhOycWdW/xplgwmRYX48+CVeOQo8LBs05CtFVnCrCt7e62F2CsEcE4xpkOtGTlTK0OdaYzDZ0JKma4AxpIGJ0vVInUWDkA9c1W2j9m1lP0TJOLfgifurZm2Lvx53uXjW3fNK/ryFVEBsijZ14evX28A184EKoBGMUQnSWtz+BEybfj7dDMt3uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dpxjk6PYfYp6NXN6jOtJb/rMV70ojFijvN5v9HA5VhQ=;
 b=ECpd06/wqrJrKuiGge3gbVfXS1FbN39sbmk9VDukC+2+nNg12hVatKc++S1fSLAgxpXSFhL2ItB/vo31WWlbUr5ijLEKNWRZJ+3UH7Q5+U8C4/zFOMRHbjHhQRZb2beB2H01QsYPWgkstnx8it+rLPQOxO4FRE82qImBZZV6eYQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8924.eurprd04.prod.outlook.com (2603:10a6:20b:40b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Thu, 11 May
 2023 21:02:40 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 21:02:40 +0000
Date: Fri, 12 May 2023 00:02:37 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
	=?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230511210237.nmjmcex47xadx6eo@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
 <20230406184646.0c7c2ab1@kernel.org>
 <20230511203646.ihljeknxni77uu5j@skbuf>
 <54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
 <ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
X-ClientProxiedBy: BE1P281CA0329.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:87::9) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8924:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ff61137-8cba-4f79-276b-08db52630e68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6VXajQ+98MAZQCPEryTa2ZzcOSRazhGE/j4VbVoSOqLRzHctidCxQ2S0NYKDPqz/eNVZiZici5FTW8dD0sMJkDTerZEljlrpwZSYqjBCapp/iCFO4zO2H9rktwECy/vZaP+Ox2DH/OhwOXMPOVR89KX152CgLprHBmrbbDNKrpn3Eq8dWZXLTxB8jOWj+zCulIoJ2vK/XVDoi6VpPNgCtmtPGRRfylMhxj2xyQgZOrOiP1Rhe9Nhzp2I1dLRWT0NfvnhIxoveWF3j9EGRhyYLXxD+DORor+SFmCOJ3vvEniZ31ExdU9dCdBpgkJs3PKBVBbEoNjrLrVbAKjwSC0G7gZzTLGNNkzRV/NR+VldRTBM7tv+yHKgsbyWcFezpMGVUSLCKWBua+utS6Osm/1Kmdp/YuFF/lKrb2NUVbo4so682u5YcFzAoCLtotyy8ay+R2IbXxFqWPwNZJG/Okb+wYoJwpFjdsIU6rWuoGSreCYmJVijjehXRAMF2kb1GLlt2F+Pk4PSw7JTOirYXu3LXeqbUw0f3Vg1kg2CYA4avvA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(451199021)(66946007)(316002)(4326008)(66476007)(6916009)(66556008)(54906003)(6486002)(33716001)(6666004)(478600001)(86362001)(186003)(966005)(26005)(1076003)(9686003)(6506007)(6512007)(5660300002)(2906002)(8936002)(44832011)(8676002)(7416002)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oau9vwhCVYkwodz9XX6Z6woZfZY/LZyQUqwp4Qb8sBu9NZSv22t9UT5E7em0?=
 =?us-ascii?Q?8fbyE1jTJASVsm5Soilfur+ij9t6ssslKc6a6OWT76N8u1/ny69Pj4Rsj6Vl?=
 =?us-ascii?Q?s06/o19/W4NxgMJbmtuqI1NjM/zla+WYwQEyrrsx5ER0qJCF0bQ0hIunbJRS?=
 =?us-ascii?Q?sGlXf0yPvRcc6DO/OSifKQX0FahXHFKRV8eSenkmtdPgoez6qVzjN5mKbEvU?=
 =?us-ascii?Q?4WwK9Qt4FNHYz7mKuuAogb/rDvmWRfCrZ3NG9vhIUCxpGzZbE7JlzwpsuA1/?=
 =?us-ascii?Q?6uAGTuSddWmvLxry28a+JGhbVggGXDCthJC2EyNbtW2V0xFhmZ8f3ep1rR5V?=
 =?us-ascii?Q?RlHxzP42cNG9FpJI5WHkzzDI2e8H/VcdTovKtRmLM+EcZSmpGnvcNJqFr9OD?=
 =?us-ascii?Q?0mOy+WEAvYz/VutQZeMHzooI6QDB8wPV0pG08z0h3K9aBkjMiV/eNu2XwJdZ?=
 =?us-ascii?Q?tMaAnKzpN0pBLxoKcCHa3a+Go3vM4P2Yzu+QQPHtrEfgw004/3l7L72eyJr1?=
 =?us-ascii?Q?8k5OXiI7nb8+WfR2yct0Sev3tBboU93YArDsTb43s9hbjcBV0DanC4fVK/9R?=
 =?us-ascii?Q?Q/nFg4mhrdRM9iq7Gu0GUFxuhXHLXmMDzMFCT0Lby2pcau215pEzYAeHHUGM?=
 =?us-ascii?Q?+sgyyhevVArBR/pfYfeSppv4ki3wKiHP0TaUPbzGJGx0eGAqxQT2TXEkt7Pn?=
 =?us-ascii?Q?LdBYaHgZWMOuo/pum1Uu0rXhKMIHXgdB0pmhkGqe3mEKeVTi5EI0+NqfFp6Z?=
 =?us-ascii?Q?BVMUaHpQr+04MFUgCzcnv8tLBQeynTg1E72kJmgM/QkHCX+81gL/Fp2GpAw+?=
 =?us-ascii?Q?vYA3u7zcLjghlMPH+rBcG1V+X+hBHH7s9o0ouY514+p0ejdfa0T0Qt4SMQdo?=
 =?us-ascii?Q?RZtvYr510KR1mdsuBP1KeeBmXdjhFBkhuRKSK4JsgzdZXiQAWz1RaHAddoNB?=
 =?us-ascii?Q?lyWLZsLxBLYKhYwB0F2ts16b8dIYQ3R3G13nqj77M4d3pi9q+9wcuPvxvim9?=
 =?us-ascii?Q?SSWFwFqdW3NWW0iHofg8WyLPPJHvX9BC7l6Js0NI4zHlQLwQLlOcuuzlAbpL?=
 =?us-ascii?Q?I6O8dhqQkVhvw4wM5Xgtkq+EMpOHTg8Bwm8XHRn3HA0POV+rqvE2dxChAKKf?=
 =?us-ascii?Q?2yMu71oOsZJGgseZIgefINfUnzWrFSU1dnSnAZNcFW+FXBg+ShCIC+SKbumz?=
 =?us-ascii?Q?fXS8NlDeDCNJytGHMxKHaK7PCyfgjBHhebQw8b2OtqH5lBYmu8/b/4NXwgnN?=
 =?us-ascii?Q?i0qBohbW+DrUYUzcSYR/qyJKz3WqvO05qlLXvNH8eC17YXcQqn2yZrPc54AC?=
 =?us-ascii?Q?tIfQQIKpf3tK3BmMUKs64SemAU12n9OsXNVxv4XCgfjTkglNMjnJjJvrEmQQ?=
 =?us-ascii?Q?4s6nsV4capOnKEGRDxccluWzW/9izIx4uduZQIbxdy3oBungGRZu/fgDwAMj?=
 =?us-ascii?Q?1emkn7qi0vMRE7KAt8D6gHYGtbmbvkMMuF9Uh97WVji41lqTtMQR9MN9pjg8?=
 =?us-ascii?Q?tn/vI5dkcM02LSCIIqSme7wVt7wFqXG3rnBEzEmwNhYFRjgX2jCArSOnB11j?=
 =?us-ascii?Q?ftINnQdE2o5TezGHi+nuZAkvbhrP01xUK31CSdqYDlzXxd/TF7RLFfpa6D4e?=
 =?us-ascii?Q?Kw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff61137-8cba-4f79-276b-08db52630e68
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 21:02:40.1958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1a2XK4IsXM8qqJoSW6GhTT5yJ2xPR2isoHMwuhVk6BaSFqdt5DLMhOtOgedfeEgaXJ+YRO0p61TJzIP7ZZV6PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8924
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 09:55:39PM +0100, Russell King (Oracle) wrote:
> On Thu, May 11, 2023 at 10:50:30PM +0200, Andrew Lunn wrote:
> > On Thu, May 11, 2023 at 11:36:46PM +0300, Vladimir Oltean wrote:
> > > On Thu, Apr 06, 2023 at 06:46:46PM -0700, Jakub Kicinski wrote:
> > > > > +/* Hardware layer of the SO_TIMESTAMPING provider */
> > > > > +enum timestamping_layer {
> > > > > +	SOF_MAC_TIMESTAMPING = (1<<0),
> > > > > +	SOF_PHY_TIMESTAMPING = (1<<1),
> > > > 
> > > > We need a value for DMA timestamps here.
> > > 
> > > What's a DMA timestamp, technically? Is it a snapshot of the PHC's time
> > > domain, just not at the MII pins?
> > 
> > I also wounder if there is one definition of DMA timestampting, or
> > multiple. It could simply be that the time stamp is in the DMA
> > descriptor,
> 
> Surely that is equivalent to MAC timestamping? Whether the MAC
> places it in a DMA descriptor, or whether it places it in some
> auxiliary information along with the packet is surely irrelevant,
> because the MAC has to have the timestamp available to it in some
> manner. Where it ends up is just a function of implementation surely?
> 
> I'm just wondering what this would mean for mvpp2, where the
> timestamps are in the descriptors. If we have a "DMA timestamp"
> is that a "DMA timestamp" or a "MAC timestamp"? The timestamp comes
> from the MAC in this case.

No, a MAC timestamp carried through a DMA descriptor is still a MAC
timestamp (better said: timestamp taken at the MAC).

DMA timestamps probably have to do with this igc patch set, which I
admit to not having had the patience to follow along all the way and
understand what is its status and if it was ever accepted in that form,
or a different form, or if Vinicius' work for multiple in-flight TX
timestamps is an alternate solution to the same problem as DMA
timestamps, or whatever:
https://lore.kernel.org/netdev/20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com/

So I just asked.

