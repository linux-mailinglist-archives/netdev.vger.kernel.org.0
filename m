Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130F82100AD
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 01:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgF3XqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 19:46:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49700 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727041AbgF3Xpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 19:45:50 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05UNhcdt010592;
        Tue, 30 Jun 2020 16:45:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ieoP43FgRJxuqAZmzPI1FdRkfoySVEb9PChlXJK2JQY=;
 b=OxHKKuQLgiO+CiGrZm55T6E3oqfypbk/hd2XfhdLBCj8Lqw6fPpMg7XN2Ypc29sCcUJp
 kK8pB7ZLmRqUVzjfRJMDsIs1kaBQH1LIwN9+YalqUP+YfRmX3vEBTNVcespUk8wBDnsH
 3ShCgs/LB6nc+AznX3lcXhC9Nzrjz+eW37M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 31ykcj7kdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jun 2020 16:45:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 16:45:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2in21vjTY5r80znhF7tiBdzbLThWNvV/zUdIHqAPo2WQxAqdYrS9fvhHX3AAd7BGG9PRo2q10Ou1Ftz284J3A7L5F3hbdZLp7kuHA/3lvUtt06VDj1uj4bujSGOU8KeIzHSZtuV9X8B20zDXH66yruJAMXUvNod2auvAy9yunkia4z/OFTy+yaJCIhs/vTA9Ynapi11ElZ0gHSi6DaX2UgBThEDGLz2eV+oCUISENAUQflhQZ89cqHrVyEUT4cSb9w13OQQhMzB/cjfGHVZ89MLHb/GlJtmrWhScsDTvHPxigbvGRA2Bry9R1oBWL/nYlh01fKkl44p06zZm7R0kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ieoP43FgRJxuqAZmzPI1FdRkfoySVEb9PChlXJK2JQY=;
 b=PPB8N2C3SoTGIpyHrjfeGzKk9PWWvLDk1f6DaSW1zZw2cwUAx9ZvH7UN3dCQUSz5O67cpa1sgc8GDR6EOwtTLYXXdZ2i/I6oyCTMUupWreNK+YUuoW7mUkua/VXIdTstcT2+xtRLSOwvTsvoQUF/FlVVq2a8h+mJSUMAIVdzUJPWwHxj6SuF8jPHvdhoS1ZZBXigxYNsmOyunrFiJ7CQNF0YqIOpMqAVBlXH46i97p+d+UISn4NS+tirTcQmQwV+6KnUx3SRCq33PPpbT5PZXRX7yMwvl8sJw7J8PiCS/DATAOmmu/SnU14CLhLaE2pyegm35Xp/ThNiFgwYKVeVrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ieoP43FgRJxuqAZmzPI1FdRkfoySVEb9PChlXJK2JQY=;
 b=ft4pA5zjup80NQZ8m+UEEDHTCtLcaKamfuNy8GSIp8cTwpV0Fe/2ii4huA2FsEs2EIRJUIE2BSDIIvFMsUdo8UwRgZcD3cEotfcweTGa55TilgcHAFY7FlhwTXKdlE8PL17iaou90YQYrCPGCj9Hk4DSSd/4y3gSwU0GwsxkAvk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3526.namprd15.prod.outlook.com (2603:10b6:610:d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Tue, 30 Jun
 2020 23:45:42 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107%5]) with mapi id 15.20.3131.028; Tue, 30 Jun 2020
 23:45:42 +0000
Date:   Tue, 30 Jun 2020 16:45:40 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH net] ipv4: tcp: Fix SO_MARK in RST and ACK packet
Message-ID: <20200630234540.2em5gcjthb2lh3x6@kafai-mbp.dhcp.thefacebook.com>
References: <20200630221833.740761-1-kafai@fb.com>
 <CA+FuTSdbdmvsAZKwUW7AKwfGWDcs5Wff5GoksErzMcmC_2EwRA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSdbdmvsAZKwUW7AKwfGWDcs5Wff5GoksErzMcmC_2EwRA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR01CA0024.prod.exchangelabs.com (2603:10b6:a02:80::37)
 To CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a88e) by BYAPR01CA0024.prod.exchangelabs.com (2603:10b6:a02:80::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Tue, 30 Jun 2020 23:45:41 +0000
X-Originating-IP: [2620:10d:c090:400::5:a88e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 534cad9b-d3c0-4f83-3d8e-08d81d4fb34e
X-MS-TrafficTypeDiagnostic: CH2PR15MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR15MB3526F1AFEB93110842F108F5D56F0@CH2PR15MB3526.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: acwDtzUbKZIPmT8+1aXBUI6i3ealRC4VV4G9YBy2rE3ynh9nloe9lUlLCZTbrxNQNDH51VcSuBE3o2yzw/i2tBUJeBvxBJIc/2dVAaewoXWrej80jtEb91+PofkdIrpZkMCs7AMgbh6q5iJl6Z6l1rrH3OKFEZNgVj8HL6XwIk6Y8KCgu0ebUsFdEPkL2RU1SIhaJkjO1NcGNXYuvc7zvqJfPscnc94xxLvvhNdyAB8SB0A6VMi9TGLAxnjv7/VpG9AE0FNi6QfyaxVh/oDRD0yQk6vPxatmcSrTKH57LjpeNfirpBkl9d5o7H44O9Xg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(136003)(39860400002)(366004)(396003)(86362001)(7696005)(52116002)(5660300002)(4326008)(6506007)(2906002)(16526019)(53546011)(186003)(8676002)(1076003)(55016002)(54906003)(478600001)(66946007)(66556008)(9686003)(316002)(66476007)(6916009)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jnBUP2bG8K3HP34/aOsuSCRM9I33DkD8TzPnFRzaOaBWTJjWPo7Du3yWd2/GDE36CdT39qqS1b+S3V+NuQIGOWws5IDOhQTDA/cpPWEWrAO/pYmuwhZkh9czI6HuxnLWKljpnOfWrX8oOYT5pB1eB28DQvng7eIWgyzY47H+6kOB6uIrS3m8f70o903JgjHP0C/fsMv9sqCKpYA4G44dDvD0QKc5o0/XChnW6SljGQUsx1CG8lM/XuDuzgd0cBb1mmQcXyFIqeSFvldMcbg2TzZQetzuFL0kXJ3heK/fW0I/ASGVhxf92IWz8U5yT6ziabjhMVPIRiogCaUJzQmoo4BSYfxViXCiL4Ce7ymCcVLI6Ybr3wh5xhnjmvQMji2PfW/A42/MQBZp6MwWfjyM/jAISWsK5MkxqzrgS57GjlD+xVDl6OJnwT4QK0hq1xI30ireN4xm+Ntw3g2LoVczcDnOb6cGhpcB4zeZ22Vo3IPOkbuXbtv5eXZ4BhmPjou5Pml0kBME9nqDFv0CkGLT+Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 534cad9b-d3c0-4f83-3d8e-08d81d4fb34e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 23:45:42.2615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W6hbXDDuackViHu0H5xATyPRODXdO5Sxi8lL3u5a8cFy4vcNa7ltg7+pGkoRKmKG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3526
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_06:2020-06-30,2020-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 clxscore=1011 suspectscore=0 lowpriorityscore=0
 adultscore=0 spamscore=0 bulkscore=0 impostorscore=0 cotscore=-2147483648
 mlxscore=0 malwarescore=0 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 07:20:46PM -0400, Willem de Bruijn wrote:
> On Tue, Jun 30, 2020 at 6:18 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > When testing a recent kernel (5.6 in our case), the skb->mark of the
> > IPv4 TCP RST pkt does not carry the mark from sk->sk_mark.  It is
> > discovered by the bpf@tc that depends on skb->mark to work properly.
> > The same bpf prog has been working in the earlier kernel version.
> > After reverting commit c6af0c227a22 ("ip: support SO_MARK cmsg"),
> > the skb->mark is set and seen by bpf@tc properly.
> >
> > We have noticed that in IPv4 TCP RST but it should also
> > happen to the ACK based on tcp_v4_send_ack() is also depending
> > on ip_send_unicast_reply().
> >
> > This patch tries to fix it by initializing the ipc.sockc.mark to
> > fl4.flowi4_mark.
> >
> > Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
> > Cc: Willem de Bruijn <willemb@google.com>
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  net/ipv4/ip_output.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > index 090d3097ee15..033512f719ec 100644
> > --- a/net/ipv4/ip_output.c
> > +++ b/net/ipv4/ip_output.c
> > @@ -1703,6 +1703,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
> >         sk->sk_bound_dev_if = arg->bound_dev_if;
> >         sk->sk_sndbuf = sysctl_wmem_default;
> >         sk->sk_mark = fl4.flowi4_mark;
> > +       ipc.sockc.mark = fl4.flowi4_mark;
> >         err = ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base,
> >                              len, 0, &ipc, &rt, MSG_DONTWAIT);
> >         if (unlikely(err)) {
> 
> Yes, this total sense. I missed these cases.
> 
> Slight modification, the line above then no longer needs to be set.
> That line was added in commit bf99b4ded5f8 ("tcp: fix mark propagation
> with fwmark_reflect enabled"). Basically, it pretends that the socket
> has a mark associated, but sk here is always the (netns) global
> control sock. So your BPF program was depending on fwmark_reflect?
Make sense.  I was also tempting to remove the line above.
Thanks for the commit pointer.

No, the BPF program does not depend on fwmark_reflect.  It depends
on the sk->sk_mark set by a user space process.

I was also considering to do ipcm_init_sk() but then rolled back
because of the global control sock here.

> 
> ipv6 seems to work differently enough not to have this problem,
> tcp_v6_send_response passing fl6.flowi6_mark directly to ip6_xmit.
> This was added in commit commit 92e55f412cff ("tcp: don't annotate
> mark on control socket from tcp_v6_send_response()").
Correct. IPv6 does it differently, so the same problem is
not observed in IPv6.

> 
> But I do see the same pattern where a socket mark is set from a
> reflected value in icmp_reply and __icmp_send. Those almost certainly
> need updating too. I can do that separately if you prefer. I even
> placed ipcm_init right below this sk_mark initialization without
> considering ipcm_init_sk. D'oh.
Good point.  I think it will only be a few lines change altogether,
so it makes little sense to break up the fix.  I will toss mine and
wait for yours ;)

Thanks for your help!
