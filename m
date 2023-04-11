Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344586DDB04
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjDKMiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjDKMin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:38:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2130.outbound.protection.outlook.com [40.107.243.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C3449DD
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 05:38:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMxDwI1bvqwocSdKQQuLmyZRnBOlYcB1wuo4mQBHwBL4tV0o8+twCxI3c4OH5jf7rKTGRREnghBbeYfKQakUJtk5GhWu6RU6H52Aa52ZsKmgG3RVCdLueHd+CEQMtScCwXPqXpXjQByp9urStfuoFLhjx2CQTZ3m9Y+awXqBi8RByYldn+sLgD5mdCXTA3911RAhEW5wwJ4sXnWVQAV5Z3MIdAsOssa8NihBgmoPGcXCLTSa4kbAp2kGJjRVtR09ZkJUxZLc5doIdD5UrxAzW9WosxIBhPxEASQwbuwsjbakc2J1ObEXd4mrUIkQ7Cqna6lSsTSutGv2Wk2vMp+ymQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7CKSnJnr51wNh6fEwuIiZxq/XYeKWtUuQ5trB0q1yzA=;
 b=TuUTqyHjK9r+VXqmZJmGMf2+wENgklmsTCm3TymTApF1E4yrovumqSAR/yWaTnULdgu3POz+Sp6a6tDAXvbVlmeH1b+MtooXSxTLSusQ3csaJCnk+CY0RXmkS9eGD7DefIa+ONebptAbjPbNy2Zypr1WM7D97CV/5n7Hok9z0qGTFOMB6iqqud4ejVXhD97iyQXT/tWg9ei7BuuFxsrQ95YxgBO4YFLbrqgq44KojXqhLYtByXhKZp8V3pMozVAxrnCLqMyinI3ez/Xl3pS/lEPnWmn8VUSc02N340MSG19u20t6CtlTrKU5ZVf2Rsz6pTDHT5VwA2mXmxAeI5LwbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7CKSnJnr51wNh6fEwuIiZxq/XYeKWtUuQ5trB0q1yzA=;
 b=ARyXZecnOWesDUuK9fxw0qKgcubERA5bE7e14J9nLV/6ml+qOXqHZvQJhU4S9Ghw9TlhXVKu7EdyqAzmO6//i9ZEQRCV/MqEeOuuP0ryq38CzYOg9cUVvVSUSynqIewwQD4DvciBONRbMFy91f0xROjCXK7nTdg4Tw3jvriY4rY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3901.namprd13.prod.outlook.com (2603:10b6:208:1e4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Tue, 11 Apr
 2023 12:38:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 12:38:04 +0000
Date:   Tue, 11 Apr 2023 14:37:58 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: thunderbolt: Fix sparse warnings in
 tbnet_xmit_csum_and_map()
Message-ID: <ZDVUpvzP8V+xzqKr@corigine.com>
References: <20230411091049.12998-1-mika.westerberg@linux.intel.com>
 <20230411091049.12998-3-mika.westerberg@linux.intel.com>
 <ZDVJeJd3mM0kBdE4@corigine.com>
 <ZDVLXQ/8O7YxTHRv@smile.fi.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDVLXQ/8O7YxTHRv@smile.fi.intel.com>
X-ClientProxiedBy: AM4PR0202CA0004.eurprd02.prod.outlook.com
 (2603:10a6:200:89::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3901:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d3fb899-6a42-49b8-e60c-08db3a899887
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aTZAkHTqorcHDj58iKSpMXZhNPpPSSxzPE5JxA+u4p3tfCFZRk7PjCcdfJcxFrq9RQ3ud6yLPPQ/xMTU+TUugRXai/raUXRVQE2kJ5b6V458M97ZpOB3vQvT6FmW0i6se6RTvBin3wtjsiru4ppYa+q+GfIGkLMSDnAeXmZYGRHC+haHI8DNrmdeceLd10hq7PmqWAzoiEClhG2FmE/VNOMmO4OUEP7PDcNPx761dytev8k4NwZA/DiAKcQux9P4YoBhuhptWB7shNP2Rr8fbe8rMaJ8edaQliFN/E3r6zGtfWRWv3jGWj3zU7Xeg/e3Obvotxf9jTJZNPKXtK8IQ5VRtD5+SA2s1yxoFiZDMLYfMqjwFWO3khMxnqAh6g30edqc4J/I1X7u/yth7va3/7Qhv7LMDaoKbnI3FqhDin94nw1NvDPxJ5YqtAKOivypWyw5QgflB7vMJAjWrGusmIGL/floux2+AEB1cfMo0tKBHHauEallB9++YqrHBsKZe5Hu0UqG0W3LwXXtNqc21Hxh5HWxblzvTbNnTw8j55y9z19j861bprCBRoVpEEDb4rEi7isZ4QBbTKLGWSbigS7O3H1rUQVCyZe5WfhcbMgZWWA/JrWG+EjoTK8saSXMzkML5yf032o28gpVztt9QDDvAy/ptbH34ORQdPHV5OI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(136003)(376002)(346002)(366004)(396003)(451199021)(4326008)(6486002)(66556008)(478600001)(66946007)(66476007)(6916009)(8676002)(41300700001)(316002)(83380400001)(36756003)(54906003)(86362001)(2616005)(6506007)(6512007)(6666004)(2906002)(8936002)(44832011)(5660300002)(186003)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R9gOc1/PNB22JQKju7wEROXxdA7E2sQNi6Meeu3URQaXdFHUqMZpwDWGGXVg?=
 =?us-ascii?Q?5c5F0Gk8qQDhmZ9AUiKHZVC+YocbzWynrvK3+ecw6JfdFPgdM3iryvk0nh0z?=
 =?us-ascii?Q?ZlAbE5GmQ++J9HugnPaVmTqP8wCwW5I44wktTuxCiWMTq9iPeiK8DjC4gF81?=
 =?us-ascii?Q?MbRRS50pTkULRNm0ENn3tnlLbCyZkryEjjJBd5B5dVZiDq2WrPFcSLCgiLjC?=
 =?us-ascii?Q?eON70XbI8B960/wyOekCgxCCAtUple09eCqgbofUFKI46PQOVJOUGfMhA7vU?=
 =?us-ascii?Q?Wfh0UdCFs/u/6NAgQtvNpGMjVaCS5lE4CPLmZZrX48hQLCZ+XkiDjTdrBT+o?=
 =?us-ascii?Q?RM9qdOSFrStuIerht3YZiOehcX3SyiJfrGZEfDA8h7+XkPJ+67npdyebQee9?=
 =?us-ascii?Q?mNXywzRio8gYcuSHPdzDBjcga36Dr0jHQilDCye/Qp/fDmnRfn+pPcnwxz/L?=
 =?us-ascii?Q?oPFrTcQvG3H5RpRKygPEFUtTahjjh3VnwUS2Npf/9dU3OmYzLqND57X2zfr2?=
 =?us-ascii?Q?sk/DWODVjmgqggwXuMO9enKTqSH7t1CC859npE4UaTTny9lQIyvc0kZciULx?=
 =?us-ascii?Q?v7pnqvemdOg+TSHdBZP5fNwhzoRM/Ih/N4EGmcrnX04REZIPpVWceWVSpsP5?=
 =?us-ascii?Q?CHhoQLqpekNHvUmYh6Fv7F96cwoM0Ks8fvxOlSbF9SJfgeHX7GodKDH0jcPX?=
 =?us-ascii?Q?in98sXblDUhk8EHECrW+OVO0lnPLuWB+0JbvtG8DRa0cXdnjikZefbcKKoy2?=
 =?us-ascii?Q?efqPWlyrPIoCq9kDWzRKmkS+z5b08r+upb5JhgA9xQlz23v8x8uYb4c2kmxh?=
 =?us-ascii?Q?+Ivnm2uh6wswc/tas9VgSDftn6Vh14UZ+73KRxg0Wqif6WW028K8wh2Gik6W?=
 =?us-ascii?Q?yUoFK0eB2inqV9Zd8DA7SzS+h2c8ERQzCH1Bzq6R/+BopHaC+fYfQw3XdrbA?=
 =?us-ascii?Q?wAD+umjeAPhK/RY7raUJeSt7nJ58NRRKP48d0LvXMRvlrdi0pUcCwEzmfLJR?=
 =?us-ascii?Q?e5Uu8XXhK80BD6c7fjFIQXvacdBKwMRPHaNPH12nd5q5hEbwz6PihFGO0zlK?=
 =?us-ascii?Q?a23iJfnHv5pjw4fmS05dVuoQfiGU9Jm9QJPzpM5Q/Z8erVdm+q8d+rKlzu5X?=
 =?us-ascii?Q?Pu6Qbg1lXwpkG5MNy0obJpFIR9TtgbD95mn66hlCZFiJEJg3igdJXvnYD9Ur?=
 =?us-ascii?Q?rJE0vpR4iVtKfJapcuoXNWBRW1tbSnjy4Rw10c00DGADah7B2Bw3Pf7FWFI3?=
 =?us-ascii?Q?03jFxg2q1kmZv+OsqG8o6Z7KJGRXxqHuOcGl0vFbhZnpGGKgjIRuk5ooT6ju?=
 =?us-ascii?Q?pgSZGq22N4EvvhiNq1t+GNqTri40RmPJTtLp7AClXgiHqOlX3l2twoybNJX3?=
 =?us-ascii?Q?JRsCzc9e1FRyP3DFAbRGKK62//9DTGg+OoumvBm6/OmjGrJb6Uyp0rZ8tJOj?=
 =?us-ascii?Q?B72ErA/i3IJ+tSdawzK2YcCUbFdMw8JqChPblxVCU66Wh1yOmB6O55LgIOzG?=
 =?us-ascii?Q?ctpjn5df/FYnuHeG8LuRkE6TMcNDX6Eq1UYdrb6WTHRWcbvAguk28MQ8p1vq?=
 =?us-ascii?Q?v0VVO+w6p+kgopXHKiieQnjoEy2nxoD8p6CxkXlwpb4ey0EEvlOoj2Al9vwC?=
 =?us-ascii?Q?pktCF/Y2kIGKoruVO4fX10MSzKMMYwbtO59sTp/Mj556kMXkmTOVNj81mqtt?=
 =?us-ascii?Q?j2IPyg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d3fb899-6a42-49b8-e60c-08db3a899887
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 12:38:04.8694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tLtpm/DI3zACyB8rgtb01c4KxbJbFeraZ8bavcjUHIh3e8zdXbxP60yioUnewjlPGYBKZVIS/sBYauoQoJfCRsNiSkyUAgnyjPSmQhQRzwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3901
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 02:58:21PM +0300, Andy Shevchenko wrote:
> On Tue, Apr 11, 2023 at 01:50:16PM +0200, Simon Horman wrote:
> > On Tue, Apr 11, 2023 at 12:10:48PM +0300, Mika Westerberg wrote:
> > > Fixes the following warning when the driver is built with sparse checks
> > > enabled:
> > > 
> > > main.c:993:23: warning: incorrect type in initializer (different base types)
> > > main.c:993:23:    expected restricted __wsum [usertype] wsum
> > > main.c:993:23:    got restricted __be32 [usertype]
> > > 
> > > No functional changes intended.
> > 
> > This seems nice.
> > 
> > After you posted v1 I was wondering if, as a follow-up, it would be worth
> > creating a helper for this, say cpu_to_wsum(), as I think this pattern
> > occurs a few times. I'm thinking of a trivial wrapper around cpu_to_be32().
> 
> But it looks like it makes sense to have a standalone series for that matter.
> I.o.w. it doesn't belong to Thunderbolt (only).

Yes, agreed.

I was more asking if it is a good idea than for any changes to this patchset.
