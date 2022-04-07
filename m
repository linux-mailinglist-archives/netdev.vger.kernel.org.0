Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD0A4F846E
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 17:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345632AbiDGQBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345473AbiDGQBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:01:07 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2043.outbound.protection.outlook.com [40.107.95.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA3F10A7E2;
        Thu,  7 Apr 2022 08:59:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyShjpwETsI/t4GO1FO4PFsC9Ri1ygn8HNfJP7oBcNZJW7+FwnyDJH556bCeKqMUjW2TX+DPPs57qVyVJEIWKC+B37qDi63Xb51uQdlaAc8/Ruz84n/F1uheKXU6GxTqS844f2Q78kdkRkiAOHjhLcmrMzfe27oggkyRTPSV+073h3liXO3Ks9g+77VX5qoqwtH8KCKpba1ORu9sMxk+IyGkdnjPr22JJ8/YSyl6+R6OC8ylwwps/labmbD/zaTj0EuNkaLrsI9z0P3ww5HlA2Tr7HBeTorZ0tvrfGbWNy/nUlh0B0G3cgGpVsRTQuwq0r2Y47/z4dZIzrVFJWTRfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wpLeOUaoNIiIVxKhzRKWxdaSjgwcNOxt9kUWrG9yXkk=;
 b=akaZwJBW8yVUYUrdKRz6+zBVO0gh+E4V0+tnXRquDttStK1ZV9lC3sq38bBgfzY8ojjy0bxFFH/yTHrrgM7QKsEwRTr+oi8uQ867mNoDJfIrekMHhKOecn7xPHlYd4HUjqn+WXKmT85ng8Z/9jzlQIPH8J2MKXBypGd9B4Ib353lNDl5HJpM0bTivwuf+oHRfUlmypJQWzugrGgZabd3h4X4hd7fEUq5ZrbKuL/9LMXUF1E5EWwcyOZlKGwFWklntpVcByRumRTGD0JhZRWwBWu1XUg9Nv2GsFf/5MhyApaT6+RVk4TR5lkN39AYZEgRELEI9SRLvcBzbSbptTvOCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpLeOUaoNIiIVxKhzRKWxdaSjgwcNOxt9kUWrG9yXkk=;
 b=Xe7RLBdNnbj2vZCILqLGBiBHSKiS2yRcaQHRgpzsxwFhhVSUZQMqXOnTfx73oLp2gVw3gM5CnutrLcxgjGKJpldOMDffv0qIFRJOE1qS/WGydrM8rWz5FI/VG0kNk1yyyZamGHyeFnoA8Fyg6iJl/dDbaUkKPN9NQqiPZsb6hCOM0UAj4M+AIGiczPdVL6AALXsV/eHJJ9liGMXObzlGtr9LFlEYWdmC6BEDypIBIvUo2UznU1QcfiR8hEKDiLKXVJVIOdP7EZalSZytH+rnIYW6eh9p4w9Nw9ICVJ75bmuUPRKhE1pXKD30OJ9rpHlTfvOxxQMfZDRsytjHTR3MWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB5213.namprd12.prod.outlook.com (2603:10b6:5:394::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 15:58:51 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 15:58:51 +0000
Date:   Thu, 7 Apr 2022 12:58:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Gerd Rausch <gerd.rausch@oracle.com>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCH 1/1] net/rds: Use "unpin_user_page" as "pin_user_pages"
 counterpart
Message-ID: <20220407155850.GA3428848@nvidia.com>
References: <47050fe9f6f26f11fc14ff0ac06547f73ec3b81e.camel@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47050fe9f6f26f11fc14ff0ac06547f73ec3b81e.camel@oracle.com>
X-ClientProxiedBy: CH2PR07CA0057.namprd07.prod.outlook.com
 (2603:10b6:610:5b::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bebb6a5-5bf2-471a-444f-08da18af825f
X-MS-TrafficTypeDiagnostic: DM4PR12MB5213:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5213BE5347317A17F5F56EC7C2E69@DM4PR12MB5213.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3V9xli7/zJJb7BehvI7Uw0jo6DeTkapILfyDoV9Kr38iYU/vzxzf9sXWF8qr20yQTgrwVl8lgRXwhm+P93dwCvSninzR9SXAYUbhnqjxq576OwdQGJ2iNKKXcaNSrkoMLDGQCWuyCk84h5uPQK9Xb+3MYucc1D+BoBD9/7BM5ebgwIHQyhWbJfONPtRr5g3KwDpfiX0B4Focte/+fnSuhofoQw9BCCdlQv0mfNLRR8pMJ0ZO9CXUN15vdRw72TjPEaHppLE1/X/5SGXeyLQY9NXzTnGYrjBJ6WsRo8AY2xzMSITQilY5K1tx8hnL+/Am2lHZJMJ4XKaBkQBB9WWSdXfE2JxROru3sJEa5NrMJID1USPeeK5DOdaeN1gAXqT7bquWn36wXawVtChtwiKEgkgtoW6sMuGdn3nlKAlrwh+IfeBSivAhocTK4Wmx1eA9nOA9rYMApkSC75ov30zbc1HfCWC+Vkd/BK/HImEPeFHoJnBQJEYZCAfZKcQfINce90Ak9NsfFKBS56bRgrJNtLStZQkuOyp9ohpkF6K96eHlIR7sOfkOFp+Rt/3RGKFqtmIMVA0Z2XY40XvtzCD8uDPI1QkOUSQu/dUZLJxw+g31ymB8X6TAW4e4PcOIqzVk/LyQkDdIYaptEXy//sRyaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(316002)(33656002)(1076003)(186003)(26005)(8936002)(2906002)(5660300002)(508600001)(4744005)(6916009)(2616005)(36756003)(4326008)(66946007)(8676002)(6512007)(66476007)(86362001)(66556008)(6486002)(6506007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?chbDwcZpYWbP+Lfft6RAE29YMNOupP9cULQ8V3KEBI7ZWT5eUM6gDtiSSttx?=
 =?us-ascii?Q?qAossI0ousxaRpFpumnofqNICksauPcqR13dhQOIR5uxfoDSaKzMpTUbPJhP?=
 =?us-ascii?Q?Eruk11+3U2170DX+MfcbAYN4pgauZTnS11VoJdQddug7AZkzVqVKPs/59XkI?=
 =?us-ascii?Q?jQQptU7XyMV1XE/mjuMB1iNta7o9cT6+CtxnO3vKDG5cLVC+QVlgPTSiyOZU?=
 =?us-ascii?Q?LNCr/7vNTFrH/iCvCbntp0jEgw4lmmx3cwxCBcuu5c5nSo9i1eXgfY9OoDYl?=
 =?us-ascii?Q?8i+F6yZE6XduU7F/MlfQGnGMRc/V3Y16wVox0u/kPOJALJw2mN6sBcRJtID/?=
 =?us-ascii?Q?wQS67TEYUi9CIW3gCKH5V6oHHPt9J/T8qiQUkp//A9FKiccFSJmWgvs62gee?=
 =?us-ascii?Q?v1sUqfdEHAZ/8slMbopsRH702uI94rh48ZnsVuxVCjxaReRat5VZOdl9E2kU?=
 =?us-ascii?Q?gllQdoAAYLH8J4LucGE2i1NGqlHa0zeIZFCKTx8hxVa2h67wHOHh8bph8uT0?=
 =?us-ascii?Q?I/FFS0Zr8hGR7u8A3skcVHRA1HD9gShTUWjsjEys+s9tY6Kzy3TjTtB/KlR/?=
 =?us-ascii?Q?+fYhDJgtvpm5sYF8SHnV9bO82xtcmPBqDlK870s+7YcAGOtPvUbJoHbIQ2oh?=
 =?us-ascii?Q?dP1K1lQy7oQaiBBxBYfdh1PZUykiAyrdDoU04tv5TdPdP9tb1o6xv8+lICQO?=
 =?us-ascii?Q?FiFFC7NF6I91RTt64ZoHrPDVXDvdISG2qcFdfGmZM4N30hII2k8GNhEM0RBg?=
 =?us-ascii?Q?ZrrHMhDs/lT03lfILVlAE/CnD47N+OJfdu2M5ZI8B6ZjbSNOS3n/eueSaN9+?=
 =?us-ascii?Q?mdtELyg5WIJ0Jr8VHvdxI1rlweyKK3hnOoPIaIUMpuZW60KLNgPcqnx2e4/w?=
 =?us-ascii?Q?DubI9NvCKyrR8spq9v4zNu0aUhiFbigmxXPS3nf1yBraoyJRq/L4Fcal8Zxd?=
 =?us-ascii?Q?uDz5BgFBeqCiKEMy7zPl8zXJxLzSLIOifl/chpQhR00SYmHnUiReSFVUwjZV?=
 =?us-ascii?Q?/PmNY16Wuc/ejyLFKhqsrSmf4fiyf1vO5miU3CA4mzTWj/xut96xaykyRmaf?=
 =?us-ascii?Q?F0Dn/E3z1h0zwsC5tFLPEybKvFXHugt7/stsMmYO9hZP7O6mYGUMh9N5Bki1?=
 =?us-ascii?Q?mJO8ou3k0QpxOC2/0PCyRh7zKIcFpGz1htP6iXKjs0web+dfCg471qMKQcS7?=
 =?us-ascii?Q?YglJ/kO1bkQ4MxyvrHyigygcGvfvW+IDMnklWnJUYNI9v/pn0hCJAHgv4XJH?=
 =?us-ascii?Q?pMfbF543muZGxbEW5St26yv2DMX2j2L+Y1XD2Y4pc0nPGVDzDwgOrW7qtCot?=
 =?us-ascii?Q?Fix58ZdpCgr9/qPkWMKU1HhAr+lpMkl6HpJRDeruBL6PNCfQ392pf3yxq6aK?=
 =?us-ascii?Q?60ZEJsunGMkwpjV07K82zOFOFJZwlbSupJkjsYSBBhhWoCaT6U/x/0lQLQ1R?=
 =?us-ascii?Q?HryfdSyNIpoIfjU8oguf7ChEnt2fzhFNk7aErslmV7ff8UmIsICVkPD9/1EY?=
 =?us-ascii?Q?RRCskD6bpkn1JwOaUhIDGJMuy5BtTcd0ChH5JvD/ZsT0f2a/oIfox+AnMf+V?=
 =?us-ascii?Q?uG9IEaCxIRyaWVaFEf5vGEOaAfq55L2YXUjW29us5xtrOQv8ZKQDzu6wcFsN?=
 =?us-ascii?Q?RGH/OSSXQU1VqUw3ZPXZOhUUtz3JiYK8vSj3kfH8pECHNEgAXEdH4IeQ9qe3?=
 =?us-ascii?Q?GngphWA14V7fRd3dUIHLZgJTxKHVkMMqLrlwySWIRL8yXKZ/QoXQvF9kE34X?=
 =?us-ascii?Q?iskl0qX5IA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bebb6a5-5bf2-471a-444f-08da18af825f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 15:58:51.3221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: clmCFAR3b6+k7rVJ6QnBkckb4wdNmB8HBCM1oGEf5jcsLmKWyCuEs9ZNl24z4TLl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5213
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 02:03:05PM -0700, Gerd Rausch wrote:
> In cases where "pin_user_pages" was used to obtain longerm references,
> the pages must be released with "unpin_user_pages".
> 
> Fixes: 0d4597c8c5ab ("net/rds: Track user mapped pages through special API")
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
>  net/rds/ib_rdma.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
 
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
