Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E32402EC6
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 21:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345371AbhIGTLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 15:11:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20970 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230203AbhIGTLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 15:11:23 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 187J7jB8016651;
        Tue, 7 Sep 2021 12:09:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=FeuuUd3PgZbgDCB7S31OM6KTbLLg4uBwt18EDUtg6FI=;
 b=YDD0l9W9f8/7KNJE7TdlR0UbCM/2N1l23AAqFHFd7z5cZMoeUI/AYgNIGoGvc0GAvLVL
 XncpnRaDHmbQPsCCa2jb5Ezf3z5WFjNsPWcHsqK5d5LnHcQngNtD+tXTHLDKJ05H6fcM
 e98ae9cOKXWvBV6MkWZ2re95D3+mcMr4jZQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3axcp60jk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 07 Sep 2021 12:09:56 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 7 Sep 2021 12:09:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XAHtODzNKSeDftwetUvtGtWkBM7D/9IAhAYJGmQizG7/jKJnmD4013QSmrAPitLkMxe61hg985PZa8yYf5hSbsKxMOFV5ox6XpD5P49D1C2BNwZi0tfwyES3a/YGtNvRohC9OOfuN5LuMyvbnu7ujAZJzCQ5Sl/UQwu2JbEjXFkShXUtQGyVxyAfWJSE9StsCPPRdVGnLB/q0rC/SXAZaR7pBMmlk+jebWH8xhDtSPQU1x3W4y+9BPcakOk2Bd+DTlYznV2Y8Yz9RkuCdvVTRtV9vtqh+Qi38SM5R2Ilx0wRlRKniCS6Xry2IRRT74Rusz8/9Jj6zRWq+7S0RKo70w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FeuuUd3PgZbgDCB7S31OM6KTbLLg4uBwt18EDUtg6FI=;
 b=M4cdlxF66MH6gPo3kPBtKrHAF/7Ps8+X/s15d+BK2tHKu1/n18Crwk0F4WRQd1iTYdp1LkcYgMplAjRetbgs0PznRTMnHibYF318YFmE6oBL+e3VmjY3F4WrQaKqrFUwgMLzSzc6IoDGV1Z7H2gRHVmkArY57lTweyRkF3Gj3J0Ned0MtItkVD5V/E563xniZv5KMNSEDlJ1ztzw9+pXSJ302r08paBKet+aTLLHZ2l2o9vx2bpdJsNfowS0xzhbu9gCYMclE7skgCbh7hpxrwDrTc9RhrbvIBCpH9ltaVxNwT537EeTlpVj/P7U6nqWqoynsPesXeIm30/5lskukg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: novek.ru; dkim=none (message not signed)
 header.d=none;novek.ru; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN7PR15MB4174.namprd15.prod.outlook.com (2603:10b6:806:101::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 7 Sep
 2021 19:09:55 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::3c1b:1a10:9708:7e36]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::3c1b:1a10:9708:7e36%9]) with mapi id 15.20.4478.026; Tue, 7 Sep 2021
 19:09:55 +0000
Date:   Tue, 7 Sep 2021 12:09:52 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 0/2] add hwtstamp to __sk_buff
Message-ID: <20210907190952.o5xenqjdz3pspq74@kafai-mbp.dhcp.thefacebook.com>
References: <20210904001901.16771-1-vfedorenko@novek.ru>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210904001901.16771-1-vfedorenko@novek.ru>
X-ClientProxiedBy: SJ0PR03CA0156.namprd03.prod.outlook.com
 (2603:10b6:a03:338::11) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d487) by SJ0PR03CA0156.namprd03.prod.outlook.com (2603:10b6:a03:338::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21 via Frontend Transport; Tue, 7 Sep 2021 19:09:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99893c7b-fd68-4190-8e2d-08d97233138c
X-MS-TrafficTypeDiagnostic: SN7PR15MB4174:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN7PR15MB41744A2ADCFBF8896B002242D5D39@SN7PR15MB4174.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6DkzTzilh4Keo40sOQZEPOS5L6hg0Ep+xwHJ1wW+XwYyUaDKldPlVNvyiD1HdNtTqCeIzM2t0+fRCVur0KINIdEdHx9c0RHl/RBTK2HbA4VgIItkH0DOA9Dpo+/7NlVKDcABKEam4m5qIy7Mg+tNKXo+4dkWiWEFPsSHiJtJTqG90Z/aoUlMhnvj2dPH+SUqaAAeztnWzrP+fal/OCJ9HrLK0yunXx8nhsxsZVrXs3yoH6/ssJ0kjAF59dKzQbqo6M3NivJlaUWyU+BNVUKXcTvoKNHgl+uXsmbCpcD0ixAe8evQfmxJAle5aIz4XATqvTo7fOXbmFgUSvxaBwrzmpEr3lWn0DrVG5974zdRmLjhFwFHLSM6YjV5uwwqz9Cu4GiEOIObM19kX22PctLfY44S9IwvBNNPdwVC8LX9Qg0XN1weChS8uRxR9BWuxZJCBcoQ0lNAD9MVnkS+BNiIAwCCOsSdVP6Re04ESImInr2S9ovm0Jf4pOcKoxoFiocXUtrpuoOgZmMhnqdVJ2greVoTzRNW/4PaMqf9WavlI38VNu7Hm2u3UkBmCCceCor/K9gA3K7C1xS/eMB67cvixCAGzcZG3E4CpdgmCYlvkLZHryTYoj12Rr71MSwhA/197e4P5gg7uFzXVeHODsEUxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(316002)(54906003)(8936002)(6506007)(4744005)(4326008)(9686003)(86362001)(66556008)(66476007)(38100700002)(1076003)(5660300002)(66946007)(7696005)(6916009)(8676002)(186003)(83380400001)(52116002)(508600001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9k3lTGP3ppkE+6FRFMhvm7ZW82qgZd4TCxk6H/L9kGMpIUbTzYk6PxoCdcQW?=
 =?us-ascii?Q?b88tIOUrdyn5+vm2rpnCuM6k9C5XbwepRZHX63HI+e+xhzCkPz9FbPnRgkzV?=
 =?us-ascii?Q?Nwha9YLcYJBAotMH3zs2px6hiNQMWR2Wk/kNF9VtrIFIj5LO8l9WD5TWoiq8?=
 =?us-ascii?Q?ZJe3Tmj5vaca9x3HWrS5y2RoCZj/yjDEmJmmOByOLJEqejzXb29uAttEahuQ?=
 =?us-ascii?Q?SVnYV1sZKtVF/qFOhIT4lPAUwkdG1Y66ECTMPUeY+M6S4/yDhflV+/8ztWev?=
 =?us-ascii?Q?Q1Zm43MLKUarRVJlZZsMd3Ltdq8aqSnPnyAGcSJhP52VMricjrnIbFAf/0aE?=
 =?us-ascii?Q?LU+RzAWR1/YPDlD7OOLCh6Dj3GamBHPw9eg0nb8sOgfeaTDC59or6/QnmfGF?=
 =?us-ascii?Q?bb0EzNe+PbgAWd73vJLIvLyAEO8ZufYgLTomGk48a5aBMSeeGMESj9w8u6Ay?=
 =?us-ascii?Q?TjS3IsuTXr5C+HQFmXBM1Ob+7/z1eoUiirn3L/zrLa53TlPy3FOnhvbAI0QI?=
 =?us-ascii?Q?qWdfdcAKjtJGyyiLK/agHOPq47EUugrXzuC3DkK4Fbkx7Vk1fMX1rTIGSh36?=
 =?us-ascii?Q?5CpOxAaBKgMYsRCaNU3CODHlCV+g9g4xK1VCGOJV694dEzVjZ2c0ezbdO3Wy?=
 =?us-ascii?Q?Rg7oolybZwLVRTJ1dmwG0S7uPp80J1ukT6OddcWEQtjt5+cvIrB18DsHPAud?=
 =?us-ascii?Q?hHZwUbRt97r3qxtmezZW9lMZtQLjBJdy0DlmnTVnh3ICbXBGbObQV0ya5LXg?=
 =?us-ascii?Q?MZb8IuWF2cDcpuL+R8oLokdxpMH0YGSyeRhyKMN+xfRwtaNaZKUb5DtsV+4X?=
 =?us-ascii?Q?FVJAuYSosRKg/5QwiouFjBNAsSsfN8Ray4YeZGEM+7JNnFV+WHkzIkdb6o1M?=
 =?us-ascii?Q?sJnnzXEsLRkM+3wDI1bSf5HH6CqZ5TVcARZZVmyLzsZ8t954J5vDUMivcokI?=
 =?us-ascii?Q?PlTKVncrIjM5YORybAIC4i2eIxrRQQKPGjee6gJ419jDJxWdBjyGB3K/JFLR?=
 =?us-ascii?Q?k1eyDresalnYNnFVW4W4uZbX7oH7slWPeMuNG8aZl465Kc/4LYcou80/aG6g?=
 =?us-ascii?Q?wPXJ24rBBVs3O3F7DAKdDlBa8kbg4HgMMYACZWQYN29TONUxHjZ26ufrfNlr?=
 =?us-ascii?Q?ICIk9josM1nIZlOtPLoNXz2xiy/GHvSjez5pI18seGYH3/Gn2EzkP+jY9yup?=
 =?us-ascii?Q?wSeOWPzGz7l+6xmdhRgqJis7isMwyikrTWgUaFzOLHFEX5BCevWDw2WUA8Vl?=
 =?us-ascii?Q?Mb3IqOK+mJWnrUDHiPIhgbk0Ev+GAv3fH5Rvp9dLPlBDf92FhVsz3zvyHA8k?=
 =?us-ascii?Q?eMMvC2LEsn5B1kXPPh6MItw4/lGHvqg+GNUJqJzCCa2BuA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 99893c7b-fd68-4190-8e2d-08d97233138c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 19:09:54.9061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wMlOtSUrJhK2XiNU99DZVa5c3ZZyxNq1TdShxm9YKwildsb27SKXnMeuTnN3j4iZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4174
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 6EqbDrVBRjkfg4amIxOw9XVFnlMlm1fA
X-Proofpoint-ORIG-GUID: 6EqbDrVBRjkfg4amIxOw9XVFnlMlm1fA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-07_07:2021-09-07,2021-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1011 impostorscore=0 malwarescore=0 spamscore=0 mlxlogscore=509
 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109070123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 04, 2021 at 03:18:59AM +0300, Vadim Fedorenko wrote:
> This patch set adds hardware timestamps to __sk_buff. The first patch
> implements feature, the second one adds a selftest.
> 
> v1 -> v2:
> 
> * Fixed bpf_skb_is_valid_access() to provide correct access to field
> * Added explicit test to deny access to padding area
> * Added verifier selftest to check for denied access to padding area
Acked-by: Martin KaFai Lau <kafai@fb.com>
