Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE5832B3E1
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840257AbhCCEHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:47 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49608 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239073AbhCCAq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 19:46:28 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1230SYNU004501;
        Tue, 2 Mar 2021 16:45:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=z4XlEuSXxYnuLkP50X4os/N/YmByvXC/XOj6eL3j2Q0=;
 b=SsRYjobRmZNSfJtQKsIYACuKzt6oewf/oyLGbEIZHlH+bjzXGJUOBIePBKJtun9PR6KL
 gThHYuckrvCoVyGqd/h8oxJpA+FhHqt8G6WUK/L4041i4pCstYbDFqTF7o9SkmflglDU
 ezPmHFwYrlPHg+aDm1UAagKphqmbgeeybSQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3706nnfa4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Mar 2021 16:45:22 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 2 Mar 2021 16:45:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bIFNGsBk+oorbOLxnlq/nABVHHrw950adoNH9o4Q5uODTbrw6mKym+T15rlOzD3mcYMeBgc7olPSTsPN8J9adBnvWxylDyZbTYfKBUuVXNPeZlgIn/bFMmbrdB2KjWozIfVPDH8U5oJ6PFHmuGqxlwRUuT0ESrBNJAV/tnkqMqESfFDldxyWvnH2iPn06YxI/vG3Z14knSjrUVd7kqZO+Ax5ncnriKxaZrmIyr1lfyNtV+MO8oheFlCyRIlcNmaWN2vR/XLmJcxMWgrKoictsnhpLXzKjxtsDnna0CpwhqXpl+L5BzsdrIBAogqdNurrRczQtrM9l/It3za/oVlHAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4XlEuSXxYnuLkP50X4os/N/YmByvXC/XOj6eL3j2Q0=;
 b=OVGcS4rSDicyGxcmCdcTAe+L5XX1TJMOOAoxtghosQOJK3Q2yw3UN67RW5ezu+31baYv3k4HBzOTXhV1odXfhICftjmCPo9asH+yYoABVVqytmQyI4zIKCKlYHDdqq1xSMSRAY4TBMflcp4Uq6m8w7QQPgXUFBDe/Qan6jvrVemNnUBR9m81kwKvcVyZnOPLj5ZFlTWYazhdZ9XWH/jKyXyJJKGVbWbPU3SUjU/v4lkELGDmIoMVj5nTvSLZrRWCcVOexV/oM/Z9ki6Dzpxo18tBLGfHyTp+Hco4+bZ4irulPe30c3V/GXuEveYBnD2ckVtfxcXMvrs60E0a2KbfdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2774.namprd15.prod.outlook.com (2603:10b6:a03:15d::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Wed, 3 Mar
 2021 00:45:20 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3890.028; Wed, 3 Mar 2021
 00:45:20 +0000
Date:   Tue, 2 Mar 2021 16:45:15 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] tools/runqslower: allow substituting custom
 vmlinux.h for the build
Message-ID: <20210303004515.vlik7z6cpulxtwmm@kafai-mbp.dhcp.thefacebook.com>
References: <20210303004010.653954-1-andrii@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210303004010.653954-1-andrii@kernel.org>
X-Originating-IP: [2620:10d:c090:400::5:11fd]
X-ClientProxiedBy: CO2PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:102:2::18) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:11fd) by CO2PR05CA0008.namprd05.prod.outlook.com (2603:10b6:102:2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Wed, 3 Mar 2021 00:45:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f27cf79-da33-4e24-7a3b-08d8dddd9ef3
X-MS-TrafficTypeDiagnostic: BYAPR15MB2774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB277478E45E4C2C42368CB320D5989@BYAPR15MB2774.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UjKn9w1ntZIX3IzfuV6MKRK/RK8dzvNOkIdF8NfHp2KZMSPsJl9fuWfnUjKO+sfNtmXY90aQOPEzdhcqwDdDahzjNCPLLsqoTrGU7pplQmncQ/1zDndupXNb+oiD0ALD9xA4osq6YokJKcRNLcmSNidkADoOZNJLC6odOtqbpllg+jYfYD9pqh/t1OwGHMObKBoNBrA260EoH9pfFt0Z+HTZgW7U3SpaNAqnaHVl+kFEKGH+0shNaUNeZ2iEZ8/PV+TXtJpq/cc2O08lrrMjuWEX8CFtNRQIBoEVzuxFlK5KOKqZJ2x/572LObmlYmjul80GWXOJuSCfOy3aQ3cohn3AZvn8UYT3+en2H1vIFE9mmnjP+b5nclwQ95Nzpo0vV4xEs+Wm9qh8224ysDIKScJrIjNB5zmMoZ8/Ix6P5pRUjnoe+o7fBpGGarDzUACujEI0g0F3GbIosdBSI2ccg90U92sg4FIFZt6orp21nn/Nrfjws5VN1UKzyI7Z+Lh1GCL2kK9kw93fxosnwf3SKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(366004)(136003)(4326008)(2906002)(8676002)(9686003)(5660300002)(316002)(55016002)(8936002)(6916009)(478600001)(6506007)(1076003)(66556008)(66946007)(66476007)(4744005)(7696005)(6666004)(86362001)(186003)(52116002)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5P05uWuPiTF3F/EtaiIvjcN2CYxtmiQGtaOjl6GYxu1j4ljMBd2eXrisMS1g?=
 =?us-ascii?Q?Ji0R357oqH8lYHj8itw5SpOyG5qTvMpx6BckrGv89TvviJArBqQNHxGQ75IC?=
 =?us-ascii?Q?OWV4Ic2xY4RdaFqG07alW4IBr4UvhgzyVehlKGOxNfghd5gI7xNxl+1cE0HN?=
 =?us-ascii?Q?eU3Udh5kBrIONre1blAHF0/Cl7q1PlTqyNtL2RPwcbKDZakoi/wwO06HxR1Z?=
 =?us-ascii?Q?JMEvuUB9RknRXLR5xrZP1f8dS2pyfq5G5rJ3ozCq2O9B1HA3nQFSmYxQYqXe?=
 =?us-ascii?Q?tx56cgCuBSWdyS5lSw+3WUKtu58EQHSdSRvq0FbVEPayGzen4wrVaxcC5wE2?=
 =?us-ascii?Q?EUaS9LKq4FyJZv63IQOKJlfNdcU25bItYU0va5lNxQtMlXn+lFpOMNA/Phzc?=
 =?us-ascii?Q?ZyWHqkJ8mGrf8VyzKo1aDTURBSG5qh8I6CdHW+fvvzmC5r4rlGogZsPrEUxo?=
 =?us-ascii?Q?ZZ6zmjA0ZDNVu4xH+oOASrWmmW4Jvz9uMkRWmqz3IKcmeYtzOaXBfnMBZdp+?=
 =?us-ascii?Q?ucSVM8Hnqd414Vu6iSv9/waLbjvWtY1FAFs+inKu9Wzg5MuenGo3Vni+BZ+s?=
 =?us-ascii?Q?qZ6GjYRSSw9f+oRh16dlC8v3aqMcC92m3FMY+ePrpIhtd3M1QQWoxFbAPuUa?=
 =?us-ascii?Q?JNSDmJMW1ULnxjBkBeIZ9OSxJjbMC8YRF5lJczBQC17ucqQa4AgCbbbCTwAl?=
 =?us-ascii?Q?w6yIiuf8pMjWdwqkl+zmTXPs9CAuqCtD5C/pwJjy0Nr5y5KpoTX+WzgvIgYE?=
 =?us-ascii?Q?YF/WM/FDL9NlToy3+qRotGxsEiXhY+pvniHFmZug7ao/yJUioK15Poj8shkU?=
 =?us-ascii?Q?OLGJSPW4jOL04QMxgWKREvkoCPugTPJpT09jD4TawQV3+RvxQmZBukhR+fFr?=
 =?us-ascii?Q?uLVMt2O89jDRwn/4828KeuYEAMpN9IZ8P5CPhEu7syG3GX+C9xDBKZ60ZMor?=
 =?us-ascii?Q?tNF6LN7E8InSM6CMa0hkjWtjL6Aja0ZAqzbI0yIJ2M0NLze1c/Bvad73OvJ/?=
 =?us-ascii?Q?TidXm1RfxSlLxoz/z9GK2jFMfQG91zomPmfY0nT679VOc+z40GbgjVj6N9Zk?=
 =?us-ascii?Q?lQNcRxv/MsvBNYg26GHzsp8FtMruK9CXvMIiziuAxqkrJXkHKXb11rDHIXiD?=
 =?us-ascii?Q?3QNV9vw30OAvLhKSIaSsKtdoLqzaaPtMGz5a+QNBJkQLCov79HkzAK0UWvMW?=
 =?us-ascii?Q?y+ZfVZ5gwJAHr1jjE2QvmfHQ+Jyx4zOf78BLFJiKIRm7v2MsS/m2aHsx52KE?=
 =?us-ascii?Q?VM1FFDmdqVwFfSkKpy1jbHGpbWNyDBhEQAiNU6wyEPxc3b/sIcsojcghWJSv?=
 =?us-ascii?Q?3QZs8ypjdmQ/yjIAyj28baMbnjV5nBZCxhwjDlGObCGs0Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f27cf79-da33-4e24-7a3b-08d8dddd9ef3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 00:45:19.9511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7hVRXw8G0ss0FgbQR6uy7tUd5gW3rgfb1DhFEL6OZVcCKbeL0X6ztLJGKiVgoY1X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2774
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=0 mlxlogscore=696 malwarescore=0 priorityscore=1501
 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103030001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 02, 2021 at 04:40:10PM -0800, Andrii Nakryiko wrote:
> Just like was done for bpftool and selftests in ec23eb705620 ("tools/bpftool:
> Allow substituting custom vmlinux.h for the build") and ca4db6389d61
> ("selftests/bpf: Allow substituting custom vmlinux.h for selftests build"),
> allow to provide pre-generated vmlinux.h for runqslower build.
Acked-by: Martin KaFai Lau <kafai@fb.com>
