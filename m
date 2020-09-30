Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBD627DD32
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 02:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgI3AB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 20:01:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59762 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728192AbgI3AB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 20:01:58 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TNs923021738;
        Tue, 29 Sep 2020 17:01:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=BJ9HS1a/iitULrsuwDH/MV1YKhb4d12f6LlZkgRhG0c=;
 b=IiyOfMSzhCpY5HUeo9W74tJXnpnDf5a9gUEzLRrq0/k70tkyjHBiLoR3/LJGe+/NjNU7
 lkho2kZqi3Sp6Cmu5Km7mp4pT8aVWfz1dlyZTDbcDsJM16eVAbfebhlIpyJPz08Q37V4
 n7/jmPIT5g1tX1QA/J5gWZQmQ+Ux1Co5bSY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33v1ndcaak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Sep 2020 17:01:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 17:01:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtbNcZSvsq85A996nKRPovKWlR7wlk6ogvPowycodWv04q+uLxjDdz09/whXAXGaKdYwKIS98X3B9ZHXfdfwU1b1jm2ZqgtDJzJLHVrRnxlKQd5B+1DJf8+U9kcKWmq2fhlzLFxz58N5yQp4WQLsZmdOAaeLlZT4mPyfHHwzRXDDrFMu3LNFxNbhDoMsgPJ5Xl+kKgRlbmir3bymCBXlhBKIyUaTZZrX8WfUUf6HxfYfO0OMb/IMlI+l7Pd7mbV5ToUma0vBU9g1C7F/laBeivMLckHfl5JAPFrys+3bp1ahE3LPnifqCMQ7zaBrK7qS46VrxcXLEtcRJovGVyImUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJ9HS1a/iitULrsuwDH/MV1YKhb4d12f6LlZkgRhG0c=;
 b=aVccwZwRDitG9xh9S1bG7W0eDbIIG8VX4184f9bIQOBt65l01P2K3v3s3oqu5tT2Gl5EyRva9h2SPwbpUIP0kps/boO07dGN7Et/ZSFvEt7EVypdtskla853fpScmw0F8LLSMvnZRPqZCA9Vo/cLUZrp7DFP2g0v9x8QAqqHSF8qlYWGm7n+vzq0H1EgsJD2PIHgUnaBxaZ3SrIcib2g1PLrEzNqb5yPh+SKg4s2UUKv/TAbbyDoDHdH0GZdggZ3Xk82v5RYRWQWn+/Xiye/CnGWt8NFlb2/ZmqHae9moZujSnOdNSuSLxuAEjCxZ1gkePVD3vxmTtLwTrzDxINI0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJ9HS1a/iitULrsuwDH/MV1YKhb4d12f6LlZkgRhG0c=;
 b=Puna+QztzpL8zjQt3gV7Pft1NeTOBX+j5nMFAht4z18l8Org4Sz9kxpccZ2jb1IkUX4j2r8Utue6aHh4wDC3VlR0BGY8vywL5ejzzRnMooNNIehsxmwA/PyBvKCKIPKdtwiZo0w8OTg6erk++mYZTE13skC3VL1IOCjnaz2sQcQ=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2952.namprd15.prod.outlook.com (2603:10b6:a03:f9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Wed, 30 Sep
 2020 00:01:43 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 00:01:43 +0000
Date:   Tue, 29 Sep 2020 17:01:36 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: fix uninitialized variable in
 btf_parse_type_sec
Message-ID: <20200930000136.vv2re5usqrlp2jcs@kafai-mbp.dhcp.thefacebook.com>
References: <20200929220604.833631-1-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929220604.833631-1-andriin@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:f2d3]
X-ClientProxiedBy: MWHPR14CA0033.namprd14.prod.outlook.com
 (2603:10b6:300:12b::19) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f2d3) by MWHPR14CA0033.namprd14.prod.outlook.com (2603:10b6:300:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Wed, 30 Sep 2020 00:01:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b614edd-fc69-497f-b47c-08d864d4039f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2952:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB29526930E05C2DAF78B73F41D5330@BYAPR15MB2952.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yiFqgSnO+n0OZ9p8E0Mq9AFwvKTIwNy7aSYdN32Lfj464QwK9zziUaO2rSXsDZFcpLEhBSOTKOCtAMdw2t5kF/NBbXTvvcFyUUnrGsp2VTqXrA3zEoOIl9HkEPIDOwaTllZO09whAXhorVtA0GIE6L72aUUPyrcHH2FOocILqym9QK19m5ZaiQmX6ulg11uOZ+ifj9lLSQwyBxlhCQsmmOzIdyZh3WQ6kri9F0SHcDmBywmb6QFPL12rHO9iQ+g6CRxP52+KpkWtjB/AbCQLNwDTP1N+L402G+KBuBd/fLxaKH9wuQs4e4HKeREjHWhK1+3X5B9cTRVhqzAhR2WQA0HGUpYGsmV/aLm9JtOwTf6ZNl9V25ZHaewc5pYVWLv7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(376002)(346002)(2906002)(8676002)(8936002)(6506007)(16526019)(186003)(9686003)(7696005)(52116002)(86362001)(6636002)(55016002)(6862004)(4326008)(558084003)(316002)(1076003)(66556008)(66476007)(478600001)(6666004)(66946007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: QIXELAjCsUEvOEqxMqkvLyPxr2grEMYRJWl+I8QcO33m31ajw0u3LxI8SZRq/musEEMBqJuW/O9Zug/QbZQd6V0XvYsU+bZ6JOzXrXR+Y0s6uVI17Au3H401SUy6gqRwhcagKcO6+t3oXBIjmQYBrYDja51fK++yOmH+Th+IWY++RAAHWsx7g/IpzFA110rIRa/P4i7S9Dv960+J8C1wKiV4eJ4M7TzCum5+FNJVyWXmSvF1OgO3WQHHLm5ISEcBS1lPGf6HT1zS+Sg+NfEJWYtpjGyoBr9yeIP5/VR2r8jda0xFwXkzNLEeRMYfH9qfXKErKMuHlZpchXrOAOPxkDqAYPn8abZzsaG/X+U8tSeQUjf45jDC9R5p1rPARRaDJ6VK2pCY6s5ntC6RRKx71r6G60nh4J5rnYpDqVPamdrEKIAkhr+Ytbsnb4MXFjrL5ScedMRqlOgXJ5fiTijYmeHm9thD/UsJvc/ZnnrQHuiq3ckYxBBH+geGP+YmJvmT4w65wwzes7x4QpX5F9ncjXSURYTrDAAJMh+B5zfr7Y6AYADazhrjxRfvJO48qngZNHjRJXAyfvBIOQrIj5Ak2jZWy1DGHIxCDYUbtyhkdM3ZxDlivhdaJH+FJp6dA+NnJdCGRoJeawHzBu9cBabYq46FzSGukbBdixzTWiH3CgU=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b614edd-fc69-497f-b47c-08d864d4039f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 00:01:43.2555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S15sx86zS0LGEQRwMuJWrWAhVpFnUSKsvu8WsfltMG64rnijhzONBRZAIA6K3fyg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2952
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 bulkscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=1 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290203
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 03:06:02PM -0700, Andrii Nakryiko wrote:
> Fix obvious unitialized variable use that wasn't reported by compiler. libbpf
> Makefile changes to catch such errors are added separately.
Acked-by: Martin KaFai Lau <kafai@fb.com>
