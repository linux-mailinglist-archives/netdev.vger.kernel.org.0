Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69A14DAE18
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 11:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241653AbiCPKNT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Mar 2022 06:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236869AbiCPKNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 06:13:18 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9D8B4739A
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 03:12:03 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-75-D7LEVb_5OqOwc0OTaVk56Q-1; Wed, 16 Mar 2022 10:12:01 +0000
X-MC-Unique: D7LEVb_5OqOwc0OTaVk56Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Wed, 16 Mar 2022 10:12:00 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Wed, 16 Mar 2022 10:12:00 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>
CC:     "menglong8.dong@gmail.com" <menglong8.dong@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "xeb@mail.ru" <xeb@mail.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "imagedong@tencent.com" <imagedong@tencent.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "talalahmad@google.com" <talalahmad@google.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "alobakin@pm.me" <alobakin@pm.me>,
        "flyingpeng@tencent.com" <flyingpeng@tencent.com>,
        "mengensun@tencent.com" <mengensun@tencent.com>,
        "dongli.zhang@oracle.com" <dongli.zhang@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
Subject: RE: [PATCH net-next 1/3] net: gre_demux: add skb drop reasons to
 gre_rcv()
Thread-Topic: [PATCH net-next 1/3] net: gre_demux: add skb drop reasons to
 gre_rcv()
Thread-Index: AQHYOPIjV2F+emaGqE2wwPgtEq6jh6zByRBw
Date:   Wed, 16 Mar 2022 10:12:00 +0000
Message-ID: <5f73ddd6ee4940d79e846a0eb624c73f@AcuMS.aculab.com>
References: <20220314133312.336653-1-imagedong@tencent.com>
        <20220314133312.336653-2-imagedong@tencent.com>
        <20220315200847.68c2efee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <daa287f3-fbed-515d-8f37-f2a36234cc8a@kernel.org>
 <20220315215553.676a5d24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315215553.676a5d24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski
> Sent: 16 March 2022 04:56
> 
> On Tue, 15 Mar 2022 21:49:01 -0600 David Ahern wrote:
> > >>  	ver = skb->data[1]&0x7f;
> > >> -	if (ver >= GREPROTO_MAX)
> > >> +	if (ver >= GREPROTO_MAX) {
> > >> +		reason = SKB_DROP_REASON_GRE_VERSION;
> > >
> > > TBH I'm still not sure what level of granularity we should be shooting
> > > for with the reasons. I'd throw all unexpected header values into one
> > > bucket, not go for a reason per field, per protocol. But as I'm said
> > > I'm not sure myself, so we can keep what you have..
> >
> > I have stated before I do not believe every single drop point in the
> > kernel needs a unique reason code. This is overkill. The reason augments
> > information we already have -- the IP from kfree_skb tracepoint.
> 
> That's certainly true. I wonder if there is a systematic way of
> approaching these additions that'd help us picking the points were
> we add reasons less of a judgment call.

Is it worth considering splitting the 'reason' into two parts?
Eg x << 16 | y
One part being the overall reason - and probably a define.
The other qualifying the actual failing test and probably just
being a number.

Then you get an overall view of the fails (which might even
be counted) while still being able to locate the actual
failing test.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

