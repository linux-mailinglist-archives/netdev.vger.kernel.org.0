Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC74358330B
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 21:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiG0TJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 15:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234924AbiG0TIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 15:08:55 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F1F655F;
        Wed, 27 Jul 2022 11:48:21 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26RIHckS021189;
        Wed, 27 Jul 2022 11:48:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=DF3Zmo4OTWj8w3awDkpUfgEJXv4uKXP3Ky4Hixc7h8E=;
 b=f/cULplfbJaegVJcpozNGrcGAjwSeJu165YeSUWEhgfcY/S/o3/YWxzOwdMUeaEY/973
 nKKov4NkfDe+xThkp8K+fBbBoZl7jxDgXKmoC0afHJI84NjB8HkY9V2AFZ1jUAHrGuQy
 aadKENqFrI3DJr7BKtrEKDb0vo1OH33douw= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hk36yv30x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 11:48:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwpwUb87YWte2J+yma2djTsU8WhEEBg4z9h1MSZC/8xRo1ZbLo2X7CywU1gf34X7+RgDyzzmDjentgLy8Lr4CHUO19iID1Ouu1BHM6Ab/R3SkCiCDLdFaZGc4kjcoVcz2preoWcKyPr35naChDt3fwwNiwU832T9Jk/Jyh7HeJpB/Ha5x9BwHL1TZtQZGBjbLfM/9bJqojZ55PufSaV19MNVMx4CU1utHkeB4g0nRPPJlyW6GzRwvhj+h+NkrwiWEYDgQ+225s0a6g4UMxJta+oENwPZX0VyRBQf+UyeFIkShlYFSWpPjgDMQ4iRdj13MzX+70YsutJWBcpkiI2Oug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DF3Zmo4OTWj8w3awDkpUfgEJXv4uKXP3Ky4Hixc7h8E=;
 b=Ux9aWoy0U1EpFZd2qqV+gPImG7UHFc6D4Fnwagex5fRlJDhhKYR8zfjF0jbEUs5hCc49MVctkNpuxDaKPyGjXv6h7o6y2cO8fMQQCzuDGFZoQIjeThe9x15xwBPhCIOQnnQ/A/4crOEvlwgQX+5RhRJACG0UHf77jn6toxVj5QDe3spPqyPafRqImHrHBY4ggICdrQtyyowtQBJ1ZMfXS46e+z7NtHPaNjMFrUw23E6vGllGnhl9yPozf8VzFzqwdW43gGj7FXht7HoJO3tUlJ84K5GiGRAs1kj5MHrDHo8UxBz4kOp8PLW7j4TDOXr0wZX/V1WYkioprRq9oXKr6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by SA0PR15MB3983.namprd15.prod.outlook.com (2603:10b6:806:8d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Wed, 27 Jul
 2022 18:48:01 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a%6]) with mapi id 15.20.5482.010; Wed, 27 Jul 2022
 18:48:01 +0000
Date:   Wed, 27 Jul 2022 11:47:59 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     sdf@google.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 03/14] bpf: net: Consider optval.is_bpf before
 capable check in sock_setsockopt()
Message-ID: <20220727184759.j6g4b65uvlp5cnrv@kafai-mbp.dhcp.thefacebook.com>
References: <20220727060856.2370358-1-kafai@fb.com>
 <20220727060915.2372520-1-kafai@fb.com>
 <YuFtsIvDlxh6TwkG@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuFtsIvDlxh6TwkG@google.com>
X-ClientProxiedBy: SJ0PR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::7) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f658ab99-2716-4d73-b658-08da700087cf
X-MS-TrafficTypeDiagnostic: SA0PR15MB3983:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UQhoFvzu/SuFzbH+Sxl/MoXj9goYSU/5x83/Zd9x6tl1wrdzUgHksNxMk5FZrx/wCJYmAI4MI2P4xkRWLOQUsQ+8UixyEhBD6E+pHKb/kLaLHklHkzHIo7q0zw1/VWg9trOAqrPtRzcgHd47XlJ7FGpIuzal69WwAwX5EiOxi4/UKDXzwec4ua34GfSBKVsqMGALEXT1pRfgYD4wNgLdfBcyLMQ33MPubJrVWiU7RHDtnEx5Ir3VNVS39Et5ucchTZX+4u8omtziW0RcNSUC5M+eutvwPqEjlYZTebDPvcq604cV0W1mKf1cXdtBAy5t4QCAZtxXEfNQtdupvBN+Uc84zO5DAwb2iWu0h/fmnT+CZTCj6pdoZ5/twGOMzeS7IQXRCqiPmSVB1JZ3y4VMzmBEfKacGhby3rjNZyRMfphtqb/n1SnSVQGk9+R5vGuQQmQd4f5hZ+qdQBoQ4n9HemOmzqCKqTQ3SItod7+g7MRBXgCO4qJjcUHuG0h1xoRnpzcVoAJ9HfBOf8rw+gtQg8WEKQ3eO46se6rF592S1FcuBuW2iABaCM6mG2CnDyCnWc55IecW+yOe2aNoaXBLYicM0SlFQ4KdAV+ZLSasM0P3thOOkRIIVpElRCc2FojFQ/bBnqKVkKVug8ueJb4VefGPhLItALKKn0C7PACzR2K3vXigf1Y7rq1TXifQrpbMYtdu5LQWKhqVpGpY9nUhmnJpcQBgx91wioqbQ/whx+Ph/x8F5BoiR/mrDwk5zN4h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(346002)(376002)(136003)(186003)(9686003)(6916009)(4326008)(66476007)(66946007)(1076003)(8676002)(41300700001)(5660300002)(52116002)(6506007)(2906002)(54906003)(66556008)(86362001)(83380400001)(38100700002)(316002)(4744005)(478600001)(7416002)(6486002)(8936002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hF5UV9DfozQBWXcz7QL0Un6Aw93NSe6/BjvIg0t/F43wKj7MHR65ziL93kIm?=
 =?us-ascii?Q?5P1cSMquoSXdf1eyNPTst7sHWJG3PLgwVmkRbNBvAHUccxPpYseCtJupFkjH?=
 =?us-ascii?Q?ZDC65+ZufaxqG5IjoQdslD8fUUa69JuenKJovrKErU1lh/0oNAK5mc7TM+7r?=
 =?us-ascii?Q?9PchnWWruoTYFf4+XSAav9Mv8fELn3x+N+OhQ8iKRsU1V0LSpcnmB0UYny5f?=
 =?us-ascii?Q?bNtuy93BIDMgyLDzRfTNR6pp0dmwiBp5rHLSlMFtqET59busk8zx9YmefKsH?=
 =?us-ascii?Q?HtXy+6yNhWykaNjsAXbz1nKF4/NgJmnsmcQKIvYb68/i8JtKOyuzpQSBEFnw?=
 =?us-ascii?Q?/GaFV/HgqQ77gwHbSw8uI4nHIA0XFZOUS5bvQii7Tdpt+MjLzNQtnOmFgEte?=
 =?us-ascii?Q?1VjGQpgWRabbEli6bDvjIz7oIipdQ/qNhTGmMUxoJk4MZvRH0kFwa8PlXhjZ?=
 =?us-ascii?Q?2jG6fsU+V5jV0uIaocGgqPur3nY5Xw3f4N3dzn4YhGHfF6YNkGe2Or/WG+St?=
 =?us-ascii?Q?YnjgJcZ1iAFJTYHu8D+7iQEPZMYFKOdlKX6OVk4Z7cO4ondfzBWL4QUNn7Tx?=
 =?us-ascii?Q?3Xo9Y1DCr4jPDusA/MkVhqMpndjQs9zedo9uLxPl4TLxv4sHVNcIcfNvNlx9?=
 =?us-ascii?Q?Q6qDeqdw+jNRfAys+HDhAPXftKKRDBwpBMdGg3/UU4X9mbX7ZzajiUXHloZA?=
 =?us-ascii?Q?M3Ib1Er7pO5wJlFuz4hhyCMkvRUMi9WdVX23x/iq9Y378vDc8H5OdT1J/h+D?=
 =?us-ascii?Q?yNgFb7g/BbU7sb/QnPamRBTFwdVvlsO/mBNpDas6rGtlZb+UvzhLdCr7wjIN?=
 =?us-ascii?Q?mll4SzSS3szbEXXuaOR4aGRBB3lco3LS57ySDo7upgyv+6pEZh5iQiSUjLBM?=
 =?us-ascii?Q?zoGrWcN9Yd0YdHn7syje9Sr9iSihzd15fHt0jw+F1ksx7CKzeOXCeq3p3gBO?=
 =?us-ascii?Q?DSfb9PAO5KCkVLkEvGNbUobH2NZdyH+bJqmr+E0fTXpQQCDwgFqbah11gb0C?=
 =?us-ascii?Q?XP/pHRwv4CfXyjrNxV3Pbl9GFduUcxmeGNI81gQ4yKdRD7ONW6l4HFDzWeD+?=
 =?us-ascii?Q?QKQ8Wq8Ad6rTog38BK3unuX9oV2fuZ+ITFaf0Rkk8+iGBhNlv7nANtmIt08S?=
 =?us-ascii?Q?GBjEyGyEyi4eRIvEWjgaqrC6Ua/ZGxz7Nyoo64fR+iNHKFFq5KYM3j5mmIIY?=
 =?us-ascii?Q?uzA8pHxR2wVN8RhDW3WIX99gwRfkyAElKDS1B83HIpWItFOy42tIX9AuwiQy?=
 =?us-ascii?Q?SQcKHXJm6ggKSVUTQm9qk+CHrTpcA4aq9uyejwCs1oGMTnv5k7VS4iS1LyDA?=
 =?us-ascii?Q?Zzva8IgawpUcnYXJzHGaqpApRObbKrpMM4fdEFCL6uU/77mfYtMpa5O8jLWW?=
 =?us-ascii?Q?EJDDJw3h8Rad2607M+/KqxjYZIAueD56jf2HHDqPLRFdKrezo/ItXBR7VbbS?=
 =?us-ascii?Q?aBjb0SjASBxSxfdhqUhC0A+y0Cg+rg0yrIlOAje/aC5j1OtmqpXqo46n0jhF?=
 =?us-ascii?Q?VcYwK9qexabuTAKsF2mAGz/dKF76jwrcOE/h5Mre+fEV6j3OSjLql0EmtzIQ?=
 =?us-ascii?Q?DPdBtWWY4ScIE7IZpVo+ccX+9CzYZj7786aqmWcLeQKp9g0QhA37bM56dW36?=
 =?us-ascii?Q?Jw=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f658ab99-2716-4d73-b658-08da700087cf
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 18:48:00.9225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kl3tI472WcSe9gIliuIgsW2jmQsGF0UmBKYJ4/VRNy8AhcnMByuS2ZS9Ym5YIr1f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3983
X-Proofpoint-GUID: cgzPe8hGo5ajf4ZvOUjph5wS-gsMY52M
X-Proofpoint-ORIG-GUID: cgzPe8hGo5ajf4ZvOUjph5wS-gsMY52M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_08,2022-07-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 09:54:08AM -0700, sdf@google.com wrote:
> On 07/26, Martin KaFai Lau wrote:
> > When bpf program calling bpf_setsockopt(SOL_SOCKET),
> > it could be run in softirq and doesn't make sense to do the capable
> > check.  There was a similar situation in bpf_setsockopt(TCP_CONGESTION).
> 
> Should we instead skip these capability checks based on something like
> in_serving_softirq? I wonder if we might be mixing too much into that
> is_bpf flag (locking assumptions, context assumptions, etc)?
Yes, the bit can be splitted as another reply in patch 2.
I don't think in_serving_softirq is a good fit name.  Some of the
hooks is not in_serving_softirq.  is_bpf should be a better name
for this.
