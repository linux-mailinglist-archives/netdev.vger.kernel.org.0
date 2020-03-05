Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1CE917AD4E
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgCERbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:31:33 -0500
Received: from mail-db8eur05on2116.outbound.protection.outlook.com ([40.107.20.116]:37728
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725938AbgCERbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:31:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEAsDRzDBCaJDTWun1df07fNR3tCkJwKLkFQ1AcWKZVT4F6SSKw8cfCOC81JB3d7QYuXfkBCdgsKb/XuvpLxnugajYLu/jVJMfdl2HEeOdTjAgjJ7hP+uX+JV3AdNknbwFMKqnEmU6obk4kyhw3Me4nFfSc4AFrpsXr3RgwfO0jJA2UHXAcKJailiu8hgzmYZGQUYQtqezOExAnIrVHas7BxEQZgE95eCAtFgAf5CMH+Yd9rWkhZ/i+MYhyCqebuAnYFpLXHrcnJXsm7L0pK4I3Ul0OKRkd1E5KATEVU7Uf1ynJ/t56qSC/84TCBixdtclj7n+gEmHbKZnKibJKStg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcnuRSLZAT5T6HxBN2rS/xagJeaJKDRhAW1PIbqwOtA=;
 b=fkktNH0rlrWpOofOJS3QGTiQ4A1JmoEcLtAUX89POhv8ixfNosBwIX7hJp8rK+oiLIRptCqMGJx8oVQeX/R0VxodNdOP2+3hyx9EwL2uw5E1bdg8MayK9fP1ecQNTLn2Ernu5suzAf6ddS10BWMZOZ3p6NxsHA3Icr0lsIhu/6fEki7jzuQw/ArBKTvFBCKBZbnsObUAy0eYzkJLjJIp+uzvDdqb52rYKl9KoVVcPSpO8MS+iyFDJYEgu0r51BjsDA2DW8chW8q5TMalUAzOmQH2UdZuEBxEbw/Kk9Rj9GR63zvP5dQeKyK9TvJAQe+vgzxdYUp0ST89tqdTSlKvyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcnuRSLZAT5T6HxBN2rS/xagJeaJKDRhAW1PIbqwOtA=;
 b=w3l3bUtFlpvqfm6167W9aOeFk6i0bN2AbrEHfVKQUkVOBNqBUsGI8SfegmItYCxHP5sbmBFWPbddmxcqWTIwwS72V6vL/MVnTX33zJWAZGRbL7Jfbu7sYreEdDZRYeddd5s1+k5JvLehyz25wVSY529i6bIwQhOw+8y1uF+GS3I=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jere.leppanen@nokia.com; 
Received: from HE1PR0702MB3610.eurprd07.prod.outlook.com (10.167.124.27) by
 HE1PR0702MB3577.eurprd07.prod.outlook.com (10.167.124.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.6; Thu, 5 Mar 2020 17:31:25 +0000
Received: from HE1PR0702MB3610.eurprd07.prod.outlook.com
 ([fe80::fd31:53d3:1e20:be4a]) by HE1PR0702MB3610.eurprd07.prod.outlook.com
 ([fe80::fd31:53d3:1e20:be4a%7]) with mapi id 15.20.2793.013; Thu, 5 Mar 2020
 17:31:25 +0000
Date:   Thu, 5 Mar 2020 19:31:23 +0200 (EET)
From:   Jere Leppanen <jere.leppanen@nokia.com>
X-X-Sender: jeleppan@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net
To:     David Laight <David.Laight@ACULAB.COM>
cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "michael.tuexen@lurchi.franken.de" <michael.tuexen@lurchi.franken.de>
Subject: RE: [PATCH net] sctp: return a one-to-one type socket when doing
 peeloff
In-Reply-To: <8831b4dc929148f28cca658a4d7a11d9@AcuMS.aculab.com>
Message-ID: <alpine.LFD.2.21.2003051736080.24727@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net>
References: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com> <HE1PR0702MB3610BB291019DD7F51DBC906ECE40@HE1PR0702MB3610.eurprd07.prod.outlook.com> <CADvbK_ewk7mGNr6T4smWeQ0TcW3q4yabKZwGX3dK=XcH7gv=KQ@mail.gmail.com>
 <alpine.LFD.2.21.2003041349400.19073@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net> <8831b4dc929148f28cca658a4d7a11d9@AcuMS.aculab.com>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: AM4P190CA0022.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::32) To HE1PR0702MB3610.eurprd07.prod.outlook.com
 (2603:10a6:7:7f::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net (131.228.2.10) by AM4P190CA0022.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Thu, 5 Mar 2020 17:31:23 +0000
X-X-Sender: jeleppan@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net
X-Originating-IP: [131.228.2.10]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ac1ce31-9408-4658-aa0c-08d7c12b0738
X-MS-TrafficTypeDiagnostic: HE1PR0702MB3577:
X-Microsoft-Antispam-PRVS: <HE1PR0702MB3577E9845E0A264FC9DAA10BECE20@HE1PR0702MB3577.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(39860400002)(346002)(366004)(136003)(189003)(199004)(16526019)(55016002)(186003)(26005)(66946007)(66476007)(66556008)(8936002)(8676002)(44832011)(9686003)(81166006)(81156014)(86362001)(5660300002)(478600001)(2906002)(956004)(53546011)(6916009)(7696005)(52116002)(54906003)(316002)(4326008)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3577;H:HE1PR0702MB3610.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t/Ao8RlhYgyBGFZGax5pCsG9r2RyWj2nTkdZlpEneaYSJPUIVg2KwWwP1oqVzjry/PJdemkuQJhMHdf/n7I8rFrUU1m8hA4KyJ6WupidrJZcdIFC5OTNZOb3LgbsWaoi4Wks5OgEjqVfzDd5ofJXlFa7P8pe5fM/nrr40Mq1BfuyLiW1vCIEqEZMa9ZfyuPN75fPeCDmGTCSVgYG2zSm+dmIRnmI6WeFQC8vSBxNXGiVcgEMm/VDqBHFVM6avweHGPI3J3u27yMlZp9D4WBQhWefdFyAwJ6EDz5M80vO45r9YhHNX20ZNnKU7Y5Se9eBX55czwzDATl/shNXeNkZ+bcSJEiyAQZQBKTby90CHnAgSLXSWfc04tQsoT9R+pbU1fWW08gWQaUvrpiQYo5exbpAu2tz5wPMASXId6Q2qfS8ghKCXvAMhlAlf2jqLw8O
X-MS-Exchange-AntiSpam-MessageData: +bHCMyG+x3e3cQ2mWDn2seBL/nyyas0Ap1VphEmtEbiiGRcNPIu2GFX0fLL1oG+XfABMy7IlsbArumljAMAZ/i7ByL7Es6pHuCK6llCp9BJ1sFnoG0bwTpTZk63WVIPwkfXv8OUty/+PCCGD91hmBA==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac1ce31-9408-4658-aa0c-08d7c12b0738
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 17:31:24.9070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: asA5FV+mTog/rN4vT6pYSdYXQ87s7GrUNteWlryOgKtF8U6BQDOKrBaa0yXHzelY/fJi6uSEn5C88yw2F8CZ5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3577
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Mar 2020, David Laight wrote:

> From: Jere Leppanen
> > Sent: 04 March 2020 17:13
> > On Wed, 4 Mar 2020, Xin Long wrote:
> > 
> > > On Wed, Mar 4, 2020 at 2:38 AM Leppanen, Jere (Nokia - FI/Espoo)
> > > <jere.leppanen@nokia.com> wrote:
> > >>
> > >> On Mon, 2 Mar 2020, Xin Long wrote:
> > >>
> > >>> As it says in rfc6458#section-9.2:
> > >>>
> > >>>   The application uses the sctp_peeloff() call to branch off an
> > >>>   association into a separate socket.  (Note that the semantics are
> > >>>   somewhat changed from the traditional one-to-one style accept()
> > >>>   call.)  Note also that the new socket is a one-to-one style socket.
> > >>>   Thus, it will be confined to operations allowed for a one-to-one
> > >>>   style socket.
> > >>>
> > >>> Prior to this patch, sctp_peeloff() returned a one-to-many type socket,
> > >>> on which some operations are not allowed, like shutdown, as Jere
> > >>> reported.
> > >>>
> > >>> This patch is to change it to return a one-to-one type socket instead.
> > >>
> > >> Thanks for looking into this. I like the patch, and it fixes my simple
> > >> test case.
> > >>
> > >> But with this patch, peeled-off sockets are created by copying from a
> > >> one-to-many socket to a one-to-one socket. Are you sure that that's
> > >> not going to cause any problems? Is it possible that there was a
> > >> reason why peeloff wasn't implemented this way in the first place?
> > > I'm not sure, it's been there since very beginning, and I couldn't find
> > > any changelog about it.
> > >
> > > I guess it was trying to differentiate peeled-off socket from TCP style
> > > sockets.
> > 
> > Well, that's probably the reason for UDP_HIGH_BANDWIDTH style. And maybe
> > there is legitimate need for that differentiation in some cases, but I
> > think inventing a special socket style is not the best way to handle it.
> > 
> > But actually I meant why is a peeled-off socket created as SOCK_SEQPACKET
> > instead of SOCK_STREAM. It could be to avoid copying from SOCK_SEQPACKET
> > to SOCK_STREAM, but why would we need to avoid that?
> 
> Because you don't want all the acks and retransmissions??

I don't follow. The socket type and style have virtually no effect on the 
protocol side of things, I think.

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
> 
