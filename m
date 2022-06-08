Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5BE543707
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243786AbiFHPPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244495AbiFHPOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:14:38 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE03143865;
        Wed,  8 Jun 2022 08:08:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SaM/kKiRwqWGq0+j3Mgil+nXXZluoY1i0Fx0jMKBaJNiA+AwPSN4cKjRLv+97hXmVK0sTcIZkQHIqDdDFqvSKr/N8vicW0F9hMdvIsSyxXoDN/qWBYdJ9eK1ui/JtT4yL634CoVK7OrM5TdfukWhlUF+WiQV4F5JKCkv84A7NP8fYKKQac9K8CG+7JP+tPK5xk4p5zc/LwRRCcRKRQx//6/E5eE2Q+gXig8TawCsIMYf6778R2Bbi88FLFNiAJjUauUHzDXCKuhd6xJSrGkAX9mfY3mW1w3lM5rIxFclo+OA68SdTc4+3SyK9/a5VuQujL2+67kZrjXi3NAjujRtZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tii5PNnP+taXWXTlvLFA44qKWas5FqPIaPebb5WZI/Q=;
 b=VTAZMmnmCi+bsNaKpgxKjCPh3gfiY92ic4ONCI00iPqbNJLLdKg1DAteJ173vOYqVuNH0ralUj4j5fd52ixtwR3b2wVA1vVlmSH/XSfEh2s3Bt0F8kyQISGq+rF9xmUWt1yCIB/IdbaO0tI9g+cKztO7Mnc4Ac8KAjx+cAHAq1VAMjO0r1V04bbpPtx10bS/NvBDeZP0VKtVZ3Yzd1znCVMo65699b5LsEl0gl++tCgzK6fBFxTKPWMs4D5IXE+dbQr/JY3cL6MhhPLIzXuMZAzbhJtYIAz2mDGC2zVFVeaPOsChlAhmCYRjqjvOWMVhsLvlJRGvr2mQlrOeYf2x+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tii5PNnP+taXWXTlvLFA44qKWas5FqPIaPebb5WZI/Q=;
 b=jtpcZ+GIcOBOX5Q0VH9JCqIX6+FjE5fvIiXogNjiqlUiipdNfSRQqHrxbU+JQ1ICONu6pVI5q2f2lfnwlcsG7mYkPVT39xE9kLaxGge3IV5Vhr/1dY1veayMe8AqECOG2ir3epy1ku84baZ04nJgZ6E4Yx5+W/QRl0RTCbBkm79LppzpzPpHwosMvU8ez2rNjk7j1JLYMb1+kEzEI5GS7oFZfUxUSFX0PwB08j+N5llFdNdE3aGW3ko4gRzQdDBMnkL85R7RVGsFza0uraG9n4tdabDutq4h1gb5sZsuJ8Nmi51Tk5R8bajNVPd6Qtgdu+3dql/zOyqCTDN/p3b58A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3950.namprd12.prod.outlook.com (2603:10b6:208:16d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 8 Jun
 2022 15:08:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 15:08:40 +0000
Date:   Wed, 8 Jun 2022 12:08:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Aharon Landau <aharonl@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 2/5] RDMA/mlx5: Replace cache list with Xarray
Message-ID: <20220608150839.GW1343366@nvidia.com>
References: <cover.1654601897.git.leonro@nvidia.com>
 <b743b4b025c5553a24a0642474583fb3de8bf0de.1654601897.git.leonro@nvidia.com>
 <20220608110144.GA796320@nvidia.com>
 <cb340692-422a-8485-cbf2-766b3e327d0e@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb340692-422a-8485-cbf2-766b3e327d0e@nvidia.com>
X-ClientProxiedBy: MN2PR11CA0014.namprd11.prod.outlook.com
 (2603:10b6:208:23b::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44058b39-672b-4e05-f02e-08da4960c597
X-MS-TrafficTypeDiagnostic: MN2PR12MB3950:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3950559D4CAADC425550A68AC2A49@MN2PR12MB3950.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tx1IPGvPtpzR0Uc5BPgMDnkJdV1XZGmUnHMNQ09fk6E1bDV6zSV5g44IzZdU+nwpSgdN/mJ3ucNUhma87U4LZvCv3BFQZ16VzU0aOXNXLjOSX9IvK9S10l3Db2gio6vc4NCjC8xT1vCcBXBJyC9CUN7NbzS2H280tOiRg7miUZlAzw0k26xscF1V4t3JlsQlCOoIlR8j87TFEx8PZa1mHtYbRmgDwPsVChnq6lLizLmIS+wv/R/p44uK0DivYTvpkHkLwkJ9aShffCX7v3D3Fdo1wzVwE018zXRuLkjWOdSDpgNTtREOeaBNRkCnz44S7GSFpbWBIW7gOeWeRoXXFIJK0cIO3SfD90qEOHzO/xuTZ8PtwxtvSq/klIiX38AZMN3s2EtzjVFPRVFodDL51YRaRTy4q97C4DtND8LhhQgACUM1Qvv+ONb9+Auyn9dbGxBwRCvRJnfgopiAuLpn5QVrr5fE60kJ+48BOHjTHif+5VxNO/wzSi0R9Gy7leaUIzktQPeD/bjj/SNXNuUaHGr48nJ3YhdIXnG8npj5r89xrWx6smtQK0lqaVuRrAbFNN+RVX6489Tgb1Rw49xoqMO8cDuFtDaGU4x2K5wM50PhiWEKhJ1gwpu5l9vuTSoQudXlf2N0fDEqdzbqWN/FKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(5660300002)(38100700002)(66946007)(66476007)(66556008)(4326008)(8676002)(316002)(37006003)(54906003)(6636002)(6506007)(33656002)(2906002)(107886003)(26005)(6512007)(1076003)(6862004)(4744005)(86362001)(186003)(83380400001)(8936002)(6486002)(508600001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?McMS9LYpJ3wuXIflOY/ejUFD0QX3FUuKeeQZCMIaiAUoQcvt4Dc1GiLZJ9vN?=
 =?us-ascii?Q?6vfU28yXEmIxJEgpiD7unj04JrnM74krhYPnir9YLei1b27O1A4IAqKeGviR?=
 =?us-ascii?Q?xtjcXJRgiL3tFiAtiVZr86dU4hW4fsCOiJZR6TiEhBAPIUuLrglOTip48avw?=
 =?us-ascii?Q?koZpk8LrCd6x/Rtjl3xhN4xuswYPyCZAnC7FdLpK9Pd8l3I3/I2xQO1VK5B/?=
 =?us-ascii?Q?8PIlCFE3FsZ9r84Gxrxu0zGRpt8h1sqe8oGMs+UcblRLDj0Dk8xZ7RTHGI0x?=
 =?us-ascii?Q?URhLqM3KHcua4ukoO3MhpmtXHRKJHRBF7dOLPSqDHemGLSPaTE50vZVVODHD?=
 =?us-ascii?Q?5UD7eYKR278qFPX2OHjqTlpWh3x6NMYal6AUEVfMZJoQlb8Y8teqHP8p6BBz?=
 =?us-ascii?Q?ewM6lrUMqibHqP00uTfEY4hkzJHeCSXQHXlqWRdhlnDnNdC7WttLvVYhAtxy?=
 =?us-ascii?Q?PJmA7tergXbpsrQA6OmU0e/V8+8EKRljLHVA79UNsANi9b7U2xTHfgixdF1A?=
 =?us-ascii?Q?QinoaE1m5a4X6r7wJKsG80pjucEq+lpD7W7APu1ZaiIv06d9GUJ18xtQq0Eg?=
 =?us-ascii?Q?GtMOUc/CXLMJ3UJE/LMYRSAfS6BpVaSu1PdI29a4OLsMSh/NaCZY5WDHwEVl?=
 =?us-ascii?Q?ZMNi3i1LBu2HZ0QKnTOJEoPQh2eg9O0URmxnmyHpWDa3yUoP9oVtHV9LkGbL?=
 =?us-ascii?Q?KAYoxh7vrLbX3eX/vMF8pqEVEW/9oCC0+RXZVtyczlbDoirmysLt4fQWTCFk?=
 =?us-ascii?Q?/Kf4/npr583ekxoq76vTykMZbV3yTA8LxMNvlQnH7UyFnW44LEqWQJZygcPK?=
 =?us-ascii?Q?NOwSw7H8YrYKpCN9z7mhFcLBhb2GOuQ13BrKbBxyd6R7c8THXRuQAKleViIv?=
 =?us-ascii?Q?C+WVKm6dUg88EWMyEo6RgFlwALfUS4KSz2limSpCfk4FoXReVCTcnXD1ik1U?=
 =?us-ascii?Q?7+zrtTkFLsIdU34je9upmC9mJgRN1ejRuZsbb6ET0hQM8LZOU9Dd34fijtR/?=
 =?us-ascii?Q?jZcNuGvemweNOwclvopoai0mV4CR12E2PTENtOnHcKBrtXSNaBZt4CiDjiZk?=
 =?us-ascii?Q?dCntRzWRiPd2svoA30a6mQ70OsfHu5YXJ5iScHBi2EYzwwwDHkNws82Rtt6P?=
 =?us-ascii?Q?Tguq80GbmCI6z8cyEEGmPfIAAS0SEdb+EiNjs0GaOYA6auqC8OK5QdwfLmLx?=
 =?us-ascii?Q?bWfIz9jphzFGXMZMWaaD8aGVabXDIIzsjaOBZGJxclSS+g8XmLeoduI9mEv6?=
 =?us-ascii?Q?CBPsXIGUjmnQKh7RL/9IbvHH3I09u+sTMLKcji+Bm5FZzL0yBL5IZfanxWNG?=
 =?us-ascii?Q?DFVLQW4P8h1gqWjN3Ke+XXeQ2fcceSVGVuPLzSpBsMsRhwuK+z9RK3CPIxKg?=
 =?us-ascii?Q?F3b79ogY2Ni99xEdTwzflLx/dL3lpeczRiG0jlYBt/FNQOXRHNEQCYloy0Ti?=
 =?us-ascii?Q?VJdupNuHqZiSxRbQB3SmduHtc6fjPBudYR2m4ecJk7LF5InVzpyhs8j88S7A?=
 =?us-ascii?Q?etO8O+tqnb2eun7hFdDqLjxcbCZMkvSd9EGOFZmEG2Mr4wFxBbaXsOSFfkM+?=
 =?us-ascii?Q?uj90Kmr0TvhSOJvhp0KBpZpAx0xgvHBOVUD9ITUuio5vqXjmqjfb3uFpUrks?=
 =?us-ascii?Q?0NzBkgOsmwQkoU/0aun5Y0NCtCWkKQNIxYf/fpEgGvWugAZnngIHLz8C/zTa?=
 =?us-ascii?Q?6m54HEHddB9FrD5N5ns7jePfHiWJvvBYh6fqSbQDxEM0xSkwj2PZDdh/XNVa?=
 =?us-ascii?Q?qyC6nHBjAw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44058b39-672b-4e05-f02e-08da4960c597
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 15:08:40.8197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Wse98ZnHQhep0bqEWmOFYQRkcWbBWAPTUeACBdY4+VVaf2pkK71IekKvLh7OX6c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3950
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 04:28:19PM +0300, Aharon Landau wrote:

>    Isn't it a problem to store an mkey before ib_umem_release()?

Shouldn't, the mkey has no connection to the umem other than the umem
was used as the source of DMA addresses to put in the mkey.

Previously it was ordered the way it was because thr mr->umem pointer
would get overwritten as soon as the mr was put in the cache, but now
that the mr is just freed that isn't a problem.

Jason
