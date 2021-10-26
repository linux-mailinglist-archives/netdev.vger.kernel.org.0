Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489DD43BAB7
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238679AbhJZT2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:28:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38986 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238684AbhJZT2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 15:28:00 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QFXFGr025840;
        Tue, 26 Oct 2021 12:25:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=dQJW8O2XY8jkDsVc+lZdeXxbE6tLNOjWgC+8Z99liIU=;
 b=WST8PDYyXlYbNa94PStYIri7EEcU+VLL7HuaS9MTKhKO3kIutnhJzIZWWoaVnMPQJq1M
 NPVoea9OAbh+nUpHhmGmZC4uumAw+X98VBoXXUb3j3WB1Hn/AwWF7dKXL1ATblOs+2IE
 jW0pyTYuY0dhY7OgblJ8iH8FID8dpSDNiVU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bx4e7qsdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 26 Oct 2021 12:25:35 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 26 Oct 2021 12:25:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uq3XABm4LQBLAIPT2WzvIFDWOKFlX/fdEq0V7TRCLbxGvzxiFk2xTCMjCTuPSeD7DI8z0IHUyjw5ajmv6dV0lvMQYsUOk7OQrXXrzkZcft46A6ErZU7rw+R0MhQKM686OlIAtYkzilU34EVonGoqpq70aa3ietNCe6ajt9u+pbOYAkF2F7gOD3lnqWbev1Y1uilSXFj/f9moKQrbTuDC8+0whRTpQW5CJvkfWH/+sfgVTeurKFfvgZqA/lB8lrvVo13/NCiAyXYGM7TyLlwCc6pY4I5Er1+MpiCd/kD5xZ6QN6X0N1iaPOAcFWkWleVxQDjD7gjVMQQSIJu3mKhNWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dQJW8O2XY8jkDsVc+lZdeXxbE6tLNOjWgC+8Z99liIU=;
 b=ZBcIS54dOYrzpkcaKJKbyGoSvH1uP2cOhcBmlESgQePPJeBuCtgy20Hhh0HKCqJIpY2qJwvec+BffEI0tRhydGzz+Li7PPnmQ0K+mgMkPpIdF2l1PCLjUseLm5vG73uslzH25klTkKgknsdal/n9gOdN+9HoZEuIm2WwipJQwl3SHJ3ncoUlZsgOqeAEdpg9KduzQGMYecqfMx5D2aklJYg2p6qUnUAFgAzFGFn03EkEGwgaUvOPDRs5MWM9eqi2ch7Y3r1LrTpxHlFh9siOKGIrZ5UbvbVR3uWfJP+G2e0r6nTranjb4HV5UXabQ+pb0MRVMKdW1aJGZ5gSNXIyLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2240.namprd15.prod.outlook.com (2603:10b6:805:22::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 19:25:33 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%7]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 19:25:33 +0000
Date:   Tue, 26 Oct 2021 12:25:30 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Tejun Heo <tj@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpf: Move BPF_MAP_TYPE for INODE_STORAGE and
 TASK_STORAGE outside of CONFIG_NET
Message-ID: <20211026192530.jogbgykrgra5ic4v@kafai-mbp.dhcp.thefacebook.com>
References: <YXG1cuuSJDqHQfRY@slm.duckdns.org>
 <20211026191933.as4tk6vclw4q2fsg@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211026191933.as4tk6vclw4q2fsg@kafai-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: MW4P222CA0016.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::21) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:bf3a) by MW4P222CA0016.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend Transport; Tue, 26 Oct 2021 19:25:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0dda061-923b-4ef5-0bec-08d998b6614e
X-MS-TrafficTypeDiagnostic: SN6PR15MB2240:
X-Microsoft-Antispam-PRVS: <SN6PR15MB22407952726A5C4F0B2FAAB9D5849@SN6PR15MB2240.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9aeJqyZSsuNKQYTUHppNeeJ5Ht7FatAcj/b15vJAujexcd8/xQ64QeGMa4iZJseXupP4iYjf1MxGWrxeo/ztEdjuCdbBKpZOpTcl5wNvIO0cdq7j8EJSCbD2nxpKGTZtrHXbUMumoalpquKmARh2qk8UoMRDp8Im8VzUAfLiDFvnDDqc8hcyxw49QMaXrZa8Won4rL/wRDhn1xed0VpgZH1FcaU66KUZy6nsnXb7irFPLKaO1iN34JHdSWu/1dD+1UtQrvCdLkA5ZZIycy/QOq0tsG9+zShYXBjRAIfN/RPl3nPC0kDFwwiJPiE/4JT0C848xtIqrhs/e5sWBUv789MPLDQRqywz1CbHxT3T+2pl5Gbi6nlbljsoEPWWHP/hds7Ty1s9oBDmM8gnHfH9+YtBdaGNvxRvDU0AUNXC+Y7l1dFR9nr80Nrptlaioi+227fHTWH+bo30P+LQIVFtLAy9nZFwwZAm+cewuA3kaDmcQHckY2nEDYW30lzMAYtHIiYS+LUCRtXD1yog4U1QAEYjaRzzpFudxpCBW2Taz3EtvG9f78PF2Wa2U3UxnSyxBpJ3sW1zfDiOOEtW6pTwRUmoszRItAOXtccRAPtvq+dhrumnMSfZS+RXsx83ATS+GoEHd8RIGm+qxzgQeGVmqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(86362001)(186003)(4326008)(6916009)(52116002)(6506007)(316002)(54906003)(55016002)(9686003)(2906002)(7696005)(66946007)(4744005)(66476007)(5660300002)(66556008)(508600001)(83380400001)(8936002)(8676002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AMtpaT052vry/eClhl6YfQwY2VkLRGGsC0hRNhGEUV2nDdw4ZBXlC5UUWBka?=
 =?us-ascii?Q?bnXtpu8v8W46QN4ho/a/j5fQNCksRp+9JJradKPMQiTZ5WmXzn2l8fi5iHCF?=
 =?us-ascii?Q?E0NAMb8UEQjFc9UNtBIuZWFDGoEojNYQJQ0f/MbaRpvWxHpa5g+xdSw1SNLu?=
 =?us-ascii?Q?mSxK0cSWKpItZrI+tTY92UF2WxAk31Pah9aTn8X4kB2Ma2VT+WTKD5xL5pFX?=
 =?us-ascii?Q?9q32NJQ7VlnnIuVWaOhj8ABab+uRHTixZlupLfXKVPG0MRL1SQdXdamMCn42?=
 =?us-ascii?Q?PYPDJ0kAuyAWb7w42nUPxX+Uz/p3M0hV8zFXGcRohSv6QUqpbAbdz5+oVvWf?=
 =?us-ascii?Q?pSmf9eVekwB2jbaOa6P2LIIpxQhfFWlxbnBv3cZIkj39k3CXQyzvl2S44DEt?=
 =?us-ascii?Q?0FwPIeKydh5lkXJdO0TyGKgFGapw1t65PxPTfBVGnrt6pYsvq0CAzpfAYOHG?=
 =?us-ascii?Q?tZXDhN37VV8qd4NR/QMY5jY6PVRnvKZSLfyZJYboBSWiCV2KsyN76gFRAYNL?=
 =?us-ascii?Q?e4ZnIXdQUMGAauIUxsxIrNBlZ2aQfpP9c7AmliToiWVlRDUFWfdqDO4o7dCV?=
 =?us-ascii?Q?2+OCOJXZOo+RS4JBLtCN91SG1gSZLJTF+pLg77QS927zLxK2/ci8m8+R2JIG?=
 =?us-ascii?Q?M9FayU0KcaTMYNxH65v+FFrFrKeEXNo96FwasCeEmkWzDqJ4FwDCzcM0WabE?=
 =?us-ascii?Q?vwRkZgejA67DuhgsImELeQakm7hC4cKmn9QsWbtRNG6N3e4NjPNrD1ojVcdP?=
 =?us-ascii?Q?nf0n10Ot6eDPh8oK8vld6WUjMwkST3myhCDbsgtpIWE34Gw4YJqp/W/zye5e?=
 =?us-ascii?Q?Qmk5RdoHgHo23f3wjPvCVXNMbOQVNuAcN9IoRjkAam0GL3tys+EiSdzyxlEz?=
 =?us-ascii?Q?yimc1enfQyz3vo4R2O5/X4JJjejZ7ntAw28UCzf8xUt2MiiFGHSOOkZU/0ww?=
 =?us-ascii?Q?mdvZWomwk5ZElaimwEqtyEuDSm78XkrFUXMZ54Vgvp6sQQpDlXGhnfZrjnQR?=
 =?us-ascii?Q?HWeKvH1UYHJrCm6q3bpccPyEriMYfIcY/13OKhh95Z3kp+jlAgH6kfhZEJUd?=
 =?us-ascii?Q?5dD5tIG0i5g641HLB+A30y9eB4ndo86eBqoifEJISYmd49LIOKkJsTIUzL9g?=
 =?us-ascii?Q?Wu/X6j5+quJgXJMhM4EacskuUSGFiY4t7z/IGlsJPCxLLT0ApQBpEjHDJ3jy?=
 =?us-ascii?Q?5Xk/mogsbPwI13kDVkOWWFx5b9gCxKsxuxW+5tahDJxQGhPmxdIhX3ymhBjB?=
 =?us-ascii?Q?0aeAoqTRGMohyIuW+8gX7VMFozCcF2VNRQ2eVkiUxXIyqSydp1/FL3iSsA6j?=
 =?us-ascii?Q?cTcLpb03noEzBpI4PR3wuoYGwRnv4Si5MnLOinVbYaOd2R3dl2+W5amWKyjK?=
 =?us-ascii?Q?iEnxAB9wkScvoAHpUwdTGbPuEC0HyOiGfM62FX+pboAC0DRxcQ0SIPFNzILr?=
 =?us-ascii?Q?9vycKDZMsjf8WiDAut5zCchxqj42zDHdx3o7GeRPBVIOcFA2FHrxJ8zqYDgp?=
 =?us-ascii?Q?JWKJGVMvyNlK5C6qH1+aQ46BInDxkrAn27WpObky61wU2Use1xahFJyvxRV0?=
 =?us-ascii?Q?gtcGe41O4mLzHxVQUkhaPWqJpTTr4N6AXHhzekCs2B7BtQSpw+5cIswTeeso?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f0dda061-923b-4ef5-0bec-08d998b6614e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 19:25:33.4586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Lcmd+HKO3J4N9q6GkqmltKiPWXH0/Fwyd905ZA/xiHI7mBEwfFzwUcyHXo5T0ED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2240
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: LMvRBsLa9iYLmtnNYiDwenGUvI5Xp8hq
X-Proofpoint-ORIG-GUID: LMvRBsLa9iYLmtnNYiDwenGUvI5Xp8hq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_05,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 mlxscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=690
 phishscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110260108
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 12:19:36PM -0700, Martin KaFai Lau wrote:
> On Thu, Oct 21, 2021 at 08:46:10AM -1000, Tejun Heo wrote:
> > bpf_types.h has BPF_MAP_TYPE_INODE_STORAGE and BPF_MAP_TYPE_TASK_STORAGE
> > declared inside #ifdef CONFIG_NET although they are built regardless of
> > CONFIG_NET. So, when CONFIG_BPF_SYSCALL && !CONFIG_NET, they are built
> > without the declarations leading to spurious build failures and not
> > registered to bpf_map_types making them unavailable.
> > 
> > Fix it by moving the BPF_MAP_TYPE for the two map types outside of
> > CONFIG_NET.
> Acked-by: Martin KaFai Lau <kafai@fb.com>

btw, this should be the fix tag that has both task and inode storage.
Fixes: a10787e6d58c ("bpf: Enable task local storage for tracing programs")
