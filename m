Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71144380E4
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 02:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhJWAQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 20:16:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22050 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230086AbhJWAQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 20:16:45 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MLC7RC029534;
        Fri, 22 Oct 2021 17:14:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=nbP8f9glXblYFxYV+vg4WzQfMmxd+27TUbVY5iIQaqw=;
 b=FtQTBBo3ossa3YyOaLEsnWwrXNfCO5GZfiMCSUhsHgKmyyYzeBfYWnglJIFMtX/cEGBl
 hbd+TqOSwH8n7xraaCbL6cM0QFl2iqDnOd9C+2uJVwDcnS0NR/ltI9vNB1QxKuqy92no
 FEeuTMrve9i4pVQflkDLEcQzpCvnSEH5Y68= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bunregkct-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 22 Oct 2021 17:14:06 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 22 Oct 2021 17:14:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRkublGHv39dmI60rKxVx6uRy3Hh/xLclN6tWxUG7g1/QdiCyN8XdmxBW2/+YYipiNBd247I6sWVCcN/M2ISivMXKpfDUWqZ7fN73+NWFYldOGmtIa2twZPqBFNKK3pGAY99ZJ1DXSA+/H36eqXHqK3VYNzFDBdAY28hIJb3wbJsTDmDe6IEtbejFzq4+2oPBI7WbAdDbpSLHrXiT2WonNMywOS9X91FSxT5TlJp6RahmRDhzDXEjIYE1VzWbYotY40NQN9IEzq8yslyjPDrHoPk+P36VkKsBZXhdPaQ85L8h1as/R7wXinFVZ9ZuKHpke6ts4T/u1ckAX9GQYZXrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nbP8f9glXblYFxYV+vg4WzQfMmxd+27TUbVY5iIQaqw=;
 b=IwMnU3pzVowom1VEtVOP9oZ63TQgI7UUNtm2vQeb2yzT07zD26aIlYuHVkMT1UkfKPvaQbRFtMDBh/XBVVyRfTLhIrKRwD6jbsZlcoa2oCFqkMBa+fSqPe+inogb8R5w2owX7QairLgpiv/NuKxl2NI5dcOQKh7uZnncHDpD5c2i783I5emj7+8vv8Lhrxznc9s0KKrsBjbqEeGml1Av51IJcKkJ+moRDzURLbM73eTInuswL81JeKcK1fbYH2d7/PkVq5hyU83dYQcyc9qCdkdTDANn0hGtQztWl/Of/gJbu+qqmtDB9Ep02DT+tdbfUhIq8nSWwtmfrRsTgI4XyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4886.namprd15.prod.outlook.com (2603:10b6:806:1d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sat, 23 Oct
 2021 00:14:04 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%7]) with mapi id 15.20.4628.018; Sat, 23 Oct 2021
 00:14:04 +0000
Date:   Fri, 22 Oct 2021 17:14:00 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 1/4] bpf: factor out a helper to prepare
  trampoline for struct_ops prog
Message-ID: <20211023001400.ur55h3hmau6xxkr2@kafai-mbp.dhcp.thefacebook.com>
References: <20211022075511.1682588-1-houtao1@huawei.com>
 <20211022075511.1682588-2-houtao1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211022075511.1682588-2-houtao1@huawei.com>
X-ClientProxiedBy: MWHPR14CA0042.namprd14.prod.outlook.com
 (2603:10b6:300:12b::28) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:792e) by MWHPR14CA0042.namprd14.prod.outlook.com (2603:10b6:300:12b::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Sat, 23 Oct 2021 00:14:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8f9d9cc-4628-46cd-1b9f-08d995ba058c
X-MS-TrafficTypeDiagnostic: SA1PR15MB4886:
X-Microsoft-Antispam-PRVS: <SA1PR15MB48866A884A8DD7EB587BA33CD5819@SA1PR15MB4886.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SsR5smkDWNQPYUy0tDSKs6vmWMbplnvetMdurLX0PQOqmPoobIwY1Udlzof0nuM9QlYH1eowhiBb21LL60EyWgFFwPvN04a1WqyO8E2OnoWaiKZHSDO3W8KEXY50XUvHTAC+1V78gRLSpC+DA/4XRYAZ9DZg8CLLblmSPRF4C9ma0KBSVYTIIE+y35Rs9Vokuf71z0m3KDEANdWyaMpBTyx9kDhzr9wdRxyWdxSwpakPQzyi1fdnBI+oo02v+LOMTUE6L2iBYEfHn8W81bwdamJZR5CEOPQNR9+7I4QZXh2e/7Er9RHQisjK9cwJMBtlPneDtp66zpZfOKKrvb5Fkru7o4dEOmm4CX0duyldkMmgNTNMuJepqNlhYLY78+ocAQY/n8VLp7eN1KGh1R6PwCo7f6Mqydk9gNSVIZSt+JgkTdYylgyKlw+qN4kYEWJLUYCP+WiTtz49DOIPlz0yk48RuX/zY4l7wynssxdsJfLgkpFtG856l/LtY6iCHfYGQl63h8r10YpisC+T/433+krFc8EH+HagdTPHFGc4Fn3ZdL0ZWp1V4bgPBwM1nPG2ajVXwaOk5epQUw8FLmPwNdSaTbgBynTImVYYKB/gBZF1b2/whwJfdsfCEEoKZMyrv7AXaidBTg8MxfI/CCtKfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(1076003)(55016002)(6506007)(52116002)(2906002)(7696005)(9686003)(86362001)(558084003)(6916009)(66476007)(8936002)(8676002)(38100700002)(54906003)(66556008)(316002)(4326008)(66946007)(508600001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FfXDyIKkGyEAvZmpaJKxJE5Pd7adf/0LDljQAuDlYNff2s5HyWtDD3yhzy6u?=
 =?us-ascii?Q?g+AeuovUm9k3WWF63u0MyQLES/JlUMZcGOhBKdEMNB/lt36WabcsFWjrB4KL?=
 =?us-ascii?Q?MOlrQPVGXNqoqlDZyIgjDp8WuPawx5ghLHuWe+vjotkBFVSfXXdYHBkk4v1p?=
 =?us-ascii?Q?ETWtb5CC9uJ1lHIIBWWyIG2gGQB3ek5feJaWEboEauuHoXeuQM0gOAWTb7o8?=
 =?us-ascii?Q?m3ihJ3D39aH7dIrk0ozJqv/n4+UXR+ApJUpAIQx1ETxqGFe4Pw4PtCcvwGen?=
 =?us-ascii?Q?XgxUpt0iG/sZwPPFUnImd/vSno6c9SrU92La3RzhYU46+XJgSJCGsUwMiWki?=
 =?us-ascii?Q?Pmt4C4sgD6S8ZXw30ISPycDXCBo+ovV/bI2XWTnYkVj+netq3XF17KoPxr9X?=
 =?us-ascii?Q?bTQTWG0RhNZTg0MQmOjS1Az0XXOsyb1+iIVPLGC48e2fj9qfGEqbaXgPQAZj?=
 =?us-ascii?Q?OIZo1ms3BUOAw5mPKdTwKGJa4GpPu3+W8KwVJt8rn4Hnah11xfFd4CiValjE?=
 =?us-ascii?Q?eKjVyKBGTB/GlyMxUdK4pXvkl5mkM7JtclY7+XQcu2VWQr+rW8PoqNxfgNOO?=
 =?us-ascii?Q?PBef9x0iN97av1jGqJMSm1uyM2++vF9VmaEv36eBV0SQASP26Jbn4oZBECr0?=
 =?us-ascii?Q?lBFP9DteCpfWVM/bex8gYWMwPFwFI54IDYJadXw7DvWD1sMydoUtsRgyx3XF?=
 =?us-ascii?Q?cDkVd7J3VD+ze8hzCPKS3P4Dr0drv8/iRw6AGqCZ5S0DGKx66J5nTWXfyhF3?=
 =?us-ascii?Q?Uo5gYO85m6t6kxEgdTZWbBrS5YWyTp4a3mjso6ZyqfSqRM+UFmb+5FcglBe+?=
 =?us-ascii?Q?n5xHcnzAb5SKs6+K1k6wQlevW5GYtQF5rt1CtQoI98+dvAXQVSVQ4297CG3q?=
 =?us-ascii?Q?6LSqxjHjgSOOOqkPkHUb4lyJRpRHqlfkGDnaGo7IMLA+HDZetg5TRutki8vY?=
 =?us-ascii?Q?JzYXqYEDMzh8b72Khiq1Bg4/+ueZeESd4iKFq0N650jOsnKF//beI2wHLmwu?=
 =?us-ascii?Q?JYTcVcR0r0lzKKpRiJI+KkUhK1igzMItfLV3ShL8m7/+5S/rMRTkRQe2TMLz?=
 =?us-ascii?Q?Blyg7Sj2LzgVbFjAdIStJOxmfdTIwI3RIvzMUt99XMY1ZjkyMlp9lRZBMXeF?=
 =?us-ascii?Q?1jIJo2UsmVRujQFwzAPmD+/LPUuP8QtbhvyJFE9uTitAqgJq1mqKMw3XNwP3?=
 =?us-ascii?Q?KyzSSBxv9BXlHnpMlzsntY15BPcBQ727IhzcMkFM0sRXBbnl1Ko1DgErboH1?=
 =?us-ascii?Q?jpXjWxE2HTF3knkVSADFtn9aR7RLXzZno9RpvclTZibtvDgUJ4W3uTDT1bG5?=
 =?us-ascii?Q?gLhCDoYrexcdcHfxHEcI3/zjQiXg6oQGjoV8p1/rcs1BfCOSp/xMRFx/6bzZ?=
 =?us-ascii?Q?HaoczzSgU9srcbGGVuO4MKkhEa/h1FvsvPgSOI/nWyPKgtqMv3Zh8n4Z4mpZ?=
 =?us-ascii?Q?5DVt70iGOIE2gy5pmG+U8Up15qVWCpMP0MKET0YXZrtkrOCdeD8EN54T3MbE?=
 =?us-ascii?Q?sZNRj68zkpx32CPeUBi2G9pbPmi8cUBP1Xtt2sKde+t8W0xA1usSmubumhcl?=
 =?us-ascii?Q?aapqSJCL3Hqe4CbnUG/wwCbpQczADdW+qrhnTJ77?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8f9d9cc-4628-46cd-1b9f-08d995ba058c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2021 00:14:04.1141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fa54FPveVtllJaM1BknWh3MiY0/hz7Ic+Hch8h1DJ6iICn/hBeM+Syw6D8Itpauh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4886
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Vx1gS6RPbFitK7HP2u_n5ujpEq_Bn_jM
X-Proofpoint-GUID: Vx1gS6RPbFitK7HP2u_n5ujpEq_Bn_jM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_05,2021-10-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 mlxscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=447 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110230000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 03:55:08PM +0800, Hou Tao wrote:
> Factor out a helper bpf_struct_ops_prepare_trampoline() to prepare
> trampoline for BPF_PROG_TYPE_STRUCT_OPS prog. It will be used by
> .test_run callback in following patch.
Acked-by: Martin KaFai Lau <kafai@fb.com>
