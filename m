Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740994342D9
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 03:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhJTB1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 21:27:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58752 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229603AbhJTB1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 21:27:44 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 19JKeicS030409;
        Tue, 19 Oct 2021 18:25:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=+/w+qYm9C0gLLzYtmEsb8oYv92lTFS6g2gnzMGPA8yA=;
 b=dUY/4oG0GOvWTDKN7h33H9Ef9PjhMhMLHbEpm6wDVUjuJipSVrvjQVzXmtXZrQ+P8gwT
 Hq9574MPgYEG44JGnoOU2Qn+3WM/bhyNB9yZmuMP3Ad/lGgCKirLVD+pjqEZYh6+88Mk
 OMpjKBmAzWokvjLIABCnwuk3rFDKPXgt/WY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3bsu1eecqf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 19 Oct 2021 18:25:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 19 Oct 2021 18:25:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWGtl9c5B3BlXExvXyVq3+Xl2FqeXVtt404eLALEtQu1aa+L2O3d+jGWp+DBUTr9Ayx9q3pE/Fcuo2YpQ8a1+vQsDflSyN4Bo5d+CAL0dNoRl8fl+2EVVgprbIiJB7jejw9FP5Scg423Heb5qzt/ZAd0lsIGwGtO2hvldvImgzH/0ecmTuvLneRo+o7wHiGf2eIBmOfobOojLZTYBc6H++4gVOi8GXd+YcLYRY6v+qvEENeRrszWcz+FiftMX/2+/gU3irUwPblKueaoC1irR2sozbVJ+kTCvoJ/qGvLSWToknEy5UAHpSqfeUtC5NZo0tKnnfz/kUhJwi3fxg3EQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/w+qYm9C0gLLzYtmEsb8oYv92lTFS6g2gnzMGPA8yA=;
 b=SR+PlplyvGtm8jN+aGR4uyG9yGRA+3dYfeHC/SMV98Ox2zN10BXRpLYZDvwGbIzn2cUBHBRWTU1yBnxOrBSbiS2EOeIsip1BenSzy0LH778s5+Eq5b5ciBBCZoewkfABFasEkO03L9nqwo+Z1Nr5jN0h3xrIC7Vok8OBHPD08CWx6RDDoIVHGp/pjIS4EgacDfNZv4BlbOvYbp/xEwYdo2kQIcHRmILkJBXZ1QUBKBAYbmCpFpyHHOsHIh5D2hbEepMc6Pyh88cet+sGund3qd0Wv7pvfBaE4p/lYEo1SIhr5603SjVw8axfxCVigrOykBLy3V6XxCx0Tynazi9oMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2447.namprd15.prod.outlook.com (2603:10b6:805:21::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 20 Oct
 2021 01:25:06 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%8]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 01:25:04 +0000
Date:   Tue, 19 Oct 2021 18:25:01 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 4/5] bpf: hook .test_run for struct_ops
 program
Message-ID: <20211020012501.fgkurn3uqfrieilz@kafai-mbp.dhcp.thefacebook.com>
References: <20211016124806.1547989-1-houtao1@huawei.com>
 <20211016124806.1547989-5-houtao1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211016124806.1547989-5-houtao1@huawei.com>
X-ClientProxiedBy: MW4PR03CA0178.namprd03.prod.outlook.com
 (2603:10b6:303:8d::33) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1383) by MW4PR03CA0178.namprd03.prod.outlook.com (2603:10b6:303:8d::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Wed, 20 Oct 2021 01:25:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ea3bedd-3077-47b5-1792-08d9936871ed
X-MS-TrafficTypeDiagnostic: SN6PR15MB2447:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2447B11210763521415683B9D5BE9@SN6PR15MB2447.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gck+SS3xY3BiDFTrFdWbH+j8UOatMSDAgfjkkZQhC+kFiC16i8DjMXLAkSs8YQDJULLejPt5Ivnp/UKR0SVY3Q+UYW1kvaReIAkBuK/VPAvykmWNgZLjQupdazUMwmAEfTfQRey7l4pfoaz0gbWgCAQwIxBzJBJjuw/0buJ1qMstT3Ol6JC1NKsxC7g8QAdm8zUxgYOH8UQ7ztqJuoTXX58QcDJs1AjugLROynAC8Gsw7jcGq7uWyAM1SpJ5++5c8Q3I0pbv7h0Yw9ZwagmjZpxfmIijIrkxCYV/ONWwF254sYqvFOUjqfxldO+cqgMJ9x+lR/AiyTLwcePohvOWOBAT56lXaO4MWnmK4H35MXvDYQ1TqyCcyH545MOE7X0RZ7dml0qzPm5HkO9NgsX7Y9f39hYbSjgvZt04+wctEvyd0RidHLQ3Kl8ZEZ/kJuxPhSPYTs5LB4go+s/yKMKsi/LIDRKNCS3GoqFlqY5ocyGUQurj5u1heLdE5mtzgcO0yfxXA4pxXv1smr7knTMmYW8m3g0R1niW6tii7gItgX3IVgT+tjT/9ECOReqzXzN9arXzjwpSwbhNOO9DdG45GqoQFeiw+nhy9n33s5qxAqhbKUDkEuuxe+tr4py2cdsQDw6JS9OVROZAZNiyjMLaCIBdu+ohtruOSKP5AjI4TIxvZ6RcSJBSjT0xLe5sOUX/YL0hh+tUVKc1UPN1nJNbpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(6506007)(2906002)(316002)(4326008)(558084003)(9686003)(52116002)(7696005)(508600001)(66556008)(86362001)(66946007)(186003)(1076003)(6916009)(66476007)(5660300002)(8936002)(55016002)(38100700002)(8676002)(142923001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kOOkvibAN9gQwB8scJV+GKJPk8dy3a0oRKfyXuRcCIpVRCUNS8qbeDTndAeZ?=
 =?us-ascii?Q?FOK9YBlpFO7pMdMhLzA922FbRyMyVhvHc9cqsxT2QI5/EHPO5dh26d0X4+hd?=
 =?us-ascii?Q?NAANFHYxlnlAP0+5ARChE3Ob1Bx/YJ4Crs16XRwhf6tHsPJ6HY0+Qy1UdwbQ?=
 =?us-ascii?Q?TP0Tj8FjDqMUrmavoEk3aK083d9yJwTY+ROFySaxdIWVI85HMfBLDdS9PXNe?=
 =?us-ascii?Q?EHBxvJ/NEShmXYchsLo9WSY89DM76LkNCcQHjzClqS2Id34GbaGYMqgNHGZa?=
 =?us-ascii?Q?cMbjS3UIHpQYzMC0/2XcvG0fw+0NhqVkT54tg6Uboj6vUQJFWeGbFParTwdg?=
 =?us-ascii?Q?lb+O3w0umRhH6+6RiYxDPhJ5VNuj584oaPeRs5MZes0xAGW8ZTV/k5EQryVw?=
 =?us-ascii?Q?K5yxqCYbW+nITovvP3Jr2w3IUK0D5vkv6AHy3WRe79iGnrX7MRtZ9TLvDsdL?=
 =?us-ascii?Q?WWM5397gZMRuv+bYy9MFv9bjKi1I0ombOCz1H9+9m8Fpm+uE6LSK2eqHFP58?=
 =?us-ascii?Q?6JTYtOJKmcAnMvdKPTMr9P/vxbBsghpTTpKbEm3Pq5yLVmvM7fTWs7IX8kc0?=
 =?us-ascii?Q?ll+21EWKiSzvSuTfsiyKYk64pJsWRoyszRyIb/c2ofjSBTP+NFRw9J0TPfE3?=
 =?us-ascii?Q?YhoPHe8FJuu5lHrf5MeUdKjQgFYebo7ubKlDMpbOgM7U6ZgiFb68kdRCsM/G?=
 =?us-ascii?Q?RY2nIiIDHdx/but5NdmuqbaodAlocT8L4iewlm0rA5ANYGpxtiu+STlp3c9A?=
 =?us-ascii?Q?zJq2DUqyqkN37DttAdRxl4b0lA55fGa6DOS6TgYDrOtgHWaOlQ8sMORKPCA4?=
 =?us-ascii?Q?YYZDGE0+2V84/Qdnh8taDf0TQUfYxWSFZibsjDcj+IzOokaCCOYrIyqgW/pj?=
 =?us-ascii?Q?UZE0pbkoynoClxACwWWA9u3th7t1gbWblV1AX0j44wTavvAi4xPVfiZ0GM7j?=
 =?us-ascii?Q?yUt41GARgnFmIp2yv+IEuLBO1gpBCQJbaQo/YjqTZtS+Pl8a1Yhjo8sDoIL1?=
 =?us-ascii?Q?nivMc3bb0PuHLMdf93/sUXViWBHwxT1vsKKER/bXUdf/39xd0T48O2nBr3rI?=
 =?us-ascii?Q?NgSYD1gr2a26JGxKIVyzF98s0V5YG+fZeLcrND4kNZbU9C0QSSMiI1+cnRUU?=
 =?us-ascii?Q?/JJSeqEcYg0sOaq78WIX0LVhS2K4omnFqgDlpTZkuVi5UstY5R54km/9X0dn?=
 =?us-ascii?Q?vn2XXfaBtGvtclijp7LWSQKXw6oPFSZHRlg8OHMpvpbJlNzxmWpB1R9aLHGP?=
 =?us-ascii?Q?8ILRshu7DBZ313JSoXxN8tOxKSq6IHHYOIL5qDahABdGlJkrNahETS+ob3qB?=
 =?us-ascii?Q?bqdys0lfwKbI3EfqXYfwJfp7cZKruBthQ1KjLTGTdf4cTQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ea3bedd-3077-47b5-1792-08d9936871ed
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 01:25:04.7747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cGwa7ZMy4yFe1N5eA03GpU7CzQ9zfPKt6sXTd0/EF4B4L1hteY99tJm+1pRJUO95
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2447
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: qdZAAzp9v2CspSUJ3057UFH6CyeFi-ds
X-Proofpoint-GUID: qdZAAzp9v2CspSUJ3057UFH6CyeFi-ds
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 mlxlogscore=540 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200004
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 16, 2021 at 08:48:05PM +0800, Hou Tao wrote:
> bpf_struct_ops_test_run() will be used to run struct_ops program
> from bpf_dummy_ops and now its main purpose is to test the handling
> of return value and multiple arguments.
lgtm.  Please merge it with patch 3.
