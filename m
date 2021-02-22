Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7D8321FAD
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhBVTIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:08:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23674 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232803AbhBVTHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 14:07:00 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11MJ5beV002962;
        Mon, 22 Feb 2021 11:05:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=bIjmbD7CgVzeWjFksYh5D3bCXwEke22YkL6iZYDtzn4=;
 b=N76IL23hhIyFsvmm3qRIqs6V/1ZOiHYiMXhOBQ2Y16HJqTkMR5BUPLylE/Zb2sXYsXzI
 /Dq8wAWhaMcH7AxcJ6dx2eaL4boU1mkrBF9rYqPb/Y+SD4rPW0HT1XlHM8FuGf30Hv4F
 VM+uMloVn2Osj15/JVKTYrKS5Zjw33iCnf8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36u0tu9phs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 22 Feb 2021 11:05:56 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Feb 2021 11:05:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ll0tUejNf/HeLxxgM9YYgVB32WviWDyFNY/eyRgTxRqX60LbOSRhhFsAo8LaJCHBr9wpoNH3iIh3kLJhR8TSUPMi9FTp8q8VCPTwIUHWHL9k6wRiqcFgu25BPKQDgHMeZavVOHi0oCHwVizA9QX4OEOsJQbPehA+7Q8zbSAXiR5WoiKtJ/p5tw7FRVemHeqXyZ9da9EzzROb4+x1V7ts3c5syJw3zOLWUTNQgAdOYaO4bqf+Mjuh3tyLWplklTUVV7mpcicvPMe1YNHqM0NLWDyOT2etkSKQDObQeM5jqAmq96neym2QHdDDbQe7gnQLWOEhoxUMbAXLaR4VAjpY2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIjmbD7CgVzeWjFksYh5D3bCXwEke22YkL6iZYDtzn4=;
 b=P29bAYsrXzaecSHKQ0hSr5NxfiCUPUE8AKCNMdXIflj9FJcfDqX6iRtRsQD34oEnmJDxgjl5K3athsfDWDGI4FKd2odjsgCkUchLFpEgizIZq15ykwxDIDlA4Ze5Meht/kxbGDjt1T12j0FsY6e8AlKVbvn9dvvvxVis8gJIzUwvwK1EPIw/TFzUAjgFMqcQCDeGqOuHYHcIbsw3hjtMBXXvDYQ4X/KtZ8EvbETELIRVSfCUd+BXPu9v9pO9NdBOCHsvfI6w+RDjxM5x0XRyNtwPVVeoYEVaESQD4JF3Y5kVn5//Cnd4YLlPKJVu0skalAZBZgXw0KS8MfJBLCWDIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4488.namprd15.prod.outlook.com (2603:10b6:a03:375::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Mon, 22 Feb
 2021 19:05:54 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3868.032; Mon, 22 Feb 2021
 19:05:54 +0000
Date:   Mon, 22 Feb 2021 11:05:49 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     grantseltzer <grantseltzer@gmail.com>
CC:     <andrii@kernel.org>, <daniel@iogearbox.net>,
        <songliubraving@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <irogers@google.com>, <yhs@fb.com>,
        <tklauser@distanz.ch>, <netdev@vger.kernel.org>,
        <mrostecki@opensuse.org>, <ast@kernel.org>,
        <quentin@isovalent.com>, <bpf@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next] Add CONFIG_DEBUG_INFO_BTF check to bpftool
 feature command
Message-ID: <20210222190549.nqeh2dabl26omnm3@kafai-mbp.dhcp.thefacebook.com>
References: <20210220171307.128382-1-grantseltzer@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210220171307.128382-1-grantseltzer@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:daf9]
X-ClientProxiedBy: MWHPR18CA0045.namprd18.prod.outlook.com
 (2603:10b6:320:31::31) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:daf9) by MWHPR18CA0045.namprd18.prod.outlook.com (2603:10b6:320:31::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Mon, 22 Feb 2021 19:05:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: befc83f7-6b78-4d7a-281a-08d8d764e05b
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4488:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4488D69F55ADB2E881A73F68D5819@SJ0PR15MB4488.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7dJ4stl1oqjbTJChPQ+zK5zxJgbvvjN1vRsCFjU67NbbDwNBpGToXlO/62d98Kei4Hl/XnQRGkfDNKH/kyG4RiRNGdWpzbMok2RG/a31rCD1qoW9UORUdRI3NT73OkiW0QR4rdKx40gVNBNgx+ssufUmEdHOg+SHdzjJCkJKjgnUCI169qCLrPbMb5qexC+nZdxr4fZoGAP2LJF12WS62UV3zOq14boVu+uGyYwhc03RXDWwhCQmbQ+jeAyvOpH/aSAQkWt14DANaEYkfXrf3H0RQ7DnFjEDsoojzOlhUqSsL3/BqK8wapp1nBC2RniVR90IudskSntwDarcNbNeCPMTlSEllJ9C6xq5GV8sOeX4UKOkRVkLidlQUwxVllFEWMcbMeS7yTCwPysOvIN+ODVxylG8L3EiA1H3zP+qxySXRRVFLHoJVy1mX5Hzj18iZLHPNoPOKXmbVMP2UndybIUgg4FXrAsuvDikRWze3mNBA8nf7F+R4+6DHGNc6pR7CU1eOmUOajNXphJ9buCsoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(346002)(39860400002)(8936002)(66556008)(9686003)(186003)(55016002)(4744005)(1076003)(16526019)(2906002)(316002)(66946007)(478600001)(8676002)(4326008)(66476007)(83380400001)(7696005)(6506007)(52116002)(6916009)(7416002)(5660300002)(6666004)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jqhcR5xYXBdqbAcWdc9izXM1bdnRECxjyWglFW4zzVNcS0Y0ofualM8qCCIE?=
 =?us-ascii?Q?RP8x25XSIIkrngO2VdAwrmQh5XaWq4vfH7ePx7RxZ5oKp6Z8QcZ3p0GJn03L?=
 =?us-ascii?Q?cW3hJOHkr0qZ17IDDKFwSrMJVBwwWRIXcvOrVyngx1c7XavaTstuexQbTiTO?=
 =?us-ascii?Q?RrMBFUfK2KtvynbLuL8Lcx5bZjdSoTaLKeMTvHxcDnT8skEShIZqLxFJvqSf?=
 =?us-ascii?Q?M6QxeIf2vKFPtYS3MrocbMba+yAnMjwOU6D4MpCWRPRNIrTj6z3BizQMgm1x?=
 =?us-ascii?Q?E2rIC45y38UtN6LcG/LPBlJ5a9Cs5prypvPNWr6YGAn+rrQGoz5OwHc1+7bF?=
 =?us-ascii?Q?bBhF/JkghoN7aJQNcThqv1zF3NpHIzxYhxHYugtOlylX/FkmZiU1zWABraES?=
 =?us-ascii?Q?vhgXIpfn1UekUY1gNqdtuiq1YXdC47RDfnzUt/myfEG3y/oUdtujIGnJvljb?=
 =?us-ascii?Q?FYcKihonKO93Rq/UpNVRitMKCqs4+IoOahfu8qkscrAyu+B1vVCcT7/zhIio?=
 =?us-ascii?Q?FH+Q5cNaufh1zvyPL0dasQesyZmZf5H+yeipS65P0/gpaf/pD3tf0bDZ58wT?=
 =?us-ascii?Q?ExT3kDByUPMK1vi03JWyYoyugGFRy5/kXDZB4LorkWxAj1f7zJ5INk2hb8Cb?=
 =?us-ascii?Q?800RTSBN3B+Z3l9GlvXyPQEmVyjgiw1oIGUFrelK+WcXuqEQeWeohB2EShRS?=
 =?us-ascii?Q?dTrMLH6zesfBY2ED39ALOGN1ApOy1PnO4W+6v976KCJEqbmyRvHIrlypLfBo?=
 =?us-ascii?Q?NGE5Qvkcp/bKwEvU3G4WrhoErXCvom6l+/uKR2g27CzGVx2S8omCEM/iPnE9?=
 =?us-ascii?Q?RxZgnrQQAaCg7/oK2GWzkzqsRdjF+jg4b7qxm037cTV2Lsp+7VqYOzipiP3L?=
 =?us-ascii?Q?fSyJ2NZOlYstVDHewnsA9Ia6OOQviqA/tsbhap35XWVNlCE+qgpw0E586Nb9?=
 =?us-ascii?Q?eXWedPfF6FRNpyrEKwo+w9DNou3z9VTUMycPyLxZr/VJ9dCn9yhUx1zxJvzv?=
 =?us-ascii?Q?TB780tMCRfU61d7UhEyczjG/o+jUL1i99Qsg4U3li4FylDFboUxmCeGkGt3P?=
 =?us-ascii?Q?6YcRr45DtfXaKX9K5Q0j05Qm9366g5Ga/9Z+7vkJvCZF8n80v6mRmOQRhiWo?=
 =?us-ascii?Q?FFzdZ7NquQ5ZXx3IFJ0o8jcCob7JWaQcQyN+in2IRJcES9h5SX1/XTy+Xn3E?=
 =?us-ascii?Q?bZnwG7MtrHbfWIjxnLYY/pXESLbsVzhYf8+faqSs04YHd0DigQe3BzJBfa/q?=
 =?us-ascii?Q?o8uI2jA5mvvCr61Q/i6QophciJ1QRJu0fOO4NqJty6Glw9jGKm1Z+3xfBAYc?=
 =?us-ascii?Q?UW5E5E96eguoOSXWZAXIz8EIrV57EDvPCPhSGcpWUbyTvA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: befc83f7-6b78-4d7a-281a-08d8d764e05b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2021 19:05:53.8884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: psoxg7FZWondOubKQ1j5kGZugC0IAOz0KMb+/q7JUsa2yYMn06Sh5xw1wk6wLW6Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4488
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_06:2021-02-22,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 mlxscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102220168
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 05:13:07PM +0000, grantseltzer wrote:
> This adds the CONFIG_DEBUG_INFO_BTF kernel compile option to output of
> the bpftool feature command. This is relevant for developers that want
> to use libbpf to account for data structure definition differences
> between kernels.
Acked-by: Martin KaFai Lau <kafai@fb.com>
