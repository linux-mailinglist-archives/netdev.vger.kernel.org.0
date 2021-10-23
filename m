Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3508B438133
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 03:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhJWBD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 21:03:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33662 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229935AbhJWBD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 21:03:27 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 19MLBUvD023424;
        Fri, 22 Oct 2021 18:00:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=EZAmmY2ICdlll12drXUBZc//lSrGH4zeM2zQPe6f0dk=;
 b=dYRPvy4XWlHrhhGK1xF/yU4yAEBvlE6ogI4f/PjnCFB+3eb7cyXhnSGqls3wK36RZoo6
 z7cLD2e6seZ/7zhbCnVdSU/nTsCVvJQCMXjXEWugL3jnVK3fz9KRzDawQ2rPHzuZfjkr
 0pnX8S0i/lnkvx0Do4aan4lW8Ae5/4Sp+PE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3buu1ye498-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 22 Oct 2021 18:00:45 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 22 Oct 2021 18:00:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0iu8XV/abcC7UpC/QB+nJ7C5+qCyOhG/f9K7t9TIweaOIexYP7QgbTwuC/ySM6na+5vHJCYb0FOm+tKyE0Ad1WWRZhdpdmyZS3/4XSvJi6qy5ot8bEOnntico8EYri+lfVNBNnWSVzYFcaNl7dHcyBfsaAHEDNcWY71o8DaYcw2cTFRkTjzfAuTI84gdPPGcVMX5UEWR8N7dwvU6hGh8xt3nWf2MnpdbHUHBMcvyR7LR+nIYsZmAPLELoTUGzoNOmp02BKtdfEHR95jRGgEw5EtJY8HCNOqjqes6r9EdUnUKa9Nnn6PNR6ziatkK41A2W/kC3tDebnKbcWt47iQQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZAmmY2ICdlll12drXUBZc//lSrGH4zeM2zQPe6f0dk=;
 b=TatjFjgV/pCJ2syZoRRM57GLKqEx74pvfk71EOZ5dfl5/SS0FNuua3CjNDDq8iS6dC0+WdB8l8OFdKJGxSSLwGKiRWga7bjfrbuGX3aVFCJ8M7f5JOs3iNWldQ27dEO5s0VG/h/HSzaBGgRY33zTno1YNdf8cuwNlm+BzFqkLbsrKl1GZ3Ym0xcN3fvW9xOPyzc9IzKSlMVZ0tMLfbSsDq+YMTHlH4r6FSLqhjow0uqjfZ6thuJ4jsk9pfE7RwVMKdbpMoYbLY+q9BC9rHWKMvLxjcLIEk6nwYDXwHoDeRTTkCVaMFBMGEB/2U0770x5ts1EzfS7lTjJHgK8RP+jrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4886.namprd15.prod.outlook.com (2603:10b6:806:1d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sat, 23 Oct
 2021 01:00:44 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%7]) with mapi id 15.20.4628.018; Sat, 23 Oct 2021
 01:00:43 +0000
Date:   Fri, 22 Oct 2021 18:00:40 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 4/4] selftests/bpf: add test cases for
 struct_ops prog
Message-ID: <20211023010040.v5pe2aedht3judd5@kafai-mbp.dhcp.thefacebook.com>
References: <20211022075511.1682588-1-houtao1@huawei.com>
 <20211022075511.1682588-5-houtao1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211022075511.1682588-5-houtao1@huawei.com>
X-ClientProxiedBy: CO2PR04CA0096.namprd04.prod.outlook.com
 (2603:10b6:104:6::22) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:792e) by CO2PR04CA0096.namprd04.prod.outlook.com (2603:10b6:104:6::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Sat, 23 Oct 2021 01:00:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0609d02-b366-40fe-d9c0-08d995c089fa
X-MS-TrafficTypeDiagnostic: SA1PR15MB4886:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4886358DBEEA091823C29DAAD5819@SA1PR15MB4886.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ILcn6J49wwlkUVfkdaEqQpCPk2z5Fwfx6CIdRP/aSJTJNqTeWDnUKoe8kapHfg+SnKtR2qUP7DP9MBiRgaoPBo1iWQcpK0GpNLnUYOYciUe5lfXTVt3hKb5yZgQPBrfI3DB4H15RoNfZfVp1C22N3F41DcKTs99tvSPFXMtcaT5BS276vsTQMUJQwuvOdBtixfatlPoE4+v8SNptt3YWLBQY+SfGxSlr5WoKS/y8xG1t5JA7AvqyrPR1FCykWVvda0fiuxNaWIt7VOizaS32IQiFkYmvoUdGr7YI0RLfdOPHrumLRZbV5GEz/KPeejk5jaQEWopYYt5d0m5TtkYap/BwJjJfHwJJtuaOgZaE3pUuRLzrw+sxjz9caX/tx7RI09ls9r8AlnjtumvhSCZcVSsPNtwlB5SUGGwbDyMHZeQ6xBVvLcP7ThKOLOxF4l1cYR9jYtnPYC+hxxXdys0X+CZNXVo/g0YuXmPKiXtNiaDrnaP/5KC10I0c3ekfFiTKYk7iPQtZgwfXnvaZhhlKWjSUj2lVbLc99apOLy4MMMKSzi7+lYGN4gtd/tnqtA3Y93YejGMCeZWjHYJicFSHksJ0geU9MkaFGA98gvJo0ZCTW53GwI02DeCbLqCKbWsUoaa7TFZI9kJCbc3G1RzhrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(8936002)(38100700002)(66476007)(6916009)(508600001)(66946007)(5660300002)(4326008)(54906003)(66556008)(316002)(6506007)(55016002)(9686003)(86362001)(2906002)(7696005)(52116002)(186003)(4744005)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yew9tf3+UzjL2Un3GDT4BUhyFnJrV3SpsdyFGQx4qta7ti9HhcclXr7rWFuk?=
 =?us-ascii?Q?XhadAHUT+D1bafbnTdWefBfxjxFah51NNdHdTWExq8iax26jVS0OLk/YAhq6?=
 =?us-ascii?Q?gWGGjay1DuSIcG17VE20zZi53AtiCkxI5FtsYLCP03OSp+JQx98WbfeF7p0J?=
 =?us-ascii?Q?sAivAQatcOpKXij087tDoH8OpF8VNFwMwlIiVGHSoqTDNx6u2chPrJcGmQHq?=
 =?us-ascii?Q?uPqOnXDFtpNvmEoEb85MG2YpGSOVjYcqRYGQjsV4lXq4MNsKSwJf0xD+Jfyh?=
 =?us-ascii?Q?sAHf/EOziPwclWzY7z134AsMTndRSgy0Ft45d8JaxdTnDtxwJ1wUaE6icU9I?=
 =?us-ascii?Q?38KWbbPsLG1LDM3LDqeM6uNWrRJWn/Or5RuG2Y1DkxZ+SPi87V7QGgG86Lt0?=
 =?us-ascii?Q?dwa76c+Ca3JErQfH3hU8ig27NQbWF/Ot0FqsSIbeQ4Vjd31UwLHhVwEZ0HFk?=
 =?us-ascii?Q?E7aF6admaVHjdkCRs4I7nhXd0Z20CWPCm2CUcQqrCPSpRDA0N7l/ShSBGtA8?=
 =?us-ascii?Q?3YEmiSL/p1aOBmiXt3If3ssShLwjCBMPaOAq9L8Ao7uh1rHpn810cwwY9azV?=
 =?us-ascii?Q?qxjad6+Eajvl0tb4f6IB3hW6Mpm+R9j7YFg6lr/kdciTkfkteCq0Yt+syzi5?=
 =?us-ascii?Q?2nrkcTtklU5PPumOyI1fX2MSzSVlp018i8tRXhJ5uKMK3ZYbLqi4u0DNct7+?=
 =?us-ascii?Q?w1bxuAWdwD/sxf7hZrkbM2upcQa45TnN32mzdLNY758VsqKdEXn7B05k3CuE?=
 =?us-ascii?Q?cKF4MagWgV5hXEMsaMvL6KUzi9+JZzwoGF5jSOt2K9ngcpP0M8ptxmHAr2d/?=
 =?us-ascii?Q?AtPUXlmRm8HM24furJHXNeBX9fM+D+vNj7nuOpvUp2T8+hm+s4T8oWioJN88?=
 =?us-ascii?Q?cEGR3zT20wJlhrKMUh7tJmT4lgSDBqAOwg2fGwfEudID5R7PA7yr5Wa/Rotg?=
 =?us-ascii?Q?Qx1B+DwoPjPPOUqx/kn1vW484+KgciIfBjgDkpmo72Ww172h6GBWHCX25szk?=
 =?us-ascii?Q?caWqKLmQm5aN5qvxv1SzrJfy3ucuL4GprTmrQA49o2vjr1P5IbXgZ34+4aBN?=
 =?us-ascii?Q?mCwQwNqQwRYIbI8EwssUc/QENefA9pfHOlpYd0Moal65tKlRaqbjq7UPI9hT?=
 =?us-ascii?Q?SAim+5JQ2uSNySVK3DmSutoqFC5QQDuzC6Xb5ia0tE8n/S+Vn3FvQEgcBTd2?=
 =?us-ascii?Q?ze7iIyW5S7zevFGGFy3b78PF8p3v9C2l8s3Ev7QHCw++kVZVyrXJgw/w9SXF?=
 =?us-ascii?Q?Nc1TC4AZdlL1TaYXIp4U+rucEiCq3nKge8zkN3Roswh4qdtWbj10gMNhnG5f?=
 =?us-ascii?Q?vGyXSMSoQ68/key1KAANAoqf6wf9lLgfrnO1U09J9jHAJKmoMr3tjRQukYfB?=
 =?us-ascii?Q?Ae7/TiIjYJT2o2qjDs3u7+KWlyj+ShK1nAItu1o2h8UrqZI64fDearzr9ZgK?=
 =?us-ascii?Q?+wl8HLkSV2GgVFmzH4JHJ93Gm4T4vI/pToV7ermBUfi7Fpi3Qrfgcsg6Y4I3?=
 =?us-ascii?Q?Y99ak5mFhST7mAWFDJEWOGrVbwXsCfdG/DhqMuD6umREtJevQMx/lX4GMDn9?=
 =?us-ascii?Q?SJJHIp0c5v2ZnqjtJgbeKDY8idmN/eFUgrJC0lzyFX4ZUm5p69gAQXMpGYYN?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d0609d02-b366-40fe-d9c0-08d995c089fa
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2021 01:00:43.1888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bSIvn9jFiSRn8KP6ZByf0K3INqj0dHXcusY7TUpkShvkQsfPztYfVJqnyt4DWyq6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4886
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Pn2WIBsvaLHtpK7HWAGfuxFINWIvz2OK
X-Proofpoint-ORIG-GUID: Pn2WIBsvaLHtpK7HWAGfuxFINWIvz2OK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_05,2021-10-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=745
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110230005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 03:55:11PM +0800, Hou Tao wrote:
> Running a BPF_PROG_TYPE_STRUCT_OPS prog for dummy_st_ops::test_N()
> through bpf_prog_test_run(). Four test cases are added:
> (1) attach dummy_st_ops should fail
> (2) function return value of bpf_dummy_ops::test_1() is expected
> (3) pointer argument of bpf_dummy_ops::test_1() works as expected
> (4) multiple arguments passed to bpf_dummy_ops::test_2() are correct
Acked-by: Martin KaFai Lau <kafai@fb.com>
