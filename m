Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C9E21016A
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 03:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgGABW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 21:22:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7634 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbgGABW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 21:22:56 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0611K8VF029680;
        Tue, 30 Jun 2020 18:22:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=XOESMgVB+R5AU0ksrIO2tOBdNLKL9LYMwJTZ17gv7s8=;
 b=ZCGdvHwAbPm2Ws1xAz7giFBhEfnnU1Tmcvq3/0egi4+D82LeqmNjlJfVtm8tD+UkADlr
 pgjStvZDYSO5kghb8TxQGoM7mwQCCo8FE6M+0XjCK2DxNp+fV5RmAY/SrRZw8e0elv+a
 M8D4rguUw5cZStIbyAbXRBFjvYeImrdCC6I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31xntbw249-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jun 2020 18:22:54 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 18:22:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KU3a2TkI5eypzDUVZTVQrGRzHWNb5xsP+1ODmVHCSV7BWv4Jsk0YE2YlML8HnPOVEUkg3Ut59UPji+WQO0NPLJmZjSxrmb7pKbcIe6MHL74D6tp4X4LGRDG/2UbNSxt8OS1MCafgmrbu58O0CVlC3Fxoo1uqtMlxxStcGwUIZVa1saZK+FD5VVqJeOaRzoLWIoXG0+7MkLNQ8Mg//maWQkl2qKurPEyvBFFrVrP4s5DHl0mzVcq13jJ+vBTAyZxg3GzVugkQdDvuFyr+A45B/WuBXQmkynLEuFSEGr/AZCcmbj6kwWnerocPIVSJ3nLFEbdWpMFmtTDJAXBh7z4dqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOESMgVB+R5AU0ksrIO2tOBdNLKL9LYMwJTZ17gv7s8=;
 b=BmpQ4wWcV8HwOmMVcO3US+y0qxkFrTVvmEkurI25vCsaBToRKP0TdXialCe3WcUkDOQgvHUwf/A2Lk+GYmxo7fVB8hsv3gzQTQ4dojSOrTV9mSFzbxOu7KhpJjJDnmbZvw8uZBkFs8zoMSyfbS1u5pY38bqZWpV0x5XCdDnaNhc7Qotiy5ZmMJk1AzZQdq/Z8aM3V5GWUI2oztobc4nm2EwG1BAHTiZsd41nddrHWHlJ0IE/skaGMAih3AFdFaj03UzsmtqJaRXB4abpvb6DTFTW3GGz17I7RvJXGHb4IJUbnkBep6iXB3UVT7bpiLPjiru5lpRK1s2XG5YlCg/4LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOESMgVB+R5AU0ksrIO2tOBdNLKL9LYMwJTZ17gv7s8=;
 b=C+q+EZIYreS7ADVwee9UmTOEcp3FYI8363KCfgaFERLs1nbjXhuk1qDA3l9+LRhD3ZDLXItBifFVARPQyyNTyUlhsr6Xwa8rJoJg8ccGQTQrV/Tq4FveI6yJk4l7+mRHbRIBBNpLWsa5Pv4lhj2hatX3h0C1JUZYxTrvCowcFdM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3575.namprd15.prod.outlook.com (2603:10b6:610:2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Wed, 1 Jul
 2020 01:22:51 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107%5]) with mapi id 15.20.3131.028; Wed, 1 Jul 2020
 01:22:51 +0000
Date:   Tue, 30 Jun 2020 18:22:48 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH net] ipv4: tcp: Fix SO_MARK in RST and ACK packet
Message-ID: <20200701012248.7t6tif6mspaggy7j@kafai-mbp.dhcp.thefacebook.com>
References: <20200630221833.740761-1-kafai@fb.com>
 <CA+FuTSdbdmvsAZKwUW7AKwfGWDcs5Wff5GoksErzMcmC_2EwRA@mail.gmail.com>
 <20200630234540.2em5gcjthb2lh3x6@kafai-mbp.dhcp.thefacebook.com>
 <CA+FuTSetERjsvP=M1VhQeMZ7W_L4PjCM19URh4fA+PwSJu1rdg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSetERjsvP=M1VhQeMZ7W_L4PjCM19URh4fA+PwSJu1rdg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR21CA0016.namprd21.prod.outlook.com
 (2603:10b6:a03:114::26) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a88e) by BYAPR21CA0016.namprd21.prod.outlook.com (2603:10b6:a03:114::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.0 via Frontend Transport; Wed, 1 Jul 2020 01:22:50 +0000
X-Originating-IP: [2620:10d:c090:400::5:a88e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c23426c-b975-47c0-de2f-08d81d5d4587
X-MS-TrafficTypeDiagnostic: CH2PR15MB3575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR15MB3575888692C6F1EAE432C31AD56C0@CH2PR15MB3575.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mysWOSuliH1111JqYmF3BKRVt5aa+tQy8pERY/CDCAAJvpkzllEjQzjNIKrFLSfsfC/2mDHOHikLdZ0GtyjUNMM/4OXK02CIO0qHaJY/9PEW20ZTL6sFN4Oz1Npx7tXO3SN+qvi51rpYgCd7HyZ/OgokKgLzGhsxStW9Flzb+MZZKQ83GPEUwNaPUWLYnd14N8VdrNpkF5nIg7bvgzcxYwPasc49cFAXDC3UsEPqc3+VbhIsFwgaEHQ5m+6JxddaXPrh/5+NyqlXufQBbKTo2knde8X2oedcdzss4Rj1TCwzq5vy6tbaKx4pQaCB1kFE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(346002)(39860400002)(396003)(136003)(55016002)(478600001)(8936002)(4326008)(16526019)(2906002)(1076003)(186003)(83380400001)(86362001)(9686003)(316002)(6916009)(66556008)(66476007)(8676002)(54906003)(66946007)(53546011)(6506007)(5660300002)(52116002)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: zvdZhyud5EZXIe7Xq4gkJo+eOWjQyq8rzsGuatbgKYdJlfKZ0O/V8KqDtHGbCsGchlq62iR33sgkkpWOm1d5HvQq9Ldd5rE6Gk7/WcxHFqY0ovJeq/Q+0neW8TZMutcYrGgyPWtvUFr0UlM6SRyK26N8LFHwpktpr3LgFiNksKiMOTiSOdxNW+XaNrvCk0vCEMzAvQU4iDlOPjEjAQlN9AetV8fsXt4ebDIawXVIuAg5CrWNcSfRdyQjd++jvZzykRdbeEe2546D7HeHqkxoMs2sfdtxvwyJwFNDqTD3MtPWoO+C8IKWRIps08GikBaL8OYopO/wslV82FN3A6sd85AN6/uLv0yff4kGD/4pzcpnD4zJjmlE1tXxRBzXLOjUjAHLZ3xa6qMLUQ2jsv/njfr/h8R1sVVAwrmLPJSw6A2z5wM3MrNLg/IQyOj2CygBBVxv04FJsTfiesLAnTAEiQw2/oTXUnkZsg/9rDNaA/1NVSwqB3MSrVN5XJTr3+3eVvZRuTTRYVQGlzWN21Me4w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c23426c-b975-47c0-de2f-08d81d5d4587
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 01:22:51.1249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BNL4QbfZuc/djcHdCAnL9dIPpbZsHalWCG/YxX0xvOCM43TfTjOm5kuW8g+xRBcp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3575
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_06:2020-06-30,2020-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 spamscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010005
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 08:45:13PM -0400, Willem de Bruijn wrote:
> On Tue, Jun 30, 2020 at 7:46 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Tue, Jun 30, 2020 at 07:20:46PM -0400, Willem de Bruijn wrote:
> > > On Tue, Jun 30, 2020 at 6:18 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > When testing a recent kernel (5.6 in our case), the skb->mark of the
> > > > IPv4 TCP RST pkt does not carry the mark from sk->sk_mark.  It is
> > > > discovered by the bpf@tc that depends on skb->mark to work properly.
> > > > The same bpf prog has been working in the earlier kernel version.
> > > > After reverting commit c6af0c227a22 ("ip: support SO_MARK cmsg"),
> > > > the skb->mark is set and seen by bpf@tc properly.
> > > >
> > > > We have noticed that in IPv4 TCP RST but it should also
> > > > happen to the ACK based on tcp_v4_send_ack() is also depending
> > > > on ip_send_unicast_reply().
> > > >
> > > > This patch tries to fix it by initializing the ipc.sockc.mark to
> > > > fl4.flowi4_mark.
> > > >
> > > > Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
> > > > Cc: Willem de Bruijn <willemb@google.com>
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > > >  net/ipv4/ip_output.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > > > index 090d3097ee15..033512f719ec 100644
> > > > --- a/net/ipv4/ip_output.c
> > > > +++ b/net/ipv4/ip_output.c
> > > > @@ -1703,6 +1703,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
> > > >         sk->sk_bound_dev_if = arg->bound_dev_if;
> > > >         sk->sk_sndbuf = sysctl_wmem_default;
> > > >         sk->sk_mark = fl4.flowi4_mark;
> > > > +       ipc.sockc.mark = fl4.flowi4_mark;
> > > >         err = ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base,
> > > >                              len, 0, &ipc, &rt, MSG_DONTWAIT);
> > > >         if (unlikely(err)) {
> > >
> > > Yes, this total sense. I missed these cases.
> > >
> > > Slight modification, the line above then no longer needs to be set.
> > > That line was added in commit bf99b4ded5f8 ("tcp: fix mark propagation
> > > with fwmark_reflect enabled"). Basically, it pretends that the socket
> > > has a mark associated, but sk here is always the (netns) global
> > > control sock. So your BPF program was depending on fwmark_reflect?
> > Make sense.  I was also tempting to remove the line above.
> > Thanks for the commit pointer.
> >
> > No, the BPF program does not depend on fwmark_reflect.  It depends
> > on the sk->sk_mark set by a user space process.
> 
> Then I don't fully understand, as ip_send_unicast_reply is only called
> with the per-netns percpu ctl_sk.
Before this proposed patch, my understanding is,
the ctl_sk->sk_mark is correctly set here in ip_send_unicast_reply().
The ctl_sk->sk_mark was actually set earlier in the tcp_v4_send_reset().

However, ctl_sk->sk_mark is not used to set the skb->mark.
Instead, cork->mark is now used to initialize the skb->mark
in __ipmake_skb().

The cork->mark is not properly set in ip_setup_cork()
because ipc->sockc.mark is 0 here which this proposed patch
is trying to address.

The call stack is something like this:

tcp_v4_send_reset()
    ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?... /* <- sk_mark is set */
=> ip_send_unicast_reply()
   => ip_append_data(..., &ipc, ...);
       => ip_setup_cork(..., &inet->cork.base, ipc, ...);
          cork->mark = ipc->sockc.mark; /* <-- ipc->sockc.mark is 0 */
   => ip_push_pending_frames(sk, &fl4);
      => ip_finish_skb(sk, fl4)
         => __ip_make_skb(sk, fl4, ..., &inet_sk(sk)->cork.base);
            skb->mark = cork->mark; /* <-- cork->mark is 0  */
