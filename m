Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29EE564691
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiGCKEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiGCKEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:04:06 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700269FF6;
        Sun,  3 Jul 2022 03:04:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LEI4E9MylZHjVWvG92UIXBec8QMP9sEr3B7EvZTi8T+/l/wixhuW0nbJjR0BPR9xDxLAGNRzNTlf+hdKxPt3XH61SStU60LS2kB//C4iJ1KWQIg/x8qhM8g6QtTY6KrrYilii/Wv2hGQcaeWTUBOBgkO9SZ9qDE2YiVOPP4GLJrNDaKjqxiu43RRYgJHzuiFPdQgmY9+vMPr5FZHeT+BB+5rq1ncpFOyvKw/jJiR5iZrYFwp9QG6PoykfY1e+Io9rXrsNE+tCgQrc2v9qF8UJsL73PfhNH186+CgtFX6S5EmCGQ5cFhkIf3hgPeW3YoH5BZwawNOhJsXFvscLxiANQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8b3Oo4ETfqnZwcvUOOD+IFOHZsmCYHJ4g3xnnZTAb2o=;
 b=GNs1UR6sy6oAd5TIjaKyQbO3Y/Y3MTOlXHKprqZXcXWP/FLlawPX3qlv1I8E2g8znIHyWlgZr8qPEr9DGM4uKbMH8rk8ygf55BwJ2LA9D9NHn76lNpmsYau5uwzgjf1osj7SrDjmyeuzhq2syqX3kUEcp293Gw6YMERrL/zJEmb04Eg8wfPqNRL3o5e9BsFh73QpNcRh4RhPf1W55Jo+tS2dbAAKyQAU/P8u/RtYkqPkL1excjuajAbQ9Tpw9xQNWL0YI5Tz+i6VQAB3wfV/6b3xd3utzXEnPKcwQsEp6724mWoHrscI+nxh0gK6r6wSvgLf04vZ3ilxPOB9bLmuZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8b3Oo4ETfqnZwcvUOOD+IFOHZsmCYHJ4g3xnnZTAb2o=;
 b=X+cKhdcvBfDnQ+SQhBon8ZzbxBNFEBCwEPc7enUFlXQ6cg1Tc6bQ76RudVsXiLVJX1IIwwQm6GZp9tl8rYQhODBLSTUQatbW3hSHFVveFub12HGvAUuanLZ88noSrkNvChcE/9yCy+wo3F8zTXOG+7/4NFhxG+FCWquc1PqW/ZR0YTagxJeDg7pqkE319/RnqhTqvL7yyl66R0bds++6Yais78s6IUCNSOpzIWRmllV2eADzMqr4hlZllU8KvWuGhSJahnYwuk61rlmAk1eUDkKYvbFcybt5EUtX8eOyCLUl4Ko9cT4Y3psxJHMhhkE85fXAz3vKm+fTdRhYA1IN5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN6PR12MB1778.namprd12.prod.outlook.com (2603:10b6:404:106::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Sun, 3 Jul
 2022 10:04:04 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.018; Sun, 3 Jul 2022
 10:04:04 +0000
Date:   Sun, 3 Jul 2022 13:03:58 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 3/3] selftests: forwarding: fix error message in
 learning_test
Message-ID: <YsFpju+47y8WR9X+@shredder>
References: <20220703073626.937785-1-vladimir.oltean@nxp.com>
 <20220703073626.937785-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220703073626.937785-4-vladimir.oltean@nxp.com>
X-ClientProxiedBy: LO4P123CA0257.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::10) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9a149a2-04d7-45bd-9ab5-08da5cdb5c12
X-MS-TrafficTypeDiagnostic: BN6PR12MB1778:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Unp8vdfQb0xd2gd16Hu86VRfj6y2G1uzs8ph0oRncQ8DNrHChoRZjnmxnx0RF6VkVoRUKQBI1OFWdQPslHMrD8E6CM4N6p8XidtXy+RLAwj0Ylm0hEctnDA3ilntYYxogoixjDXASsCJxUYPktfhkiZ5PfiekRoQwbNs/vyYp7lnu1XiLYloayT4rund9hrDLxLqKgna8CRv+RIeiB4BkL+1taNZnqnmKkjWaCCFZNa1fvTKSM7TOOgCx/iNHagTjDJ0TnflZg5LjNpSP4Jgx1FMargyeW+kPKvH76Ray8JMnhe6Otu0Z2Ou0zB9c8whZB8B87cdmiLGE5kaqXEsn/mxVpvEp+mDxm1XHK4EZUUw7ycrj+1oSCUFqnk1nkh3dGCiC1Lleb/Di5uRF0i10bogXs5XaKCUH4QNMI6rLrmEYIpafousdJZFLMXXOUiP3Yn/otfLQYwtt39N/nA7rdN3UiDAINT5HAwIt404lgL+SLR5PKWOyQmFDG7uY4mGsJ7pWW87TGqNuFY1RBLYT4d7TROmr/BGzxRZJG4LX6maPybmXxDUdJPA4pNlt6qYvHa3z83pQ9NriMrT6iPL78RBGxAAoZQjx02Yk6IsFZEisFVXXoyZ8R/7DomP/8VMN0nm4GTytjPM7bq+zxBUw5VcUOfmQb3zGKm7nG9ukHNJ6zrqpT7v0Ewk/0mPRe5c/j1esMMXnQ3zG9lszOAAdEaO6lXCmUcIvfTIG40glCHRPm+iSjAVPsRVZFGX0kX4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(83380400001)(41300700001)(4744005)(5660300002)(478600001)(6666004)(15650500001)(8936002)(2906002)(6486002)(6916009)(54906003)(33716001)(316002)(186003)(38100700002)(66946007)(66556008)(66476007)(4326008)(8676002)(6506007)(26005)(6512007)(9686003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kk9fRrKPGaBVqSf2GAjftcMG8ARqg14nnaIuqpClFeUwwijgQBExH5FNjiOR?=
 =?us-ascii?Q?IJwpzdwMipZEnyn6qu5cvZ0k3DFYy2feglN/XoX/QrImoHDccHq5cdzsL4Jm?=
 =?us-ascii?Q?bGb8x1dk0XNDjuNILs+j6lQ4ekzbnuO9khqslmWO3ppVi/cbHrmvjiVhEQfM?=
 =?us-ascii?Q?vlaoZg3CADHuVY/OU8inUiSDBG6eURcpxgvxMBoEl4NSY/JB/PfU0O6PtGK2?=
 =?us-ascii?Q?+tsZbittOWHW9XVSPHS0TmOZMgTm0wfcGGe8X8l8XP2SjZnLtJjATV23zMHN?=
 =?us-ascii?Q?OlJfssRpps4QrqBogIN6Ft0oYSuveNEmB0Br8dWVqrdUamZnOM/hc11rzR+p?=
 =?us-ascii?Q?zHA8FJl3l+pWqIRhegQzD2Iuk1/bnI4kELb3bmH/cgxgzVUMVpeUjPvEEQX3?=
 =?us-ascii?Q?b1xzMDNEVPIE6j9K0xeWMmA5r9lO64h+jDgcPSCoiH7Va7iE4CzXrE1ovGGq?=
 =?us-ascii?Q?QGPmUncpWixaINDqbRB/i/ovNugSGtWFqwhD9pEYGf8bM3sMwA4F68YEMzx5?=
 =?us-ascii?Q?tKIt7jCC+Pk6RunIwkJXLlRxg9yaDfwgqlMlUhhKqj7uaBUCMrgzUjauYHTk?=
 =?us-ascii?Q?9h0pahMMx6vQ8dbrS8zNurAnmI2U/AFntSfoLGo01HiDKgZdFb8cvAcuO3PK?=
 =?us-ascii?Q?TBwMFrgVH2S76KrUIFPv+4t5pmGuzIiTuGlwgywZx0MhXA3FIDelsW8GmBqm?=
 =?us-ascii?Q?8cY+pl4wX0/3SERrtQSJh6ds2sYNi37LO4DVt6YDGCrw18im/BHhE88ty50Y?=
 =?us-ascii?Q?3OzenmRfL2Pfh5AIHx6Mgto3mPv95lMNS8NUs/K+36R2x9eh5KvM5iuUe1DK?=
 =?us-ascii?Q?54+jUhfb1Zd8BaNRyXEBLUMhjHRB5aQ/Sfe0q03QxO6VjZ5MQZd5oKWy82+S?=
 =?us-ascii?Q?MTcWl/Ih26OMzf4aeMkJWEJ4EnJ7mO/3D6cOIEHIHqv3o2Z+VtGMbUcRyw6Y?=
 =?us-ascii?Q?IE3NO+lWCcwcEs6Is0gok/wMIfARGmmzbvd5+C3kmXRcqlhJz9URoLRNdyE1?=
 =?us-ascii?Q?ArkuqSG2cR0+XuzAwS6f/dnCeupN8fN3I1+hUtcVtNRHIUls+0WajiBgVmsP?=
 =?us-ascii?Q?sRsM41nBnM5ZIoW8GVaFOtUDW3mVgWrb7R/uEk5IJWNJGSrpdbbvKszEOhML?=
 =?us-ascii?Q?6mVLDvHhqzjf9FZy8jHMJqdi/N3121mlKsoaffDrBbH3JTTevxE1Bh++XDNr?=
 =?us-ascii?Q?SQXPIBpchqPNzvSxc/wHLTK9rZFi7IhyoEFN/jLhE17Sm+VMNYo7ATQ0YsW5?=
 =?us-ascii?Q?sHpoZPvxJwhmb14YzbBO0mVg3hPh2VgzWs3oXdZnMYBfn7XXpiR0YHQSL7Kj?=
 =?us-ascii?Q?jg7XhFOVZAaH0YxDp2bPHSc1Efd/FKe8b9mEPIO+JBd7m3If82+dvwJY8i7K?=
 =?us-ascii?Q?noPMucPJklXo5HrfIGxIz2nPB8rnxhQQ98kJLExv4e9NmzLF4cXudAy6N1cD?=
 =?us-ascii?Q?H0mmKyjPM2/w55qiTK4IBT0PEQM6pyWFpNemuiKkNVX5iFeTcZhLmijOutz7?=
 =?us-ascii?Q?qZd5gFnAmz20e4Wc8aYm6wVKKFC9MOdGdT8puZKyJskw+d2I0FbO+UqTmjb7?=
 =?us-ascii?Q?0ZLUo1VBfZukUnYRMXBC6Y3Q5BysV2kjGQ6PILye?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a149a2-04d7-45bd-9ab5-08da5cdb5c12
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2022 10:04:03.9768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iIRMiOVREvR/BcEb5DsOvVy5kD2Q+Guwvjy7QMlauzC+wc5Z+0p0tVwZcmtaegjQgpySppgmkEcH+UABRVA+qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1778
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 03, 2022 at 10:36:26AM +0300, Vladimir Oltean wrote:
> When packets are not received, they aren't received on $host1_if, so the
> message talking about the second host not receiving them is incorrect.
> Fix it.
> 
> Fixes: d4deb01467ec ("selftests: forwarding: Add a test for FDB learning")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
