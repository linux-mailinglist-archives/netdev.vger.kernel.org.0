Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3979B4C1F8F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244782AbiBWXVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237743AbiBWXVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:21:21 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD27658E60;
        Wed, 23 Feb 2022 15:20:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZ9R4zUcKGL6FHQen7xPknXI7LrjL7ETeTQ802ABSewTSmSpESFoaaUgbVYMFeG64vnn3i4H6xdxjxihRZpFZxBoYFV5KyLxWHL1HWWCNVrCCET/I9FtEQG7yRqJGwL6NeleUM77Pkdnm3v5U3apYJ7a44gW//pf7KQie1jakod5mQgKYWJiCqc/TviTYw12KV3A9g1G5LFImrC1MreE2SQVtbeHKQoVWkPgVjqZzmphEYqncAyADkakb40humHAlHDSFzNUyo08RgFZ87hWmouOrwdJTJJRhhVzqc2wODTVIivzFKIwCaI9K6IkGo1h1jOyqQeRiWwQUN7WoLj56w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4H3uRQfrrJdEhLjTQ+qUA3ulbODTPaWm8oN5dt270Xc=;
 b=mnXCZDZRUjczFeEVTamvku0Lw8BVCxe/JVIhghGNywCzIniWxT/OB8xThR3ygq/vA4uTEXQxg18eMxGENjmjYLUtm9244waTmwZoJgcHNiYYMAmq2ZQS4/gLOJp9rGDg/mPlNh96Ivh6dlSjwlZY4G6t/CSDgXFdpdwM4xFt2gyMBK7lheTyopfbE9O8Q12DA0VOkMGu/gdC9kuz+WGucQD6CzUFCY8R3Z2oSRMgIrI9jtktCxu5ay6pR4PfOoHJQQiFNPFXeJPoJr/I5A68BcnO3s9mr+N+h//eFo3FlODTP4FqIbNdsg5RkzccpkyyvglplLP9PavzQsF/dnGcsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4H3uRQfrrJdEhLjTQ+qUA3ulbODTPaWm8oN5dt270Xc=;
 b=nRRTODdEwzd+2FaGRhZXYiawN7BJIEE8+Lzz3/QJcO676FjlzndlLcFbaf9OPrBfPCHdIi9AfdOActNlWyYRvLmrdwPWMZ5aNojiqwiot82I6uhVtGLBog/lbTy/lZ5/FzJu3kUw/JScZKWRMRdIoYOgeHMCfmAvcBSxSp5TJgIwNcx5E/7sSP6FMzS5vW0/QWUk+Db9dqLRDSwVygwMicfknRpF++Pi6aagNrktBA4l70YUb6saHu0XtgIqKYCwTqi/BOj4lfTFfzh1f7W/VxRA9ASLTxNe37aXBNtldmyLAsIZfsmZ2tbI+m95tZN43piOlpDKrO12AZ1jKDpMjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM6PR12MB3723.namprd12.prod.outlook.com (2603:10b6:5:1c8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Wed, 23 Feb
 2022 23:20:50 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::fcad:8c45:be14:5a49]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::fcad:8c45:be14:5a49%8]) with mapi id 15.20.5017.024; Wed, 23 Feb 2022
 23:20:50 +0000
Date:   Wed, 23 Feb 2022 15:20:48 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [mlx5-next 01/17] mlx5: remove usused static inlines
Message-ID: <20220223232048.tzqpszyv5d2z7ft6@sx1>
References: <20220223050932.244668-1-saeed@kernel.org>
 <20220223050932.244668-2-saeed@kernel.org>
 <20220223151714.48bdb93d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220223151714.48bdb93d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20be40a5-c835-4a0a-267c-08d9f7232160
X-MS-TrafficTypeDiagnostic: DM6PR12MB3723:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB37236E132BFBF1E6AC347A65B33C9@DM6PR12MB3723.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OExNoKPXJvUESCXHjN313IW7Gs1Jvb08X9RYUafMziwopijBMMKAEhEjjbFOhNaOaS7CusefL1JK40DOhRkVsvjb/IRMrpOk/PHmVBAulO3QIN5IkN0s2TE62EtfDf7CeHwe2yz+9G2J69OylTsx+VSp/C9EgR3Zzz/QGsqhAThxQcH3awHeE66XLuH4W+L+hpxmmIewkePHuVg56CImmMJSW61SO3k1QgzM0Z8Pzfz+gUyV9XgeFr2osuXxh/MkCXK0kjl/1/go2aVRJlhFQDZt9BE53XMd1mvbbvrGQ0fnkf/oK+CkVSLiROILaF8ZZsAVavLSoTN5g5bDo+urj/jcj6nf5e5KsDs1XK1UrnC0T4YVEJxxvm9n3hlSNr6TxUjr2yZDf3VW7f9/vrmDGEU1HZ6MY69dOKwsdFuKLhrCuER3HAfXje/+Gx5h6IOqjuLodu2Vou5r1/TKg1gybdVu0HDjT2gACfC8ew/hDxUrReftLAJ+lySHIiCIFeln7Wr23pugrOT0Ob0paA9hSkDuT7nUCZHRO7fE3mlnpX6+OyK+iIMbbmKbRtLzIU+MwL2PSgPbNQtkYyYLZ4DqUI+crIFhw8q9oobuGA14b5y9bg97gWCwuSpbwxj+5S4d99m+M5ie/uyQvscXU4u0zaSiIZIBUi9aVylTFOv8UvZawSSzDnfA8rlJMh/8kOqCm0MDPUOG6Afa3BPDNegPQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(186003)(52116002)(9686003)(54906003)(66556008)(6512007)(508600001)(26005)(66946007)(66476007)(6486002)(6916009)(33716001)(316002)(86362001)(1076003)(8676002)(6506007)(83380400001)(4326008)(38350700002)(38100700002)(5660300002)(8936002)(2906002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ugO3xoy1piMmIiA88Y45Rwvir/y3SD5mEXPxgrKKBcsmTuFJ7qNmykHLrMsX?=
 =?us-ascii?Q?6VmDeiPHpXPGlI/Sj8Ed+EYow8uiNsbeL6g1u3//J+S7cHHOTMBLhNrhH4mw?=
 =?us-ascii?Q?z6NtcGs88qsgQydtfE2eTzMIl5sFxHv5XMGHdXY2gxCEAOiIH7DbKgk8vG4m?=
 =?us-ascii?Q?Ox+dndKDPbJUCFtEzugBPZdzxHeUqsZB6bxcWBEzGYvWoa1tJv5dmVOenZUD?=
 =?us-ascii?Q?iYLEtJGXNocg4+/Jw7Q80jKYLrCuSAK0odOcQJ+a9sptjFHrQqabzWiFFeSc?=
 =?us-ascii?Q?64GUknK0HNGxqyhBJAWwwWLxZ/ywTnH9YEmFxMcZvWR2BvjUN6ds2z6f+xw3?=
 =?us-ascii?Q?ztK6jmFfBKfuGHaayLZTzcrISp1Z2JqLIosytHS/yP46ud3leOmOMNRaKGUE?=
 =?us-ascii?Q?2f5FSU8e8BTHJRL/Bk/mwAJ81il+1iZXb9z2tIRA1Wcp9vPaQrEJ+Bk3x4BO?=
 =?us-ascii?Q?yZF2pyqBvsNaaMTfp1kavvO4GDfBmRFJ5qHSKNB55044d0B04iio7RRfRJUE?=
 =?us-ascii?Q?UDwhpb4gOq0S5zaXfhmInrLeQvF4Tx7IHerQ3q6yVIfXuV7ycPpdw9WB/EyF?=
 =?us-ascii?Q?pG8hD5S0F28YDlo8snRore4pAEGop9Cpu1EPQKLt3xQ1srtJJ26OLNThiThZ?=
 =?us-ascii?Q?y+99yi4xO2fBDKXajTsecYh/kp3QFKGZ+yj4gPc+MGy0nUyRP5AFAmGkIi1v?=
 =?us-ascii?Q?1F4aj1vU5kcgvsX8RlEQuNKzaJd9namZd6h+l5wVGhjm4FDQnvxTRf7DoT9G?=
 =?us-ascii?Q?BvX7+rcGHQtgs+bfBI4h0shWSqWVNbnm32RTBYWLJ66GnZAwg3FAHiXLakjI?=
 =?us-ascii?Q?B+v4NajVwEZTpsVaw4WbKMAGDDCsgyDAMWNMtEmjgNDYa7vfamxmNxMzmq6/?=
 =?us-ascii?Q?TEMfdelVFOHo/cuNMiF/VQXSjzbZAtwR2gSf/yBSQwmnAqDNCCEi+13UXC84?=
 =?us-ascii?Q?aml1tZweqomWRo99NjJpRqC3alT9bYRJRlfzdDVCnwhOxvvgDqWYlfzewXkX?=
 =?us-ascii?Q?3Y5ABNe2qxiflApF3otKuuu3WqTmkVRER2q5SoBqZGA+zcxfLloH3b5CmvfJ?=
 =?us-ascii?Q?wXVgduBWWUPrzQ+UFImFd02TpjCrjnYAJL4FfvKp17HV1m5bdVG43cAO87hL?=
 =?us-ascii?Q?rPE+oFmHascChZfTHYKXuc8PQYmK/O/kDoLr0Y3aoHamYKxpuqprbk30JKtN?=
 =?us-ascii?Q?E016pw8X5iTADwH+9mmd0Kiq1oguyPI18JBeVUkVXVqvdWLuYAR4ASCZ/B5a?=
 =?us-ascii?Q?g5FH9XxVxh9ArTE+7C3Sdpls4+MQQ/0wm3G4fU3nsLNdxLaiQmZ1vXNIkR78?=
 =?us-ascii?Q?xkTxqFQrfBkiT4hqHbUzkAmsZRVTULwy8+9V3g7zpOvVXC27GheAwPFT76J6?=
 =?us-ascii?Q?eNjcJxghQrRY32rpcJ/IdVR6JEs1hltRGal7M1cDjeop8flZpqtOrG1MHaKg?=
 =?us-ascii?Q?6T96awv6pWZQ1NJgkL36T3NaVJ/3hVL4AdjA28AWjSfM3ip363bXxUo3/43z?=
 =?us-ascii?Q?2Slk23BS0JMgTVbHlwOWqhE4sLvEDP9Tagtt0GilbEYaB9dt1nRwL6JriZ3n?=
 =?us-ascii?Q?TCdWFzlu8S8qe5wbvdHwWDdLlpqkKW4b+eMhaaYfPwknqCrBM24jsu9CK4UE?=
 =?us-ascii?Q?6gTOsj57uahMYmaLJj66SaI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20be40a5-c835-4a0a-267c-08d9f7232160
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 23:20:50.7376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mQ1WYcoZBUavd9zy9VlxiCUQhSIPZJPP/yMdkvwrB3f6UHS6+VCJgfzQBtLTUwEWgX/9Cq1s8GUdPwqicO7ikw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3723
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23 Feb 15:17, Jakub Kicinski wrote:
>On Tue, 22 Feb 2022 21:09:16 -0800 Saeed Mahameed wrote:
>> Subject: [mlx5-next 01/17] mlx5: remove usused static inlines
>
>If you haven't sent it out anywhere, yet - s/usused/unused/

Will fix! this is the 1st mlx5-next PR, so we are good to fix this.

