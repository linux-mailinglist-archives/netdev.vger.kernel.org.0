Return-Path: <netdev+bounces-6547-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB003716E02
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:49:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74F6D2812D5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91572D276;
	Tue, 30 May 2023 19:49:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6580200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:49:51 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31613B2;
	Tue, 30 May 2023 12:49:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlCBunIvmU6Hjz1A769HXbjFtp5FK3iZCjw1NprbsiiQ0i/zD7AOwSzoR/1bPjXH9rYBIxVqTVrluviS33sqOfdikcnv2yCJ4iZWl0ZgUNvYR5kK1lZCwHmGk1PmhyFbs3sd4YFBcvvTKXr82cwi2InerlJG7GWoG+8XBw/q3NeT+h1s8N1QN28Z7bjHuQF3Pwi6+lh5NSWgAXxWPBG/J/UuxbzCXzWm2aiwCzdro7WKagj7QkFqcduCdsd+/S7NYqUPr3FOYW32zYQ/2Fr6nnrAv0fS7ofmSc4djZ21rdIeX22VQGjkee/Ch9UNzVxkuntwER4zOqbVbAvSAHIBHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4LuF68gyQnRtlGDCHaKmKzW+gw5O+PP94ixJ0YapXjk=;
 b=QWRWyi1MF3BFIDTOlyeHQmBg/KSiZg3eT2cOWa4KGTQqgGe040nTFuuSg7bPsI6Cda8Cet7+r1D1RaRE+hRoLJ7HkBOwTNrirDJkoiJIMIoG2+kRLKbn6AafDgsEbG2Fu5EszihBfDRUyzMZloIUSVV2CmW8BM75Vb+zfJmMbOAguGez6ImTEIQZAjdDQyFufuLOEbx8Sh50YmqaT07LoWHuLHWruNZeqGQ1BRGoGP+FGrQPFe3UYXuz9k/i29RZIwbIa/Bz3TecxA/UP5cdPjtAFvo+Fxdcls7rA1IHH9rSx27zq0cpae1VvIjWU2Hsc0n+GSgVB3RhvoDqBVQB3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LuF68gyQnRtlGDCHaKmKzW+gw5O+PP94ixJ0YapXjk=;
 b=n2bQYuw/GNMTwBRU3yPpbamJxBsokMT3JTU+gqFedEbE/itzUct/2luypOe2lawWTbhagjBZChoemJoQNWZYt+/TiLqjcMVmraS03M6tqXdRfhNDdlc41FxtvImo5MWxkZjOXuZy56WZqQVGOuk4qtzAEU72lTOgAAhVv+qOvB0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4615.namprd13.prod.outlook.com (2603:10b6:408:128::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 19:49:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 19:49:46 +0000
Date: Tue, 30 May 2023 21:49:39 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
	Thomas.Kopp@microchip.com, Oliver Hartkopp <socketcan@hartkopp.net>,
	netdev@vger.kernel.org, marex@denx.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] can: length: refactor frame lengths definition to
 add size in bits
Message-ID: <ZHZTUw9HWE10CUn0@corigine.com>
References: <20230507155506.3179711-1-mailhol.vincent@wanadoo.fr>
 <20230530144637.4746-1-mailhol.vincent@wanadoo.fr>
 <20230530144637.4746-4-mailhol.vincent@wanadoo.fr>
 <ZHYbaYWeIaDcUhhw@corigine.com>
 <CAMZ6RqK2vr0KRq76UNOSKzHMEfhz1YPFdg7CdQJqq4pBH3hj5w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6RqK2vr0KRq76UNOSKzHMEfhz1YPFdg7CdQJqq4pBH3hj5w@mail.gmail.com>
X-ClientProxiedBy: AM0PR01CA0170.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4615:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cd1c923-85d6-4cbe-2dee-08db6147056b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fO0ysoM70nyXaZQGG3reNo5jzWRoD5hp9emDKfHvJs7CvXlubmMtn+qvTcO4aELzPRshbAaw3VjtoNfLDAmP7ssFqdu8QCNfUrE12LDzm9Nh6SnZL0nwOFOy32Gf+mGIuBlHEbTLK9f3PBLiT95NrAVhcj5VV6L0ovZEkRBGC56InVDQ45i2DLvQNdghTjRvBeOlgUel7FTAVToIYSXasWWVMJb16qCm5uBnLQLxMnS8gSf/xbrnV1/Qk9XRG+dZmE/S41ZsxYlVDWAR0YNrk716AGXv1QXNEHz1mA++RJCSscAJScBl3WMiBbZ07hLL3an/NXpnjIP30UVMeA25CrjW/WGB36D58C2UM4knPi/62t+ORo2qnCLrH3KFTf20e3097Fe4C/tFhCV9EQle0e1q4CwznH7wLPSLok8VM7+bzVL9dx0VUXB4AA7JZSwRhjy0G1wNr27brYJOvZOVDbie9PNYWBCQ3PQ+1nzgV9i2FlZWV8vN6TNSptcYk+aL6WvDXOs6IGmQOSe8Sbj+uWyKGLfkesFZhJpsQijweyg974krj2DuqGAjkZC9xkvmgpk+YIZfn40BMP+f5S0xr4F+6Fi6t9njtQIB5STPp5E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39840400004)(136003)(396003)(346002)(451199021)(2616005)(186003)(6512007)(4326008)(5660300002)(54906003)(4744005)(2906002)(6506007)(36756003)(86362001)(44832011)(478600001)(8676002)(8936002)(66946007)(66476007)(66556008)(6916009)(6666004)(316002)(38100700002)(6486002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WfgbiONmnxbDlatV0ho75korMsVU52lzkz7PPoZEZdp9HJyd/O9Awg3xl799?=
 =?us-ascii?Q?5IFLFknTUINUBxJIiGBwilF5eoDKvlUUKR1eT1apKIq+kfoSZxg0RPRvNdbD?=
 =?us-ascii?Q?u2rxYzsdejk6T7DnyJrETHn020R2aCruFBafzDKIggh6eiBppXSVjZ7T6hkK?=
 =?us-ascii?Q?jeg+9L9JKRVJEunUDwfGowQFmrZuPUkf6/I6o/Y8OKBuaUckj+BEMQSyO1Vt?=
 =?us-ascii?Q?vF32lY9jGlk70/9HOSnb5neGQp+yKfgPzBnT0pRqly/jvCYN0I1A3C43nRYx?=
 =?us-ascii?Q?xILU9x7Bb13EfNbSnrFLDWr2fs6FM1XTPp1JOZOiT78neEx/LLnd/aqc6GIi?=
 =?us-ascii?Q?EmFZC2gv7ETNMXSX9luhyocQ69BQX2oy3gcHvHDz1NSTDKbu7fwXGl3AeEo4?=
 =?us-ascii?Q?HDa+DxeJFrFUrsmLreIu00YaggvzRLWpm6POmcFkXt6odFEVVIdjLxHvbVoP?=
 =?us-ascii?Q?MOrWlOktUdQZtPYZKcBg1/bR3/Jw24FkF7qMfn+vb0C2xK8Pbhpw1H778lNI?=
 =?us-ascii?Q?zfOsuo0y0RdjUD55it7hILEutsMTJCLasqfu5jvyEMQvDfBcs86+EoU4PAr7?=
 =?us-ascii?Q?o+pfnSCxf/d0juwbq65z8547JKVtjJRyCAVfgL87Qqd5vmANDf79rbdqP8LT?=
 =?us-ascii?Q?frMe5tWXWnkv+/PzwUKNB407HSF+cYjHG883HcIleuILEMJFpJTw3yqHHthC?=
 =?us-ascii?Q?py5EtAYk9It3iEKpDN5Qhumpv+A+mVqyhdl/brXJfHBYYKyeFlkc/sT3y2sE?=
 =?us-ascii?Q?srIWop8MPkv87s12YdoSkmlvusN73xvKkYHGJgw2W63i1EDcOgAdmkO/Kt9t?=
 =?us-ascii?Q?47V7aUpbpikxI0w9/REL1buFn6LHAdiTWdoA7tUuvfv43S71/NJyKYRtQVgn?=
 =?us-ascii?Q?MQprfwArCAbfJwVcgrLciENVPV0mpAK0hHEw/D1dwDQRtckmJC57OBxoG0mb?=
 =?us-ascii?Q?V/rw6VEnl+/kM9aUYgB9rAuBGsUrmJf7yc2XRXmhfa7VArGFCcoyN+C/i0gP?=
 =?us-ascii?Q?NoBH7b4xvJTdbkeldUs3pc1F/gu3SNhbD31ed74aorl/SJqH3OcYdBO8+U7v?=
 =?us-ascii?Q?xkwTT/DpXcPafxI9DYSq1PGIKYoiBPOegwQKToT9+JMiFIACdv/SsBNuXjWV?=
 =?us-ascii?Q?J5QPCuJWdVY+wTXgIcy9vzljeitjcJozVaEsWoT97qDMoNidmpmj1xZHDeTZ?=
 =?us-ascii?Q?f8cQgWCrGW+ZGTz5SVmfRZ1EWfOIGi4bbTzA7fsBBea/otTC2U4bmOpeOp9D?=
 =?us-ascii?Q?eiM2FYNG3a+OJpDnJtILHBos7mq/bg70/RrN0L5c6pMaf1yA9j9IoPXnyId0?=
 =?us-ascii?Q?o4xrIbdMuliVkizcW8DIARap45u4niU4PI73RpK5OMR7inVaH1DnSRk65Onx?=
 =?us-ascii?Q?evq3ll1Xp6ctXnz2La/L+nobpG6X4ZcoC8/tHpj95Nr6p38v5w+xzJDaRNct?=
 =?us-ascii?Q?7nzBd/Wrr+g8Y9sWs7kIU3l9WrZGvLr3XJ8kMwHPX/ZIskxX7EJSRtunokcj?=
 =?us-ascii?Q?8vElaFC0sqd1aAT8MgCBjb05E2Tw/b7DSvkpy7eI91/C+2zbZvGpVS1QxuKS?=
 =?us-ascii?Q?7iBH6Cg/lobQNpFtbM52wnMfSvgGHt98MqvDjWjaqJAtZzqxH7eHJdBiKbSr?=
 =?us-ascii?Q?CXikokpSNRznubcWQKIYc5QqFJcg53n/AdP4cDz89BPGch9xt1LG9CfkA9Hz?=
 =?us-ascii?Q?RSkK7A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd1c923-85d6-4cbe-2dee-08db6147056b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 19:49:46.6085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYrJVoo0OgAHlzIfhrSS6MLsRjQB35t9p+9yWnMKs64sfvZwtjzkQ6SXHCWDE50vWUlZFkYe/jypGQqcw4NR5ktaWrORfW9GDFcyBWwuuWw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4615
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 02:29:43AM +0900, Vincent MAILHOL wrote:
> On Wed. 31 May 2023 at 00:56, Simon Horman <simon.horman@corigine.com> wrote:
> > On Tue, May 30, 2023 at 11:46:37PM +0900, Vincent Mailhol wrote:

...

> > > +/**
> > > + * can_bitstuffing_len() - Calculate the maximum length with bitsuffing
> > > + * @bitstream_len: length of a destuffed bit stream
> >
> > Hi Vincent,
> >
> > it looks like an editing error has crept in here:
> >
> >         s/bitstream_len/destuffed_len/
> 
> Doh! Thanks for picking this up.
> 
> I already prepared a v4 locally. Before sending it, I will wait one
> day to see if there are other comments.

Thanks, sounds good.

-- 
pw-bot: cr

