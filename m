Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A950592E6A
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 13:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiHOLsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 07:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiHOLsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 07:48:04 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15764BF5C;
        Mon, 15 Aug 2022 04:48:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0z7x6bNYw8U/EJsoQI/1WnNTEkMPWW+SqnE6vVAFdHyxyVmZN12Pfk1gYduBxNCSeqteHSLDV5RH1xj3rV1ZpU/PVAT6lrQ5ujwXNcDJmamYnEcZzDhl3deInGwqVmpSyYkdrqh/OmjX/2Kb7egM6zSfKp3tJcdAKBHCood4O3M1eHM9x2J3aAu0bRmustnGssqFefI8fywn/CZ/vZBFtvgzKpUto6S9u9ir6rWjTYMPDjFXBTHYl0VucimoXwYHvepm0BDCzrTCLfS+KonE0EWHi4oQikLP7lbo5c6k6NTkaVnTIHeGgqwdSamhenh4Jy9I5f/5obJ/6RaQKVGmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YK4/YYV/5JtbycZpuhBrL0roQ+XYkCZFiPWevSlq6o4=;
 b=XiLiOD7H7QvmF51U69s502gMX5VrkXsrKNQkmX5kB3zOXMtRBuwHW5MXa6KxpauoeNGR2i0z0U85mqP14xn1Z5/ITNfhr0Ym3sltdiFu5Tp//6mxesFq4hKjgO2n8D2hmN3HuBRp7NXzY2NSLBIt4deElTYO00Mq2Y6F6xfy9HB/H3rvdhn2U59ZbpotjEknCati+GQh2aV3xO5KAHzenmgjBoneeib9x/qSbGQMclnchgoHHRkXi+b+Q4KNEQMtchLZmV11dd2JRJPr5wEQoQ6m3KVo8IINKuvQ6BBKfPjrSqlKhPWhoiPVNlDOkzqwfOBYnsJHLK8H+ETtJjf5+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YK4/YYV/5JtbycZpuhBrL0roQ+XYkCZFiPWevSlq6o4=;
 b=Rzc2rXEDu1CkAEk/xM7j8JOc18qzFQ9x7aMQfSgn4135XVMLkXboUcQz7dA1mpMn6lhcwU3+yvntw7mjVLuXcYV/VajMEYGw1WVo2oP2VTBLpz9X+VEOLJwkIA5mCqhH+8UbZUVGtceDDqoWfHynDlSpYJuoBsMIJiTij8KSHvwQq0EeYixpyONdVxau9qfxMtHCrNgHTdF3xslEpVkLJw75TB0nREdYLhjc3ocz2VsXOawJ2zeAk3/Q9t4vYROq8N6jicHZmP/rk7kHsx7jNlarpQW6Syhm939IXguSVa9aIXiFBSUJlL31G5MetVaRbz/9FxK0uPJU5LZsh1C1bg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by MN2PR12MB4607.namprd12.prod.outlook.com (2603:10b6:208:a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Mon, 15 Aug
 2022 11:48:01 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5504.027; Mon, 15 Aug 2022
 11:48:01 +0000
Date:   Mon, 15 Aug 2022 14:47:56 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     rafael@kernel.org, vadimp@mellanox.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadim Pasternak <vadimp@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 1/2] Revert "mlxsw: core: Use different get_trend()
 callbacks for different thermal zones"
Message-ID: <YvoybKfgNnHi36dN@shredder>
References: <20220815091032.1731268-1-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815091032.1731268-1-daniel.lezcano@linaro.org>
X-ClientProxiedBy: LO2P265CA0484.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::9) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28a080d2-c47c-4ca4-2f7d-08da7eb40170
X-MS-TrafficTypeDiagnostic: MN2PR12MB4607:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jmOoEgLuPcyBScZb8l+utYzTL7KTtkzypkHuXOj4zFBaKO8UnhwoYA/nRVHx/d71OFCHcHoGgsL16iBdQaOrZgSnQTCMW5uzuM5Velji2rXAiSMAV7wIuaMC8fqeir3t6tq3MMtAks6oElhQp51blDr0+/OCVWJ8EhAFDxH5HII9HSMxZXsotSUXzDQr6dqZjbLsRyS1U09O1GYiRQJty0rq3PUF6qAmzXMXILpIznu8gBUZ6LeQv9fKW7mphqfmX3/8PCcl6b0BYvARDqQJ5XrIEWW4bZZWMQdvSE0GDe/57ZdBkklpT1P59CHxNdeBx99IX5Kg4fefmmAD3G08NETgsABTHMkUr0funEuRejImGQcgYpOyRXignWYzRwgPezDQ6Te42ZnKKWU2vUjJ09UvYqeSBze0lInc8Je7/HOFFGT0jSuqkFHQ9orATa+QOQKWkGVL/xFEfJzTvYee6xi4EtBNsQeyvYuRb70Ori3iL6Uyh1vVJcBVxPE+ZkRwOXrER1Ez3qGsbPUh70FIHjBI48y4WFh1LETqp8JeuSD3z9EkI/iYZsv+Yw5hyMNeyPhOam0kKWZpUdUvj5fchnDgag9PaahcHzjE0Duc0Fat60/77N7cJAg/2DYn+6sw3AiutmQl3a2lUsV9Iw2/dORcVl+S1HgDVa+sAiEHSDfA/NgrLfMCguVcigUY2IxuPdggzcM3I8x06gumxfc7IS5SImjIeXRSwr6d7xvtLok+HAXCNMuniyjubo+45xE51VsZh/sPLTpIxyjePEiUf47KxDaPi/0Pv1pnRo+SfbA9f9rwhASlqrmGJ0+uNoqM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(478600001)(2906002)(26005)(41300700001)(6666004)(966005)(9686003)(6512007)(66476007)(66556008)(6506007)(6486002)(8676002)(33716001)(4744005)(6916009)(316002)(86362001)(54906003)(38100700002)(186003)(5660300002)(66946007)(4326008)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R61bXfQD7Zfz8ST6D3CJQ5stFkkEWbyNhEF6Gz2rgMs0aXfJWNbAuCIpeWM/?=
 =?us-ascii?Q?P2bPHGTaCpmxsb2ldic7I0El/rj9Rs4RkGlJLfZURzFa2r1XfjwpwYxLL9KY?=
 =?us-ascii?Q?4MggYx9lV6JuCXpQZl3YRKMkbJi8Y80MTSzldx5bOISxQq0+Gv86/VMevCGK?=
 =?us-ascii?Q?wtQ2edw2px3ktIalHdsQouZ3cRoJwCGt+e2gxw7/49IUnT5LJX/V9nq8VIbr?=
 =?us-ascii?Q?Mp+D/MxnzxlX8OhnG9j3HZS64hgCj2GwLn4q3Ba+hBNwRR/JlDPxy7DsGjRe?=
 =?us-ascii?Q?0ORHM9hqaE4gsg3a+29YRtml0RMrvqXGnaJYk64lVjIWOY1lxEPWXbTgCyrN?=
 =?us-ascii?Q?wT4vuRgY3FSsMBf/co6kljrya4/kxab8O/N5EG84Jj05l0Ac8I0OUNfJkM5g?=
 =?us-ascii?Q?IoQZh0MF27SxOOIibrDyUxtFaDgyePeTyjJGAuxb0mm7rUohZMINnlR1lGH0?=
 =?us-ascii?Q?wnZcFtISwG4xbkibMl5t3+CSPh8k/kGql5uFl3LUjjWw0bh6aj7sRLx3odNK?=
 =?us-ascii?Q?I7/a69t43U/UeMuL0aKqicz97k9agEL1kHnR7+Q66lnHCck23b6m647Yb06S?=
 =?us-ascii?Q?LLrO4iW9HTHgKTx5yhKS882HLtToVgtfbnwCs2Np6SYxeBS+fIoeATGIjEtm?=
 =?us-ascii?Q?WS828pAkmOUiDhGAPsnryx6Su5Dp9Fpdq0IUr9qDbx44iDdz6sHfhX692qK2?=
 =?us-ascii?Q?dyvlwvQplVUo5VIhAY9isUvld8UdTChNLvic2pEgzuyIrAhxyHEvBeGAkKPZ?=
 =?us-ascii?Q?w7/Bh5fiFRGofUumK/I0c+Y4sES/rtkbmf7Puv5EeA8DjbmksRDpYpA0LLBj?=
 =?us-ascii?Q?tt7peda7L4O1++HfuqutJScOMhWH033punK6rsYG4aJQK+HNupsSmp/9EThB?=
 =?us-ascii?Q?qKX6HQUC1pi8j74czQopo+FfjQikM6T5gQCszT5WDRKZhDvVJzoucU3Mchwe?=
 =?us-ascii?Q?etUoWiGS9nJ/27c7yDJ1iglFJzQdMcWsVQ36810sCdk6OELH8RojP1KCqyzz?=
 =?us-ascii?Q?MSfUSaQ+8RiUzmwZpWDEKX1GPZbByoVY+rYGF+W5OWD+ewzzxA087hHK2Fz7?=
 =?us-ascii?Q?sCrYaJYTNLyx65BRovGTVNor8iN0wm2Nlr+tPlbx2xNfmzcSRomDHtG+GXX2?=
 =?us-ascii?Q?dq6nldR7yqZIpR3Az/WOHmd/OfR0cjonBSArpNKnunQGCVitlG8xdzDNg91W?=
 =?us-ascii?Q?wOWEMIBq2/Igea6c0+eZ8A1rT7eAoqmfqucTHQ9ofWOjQeNT85SJ4XTjk5v6?=
 =?us-ascii?Q?15sU74iEG6klkvwGsEXv7MWFpH193ZKe6t4iTIl1qZIjc0GHEtRBex+dH6Dm?=
 =?us-ascii?Q?TyhtLo5vc9RXfU2/joOgU5CjcQESWqVBi0QuLYMwT4E4W7Z8rQ8pLw6J6obb?=
 =?us-ascii?Q?PwuRtYmUsBAnme2pQH8iDjKFAoySEv+Qug6xrY5KxAi7FuU+q8NukxUFO5cP?=
 =?us-ascii?Q?oa7Y1yJzDa2oe0vNJ2+aBeCg4KADmh5gvdwNhEOrCHWnCPkQAn12CZPoJLXC?=
 =?us-ascii?Q?mH2URrEw+ywd4ULKp++74+O3l07HCH3G+w+ihCWYLksahUrKu+cbNlmynJWq?=
 =?us-ascii?Q?wjKocs1+Y6l8x1n6OUJ7KSNDR8m34mtUBRNU06ao?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a080d2-c47c-4ca4-2f7d-08da7eb40170
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 11:48:01.0782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hHgecoa1beTcaAk8qOa6WJBkmn3CvteIcOgejsPUPNgR5gYioFEJpsNXe3TKPEt0Ix2fl7Z8Ez8KBA12ijX5XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4607
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 11:10:31AM +0200, Daniel Lezcano wrote:
> This reverts commit 2dc2f760052da4925482ecdcdc5c94d4a599153c.
> 
> As discussed in the thread:
> 
> https://lore.kernel.org/all/f3c62ebe-7d59-c537-a010-bff366c8aeba@linaro.org/
> 
> the feature provided by commits 2dc2f760052da and 6f73862fabd93 is
> actually already handled by the thermal framework via the cooling
> device state aggregation, thus all this code is pointless.
> 
> No conflict happened when reverting the patch.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Tested-by: Vadim Pasternak <vadimp@nvidia.com>

Daniel, the intention is to send these patches to mainline as part of
your 6.1 pull request?

I discussed it with Vadim yesterday and we do not expect changes in the
file during the current cycle so this is OK as far as we are concerned,
but I believe this will also need an ack from one of the netdev
maintainers.

Thanks
