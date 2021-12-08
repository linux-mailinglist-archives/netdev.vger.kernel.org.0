Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4D146CB21
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 03:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243394AbhLHCuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 21:50:02 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59652 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243340AbhLHCuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 21:50:00 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7L6AZB009717;
        Tue, 7 Dec 2021 18:46:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=5FtvHL0AJGNAotoQXcFz04cSSdInxVXqxDTbDlNILqg=;
 b=FcD1uetuzlz25oNl+Vu69Suy56raYN1WfXTxcCS7oGbzb1+ljjd9psjDcp5VEhq3HeR0
 1rbYLHEZFJv3wwwEe4QfegoHjNG95KZ7wpijrGFLjse9DHF+n3RmxFcvDgSxgCPSgCE/
 28cCvMpXVWczECRRC6Gsr2zgNfeNofdg0Rc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3ctf7thufy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 07 Dec 2021 18:46:05 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 18:46:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBAqK5AvtKwWpDkyoMxOFLuXkLpiurf3sVRItJ2GUJ8qECAliLnAwcF8tWeu7djFeCMBI6JSCA1+6Dm29lBlqs+61IEW1qw6jswC9Wik1uxcWEcAHdcLuCYA/yOhICN3duv1RtDunGfhHUCC6GAbR+wjf6Rtwyx+Vk7LDyfpTp/HZTrHMZPMcFFwvnpNneOzqqu+BQ1wVJVn12xqdZ3izcxoJkJuhWxO3tkxawLQVJ3P3VG5g4RRhEQHeweu/v3XWGEtE9p5k0jMgmOwI8627D8WUFaQu+A0QQFeYod0gZGtmXsC3knxn/BAcmcwOmQ++IDh89IZuVSRnYbAzmYiqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5FtvHL0AJGNAotoQXcFz04cSSdInxVXqxDTbDlNILqg=;
 b=MtdSOSUVd4J5fpBiGjCCxwkBe8G5gwtRXjxGjSPXlElNytb00fzJ3rr7/xWJ7wC9nlzXkBgKc478I3ispNvj/8UoHoU5+KLKuJkLlDFp23mMVPlnylqvpjtJnVKVGs7grr65Xl81+BoP1ophL/6N9WFU2VegzYI2svpjgRCcKx1QkLWUkRyhU088H1ADeVknMhT6H/SCX2g0e8zyHQr2wJb4p4I0kV9Pr4lWMhw9ZbAeR30SkAQA7CtIEh1ftQHbVR1LX14h2G6xx1FDcDfHZjFgRGVohz8UcZlK8DOr52qDd4zCtW5CfeL0e3OGELwBRVa/604JaioNtXI5lpvaUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4888.namprd15.prod.outlook.com (2603:10b6:806:1d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14; Wed, 8 Dec
 2021 02:45:58 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 02:45:58 +0000
Date:   Tue, 7 Dec 2021 18:45:54 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
Message-ID: <20211208024554.ol3y2dieuzcnevyf@kafai-mbp.dhcp.thefacebook.com>
References: <20211207020102.3690724-1-kafai@fb.com>
 <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
 <20211208000757.c5oshpdxud6rbzuv@kafai-mbp.dhcp.thefacebook.com>
 <CA+FuTSfBTQ+G3i6j8LPi7PHZWnSx5msdMYoUURdp5Z2d3S6gDA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTSfBTQ+G3i6j8LPi7PHZWnSx5msdMYoUURdp5Z2d3S6gDA@mail.gmail.com>
X-ClientProxiedBy: MWHPR21CA0029.namprd21.prod.outlook.com
 (2603:10b6:300:129::15) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:fdb2) by MWHPR21CA0029.namprd21.prod.outlook.com (2603:10b6:300:129::15) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 8 Dec 2021 02:45:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28b170f2-dda1-463c-f0e8-08d9b9f4dcd5
X-MS-TrafficTypeDiagnostic: SA1PR15MB4888:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4888BBFFB70772EF981E3ADBD56F9@SA1PR15MB4888.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zeYKrJWdkFDrdqaUFBNCpvaHygPq3xFiUHUl7W9y/qe/QBIIaoGwKLN0Sbfy4I6uH6illOsbaxeW28iEtR5RzkOx21uZaOVQzamWSdkI/B9CCwEAo/u654T59I8jmdRtd1UjWZflsmC2t3Ugv9t8cutoTYOYo2VdzxMIoukYunxJgPPS6NUHxJoOPjRuJr+uKIBTgFHoiYgc41UZiQB3O5waY1aP3MniVwU0hp7YgWBbvKclp7B7o1juVMpvEdBfKJC+B15JvkKgGC6teCg6+6onOeaSNBAx6EYPifeh1l13+ullShW5AbmgmN8XIOeQ8s/o8udEBOjAoJLkEgOBSZORQ5C/CFMM66f5vMQnMsO5uxtVnlxgM54wbfQUk5lzjdKg/BLbW6QQUhVrNjEchRidUl+cBtMabNXTPjFtJSAxPvXDU8Eh7qfyPPxKELzMOrV34/Kb/jhXPHqoyuHtDrCXrk6os9v1+CbwJTAyWG7a+9+s2QRvMq4x5kMHwEX2fYLUsSvW2pUZVlZnWHGTHXgdfeKZ3ce3ivAAZ4al9BSypa7fkz487xAkTx7D5zQ7i4TyrGvdKdkG/5yilAYtdYcEwxDXMaJMqPHDIU74WN/aZHxgxdy+ddc/uAp7/ThPNnmbE9gTCcyZrpFM63t22g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(52116002)(66946007)(8676002)(86362001)(8936002)(7696005)(1076003)(5660300002)(83380400001)(508600001)(9686003)(4326008)(66556008)(6506007)(55016003)(186003)(66476007)(110136005)(316002)(54906003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8AIWh8XvwOciaPfhXmx6WeMcBb7mmhPH5RSYxJBlJ9+EPNpFilByl3UHrF6L?=
 =?us-ascii?Q?HkXlctvZjaqkl9bHNEjoi3fdg8DRdrY9JB6jUdi9SAVrn7LPc2qYsfHdCACl?=
 =?us-ascii?Q?nD81a7zC6PydSsq1W2dvka7Ltuhix3/hgPR4z24HnPPkBjiI83dFc5TzOLGt?=
 =?us-ascii?Q?hxYnHn8/1yBWSx97K97Ag7+nApaTycRxqnbkCOrqnVvx4Hq8OE+BlEjrqKkE?=
 =?us-ascii?Q?W53xK4LLkAsg16grJQOAukaPJaq6w2q5vFdSgKHxTGYJoB6TFrlor5yAOl00?=
 =?us-ascii?Q?b+naHLN3j2m7KTZmWijnxZLfK3UJCekk9qiL3R0GKh/pOwnC9eBRokaNZbdu?=
 =?us-ascii?Q?A/Hc/I+LsLMvlxkVxUBVof/CYPyehDoeN79Ewx+MQCus6d4zoD+TxWR0sgHU?=
 =?us-ascii?Q?AHmWhB3mbvHr4WnOuX7eTmiay149A1JEGC4JUaWQyYjHR0Kgh+D+XxYKR4tJ?=
 =?us-ascii?Q?OyOpZP85Bx4WHR82rX9uXw66iSvNtGscrlsIslT6YN767/FYoRUttfV/baYk?=
 =?us-ascii?Q?dfz7ldDTuksG+y4HGZmdT6jE0AyJYWrMHZUlL/3xFBOfRPgdxxc5sAypKBzD?=
 =?us-ascii?Q?bHyyg0YXcicB70Nc32x3n19KtCFtfqlL3qCzmntcL+kWycJXLAK9wKt4WpMr?=
 =?us-ascii?Q?KlJ6ames6zyfoa9x01vAMB5SKG/Jf0Q0uM6lp6GG9aNnngdnficZeN8o1/R0?=
 =?us-ascii?Q?98lOXCu5Z8BPOxzSl+RxCoKUyIur+YqxiUQUsWFbvwNjuTRZE0gf1pHye6zC?=
 =?us-ascii?Q?7pUhZ4ADPdwwOVDqXTI2TQE7T9UBmO1AhxjUmr+xLIxf9ZmABREyzitwS+ur?=
 =?us-ascii?Q?yk81CtKkPX5B6+VOcdLq/7ICSpYC/lh49LEI467W6bJMHLePzY4mV7Pc8FJF?=
 =?us-ascii?Q?hpEn7PikEuQQHAkAIgUTk1cnie7kRT8zNaQiACHH0ad7h41oi8C5TyKSER1A?=
 =?us-ascii?Q?o/Tx/vqwjTnO5G1OA+h3L843pmuhdFTh4nwcy1AJru0ZWOraLDW6SM23p1ZW?=
 =?us-ascii?Q?Qgmm3TvQoM826DlXhyugMREg5sb+XnjTulJc1VR5Wvxp4GSHhwve+mHEaoDT?=
 =?us-ascii?Q?3pe/1dDmM28TYw8KxHAS7JFqKSE0aBfmDDFde+aZAyGEHo9ct5NjpY3Mto/x?=
 =?us-ascii?Q?9WGuu61Jy3TY9igwdGT/xue2B8Dnh5QQ38W8q37vaEuR4sWJWulfgfApzslV?=
 =?us-ascii?Q?/vKoLSMm72rOxcCdijOfoiJAaWjQ7DDzNUbF/T61DrUVzFJmdNijWU8R2yMV?=
 =?us-ascii?Q?FH3rFj/9tp7RccmeV3cG7D/DJtIevEto60D+Akc5cJcAG+t5BxdS/lo+27HL?=
 =?us-ascii?Q?YB+VcUTQSmGCOBtEvLWHmbbD4K9tejYSIJj2OltCS2b6shAfAiHDv8nAx2We?=
 =?us-ascii?Q?h/X3lnx0ojagtg3Q4eBUprzwGGBW1z2Bl0JzaSV00+4DoDKn6YFbIqfAz1T3?=
 =?us-ascii?Q?zdjNCK5TttatM/MOZqj2wsdK6OhCgKtIaN26cPXQBfQjQTUXPsLlsgHV/d7Q?=
 =?us-ascii?Q?cudR6oZMer5aLsxANlAaczMCQaTohirAMnATmWadk1ZBmepQX6Bd0D2gQzqK?=
 =?us-ascii?Q?oAqFt4ND+DSbVdbomeT+bTOq/G8BlDkF1qROjDyd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 28b170f2-dda1-463c-f0e8-08d9b9f4dcd5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 02:45:58.1128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wO6JqmqaWc/hvC3eBhPHzFTXTjrfu++yKAxYl5ha2S11/383m8/xmTEyV91NSpf6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4888
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: RQVoZON50KJ87vdD1WejPwR6oTNmr5Tg
X-Proofpoint-ORIG-GUID: RQVoZON50KJ87vdD1WejPwR6oTNmr5Tg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_01,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080018
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 07:44:05PM -0500, Willem de Bruijn wrote:
> > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > index f091c7807a9e..181ddc989ead 100644
> > > > --- a/net/core/skbuff.c
> > > > +++ b/net/core/skbuff.c
> > > > @@ -5295,8 +5295,12 @@ void skb_scrub_tstamp(struct sk_buff *skb)
> > > >  {
> > > >         struct sock *sk = skb->sk;
> > > >
> > > > -       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME))
> > > > +       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME)) {
> > >
> > > There is a slight race here with the socket flipping the feature on/off.
> > Right, I think it is an inherited race by relating skb->tstamp with
> > a bit in sk, like the existing sch_etf.c.
> > Directly setting a bit in skb when setting the skb->tstamp will help.
> >
> > >
> > > >
> > > >                 skb->tstamp = 0;
> > > > +               skb->fwd_tstamp = 0;
> > > > +       } else if (skb->tstamp) {
> > > > +               skb->fwd_tstamp = 1;
> > > > +       }
> > >
> > > SO_TXTIME future delivery times are scrubbed, but TCP future delivery
> > > times are not?
> > It is not too much about scrubbing future SO_TXTIME or future TCP
> > delivery time for the local delivery.
> 
> The purpose of the above is to reset future delivery time whenever it
> can be mistaken for a timestamp, right?
> 
> This function is called on forwarding, redirection, looping from
> egress to ingress with __dev_forward_skb, etc. But then it breaks the
> delivery time forwarding over veth that I thought was the purpose of
> this patch series. I guess I'm a bit hazy when this is supposed to be
> scrubbed exactly.
> 
> > fwd_mono_tstamp may be a better name.  It is about the forwarded tstamp
> > is in mono.
> 
> After your change skb->tstamp is no longer in CLOCK_REALTIME, right?
Right.  The __net_timestamp() will use CLOCK_MONOTONIC.

> Somewhat annoyingly, that does not imply that it is always
> CLOCK_MONOTONIC. Because while FQ uses that, ETF is programmed with
> CLOCK_TAI.
Yes, it is the annoying part, so this patch keeps the tstamp
scrubbing for SO_TXTIME.

If a sk in veth@netns uses SO_TXTIME setting tstamp to TAI and
it is not scrubbed here, it may get forwarded to the fq@hostns
and then get dropped.

skb_ktime_get() also won't know how to compare with the current
time (mono or tai?) and then reset if needed.
Alternatively, it can always re-stamp (__net_timestamp()) much earlier
in the stack before recvmsg().  e.g. just after the sch_handle_ingress()
when TC_ACT_OK is returned as Daniel also mentioned in another thread.
That will be more limited to the bpf@ingress (and then bpf_redirect) usecase
instead of generally applicable to the ip[6]_forward.  However,
the benefit is a more limited impact scope and potential breakage.

> Perhaps skb->delivery_time is the most specific description. And that
> is easy to test for in skb_scrub_tstamp.
> 
> 
> > e.g. the packet from a container-netns can be queued
> > at the fq@hostns (the case described in patch 1 commit log).
> > Also, the bpf@ingress@veth@hostns can now expect the skb->tstamp is in
> > mono time.  BPF side does not have helper returning real clock, so it is
> > safe to assume that bpf prog is comparing (or setting) skb->tstamp as
> > mono also.
> >
> > > If adding a bit, might it be simpler to add a bit tstamp_is_edt, and
> > > scrub based on that. That is also not open to the above race.
> > It was one of my earlier attempts by adding tstamp_is_tx_mono and
> > set it in tcp_output.c and then test it before scrubbing.
> > Other than changing the tcp_output.c (e.g. in __tcp_transmit_skb),
> > I ended up making another change on the bpf side to also set
> > this bit when the bpf_prog is updating the __sk_buff->tstamp.  Thus,
> > in this patch , I ended up setting a bit only in the forward path.
> >
> > I can go back to retry the tstamp_is_edt/tstamp_is_tx_mono idea and
> > that can also avoid the race in testing sock_flag(sk, SOCK_TXTIME)
> > as you suggested.
> 
> Sounds great, thanks
