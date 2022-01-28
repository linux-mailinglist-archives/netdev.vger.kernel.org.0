Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C3949F3B6
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242573AbiA1Gch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:32:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36842 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231443AbiA1Gch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:32:37 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20RNaaJe023239;
        Thu, 27 Jan 2022 22:31:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ZENb3eNvxJkMSOjP3sYzrimf4qBX2O4JICNP+T890hA=;
 b=TlCZkWC1GNtSA2p1mW//Ey9hocwgKpFVYvDZ9wBVgwHFLPv6hmuVgSKwYWegwhiKjN1s
 g0rsmLzs8H9n5DD98r3QDQOMJQvilNtieBAVY3RHJGGya3ejurOoP3wzeE4LAHJy4WUK
 LyjeB9s2NxVbLZZ2xAhg+qKpCJ35ns7Bb4M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dv3m9jcjh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 Jan 2022 22:31:57 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 27 Jan 2022 22:31:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jq0kPwTaDiEVyVvXsA0uWqa0aZy5fXi+MwvJ8LZTwfgaFlBoKxcnGehoEPWX4XoZu8pQTpfmIm8gUoJWngYd6EaNkIWZVS38hEyxA/qCxjh/xpALguP8k6cwxFCGTOQP4ffN3UItr8wKiAo5M5PlZBOK7jLd2Wqc+mbirzotKClMU3aKZHDkfT6jj5Mt+G76ErlF0e5DR/PNVD8K/P8VssKB47vadNwlpW4xT8ljcKiZvk5a87Wz+tw8ptDkUQP7b0i4tSIdFkN+rtuB7dmFRMxaxONI/ChTtelOhaYPs4CmkBUytPr32e4ZL46IR2lkMDiLlU+ptlEequIT7QNGlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZENb3eNvxJkMSOjP3sYzrimf4qBX2O4JICNP+T890hA=;
 b=Cc3lUxN47rkVxMuuxwsgtp02Px0kfcOS26DsVqmwPQ/S2xCmQ5FGphAlcbv4oZvNZJae0MrxFwHYrBA+7OEpZ4DW7MDIFmdMlChHaifd+KY6Do0DF0BM/bDb0Wil+XgYDs/TugGghuLqyahobQMxkJgTACGq9Ob7S+5Znk1M1ajRTR1SsFSqQ/Urk9yNs9PlZ/pYWPL1rxyeYH3r7LLshdyFML7yR/s5nRplbnLpXnEl9RSav5g1ayVg6RsZ6ujVGsm8y/SXKKZMh+4AvXKU9l3bWNtSbHZlDuQARkm43JlIBbrtwpUIPTPBgEYC42bcIyrxJ3HdVzZnBhn0uxDgvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SJ0PR15MB4710.namprd15.prod.outlook.com (2603:10b6:a03:37b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Fri, 28 Jan
 2022 06:31:55 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%6]) with mapi id 15.20.4930.017; Fri, 28 Jan 2022
 06:31:55 +0000
Date:   Thu, 27 Jan 2022 22:31:52 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH bpf-next 0/2] Split bpf_sock dst_port field
Message-ID: <20220128063152.gqfrdqa2gszpdc26@kafai-mbp.dhcp.thefacebook.com>
References: <20220127172448.155686-1-jakub@cloudflare.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220127172448.155686-1-jakub@cloudflare.com>
X-ClientProxiedBy: MWHPR19CA0015.namprd19.prod.outlook.com
 (2603:10b6:300:d4::25) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9212065e-d611-4a7a-2023-08d9e227e104
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4710:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4710C2CD47072D1D975E5C7FD5229@SJ0PR15MB4710.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4K4RQBOZ1WFVYpMXWD7Sbkpbgg9vDBrRltgfQYeXAfr6IKNlK88TmcDL+T27i3LgTJRHCl6+fJ8m2alTEj8E9U1bmJmvXl4ilNjy2Bx+5YzQZq9Avb65azPqdPcH6pdYNPCYaDXY3pUTmqwcKiM80ULvnmVLYjNtpFxS3D+x063ioK5Pbz2x7B8HcEc9TKCdfVfP7E9mk7T6mlx15kSsqh8z0yrLISbwNeOpkB8PIM2omGCJzYgMFxAJ4LsEQA3WEvlLh2KThVsk+92VuWoQ21CshUXsUnrN4ln9F0TRHzcR09qX5HpsqAn1zNThKagQilxlwr3JJGVsqDZHYcpvbwc7TLR2rAH9VLAD+H258R0DnpS9icF7EXtu9rKeeQP5wi2NqPpZW5QIwwrvXq781YfmUbyIF+rfJyJCiN65mjJj8VymS0vEoIMjDyrdjxJvEAEj+mgLlV8Jf1Th9FA0VjQzVjU0WKq/7O9Arjcs9IG198pE82iPNvWfMiIfOYjfyUPAzH5OrOXX3w4YtZTaMaKCfGUFEIbXtqA1X1k3k1nypNoUp6DD8QpKwOnFID96W4k6xxa2SWTK0BfC7XtK3lfJdaxXGLTConpn/cc2XcHTp1Ej4JyfsndihNUNdCvN2JQjQF3IFObvSEFHZX6ifw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6666004)(186003)(9686003)(508600001)(6506007)(6486002)(52116002)(316002)(6916009)(1076003)(54906003)(6512007)(66556008)(66476007)(66946007)(83380400001)(86362001)(4326008)(8936002)(8676002)(4744005)(38100700002)(5660300002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/WIpNjR3idJs07m/QN29zIqne88ej2bWJ30M88UzLi18Pt1U5gEIFdmVxWzp?=
 =?us-ascii?Q?UJgRIIpL9xNAPw/PV+ELdmJypvxM16EKFU+kQvy9/WpM0cvbtmtIaoaTY8bY?=
 =?us-ascii?Q?U/brIEZrJ+YTD1iIjcDgD8BjVvOMJwkgeeriaENhmdU/fdb4FQEwZYlZgyrO?=
 =?us-ascii?Q?rP8+HwBL9MDQ1gGgvvCDlBqbjvXkxdfst+IupfuM59h5Z9hgsv7DXCd/8w/r?=
 =?us-ascii?Q?oEAuLInRTcl7qCySjTk0+vrHD5/vtCHuHAeEHUxNbLzLpGzZuMGQrlQWNhbi?=
 =?us-ascii?Q?vBTxMsH0QSXgeV2CIN+i0T4Wx+avclxAbJ0par/WUpzqSFc7jJb6PrXZaNfT?=
 =?us-ascii?Q?TsqFtemH/ujZpWWgf34hyIj0siVGR+YAG6wdl8v6d6JxloZBfiPhmnn4gjfZ?=
 =?us-ascii?Q?fishCyxWcnSIjw/VBhbWtfE22l8iaMRkPGwZJWkejPpFQmzr8zIBlsoArtX0?=
 =?us-ascii?Q?NykTbyw3k8qZSngbS+YcnEBxyWWTOE4psiaqEPV4hBPIT862DIrUoFB/U9Ks?=
 =?us-ascii?Q?pXmzAzEstahWWPYT0b12NgABHREjgX3GDX4TJ9nnfP1P5ntnyrnuo+WXpjgH?=
 =?us-ascii?Q?Bdci3jsL5SLGSAuhmGTuJGG9474dM1hc7L+hDzwfKPW8++laHRGCp+XNRkR7?=
 =?us-ascii?Q?crLUrFpmUzgD2bWh1BY3wumjqsQUCHkoIz+kW+5olzGjy/OAEbXO5GI2JJ6f?=
 =?us-ascii?Q?C561dB5LnZjXkDoZ9sI3BR0gICIKkMf6zvtfwZnW6laT5tAd/FL1pQ457qwG?=
 =?us-ascii?Q?fSCEPVFjedCZKrWtAJ0xwjq+g6D1fGHEv+R3lGXpPsxxRO5RACexA15N46Vh?=
 =?us-ascii?Q?HrX2Cye/+f4dadjosh1CUFz/XSPQ2X7YTeTFz2gcf53OCKZedqA2QYIkRlJa?=
 =?us-ascii?Q?JsEiODFp9VbVcZuvcPLhrfJRCPlkHQMRRUNhkfe4DxxOjQZrVPi2AEl5oinW?=
 =?us-ascii?Q?SNxTEjfuLnVvYl3tH8MuQ77Jux3dVRzOlJddaumI4Ocvh3UPzsKvCGXZSl+b?=
 =?us-ascii?Q?SFiR0dPbmKr+Qzez3jueIokSpCDSmsk3hL9IhJuIvWpE5YsfLzulS5swhCxF?=
 =?us-ascii?Q?RMypKxS5aHYXgQK9vXmBWwfBZqPCllk/kulj+nhxrcLGaDpuFBBAX1BV2hch?=
 =?us-ascii?Q?nPJuHqJcKqayZg6OtdbQxE0QRpeYibkWzYFtHDE24XzICbE3K4fHwxWYqczJ?=
 =?us-ascii?Q?ahQYQbtJnJODlCe5jhyOnIsj7o0UaWZXMZkoi42sS/xEKQsu25LuTxAk0ag3?=
 =?us-ascii?Q?8smG+yu9LeaI0ek9aqXhBxzm0iFbekgZ17lxarnI7zBPOb/xvBMcCpQxF2Y1?=
 =?us-ascii?Q?C+7L1bk6vZ1BZjCswzQ/T5BWTNMPJ4blgqp0HVd5cVmfVF09/8dHCWrDjvFw?=
 =?us-ascii?Q?FNsOAhyOSCa34T4okPqGX8D+yeolHqTMkU078keBqzy2MLMPj7946jXACGpi?=
 =?us-ascii?Q?gf1C8jshHwdDgJkXeeIcOWN0PgRIHjX+Omd4v1m+Kivo7juzxaH+SyHsXjS1?=
 =?us-ascii?Q?leecg9UCd7jZymvPATo1reu9pt3f4293sZAI0xYZipI0jRMElB8l1eTlsT6I?=
 =?us-ascii?Q?fMHAR0FdHCt7o4IwHjutee2hmVCrW17Z2/H/+oP6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9212065e-d611-4a7a-2023-08d9e227e104
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 06:31:55.7474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9rbxwTmBDirxY0H9k2QyvdXbZjluu77j/Ua8Z097XYARzPrKf2qb2e5UwzA3xPaD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4710
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: x0x-6j7EWAbaGDlkilgC3HTSfy83TZ_3
X-Proofpoint-GUID: x0x-6j7EWAbaGDlkilgC3HTSfy83TZ_3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_06,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=756 phishscore=0
 adultscore=0 spamscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201280039
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 06:24:46PM +0100, Jakub Sitnicki wrote:
> This is a follow-up to discussion around the idea of making dst_port in struct
> bpf_sock a 16-bit field that happened in [1]. I have fleshed it out further:
> 
> v1:
> - keep dst_field offset unchanged to prevent existing BPF program breakage
>   (Martin)
> - allow 8-bit loads from dst_port[0] and [1]
> - add test coverage for the verifier and the context access converter
lgtm. Thanks for the patches.

Acked-by: Martin KaFai Lau <kafai@fb.com>
