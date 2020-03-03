Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB1D177AE7
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbgCCPrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:47:33 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2732 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728291AbgCCPrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:47:33 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 023FYpT6020481;
        Tue, 3 Mar 2020 07:47:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=t4vNZDvqrEnZjBSQxeEPL7GH/BcSPq8YhKEni6uqzpE=;
 b=XeNk9NbvNDn53dj/AdIkB5l4CKviLtYbz6MFliYDDjvgJpgOkcSaMTPBOSHhOLr0rb7l
 R/Kc8GfCE7QJFRT0ptU35FZYBqJ/32ZeKO6CKoIh6XLzLgWEKZ1A8Wu0lxzMr4T9qA0g
 K6Fd8RBw6+LE/dFJ05zMcZpQ5G4CG9MvC9g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yhpfwh4ys-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 03 Mar 2020 07:47:19 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 3 Mar 2020 07:47:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOYRuQXTWEzEtlE74v5V6rLtsvYhjSreNfDUtPI3RBhggix42ueCht3plDC9Oxz+baa+rsMV6mKFtJ/FefvSDEU6tt57BJldfIhCfoKZQkO42uTfbZpHKYAwcswkeRDwH/90qZczdY60KzAj1pVrgWAVMj2k/zgBCydKR4qwC7320OmT2HtXRp8stdXGFCRybNOyrBui8nVnur8qvE6ibXPOWscnpavDKp8e51wyZki2LZVEadWa0w65uwq+9FJzSRTCMmM4FFVIPIpZ//Z1NgorLyxH49+TgWNUS5AJiCvRGyNt+zm0Iwg3R+P9MoXYo1lGag/UWJ6jU0yp/HS79g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4vNZDvqrEnZjBSQxeEPL7GH/BcSPq8YhKEni6uqzpE=;
 b=fEN3OnfOr58haJuAlwlz6HjOvGz4+w51seo9PF/o+O8tqKv2eyqANShAiiikrCNCgbEF0dZRVSTCmxIRSJ+IjhNhc31vLOW/8FbsBg5eSFIRNLK5lHB4eDmB0Rk8uItm/TpQnA5h0+dOloRjRhZSXH1IYUKHN1XAb6v3DsuDU3Xw7dPfmnHLxvOGJ9Iry4b9fuz7QM2Gzsse/3BQ8qtjz5p/elYoekyw88Kjw/2wEPsE4QTiTjwT4bYoucPn0gWRxpk6GfE9WSjwbfGCg5op4Z6XxbciUekgGkyn9KDVEcTo/wpDxmarPGsud15GBZIewgzk7KTgzUz6s1NvZMlWRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4vNZDvqrEnZjBSQxeEPL7GH/BcSPq8YhKEni6uqzpE=;
 b=BcURt7ifY5HAUGNKROKbeCvo0cXr2o1Vg+ahHAZFCeYiIBVqEJX0GUXw9fN+Pex3gTa/p7cXkua/bPW5EI3+NvlmG5Zs3V4Ja5e3Tb+UF0HSX4APrkseS2BSONPsO6kSedC88rQ3zOYbJ/l6SwCuk8xUpFwUkt5oMFhj4/aK1Fc=
Received: from BYAPR15MB2232.namprd15.prod.outlook.com (2603:10b6:a02:89::31)
 by BYAPR15MB2263.namprd15.prod.outlook.com (2603:10b6:a02:87::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Tue, 3 Mar
 2020 15:46:58 +0000
Received: from BYAPR15MB2232.namprd15.prod.outlook.com
 ([fe80::6536:60f4:3846:e5c0]) by BYAPR15MB2232.namprd15.prod.outlook.com
 ([fe80::6536:60f4:3846:e5c0%5]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 15:46:58 +0000
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
References: <20200228223948.360936-1-andriin@fb.com> <87mu8zt6a8.fsf@toke.dk>
 <CAEf4BzZGn9FcUdEOSR_ouqSNvzY2AdJA=8ffMV5mTmJQS-10VA@mail.gmail.com>
 <87imjms8cm.fsf@toke.dk> <094a8c0f-d781-d2a2-d4cd-721b20d75edd@iogearbox.net>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <e9a4351a-4cf9-120a-1ae1-94a707a6217f@fb.com>
Date:   Tue, 3 Mar 2020 07:46:54 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <094a8c0f-d781-d2a2-d4cd-721b20d75edd@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0124.namprd04.prod.outlook.com
 (2603:10b6:104:7::26) To BYAPR15MB2232.namprd15.prod.outlook.com
 (2603:10b6:a02:89::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1252] (2620:10d:c090:400::5:88bb) by CO2PR04CA0124.namprd04.prod.outlook.com (2603:10b6:104:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18 via Frontend Transport; Tue, 3 Mar 2020 15:46:57 +0000
X-Originating-IP: [2620:10d:c090:400::5:88bb]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e76e313-6fcd-414b-fc6b-08d7bf8a1b8c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB22635FEC011342657D67F98CD7E40@BYAPR15MB2263.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(346002)(396003)(189003)(199004)(54906003)(110136005)(52116002)(31686004)(316002)(53546011)(31696002)(86362001)(6486002)(8936002)(6666004)(36756003)(8676002)(81166006)(81156014)(4326008)(16526019)(2616005)(5660300002)(2906002)(66476007)(186003)(478600001)(66556008)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2263;H:BYAPR15MB2232.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YGqXw1ck5JpRLiqUT0rsZHYY5Ukc8/alGLzz3RjOQrO29Cw/M7PXP4tIND97Q6dFat5p8jUx/t40GoyUO0lYYiAGxPqOK0QG10QPqIJWzEK3ySz/8hrD2pkC3sdGZhuEJUKXi2CItDn27d1lKGUK8VTzUIeYvz2yPcsrVTvYun//YE/QbstaRWwKUYTOP56f3QcRi6imCFDJPbzSvRUe9TcPAAer55OArLxstU0n0DzVK3+MD2IAK3ts0B89z8zhv8BJNIxtmPG8g8JMTfEM4AMxkJXFuJsNHYRs/XBcGwkUfdgxDbmxKLM//FD3j8+EEucM5A0WAGiasaR9Vr7jHhnM5XzSpRBNVqT4g2BabXopLic6kMzVKVrbQ6qc/1AC6RvoRz1sukkrLYApj8gCqW037LuOJQJdGDCpx+7kK5C5cQ9z0iE2/nVb65pz/YvX
X-MS-Exchange-AntiSpam-MessageData: KZDe1WP0dOGv3n2iQcP3hgi9Z4FTmCYMQxgn7s3GLK9QubBTmCZcrTPUh00cGIBUcFpxY/GJ79ajGxdzpv8ONn+Ty93cKMvMBN/R/AvX30qfXym/XQofL9aMED5o8ymgOGyZPm5O40ERDA6ATbdCiFHbhGPPQl9uCN1/Cnz/Zq5oTT2TdSfkrWKQ1HQiDK41
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e76e313-6fcd-414b-fc6b-08d7bf8a1b8c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 15:46:58.7079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5mLR0wJNPSTuEIvhhGkDTsxbeHXNjBdWLD3wRgg35IJUQcX3uAii/zUsqOTaxKZu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2263
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_05:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 clxscore=1011 priorityscore=1501 lowpriorityscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=730 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030113
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 12:12 AM, Daniel Borkmann wrote:
> 
> I can see the motivation for this abstraction in particular for tracing, 
> but given
> the goal of bpf_link is to formalize and make the various program 
> attachment types
> more uniform, how is this going to solve e.g. the tc/BPF case? There is 
> no guarantee
> that while you create a link with the prog attached to cls_bpf that 
> someone else is
> going to replace that qdisc underneath you, and hence you end up with 
> the same case
> as if you would have only pinned the program itself (and not a link). So 
> bpf_link
> then gives a wrong impression that something is still attached and 
> active while it
> is not. What is the plan for these types?


TC is not easy to handle, right, but I don't see a 'wrong impression' 
part. The link will keep the program attached to qdisc. The admin
may try to remove qdisc for netdev, but that's a separate issue.
Same thing with xdp. The link will keep xdp program attached,
but admin may do ifconfig down and no packets will be flowing.
Similar with cgroups. The link will keep prog attached to a cgroup,
but admin can still do rmdir and cgroup will be in 'dying' state.
In case of tracing there is no intermediate entity between programs
and the kernel. In case of networking there are layers.
Netdevs, qdiscs, etc. May be dev_hold is a way to go.
