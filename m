Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9F46E7A04
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbjDSMwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbjDSMwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:52:24 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2106.outbound.protection.outlook.com [40.107.94.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EF5DD
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:52:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3sMv4XzK0FGuN8az20ykCBX64L1MV9BjdTo8ZxkwSbCx8RtYlYFlLEAB94VzXvkv6Edd/XpMbz5gDbN657i14nkostY6Mi9XCB5tSF7C3rfDQdUgRRG/OCFpFVKHYx+FJdo9+YRfCgM2V8LrWHuLyMdidQLW4puQf/bTUkxtdZcDIFNCgwgZQNSVOXe6kcXUpLbgl2I09SmE6sCpv40ORghDBb/mZ3Hpg3fpo1W18lgVyHX6BrgIUr6JKz3uikQVOP06H/cEfgKKm8cm/7KeAbOJG/uJxY5gPrspMnZq/fse3Rt9zPDFS54US29KNaYv9Z+2fs+3JI/8zN/mejzjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YpHKDA3JimwY9wRNcqeS+u9qWlmKwOev7uJvbh93fHY=;
 b=URnUKKPO/uYad76dRh/SLprVy//c6VEScwjyHvFMOrGPi71OLJ9F3cxGnMHdPjrIkNp0gWFNpyExILExYZKAy8Y12tuFXHZVcaRDersV3GWHHXJ4zXHnYjHD4tR7aV5MMWIgkts2nFL25jUvN7fAmdOpJ6Sc6f1xeqCj2HqD4zmWd2QF8EQtASv/u0bAWv4W020CclyMN9YczAwlLC/hWiE1OsvncLeVyrYKSF5efHxLH+fBajJSk+jsAWbzB582hQcvmP+kkA+SKO9Xsg9P0Vvxaaj5kT4n35EXfcHRaceVcWQqchp4SO0wtjdEuXpxAtPT0v+u0E3FTh6pbHmk+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpHKDA3JimwY9wRNcqeS+u9qWlmKwOev7uJvbh93fHY=;
 b=lpJRvCNRJXzPwOlKOd9ZMcpnzFJBTMKcAq66A+vlGb21Az4gA+kviBPXB2z/lavD4su5f2OHPeUF2glg764L2tr5lMYb2zS95Fl00hk/lzAMUYonaDsFnT/nacs5xzIH0SS6nuja7b2ALg8bOqMfuZ819HwPhJShxsgk3jrqMtY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB3931.namprd13.prod.outlook.com (2603:10b6:303:2e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 19 Apr
 2023 12:52:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 12:52:20 +0000
Date:   Wed, 19 Apr 2023 14:52:14 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v2 2/4] net/sched: sch_qfq: use extack on errors
 messages
Message-ID: <ZD/j/tgIM6yswMqq@corigine.com>
References: <20230417171218.333567-1-pctammela@mojatatu.com>
 <20230417171218.333567-3-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417171218.333567-3-pctammela@mojatatu.com>
X-ClientProxiedBy: AS4P195CA0005.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB3931:EE_
X-MS-Office365-Filtering-Correlation-Id: 14db7769-f36b-428e-3c36-08db40d4e9a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FuBrNGZG10DMDhQ29L8xdDPLrrnwjebtWuehYxKVm6ngThUDko1i5K15rOVvgUri+rmHHqf5CvbUHUViXaYCqEuEksm2qCnS1CBG40yCCQchDHt2Op8U5kgkiuYyaJ+b6LadBqaeKmvW5iK5iDIJJfboN1T1f5L4n5H1nTQQICcs4TIiV7NFmJED+oWCf5ZkOn3T1WLjawA6CAJIc+t4mKFYf4rFhxMCEGPSXbvSVIIXUdXLmkdZijS7OLsPS6vn8Z//tMF8Jw8Q3iofFt+keceYBcmQT74glHhjVh9lv6R/1zT2kXeB0E4SvCZGwOgOAQVzeh6aDu5Vk+N8DoTNePHjO3KT0p7BuJfzsNzncRqUpc8fvPLIU/pCarsDJcIMBKu4+mxDgrCaeBZjOupZE5IqCGFUOKy8oDkbSqrZ1aaf6c2IAtw6e3Y7hij05kLD3Pdz13JxCFA+hQdTzZxmhmlJu00ciA2g5S/wcjuhTl7RWZvOGjog2oV7dF9VfaH//a9tzn7ZWnPHZLwR0/Q6tOxgL687D7ebFWBslNfcpx0tu5o0fU7cfaiWXWQmAArStljK/BP7Fd/Tr7yzu+pjEmcXSS6m6OGwWsslmse+NjE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(376002)(366004)(346002)(136003)(451199021)(2906002)(44832011)(2616005)(15650500001)(478600001)(6666004)(86362001)(6512007)(6506007)(558084003)(6486002)(36756003)(186003)(41300700001)(38100700002)(8676002)(8936002)(4326008)(66556008)(66476007)(83380400001)(66946007)(316002)(6916009)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nmXpZUQUQsKtnRgJlwVHYZ+FXu592Pmj+cZzsIcT4nUIBqjDUmu3qj39Zw3w?=
 =?us-ascii?Q?myWudi8Z7qjxO8eeRV7RKEvQ863XCgTLvv2ci83PPe4iu84zrD27WVwDFBjw?=
 =?us-ascii?Q?XCPBh6hditDp/PY8yzjcpXbn//wqfIgt8BCEYf+4NoJCVqe+siPxxxfS8JP1?=
 =?us-ascii?Q?JDC+x0TfWfhIRixkoqc0RZ7RmLtx7B297HPzauQfIJDQc1I0Q36X7mXxnIf5?=
 =?us-ascii?Q?M2h2YLp7yZKYkLR09yFT6ZMM54/uBJ9ndooCtG8binCdKN6mPjDIYLcejlOT?=
 =?us-ascii?Q?eFO1F0w+IlmL04vVy+2Y2KxnULEfaN8Cv5BqrSecTZ2DodCr2it1VGs+BaYy?=
 =?us-ascii?Q?/D9EbobiZxb/lS8mNAJEJvnRPurtU1++DYrbOErAOi4UOzAqEsKwef699YSu?=
 =?us-ascii?Q?7sRr6n6h+JB2Bk1SMceteveZypiDMBKFEa9ECkD796oYjYgr8dPx9grscyTa?=
 =?us-ascii?Q?Hq8pD6sqch+DewylyDtQGaPpeUJx0uhotfvyirSIm3k+8yzg42eOf+Ea2oWP?=
 =?us-ascii?Q?svo2YOZPiDb8jvrfvOrDEILot2903lYzoXf/nbTEyJRuiUTGLTyxvD1SbTBL?=
 =?us-ascii?Q?ubQiuuh0idERPg3C8zgd8XP/6X+uiO06lOjwBkgbtFb32uuy5FbYUosW2syJ?=
 =?us-ascii?Q?4Ncx5YQY2H/iODfNSisUg19K+A5v3Lc8sicLtKczgWx864+wBJ3RvsOaImL8?=
 =?us-ascii?Q?9xpHFhebZG/6FMF8mGPd/S4l7GIi7WB3SzIha3lHLnV6k8Cd3vZQsEeVlEjU?=
 =?us-ascii?Q?x3T4WXIxvqcB58WWR/yXvhMTed5gAdoCsS9oH62ALvBUbkRHdnbQfVz5PkIX?=
 =?us-ascii?Q?I3E8dgPmXZaXFHE9oS9dG22v76DO3RLO0dgN8a/4sa8j/0jL3HfSBRew6/Y0?=
 =?us-ascii?Q?VwrW26ccByFkD2hoEbxPCixxHzMR2ZUToPSY7DXlOxKrHS7Xeh7nIW/Pm4KD?=
 =?us-ascii?Q?swJe7if7zEpAV7eJJZEWEl9RykjLJdxXnScnUqhlE+HKxfS1m4UZ6q17+31b?=
 =?us-ascii?Q?VO9M1O5M2Dw2x98VeXQ5OdwhLgF4tbTOIc8jmyvn+/KzTOZJ3spOukKr1uAX?=
 =?us-ascii?Q?WhdDSPxYpWGdys0SB8TT99ON2oD/6epV80uA0PQAOp96nBVBeL9PtGdSKtyD?=
 =?us-ascii?Q?sefttWNGOdyQYHHM21UbjVCvFbKUMRwOiId3Iahqj/QqJQewYIuwfdCU8lFx?=
 =?us-ascii?Q?+uU4BckljPAMdgjwGCgXTxE1wykvhEY3H7bi7r35VNFHij7+oPO4rCaEeFmz?=
 =?us-ascii?Q?nNPH42APRkYNjo1ZurO1iKHr7ITD7y52odXzBHseH8l3I1gMbHy/7+2TAt11?=
 =?us-ascii?Q?k1EWzI6u73dE/vvprL6E0KkXsHaBUWXJOBEBy03Eposfuh+py2oKTyNSslpE?=
 =?us-ascii?Q?cQ/IulD0IS5ld32YSkzLmxg6lhOxFsoSmXz7DGUB2FdWPjVVg6TPHbX2wJQY?=
 =?us-ascii?Q?qni1d1KszxcUaVkn9UgNUCFprJmIrYQFkROWt24PwcfYnRKOJD8//g7fsFVv?=
 =?us-ascii?Q?/v6F08OUodFwx9A7BDDEM0skdjfyrBZVdivigu2MQLG2kdAgotTuzhBeZZ47?=
 =?us-ascii?Q?GxXUMmPs7KHN2aKvHZGcca8WZnNXK7LzfsEDpyMHdmL3CcW+dgfshDkXA7Z9?=
 =?us-ascii?Q?0n4eJcV5imhJtKGYsbU0OMiAbKs4JCdKGtlvD6CdTH7NGNBWpFzPz8+XUa5Q?=
 =?us-ascii?Q?HljIGQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14db7769-f36b-428e-3c36-08db40d4e9a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 12:52:20.2391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9uon/JfD+FNCcftd4HbYbT47JiIdFyU+q2oX0nh9HwJqDLC4JuL75OUPrfYS4r+nuwE7CaQCMM0yO/77u881AXkwJQaRC9ECsiTsB74enIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB3931
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 02:12:16PM -0300, Pedro Tammela wrote:
> Some error messages are still being printed to dmesg.
> Since extack is available, provide error messages there.
> 
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

