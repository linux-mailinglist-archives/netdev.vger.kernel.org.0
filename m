Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557FE57CB1F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiGUNBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233804AbiGUNBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:01:37 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2083.outbound.protection.outlook.com [40.107.95.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28B474CE5;
        Thu, 21 Jul 2022 06:01:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6tmHzVXL0l4UTw+84JXRDXmn9Fnlj9XQZKeV07bvqXpga4r1Q5MYvzHBwgQQQbrGT/PXTsJeexWc72jiiqtJXNJ/nMW5WUZQBZwuRdPDV5eqOyuJlImnwodl3Ih6HAHmXpni95JaH9ife1+p0RJtPdd2BYviVrQgZuu3PCHJyPbc7se+DTcVSRsSDqKLxYVmIPHxKDxmvpm8+hAWm94GfPUQK5qzWL3Ccn17X2Davl/Vt4HtG41IuIuI2MZucg87ryhuriZJAsRJFX3u1G7lFOUM2ZDRo2w/V0VXwKBMB1JYT3IWM3B7rj7uB+iqhmPnGbsF8tvj6LHXGcf3ngbpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKY4vL4B/sN/fK7RI82U4BmzYum2xw/qDgrjipVQGSw=;
 b=FylF6lXyjPv/filJ1USmq0RKQ7z5IKu+4tL0Iw9bGcX6gWblyfx2k6T4sDYQ2VrtKZge/d0goC3HtyddVWqDnWoRkoyJ1Fb6QEhuImq1zssT0VjzimnPeSBYw5VN3Rductw1j23FXmB8qq1RrQ/9mQ6cMwKNlcc+pTzwioYKfbKLjCQ8o6S1cStFYlra+xu9JpigDjFGWpLOAIsx64lTEKa8X/DTAQIK7R1fogRHbqoh0KHxxjz327Ll/Wta5t3pO2nrsElO/NFu3ndGwkxCPODiIlVdC2EAuHfLPTTLpJCHiQPo9A1IX03ZtjYr3Ji1kIQzE4V2X7BtbnHQF4Z6TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKY4vL4B/sN/fK7RI82U4BmzYum2xw/qDgrjipVQGSw=;
 b=N2puuanRtUH69BzME3FAUs3siT3gepgq+Ogsq79jL9KEZMmjKKNSF7vbAwHbtdI6ks2oYYZ3QeSXzXn2pGMLGE9yuvsrl1/pFL/GIkSQH+G0nVFm2btD0h6ly44OtQP0si8igxz1gw8YpIoHmGoRmhevFKaSy1PdB1L5s5kF2+6vo4JK0MyX/NrwPWde90oTKWdV+HMK+c5nxTFB2rAsSQk6LbFL/p9Nkg0USgog18aXd6BhObQ2UPZax6c2V7Q2B7pwmG1Xehhsjuhf4jQJHL99dlEWWvap1ao0801G56K4TIZUysKehTSKMchHu1naXzuAFHMhyecxhitFns1C0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by PH7PR12MB5832.namprd12.prod.outlook.com (2603:10b6:510:1d7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 13:01:33 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282%3]) with mapi id 15.20.5417.023; Thu, 21 Jul 2022
 13:01:33 +0000
Date:   Thu, 21 Jul 2022 15:01:28 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v4 1/3] devlink: introduce framework for
 selftests
Message-ID: <YtlOKP4i3AG0gz+B@nanopsycho>
References: <20220718062032.22426-1-vikas.gupta@broadcom.com>
 <20220721072121.43648-1-vikas.gupta@broadcom.com>
 <20220721072121.43648-2-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721072121.43648-2-vikas.gupta@broadcom.com>
X-ClientProxiedBy: ZR0P278CA0137.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::16) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a2bdc6b-3b6f-4109-5275-08da6b19230a
X-MS-TrafficTypeDiagnostic: PH7PR12MB5832:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BpZTYwuolRCs5uEMwNZktMw7rYRr9VfMVxCQnp1N0u99gE2QOUw5AfVWP5yFBgij7jTF7J5+6T96rY2coUpZd+IHZIFs0uwTUne6XvYxPMzCng50VZPGALpLxDPwKkIvOUxY/kgP+UNy9W8l1GiAMlTY3Z1kMolZbd3hymbTvX63EXsrHD5H6dpbtl6HTaipzuhldtgzw5XpiRQiCvyaUxuOUagrnIlm4WKSp0V/89GiCwnhjPlVN9BjPatKOXCaOoDOQm+cBOD0hLv7JNj2pz3xKMQTjaLgvxoZIByFVo2SRey/HbHcwrmWKWDPEt/oQPTPUDzkDwTEUQRFV1renA736MyMPZQtWOf3jjU3Owet9eFNL7kneKV2yESa48U7Lp4oX4aYMZIt+/wF9RuUpVt9CJclfWXL/xkHuiRGzhw1fioUhdbI1Xiv0pEcK15f/naykljbjMO9eZjiaTdw5D8xXWY/3PlT5YMaZreMMD4sAXPzFOGEY6+5RYxWEqWMvIt7JgcPCbqAUNcCHwPDQXMnd1RboeS8+9uGdmBbkFu2a5d7em0+/QTA0xI+hvCUFsVcG6+xlUp3Ln5FST2Fhfoff55eUeC1tevKJzg3AZti8bsMoum9OP0t+J1zBXdiafy/zTXl1dyqsXSuBaa+WLcEvbF12NDLreSnlfWMGKDq+VV/ACKmpnB6ytLnBNVJLKAm+wqO2XXHfGpJ9q0L4Zxnv8KjU4qy5l+hUdKiLNAPYlK3Mlr9LoxJwe3LJ8TlrCT1llQeRAT9mKNaodoMLlL4nftw/BDsRaDh+k7U9c0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(136003)(39860400002)(396003)(376002)(346002)(9686003)(6506007)(6512007)(26005)(83380400001)(186003)(8936002)(2906002)(4744005)(5660300002)(7416002)(66556008)(86362001)(6916009)(8676002)(4326008)(6666004)(38100700002)(6486002)(41300700001)(33716001)(478600001)(66946007)(316002)(66476007)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p8QYRn35n+Pbczztk80JtVfmjfiqShCl0A6CUkNHZrSDlOeiPQi912gyWwDk?=
 =?us-ascii?Q?WNdQINpXtvk0CxUx3rRSM3vDXQ1hHuLtr/eXsTMveZAbsdHAqKxBCKMzkF70?=
 =?us-ascii?Q?5awHSDR3GvqQqNTOvY7MXevEMspBozEh6OS1VThQAAVB0+49nr1XHr7bs7p/?=
 =?us-ascii?Q?1f6SF6kYuSCIyOuwhTk4GJljx2y7PK7rZ3YB+WsAJMqSpxTUj0LwxUZrvxmM?=
 =?us-ascii?Q?iY3ENsa43rtL7efkbI4egeYTZ/YbjfhyQeem2WaVnF8yYQ6tU3FpBKmnrH3J?=
 =?us-ascii?Q?75GsBMWVZmbBpl+8p6/1eJSmcElVwRu2s2S+dL/8TumyZ4Ms/16nGmHBuUFb?=
 =?us-ascii?Q?sRd0yfilRfwQYDfBIMZtnR0NRlgP2mhpLtaHn351owBJwH8aMuZMg8ccJ3n1?=
 =?us-ascii?Q?b0rCaVw9cCSHjm8wuH0c5BJQ0XWriT5kktPuzAtQsOeow/jT5gAJnKNArEDO?=
 =?us-ascii?Q?Yl8hKI08exdSZHQBTiYXwF6301E150APV7DQCypKxB2ZCs601se44f2sZ6MK?=
 =?us-ascii?Q?8VxX/zb3VWglW9T52g+2cDGzctrHx6JbTPHCFaaR2OVqrOvpkLrMWjqO0iZ0?=
 =?us-ascii?Q?NtJkUYAURy32O7kdFXbuD+wAAnufWkKmnIjIMrQtV3F+TvrOgAnPpC7lW6qI?=
 =?us-ascii?Q?0TNkdVVUH8EbEoVVKlZDQ7I0+9N7VRLzafz3BOpWGUorILnb4FfNcVieA02p?=
 =?us-ascii?Q?PIPbd2sq9FhvmtYBQD8gD6Y9V+w7L+LaOJBzwr+Ccruo53UhIPPBtD1YgcR5?=
 =?us-ascii?Q?UYKfZVVkTmkxhskz18u/fJ76ZioRWI8f849c8+dHkJxDfVzswsTUgXGX4nEI?=
 =?us-ascii?Q?1lhrv1NctmcLqnAQWlz9Ardkolg2Hpngz2pfv6ONQ2GGhOUFPVWD/SpYSM8p?=
 =?us-ascii?Q?Zbdf+ntf0ONBElIs5RyJBu0AvC8QEKlbR4oU6pJKxEXkgrIHipNWD3+mt34+?=
 =?us-ascii?Q?w8yfYRYcIc2RZtWLOtFz5lPE165FUCoTnOodVUk8MzMtWdfq+vOUzsR3CDqH?=
 =?us-ascii?Q?+p/P6IXPuvQaQLWwWmayIkOqDyMahsoqBCFvwaVSSIkLs5gQe8BxtqM3Msvu?=
 =?us-ascii?Q?X5GclBDt5VNRIKx+2hXjCji5jjS6kPeP+5lyyTiM1UF+BTk3bivjMteLHn92?=
 =?us-ascii?Q?qZPlmH+EWhU8mb17J3+tEJ4cUFZiS4Ue7b+kZWzGPJjCAogSrOF/jr3itEaG?=
 =?us-ascii?Q?1mPlMLCT+9tThWJnBUtDGopOfVXvYAlf9knI/ajAciwef3zFhPAnRRurMXb7?=
 =?us-ascii?Q?k4YwRnIKLLgPGbmePnyx75OHHftDeSQbalysk5TG8/0wgRUWhyawYSCcNFGg?=
 =?us-ascii?Q?KiDFrgebk9dDB52VEyWzdRSMg8P+r7F9FOhVya9//aaGrPxqyKL7kcgBClWw?=
 =?us-ascii?Q?TQLAgj29VTuaD0ocRkgUh5KQPMUG5sxoH4u6aj4KYFLpGe+pRVFI+jaWtjRe?=
 =?us-ascii?Q?itnSiA2IgZua2JVZFNJu46AkLI+PY2BBN2aSdWSyeqym4CCvGEfcFX9j0x/A?=
 =?us-ascii?Q?bSY6+hKAt78/KyeRn7OWsy5k9epGCkf9YA5Es9MoTSepxpcJ9mvN6hfDKLpZ?=
 =?us-ascii?Q?u7aCpR38FGO3XcVBuD1TkmDrUAlnfqsZ7aZ4fCdi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a2bdc6b-3b6f-4109-5275-08da6b19230a
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 13:01:33.3517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gy8EsSXX0exOZr9JaRS8tQ3eEOPD6dqPqKeQcMgXALYa588ZYxDxz9LEnqHs7+wF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5832
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 21, 2022 at 09:21:19AM CEST, vikas.gupta@broadcom.com wrote:

[...]

>+	/**
>+	 * selftest_run() - Runs a selftest
>+	 * @devlink: Devlink instance
>+	 * @test_id: test index
>+	 * @extack: extack for reporting error messages
>+	 *
>+	 * Return: Result of the test
>+	 */
>+	u8 (*selftest_run)(struct devlink *devlink, int test_id,

It should return enum. Make sure you changed the variable type you store
the test status in.


>+			   struct netlink_ext_ack *extack);
> };

[...]
