Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D21827BC7C
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 07:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgI2Ffv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 01:35:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33404 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725300AbgI2Ffu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 01:35:50 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T5UQZg025499;
        Mon, 28 Sep 2020 22:35:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Xw7Lxul/xCI52UGviK9+Nd/Vv/QbVESIt10e+s622Ss=;
 b=kQwxMoJMMSvfXTSzGccjfm1I2+fqr6O8h9cK7zPwjTOpizcAEcOZtgHGUhZmgw3GhiZL
 aOyxcIO6Zk8EaCuV+alsb5U7zEidqs5bORmeemeKxwvhqQljrA8v4qzNdhZ7b+MeDOZD
 tfESNEZIUmLOy/xGL1Nhe0hhiqi+bSJFpbY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33tnq48ky5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 28 Sep 2020 22:35:34 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 28 Sep 2020 22:35:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ug95FAcPjGC+UGSOuDh7qVe+RIJDrzYk+WkurE4QzWG/NJkRgimxCYtVUlOCEl8P/MWci/fTINLMevFbZNj0NaxFn7Ue3WsjlaS+MKs8Jn4dr4JlmZ9QxdkMLy7wlPT19WrU4CD0rp/42/XVgWPa7J2i4nsRMnKYfz+kVEYZ5uJ6Va9DdARduOqrpqzJDk61c6JpMBr4o2p0P6ZXD0K2RPoqip2vcYc1dlOxo0OsDWHMdszTvtovay3cbgcILAf/PM3ElwZfEOBM6YT6UtuQLYdqTN20idpEsLacVcjavYmvLhOdpRkLgRi7A9xTlN6+DNWuWSUpPIRs0Ogm+up80Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xw7Lxul/xCI52UGviK9+Nd/Vv/QbVESIt10e+s622Ss=;
 b=MT0avZP7Ttv25bTufYVyF75XLMHcq+q+XZ519q/vojtLOpvMHi3K6OLaHYEj4L3IWsrA8ilU0dKDx7Umyicu8wx1amfFE38R71WTvTHH6dGE/Ab2Q9lmvhVcw0jABIjLkL4rzSvNXRpFGUlMIid9d2UsdZDhFyjd7yR8rc1gnb0BmOakDWTpNvUnxrRob0WELlo0kI0NhvLoNdKu9YIdtkTJc4+37wBQorHD2UmwDgS64EmNpQb3TRaU45192O9DuV2IQL4UBiOIEc4XHtIlx97FML/ZiuD+K52UhyWw+45HbAWRLOLp82Gxe+vYG9X7KQDZbFo6PGf3grSVrBsVpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xw7Lxul/xCI52UGviK9+Nd/Vv/QbVESIt10e+s622Ss=;
 b=Z3OGDjfp0lKEFic2hXhsmNYtpg3ptdv6on9LcUibuYjYhN29FLoVqXsBJvWDl84WjSPVyjm9X3hD/oHb+QJS2PDKjMMGC36oNgHAwkAq0+TNfDY5SPnXLJzOnqNo9jDzruGQCv/O2kbxKgUiD8E8NbizjBWlQWMs2Hb41LOjwrs=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3255.namprd15.prod.outlook.com (2603:10b6:a03:107::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Tue, 29 Sep
 2020 05:35:32 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 05:35:32 +0000
Date:   Mon, 28 Sep 2020 22:35:25 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@cloudflare.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 1/4] bpf: sockmap: enable map_update_elem
 from bpf_iter
Message-ID: <20200929053525.aje3oavmcrbzmo34@kafai-mbp>
References: <20200928090805.23343-1-lmb@cloudflare.com>
 <20200928090805.23343-2-lmb@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928090805.23343-2-lmb@cloudflare.com>
X-Originating-IP: [2620:10d:c090:400::5:d609]
X-ClientProxiedBy: MWHPR15CA0038.namprd15.prod.outlook.com
 (2603:10b6:300:ad::24) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:d609) by MWHPR15CA0038.namprd15.prod.outlook.com (2603:10b6:300:ad::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Tue, 29 Sep 2020 05:35:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 722cc334-f5d6-4771-d8b1-08d864397baf
X-MS-TrafficTypeDiagnostic: BYAPR15MB3255:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3255D2A20950082BBE65F371D5320@BYAPR15MB3255.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cPG1E/8a0qGbFkD7AgI2hOu3TIHfqzqsfBMFA6cohcFEijwBn6oy7U55HRedr3Ma9p7iMDlbyNamut/N1DQ5MpcDBCCvswaNMeKE3mkhYIQ3QjJnrdAOE6JPq5/XEJWJbR7HZu6IO35uCZJEC9fmXgtnXBNE2yrkelEqLEHtO5G9oEPoFPStJKujf/oe5ekC7VjvHe1xoScwIhap72g5iaNgXFAlcLmGU8Krw9hBNgrJdSal/Z2BeQds5KjR+TubvZd5ZToifZOnWoZ3ZbphkqReBlJGE6IOoIfBX2Y7pEdTk0Tx6xJW8zPyHZ18dPWyRZOeGSECeHhILp8wqWZ5B0+XON2Q8X6pkWnpZLmm4Bc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(136003)(396003)(39860400002)(16526019)(52116002)(186003)(7416002)(6666004)(6496006)(316002)(1076003)(54906003)(4744005)(4326008)(5660300002)(2906002)(86362001)(8676002)(478600001)(8936002)(55016002)(66946007)(66556008)(6916009)(33716001)(83380400001)(66476007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: u6zDlN19bw+9PdGMPn4cz9zGQ3o85UafYnuILddcAl8spmzoY8ON4o5izeBYvyQsEVL9TFy/VWSsN+IB1ybz1BkIKbMJ+/QoMjLB1wk4t5U/3R2/mc7mMDoNF2FP5Y+hI3AVd/KesSAH9hkZ1hHVgXNWy5UTIxWD5tOtY5Ski40AlcWV8Z59Q0yWOP99tD2GOYaIetdr0AvsA4bczb/LonsRFyNeeXqYBubpWEoOeQzSx52x66PLgqRY0t7sphM9CNMkxerP6NvMWqI2j2R1UaQLSwlM6u8/4juCyzGujcrhCCxG+J846oSgaF4GJrEYVPkBoK4F3J8l+dFL2kYZGOkoJFVHEt9PCxgXgMtPSKBZXh0ApJ08mGWQskiG2okDYsDCMrLYl45XqGm4Bhhp0oogquZFAgNdNiPTxLPbt8sEV44OZJhJB4KEi9E8SIde62094z5ag2QtVjp9SnRmLfiWDs5BHA7sphT5316bfMMNR4FmCTkB1HbI1qgOYizyQNg4qRYIl3oUs1aq9+QJxqkB705whblmxc84XI3hbB8hTucN6fBo/LLeipPTHeGSm3my0QvvtvSLVRSNAud6ZV0y8m2mSLe03xjkVCwMdAfq0KgbwrRtdG7a6tm/n+avo0dmPWDyHYR9pINw85KmPCGHv51LsD2JUmcVdYWgzno=
X-MS-Exchange-CrossTenant-Network-Message-Id: 722cc334-f5d6-4771-d8b1-08d864397baf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 05:35:32.6968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfRlS+DW9vNKhcvYxJINPdbJs12BvZylOfyM375bxw/kedV4Quw305F8pTMjgsOZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3255
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-28,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 lowpriorityscore=0 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=843
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290054
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 10:08:02AM +0100, Lorenz Bauer wrote:
> Allow passing a pointer to a BTF struct sock_common* when updating
> a sockmap or sockhash. Since BTF pointers can fault and therefore be
> NULL at runtime we need to add an additional !sk check to
> sock_map_update_elem. Since we may be passed a request or timewait
> socket we also need to check sk_fullsock. Doing this allows calling
> map_update_elem on sockmap from bpf_iter context, which uses
> BTF pointers.
Acked-by: Martin KaFai Lau <kafai@fb.com>
