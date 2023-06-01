Return-Path: <netdev+bounces-7038-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B0657195EF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 062BC281694
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2782AC2C1;
	Thu,  1 Jun 2023 08:47:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BDF5231
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:47:03 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2135.outbound.protection.outlook.com [40.107.243.135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74903138
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 01:47:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chdwNDVMObCuipjIJpys8zv0vBVcqia9BwuoPe2WiqN6A9HkZCfjvEFf0LJnmy4S2/YMkvYtuFOPSMoc4GQLIf+x0/4a3ZEJVMzl3rQoAm/5FCur3Oz15D7dTGa4MZ7z/q/APyOIW5KDzVrypT5Z7QOFppCKzJiIFucIHD0+qkqab7sSPLVjEM9q1XYhSsxtIfF2RGtnWou4yJiZlJ6+m8SG7gaIYMl03WTJ4U3QDr/ZzJhUdlu0b7hXoiO6HfLqGPq5r8OfSHDZDD9kc4rUjXcSSBuDLtY8VBwH/62gLy2PLkdZqDB91Ho6HbNZrpTVrDE1uoWI8XgnAFsonTyuww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lU3IGPZsjXkYb/aSMPeNWUm9RDNBQJSrBxvF+HESl40=;
 b=A+KxqRNoGguDZkUqWoSrSu3maVYprOynHu3xHbuuZ4tgWaqhrTZa99Fxzd+gTwrFStQ7DHnDR4WLD+itOwe5jnC3zd9qRfIHqcXSP6vrSWbrboROAAa/Tm16x2ut3WfkiBNMg7i9UOefVpnhvwnlWuR1Firajnha5x5SlM9oBYetVkLo0n9qzSF9OewTNFg4jE3T3Y/Znl9bl2dEMkZ3m9YV1y/AnBy5Wy44CYmXQd6Je8ArJwEjHmV8Rc/1ZzH5GPAtY66Vtiwm455pdGq199R7R9IdFHIkVaiwtccruSRqCLwBHZBBWbof0Z7yzspX2tWGSDEYV6guniC2ZHN5vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lU3IGPZsjXkYb/aSMPeNWUm9RDNBQJSrBxvF+HESl40=;
 b=k6uScg6B47TdbxHitbXNVgcPmtzQUHbxiat8/WZYqKORGKt8yTdrlmp91qliFaWI8BcHPX2G+4Pwo99HShfudlfBPDCvjGpUT1RzZPBSdLaZ5YLVkWE1LbWfVxdMzeLTvVh8iHym4DL0M+/B9AZtQ4DQuKsPGGrKNq2T6ThHjzc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6455.namprd13.prod.outlook.com (2603:10b6:408:196::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Thu, 1 Jun
 2023 08:47:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 08:47:00 +0000
Date: Thu, 1 Jun 2023 10:46:46 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Tristram.Ha@microchip.com
Cc: davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
	netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs.
Message-ID: <ZHha9tmg2ZfsKCYT@corigine.com>
References: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
 <ZHIMF8k+bYGosakh@corigine.com>
 <BYAPR11MB35584E92C5EA85D79800528FEC489@BYAPR11MB3558.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR11MB35584E92C5EA85D79800528FEC489@BYAPR11MB3558.namprd11.prod.outlook.com>
X-ClientProxiedBy: AS4P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6455:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e4f2d98-988b-4ce2-88c7-08db627cc399
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7qUa3r74+F/cjv6C/354fVWqEAEy8agtk1ilc2PbD3+T8ukQn+Ad4nIRMpIoZxcR3OgdbmyXkIuXnhF3bziKDgXIHwt8ymKAHzBu0XJIo5EaJOER+lu3cKzcR7Gtl7L5wRH0SF6LIY151Fi5jpJMR3LZj+qCs8AomRKiDW+YeFK7V1/3G9isTq/rgINHE23zpWKcSOv+TM1wzK+D9+fI8iH6zFMvELceBf4Z0o51+7GP0xYaVIVlV8mU7kv6BGC1UvFnm/coHbt+GGdKmqFMoETfN/iaegAngkJ9SVzkXDsZuNbkEoQWKzeZpyJO1hIIW0j+vp6YFQFhgKJZL7D49iN0XffArz+rWXKu1f4TyRs/yWPBKgyhPlp9KGBDsIewEey9G0rRPXG9br9BonBskycb/6JewifLuhsJ0rjW9HrSyGTOdNgB79L2yigIvzEW/Sp2eXXVhVo1NBZSkfH6eWOvD47mBTfQqACDt0Gy12FcBa3bZJR+ejaJkCUprm4kfgc0bUl73rU2PhlMCy/BoL2wjeoZWjVMgnK9HDzM0AXauuX5lbtQh1XGX/AoElFAtWQZGdm8x8P48cvKV9i3lcfUpNhNED46avu/R/+PRms=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(136003)(39840400004)(346002)(451199021)(26005)(44832011)(6506007)(6512007)(2616005)(8936002)(5660300002)(186003)(2906002)(8676002)(83380400001)(41300700001)(478600001)(6666004)(316002)(6486002)(38100700002)(86362001)(66476007)(6916009)(66946007)(4326008)(36756003)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mv4+mEwh4T5vPycWy5nyBwN+17JiXyf1+FjGLSFRFFw+vvGk8Nf1hE+Nck1M?=
 =?us-ascii?Q?FkiH6+uou9enVVxc/Jbz3brUQbE42f4Nq6IwXDvRJIUsk4FxnMZawSLpbEKv?=
 =?us-ascii?Q?o4NxnFRfE/hppltM/gyEvJ1sdSls4A7f8FZ3csheLNp2R+Dssec+oJX9KKRG?=
 =?us-ascii?Q?7yp/HUN19HDgtmU1dSbGu6ECRf59GsA5huZwFeagkQD2SfDFWVDveFyU44FQ?=
 =?us-ascii?Q?TTc/NLsS/Z2uU6YZEbD86GVWzzhs7rYZxpZJ+ynKfkYLfoqQKvEalUKTngB7?=
 =?us-ascii?Q?X1uBSahaUgV68fIojZE1pRBzzjwUBxp1N8VyO/1Y1BsNYgfhNs9eC+pot7hC?=
 =?us-ascii?Q?FGy6wE1BCaoHgvfv19+30FsnDErzSXkl6+CCv3KGJWz1aMQg1nLPVHXLUfMG?=
 =?us-ascii?Q?PxVz7Vx4982YJGfCzOqTZYoBDp/Z8P/LoDhRVVYHZUl7Ht74SaXHURGfm1wh?=
 =?us-ascii?Q?m+FUHstTo84QXS6/xBZq8X11VRY/B6f8P5OkBkb3o5ZXBXqz64eYV/KuoaoE?=
 =?us-ascii?Q?kupCtrtsnbCqIvme5lKe5L4Lj/+CB23V1P18aMIyY33ujVMvqDt/j4eO6cGE?=
 =?us-ascii?Q?CtPBxJ2ls/qGyVTsSsZot49r0gJMzOZk+cKaj25o/SFsi36tBQJuaFsyzQnl?=
 =?us-ascii?Q?xiP4zzBNbvYzRDD88v2+tCRIwzIDUdtgOAKmd+xDhcq6ZLm0TpU+53hQCxk9?=
 =?us-ascii?Q?SPOFHbii0/Npa9FHnF8Xl+aBYyqHP2zxCUu3LliGH/w+0ioUE4YUR6KaRwvz?=
 =?us-ascii?Q?/7lWoTVLeHw5f+3SycxyJdGAs0xdRfRsbf9wtUmQQk2M3RNMcpziHRLkKpYw?=
 =?us-ascii?Q?sLjaMDS/Xddg8hvQ4yJ9wasWmbs2pZiX8+mGSc12HafvlNesP6RXB53ciXRF?=
 =?us-ascii?Q?z6paVcjDQLf7V7NQt/XvZbk+4EY/D398swnZqhII6M35jjoltnW9I/RFubLC?=
 =?us-ascii?Q?l1crRoVoqwRWtKDjVfBR72PXQKuF5gVXGl8O57GCJIwW2y4p/MteBchsIkPa?=
 =?us-ascii?Q?o4dkfcU52tOniG5O2qcSeSfxkuqBvTWaCvyQ8y9oo060oEAY47Jud44rWzLs?=
 =?us-ascii?Q?f7Err4fdbiTLkoIOkhB1XmdWzsgkKh67LZnyknFKzM5sPN40I15aNZTmqrFA?=
 =?us-ascii?Q?hkCrQJadu0YDuAsi1vCDCLRiklcYr1E4hy/GJGX0KerTTH+AwPfwR8vZziTI?=
 =?us-ascii?Q?nfDqnPVu5p3ooMVoUFwH5vCTqXeRv8wqkkB6fRrwmQQwAeLgGjsMOqitNgmU?=
 =?us-ascii?Q?RTssWogMutR25Ng7ZIZXQ4SigufaoHzoTiF5R+lEEQ+mdWQ1MxqsMMOtrkg1?=
 =?us-ascii?Q?hd7auDZX/frH1cpkWnqwd+IHYAs5fvPGYRkqwYSP1TTaYEx80A09wZcrqbdZ?=
 =?us-ascii?Q?jaJi/ed1H0/NewE1rMqofbuH6s1ELvO8xxfhMMZ64hACd47zGOhKjXEXnmZR?=
 =?us-ascii?Q?/4cUu6ovmwSVE+DRwlBmzN5y54/jLodMcDs+gFyPwUER4QOECOcck7n5brfP?=
 =?us-ascii?Q?s/tz4XqK5ZS5c80X+9DwcGCS38NQ9xZ80qqRmPWfqCsPsAuxjMc1xJ3X8Rli?=
 =?us-ascii?Q?5yXXpnlW4jenu7NPLFZ83Wan0DzU2Qjg/92s0ypkAabdzdNFnNz7Pfv1Qu48?=
 =?us-ascii?Q?9g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e4f2d98-988b-4ce2-88c7-08db627cc399
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 08:47:00.2192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lg77qYiKIIB8NQce/TZTVHEHUfklE5TWoXQXTslKADv9vtrWnM+3M43jFZpUFEWTbEqGvhGk61Zs+6yWwQgV5Z01L1w0dzYue9zhTP3MHTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6455
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 10:52:22PM +0000, Tristram.Ha@microchip.com wrote:
> > > +     if (wol->wolopts & WAKE_ARP) {
> > > +             const u8 *ip_addr =
> > > +                     ((const u8 *)&((ndev->ip_ptr)->ifa_list)->ifa_address);
> > 
> > Hi Tristram,
> > 
> > Sparse seems unhappy about this:
> > 
> > .../smsc.c:449:27: warning: cast removes address space '__rcu' of expression
> > 
> 
> This will be fixed with in_dev_get() and rcu_dereference().
> 
> > > +             /* Try to match IPv6 Neighbor Solicitation. */
> > > +             if (ndev->ip6_ptr) {
> > > +                     struct list_head *addr_list =
> > > +                             &ndev->ip6_ptr->addr_list;
> > 
> > And this:
> > 
> > .../smsc.c:485:38: warning: incorrect type in initializer (different address spaces)
> > .../smsc.c:485:38:    expected struct list_head *addr_list
> > .../smsc.c:485:38:    got struct list_head [noderef] __rcu *
> > .../smsc.c:449:45: warning: dereference of noderef expression
> > 
> > Please make sure that patches don't intoduce new warnings with W=1 C=1 builds.
> 
> This will be fixed with in6_dev_get().
> 
> > > +#define MII_LAN874X_PHY_PME1_SET             (2<<13)
> > > +#define MII_LAN874X_PHY_PME2_SET             (2<<11)
> > 
> > nit: Maybe GENMASK is appropriate here.
> >      If not, please consider spaces around '<<'
> 
> Will update.

Thanks, much appreciated.

