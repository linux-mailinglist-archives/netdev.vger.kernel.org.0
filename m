Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B57C25667E
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 11:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgH2Jhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 05:37:36 -0400
Received: from mail-eopbgr1390085.outbound.protection.outlook.com ([40.107.139.85]:33136
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726464AbgH2Jhe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 05:37:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ts8njszqC6f6E5Cj+LK2pU0fgZA4e0bsU3ZQGlnZ2TAQPlXMS2w7gEqbItnlwwISB0JojlN31h5DDmfQiFWu6VCo+483+rRGr8fqPskgQwZi44IbyVmkIPOERoNxCXD+wQ2T67KiYVaSmenAmVpNLDJy3XkEC4EL7uNxvN+iQN0yfkN8ED41l4FJU/Z4vEhiR/2aC+wcdO/YsSE7Wc1zyQKVRTDlSNo9eu+3JgYutnI0kodOLe3T+PwaBC+Whgh2uBsFAVWURkK/x0iPQlsauLrCsRg5/jU67PwOU6tmMG826O2Q/yTCxjpgFPCWDBkEotzT0wDY+D+KmYrt4quCMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TT9jBw+O/xSU6Z1cjuEbw3li0lwHkVQWcKme69oas9A=;
 b=VlUByUWPBv0KBNKeRKFOIMdEENHd/9nshkPWfRpAGa0gG87DbmkzaW+/eTrpOFQ1XO/nX7B2MwN42VGo/gjVe/jDWaP1OekSjQiCMjkScTcD6ZpWa+La6Dauuo3zL/seChRgVcrHt3jjVODUgAABMJSOAfFT6VsdPzEZ4xpSBiVyqsJ63DTkt8bwyD4vIkKg/SqHslRb7tTu0Mma+8xTM8wjE3v+yQWZ+SKR3oSpEz1jpf1Sp1hhaS2RtdrttHUgAB15O7iGeHdbHPoebQbzHjBHWvF0yHSPzYJHTi5AnDXKnjRSY7jn5GhpSYUsAeoHwkgIPOUev5PoZ4mwNsbTxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=iisc.ac.in; dmarc=pass action=none header.from=iisc.ac.in;
 dkim=pass header.d=iisc.ac.in; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iisc.ac.in;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TT9jBw+O/xSU6Z1cjuEbw3li0lwHkVQWcKme69oas9A=;
 b=r8xLOMbEQB7NdB8PjsMJ9aJAGHclpK2qW9RkVzr4sDA77Qp6gX0Ne/YOEbvpqGEKyXe+WKVYNNPHGEtT50gP884fqzSbTWzzOEOFxeY0CrLwhQEWtucyAgyqGZ9oaEZYrltnuwll1wUZXxNFiG4d8o2eS/G+FbpE8pHs1MueOd4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=iisc.ac.in;
Received: from BMXPR01MB2213.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:3b::22)
 by BMXPR01MB3512.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:5d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Sat, 29 Aug
 2020 09:37:29 +0000
Received: from BMXPR01MB2213.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d18d:b4b1:e2a7:8510]) by BMXPR01MB2213.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d18d:b4b1:e2a7:8510%5]) with mapi id 15.20.3326.024; Sat, 29 Aug 2020
 09:37:29 +0000
Date:   Sat, 29 Aug 2020 15:07:27 +0530
From:   "S.V.R.Anand" <anandsvr@iisc.ac.in>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: packet deadline and process scheduling
Message-ID: <20200829093707.GB4669@iisc.ac.in>
References: <20200828064511.GD7389@iisc.ac.in>
 <c9eb6d14-cbc3-30de-4fb7-5cf18acfbe75@gmail.com>
 <20200828085053.GA4669@iisc.ac.in>
 <CA+FuTSeOx53Vq_JW4icjV-QnuKwj+PGkPpg5XWAoHWea5bfviQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSeOx53Vq_JW4icjV-QnuKwj+PGkPpg5XWAoHWea5bfviQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: MA1PR0101CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::13) To BMXPR01MB2213.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:3b::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from iisc.ac.in (49.206.10.123) by MA1PR0101CA0051.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Sat, 29 Aug 2020 09:37:28 +0000
X-Originating-IP: [49.206.10.123]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc7837c0-54ce-4dab-98c2-08d84bff2564
X-MS-TrafficTypeDiagnostic: BMXPR01MB3512:
X-Microsoft-Antispam-PRVS: <BMXPR01MB3512292E11B50750D607BD30FC530@BMXPR01MB3512.INDPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ArXeAUBKrgKdHp496TQzZRQQ4gWn+HDxdBgRKi6CA9CxwTNnAcITiobOtWybG3qshBVQcG+Nwh5w2wb9ZAiACnTqVvByX5Zsv2Ru3nmtrQKMj0pisC/f82cAUptM7/Y7ihMn33ytDOWj+cO1rsrPWl+DZSVpaE3azQfITEBW6TB9G8CnrjB3ejEmzQVc15Txb1nEsUoqX4KN6+yMcfpMDGB1bE+Kb7oAP3Y6qhpo1k/Z1yNqukP8ZTZ6emqL0MqR/tcnMLQ4Gtp5weaCURm702GWQ6jCPKxFXC0RTLmWooRrEmMpHeIMFvrMnVS+M//LSE/CEywD1NSPhheGqj6H1FC0fubJGQ1qShkzWBUNsgkfoCQu80rRiqK6NYiiulhoL+Hu7zWw29hMTNZn6WKrgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BMXPR01MB2213.INDPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(7696005)(52116002)(2906002)(16526019)(26005)(186003)(4326008)(55236004)(66574015)(83380400001)(36756003)(53546011)(55016002)(956004)(478600001)(33656002)(1006002)(2616005)(66556008)(66946007)(66476007)(316002)(786003)(8936002)(86362001)(6916009)(54906003)(5660300002)(8676002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PQmQUpUZxoG+qjO3ZgYNshEpGG7wahz9nvnuVzQj1wylH+XDjdKl4g+OgoIVAqsheUKj2PPzGxzhhc8sA4+8Y27CyAZqofQOmKBcGy9+xuYS9+j3NOi64MLFaY6LQwuEadz5QxjO/oroi9Kx5KKoYyTlDhWumJwwOhpmk1FLtuaIGZoG2F6QofjPI04zA/zAYuYVbnvMR8j7gyRLMrlSX2tiBFfT+JfXFKwYbXpyk+zDn1NUkH2Ywv28O2G0yRyBrluMoMdT+Wl9UuIqJetVrzYWKbw8RvqHva9Rww0sXtqWiP9YI3ACvhol0KX7gQmR9unve7TJzl8voxIIPLdSqjkPgJYR+LTupYyF0muxjMSwNopUSDWMfBVuC9yXuN1luZ4ehGXbGO1cVyJqdnM0yNBfE5XGOH4/IvWZXYhkqNL+b51VmgBlO1tKqb53NpBbSUq3Hj87okmZyfa/NrM42IQLO03p10AjcFLBNOwPmGUy2M3NIAOKKLPGGZ0ohI8E+wmuZfb16yuhsrh30rqApLtSYffTHHZdqpAvWtv1NHmkA8DtENYK3GMBvrewrg/ulOrf8oabJUxe1mhUgN7XwRDI3pbsQEDKrUrweIv9spUmLLOz+dRarMq8wPgYooyMQ9gn7k7Np9ssFUszdjD+0A==
X-OriginatorOrg: iisc.ac.in
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7837c0-54ce-4dab-98c2-08d84bff2564
X-MS-Exchange-CrossTenant-AuthSource: BMXPR01MB2213.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2020 09:37:29.1127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6f15cd97-f6a7-41e3-b2c5-ad4193976476
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HVWZa2awx2c0cZR8OeCyYMU0pa/f2Gnvw3tWuSlpVEKrxiqsoobPPiiAK6uhyLlTxH+yOoBFOFCG6uA15VeZig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BMXPR01MB3512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks a lot for the suggestion. If my understanding is correct, I think
it solves part of the problem by dequeueing packets with deadline in a
timely manner using bpf and FQ scheduler combination. Let me know if my
understanding is correct. Once the packets are dequeued, how about 
scheduling of the receiver application process running in the user space in
a timely manner before the packet deadline ? By doing this, we are
ensuring timely delivery of the data to the receiver application.

Anand

On 20-08-28 16:01:31, Willem de Bruijn wrote:
> 
> 
> On Fri, Aug 28, 2020 at 10:51 AM S.V.R.Anand <anandsvr@iisc.ac.in> wrote:
> >
> > There is an active Internet draft "Packet Delivery Deadline time in
> > 6LoWPAN Routing Header"
> > (https://datatracker.ietf.org/doc/draft-ietf-6lo-deadline-time/) which
> > is presently in the RFC Editor queue and is expected to become an RFC in
> > the near future. I happened to be one of the co-authors of this draft.
> > The main objective of the draft is to support time sensitive industrial
> > applications such as Industrial process control and automation over IP
> > networks.  While the current draft caters to 6LoWPAN networks, I would
> > assume that it can be extended to carry deadline information in other
> > encapsulations including IPv6.
> >
> > Once the packet reaches the destination at the network stack in the
> > kernel, it has to be passed on to the receiver application within the
> > deadline carried in the packet because it is the receiver application
> > running in user space is the eventual consumer of the data. My mail below is for
> > ensuring passing on the packet sitting in the socket interface to the
> > user receiver application process in a timely fashion with the help of
> > OS scheduler. Since the incoming packet experieces variable delay, the
> > remaining time left before deadline approaches too varies. There should
> > be a mechanism within the kernel, where network stack needs to
> > communicate with the OS scheduler by letting the scheduler know the
> > deadline before user application socket recv call is expected to return.
> >
> > Anand
> >
> >
> > On 20-08-28 10:14:13, Eric Dumazet wrote:
> > >
> > >
> > > On 8/27/20 11:45 PM, S.V.R.Anand wrote:
> > > > Hi,
> > > >
> > > > In the control loop application I am trying to build, an incoming message from
> > > > the network will have a deadline before which it should be delivered to the
> > > > receiver process. This essentially calls for a way of scheduling this process
> > > > based on the deadline information contained in the message.
> > > >
> > > > If not already available, I wish to  write code for such run-time ordering of
> > > > processes in the earlist deadline first fashion. The assumption, however
> > > > futuristic it may be, is that deadline information is contained as part of the
> > > > packet header something like an inband-OAM.
> > > >
> > > > Your feedback on the above will be very helpful.
> > > >
> > > > Hope the above objective will be of general interest to netdev as well.
> > > >
> > > > My apologies if this is not the appropriate mailing list for posting this kind
> > > > of mails.
> > > >
> > > > Anand
> > > >
> > >
> > > Is this described in some RFC ?
> > >
> > > If not, I guess you might have to code this in user space.
> 
> Could ingress redirect to an IFB device with FQ scheduler work for
> ingress EDT? With a BPF program at ifb device egress hook to read
> the header and write skb->tstamp.
