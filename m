Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031913221E7
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 23:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhBVWBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 17:01:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27630 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230260AbhBVWBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 17:01:33 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11MLnT1r026303;
        Mon, 22 Feb 2021 14:00:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=vUfvAn1bQ84coHxxZbZkWeFDmQPb8h71u/eI876zML8=;
 b=L3IODlDxM7VUfHr0FbKDW1AtXUL9ZLxB1sNxFF+DhHezX/mt/J35jllBeaLcmjTIfFFw
 sYX4SV8EWKIVpfSq6i/KnEkphPFqmV0yTuznF/3BxJLM4ZlD7LHbjz1Uswc08p8uHAO7
 cGTxZcoMozP9geevJiIvH8BW2k5gIRYY2kM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36ujy7fp7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 22 Feb 2021 14:00:23 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Feb 2021 14:00:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrCUuF0N66TR7IW6fky/7/Ixr+ljD2NKjl7HCy6cyUmTY2riZJLgmw8OQyuWLgHcrUI1o1uBbFfMCV/c5MfDa82ZX7bOh0B6VoMw4BwwJi02YrRET6iHbyV/Ey/KrdqYk6P2MoLfuHa2d848kuX3AjkcVZ8tlMfEx3rigC7gbAXyJ5FxgqOu1DjATmjCWYTh4oVLJEepPUfS2uAh9Mu+Ly321AG8CVjfUUxcfDyOf5k4Q4VyfAD/6dFIIT71hHIj21dkeIKObEs8vp2RqPdhTuyMjNmZzfgVX7iWOq0tx8+rGXdd75IcQFhAk8ai35T8xMZXZ/VWq6pjUoylDqJJ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUfvAn1bQ84coHxxZbZkWeFDmQPb8h71u/eI876zML8=;
 b=LWOVhXlLDD11tHMtKgtgjyVlJ9bQ/BnlOJY1HfIITTIQAWSgAwhTyxN9ixw+9ehRQYXkP2yrmcdtRR5KCY3dLl/TxDgDNWnKcBzh6Oj80CW3CuQ06/aZwlhZu5JOY/oOVm4T4HZBhzF8lY8W6z5sqy4buhh6rc5BA7YKWSMyw6kKbv2xLjbiXDQIjny2dvcw17SH0LH5lPs0Pp8PpGgHbt3RsZuT+oHgWgJErzKuXWdTRb8/FoodwkG1k/MJ+u2pgtop1tfa82Afr6Ce3gu7M/4UlSYomFJOLS6vrQhrccCv9yb3sTf9xefVmDiVTy3REmuqriTAXuLueLPPw1yo0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4390.namprd15.prod.outlook.com (2603:10b6:a03:35b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Mon, 22 Feb
 2021 22:00:21 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3868.032; Mon, 22 Feb 2021
 22:00:21 +0000
Date:   Mon, 22 Feb 2021 14:00:17 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     grantseltzer <grantseltzer@gmail.com>
CC:     <andrii@kernel.org>, <daniel@iogearbox.net>,
        <songliubraving@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <irogers@google.com>, <yhs@fb.com>,
        <tklauser@distanz.ch>, <netdev@vger.kernel.org>,
        <mrostecki@opensuse.org>, <ast@kernel.org>,
        <quentin@isovalent.com>, <bpf@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next] Add CONFIG_DEBUG_INFO_BTF and
 CONFIG_DEBUG_INFO_BTF_MODULES check to bpftool feature command
Message-ID: <20210222220017.qw3fby6mapnveg3u@kafai-mbp.dhcp.thefacebook.com>
References: <20210222195846.155483-1-grantseltzer@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210222195846.155483-1-grantseltzer@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:bb5a]
X-ClientProxiedBy: MWHPR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:300:117::34) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:bb5a) by MWHPR03CA0024.namprd03.prod.outlook.com (2603:10b6:300:117::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Mon, 22 Feb 2021 22:00:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc5e1cd1-56c8-4a78-2dc0-08d8d77d3fb2
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4390:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4390CD28BC588197B741C714D5819@SJ0PR15MB4390.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A5pwW/yfmUAmZsn9AGVoCm0/9EhojO/CCzPGTsV/zsWa4ZAPzr/DitIYnASfNFxdcufzn0a0T7eWFBOO+cOBMpKjaqMjxYj8rEHYfx2LFA2LnxrQYp3fjQZ4POOLztJoH5KM4SVEjWnfqIGid5rthUcoPB3p1e88OP5FuGI3RnUlBDW7wRCfh9oT2InrW/G61VQoc7Pf17ElPow2lu7ydvurN17LyjCLYXrrNpjK1D8BpUAmJIdA5UYgGUnoKe1e3guLKOIQftqx+6kmyvvNNR9SgXfrr/n/DqU39VEe4RIwd8R3prYigstCQzBrriA802g4Qr+HkFTaL2020c5q4Ez7/bm3KycZkcKS4W/z1L6WqrPDEfDpc5+6daFKUQ/mm3r42PGWdgzy+B7tvUnqAqpni+gf4w8f1ALxCdBK2MyD1moUn8Ba12EuA0aprEATUlve7r1Tiq3Sten65jkVCCUmWjMVGKC+2xadG+GwV/CsJv5OAcjbMaMSXG58hFSUPLs4VeSS7sHB91NVlbzGqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(376002)(346002)(39860400002)(7416002)(1076003)(16526019)(52116002)(4744005)(66556008)(9686003)(7696005)(66476007)(2906002)(5660300002)(66946007)(4326008)(8676002)(478600001)(86362001)(186003)(6666004)(6506007)(6916009)(83380400001)(8936002)(55016002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?g4iaj4Een3z/7fZnwwggzKPhaSQUl1FgiaeT4aJsz/uthx2y1/EENQ57aaj3?=
 =?us-ascii?Q?WsPVa4WAFVtbBunFK+JqMGmoywytcSvE3bZkmhuv3c6SSluJM4BC0odgAc1d?=
 =?us-ascii?Q?/xyXhhWYtdaf0etAVgOmAP6qtdFw8qfgAxyk4IR3n+vGJKZtSUfIqXT0Rm6m?=
 =?us-ascii?Q?z5zv+ySnw+SwOYgEO+HoKlm7iesXM32+k1n/gPdliACRZ8xN0vsChTbqqWic?=
 =?us-ascii?Q?Mrws3ViXhMloZOqvV1g9o9dVwngZ7VR2XgtiVe9PHroSHK2+LCNwaEzWY4Xl?=
 =?us-ascii?Q?OmfmqnWB094aeNGiLlV5Six1KjJ0yI7u3F9v5T4vpalp1p8Qqprr1WbGkkgq?=
 =?us-ascii?Q?4HEYcux686NfqHXfRqVdJSAVXbb3S2gIjp1T3l9wAAEtebkExFz4tgvABJNI?=
 =?us-ascii?Q?dIkhVnKZiBU/ONpkr76ygKi1+KrK+4Km+j23yF4CEStri9Sv3fN6BhZwhvE2?=
 =?us-ascii?Q?HQu9XK2hvjay5ivoU97Xe72DCW2ct8YXQBsNm8mFZqPE2RpKsc0VNsf+4DbK?=
 =?us-ascii?Q?Zt9rXFQKI3JKj+TTWxbrPIjQslF7eeS89lZdmSUALOoLf0f088L5JcFbn//p?=
 =?us-ascii?Q?p4r/J64S8LU0bGTaWOuN7+wMoAwPMy1bWd0qYBgM0SrRv4QWXsotZS0TgGCK?=
 =?us-ascii?Q?pz8Nd08hBD+ZnYcfSDVX2geP21idZRZ50qho2QaUTxAgG7Ube+aUq74DMeFY?=
 =?us-ascii?Q?E8ZFG88Xoi7oqCx9lDW+GkUmWVEgcPDDaG1Ns+elyHJqM9OwCUPS5/BpqZFB?=
 =?us-ascii?Q?oKqZZWT+IGtvYV47dfYP+sBAdDIANnPPPbUq20y3+dTCy8tg0zkYp/Nr6siy?=
 =?us-ascii?Q?xoGQ3WaMCtfc1c06WYwAy5uzg25EfCTbQUSy4IkHV6Y7ykg6Lb5QYXrCHcRz?=
 =?us-ascii?Q?Ry2gC5F8GKcuBlNO+0yRNbfe/eUDi7vYnN6kAoVF1Lwl7T1QIxACV0X1X7Sx?=
 =?us-ascii?Q?sSF88pOmESwwvoytZA+VWNDvNGz0qxILqW9NQuaeN4HsILKMQlcm9VJBLXl3?=
 =?us-ascii?Q?I4KK7Dnldud4dDDFpk5QQsgxo8KuUE8CR6x1G0OUshhutrftiLoqSz2HKbd+?=
 =?us-ascii?Q?JXJ9UL1X+Y/lJQ9KmTFpORR18+2MREgWoD+Ytvdx7d6Ftmf+YCXNq0ZSwZiC?=
 =?us-ascii?Q?5hDbEwRuI5VH7crh2OLA+XzYw44PEjvS6AulyC/Z2XDw1grPckeVZ+Ap+/L2?=
 =?us-ascii?Q?DhhA8tqDOauDsbsl34LVGThzpHkTKtuhCo1n8xhOOY8RdtiyTCseo+0VD/CL?=
 =?us-ascii?Q?jQxsoa8iOiHZvb6az190a0aNr13As0vIappBu1RERKyOFp7xdnpY11etyKXi?=
 =?us-ascii?Q?JaOB2nCGVElBdkkGQnY+cL/T/Nqdqp28mIyTeoE7TXB6hw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fc5e1cd1-56c8-4a78-2dc0-08d8d77d3fb2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2021 22:00:21.5319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/ImhbRR+UhXUo3u/gHvDrTf1zo/+ixAobSPmokg2ypLYAYAVUYbn/pQ/BpGS9He
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4390
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_07:2021-02-22,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 priorityscore=1501 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102220189
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 07:58:46PM +0000, grantseltzer wrote:
> This adds both the CONFIG_DEBUG_INFO_BTF and CONFIG_DEBUG_INFO_BTF_MODULES
> kernel compile option to output of the bpftool feature command.
> This is relevant for developers that want to account for data structure
> definition differences between kernels.
Acked-by: Martin KaFai Lau <kafai@fb.com>

[ Acked-by and Reviewed-by can be carried over to
  the following revisions if the change is obvious.

  Also, it is useful to comment on what has
  changed between revisions.  There is no need
  to resend this patch just for this though. ]
