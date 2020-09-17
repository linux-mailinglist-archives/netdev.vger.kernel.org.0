Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13BD26E37C
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgIQSZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:25:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18198 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726381AbgIQSVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 14:21:20 -0400
X-Greylist: delayed 1160 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 14:20:52 EDT
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08HI088Q001442;
        Thu, 17 Sep 2020 11:01:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=jfiSI0BP6kJ4YMErJK6HEna4zPPbxGZGEtBHY6Y2OE4=;
 b=Vw+n7cYd4WTkNSHqijA7tg3Y8FpJBCboNa/bUyOYiO/8668nrV3kGsYVTet8g57DeoBm
 wmRUq8unzlHqIoUA0Msx21d5C9Yeq26ifYskO/2sgNSQWUslObN99WOu1669U0BxW8Qe
 izlvPnzGFQJ1YTu7sT5BoMI51EZ7IAKo9+U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 33mc4r86nx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Sep 2020 11:01:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 17 Sep 2020 11:01:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRn2YfgNDHVq1zZ60tJ+ESTgCLu1GsNg0yFXDc35lORNhKmKVQEMH1nRFgS3etY0MRh++5/aQ68JMX5WTpr4r1klhik6Ht1pbeLDidXYdZcoSnc68muBEUeEst7OvKSSaLPwblBhtGIZE5LWp2+/4+etRyohbWofdgm7Bapi2+3oqmhNPkYmAlx0gx46efD8SFzY9cXW6xbh0U91p7DLqvBQYF7ROtb6E+yPENouVfx1Wro9SKMckBajUP1IOddDhr5UqTygP2vYHmzrTgMt5JlUTBF+brN1SRUTDJ3wroy0MNkiYmJRUi76Te1kqNhONYPj7li4HGaE0Tyrxbw8+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfiSI0BP6kJ4YMErJK6HEna4zPPbxGZGEtBHY6Y2OE4=;
 b=dp8jc6IUE3BkEadlGGLSTers9Ci7ysFQ2LFn+mKlHLab8Go91et76FwUp7RoZpmJX40XJShfxWHc32fWoRZIIFpu0QNd7Md+Zk/UYdS8cefZTU/11HyiXZM8FRlduMJfMwRWpp4MntlJFZJfwLLeWS5z56oZbkU87UuozTvl+kZCGClGbpUZcjVlceiiv7PEaBCwC+wjUa/sUo3NLUwVbPIvyrhzDiddgY3dTk3H4nwY2hMFOIPYOwdcG9gBTzypTDvsZyooqqrTlWEQ85iwGoVMQR1KztWprj9ChbY8Qwka3pf3mTu/IMMBRoboy7DAWNQTRQs4A+tEdUn09kPfbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfiSI0BP6kJ4YMErJK6HEna4zPPbxGZGEtBHY6Y2OE4=;
 b=acaEmm21bfz+qqRvvT1MmbFTv0LXgvLO3s2+MsySzy4ZzLdCb6J/8bijl3cOhBslEhCJsdlF2Y0JvRDIPPJM2sIr3yZ5DwAQqhUzPgg5CXnumJVdf6sxP0ZFGQMTmoxOoLtgaa4Cc+WMah7JQMCu4IOztEGrtZyVwGZUfLYV8Y4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3716.namprd15.prod.outlook.com (2603:10b6:a03:1b4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Thu, 17 Sep
 2020 18:01:07 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3391.011; Thu, 17 Sep 2020
 18:01:07 +0000
Date:   Thu, 17 Sep 2020 11:01:00 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf: Use hlist_add_head_rcu when linking to
 sk_storage
Message-ID: <20200917180100.3tm4dcafwqtjtl6n@kafai-mbp>
References: <20200916200925.1803161-1-kafai@fb.com>
 <20200917174739.wbwiayb66aemydc5@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917174739.wbwiayb66aemydc5@ast-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: MWHPR1401CA0006.namprd14.prod.outlook.com
 (2603:10b6:301:4b::16) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:af24) by MWHPR1401CA0006.namprd14.prod.outlook.com (2603:10b6:301:4b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Thu, 17 Sep 2020 18:01:06 +0000
X-Originating-IP: [2620:10d:c090:400::5:af24]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d9e1f01-4771-4ce0-9062-08d85b33a6db
X-MS-TrafficTypeDiagnostic: BY5PR15MB3716:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3716B47D5B766B4E1857ECEFD53E0@BY5PR15MB3716.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5bfKuXHrmsKvrdYXbLrPecbFHDywmrh75QcPOcVaofBITKCk85XMIU3lsNy9PWeNiCETw1nJW+QzuAlbM0ilrQJWoDUYDTxlSx6IUWNme19sQcq7fa0u7EBBKVa2933J0ip4SoPR+foTHj5mTMR5cvvcaMFNSj7iwmTgx1jsK7jFwHpI7w/0F8XcheTKfQCQ5iScFXA4Dk4eSOAHUp8gPuD3xwWmTh11dIy5vOOgtmRyYummNTJrXSUdHX9xEai7m2atkDtSgQ/T6Qdw/+OtPT2JP3fZNRIXmQM/WulfBVf4cYSNpD9Zu0OBd1ktOuxVSp35Sax/S1QrnHHFAiFiPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(376002)(396003)(346002)(478600001)(16526019)(55016002)(186003)(6916009)(83380400001)(54906003)(6666004)(4326008)(86362001)(316002)(9686003)(1076003)(66556008)(66946007)(66476007)(8936002)(2906002)(33716001)(5660300002)(8676002)(52116002)(6496006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 8/slhXGCWdHMYVcx6HSGvtPk7UQz1rowRzI4SoDV9j6vP6XhBJW1in4PRynutaTm6GTzDKehQ/N6wAKI/HHZ5v3sous+o407jAP0ZiAaEdyW4mXP4R9KomlDpM/RdV48Ujo3Z39XPI65vv8Ibk/Sb6X6UJW259F5VLohuRhXEuUjxInZ+p7Si5cpBvQ5xD6e31VJ8d6JI4Hyde6NAmbWnC32T1X6Bwk67ScypF6WPhKez1nCX8wWnjDPZl23hYoUlOUAMYNYtyQMPINWiI/TLJ5f8Gx6B/1xP1UE0SjGsf93Xxalna1AO4wfYhFlyVY6lUd1m+prFwp0+abYufYdeV0jMnVYPux/GRjdd3fqvjiPgWrR7J8IbVScR4HJJy1rX8ass9YAhJyz5Vp79XeZoYJD82Pv6kYM1v37CkdGpG2R0H0Euy5OXO2G3QRV1ECcAKMyUZMdg1zn0t+phAsu5uCzKUFDLHEmaAR1CDAgapBspRFr+efsX6+y41cn5M+lUWZYdl0CL5TtfY1sm7pQwHjCv9233sHqY8UGSus1eV/ZKMlpjZ97Q/C7XvbqfVqeMTmdAlWeeutWIg6lqMJR68VQzeN/LkOsJqG9gTUCjrCPP/wTQtdUQ5QOtotFApngXeY4sgKe6pJ2R7Ape0mLpcCRtSWYuKtOsA/TkpWsopQ=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d9e1f01-4771-4ce0-9062-08d85b33a6db
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 18:01:07.5581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJFT4cOelTAEugf6RUrYBtC3WaF4oqL1lPQ0YN+IwtNYp0bxj8I35VRZFpWyh3rS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3716
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_14:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 suspectscore=1 mlxlogscore=999 spamscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 malwarescore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170134
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 10:47:39AM -0700, Alexei Starovoitov wrote:
> On Wed, Sep 16, 2020 at 01:09:25PM -0700, Martin KaFai Lau wrote:
> > The sk_storage->list will be traversed by rcu reader in parallel.
> > Thus, hlist_add_head_rcu() is needed in __selem_link_sk().  This
> > patch fixes it.
> > 
> > This part of the code has recently been refactored in bpf-next.
> > A separate fix will be provided for the bpf-next tree.
> > 
> > Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  net/core/bpf_sk_storage.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> > index b988f48153a4..d4d2a56e9d4a 100644
> > --- a/net/core/bpf_sk_storage.c
> > +++ b/net/core/bpf_sk_storage.c
> > @@ -219,7 +219,7 @@ static void __selem_link_sk(struct bpf_sk_storage *sk_storage,
> >  			    struct bpf_sk_storage_elem *selem)
> >  {
> >  	RCU_INIT_POINTER(selem->sk_storage, sk_storage);
> > -	hlist_add_head(&selem->snode, &sk_storage->list);
> > +	hlist_add_head_rcu(&selem->snode, &sk_storage->list);
> >  }
> 
> Applying the same, yet very different from git point of view, patch to
> bpf and bpf-next trees will create a ton of confusion for everyone.
> I prefer to take this fix (in bpf-next form) into bpf-next only and apply
> this fix (in bpf form) to 5.9 and stable after the merge window.
> The code has been around since April 2019 and it wasn't hit in prod,
> so I don't think there is urgency.
> Agree?
Yep, agree. 
