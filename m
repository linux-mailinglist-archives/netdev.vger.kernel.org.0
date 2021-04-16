Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29270362A65
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344445AbhDPVgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:36:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55708 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235540AbhDPVgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 17:36:41 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13GLSpNg005118;
        Fri, 16 Apr 2021 14:36:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=FEqA/dTwN7cCgHWT+Xl+2AuYK4FhTtzZNkkvwG8ciaw=;
 b=imLiuRljvjJrmXdQhgIpykKHFhfOLlQQugAFLrdLAcCVtyzYDna2kLMVZ5vcxvMpC7ga
 AiggzCVukYgqUmKeCkTgDOT/reC7A+NATh9cuUZy9NEUJydFBb0e3VW8RogY/paGisx7
 lUNYP9gGUZ9inpmgmk6TpNwJEAz+82f7mZM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37ydj4swmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 16 Apr 2021 14:36:00 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Apr 2021 14:35:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSsZmKUqsS8RgnCW+8RbzfiMYvzoYjSCiR4Kt+7U91LlMjjEip8bVBvP7STIdiQAOc+LUiTBbnC7hIdVzLP9xpynyq67tvqqMvJTspUTkLWQY6hTnRMlHFDBIIpt8UjusPXcelE+XpIrWMGXZxwkvIAUYQkerT1r9vbj90YmGApuUIdcaF66331JtIDQffWZIEfmbSIOKgYlNrhHSyTArftGina+YceBekwK/GoX/RogzbpsB7k6TP7mSATVi5DqMQolwGxz+sKSdlwpQMTYdL0oXICiRjoOBoBfWv0jro3VjtIEurvkQrtFgCS1p5oLAYrEukgGV6YDx9khFJHi1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FEqA/dTwN7cCgHWT+Xl+2AuYK4FhTtzZNkkvwG8ciaw=;
 b=CW4hYBO27qzwKSptLuR74MnOZfPTRlTJGzca7kPnFiz3a1jSs4Ad3k2Xdo2jsvNXBkDKyhrxj1W6Rm8GXPYJRZSdp+ks8BEDUsxoFZH/3HcubXv6Y1LSGdRsKANjoynP57f54t88eni0bqDjd7jkYWI6BvTGlvjOImyrFZO/aj8fTiw2w1TsvKzComliCVu7XrpM5pIXddUUwLHAL4OyHU65giZDxzMCg6QBI7p08YkcbFbJ1WvBagX/wFvAPHFEbvKuS1kehf1PO7ZYg0Qi5EuiHP92oL5lMcmFcFufyFo3e5oJg5ZyjJa+cU1b1S/cXohTqALTVs7eFjUll7YeZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY3PR15MB4801.namprd15.prod.outlook.com (2603:10b6:a03:3b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 21:35:58 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 21:35:58 +0000
Date:   Fri, 16 Apr 2021 14:35:53 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Pedro Tammela <pctammela@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 0/3] add batched ops for percpu array
Message-ID: <20210416213553.wclvjwbkxpvs6rfr@kafai-mbp.dhcp.thefacebook.com>
References: <20210415174619.51229-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210415174619.51229-1-pctammela@mojatatu.com>
X-Originating-IP: [2620:10d:c090:400::5:d4d1]
X-ClientProxiedBy: MW4PR04CA0384.namprd04.prod.outlook.com
 (2603:10b6:303:81::29) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d4d1) by MW4PR04CA0384.namprd04.prod.outlook.com (2603:10b6:303:81::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 21:35:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97d757b1-8db6-41c8-f6f5-08d9011f9f4c
X-MS-TrafficTypeDiagnostic: BY3PR15MB4801:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY3PR15MB4801426E4802C8440DB43737D54C9@BY3PR15MB4801.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vovBa+Ioh1Cg/8U2p+/ybgqAr6CnLLQ4ABhzSuVD1flNA0uScmUReFKOITmMjzYkDsYYuTIFxY3E9iTFcMfBAsTXj58LISSKHVJb1B5OxY8hfAd0yCX7Wyekrk0pOiPyI3bo74iVu1J5reOg/MXwFRrh6QmGfM0spLmW/Cfw7jBHpeMBml7v9eI1tmN22w1NFHnbhStsGcKzRKPUPNqGLj3JKCeRwW9KTVVzFC6QjVRdyvqpFJ/+KY676m3QSEG8bxfwCFpWtbWIRHS2PjX3eJ4PrZinx7hEiHkFo2RbNCCafxKqXwn61+IebJ9f5eG4Wgmy83KEPDTp4i/stXUVWXcPGdgmfrRVLh/bFVV2ZapJHEttaNfCGG1AgbKDvs4nsm3TXl/HgGBJKQFnr66cjDH9voz7E2TElQewxMr4LCxmJQkufUqM35nmfqK9d+tpTWhVYy3rgWUwAT4qUdnpabYr4Pd9PrQMt1tdNlEzRjpaSeJORt/BZq196TfieuKdkNiwglCeOeIjdUSzoocMy7axMlMdNwZ76z+ILbZ2FoyUR8Bw4YLbaPM7MndZybZx2KQO6kesgyLk5zfGa1Hn+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(66946007)(7696005)(498600001)(6666004)(7416002)(5660300002)(54906003)(8936002)(52116002)(6916009)(186003)(86362001)(4744005)(4326008)(8676002)(83380400001)(38100700002)(2906002)(9686003)(55016002)(16526019)(1076003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gIbZNMRI/uB034XLMbv7KpcwLKSfpTywCjqOabx3azfBXktvuZSlISMPnQ6K?=
 =?us-ascii?Q?WdyXWQnOogiFdrE/xt4lQ3X0PajDFTYgx34LsTwiBmDkaUtkKJ8hM3W0rk9B?=
 =?us-ascii?Q?P3nQSUiTFkdkfFQmh0HL2eeAvyerYKdj/pM1PKsLHAk+8tOIsjCPZz1Z+ysQ?=
 =?us-ascii?Q?DmiJeDc0mHUBX8Ald5IQjWNrqzaPY0zDkAHaoQ0fEohhZ4/tIQtX4pbslS8B?=
 =?us-ascii?Q?Et2V0+fDfSMup0XbLfqr7yN+kfCONPaG+DqQhA4qkY53xD3gF8P/LBi7Fkll?=
 =?us-ascii?Q?049VpRklYXBT+aNRX0/acdINRV6q4OgOEPDaPpH2L4hR4I80QEhJva0Y4M6Q?=
 =?us-ascii?Q?k+K79N8VMl9/8H7Mtsp7RWlgvQClwLD7jRbvIn+0god8SfRzfS/Q/IvSOWkl?=
 =?us-ascii?Q?R+Ii5YfhLv/s1JnCRzuNRGKsEAoEeEgFJ2geTJrTVlkickdvHp39VwrPrDUu?=
 =?us-ascii?Q?gwsZvkaoFvda5XTf+YsQbgjZ+Cjj6YMRNAPRciBEH5qEA2YjsinanRgGC0VR?=
 =?us-ascii?Q?y4xhNj4M0R1giuGZkS3bAvJvb0aTzBwwJrvvsOzqlqgLkg8cVDoAOt5mEt3x?=
 =?us-ascii?Q?O9CzOWyb4Qbq4YGy7JbO5UuctdBOL2NDjZt4B5qrLrvXL63NN6tQ7ANNDqeI?=
 =?us-ascii?Q?MjmXgLBa47oiuFzy+m8ecTlMPtACyPZH7DXA4cU0wK8d/DjvZ94aeoQDTLmc?=
 =?us-ascii?Q?MkURfSvc73mUz9cbaT3bLmuIToOvg7Ht6qQh03p4+QYcdwlyTX+dQHwcErZI?=
 =?us-ascii?Q?tLfj2lGw8CpoFR+F86UvPBSmo/qKuykGY7hPrqakp5HHfDKt8hZoj1dJc+4C?=
 =?us-ascii?Q?NSya1SIik85UvGOmvKB6rfKzMuBxnFBw3/qluNu/g9YgbMO4nlALA/WOEr+q?=
 =?us-ascii?Q?OXecxOp4cxW+4josFXMrB+T8ogbbXtUmQr5e0z54gTHNyJ8e7hVJ8TXwTEcZ?=
 =?us-ascii?Q?mRn2cYrHHIf/phPTfpU8mfjOLIt5rG6dIqQEz1KBOY35wxjVMK+4Xi2T7aJa?=
 =?us-ascii?Q?SYwCbnG4NX2dZMAP/t/fis2W0NJWiDTiheGHU0fhjUoqCYNq9EdjLQvUtmI2?=
 =?us-ascii?Q?IH/2gVEBYNYqCkvOq577eJOVifhLY+qN/voNu67mJBiwZHPCiU8AL8EftVeL?=
 =?us-ascii?Q?p3XVQnOX0FGG9LP89NhIph36Ov+GqD94Z3XwVuqALRUXJvmXQ3EVJNcXi+81?=
 =?us-ascii?Q?hnU0569PQQ6f8ORVFU3K3JG6hSAcF10udnaHhLdKn63G9vgyzUfoLZ8tjBrM?=
 =?us-ascii?Q?x4A11YINfjkf3JYclH30Tn3QOLWlpWshe36zSACRYOZlLKUZ+KytCoJ9cqf9?=
 =?us-ascii?Q?95JPcX/dwERKqGFyWhX26+DTCwCsWLjm9qnIt4DulqkVvw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d757b1-8db6-41c8-f6f5-08d9011f9f4c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 21:35:58.0889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jLzvL6z4k0WsFEYPlo6i5hAhkP9OsKUE1pHgOacfNCKkxI8ZMmcIedxoYmdcJnv0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4801
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 3bIx0rsCOGJKj-WNQZIJ-KbpFxFw_Lxq
X-Proofpoint-ORIG-GUID: 3bIx0rsCOGJKj-WNQZIJ-KbpFxFw_Lxq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-16_09:2021-04-16,2021-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 mlxscore=0 adultscore=0
 mlxlogscore=749 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160151
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 02:46:16PM -0300, Pedro Tammela wrote:
> This patchset introduces batched operations for the per-cpu variant of
> the array map.
> 
> It also removes the percpu macros from 'bpf_util.h'. This change was
> suggested by Andrii in a earlier iteration of this patchset.
> 
> The tests were updated to reflect all the new changes.
Acked-by: Martin KaFai Lau <kafai@fb.com>
