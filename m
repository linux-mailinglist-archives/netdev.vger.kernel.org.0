Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FFB6E467C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 13:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjDQLak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 07:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjDQLag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 07:30:36 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D0B72B1;
        Mon, 17 Apr 2023 04:29:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHiraOzF6iW/Hd+bfMYdBnm3CBcejsQ+dlU3T/UYhdxwpedYRx09+Au9Q4GJTiKFsg4+j4NTPxBa0yW+E246lHgbQzvRJWcvfgvnlcBvDfrgQz3vRTQNQfvqKst687G6sh2Im7LDw/UjUxm4/RWjrMfhzT0q1JuP5aOFPs9bfJSwV8jHGLO43JQWVawtI2GwAGUFnJo4ih4PQKO8sLI6UqhKQovz15o0uAkE/YlLHBf4Nm9lsUM95bwrWFpKBn+O7qzAy6CcHiyhsMGe4yo8zaGB9ymLKtoVc3Ntb0Uh41Ou3g0W7M7+oqZlFAyzG0t0c0mEW13Cq16Ru2UKiSwzAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TZuCnIPF8V0xIsRwTrobY6BXoO0odj0vW31o/UoNeo=;
 b=Zxn816QbXXQevfTf0+lUcBR1C4d9F/vXMPyJCmXs89Nc8//LTybvZ3xlzZ4Rj3gSb0fDUiUtXtLood1tJWbGfhekXaU56u4dR+O5uxdFWgF0Lfb7skmjcSpJJoaaXnhrL5gbUQYMRH/9Z4mq2pHquq0fulSQ8bYZwap88d2FgxcM1mGjgUnfvaBKQSxwzDVjBihdiaAJw3tXdVJRLrP8sBzZwOe2fKth9lBfD9EKjbeKgz34cwLRBQPW7T8udHlA1Y/GdRmj6hDPy3HoW9JDClD8Y34aOMBf2ZXCJKy7NlRqoWajDqMM7XUlXQ3HX/PgwWV+9hO5Uzy4QWPutLdetQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TZuCnIPF8V0xIsRwTrobY6BXoO0odj0vW31o/UoNeo=;
 b=A2bBDJ/L/ogFT4IfukrhZB1KMTFy1MOq8Fo97gkAZ1ecOcd8ZP3yuDdYwZD05P+iqb7zLnWI8zXhcGqN7sxw3AE87WbVcAU1JOTjhCNvKaIlLTA5hH6VCBGlm9yQRaPFPQJF+P40KjAQN4JnS/k7rv07/nnnSdWq0pwkFK/788c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4035.namprd13.prod.outlook.com (2603:10b6:5:2a3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 11:28:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 11:28:48 +0000
Date:   Mon, 17 Apr 2023 13:28:40 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] wifi: mt76: Replace zero-length array with
 flexible-array member
Message-ID: <ZD0taOx3gjSIB3Ax@corigine.com>
References: <ZC7X7KCb+JEkPe5D@work>
 <ZC/FA/t1mzrRydD7@corigine.com>
 <cec9fa10-eb1e-dd5b-8ec0-579e87b5bc1d@embeddedor.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cec9fa10-eb1e-dd5b-8ec0-579e87b5bc1d@embeddedor.com>
X-ClientProxiedBy: AM0PR07CA0027.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::40) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4035:EE_
X-MS-Office365-Filtering-Correlation-Id: fbe5588d-2766-4af0-ca99-08db3f36e95e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sNKH3cvY7f4pIUz9fT6L3XyEMMJDa7CCyjiLaNxCBMAKExwy3fFzzIBMTo08gdKGf3ahRrlAesrz7a6yFWkoo8hIa9extwal9E1jYrpXlxrPqKYD4ITjSJVYmK+rpCWGtEGbuNvAP4Y3ffoyUpH/GJhu42ybvffCWBLUTxN8+Ygk1fQmfo15duboPSJxLdmlXhmSbZeVLx/nzNIjdpmzE4FcfUQRin/KAQYHjiCwT1/zTt6GvTvRt6DB6RQE6cDTwC0y9pZpRdLUl2cedOWfpoDxWH2w8eBk6Ziebs8GSGH6su+KBt0lZdhDICX2CPvLJ/83TfIG/xZqqLWbftIwfkf5S4DY5DObUWsD6AzrRTUD3XAcJ/XGjl9nMfxBy49+T6uE7EAVlqDXzkBTu7Zi3qtgQEo2e9EkyYIkvOxnVc7iS0d/0z+cANndGJpGb0TdfptJN+JNEziFZ+9qJiQynGYrf+oMgYwBwnkB5AgH03uC4+exkWZ1XvpBXpTQG9BwByh++FG8X6O/YgG3zCMOqopNwd1Eef9oSyZSLd0p3mRLexnZUjuoSuEeKYqIcg1aE1t6IEFtX9k0Ie6loiMhf7u7ZfJCNALMbAQYBkCoXrQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(346002)(136003)(396003)(366004)(376002)(451199021)(38100700002)(8676002)(8936002)(44832011)(5660300002)(7416002)(2906002)(36756003)(86362001)(478600001)(6486002)(6666004)(54906003)(186003)(2616005)(966005)(6506007)(6512007)(53546011)(66946007)(66476007)(83380400001)(316002)(41300700001)(4326008)(6916009)(66556008)(2004002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2rjRF4mML/xCcYkqyA6AItClbUWsW7hGIIbHkBSraLngFIN2Tz3E4+MoNCDH?=
 =?us-ascii?Q?RRNphXkfq6fGlbLvOXczm0xwPKp0tBNceUNGHPalgFZkQ6BxVWzR+E85W5bv?=
 =?us-ascii?Q?quzK8U2Zk4eqqvX3X33YeZW3HM0czoVnDjZ2RAxGdJibjZudkXsEMVei2vcB?=
 =?us-ascii?Q?MyfxMAQxK50mc00A/l200zRxN8iLR3d4pgrC9Jb9+ZxMAEsgTYuZQaTyRIo/?=
 =?us-ascii?Q?VnISAIAguRy2nkAj4J5h3JaYGsRw9hKL0wj2f3iWTT9FGSK+IUACfYAlAIC1?=
 =?us-ascii?Q?khcdh8uh3V1SIEWp+v6T3qucZU3npFx9hhoi/vYY1f0YSCn+o04G9G7iYWMX?=
 =?us-ascii?Q?81pdeKi53XE1g05KhOPmKawz59sFeOX56jAeweFawKg5S15nwHEKJlOJzH1n?=
 =?us-ascii?Q?9fjrtoPYKKyiSVjg+6D8wwCyfwX499DitNpPFrEfIJTC3/Cd4J5fdEewIb7X?=
 =?us-ascii?Q?sYpFIoMeOH8adrEYMXcRlfkG4BAT3KEa56rOgQrK00mBJqHwRkuHu+0VSaOB?=
 =?us-ascii?Q?q7EFavT8XNfxQTOoDuycsXUc6GeQw80zwlgsSI01yRaylm8Nv+26s7O98AXS?=
 =?us-ascii?Q?DuQ+wnqAwL0zBWOxP8+WLjMlSp3TnrHMUhyYuOGH33L51weW5alKMWNcDNSM?=
 =?us-ascii?Q?e8cmGOvTWLNnxVdarZF7kCuoQWzdv+g3yF2xt/Z86MzHLEjP7oVI9HWkNq70?=
 =?us-ascii?Q?xvGL5vHOZ6OgXZpGqqaIYZJISDD0XKyKyrihl3VVH7sinq5JDRpKztXITVTb?=
 =?us-ascii?Q?nEWJqvb3TC2HQ9WWtPYdYojRZ7qdanfY5Lut30vtHLbVq+dmpZFdPnjV0+VW?=
 =?us-ascii?Q?kvzNN0rWz5Rk1yD3eN/hkLMlLl07tjfT+YQm0dqUXYJZRKz0NrXTg4F0Hpwq?=
 =?us-ascii?Q?2h303aF+FXx2o5rzCMbMjmPhW/c5jOGsJpuqL4wuz4mxaTPL5/7nSiKaWFJy?=
 =?us-ascii?Q?wFS29TNCISDhcPJhYDUMssyNzJWeqDM8eskBW2xqx7QkbLe2sXXYcR2OAwCb?=
 =?us-ascii?Q?wrEUjFII1c4aCdWe6L67OVSP7hhDucKFRlx7i8j11fCt1m8c1RiP95KZze9p?=
 =?us-ascii?Q?3pzAe+NjG46tJb8DWnpTJlQDNUxj2ojdhsh3yg+MucoJVGALwv5m4MgAg4WS?=
 =?us-ascii?Q?PZZa3b1prdV/TzahVuDyRDoBYwQsRBueYSbeVYjXJOivRMjRJPGvmxnxoWR1?=
 =?us-ascii?Q?bqZo9rUbKYVyPbLqRLe6ASNiHNVCOJl/zRnvpL3kMRel2Bw+G2Z7fpARiOuw?=
 =?us-ascii?Q?0zuBJ51vj+1lri1uHGIqLFXODN21VKfJQXUnexbqK783ZhySJ7HdwlFybzK3?=
 =?us-ascii?Q?GD28kILGxaBBiM7J3wI8DvzVCty3ixOP2kszHo4+MRlFpd6WywWQXFvxb/eI?=
 =?us-ascii?Q?0frC23NP4dpAdwRgfRgpTFt7ILc5zjXBEJToR/cXx7H9h9LjrGXy/fxzP1Uj?=
 =?us-ascii?Q?ODPqX+gCvTXqx2qiTLqoqm+widsgY1mjJo36qE0BiImfFv66qFDyNVZ+yky0?=
 =?us-ascii?Q?mkoHGN3qTu0Sp4fbOVveoU8ElukNNZqI6dQ4C6MuW8xwnQP47dxO5hxJIM9X?=
 =?us-ascii?Q?uCvAIM8qlSe6PViMtW4wpbPX59jxzoAGeQdVH7gzXYgtLd0M9z3aOBjiajMV?=
 =?us-ascii?Q?8jinLxfOI/L+ctaI+ulaFvNSbYysoK3JSe7mQEpGuQrgvcevW5lCq4YRdLpZ?=
 =?us-ascii?Q?U+OiEQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe5588d-2766-4af0-ca99-08db3f36e95e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 11:28:48.2452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XRAjZ6crE6wFleHfwHJdK3nOz/lRr0netlVeVqJlPbhUleA2+gp70rZTtiugDCMwVt5fHONUNpgnQGOMnUtWbNQ9v1oyu+7zXGetCsLs+po=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4035
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 12:39:06PM -0600, Gustavo A. R. Silva wrote:
> [You don't often get email from gustavo@embeddedor.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On 4/7/23 01:23, Simon Horman wrote:
> > On Thu, Apr 06, 2023 at 08:32:12AM -0600, Gustavo A. R. Silva wrote:
> > > Zero-length arrays are deprecated [1] and have to be replaced by C99
> > > flexible-array members.
> > > 
> > > This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
> > > on memcpy() and help to make progress towards globally enabling
> > > -fstrict-flex-arrays=3 [2]
> > > 
> > > Link: https://github.com/KSPP/linux/issues/78 [1]
> > > Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [2]
> > > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > 
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> Thanks :)
> 
> > 
> > > ---
> > >   drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
> > > index a5e6ee4daf92..9bf4b4199ee3 100644
> > > --- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
> > > +++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
> > > @@ -127,7 +127,7 @@ struct mt76_connac2_mcu_rxd {
> > >      u8 rsv1[2];
> > >      u8 s2d_index;
> > > 
> > > -    u8 tlv[0];
> > > +    u8 tlv[];
> > >   };
> > > 
> > >   struct mt76_connac2_patch_hdr {
> > 
> > Curiously -fstrict-flex-arrays=3 didn't flag this one in my environment,
> > Ubuntu Lunar.
> 
> Yep; that's why I didn't include any warning message in the changelog text
> this time.
> 
> And the reason for that is that tlv is not being indexed anywhere in the
> code. However, it's being used in the pointer arithmetic operation below:
> 
> drivers/net/wireless/mediatek/mt76/mt7921/mcu.c:
>  164         rxd = (struct mt76_connac2_mcu_rxd *)skb->data;
>  165         grant = (struct mt7921_roc_grant_tlv *)(rxd->tlv + 4);
> 
> 
> which means that it can be considered as an array of size greater than zero
> at some point. Hence, it should be transformed into a C99 flexible array.

Understood, thanks for the explanation.

> >   gcc-13 --version
> >   gcc-13 (Ubuntu 13-20230320-1ubuntu1) 13.0.1 20230320 (experimental) [master r13-6759-g5194ad1958c]
> >   Copyright (C) 2023 Free Software Foundation, Inc.
> >   This is free software; see the source for copying conditions.  There is NO
> >   warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > 
> > I did, however, notice some other problems reported by gcc-13 with
> > -fstrict-flex-arrays=3 in drivers/net/wireless/mediatek/mt76
> > when run against net-next wireless. I've listed them in diff format below.
> > 
> > Are these on your radar too?
> 
> Yep; those are being addressed here:
> 
> https://lore.kernel.org/linux-hardening/ZBTUB%2FkJYQxq%2F6Cj@work/

Thanks, I had forgotten about that.
