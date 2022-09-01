Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B22F5AA08B
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 21:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbiIAT7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 15:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiIAT7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 15:59:37 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0258D883D6;
        Thu,  1 Sep 2022 12:59:36 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281I5jMe015487;
        Thu, 1 Sep 2022 12:59:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=71Xa4hs9FzitpopkcNSXOKrqiS8x+EcPuzSWfzkZvqE=;
 b=V+4gSIwrekGWQbBRElv+TJLrx3WkhO4z21njv3qZGCfzgsAXleyCo0RZgphVr0poNnov
 IE+AJ8BzpAiEMSkkK6yT0zEvjIIu/l9gZGGAFG0BiBCFXNXBAxqAKRsfSwWT4JpYIvYA
 9YYvIKrqtG2R00Ksu9YIXfhDIxh6TtBTIcE= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jat6s43b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 12:59:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfPXY5EYFoMYONInHUkw6HDcD0stiLl6POhjs3kktx56hy/5WWoHDwfJc3X6G9dBORN6CHusspQ2VpCLt4k7CTrCSKtZlqoat6mMNwhY05pi4IsQwn88mvefcLl248s4g6207BkClNg5CxgJmxtVltmWgv4cGeBdMlkWKUCPyGuuUmVEY17mnWThMmIlSfUpYOMCfZb0L4cshuwFf1ZYXMVX/1j1W8K6TDtzenJjJSlpLRo5uVTVVWZZ6ETSDefplMn7nH28eUPWmSpmM/f2kpdkHmNUVCke/J8jkNPnXcnuOkeHbiT3VivER+a7UmFzQspz4ijK/qXKcWOJC2MoGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71Xa4hs9FzitpopkcNSXOKrqiS8x+EcPuzSWfzkZvqE=;
 b=ZvGX82MZpb9LtkhtWtTi4sCDuvzgGIbfFD3X7Gv8V3avO0arjuWv6ra/ZfFQAyuOsdTn8NiIVgUWme7d4YoI92/Jnv6ztNZLUtHlKV7EpaoCtFtousQDTOpLd7DGp3KMUWKPDy5ScGozpJzEDs7qtu8M2QfGVJpCSek4Dk+PZ8YQbyF+/s1Mfwxho5RXiOTscTakuhVM6l39EWmI7t1YWU2HrwuQJERr01lh3vJdr/X2SIGjNj5rdEoahJBCoQwHu4LBL0p4YcwejT97prGd2K4+RLnzUNfBXDoxYQ/J91+SjMCYSPzMXrcUmS/LjepU0UEcLOYyEuhRxmtdl723SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BLAPR15MB3922.namprd15.prod.outlook.com (2603:10b6:208:254::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Thu, 1 Sep
 2022 19:59:19 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::1858:f420:93d2:4b5e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::1858:f420:93d2:4b5e%3]) with mapi id 15.20.5588.012; Thu, 1 Sep 2022
 19:59:19 +0000
Date:   Thu, 1 Sep 2022 12:59:17 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, memxor@gmail.com, toke@redhat.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 1/3] bpf: Add skb dynptrs
Message-ID: <20220901195917.2ho5g5hqsaidzadd@kafai-mbp.dhcp.thefacebook.com>
References: <20220831183224.3754305-1-joannelkoong@gmail.com>
 <20220831183224.3754305-2-joannelkoong@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831183224.3754305-2-joannelkoong@gmail.com>
X-ClientProxiedBy: BYAPR08CA0002.namprd08.prod.outlook.com
 (2603:10b6:a03:100::15) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9f8f9fc-e853-4b01-3263-08da8c5474c1
X-MS-TrafficTypeDiagnostic: BLAPR15MB3922:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FFkor63PGBnXdMo9i2Ca0Vov+OD++QKbX9lZC+DIcWlcHiewustOrpOotVa41fFuC0Gz/GnE1rl2AWjKy++5iIWke30Z/pulRyNff+9mHco8Q+cV00nwg0M4SpKbeeXeyh+0nuKNytBgVfq4s1SeUtth2unae0Mg0k6Zozgsn/HwZOu0eawi6tEtYu6MNDesrlaPVBP1Rt/Dq8yniyUuwi3iqiS2rAprKDUn1zz+/oKZnXef/xZ1a+jzanKFVU5AWEGDZ5pR5Dng0IxMPxWJ+T4T6uhS+qfaMh0fkfvOWfnDrMXpTqMCLHlHQ7MvvuR5WWUr76jEPIVxUUN5RAGkrOoRafal6dNWdIpkKgOsT2bkqKP4JSwVv5MMJjJ0nSIlcTluA7clPjKn3mxmg2qd1jhbg1BLzvl/jGp6Cegc9te77d0hJogQevB9Zaap0pyMZ2uCnIJdueL3bD3iuzjJLZuHn/BAAtDLBiIeWr1Tbkvf3xQktgk3/lc2tuZ97Vb616VrS0G0wWkH8o520SniP4bXYx7fXowthRGIXlWmTxPWAktMYcMbVMuXsr2EgGqSC+FpLbIjmzy//+L7IXCqoowZGVI6HSWr9EnFREAZLk8DOVWMtJBgEDE6YkzeMghEnm61NrALW5kmt74F48X8bP/7q65IGM1RuZlztag+IvQ9zDriAJfxyCiPUJG6wATQkpisyaKwMuDSNEd8Y/vFbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(38100700002)(66556008)(66946007)(66476007)(8676002)(4326008)(2906002)(6916009)(316002)(8936002)(4744005)(6506007)(5660300002)(52116002)(6512007)(186003)(1076003)(9686003)(41300700001)(478600001)(6486002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1OgBIvZ6WTTjWvLDLN84TWnI2YcWjlPxVhRJGE1iydtqX26hrRoM/OfyYz2o?=
 =?us-ascii?Q?spqrXwM66/AGrqPgpvQcoWUmfJdSal0zrvKE6ZvbAPF77OT5/2bsoTK/sTqk?=
 =?us-ascii?Q?waM/PE4uFajkj43BfZvqH+KL79euIPf+QAiuxmu/pfupgYHtwOPwm8Ivq9fY?=
 =?us-ascii?Q?JykQE1DIOTqB7GsDxoL8fJb0YmKqIVYXgBBLj26kVOW7eaqPtOWjG9wmAEUS?=
 =?us-ascii?Q?A51zZoO/vKk4igfOkGtTk7QT1raOitJdAp+pzYj4WL8KS8HAhLeL3vLFb54e?=
 =?us-ascii?Q?rt1Kc/2aDp9rgj+V9/junshKLn49PMCUCZVg/UsTwGnhl5fS/gZlgwUPhOgy?=
 =?us-ascii?Q?wRV9h4Ud4ac2sG2ZbMKXmID0g1ZD7Z0ByLDZJ+sa+K/D9WEKhzfL6ImgU7ur?=
 =?us-ascii?Q?eZNnfK9tKTi1BlE8+shoDrLLn3FJQcrbdYtQyvxpcv126aRWaP01821EZxLV?=
 =?us-ascii?Q?szXdzKvCT3zew4RprmAzIsY47wC5OsfEduKmAy34w7FNLuKruWb6TgjlwT+n?=
 =?us-ascii?Q?u877xYvHQEm11JnMDOPi1FFiZJOQPbea0czuu2X+PPBgq3lA0QXjXr+/9PwR?=
 =?us-ascii?Q?wYzZT4Cj9jLNE9Y7n9GXRJwS8Zq0NTy9UZ3Yw2htRTI1hm4G+iG6tIje/a37?=
 =?us-ascii?Q?HsCxw159fkHF8VPlpP3KUsqo6z58Vp2DCRM5s7v5c5w2z+vTwk3BkSENmGpY?=
 =?us-ascii?Q?ALzPuBldhW1OGg76J3+GvLr3+QN+4A9L5cQOqaOYAnnYpnVD/s4lRZrXYv7U?=
 =?us-ascii?Q?FeXtfDag5xCbyoIpm1WKI4ugw4+bFa/HenuKLcZk6X+zrvPWeHUjkJPfl0Xs?=
 =?us-ascii?Q?zKj7kQ6NHJ7RT4otJ0BmpNQXni2ihxFLWx/POPrAlNh1HYr6fDC/qVHJLkmg?=
 =?us-ascii?Q?uwzy6EfhVxQIk53cCM9e0I526syRFO9Tsm1pQ4BqcjLClYnDOkAlxKe0U6P4?=
 =?us-ascii?Q?5pp3Hk7hEDviAFFgGfuup70ooyI3ZnBERKqfpcrx9h5J1hAide/3YIW6DFZX?=
 =?us-ascii?Q?9+IVwHFAZK+9aN2FgwRcOn6VOAf23CS4m0ItUyE5qtlpmhov3ZldeiUohRaN?=
 =?us-ascii?Q?logYiCwvXPxZz2OZOFZC1TwDm3vkzw+YvXgrLDGioC8GdlwqUpkTPmbWaipo?=
 =?us-ascii?Q?B/IOz9hRNeM5YJIC/pSfcPKAjCRoqqoOB9lHJ2qIL1sjII/il047sl1rtwBf?=
 =?us-ascii?Q?Oj34P5C/rY5lC9XRJEJ2GIf+UIY+mHmZIc58nux1Iti+X2F8jum/w1QUtcC2?=
 =?us-ascii?Q?cUoutS/3+8/m3z5fz7yCsxhgGIiE5E55qjXQF+18HmfopH7fkBeSeqIdjvkq?=
 =?us-ascii?Q?cSFuHyMtih8MyM/2/5hnkpGkQue9vQjksuyu2HTqxdD1Ov4wcJUNAzgqsXhz?=
 =?us-ascii?Q?Nvx/BeAWkWCZxvHx7lljF8z22D88sn7e7EEfHVM6dMf6RZLCIXzg1vsLE4qZ?=
 =?us-ascii?Q?zef4ZOJow0vL1O4rIjrP19EnYKJTaWh4RN4znf1Wunbil1FuMhG0eczP18tr?=
 =?us-ascii?Q?V5thoX8xJSnLZElo1bjBJR9QCbBBGyb50wiYFRn+ioTL6cd/9G8pDlpeKtPo?=
 =?us-ascii?Q?NGIIboB9X+PevNi9wqGcHqzdSnuamHYwtWx1KIviliitbJPa/jrGS7pbViJP?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f8f9fc-e853-4b01-3263-08da8c5474c1
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 19:59:19.1868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Zu0n9+kNbbM0ybzac1m0nqfUG0L+alB+oWVhmJJ4Whsyj/FsVvD4gMjfCav9dAu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3922
X-Proofpoint-GUID: pb7ByAsvRVtAiy4lS-S2usiNCxwRkHgF
X-Proofpoint-ORIG-GUID: pb7ByAsvRVtAiy4lS-S2usiNCxwRkHgF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 11:32:22AM -0700, Joanne Koong wrote:
> +#ifdef CONFIG_NET
> +int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len);
> +int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
> +			  u32 len, u64 flags);
> +#else /* CONFIG_NET */
> +int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
static inline

This should address the build issue reported by the test bot.

> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
> +			  u32 len, u64 flags)
Same here.

> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif /* CONFIG_NET */
