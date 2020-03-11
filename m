Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2146F1820FE
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 19:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730755AbgCKSl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 14:41:26 -0400
Received: from mail-eopbgr20124.outbound.protection.outlook.com ([40.107.2.124]:8832
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730658AbgCKSl0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 14:41:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2wNnAmYQebmBxGKyN3xg3/f8UarjusqVmwsee4YP5juGEolJdYCHVISSqsZVIVFqlH+3LuAdMi/h3RJZh4ULtQeVjNsD5/7imLlPZwQTMl3g975xiyHVJ9JvNkE9Qgkcs/j1FQOt+fzO4icqYInleOc5jfl/h18YMblDPPlkz1cPdzn0lxWx34uVXEyf8bLGZDkXSjLMozJCaPaZ5Ixujtiy5bKH4W2ldaNgc7CNoonnhaOSyfZ1VJ066hCFnld3z083dXVzYF2tmSrA2DxsoTnzmE9Cz76U3rVshU30bF33KYvJC0D9v2mWVc+Nv+tgrO9B1zyGNl9m+FbOo7SGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1U7RoW9M8fTZR1WZ6Nw4AuvmNiXhacIjwyMzBL0C0I=;
 b=devZ7uP7myuKotJ1a88UoacdC0mRfE/sBouzm4S76FloHG3NAWrsPG8c2wtEg1WhX5ONcmc4RcbYBAyngUFQgpaxb+mRK2wmnJwf+P5Yn3arnpefhv9f7b01LjXrVXM/ozoDGGmPntZ/baxl8aO8158K+9vmNehQKFa6AATWLqO6haEeiG6i0P0lO3smsETcN9SPxGc/K6y3Le03TamP3VRx6DZOS33Z5aADXFYSBvX/VGq4+YySpIEuqXRWTjq+gzyn/3GdZNcptJ7wh/zNXCItln6flxYTbuOqTgQbD634l9ka6Q7/h9Q95yhOQU6E6RDmuk87FCVouw2kZFeH/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1U7RoW9M8fTZR1WZ6Nw4AuvmNiXhacIjwyMzBL0C0I=;
 b=I2a8Dz01BG+vkRc1CrRQlsAdVNEE2vGLLlX66dd3IiHHaKYZZf9JasgfAKKBzLs2u4js1gXqtsliChW800PxCqrHgE1uOGOXLbxU2gY3OD3ARqpy855QOIfpd7omRD1Wq5xIHjM1s2hrhgFvubTFRFla0FcbsS3pyS5xB6DlaSE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jere.leppanen@nokia.com; 
Received: from HE1PR0702MB3610.eurprd07.prod.outlook.com (10.167.124.27) by
 HE1PR0702MB3594.eurprd07.prod.outlook.com (10.167.126.161) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.11; Wed, 11 Mar 2020 18:41:20 +0000
Received: from HE1PR0702MB3610.eurprd07.prod.outlook.com
 ([fe80::fd31:53d3:1e20:be4a]) by HE1PR0702MB3610.eurprd07.prod.outlook.com
 ([fe80::fd31:53d3:1e20:be4a%7]) with mapi id 15.20.2814.007; Wed, 11 Mar 2020
 18:41:20 +0000
Date:   Wed, 11 Mar 2020 20:41:09 +0200 (EET)
From:   Jere Leppanen <jere.leppanen@nokia.com>
X-X-Sender: jeleppan@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "michael.tuexen@lurchi.franken.de" <michael.tuexen@lurchi.franken.de>
Subject: Re: [PATCH net] sctp: return a one-to-one type socket when doing
 peeloff
In-Reply-To: <20200311033428.GD2547@localhost.localdomain>
Message-ID: <alpine.LFD.2.21.2003111901340.79042@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net>
References: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com> <HE1PR0702MB3610BB291019DD7F51DBC906ECE40@HE1PR0702MB3610.eurprd07.prod.outlook.com> <CADvbK_ewk7mGNr6T4smWeQ0TcW3q4yabKZwGX3dK=XcH7gv=KQ@mail.gmail.com>
 <alpine.LFD.2.21.2003041349400.19073@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net> <20200311033428.GD2547@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: AM4P190CA0006.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::16) To HE1PR0702MB3610.eurprd07.prod.outlook.com
 (2603:10a6:7:7f::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net (131.228.2.10) by AM4P190CA0006.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Wed, 11 Mar 2020 18:41:18 +0000
X-X-Sender: jeleppan@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net
X-Originating-IP: [131.228.2.10]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c3f25df8-97e8-49ec-0d16-08d7c5ebc9c2
X-MS-TrafficTypeDiagnostic: HE1PR0702MB3594:
X-Microsoft-Antispam-PRVS: <HE1PR0702MB3594EA38272AB20436CFEFF5ECFC0@HE1PR0702MB3594.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(199004)(7696005)(52116002)(6506007)(55016002)(478600001)(66946007)(66556008)(66476007)(53546011)(6916009)(16526019)(316002)(5660300002)(54906003)(9686003)(6666004)(81166006)(186003)(26005)(2906002)(86362001)(8936002)(44832011)(8676002)(81156014)(4326008)(956004);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3594;H:HE1PR0702MB3610.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DoIWhw0S94KSwHCsXyiPVu+izyhJZy8etPOvd5Yxl21wr0mdZZQpW6SotF8EXGcN98ai2AA5EV7AgXXhHYn/ckOea9xlP+53fFNccW4B5zL7622OjqzjatUOh0vWu8XNXAHtgCo1bFFoW3SP+3r2+Q9OFo4MS2Lmi5GIR/725TEkKf1CM/2AHpNzAPAkIs+QVZ5Zdf4WYNvF56e+0VC8aC07fwlqgr9arG3wG1nBYMhYRTUX/pFoNBBhUTIIb3k2pz6T73qf0ZeVCMXT78QOqL6DfAJ+4AVaxPbKpcmeKLq3rQiD/XbZ+KeczllRC6NorNsGJd7CW4dbbVGwNeKkGJT6kqr8WA4Eqy54a565Y3ZZXl4tpMwUY4eukNay2a3g2dX1AF0i9C+qADuOBi5zFvHla+l+gb6u/RLzHFw8jbT40uvHPOjF2XDQ8ECzYcNa89hOCWztNpNsldI0XSxJ4m1DFbIno9SnU47peHhBcKeRmFsK7bfM+HHCkeqlEFtLW8xNUyX3Tdhm5Pja1Hf7Tg==
X-MS-Exchange-AntiSpam-MessageData: Cb6EAXN0nmBIov+2TnAMFUxXOpUECZwRuK1NATl1qcaMR4IrK1tuesRf94ZzfYr6wqDXBDL9V30R8J+A8oP866WYYCe8kBPglNZv7hDUJdDl9ETizenVao5iufDP7+FvU2QeheySfoiRkW084DPMRA==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f25df8-97e8-49ec-0d16-08d7c5ebc9c2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 18:41:20.5848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QgbGqKBRp/Ba3Hc7ZQbdUnAipj8iNcZYyez4U4J1PvZ3k7qK6onvrjdam7lOYoDKqXgtxFmHnAUNjVqVDC03gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3594
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020, Marcelo Ricardo Leitner wrote:

> On Wed, Mar 04, 2020 at 07:13:14PM +0200, Jere Leppanen wrote:
> > On Wed, 4 Mar 2020, Xin Long wrote:
> > 
> > > On Wed, Mar 4, 2020 at 2:38 AM Leppanen, Jere (Nokia - FI/Espoo)
> > > <jere.leppanen@nokia.com> wrote:
> > > > 
> > > > On Mon, 2 Mar 2020, Xin Long wrote:
> > > > 
> > > > > As it says in rfc6458#section-9.2:
> > > > > 
> > > > >   The application uses the sctp_peeloff() call to branch off an
> > > > >   association into a separate socket.  (Note that the semantics are
> > > > >   somewhat changed from the traditional one-to-one style accept()
> > > > >   call.)  Note also that the new socket is a one-to-one style socket.
> > > > >   Thus, it will be confined to operations allowed for a one-to-one
> > > > >   style socket.
> > > > > 
> > > > > Prior to this patch, sctp_peeloff() returned a one-to-many type socket,
> > > > > on which some operations are not allowed, like shutdown, as Jere
> > > > > reported.
> > > > > 
> > > > > This patch is to change it to return a one-to-one type socket instead.
> > > > 
> > > > Thanks for looking into this. I like the patch, and it fixes my simple
> > > > test case.
> > > > 
> > > > But with this patch, peeled-off sockets are created by copying from a
> > > > one-to-many socket to a one-to-one socket. Are you sure that that's
> > > > not going to cause any problems? Is it possible that there was a
> > > > reason why peeloff wasn't implemented this way in the first place?
> > > I'm not sure, it's been there since very beginning, and I couldn't find
> > > any changelog about it.
> > > 
> > > I guess it was trying to differentiate peeled-off socket from TCP style
> > > sockets.
> 
> Me too.
> 
> > 
> > Well, that's probably the reason for UDP_HIGH_BANDWIDTH style. And maybe
> > there is legitimate need for that differentiation in some cases, but I think
> > inventing a special socket style is not the best way to handle it.
> 
> I agree, but.. (in the end of the email)
> 
> > 
> > But actually I meant why is a peeled-off socket created as SOCK_SEQPACKET
> > instead of SOCK_STREAM. It could be to avoid copying from SOCK_SEQPACKET to
> > SOCK_STREAM, but why would we need to avoid that?
> > 
> > Mark Butler commented in 2006
> > (https://sourceforge.net/p/lksctp/mailman/message/10122693/):
> > 
> >     In short, SOCK_SEQPACKET could/should be replaced with SOCK_STREAM
> >     right there, but there might be a minor dependency or two that would
> >     need to be fixed.
> > 
> > > 
> > > > 
> > > > With this patch there's no way to create UDP_HIGH_BANDWIDTH style
> > > > sockets anymore, so the remaining references should probably be
> > > > cleaned up:
> > > > 
> > > > ./net/sctp/socket.c:1886:       if (!sctp_style(sk, UDP_HIGH_BANDWIDTH) && msg->msg_name) {
> > > > ./net/sctp/socket.c:8522:       if (sctp_style(sk, UDP_HIGH_BANDWIDTH))
> > > > ./include/net/sctp/structs.h:144:       SCTP_SOCKET_UDP_HIGH_BANDWIDTH,
> > > > 
> > > > This patch disables those checks. The first one ignores a destination
> > > > address given to sendmsg() with a peeled-off socket - I don't know
> > > > why. The second one prevents listen() on a peeled-off socket.
> > > My understanding is:
> > > UDP_HIGH_BANDWIDTH is another kind of one-to-one socket, like TCP style.
> > > it can get asoc by its socket when sending msg, doesn't need daddr.
> > 
> > But on that association, the peer may have multiple addresses. The RFC says
> > (https://tools.ietf.org/html/rfc6458#section-4.1.8):
> > 
> >     When sending, the msg_name field [...] is used to indicate a preferred
> >     peer address if the sender wishes to discourage the stack from sending
> >     the message to the primary address of the receiver.
> 
> Which means the currect check in 1886 is wrong and should be fixed regardless.
> 
> > 
> > > 
> > > Now I thinking to fix your issue in sctp_shutdown():
> > > 
> > > @@ -5163,7 +5163,7 @@ static void sctp_shutdown(struct sock *sk, int how)
> > >        struct net *net = sock_net(sk);
> > >        struct sctp_endpoint *ep;
> > > 
> > > -       if (!sctp_style(sk, TCP))
> > > +       if (sctp_style(sk, UDP))
> > >                return;
> > > 
> > > in this way, we actually think:
> > > one-to-many socket: UDP style socket
> > > one-to-one socket includes: UDP_HIGH_BANDWIDTH and TCP style sockets.
> > > 
> > 
> > That would probably fix shutdown(), but there are other problems as well.
> > sctp_style() is called in nearly a hundred different places, I wonder if
> > anyone systematically went through all of them back when UDP_HIGH_BANDWIDTH
> > was added.
> 
> I suppose, and with no grounds, just random thoughts, that
> UDP_HIGH_BANDWIDTH is a left-over from an early draft/implementation.
> 
> > 
> > I think getting rid of UDP_HIGH_BANDWIDTH altogether is a much cleaner
> > solution. That's what your patch does, which is why I like it. But such a
> > change could easily break something.
> 
> Xin's initial patch here or this without backward compatibility, will
> create some user-noticeable differences, yes. For example, in
> sctp_recvmsg():
>         if (sctp_style(sk, TCP) && !sctp_sstate(sk, ESTABLISHED) &&
>             !sctp_sstate(sk, CLOSING) && !sctp_sstate(sk, CLOSED)) {
>                 err = -ENOTCONN;
>                 goto out;
> 
> And in sctp_setsockopt_autoclose():
> " * This socket option is applicable to the UDP-style socket only. When"
>         /* Applicable to UDP-style socket only */
>         if (sctp_style(sk, TCP))
>                 return -EOPNOTSUPP;
> 
> Although on RFC it was updated to:
> 8.1.8.  Automatic Close of Associations (SCTP_AUTOCLOSE)
>    This socket option is applicable to the one-to-many style socket
>    only.
> 
> These would start to be checked with such change. The first is a
> minor, because that return code is already possible from within
> sctp_wait_for_packet(), it's mostly just enforced later. But the
> second..  Yes, we're violating the RFC in there, but OTOH, I'm afraid
> it may be too late to fix it.
> 
> Removing UDP_HIGH_BANDWIDTH would thus require some weird checks, like
> in the autoclose example above, something like:
>         /* Applicable to one-to-many sockets only */
>         if (sctp_style(sk, TCP) && !sctp_peeledoff(sk))
>                 return -EOPNOTSUPP;
> 
> Which doesn't help much by now. Yet, maybe there is only a few cases
> like this around?
> 
>   Marcelo
> 

Right, I agree on every point, Marcelo.

Weird checks are required regardless of whether UDP_HIGH_BANDWIDTH is 
removed or not. Either way, it's probably wise to explicitly point out bug 
compatibility in the code.

Removing UDP_HIGH_BANDWIDTH is in some sense cleaner, but on the other 
hand, not removing it allows for smaller incremental changes. Maybe 
keeping UDP_HIGH_BANDWIDTH is fine, after all. Less risk.

So due to this issue, there are probably multiple unfixable RFC violations 
in place. I suppose the known problems should at least be documented 
somewhere.
