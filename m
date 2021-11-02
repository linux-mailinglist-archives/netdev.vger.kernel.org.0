Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376D54434E2
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 18:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbhKBRyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 13:54:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56344 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233682AbhKBRyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 13:54:18 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A2Hmp9h025039;
        Tue, 2 Nov 2021 10:51:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=CaweqypC6CFyKI/IqNjBw459G8TfNKr4AvamQ25W23M=;
 b=bPyC/pIqk26Z0791mX8fDxPCKakynkcYiAOLcBqsFV07qjkyRCYR7MhamfyhmS/VH5WD
 H/wANwiC3Hb2pWav063RGgxiJlDzm0orDaIAtMSdIGDR9ePJdCTWE+80l/iYgVwz8089
 NH2xGCN9sgnO/F1Xw7VyyUd4mcRs28OddLs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c2w4rw2gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Nov 2021 10:51:19 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 2 Nov 2021 10:51:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUyf5JTGGyi4XZo/d3mt+DNF3IjMFD9iRCB6wun8LS7ylVo1HWFQocbMjsQ2sA8VJx8LC9u8OsocEXIWV7N3vy5m0aFtmeEX9dLfMj7FKxBRbtzC1FBVUidshmYMTuV4LvcMXkQvk5nRzUsIrONLbLLMF1RjK6TnL84Vz94BZg5TSSg3E86npb+/vGovPO2PYsCC3T2h7eI7S4VZ/Yj9PczBPkkaAcltvyhqzoxhmjO/tE9nO7DBcd2Nvw1zCKWg1N3WZ/Akn4I26RH1rVhtOQ8HRZwR7o46vxhVFQYHivNAeJxwz522B2NsXMtv6s8ADFx7/G4Ob/K7xpSzO24s+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CaweqypC6CFyKI/IqNjBw459G8TfNKr4AvamQ25W23M=;
 b=QYVSHGCnUsatVxgdPk2gwv1WZZaYzB23F2m6GAEqnOx8k8sG+RV+w+J4i9EF8qJifcpRFF34fU9t4kc3ZGkDSZzPmraeh6gVB4gyo3Zf1fQxsRYnxosnhiBgJdNGiGU5g6q10WIIBamt8uMNRzXWU5AXqP8JLSd4aG4z8QkzrQUrMX+qKjIN+33Ee/oJmTz4dtWUHS5C/CgfuDru5sxWb6a2y7l6xWfy955t3ebJO6TaDJVowKIM+jAuhXa0eJ9Rzdbno3B9e25hl187fxWj91xcjMOeUuAmSPbQv4QnaDhLdv1a9HMEAxbOCuSoHIhRIDnxtHenKZoYOEkWjQedSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4611.namprd15.prod.outlook.com (2603:10b6:806:19e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 17:51:17 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%8]) with mapi id 15.20.4669.010; Tue, 2 Nov 2021
 17:51:17 +0000
Date:   Tue, 2 Nov 2021 10:51:14 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 0/2] clean-up for BPF_LOG_KERNEL log level
Message-ID: <20211102175114.ausklssyuykmz3vz@kafai-mbp.dhcp.thefacebook.com>
References: <20211102101536.2958763-1-houtao1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211102101536.2958763-1-houtao1@huawei.com>
X-ClientProxiedBy: MWHPR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:320:31::15) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a58d) by MWHPR18CA0029.namprd18.prod.outlook.com (2603:10b6:320:31::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Tue, 2 Nov 2021 17:51:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fed33673-a73c-42af-b2e8-08d99e295f0b
X-MS-TrafficTypeDiagnostic: SA1PR15MB4611:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4611D4BD6544C738E8FF3D17D58B9@SA1PR15MB4611.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ejRGC36lq2uOd7V5lEcJBqJwTimuqK19Sx8IwsiwZz6G06SOBEITw9I9P+z1p4yQ671siRL5smRra8Y+wPfQLJE5ylXrZOKH7BCl5ErKAf619GOLhpZhDLsLbECb5G2FJFp+QC87Bq+QxhBedBQecl6QO9ArWCKc1wVKD5WY3+a/YlJOGZZoVS4sHdl6rw8ou1NJQNVePRJR8IY5BiuK7Hc60jbAuOKdSJnXW9/MK+fHV7DPClMERn/9i5EqnblOOHHWTXrMpEkOSZ9a90zcjthStpkUi+3wiy9adD4oql/bzJ/cZYIhumjrR34t9MtxGCkmS1ABagAXNxrWwfzWdctJmgP6Q/iBDakEFLQQVFax0tTpMBjOYbFnF/6brZhJn12tq+dSVClXIxC0AkUdqpUevAXLBCVBcixUfqmtcG7eIWAzSbfyJm33NhY8GyMV38Xsek6utm3ElcgPtQx0futI5QaDNU0lARLuY8ulFVHHBEb8a334gz0cWH2/l+NeOb40XqYXsgUUA61UtLU5nqjSaaUTRrvSEiemIptNgIxkITMCbihEXmPXEVwHteIMuY3qIkHxnfgnayaxXUNlUYh8qBwa487HNZG5kqBccodGaeCGKKgsZOMWzfx8aJcCr4TnxICkqNcV7R+y25HBww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(316002)(9686003)(38100700002)(55016002)(4326008)(8936002)(1076003)(5660300002)(2906002)(66556008)(7696005)(66476007)(54906003)(52116002)(66946007)(86362001)(4744005)(6506007)(186003)(8676002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4b2BjgPvcm16e0QJd/IUiL7gOnFwfd2isOcgLm222kNQ4lbAc8yUUEB0DyKq?=
 =?us-ascii?Q?DyaaetH4BJ8y6QudufB05E5KZ5BujWYT8xO9CNIKbTy4o/k4XezB6higobwh?=
 =?us-ascii?Q?PrBat6ErLSANKA132LP1+vCeNOBaGI2WdYc5XOlHsBXeoSh/SONaGsnVcHCu?=
 =?us-ascii?Q?iebjobsE3nFXhTMtQjPO8+cd8jBAOPbkgEBzq2VW85U8cR8EYK+fhfeevyZa?=
 =?us-ascii?Q?OHKs8f8OwiiMLsblQiRChK7uHT4BQAOaliaIMQCk0RleDv5nnyE0qK8FmSyF?=
 =?us-ascii?Q?UxNmnCEua9swLtSXbhY5AtXkaGl9ZmTKZK5C/JLSRdhfVJReK5uTyJGr/zLH?=
 =?us-ascii?Q?tDdiyeEfH2vUGkSt29aAKLp67j3/uEuChyApXWiBuFnN4YZraMWjlLZDNHt/?=
 =?us-ascii?Q?TjXz58VA1ET80m6586hpic7H6lRiuCX3Wy8FoSr5XglU4Y4aEdMtJfxC6F79?=
 =?us-ascii?Q?fV4UwRSSZgbzBjPgj+vdRj3pgnXG8G5n7b/y8UjLTCNhuWS/nQJGojXxAZIh?=
 =?us-ascii?Q?aGhtsLZYf597y7eK5yuEAPLgZ4eT0sJZn5hF1yP4H6hSceudsrIrHbvDfjR8?=
 =?us-ascii?Q?VzDhKf6R+Gd10zCVLd6kIQf/0qMddiJRoFGgXRisRSHuEiWFrYKoABKibVF5?=
 =?us-ascii?Q?YwkQmVS0DHRqvt+Pm59NNTKGDU3wQcFUssRAhjzvqXu+6NHVzZSp3NhjRTNq?=
 =?us-ascii?Q?onRMcH+33S+r+Eu4m70H7s0BIuJDSraihdvCy6HebtYQrIO3mamL4LmZU7bU?=
 =?us-ascii?Q?VxTSPVlikVPPlHz/yyZv5yttQpGnOdhsaYBGEK454Id0OYMXkWIXOewqvmpF?=
 =?us-ascii?Q?nVdpeQ/2ZmF1/4R3dTM+NEcYkOl6En1ZBSsuyrXKZN8RDADFmV76rZvJxnZp?=
 =?us-ascii?Q?Uzqgquhn4U1Q2Ztzz36kg8DYJwy7omb1HasHAh6SQo0PBO6hIJxzkU+5FAnX?=
 =?us-ascii?Q?IoeCFXz2/My/uk64t70UOdsSe9FxqYXCDkPW2fvzMxmVug3KMmyM/LOdFEF1?=
 =?us-ascii?Q?jZtUAEZ4cGU9PFSsjd1RXMDYPqgJ0VKbzMH5DLFt5EsISLmb0vjFHN22ilCo?=
 =?us-ascii?Q?U7odN0jVvkvlzRqR7PJl392DIHoduSmyUFQeFacsZ6mH2SAkjqCysiImgEBf?=
 =?us-ascii?Q?GksbdBbGJ1nHRyf9v8sbBfc9Ce/OJr1lXUzZXe9pFy44MkrDK3gGO6SSuH5+?=
 =?us-ascii?Q?gob14osWjm5A7jPhXx7+9CQr9l84gSZGy9hVe/sOAlui3Qu95K0FqALoZHJN?=
 =?us-ascii?Q?OXGvx5NfEx50Wig+GserLQXD5KjokEWw2PDIAEhx8Uk3ChIfeDylnyONl4Gf?=
 =?us-ascii?Q?0qLt4+tfuCL9TGAjhv42kwq88cM/xQBYNikWMwqK3t3lhhRfa4UwLFBSyyKx?=
 =?us-ascii?Q?k6BLP9TeCtSKizNwOFFCsH+85p7AhfI14hg9B+SDgCsYjBZ77VtRIt5KXB11?=
 =?us-ascii?Q?h4vHEyRDu3g7Wd1etHwhw2VxKjFYQokJSIX2wdW6NkfT8aTpCpoZ8qxNgZgS?=
 =?us-ascii?Q?zizAUjqkmM4YA11advazwBWYLmFH9xCVTdfG0j1BzKM8m1THwk3u6LJRAjC4?=
 =?us-ascii?Q?tsWK3UbDMuQQ8t/F8rSstV5HDN6tm1UojXKdQ3mP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fed33673-a73c-42af-b2e8-08d99e295f0b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 17:51:17.7913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y0rRxkakX3peecGVuT+5g5xA5x4viZHt4SoEohABHJx8YOnrxHS+iHlntSAAWKem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4611
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Ha5ZR5l8K-bE9fRdihfanWHg0SWdcIGK
X-Proofpoint-GUID: Ha5ZR5l8K-bE9fRdihfanWHg0SWdcIGK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_08,2021-11-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=718
 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111020099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 06:15:34PM +0800, Hou Tao wrote:
> There are just two clean-up patches for BPF_LOG_KERNEL log level:
> patch #1 fixes the possible extra newline for bpf_log() and removes
> the unnecessary calculation and truncation, and patch #2 disallows
> BPF_LOG_KERNEL log level for bpf_btf_load().
Acked-by: Martin KaFai Lau <kafai@fb.com>
