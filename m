Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A32FE17B464
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 03:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgCFCWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 21:22:37 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44486 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726178AbgCFCWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 21:22:36 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0262G1OQ008859;
        Thu, 5 Mar 2020 18:22:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Mp/1lQJtzXVINzsbfr8kALKtjQcBVu5sDXErI8SIq2U=;
 b=avREyIi2vpTR0GskRVXXOpJiKWxwyKa5+UfKrR1JMovcvlevrU7uy7OcHYGqM1KQxRer
 zwrY88V12Veu+RVgZ7x0ha0xMwxTxmqSIlDqBsYxbgQfO8Ut+3WNoQQW6uXRX1uLEl8u
 0ruZNjC1KJoXGwcLiu1r2u5benyYWiOInEE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yjk74ye8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 05 Mar 2020 18:22:04 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 5 Mar 2020 18:22:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNlSR53fRtcNZrkKBz6oByyMr26AxfOgKlGnBkKHnCPMtD1zZjWvSqfrwplNiGZmjwSR7qTokxiiPmexNe1EUJZe+dL+Vwh++XGyE6K9o2ctPEfQ0lzW7u1ygUxRayvDcvBobvOSMHvtwgcC3p37XJenpEoNa5htvBFmbYLKj5SVCuLNIzpKyc99O/EkWcqgOxKoNLFLZeuYlyCNERHp0d/YlnEeXvnGFpcPLd2yKnnw9h9s9AON+nbGzrlLboT878Yms+w2DojSjNRV8qUXPSGxGQ08DKpem179m9dUX6kzMTfSaxeyD0vbeVM6AmZ1FTX2pN3/bxxYg8HTDfhPbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mp/1lQJtzXVINzsbfr8kALKtjQcBVu5sDXErI8SIq2U=;
 b=IY5N4XlYiHUi7FEqdsKuKzVDNezhKoEi0T+NAMIDnyUoyM9ZJSFEqwNPhr7Q+9yrYjjEXIVyGIkqifz4BMCsxzqhrxFXCIH9C5Dy8TZxJUcaGUXRdRyoafOzLw/k+9paAmgqiQUtYbl5edkOMlXAJM+OCvq1LVKMmirkPWKQIKOodppYfn6LseR0XGPOsliHO6DLbJaizcxUxJeNmw1Ja9rOKSlYoBaxvclnRvqwrwlMuwOK+1qxfLvpeu1vPbYWqeuTSIuHnmmkw1dTM50fS+XTee2G5TKnV3/ljMWJ3kkgycS4jOrdvCYxsAJGqT18tloe8aTc2urJLx5oj2fiyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mp/1lQJtzXVINzsbfr8kALKtjQcBVu5sDXErI8SIq2U=;
 b=DvqdHXaDP1jCaE9I3yAMp9KSL9ccvoHhRmr4evrHQD6mheSjU5OCVcRZBonsHbFpZ4bCsuP57z3HGWitmv+L8kslPEaBiFsBfSo/QOQ1KGLKbaGgCSU2VsaSGSTc3iRCCcAPaYiLnQloMR5AGtevHnAS/tTieLUwfE5vw7maMqk=
Received: from MWHPR15MB1661.namprd15.prod.outlook.com (2603:10b6:300:124::23)
 by MWHPR15MB1790.namprd15.prod.outlook.com (2603:10b6:301:53::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Thu, 5 Mar
 2020 22:45:48 +0000
Received: from MWHPR15MB1661.namprd15.prod.outlook.com
 ([fe80::90a5:3eb0:b2a8:dc5e]) by MWHPR15MB1661.namprd15.prod.outlook.com
 ([fe80::90a5:3eb0:b2a8:dc5e%11]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 22:45:48 +0000
Date:   Thu, 5 Mar 2020 14:45:44 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] net: memcg: late association of sock to memcg
Message-ID: <20200305224544.GA1092120@carbon.dhcp.thefacebook.com>
References: <20200305205525.245058-1-shakeelb@google.com>
 <9505d35b-f9fc-149b-6df5-e65ad95acabb@gmail.com>
 <CALvZod68Raqfa2ZJOfF_OOQdb-hxkOs54G5KK3VQnUdxiZ=KTQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod68Raqfa2ZJOfF_OOQdb-hxkOs54G5KK3VQnUdxiZ=KTQ@mail.gmail.com>
X-ClientProxiedBy: MWHPR01CA0027.prod.exchangelabs.com (2603:10b6:300:101::13)
 To MWHPR15MB1661.namprd15.prod.outlook.com (2603:10b6:300:124::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:500::6:48b4) by MWHPR01CA0027.prod.exchangelabs.com (2603:10b6:300:101::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Thu, 5 Mar 2020 22:45:47 +0000
X-Originating-IP: [2620:10d:c090:500::6:48b4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 800c2384-4534-4115-ef7a-08d7c156f2a3
X-MS-TrafficTypeDiagnostic: MWHPR15MB1790:
X-Microsoft-Antispam-PRVS: <MWHPR15MB17908BE18B0F1013A1A6E265BEE20@MWHPR15MB1790.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(376002)(346002)(136003)(199004)(189003)(8936002)(9686003)(55016002)(7416002)(6916009)(1076003)(86362001)(4326008)(2906002)(52116002)(66946007)(81166006)(81156014)(5660300002)(7696005)(6506007)(316002)(53546011)(478600001)(66556008)(186003)(8676002)(33656002)(66476007)(6666004)(16526019)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1790;H:MWHPR15MB1661.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k15srNGbHOJj3rjwNPD+tFPbVF7geOq/KrZ4yxA/WMoUirt24rsJCUNwhQ3tpBK9kcDhtDxhfOExH+ikHRujQbSEnNtR5Cvmqu/xgOGwC+QO1ekfxKJEv+siI4Bf3e323UnvPAq/w6m10O2WuAF9TkJl84w3HSeLHaGNGW6BoEqQgLN7QZNOydIX1lPRt46525S291j9EXxWn+6e5rZEr2rJK3tUitdU1ikY1J696QgvU07VspY0l2smBu/kh7ep2DtzxUPSF/vfzfi6wVOw5ktJWsbfXK4GorMo928pBRRmNWbmKj7uuEU1AevcOeKj2a/ElkeMw964QBJfFH3477kZUlZ9v7V+/zxk1fzXLnw+1hJMGohM3Hvpi5QeeoGP8KNs9HnqUFJHLzuE01CiiS39/A+KJpw1W3BlCE2K8bP2yCTTn0RdxEd6VxIjsFpG
X-MS-Exchange-AntiSpam-MessageData: /0FtUZouI7L/nWCc3fWAa0HA5wp9RgP7EcB6ixjugoDFMT+yUKHxpZpyOQF4EoH7sNtZ3qM3Hzf51+INdPnWGqi/fjrY6wwzON0aJqI3Eu5oBZ/nieN3FOKQ3ObyJsekhq+uta6AMtFXVuE4RWNagKj92fqGIzmeQLPLMRbECr7Q7f49t5MbUe3DkbmtfQgc
X-MS-Exchange-CrossTenant-Network-Message-Id: 800c2384-4534-4115-ef7a-08d7c156f2a3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 22:45:48.1851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kuOqZwSFHTIXI2AbY/gGYlsLOD9xOBqscJB+N0nXwAJpgsGbLoO0OQYsCxrrtb6K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1790
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-05_08:2020-03-05,2020-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 clxscore=1011 lowpriorityscore=0 phishscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=5
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003060012
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 01:59:37PM -0800, Shakeel Butt wrote:
> On Thu, Mar 5, 2020 at 1:17 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> >
> >
> > On 3/5/20 12:55 PM, Shakeel Butt wrote:
> > > If a TCP socket is allocated in IRQ context or cloned from unassociated
> > > (i.e. not associated to a memcg) in IRQ context then it will remain
> > > unassociated for its whole life. Almost half of the TCPs created on the
> > > system are created in IRQ context, so, memory used by such sockets will
> > > not be accounted by the memcg.
> > >
> > > This issue is more widespread in cgroup v1 where network memory
> > > accounting is opt-in but it can happen in cgroup v2 if the source socket
> > > for the cloning was created in root memcg.
> > >
> > > To fix the issue, just do the late association of the unassociated
> > > sockets at accept() time in the process context and then force charge
> > > the memory buffer already reserved by the socket.
> > >
> > > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > > ---
> > > Changes since v2:
> > > - Additional check for charging.
> > > - Release the sock after charging.
> > >
> > > Changes since v1:
> > > - added sk->sk_rmem_alloc to initial charging.
> > > - added synchronization to get memory usage and set sk_memcg race-free.
> > >
> > >  net/ipv4/inet_connection_sock.c | 20 ++++++++++++++++++++
> > >  1 file changed, 20 insertions(+)
> > >
> > > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > > index a4db79b1b643..5face55cf818 100644
> > > --- a/net/ipv4/inet_connection_sock.c
> > > +++ b/net/ipv4/inet_connection_sock.c
> > > @@ -482,6 +482,26 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
> > >               }
> > >               spin_unlock_bh(&queue->fastopenq.lock);
> > >       }
> > > +
> > > +     if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
> > > +             int amt;
> > > +
> > > +             /* atomically get the memory usage, set and charge the
> > > +              * sk->sk_memcg.
> > > +              */
> > > +             lock_sock(newsk);
> > > +
> > > +             /* The sk has not been accepted yet, no need to look at
> > > +              * sk->sk_wmem_queued.
> > > +              */
> > > +             amt = sk_mem_pages(newsk->sk_forward_alloc +
> > > +                                atomic_read(&sk->sk_rmem_alloc));
> > > +             mem_cgroup_sk_alloc(newsk);
> > > +             if (newsk->sk_memcg && amt)
> > > +                     mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
> > > +
> > > +             release_sock(newsk);
> > > +     }
> > >  out:
> > >       release_sock(sk);
> > >       if (req)
> > >
> >
> > This patch looks fine, but why keeping the mem_cgroup_sk_alloc(newsk);
> > in sk_clone_lock() ?
> >
> > Note that all TCP sk_clone_lock() calls happen in softirq context.
> 
> So, basically re-doing something like 9f1c2674b328 ("net: memcontrol:
> defer call to mem_cgroup_sk_alloc()") in this patch. I am fine with
> that.
> 
> Roman, any concerns?

Nothing at the moment, I'll try to give some testing to the final patch.
I hope this time it will work better...

Thank you!
