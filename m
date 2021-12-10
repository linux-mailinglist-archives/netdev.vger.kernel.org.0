Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D14B46F89C
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 02:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbhLJBlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 20:41:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40110 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231374AbhLJBlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 20:41:17 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9N0frE015390;
        Thu, 9 Dec 2021 17:37:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=YKb1skrKY7i09V/V+Tg/WcS3MQWeY9sjIpn44U/FxHE=;
 b=gFhUKD/oSZSwgqkibrou5LJPRKDQOAZ/xLKjqXaELUMFMBczrmW5ych9G4x8SsUC1014
 WjtSCFYYFV0CaPlE8NPlJ3PEJNaPVkqw0U3n+4+uov+4snmMmnYBPlCE7oyYeTMqFYaR
 ilFHFDcn4kQooaCccU2ZUiI7K7oDBBYQqCo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cupxbtsm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Dec 2021 17:37:26 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 9 Dec 2021 17:37:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbe1XXSJFGEvGIWUT6LBft29qBwuLFmbLrwuBSMzTa33xirvgGco/s/2HksFizhgg49qdUH+PLfnSqg0XixaCUUxdDpBPenEh0Q9RWNJYx+tO97smcXBBgf7Q02aRvd7qTa7wcuir60EvuSPzSwICfUSewWm39TzLXeTxGSsMohMrERGVCuOuj2qBsdcf+05ZpFhXMuScqTa7ieWAqax/rJ6JTBaxmjSsYXawQVF8Ilha9pltIn/OHihamsRSd/fPDgWLzUwLJNL5wcTr4baSkghEFGTwhRdBh0Y55ridYM/gTuXhZYHBfM+exLYQpkzURsN5GQ6/42ro0WYSc7D2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YKb1skrKY7i09V/V+Tg/WcS3MQWeY9sjIpn44U/FxHE=;
 b=mp/vILTbdaSjrPzRKExSHLT9ZmcEm2dSyY4fywl9EsSurPEZhLCvR1UHYZNblCUVlIAFIGMtMbkD5ydd+7Kdi/lKfmjyKWUXHUpGh+JZjdSWPL1tp9/a9+kwUYH8c2sP+DeyQtbUtYIaPdP1MnaStaM/FHW//pWVQc0tUyvi4W8mIoP9ML8lAi5QNx/kCKFCfNpCNgUvjmk/6HdX1HhJeay9Ebnyu6lS3aahn4FAHb/Sxab8/5mItxuQkeHA3FBYIp1tOEta4Pu7c3f+s0z2ySuOQ2jCcPuueZ1OqCnJ9FbGFMals7TaAVbAdEEzQ2KvP8q8V5fLEey3HTIj7nH3RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3807.namprd15.prod.outlook.com (2603:10b6:806:82::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Fri, 10 Dec
 2021 01:37:24 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%7]) with mapi id 15.20.4755.022; Fri, 10 Dec 2021
 01:37:24 +0000
Date:   Thu, 9 Dec 2021 17:37:20 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
Message-ID: <20211210013720.mp7avsr63i4nttr3@kafai-mbp.dhcp.thefacebook.com>
References: <20211207020102.3690724-1-kafai@fb.com>
 <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
 <83ff2f64-42b8-60ed-965a-810b4ec69f8d@iogearbox.net>
 <20211208081842.p46p5ye2lecgqvd2@kafai-mbp.dhcp.thefacebook.com>
 <20211208083013.zqeipdfprcdr3ntn@kafai-mbp.dhcp.thefacebook.com>
 <1ef23d3b-fe49-213b-6b60-127393b24e84@iogearbox.net>
 <20211208221924.v4gqpkzzrbhgi2xe@kafai-mbp.dhcp.thefacebook.com>
 <b7989f8a-3f04-5186-a9f1-50f101575cfa@iogearbox.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b7989f8a-3f04-5186-a9f1-50f101575cfa@iogearbox.net>
X-ClientProxiedBy: MWHPR15CA0032.namprd15.prod.outlook.com
 (2603:10b6:300:ad::18) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:e80e) by MWHPR15CA0032.namprd15.prod.outlook.com (2603:10b6:300:ad::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Fri, 10 Dec 2021 01:37:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64a35ced-dbc0-4601-b349-08d9bb7d9dc1
X-MS-TrafficTypeDiagnostic: SA0PR15MB3807:EE_
X-Microsoft-Antispam-PRVS: <SA0PR15MB3807EE39CD4E1A5DF0ABF21AD5719@SA0PR15MB3807.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uRWYy7ujIhxbH57QBlsVGcNbaX3e6s8OVuUuPWxHVJ4sXf2AjRi/rx/otuZTo+LKca9Vi1b7lGpGqV3SwWI9DSoPvlAftU+FtKOH4oYv0RRbH+QyEqlJ5iwwhkP5x5+fOBqcgRAcPLeAg1uFJ3yZHKHXFo65XuuAIMGBhQl6bmfjX45lDhI3HBy/TqmvtBLKhDaWwCNF5F7RNQocc2lDDjkmRuH2najI8799fHU13yX2W2fgkSA3ldkLOgFpaLjMl4zElvQ9fEe1jh0hmSgmsfnFhjy/wK3WFLMx5ytUluwX6XvrauOnqrNBD1TFojjiM7CS3ogRH/61LEVuKiWk+GKkvgpgv7k382qFbOVJKS/FBonchbNHEhQTjgVB6dSArlJ49Yl8aTv2LJtoIPjqBzInQh5NBhG3cHEzApAONsQYtUD847rgJ/oEErBDFloqmu5pDdcYZ/u8etUF8NdW3q/nKJ81+uOMowFOA4YwJJJTQMOC6j4dNOR3Fw4IgJpdf3NaHPFhtzW9PkhWEoH6KuBcSEkkXn6Y0WpO33LN5mcey5uREvPE8LzKSVrP26adLWRq13EQwNl2jXdnPfW/OL2mq1z7Lv76/ogcJirie0T1GAJp0F0K9Yqvc4pEY1vnbeK0Cuyc2Ch3ZCIU5ZGidA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016003)(83380400001)(8936002)(1076003)(86362001)(4326008)(5660300002)(186003)(9686003)(6916009)(66946007)(7696005)(66476007)(66556008)(6506007)(508600001)(8676002)(52116002)(316002)(38100700002)(2906002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5R4WTVB352NgCVPlvDPn1Nxba4ho7jhGD3+VPh3dax0IOMdJhPLewHa9qhnE?=
 =?us-ascii?Q?WV+tcG2bwQN7cPRsNMY+OS3HOzgAcRLowaKgS3/eTZHAyEfyp00+/8PgUIZF?=
 =?us-ascii?Q?rqGa91GcZg/hkj8dgUnWQkuqeqrg56bQwVbe0pOzpO7egK6tQoj+Fd3XWceX?=
 =?us-ascii?Q?dKoupOlpD7hN7AJ/f8SonJg9AOfJpXuo8Eg6VNMe61X2EZu3p7/HY8MZIPVw?=
 =?us-ascii?Q?PFY84ceYQM4Gr5greeMum9DbqzZbeQe0378V/kZkNszO4naEDOJ7WJhyk84z?=
 =?us-ascii?Q?y/ke7/INdPZZvTTomWZTAS9fGer914gHcEgRwOQpbDfcj8D4UBsKzeYTRS0P?=
 =?us-ascii?Q?rW0yZc1HqSumGIASR9XQOotjVCornt7Hn5F0XiI0BbyW5NGDqRC1HgfvTZAr?=
 =?us-ascii?Q?QhxR7Asci1/qzBCE3kOVRTqXm/YgdGnw+B9duJOeGU4ZwBuc4/SrNHN0u1qp?=
 =?us-ascii?Q?Qk///nTJH+atgnzyALCkFXre3ryufXsRUkhfjaBw4Cw6f+QzfoY+VuoUUAfw?=
 =?us-ascii?Q?0YNRRiSP7Ba8iUj7RCosPmG4hjG3JyYRaLkhYHl+nV70PZzproPP1anZZkLD?=
 =?us-ascii?Q?lC1CDl03TvpvixTDmHsa8vImphpsMC/ofphoH5N1FiilktJHZa3H51j2BnLv?=
 =?us-ascii?Q?stGw+o39iGuI6+Fv5JYYT5ql/tTlTQeKc6kLepmjw+djpl3veOv0T5W19NYo?=
 =?us-ascii?Q?gD/BudCtrGGfaegEOHwHN7n437V+fmjzVUhTNRJRfW7xpZ9Jrtcb9wmYuG03?=
 =?us-ascii?Q?VBZ6WBoGreSGa/CGyhrpzoUd/R1hbz0dm/SiP4qVsXp16wRSUJBIDDzUzyF8?=
 =?us-ascii?Q?/d/1x5E6bD3g+cwUW7my5CdH2f60Q0XgpoGDElRCQze6LkAOodqfdcRyT/GS?=
 =?us-ascii?Q?RMKxw9Bm5NXKMYuLTymSnRlisGF/iMJ/0VpEmOrEbthyY8oJFUYxIISL6sLH?=
 =?us-ascii?Q?Lu7RbEV3um0jhE/6e8SjL5+Yo/5pco5k5IzCgVaDj+MZSA1952c8KmwHmF65?=
 =?us-ascii?Q?su1whc8h2Vl6AAEsHRIikDZjbpKwWi6+qyuffFbLMzrnJstszlAvuUBTjMX3?=
 =?us-ascii?Q?kJtpzLb9+wIOZaS+u/26c5x5D5tw5OeyChc+mSLcln/QjckyPXx+u0N/LqbH?=
 =?us-ascii?Q?7ZHxT+0HEBuhy/H47GBcdmCJ86XQxqw2L+9DZnotpE9MogqXqf65Z/q09YqC?=
 =?us-ascii?Q?yskUk8bQi9nYiH+dHA7wNi+IiiCYZK5EVtoJXLc2F9qTPh9t7wfa3vGv76Ss?=
 =?us-ascii?Q?XV0xfHEhQ7N7sVqPf5Bz6yQWOZ7LYf+dhaSLs0MbOguOdQT7q1JAL32zdLO/?=
 =?us-ascii?Q?96mS26LWIrS1oXxe4OrBQrup+2QxHakl+i5nRV3ho4AThUu0XfJXdBe2bWt0?=
 =?us-ascii?Q?CAhQtpgXfxHHe6HPAnL58wz6WXcuO4hrT4p2A1NeSv5rDKtIpmdaExrU+dsG?=
 =?us-ascii?Q?OZ0amjHyrfuXWznVU33FUIWuacxSyVu2NM3vtbEaDVxidD1PM4zaIffFX2qu?=
 =?us-ascii?Q?1tYltweu4ti+P5j67p3NkWPMDEPrQJ/LLpbdvgzYw67BJfSke6BrOOpEJojN?=
 =?us-ascii?Q?H0aK4ZM+mHwuXZ6yeZAVm5ABO1r/O2y2VKa2HSpG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 64a35ced-dbc0-4601-b349-08d9bb7d9dc1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 01:37:24.4476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xk/xFvKgKGH7hq7g6l1OcNJSBrAQ0T4oyln+U52pzr0BeRJqr/YXfZNImjaSB516
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3807
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: vgLYwVKqE4lHQu_Sf746DWGs4xRho98a
X-Proofpoint-ORIG-GUID: vgLYwVKqE4lHQu_Sf746DWGs4xRho98a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_09,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 01:58:52PM +0100, Daniel Borkmann wrote:
> > Daniel, do you have suggestion on where to temporarily store
> > the forwarded EDT so that the bpf@ingress can access?
> 
> Hm, was thinking maybe moving skb->skb_mstamp_ns into the shared info as
> in skb_hwtstamps(skb)->skb_mstamp_ns could work. In other words, as a union
> with hwtstamp to not bloat it further. And TCP stack as well as everything
> else (like sch_fq) could switch to it natively (hwtstamp might only be used
> on RX or TX completion from driver side if I'm not mistaken).
> 
> But then while this would solve the netns transfer, we would run into the
> /same/ issue again when implementing a hairpinning LB where we loop from RX
> to TX given this would have to be cleared somewhere again if driver populates
> hwtstamp, so not really feasible and bloating shared info with a second
> tstamp would bump it by one cacheline. :(
If the edt is set at skb_hwtstamps,
skb->tstamp probably needs to be re-populated for the bpf@tc-egress
but should be minor since there is a skb_at_tc_ingress() test.

It seems fq does not need shinfo now, so that will be an extra cacheline to
bring... hmm

> A cleaner BUT still non-generic solution compared to the previous diff I could
> think of might be the below. So no change in behavior in general, but if the
> bpf@ingress@veth@host needs to access the original tstamp, it could do so
> via existing mapping we already have in BPF, and then it could transfer it
> for all or certain traffic (up to the prog) via BPF code setting ...
> 
>   skb->tstamp = skb->hwtstamp
> 
> ... and do the redirect from there to the phys dev with BPF_F_KEEP_TSTAMP
> flag. Minimal intrusive, but unfortunately only accessible for BPF. Maybe use
> of skb_hwtstamps(skb)->nststamp could be extended though (?)
I like the idea of the possibility in temporarily storing a future mono EDT
in skb_shared_hwtstamps.

It may open up some possibilities.  Not sure how that may look like yet
but I will try to develop on this.

I may have to separate the fwd-edt problem from __sk_buff->tstamp accessibility
@ingress to keep it simple first.
will try to make it generic also before scaling back to a bpf-specific solution.

Thanks for the code and the idea !
