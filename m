Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0338E28035C
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732609AbgJAP6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:58:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1872 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732119AbgJAP6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 11:58:43 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 091FeD1H007424;
        Thu, 1 Oct 2020 08:58:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=jLuo1kJMaiwsSBn+ChwUkDkDNiltsFvKAuR+6U17oVE=;
 b=MYWKKaIrlv9qjCq6OkzBKP5NvuNy30ILL6FkUh9PXcec0NOZOA2l1KCL+esXbGHm0QJJ
 o+IluuxM6wAC2fDtPkavGRFY+kN8s+7D1ox2dqlj+Qjqilm8PDvkdkxtjAuvW84aVXPg
 ccevA+HXgF1KSkbnv1jYxHQusAEy7KRvI6U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 33w01t572u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 01 Oct 2020 08:58:27 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 08:57:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgkPWa02dq1uS5nn9KviZD0k6QM1heeedIhGx4B4bgQALUfXyegS2KV4GbhqFwUfq/zdGNSvWtAyHi6i39I9p5ARU0QABzzcu/zEmDgBclPfsrx5S1BdcEW9x28aneMhJPwgmNKDc4LdVkKBznus6nGCdJjOoSiGmYXwYSC+vHmk2BALRzn6fit/kK+kO4TpUcKz3vroxKbg7b/Myo4K5dw8hb+a642LGR09Rwl+X6A3XD4no6Ssyi5zWRyi+7gKiFrfMJq+SjWqpo2eq8zUCPRmZECPvaUAKfIynKr6iYvAsb45KyM+sewY8SsgLfvIhh/deRaDo+l3R7UKJVeYrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLuo1kJMaiwsSBn+ChwUkDkDNiltsFvKAuR+6U17oVE=;
 b=X5rImJZxGsr/eMJV0N8mMEGHfRH0t+6yoFSeKXWOZyq59tpbx8/joTHR+m+wBZ1C+vFohSzUkTnn2/xNw24zSGqTQyCWSOnm5I1aw4E9i1plbDmSSFTEGAqkTwgudFcGZsspws992oglQCabLUC8nQLu8ynSjMhKiKy1SaFGoYJLbLjKusl9ng9aJgIw907lUv5eZ5tG5vkDAuC1GR6Zdo3v4wzHZlMnl6p+zkJWSZzlpqh2mJ7M9m8wgy8ck8uc9ga2Y+mmYd2GEze0jBxJkgTmXnKeURHqjKkGxuQZnQUWpGBTFWSucsRqZki6teSWjLBjyVJ15KqAOHM1a6rhzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLuo1kJMaiwsSBn+ChwUkDkDNiltsFvKAuR+6U17oVE=;
 b=E5LfLwuE4lhZU2vfZ5a6zRYf6/f/98uQfwC1YKiV/LVlsh+ky0z2LD1AOSlawoZ2Ck4XdfpUExfU9Ux+iZoJBNJV0geBy5pMbaMqBVQjMWx2V2OgtwASDFTEYF4Y9DN0JRHBoYXXsEeuRdSIUJeYktY+ElHn2arxxNTg4igA6e8=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2646.namprd15.prod.outlook.com (2603:10b6:a03:155::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Thu, 1 Oct
 2020 15:57:48 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Thu, 1 Oct 2020
 15:57:48 +0000
Date:   Thu, 1 Oct 2020 08:57:42 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH bpf v3] bpf: fix "unresolved symbol" build error with
 resolve_btfids
Message-ID: <20201001155735.ruewjgrskwf536sd@kafai-mbp.dhcp.thefacebook.com>
References: <20201001051339.2549085-1-yhs@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001051339.2549085-1-yhs@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:f2d3]
X-ClientProxiedBy: MWHPR19CA0071.namprd19.prod.outlook.com
 (2603:10b6:300:94::33) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f2d3) by MWHPR19CA0071.namprd19.prod.outlook.com (2603:10b6:300:94::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Thu, 1 Oct 2020 15:57:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcba39a0-6b11-4a7a-0be3-08d86622be81
X-MS-TrafficTypeDiagnostic: BYAPR15MB2646:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2646D5EF338255A258906627D5300@BYAPR15MB2646.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LWkIFEa6u9D0JFLj6xtYxsugVPAFpOzJSf/khgJjKoEmzZelwayWlwYWJe87aO4CuztsNzPlUZl8An4uf8dvfXkckHQ2KFXZ1vgwvPLiBku7W4DsUK5/4xrXtvAgnXKpkntZtxzaCLIbqD+/Nh9d8agfN8M6bR3Iz2yE2K5Cmy7oOvIHapRhPEvo4zVO+GIWt0jLe8nmWM68N1giGBvmJy8gaF3KZFh4yPK3tGc5xVazUzgNPd4Qe9KO+Iqr53ztwq+kLsIWTTHdAMgFbwXLGVrofPLEXnCBAI34WAzPJRoMe7c+b6whjPcICz4MLb43c/9CKeqAEt0bA9zyYaczY3Q01NxpGD7qsSTNQol6x+rVj/6Phy0R/gqoSsyhdq3m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39860400002)(376002)(346002)(86362001)(316002)(66476007)(16526019)(9686003)(4326008)(83380400001)(186003)(66556008)(4744005)(55016002)(6862004)(54906003)(5660300002)(6636002)(2906002)(8936002)(478600001)(1076003)(6506007)(52116002)(7696005)(8676002)(6666004)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: PUQT0SfP3/tQeEhZGu9bNSXcjJInE61YXFpCEEsu0UioMTAkTli7b6xfHJZMq522elyWo/0w6eiY6w1c2Acq7hvEPVzCfu95xHRAJS52qR55PbbUCJk48lZkF9SyOrcUGwGC1k//ytmFCfBfehfr6NjzJsk60lNZfA6cY71qem3Ei3ZootiDvGaQu3soFtr0YENONts/Tw3cANvMaz71XDyOjXs7hRhyF3b7xSfty1IdMiGpIbvt63mKGkCviLSXBc355XwSRBdXtLu8f8T0I4d3Y8csQYxbXKodauTzz+sXyGXhwaEO06w6eiS3uGDSXHBhgKmbt8QVR8b/pY+Y7VFYovNGuNbSI8LnT8d9Cy94GXbx3MG39BiDhAtmgQX7PZQk2l5IDaWTQFqPRQR/r7QooM6tzpV3SidWemo1V6Rbs+Apur3MIq6UTtLf7Uq8Z5wtCH3O3t623Eg5ziPlZA46WC7im56LO+YejOxEgPV5jL5syk4WnFm3lA2UXJslpJVEdMIfioMvF+sSYg5IsS1zPMUd8+q2RjGxhixMLtlndZo61csxKqi9s8UMCI1Nw2meW5X7D6HwxooxQ+CCCmWO4w7FOKT2aNDue7F7VPXMYN0jrKEp/C1g5lsAew/MTuaTNCFn89vncccuj97Lk9ktlXDReKyKIRPWhImwPkdXPCwEwBT0i0ACeRhpPpmY
X-MS-Exchange-CrossTenant-Network-Message-Id: dcba39a0-6b11-4a7a-0be3-08d86622be81
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2020 15:57:48.7842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: apjdhTR3IDwIxfdLmTJ7od/F/IGkU+I/YR53IHKWEG4a/ZP4j2EG+Km7OoBDK62O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2646
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_05:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 10:13:39PM -0700, Yonghong Song wrote:
> Michal reported a build failure likes below:
>    BTFIDS  vmlinux
>    FAILED unresolved symbol tcp_timewait_sock
>    make[1]: *** [/.../linux-5.9-rc7/Makefile:1176: vmlinux] Error 255
> 
> This error can be triggered when config has CONFIG_NET enabled
> but CONFIG_INET disabled. In this case, there is no user of
> structs inet_timewait_sock and tcp_timewait_sock and hence vmlinux BTF
> types are not generated for these two structures.
> 
> To fix the problem, let us force BTF generation for these two
> structures with BTF_TYPE_EMIT.
Acked-by: Martin KaFai Lau <kafai@fb.com>
