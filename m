Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20D3665AF6
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 13:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbjAKMEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 07:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239124AbjAKMD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 07:03:27 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2094.outbound.protection.outlook.com [40.107.223.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4716581;
        Wed, 11 Jan 2023 04:01:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0lc8K2wkzk2pHeHzQ5wmDHdvtxZahewGhhilrH4oOmD1y8H3KAOjdbMWWEkkQdcEQUcl5p8NMZzi2OQpD6Hln+5hvio+kkgGFr8NbW2lN7dYYocqWKG8GDuXo8Ke3a1GWvjKvVqot1lXPHoRwrA4tLS7Qf9FkPxheja7N3QK9m6cB6S9dIfnDSkorSbux1cD3v/+T54kQPdSXiPmMiHne5e1W1c/VTauzI3gbD2cUw0/PZOgAnbupLPSozM+Ojb5xJsDNMuIzRPP4lyXjQRM9fmjfpC4GwxKMEUzuJs1JMiICngWPLStZlEYNRRLGFDugrVmN04imy044pO0Cdglg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xM+Y67rayJFCO8PYuv/WQfuDF/jgyhEsl9qMmXR7Scw=;
 b=Pql14/Iv+zMQoDS2kA1aT4jvhEohNE2PeD7EPib1ukvSvB3tROOyZ61ra6RnsBbdmmQrHosbO/kyf0cOMLeHSlKtRR7gRkiDp4A1x5Mq8Us5863rRDSXb4YpxsC0G59u9KWoVvOimcJ338SQ1LII1OXCyeJ2Kd8xkc+6EFHLSNBPGqI/jdVWE7EBQjCsmCJfdsO/DT6eHkRvEbSwzjVnZIInJxYlbHRArzkSZ5X/6gcdFDyZ9Dm5OeJgxZHDnS0DtG6Ep/wo+BkQuMd5qjSaMFlUWFr4eqS814MJP9ORV2Juy0KhHOl9hqTZSVcxalvKTwpKasKM3HcBEsDyOWkg1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xM+Y67rayJFCO8PYuv/WQfuDF/jgyhEsl9qMmXR7Scw=;
 b=o+95CzfQGBPRLmRwgiL7sjv9Uzpoy9XBSZFv2+1JXkRQ7xBnhbauDRFOhkfG1Bg47y/q8KliKXHkb95lVZ0USw+QoSBg9CKqn/2EzdTXhjQM3pR/YhdnTjiNpDe4hRT1c/JX05vZBP8YiPOFz32RfTDtHoTEaSfCNCqY+J0anrk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5626.namprd13.prod.outlook.com (2603:10b6:303:182::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 12:01:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 12:01:01 +0000
Date:   Wed, 11 Jan 2023 13:00:53 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH v2] netfilter: ipset: Fix overflow before widen in the
 bitmap_ip_create() function.
Message-ID: <Y76k9QxybRtf9aG6@corigine.com>
References: <Y76NQ7tQVB7kE0dG@corigine.com>
 <20230111115741.3347031-1-Ilia.Gavrilov@infotecs.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111115741.3347031-1-Ilia.Gavrilov@infotecs.ru>
X-ClientProxiedBy: AM3PR03CA0072.eurprd03.prod.outlook.com
 (2603:10a6:207:5::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5626:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fe2856b-ea6c-4b85-e767-08daf3cb821f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4kZBLvmj50C1dO2uiVGa2F+uGDx3Ataxkg0vdWKT2EP+oaEtLT76D7nGxypf5ZeCYWb3YoWqYwgZCPiQtuVugQ3WdEkXRevS2XGT3JcDOr5tx8INfOfIcRNRnK2VCyDgkdmU2nPeWN1jUl7RDEq/Xm0qI3pR51w3spvbLcjQtsuaDhKUtlKzpHC+yV/5n9y5lRIUhNWx6kz0KWJEZeh1GJ7jkN5hkXpyFt1tSR6oyT0ILm6hlIhpHzubGo5W/NXzoJADV5wMMGYbwibddZYfajxgv2FuJnF/hQBAKOMt5OEdQeyMeiIHY0y0ZBli7T1+RkFyajpntEKwta1PCg5r8nXjAkYAG9Vp7mW2asZeBYEehcd0Hot1tILxpQDF+5hZAETxDG1IS9jSdS84cXt9vI1UHgpmj/E+BcJjDQwBiUt8+XhhyjtQvYtXgb3E/MlMEIgLPk2kyCr9V/S89curbURl9jcW/Zw9C5buJHmRV6hj03XBKinOG3m1UbnnEZ7mkH0bOH3Xh9nB2h1RUoUnZLEQXO1Mz8PpW/HPn6A0cgHPlVPlJRngLIGrdWOqhWRzZyQBdbIiLQG3DqM3XfRdqp2ngI5ABmmlx8EB7bW2XntKdNhv7VxdAeELapabmb8yNVrGcwPNSy4OzZbpUGBWqEPgHyn+TdCW5zhSeFHca+2Zcc8pJSkjB2g08O0ZlRK2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(376002)(396003)(366004)(136003)(346002)(451199015)(86362001)(2906002)(44832011)(5660300002)(36756003)(7416002)(8936002)(41300700001)(66556008)(66476007)(8676002)(38100700002)(4326008)(66946007)(83380400001)(6666004)(6512007)(316002)(2616005)(6916009)(54906003)(186003)(6486002)(6506007)(478600001)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?juvDwWpkZ8kGoBAatIthrNz0Y2K9E3hUYzGw2sehC7sXoCh8ydbF6ANU6FCu?=
 =?us-ascii?Q?yrLnUyLw4CBxtVXfLiz+SdsyhXCJh8lZKNHHaIVD+QeA8pkLjzCP7w3WON+W?=
 =?us-ascii?Q?fRXh/pPv60S85e1SdESJrNJGQjDpcwvaX2y9NDE/nOY2lO3Hb5l3pa1FWYuS?=
 =?us-ascii?Q?qNlJ/VsXB8U9Iy1+nQVl39skKDbiv/lc2fBo1IMXbnihM034uEvSdKtCMTju?=
 =?us-ascii?Q?PUAU9hk03qqEDnTmTYgjQa+WwdhrQtk3wJeRBePtZaz9E9LQAKGEi2oS+7UU?=
 =?us-ascii?Q?qCwlW5l2utYt7+Qfw11nRCagPcl/XEsMLhu/El5voQ1bc11xRZqBHBnXIAjs?=
 =?us-ascii?Q?FGujYGq0RCiPgiPXwQQYJqmh+9ukEwu6zTpb77DlnkANyYu5xg/2O9KMjZZy?=
 =?us-ascii?Q?vwvrzMVb61mFJH/CyTCSGHoGu8IHl0KrsKuFtwFJsmU+6t7uYjFVcGggQJKu?=
 =?us-ascii?Q?qBqeoV05T70pd4UJs3VmwSWEgL0uDnfd7PrMUpASJmMCRnPVWYNIiA5vXrhJ?=
 =?us-ascii?Q?0t5TtWIwK2qAee6gFZ3CH+8q1j29TC+fTvZC+ErUa9E7qCDeq/sDfIOViZo3?=
 =?us-ascii?Q?5RuaTf0NCt9/JxvnKuiJ5R/2Cn4a6toFss/UwmKlsva7KBIiv4nI8tAmvitH?=
 =?us-ascii?Q?EQu60znyP1UaJejxCujWY/pfhozzxvzOVhbW0A9efWV/wTr+lo963i1cbt8k?=
 =?us-ascii?Q?Ks/qfcD9HgVzCjtC967fjfGlTKv5OUBSY7+jIE7uDkr6RKKm32FBejQnFc3k?=
 =?us-ascii?Q?zF7PPsjA8I/+rY6p/2GeQpYAyCxFzlRxH+R1d734zPKHEN8qN1QkplhtR6OU?=
 =?us-ascii?Q?20nJnzkcjrBwPKjqXZ2QuEfO6YHSy3U/EPtnlvyvAb7VIL2liJ9zi0Pqb2Dr?=
 =?us-ascii?Q?3gOsvwn+Gw/yQinFKfAuyK9+ykJQaOwVwrDqOVu+eBDlXChYv5TfAdAY8iBO?=
 =?us-ascii?Q?CqCM959YHolV2wQ9rXSwHnWg538lJrqqAjQKlGxYy9ISTg0X0pCaTlB9IXYb?=
 =?us-ascii?Q?QPaCxNLT78gDtYfQ1II1w+jvn2g2TbCdRYMX3Tg/83Os3F6p7Hnp3GUJSPyr?=
 =?us-ascii?Q?UTJxjPuMrdn5r4gfE4uGfcRPFEA3npEFTvKtmcDxIf0wmdw6gcGqUH8Xk+dD?=
 =?us-ascii?Q?L0yrEjRAb50PWQ9Ymr/S6ir8hBul8Z9XqTkjcs3EzGighaiHT3cjDG4YtQZY?=
 =?us-ascii?Q?GHuZP6wifZ+t17St1yk6grKGEfk0uY19LnTKu5Yr5N8avzRqiOr3s3cNDcCs?=
 =?us-ascii?Q?oR+BR+Q2qTmHsRWhbqgu7tIhBdVWRKAEkJtr44Z+PVyp2yTX8Fx6rBbYSCJu?=
 =?us-ascii?Q?BlDe/ryc/C1IURWS1STFmfOcrFDRc+GhECUC7moQNKwU4Zpmn8cFGcK+Z0vd?=
 =?us-ascii?Q?0941Xs91mStX7TVDMpTGlvkssJ+1/y/CquxMjSmDM/9kHTn8QNsxwSgJvec9?=
 =?us-ascii?Q?X3FHFdJiiT2kcnReSgXl4+AM1EUOpj/tp4z3KugiW+QULvgcGHWrNGuAxISd?=
 =?us-ascii?Q?+CWMtx6oONuBzfxNmPPYXk+XScXshrSjHAZ7gWtLM2VcqL4479Bmf24KTKs8?=
 =?us-ascii?Q?zcxLQsu6ELB1PPkUvXxLIGY4RJOTnvIJEeCiVyrE2ZVVdhttsUUGRVpae0Ah?=
 =?us-ascii?Q?jzU27PuaI6C7ge5IOmTEzHQEXmD5I4R/hG0qSJwtETn2Zu0xOlZLDoX2zRg4?=
 =?us-ascii?Q?TOzPlw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fe2856b-ea6c-4b85-e767-08daf3cb821f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 12:01:01.5260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o6Aq7yiDdhYcSdMpT0tuJ6V3Bq5peS6ayUGsqYDDZPz2WV9mic94PDif7LgjcWosHwRVofgpvoIP7BvYdToistUz4VA2OFBQy3UMfHsHmFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5626
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 11:57:39AM +0000, Gavrilov Ilia wrote:
> [You don't often get email from ilia.gavrilov@infotecs.ru. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> When first_ip is 0, last_ip is 0xFFFFFFFF, and netmask is 31, the value of
> an arithmetic expression 2 << (netmask - mask_bits - 1) is subject
> to overflow due to a failure casting operands to a larger data type
> before performing the arithmetic.
> 
> Note that it's harmless since the value will be checked at the next step.
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Fixes: b9fed748185a ("netfilter: ipset: Check and reject crazy /0 input parameters")
> Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
> v2: Fix typo of the last_ip value in the description. Fix the expression for 'hosts'.
>  net/netfilter/ipset/ip_set_bitmap_ip.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
> index a8ce04a4bb72..e4fa00abde6a 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_ip.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
> @@ -308,8 +308,8 @@ bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
>                         return -IPSET_ERR_BITMAP_RANGE;
> 
>                 pr_debug("mask_bits %u, netmask %u\n", mask_bits, netmask);
> -               hosts = 2 << (32 - netmask - 1);
> -               elements = 2 << (netmask - mask_bits - 1);
> +               hosts = 2U << (32 - netmask - 1);
> +               elements = 2UL << (netmask - mask_bits - 1);
>         }
>         if (elements > IPSET_BITMAP_MAX_RANGE + 1)
>                 return -IPSET_ERR_BITMAP_RANGE_SIZE;
> --
> 2.30.2
