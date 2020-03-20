Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17F1A18C5ED
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 04:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgCTDj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 23:39:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55546 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbgCTDj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 23:39:26 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02K3GKPd023180;
        Thu, 19 Mar 2020 20:39:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=xmoGOLCpTOwge/eUlAvkJe5LjrE6YJVUaUNFmGNenkI=;
 b=NF6j2gdPGXHf8mCkthwgX76Samd2ERxXfet5/3mhVq9F0WdVVEjLlrb26Urcpf6cfPqR
 zxD5H6P3vY9YvpwBSEQdxJy9xwCQ2Tw9LdNOfgpPdejgW8pYSr/1kOxD3/R7kANhZdJe
 4QdR+hsdJiJxlXpOcOp4XEvdAuG/ITk8FVs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu8x3uve0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Mar 2020 20:39:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 19 Mar 2020 20:39:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEOReWGVSFwDN4m2yel0b0MxGdd9LQH1UYjoYG1WVfn0Vb8V6YbACeNRMtfw6LzoPTTeZarYD9RzCktUS3N4Hy02co/znJyIdbobGXfTXGsqjCCmgo0GDlG0dNIgCvNY4fx9DJCvMZSR+7VA8ldaA8Qyzw6tanV4LZaXv8qr8uj+0bRiqd4L74VneoNXWJh00UR4JEiqWCGKnDLnDcnFu5jWz9agleLgw6nR7vpb+CHyFMVV+9mhc8C+vFB6TPbtSx/RZiCk3mBP0OlBheWrkce9DrXTQlr5TBj2Q2VHfdoMgATIrSZPFL3cMw+ol4v+2MQesOIYovJlPllNVXtrpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmoGOLCpTOwge/eUlAvkJe5LjrE6YJVUaUNFmGNenkI=;
 b=TDaQUQSv3fXuQhpFbOkEUXgxnEhs+ZjyH3xHOjHXX0PJ3L5YzbwxDN2k06f4o1VCvRflAYY56YjepLzrvBkvrdRGgaCSsv8WLEL3eqsqxRZ6Seg0C6NRmu5CQ7xqG7xD9kJq23+nK84D1nesBSomTjrieJsF9H2inZuXWEBaNqv2T0JslIGJASF2PKu6fGA47Nj22nO3TedvEF4dX84F0evra5Owz9p2fSRroyA2Qz0pUGS8XMZnKMXVYAAgYZjV3Rf80CrsUeaceJThBZ/eCCGAc6I+BgfIyF1EKWUM6t33XhjGV1vzD8e/zkBvO9RRNj924Fbg1h5k8lGSz3DqVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmoGOLCpTOwge/eUlAvkJe5LjrE6YJVUaUNFmGNenkI=;
 b=QvI6DafyFmCI6mQD6Ys1OE9i3cm8doUudys6opW3CplP72qczzEp4U4ucl3Zs35ZJyLXE2y8VtYj3FdRyxuldOvfHT67tWKiBJ9s14fmrfgcwVZwbLbM5yJtYCPewV4ehWYBrTp1mSBE5vsDYYt56D5L8NFMo2r1+UimMP3Q0bg=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3868.namprd15.prod.outlook.com (2603:10b6:303:40::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19; Fri, 20 Mar
 2020 03:39:10 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 03:39:10 +0000
Subject: Re: [PATCH bpf-next 1/2] bpf: Add bpf_sk_storage support to
 bpf_tcp_ca
To:     Martin KaFai Lau <kafai@fb.com>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
References: <20200319234955.2933540-1-kafai@fb.com>
 <20200319235002.2939713-1-kafai@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d393606e-7d10-cb48-7924-c0441b815db2@fb.com>
Date:   Thu, 19 Mar 2020 20:39:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200319235002.2939713-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR2101CA0027.namprd21.prod.outlook.com
 (2603:10b6:302:1::40) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:c5b) by MW2PR2101CA0027.namprd21.prod.outlook.com (2603:10b6:302:1::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.2 via Frontend Transport; Fri, 20 Mar 2020 03:39:09 +0000
X-Originating-IP: [2620:10d:c090:400::5:c5b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c844c87-8f07-433b-6e35-08d7cc80400e
X-MS-TrafficTypeDiagnostic: MW3PR15MB3868:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB38688AD2E4E10639E1D1E08AD3F50@MW3PR15MB3868.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(396003)(136003)(39860400002)(199004)(86362001)(2906002)(31686004)(316002)(52116002)(31696002)(478600001)(8936002)(53546011)(81156014)(54906003)(6506007)(8676002)(81166006)(66946007)(5660300002)(66476007)(2616005)(66556008)(4744005)(36756003)(186003)(4326008)(6512007)(16526019)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3868;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F8sUMwPd64a4CqdyqSeIQzh/xf56Z7QFqL2my5wQQKQ2pXrrgKMZrjSJq4mV2rXtrkofcXWheSFw6Go/E0Rq/AagMCD+seET44EaKzN++hfyGR9Pgj8dUicFVYkdJ5aKw5FNWr3J4xRIjmOm9Jk0fKM5TEyNez38y26A8FCxg0x/HMkkKx3UQIvx3vyyWKA/LQF8oXYPrmDkd6+t3otmKcB9iFBkvp7uLinUuTBVaZULjIqdJpj3WKujBXwpTiDwDhWkKvJXiXZUw2HdVZX3XuTuJEFsnX6zk33yETDwa1Vna45jpvZzw8qmHTeq7VXf5LyYqZaYfDTEtaDXxjuWiSK296L+GA2P5mYmnuNnWM4573NOjPTmMv2YTyU+x+adhjP0A84blE8jxKlw3XD+oOKwrahxB7US0UKABVmRPVaZYkpWe4FFZ7BeMwHlMu0r
X-MS-Exchange-AntiSpam-MessageData: Y89sUM8/4xNzyYXaYv3Z4kh5ZBmvSUiNdLz734NPa4jopq3k0CvjLitLeC34Rbd+aOqA/ugLWakD05zNRW0RK51fuAZeQzcUUS3+uQXeBuh/6rHer0tYCgSNMt7jJvDO4tIdc7cwIw/FrlkW0I5i3VoyMJt7Ub8GbqERxVIFP2ey8DRb1A+phlpMdVcnQv1H
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c844c87-8f07-433b-6e35-08d7cc80400e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 03:39:10.3820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3AWy4Rei6ZN9SCKYIKuZ6SWo5cZU4XhgMZUXodFR+JhGxYB2kHP/i3wXuSZN0MAv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3868
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_10:2020-03-19,2020-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=988 malwarescore=0 phishscore=0 spamscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003200014
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/19/20 4:50 PM, Martin KaFai Lau wrote:
> This patch adds bpf_sk_storage_get() and bpf_sk_storage_delete()
> helper to the bpf_tcp_ca's struct_ops.  That would allow
> bpf-tcp-cc to:
> 1) share sk private data with other bpf progs.
> 2) use bpf_sk_storage as a private storage for a bpf-tcp-cc
>     if the existing icsk_ca_priv is not big enough.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
