Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB5226AE64
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgIOUFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:05:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55574 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727824AbgIOUEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:04:43 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FK0eHK021233;
        Tue, 15 Sep 2020 13:04:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=kLsXGsKCJKRDqltufQlJY3YUwzZsuoY/yt7txIPgwyA=;
 b=TyEmCk36jBGIP3l0MOTwXneqjNcW6YPPK+JLKf+k+ngU1C7lGB/pQiuNd/p/nYcGcldw
 JY5zo7NhCKN4zV5iatKT+GnSdMQuYgtdQ6QVmqXXy2trPuux8eOyXifon2l34XLTMaQf
 nn6AjHGkhcBJBxe3TPB6ME7u0GpLtf3EoPI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33k3acrbag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Sep 2020 13:04:28 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 13:04:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfdTWOsDhKnwcSSk8s7oqZ3NUhth2FC8b92yR70P/QyZwyH+Kqw67DkiiCbQEPDbJfQ5k9P3Rp9G3uzWwMKH0rHNWnuYKVE4o4c+rnFzfFmhPnzQ1D/HYnGyPUsA/Ubbdu1IZ/gkhBlyRN6XzecoeFsT9FMHe1RCJe86GoiVvSm0KbEWwsNPtj9dBEfrt+d3qDIXgcxAj265JhZ0OdSu62HbbGW6XWW1KtOD3a5hIb+lTYdm8yGTradMaUDHIHJsG5Q219j9pBvzwiThcPeOF6GkZ5NTe4ma81ijJ20SCh6PbLiA8CGLQGrXdMydOLWQjJok8Jww+3yAFmy9z1yn/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLsXGsKCJKRDqltufQlJY3YUwzZsuoY/yt7txIPgwyA=;
 b=A8LOlqMsXz+SIerYNVNyEEUlpeim3qRvXAEeSXz2a4DH8JgktQTdJl5JFemBZs3sXDRKSIi5okiDK0vy6BpAyuW+GJBDSM6ZIAHvQI8jvgpv8+NE5DFIf2jFAIIFFfOQOim/lZMdGk1L4dhA/GxsJQ0+68LNUvecmjmRw4vw6+Dtgqzh4ZaGZ55iHlxUR6kH8DfOndzm0nr5ZXqjSm2ovZGDI/2zWM9gGdJvv6Seij9yJn33FS/e+ccgxYO3caYpDWvMi+kBo9aVvfrCgjvlrvTaMyON+VTRNMs23HiVHyZzUJjm1Swq/fUzr1/DeyYsc79Oylx569xVMsYBExpTOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLsXGsKCJKRDqltufQlJY3YUwzZsuoY/yt7txIPgwyA=;
 b=GoumPolcxTW5ebIGJJik0o8Ymfa8K0QnunUXi0ZlkIp1NZGU14tTCOpZLXlpFHbElzjgv1mVfbrlb4r+JAHRlzmLl7TZBIflspGE/2tmsSZa31i8KPUYP8B80J2dxTjY+CGWYyqOwROwxx0j2GzOYjPzWwg3HXgArVxV+eRDpNY=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3047.namprd15.prod.outlook.com (2603:10b6:a03:f8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 20:04:25 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 20:04:24 +0000
Date:   Tue, 15 Sep 2020 13:04:18 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf: bpf_skc_to_* casting helpers require a NULL
 check on sk
Message-ID: <20200915200418.pjtenydbspik2kzb@kafai-mbp>
References: <20200915182959.241101-1-kafai@fb.com>
 <5c3d74e4-a743-38c5-64ed-1cb8a6ed2a6c@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c3d74e4-a743-38c5-64ed-1cb8a6ed2a6c@fb.com>
X-ClientProxiedBy: MWHPR18CA0067.namprd18.prod.outlook.com
 (2603:10b6:300:39::29) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:30e3) by MWHPR18CA0067.namprd18.prod.outlook.com (2603:10b6:300:39::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 20:04:24 +0000
X-Originating-IP: [2620:10d:c090:400::5:30e3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f995a65a-c513-41ca-580c-08d859b28b17
X-MS-TrafficTypeDiagnostic: BYAPR15MB3047:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3047AD426C81D9060141A282D5200@BYAPR15MB3047.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zasfO6UqXsAN2QUwy59G+NiVybBIR3uURCUB1BGEOwnaaEAqezIO/OhBnKH05DjyPwQ8LANr4FHOACoYgJL4I9axBLWkqcxyzz8MYqP7urO5iYsBDt3C2meMYn7KVDV6VQpPNeHxRcMCCqCdc1b4kxeqay8s/dbJ5OdQMLq+pUf21WnJo/BPWkJpH/gc433du5M1C0JPZmGkF1Bpz8IEYugx3mzXBg3WMTgqCQPxRz2FilL2tq6VHM5jvaCGbY8bw88lGYOJ/J0bj0qVXVhpXcLWFTAX7OVeK+O3N1fmdgjv97pWAamf98QVfcSY/Dct
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(346002)(136003)(39860400002)(6862004)(52116002)(478600001)(86362001)(2906002)(6666004)(66556008)(66476007)(8936002)(66946007)(1076003)(6496006)(4744005)(6636002)(54906003)(5660300002)(316002)(33716001)(4326008)(53546011)(55016002)(16526019)(83380400001)(9686003)(186003)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: HGwrQI+gl1/wrJ8bWGtPJJlgpPm99FNJV9lcyOnuQ4Yw2ryI2zr6Lc1H62P0F8qbsCmfzTmmur92/5x3flyWhyWOyVB3FGF5M4gMR0K9etCUEgCoRGaIzn6mPzVdHCWc4b9yqoVJZeMcbr0H5UBnCoevsUqIZY3XfnNlM6QJuT+hstgWavYW/GzLlp7NNTQslcIl25o8pu6UKaa7XpGf5Orh7x1RPJ+HJHFhYqj3Yam8QYl7rN2Qzg0jaEmBD5CWq6PP3xcBYdI0xiUigi9kNc+6EI+Hly6U+pQN8TxlkQJpKeNo/13+Ej04MGnWliRQ2JuMcylI/EOWC4AqBtIYVbg9KqaX84OWbW/gHPNKCLuNJrt/P6EPgs5K8HrNhZcqHcFh8kgvVwMIWZye78rGCfxWSd2Du0P0M6AG4DTNbQqsfg5r8S423KNipCfRtIHH03W7MdkvUFLXEt0p78p355Gxx3AXbpU9BhYVd818fwo+mO+yIDSBseErPnqeiRuAfHxGDW/bAgl1kU4BrGa0LahV5Fca/PbFbnTVOrNXfYQPHVGFC9ncEPPoeoisghj8MeF+pDVNLwItmTkqvEySxF1ITIjqumLYJRhp2fENBnnnhCTNLAwnC6QunNqWPxxn0qXpSQQlM6ll5JVcEKEjwwMce16kLtc7DNJvy8LhAwx4Nhm4N5bRZzbY5TyQ2i0p
X-MS-Exchange-CrossTenant-Network-Message-Id: f995a65a-c513-41ca-580c-08d859b28b17
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 20:04:24.7557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5QSIiIZ9/lTDhv7gkpRbX9mElNk8trgscztFN1xZ0s+bk1E1fVSnpR6DHQHokV8d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3047
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_13:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=788
 lowpriorityscore=0 clxscore=1015 adultscore=0 suspectscore=1 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 11:58:01AM -0700, Yonghong Song wrote:
> 
> 
> On 9/15/20 11:29 AM, Martin KaFai Lau wrote:
> > The bpf_skc_to_* type casting helpers are available to
> > BPF_PROG_TYPE_TRACING.  The traced PTR_TO_BTF_ID may be NULL.
> > For example, the skb->sk may be NULL.  Thus, these casting helpers
> > need to check "!sk" also and this patch fixes them.
> > 
> > Fixes: 0d4fad3e57df ("bpf: Add bpf_skc_to_udp6_sock() helper")
> > Fixes: 478cfbdf5f13 ("bpf: Add bpf_skc_to_{tcp, tcp_timewait, tcp_request}_sock() helpers")
> > Fixes: af7ec1383361 ("bpf: Add bpf_skc_to_tcp6_sock() helper")
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> 
> Thanks for the fix!
> 
> Acked-by: Yonghong Song <yhs@fb.com>
Thanks for the review.  A follow up question.
Is PTR_TO_BTF_ID_OR_NULL still needed?
