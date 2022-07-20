Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC3357B237
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiGTIBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237115AbiGTH7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:59:05 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2079.outbound.protection.outlook.com [40.107.102.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1281161105
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:59:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUx+DATz/0UNzftnlVv4td1TWKISRBaiqyttu50BOmC8zORhC6TBQxyUzQ7dKm5u/UeN1K/dvAOvovraaUBviLMpHzwJgWrz7uJEI3tjAyxw+Xcm4XRPveNtup1UsPlDpW6Y1dvNDqeWRPY7jqSowVU6/WL7yG4sJ2rUbutzAtjtqZc9RzsQqTpoAV4vQnnJRBk0rtiiV27Vm7hjv/yrkaKYyvbK9HWewclQMR5bp3NUmK2CiIY4DfWo81jf7+5Axu6J8cf7mbWbR9w7Z0LREaaweaRPDV+5aQ5OAUCv9K70Of9Df6xwpmJ5eL8SdLwhVr8Une1zD5qbL1e0mRPnDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9116JcwsIlpdhUlSOa3ytOo4F57YKAUsSNFP/UTNuo=;
 b=I46aWFJmG6ZiRqX5aut4JXSgffV0BW2j5GxNLv5cN9bxzAl6lR9cdY7685dP1qYrQcNuu8gjjkOUbgpZFOdTC/58hOxv+U3g4SFz9erAh7Rr+Qs0KHP8pyUc/0ZQRk0Cb/k96AVimBCv7PGZBPKYSzISps2MWUImh3uw6Ta47ui8dTpJOyZxNh/sqDUYwg3NECHacktTposhe0jXVED62AyS0YW6+41djwXR0UT2jVo4IL4CqhgGRfcCVbm9tGXDvX7qkCF3DVZeXKaH7QumQgCs18iUoFVNGslh2xxSYCPDDWhQBMdxib9hP9S8d6pOb9FSGo0TrUC6TTayf8Dlwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9116JcwsIlpdhUlSOa3ytOo4F57YKAUsSNFP/UTNuo=;
 b=i2OwFBsfgXyaT1MkxdsX9r3PNj/5y/JZ4O4190N2HPbL96A5sgUEyyYPhR2JO3G1btW+kPgwGeMbFplsMEFk4M4Kb6YxIj11B0mH4AdC9vd2U3WI1PXUJtgjkXdxbhxoBf+WG6cWG50Ycp58OaYci93N0lDJosSapq63LceWlpAG66JRcHCKz4kCIjRi9FiTAubijtgJE3l7F1ABZKnVNU+lBq55mxDekClknSoQ6EAoJptTFcLLdWqliswbYLosfDUuUH6FnR0UFT5beCCkvNDhavEhL9aVaCysAHCZbAdCYp+lxguCqm9ENDUmCnM6/vLPMFEOm/BW4hJ4PuIhLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BYAPR12MB3063.namprd12.prod.outlook.com (2603:10b6:a03:d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Wed, 20 Jul
 2022 07:59:03 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 07:59:03 +0000
Date:   Wed, 20 Jul 2022 10:58:56 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 02/12] net: devlink: introduce nested devlink
 entity for line card
Message-ID: <Yte1wGunJYm4PaX8@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-3-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719064847.3688226-3-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR0701CA0050.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a53b4a7-98da-476c-0cc6-08da6a25b657
X-MS-TrafficTypeDiagnostic: BYAPR12MB3063:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aRzsRS7CM1QGUMyKrks9zfGW2uGa6Wd93nTiJ+UgcV7qkkOORKwltopEKt5mhfOTWUyY7e9LDd7VUzOkO9GlSdVg5neDYH95iBVdNOvR2yPmOU+cimyIeFEiKA5hXBEjwE0LV20CA70Wz1TC6uRt0vJWN707Ib7X1cqvknyyYu2Vkrkxcb1UEgs8j+Lg22obihpVDMiqPzqcvveD3oGKeGfqqNbd0PzfL6AWUt68mCwC+wnUVUH0qsI8t1XgUhVcw4yU2ieJLdOf/k5qS2Lth/xb31tXK8zojhu4O7xFjjp24ys2j6VUGFq9edlA0+DHP+7HqksLumfUWS8KOVoYUSYfrR42FeqyOxLZq668wBOzX+A41wdmwarpT3fHLpzZkahby6wfqusEYEjy9If+sNVeWcdnXFuzMAQEBoAGDrwDR35+1kNDFIjt5uGLNLRj73xp4LiU5qaGdLD/1lCsHz/7nQZ1Ux0zBQTrNOOTmd6O8v7BZW21a7KXlZrpyDHAavW5xjAqsGDCmigHPApqrazkzYbgeqa98/b+wWG/g6iHCpKR/BlRV+/EmfSOWsvYwX3xxf8FTk+/k1f1RfE4w10KPGzF0orTfMFMazkbDjmuQGzvyQ58bTtHCOfVSeQyAiILErAP4IEnREq16ZwikPgJ4Vs2PCtojav0P49YT17SQu1XcLQhY86k9SvB4Km5F1fN0f32iFBoq3E17RWvfclqzYgA6M9nnZyHOSYiwOQfAItcBre9hVekye3FTDCu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(136003)(366004)(346002)(396003)(39860400002)(4326008)(8936002)(66946007)(316002)(5660300002)(33716001)(6916009)(2906002)(66476007)(66556008)(83380400001)(8676002)(38100700002)(6512007)(4744005)(86362001)(41300700001)(6666004)(6506007)(9686003)(6486002)(186003)(26005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lraEuGUveZbq6W2OA8o7Bpo33YXBs7S3gbGzKXJRBfoJMYXf4+N8gYhxWuR5?=
 =?us-ascii?Q?uR/ECIIcgE7aWLMehGYoPbf/LjXkrGYX8GQyLSfbZzPblxMWBfiWXwERJJKo?=
 =?us-ascii?Q?FcaE5rOZyMrgez+KjlvaRjylad9SKUz3nUGV0bX9a9i+7d8LWz3sFJaolbV1?=
 =?us-ascii?Q?MhLCAW0E/QpxMbVH0Ibru0G9iZtW2a8+wfZyvq1Z0Um9Pi7VH4wivHRHRyj0?=
 =?us-ascii?Q?VTM5R/mITtHez9AneIYpXNwoj8pTgdh0JDIqpp4QSqlANENbx5tjbo+vv3zi?=
 =?us-ascii?Q?HyeczCniPMxJHFMXqRPqK/CXDu1To5HChA9atZ85tmHDYKwXjrEU9+g/nZZH?=
 =?us-ascii?Q?hZP5iHvLX1FaMR3JCsG9AD8eeUbW70Ae4tmaMwuumdoiFWUi83SnXmDAXAFp?=
 =?us-ascii?Q?VixPuEkdhGXKnBYZ8xU7hAg35TmerqtqVP4vKQMwJddkfw2ta/d5vAR8nCWc?=
 =?us-ascii?Q?/82cJiS+tconqoiGpTwFLS/yEk7ZDv6PIreZ3BIurj+9qIh690SStEr0wUVc?=
 =?us-ascii?Q?my/oRS9NzuAfNPh8jW16IeTO7L7F79rM4hrg0mKf2DN3Uq84fOeDQgIATXRg?=
 =?us-ascii?Q?5ZF4IXmauxG1IxvbK/8JDTid4APwfbjrI9eRZqEuv89Kti2pKyvshskUutGR?=
 =?us-ascii?Q?nyuRsMY5d9gLAiMtP7/OEiHWsa5Lb1rbI3nawsghL3A1j+0AywhPlOv3eF24?=
 =?us-ascii?Q?3bnNZKbFf4l9ckKeoM62MgP99XoKEMAvi+U+U3G1W71+86kE8zBqGjkZpY0H?=
 =?us-ascii?Q?5U2g6XdlrHUUhUzMPlKjNZpTgkJh5TsIMAOvE5Cz2HS6yzJCFQG6j6jyNRWG?=
 =?us-ascii?Q?GEdAU2mgyVyYpspu39mCm21T1YaagJfbUdJgHEp4NQvEbXHR6rmHmIWudcae?=
 =?us-ascii?Q?pYUbRmMmo+bt+gkYcHxUtNVFv/x9eTwch/rLhqAARG1tY8pxq7Kt0Syr95f+?=
 =?us-ascii?Q?ACll3xDpeyK4wJTRv504baSd+9FQs8PWrL4w8qSqew+iuxfZ/T0h5a4SEISC?=
 =?us-ascii?Q?3y8GvZxAcw/OtpwjGY8YkXWsqRET/QI5tOBZtRkzmLPXgJSjKTXtf4kpdjBL?=
 =?us-ascii?Q?Vr1/Q93fDjdTAg84cahYF+KQ40bXstUMFg8vzMQu+Vx77C/qA0IFbeyBMaBI?=
 =?us-ascii?Q?lSdflwSEvB6yyFs68GOKMb8ntgHqaSA9BR0UcUUrpI+onoe0zp0GJBoTYXJZ?=
 =?us-ascii?Q?zwvfvbO1NERjKLEpF46FuqvzIiuwmubaMxeUbIAzwXpqN9hb/8IAtR+P8tq0?=
 =?us-ascii?Q?INfyAgVW0Go3dkisQDo8kzJ4mD0Sx7Z/t/Uh9B/DIPi+joQ7VoKW1ms5toft?=
 =?us-ascii?Q?pvtw/h6kzUqtUlHndckKVyCvL4LAXsWbQiqSqq1iWQ4vm4SUgDqeSwVF053G?=
 =?us-ascii?Q?nnKTEAyIK5rz0uUgG2lcWi0A1SF5CLPDqEOfvWDkVCY4MHLS3t466DAt+jsu?=
 =?us-ascii?Q?pWk09StI5jc2J03GeOPoHyPIFN2FcGWfSQRgnuVNa0MF1dRZtbNr4W4r34p2?=
 =?us-ascii?Q?n4zsgCr+oa6ItePN/oDG3js/5pnYX7s/uVi/F65MD09cgBlG4hs/LXE8bBH2?=
 =?us-ascii?Q?tdISE8ITcnRt3iDx+tcLb44jPnsHObSoxYztE0As?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a53b4a7-98da-476c-0cc6-08da6a25b657
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 07:59:03.2932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XdTws2lAuqpjzB5PeeNhFWlDQO1g05qaNW9FVCPrGxD/hLOOc/qPjoeT3e+6vu7vf4I8Yuvlf7tNejVURXS+lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3063
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 08:48:37AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> For the purpose of exposing device info and allow flash update which is
> going to be implemented in follow-up patches, introduce a possibility
> for a line card to expose relation to nested devlink entity. The nested
> devlink entity represents the line card.
> 
> Example:
> 
> $ devlink lc show pci/0000:01:00.0 lc 1
> pci/0000:01:00.0:
>   lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0
>     supported_types:
>        16x100G
> $ devlink dev show auxiliary/mlxsw_core.lc.0
> auxiliary/mlxsw_core.lc.0
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
