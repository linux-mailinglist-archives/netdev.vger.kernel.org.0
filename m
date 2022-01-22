Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30B2496DDB
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 21:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiAVUDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 15:03:31 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57740 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbiAVUDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 15:03:31 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20MA96Pv026116;
        Sat, 22 Jan 2022 12:03:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=JX2+D6a6H3woY7GL5X77Z2oHYumdzcCq3MPk/6GiXMo=;
 b=iMqpMmNgVSbcxsV7je2T2itNbib2Fv0S/SS3a1WegUDqV3I5X+KZHcUj8NUucE48vvHp
 GCqav0SbYKOcauBMBh3ytGRhMZa+kqgBM+SCFWhpc1Dv4dzKVyGR8kfaxb129aH7FxZD
 LPP6wU4W1wsXjwk21sEtkAO2JOW9RibP8cE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3drfwuspfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 22 Jan 2022 12:03:16 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 22 Jan 2022 12:03:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICpTulWxtdAyBc4obWcLH2S9OiskLz//emd/r/ZyW5GJgM95TDsVV5cKyTmRW9XiDlACLf7JTXJV1BogmAPK8NYD4exXG5PrWzZUJPKKCkPQCtUj4QVBUlo8bKw1coYeQs/Y4T5uhyPO5BnSqsa9BGEKyR9c5eZbi9y5XnWE+NEYrV8Qu07azGgheLolw321pkTVyEtFn5oS5+FIuBC8M0M7ZE8CTbJsx+tIEng1rmVMPzlkoc4HLi/Gfisz6yZ8oPB6sODRHmOuq7bYdZW/90gMZIGikHoe3VhkDc79dOcP47OZrtI+z1yG+YGFDaAM65dOy8vGJhDNFbxc+6I6wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JX2+D6a6H3woY7GL5X77Z2oHYumdzcCq3MPk/6GiXMo=;
 b=J1CG7APFpBRGNorrszhEMRvybg4llKz4wRO4CtPbDwluap9CTit84b6CGlqtF7K+uSdzg2zG9mPy+RvxjCinmsHu6Wg7Wb1s19bdmiXGYTg50zjC5WjIh8VyTL16PvFJRoGXGJlYHIDRXvhTEm/mcv+3qEdK1RBHSbif0EZyFqrVoZcYR+ElK9Z1KMRmIChnMVSJssfaJPS01BUbzvwK6P0IaeKSEg74l1X7P81Md7yvdF7/zR62nTAxX90LZzujs4t8TLeCykkanJI+mWTL0qH3Ba454HeMCm9w03R8Eoit7uhaweBMxzWPVOV7VzFHZnMfQXFR4Na17YkNZdsmFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2240.namprd15.prod.outlook.com (2603:10b6:805:22::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.14; Sat, 22 Jan
 2022 20:03:14 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%6]) with mapi id 15.20.4909.012; Sat, 22 Jan 2022
 20:03:14 +0000
Date:   Sat, 22 Jan 2022 12:03:10 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH v3 net-next 1/4] net: Add skb->mono_delivery_time to
 distinguish mono delivery_time from (rcv) timestamp
Message-ID: <20220122200310.6fzcjlg2ziuauybq@kafai-mbp.dhcp.thefacebook.com>
References: <20220121073026.4173996-1-kafai@fb.com>
 <20220121073032.4176877-1-kafai@fb.com>
 <CA+FuTSe1d91JC_bQvFGdoAaAEG4fur6KfzkNheA-ymnnMharXQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTSe1d91JC_bQvFGdoAaAEG4fur6KfzkNheA-ymnnMharXQ@mail.gmail.com>
X-ClientProxiedBy: MW4PR03CA0131.namprd03.prod.outlook.com
 (2603:10b6:303:8c::16) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e2a4bd7-86c4-4d68-4c9c-08d9dde23909
X-MS-TrafficTypeDiagnostic: SN6PR15MB2240:EE_
X-Microsoft-Antispam-PRVS: <SN6PR15MB2240A2E52B822249D4580EBFD55C9@SN6PR15MB2240.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BGuaJDlXyN1SD7J6XWeaKse3y4dlPPwjD68r0J5Lomp1ZNY/fvExEG2WWwq2MyhM98wJ2YxjHGW4UbPIGrK54u/L+sck9EShUsjQnMyIzV0UwrDw6c3h9CTK8FpfCr9OTKVfE1RYhI0Tl9clpHuK8YWDRw78zjtkDJIS8LKypsdtUwAmI4LEMw7HHApJzvCvSFryzRZqcoFbKYlu/3591EYdvHPfHiURiPyW5EMWGDbbVPTAjlOoOX2cuxXvUmVJZ3g7zxmTHNAE4hlQUJQgJuEauLyYn9oyeboaFRJK161pz5IUHsx/uAPTlHGuoyeBgJ+lpal6VttlfTGSsQCUy9yuqjgTu2hu5ZTPt4s1rBOkjCgDfAMDQtYlWEsXhI8Js4i7qsA4ZQREdFTcb5ofPc8sIE349d1QfeuxpZEoRLbexRknkPs4G5UBBQvlhneRU7lPWStAEKkxrx7mDsfq8XhHaFLzne9+fkTma7qZpRxK8OaLkVHRd2zzHR8alDzlZYw70SSXHSbMSD1TrPlGYdBCn2ohIrJsl87WWLxAAVLFyzZSZovXAol5f1sqAi9g3H3hKeMgQNjFQBjD4bdr3K6j3hRUIzNPhyIzDiFfjAsmAHvJYnF/tJ+qzdQlAWRiKRJPgozB7EtrcMkb89MPvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(2906002)(4744005)(4326008)(508600001)(6506007)(52116002)(38100700002)(5660300002)(83380400001)(86362001)(316002)(66946007)(66476007)(66556008)(9686003)(6512007)(8676002)(8936002)(6666004)(54906003)(6486002)(186003)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D+DDsth5//YaOQCLfuY4GJMYK0e57xX8te31cqtc694xjMbZlr1N7DD4/hvw?=
 =?us-ascii?Q?46cCqzNqKw0msLzH3sVEt7/yFiRlikMe95nrDVSMm4bDUrrmqZ//z6pzAS3G?=
 =?us-ascii?Q?JLqaZRwlGOVUixq2Oj1RZRPtSbvakQLPn5BobvaFj1YItr/v43PDyr9QR40U?=
 =?us-ascii?Q?AnKHrOk5lsZORVqEv9BhUGPWJBTEmEP4EUAJ2s65OUq7INTH5fWJyWMF8BvA?=
 =?us-ascii?Q?YZv8b9AJ2/Z4eWH4cIkwcomhn/9uGYyhxygQ+AKyH474+TrmkkkG07cnPtSl?=
 =?us-ascii?Q?s8Kh/Jd2B5q8MwJq09GtRYOCqAOPyAHhKFOxQ6VpzG3RRHstagsjec7MT6JV?=
 =?us-ascii?Q?jeo0xymDgc/sjdzGZ+kbAXB+H0sf6O5iPoCaYKYwWEu18fUlVoYWkGoXMsXO?=
 =?us-ascii?Q?y5poH0/yd0lMTTP1/I8i471ybI9gGJlacsoamxi3HXGBpfkjuf2/Wg2OnEND?=
 =?us-ascii?Q?9PgarsQPR9C2Hx34Mqhg2ISF72CMd8QJ26x+WLxXk67DLRQ4tyJrzI5Gkyrb?=
 =?us-ascii?Q?ll4houIwrDpWkQxQlB0JEPp7rffCKkVKqRGWfh7dH7es8ZzdltZ9E23wkpYu?=
 =?us-ascii?Q?hNPt8m2eLRnXsYuMsArQDM5R9X+XUsypi/lMT+JljBkwg7XVek5U+3emxPDA?=
 =?us-ascii?Q?T2hNATNphekWSxV7Qe+1jwnEkoH9rOzlt15nn1fjLGnFf4apEwikZoo9+QAU?=
 =?us-ascii?Q?tD5DIOw2v57GEKjDsZ9JuMbzt5EMC6exLvZ4qC4MRBujZl6Y3ECPYMbm30GW?=
 =?us-ascii?Q?LPL/1wk9y+6CP+QjLVebnWHgfKvY4tfoHUnr6TAYFMZ/hGSaxbGrFUi2o1/e?=
 =?us-ascii?Q?pl4jyS02hjfO9cXkhH7Eyu8h98FWTntK2VgGrQ7tYlFzN1oq+GSYImbUeVBN?=
 =?us-ascii?Q?c7KA023dHjWquJEnjawwxdh6VQpW08SD0AY4jnL2eMdPJIC/HQ/ZKjoZ2qoL?=
 =?us-ascii?Q?UvM1vRBCkTPMS3gHEhNtXUqLMHZG8904VF6kcKDTIINaaMM23FUXgXVBTIPn?=
 =?us-ascii?Q?On4/wRneMIDAmoOAtMN/v31Tj8UeXiNhppRNKUkt6+iBMtZ62yP4p451yNLu?=
 =?us-ascii?Q?YrIJOI9kD3d56TlHbPghxsS+2A4ws31i47771ES/cbvBA02hWEtVX58p5H1K?=
 =?us-ascii?Q?vEoFKkAC0y6eLdGecLNEKyMJitP3yZ8DXFkIhuMBSfFAeYzXdFgZhuiJISMQ?=
 =?us-ascii?Q?uWjvnceth5GqpbebtUPg20TBs+cK776vHx7qXsZsNbBu+z1FoVsuGYNZKWoL?=
 =?us-ascii?Q?CbFDfX7zW4DWHRFdzaMBtG1k9S2HT0x6fpPeA2g/x4unCqWtcj6b3PSPdefW?=
 =?us-ascii?Q?g7J4AzfHPf9M1nXfjAmRMylzccUbzQG0NwopBjuoyG1WB4Oilqf5YR0uOgqN?=
 =?us-ascii?Q?u9YR9YxfEPqo+JXHqi/rapPjjgJLEy02ojpyD36Y/O5uOdGvBXXdYxoU6c+m?=
 =?us-ascii?Q?a4YF3AZeUrYqyINhl/+8jmf18U9MjsKU+/e6eRlTa0+aN/+H73PvhGlG/wxX?=
 =?us-ascii?Q?47F0ARyayflpyiUi5ys71quTs1lT+K7T//kJH83/5tffG+9gJiZHLnAlW5hl?=
 =?us-ascii?Q?sQpIYtDLw/fnmiwTRxXwlDlb5pL16KpgjnoIwRfV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e2a4bd7-86c4-4d68-4c9c-08d9dde23909
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2022 20:03:14.0299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RGMLREzl3dRJ+FgT5AIMSsVXbhm6Rlw73JGnirldWPl4P5Zcv5aOAoQCNe7f2acq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2240
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: CaAAg88Gd-ypqxYwzTfsB7Cgve05xsqI
X-Proofpoint-ORIG-GUID: CaAAg88Gd-ypqxYwzTfsB7Cgve05xsqI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-22_09,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 adultscore=0 clxscore=1015 spamscore=0 phishscore=0 mlxlogscore=851
 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201220143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 22, 2022 at 10:32:16AM -0500, Willem de Bruijn wrote:
> > + *             delivery_time in mono clock base (i.e. EDT).  Otherwise, the
> > + *             skb->tstamp has the (rcv) timestamp at ingress and
> > + *             delivery_time at egress.
> >   *     @napi_id: id of the NAPI struct this skb came from
> >   *     @sender_cpu: (aka @napi_id) source CPU in XPS
> >   *     @secmark: security marking
> > @@ -890,6 +894,7 @@ struct sk_buff {
> >         __u8                    decrypted:1;
> >  #endif
> >         __u8                    slow_gro:1;
> > +       __u8                    mono_delivery_time:1;
> 
> This bit fills a hole, does not change sk_buff size, right?
[ Sorry, cut too much when sending the last reply ]

Correct.  With this +1 bit, it still has a 3 bits and a 1 byte hole
before tc_index when every CONFIG_* among these bits are turned on.
