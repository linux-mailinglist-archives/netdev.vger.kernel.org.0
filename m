Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB0024C5E7
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 20:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgHTSxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 14:53:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53968 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728071AbgHTSwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 14:52:54 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KIUPtm010868;
        Thu, 20 Aug 2020 11:52:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=XN2JHwdiACaKrxetcSWA/2yCEBOoxi0MtWAkkERg+Wc=;
 b=ZQIk1FYdZTtCeQuTK+sui2TIiSjxcilPMUKWQsXZFcF/Mc6xcTrK8zUZIouRNQMx+1xC
 IpRbRg5/dU0KOPm74zI0RsnolfnGxmhemSV1Kg/qod36zO84Cj7DdAnseTLVHKvcHv67
 m/Vgxng3QvjzwKpfqgESmkQFGuFgfO4i9SI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 331cue52bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 11:52:38 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 11:52:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFEmnBlNpIAHvQ8dmFTmKPP1L7ORfrwQ7scAjFcym3hGf39R7CLhfQRH8/yU2mWGA228tzfcmmzfW5bMfaL0tNtwY3d8367pZgP/smDIGPSv69hmH1C1b0ZTCWWnxMFObB5rW73nlSvUnN/Pp908ImkWTbH3zsGefyayiPreJg7OkqWUcO7TLjgqO800AGadFHZWlNIG7CLGXOUNcKYrEHgLe1taUFlxZgV/OqHfj47KUrZNpQ/eGCXRTbqm5fp1rFwGsP/8YSRqGFNwyzm/afX1RE7UKgU8RiRXb+hfJk9F5MiUDvwDqs5yOCUNoofXfLI6bkzc4j6KTDyHKrXsuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XN2JHwdiACaKrxetcSWA/2yCEBOoxi0MtWAkkERg+Wc=;
 b=YNlnVrYfq3PIG0lWoQynhw+g0MytMZUDemFZPXZeO/o/W+wclSyMeznUGdjvVqJoR2UyzpzBXSoig4pVSIMmJxp1kE8zzPOFB4qwh+CZOvgit8/pJsu0P/MSpEVvZZ5BV9vwuWE/p6LZb0ZghOPTxfWGHM+6Gnm4Jcsw9rCn4gS3lSHEy9T2jxs7rrZAvN5mlfQZI+NgyBRBVgJbTYlq86HDmVAKzJRVpx5PRTKog/byYBVRDKmY5rCL7whUoGfq72wCle6aST32gT050EVoLc7Bt7TMw5WnrpfbPDC2V13cQD+GoQnr9UcgxKcNtDSPdbM138oyJ9eZxW1vWtC60g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XN2JHwdiACaKrxetcSWA/2yCEBOoxi0MtWAkkERg+Wc=;
 b=M+m+jnHoPY9SvmdT0gYhE3+noellXpVM1oQMNabnCAhUmk89lDJs609mdVsczma44pTqp1kLUBPDGI22JTPQ0fLWxWu30x7UXAlT7eTitxE9DNc1E3yMTJvdDWGQZfIxLZZH7qNXRiz6cxdz8mVjZrGi3CvNDwdp4fCcwoKJhec=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2328.namprd15.prod.outlook.com (2603:10b6:a02:8b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Thu, 20 Aug
 2020 18:52:35 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99%7]) with mapi id 15.20.3283.018; Thu, 20 Aug 2020
 18:52:35 +0000
Date:   Thu, 20 Aug 2020 11:52:30 -0700
From:   Martin KaFai Lau <kafai@fb.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [RFC PATCH v4 bpf-next 05/12] bpf: tcp: Add
 bpf_skops_established()
Message-ID: <20200820185230.fysjcpqlaelsdvfx@kafai-mbp.dhcp.thefacebook.com>
0;95;0cTo: John Fastabend <john.fastabend@gmail.com>
References: <20200803231013.2681560-1-kafai@fb.com>
 <20200803231045.2683198-1-kafai@fb.com>
 <5f28b9a4704a1_62272b02d7c945b4be@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f28b9a4704a1_62272b02d7c945b4be@john-XPS-13-9370.notmuch>
X-ClientProxiedBy: BY5PR16CA0004.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::17) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:62db) by BY5PR16CA0004.namprd16.prod.outlook.com (2603:10b6:a03:1a0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 18:52:34 +0000
X-Originating-IP: [2620:10d:c090:400::5:62db]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc64b552-7c24-4a44-da23-08d8453a33bd
X-MS-TrafficTypeDiagnostic: BYAPR15MB2328:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2328D7BB7BDAF0255E237BC8D55A0@BYAPR15MB2328.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sxHGZZ64zg9goiJo2B5X+8v06EtImlgeXCZSkKshOFhRg4nCtbcyAL8eP5QpndRDANzcwDrTSg7I17YFxR0pPHiib4O5/5LlyRxQb7YrqIE/usQq1Agz8DFLcdGJXEigcBvhal5zKWSTvCo4ZNwKH69G6TS+PpG8AJrXvcAvjiZ5fZa62mvhqSb+TokhutI5cd1OnH/nS7wj73HHF5ecoemjWhyxwi9eaLFTXm4H/+xr57qB9p3LTPIGtPhUNzc907Cpu0jShWYhxS4SilpcOdIsGtygAGU5nfTAMIGHEKhPuttAG5t2DBmWyedq8IRp9V3vA3eYCnvcyLVBk8ulYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(346002)(376002)(5660300002)(66946007)(3716004)(66556008)(66476007)(2906002)(8676002)(8936002)(4326008)(1076003)(109986005)(478600001)(86362001)(9686003)(55016002)(316002)(6506007)(186003)(16526019)(7696005)(54906003)(6666004)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 1afk0zCbBSXICs8zCKVxkytJAxp5nGLnVSN+zmous19ZE6kVffHPZYQsffP42aZTIYBdRMrfOto5b9I1NrR0Q234xyiCr7lVHcyQh21Kw+Hy/iseS4IvacDSjM6BIUjresInEkwGGKfp83xxK4V0cIDz2BvIfmJhIaOvX8/vQN51tq/s7gAdHn1ZX0vRx656oVsTfaTzT2gu0Tf/2knAna2ThqG7R/NOpi64EwAW/NxNQtqyYFtqrMlImDZDvVuPvdzJurYywxdikuoHRoej9RpMfe4io6bbzKPCYU/1yCugsmLDtLLbDq/uczEYunMCpx23FrwMAUCvTE/iYwah/a1Zkh0Ay2+WWVl6o1ZhtwtDGFmsOExTPEbncIFQlkJBZ6HSQGiABi/aVXTaqHYmYFEjFPSlNAprJSzRW+YrFIFSpdTy3rSdG1R8Wgs9DdFDlDyBxpKyA27GYkmm2ZzVP6YvaIfoXVNxeLbNiLyVEH8EPR1LUPSS+3iTT0oiA+dhe7IMS8uLIli9YOI7RsHCbRw3gfXXlZM2fhOeNTy0l6MjjHmc0f53WpsvRxAK8K+M1aPVXFCA0kgpEdV2KbRrvPSUlIb/4JxEo/EgQ2iRfnb87+ZVMN3oyQtozjR8d3yrMf/Hef0uwGyN2c9JJ760qLtckTHtAIgI/n+sJjyOFbs=
X-MS-Exchange-CrossTenant-Network-Message-Id: fc64b552-7c24-4a44-da23-08d8453a33bd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 18:52:35.3124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5URMSM4fXLKvQBXWYIJidzoGMPZFA0PwJIpIxmjebpU00KdiFSKhCbSp1axc5vF/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2328
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 suspectscore=1 spamscore=0 impostorscore=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxlogscore=976
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200149
X-FB-Internal: deliver
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 06:28:04PM -0700, John Fastabend wrote:
> Martin KaFai Lau wrote:
> > In tcp_init_transfer(), it currently calls the bpf prog to give it a
> > chance to handle the just "ESTABLISHED" event (e.g. do setsockopt
> > on the newly established sk).  Right now, it is done by calling the
> > general purpose tcp_call_bpf().
> > 
> > In the later patch, it also needs to pass the just-received skb which
> > concludes the 3 way handshake. E.g. the SYNACK received at the active side.
> > The bpf prog can then learn some specific header options written by the
> > peer's bpf-prog and potentially do setsockopt on the newly established sk.
> > Thus, instead of reusing the general purpose tcp_call_bpf(), a new function
> > bpf_skops_established() is added to allow passing the "skb" to the bpf prog.
> > The actual skb passing from bpf_skops_established() to the bpf prog
> > will happen together in a later patch which has the necessary bpf pieces.
> > 
> > A "skb" arg is also added to tcp_init_transfer() such that
> > it can then be passed to bpf_skops_established().
> > 
> > Calling the new bpf_skops_established() instead of tcp_call_bpf()
> > should be a noop in this patch.
> 
> Yep, looks like a noop.
> 
> > 
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> 
> [...]
> 
> >  
> > +#ifdef CONFIG_CGROUP_BPF
> > +static void bpf_skops_established(struct sock *sk, int bpf_op,
> > +				  struct sk_buff *skb)
> 
> 
> Small nit because its an RFC anyways.
> 
> Should we call this bpf_skops_fullsock(...) instead? Just a suggestion.
I prefer to stay with the current suffix "_established" which names after the
sock_ops->op that it is calling.  I think it is understood that established
sk is a fullsock.
