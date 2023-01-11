Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D9A6663C7
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 20:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbjAKTbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 14:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbjAKTbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 14:31:46 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEDF5FA9
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 11:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673465505; x=1705001505;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=D2P3Ym3Yc4X7Zf6ii2xPD0L99j8K/o7GI79Gxj8u+H8=;
  b=PAEEEQOdNCLk5DlA6Bu5iNccBwJ/KFUzx5/4I5aIXFYtHFY88UlvxwUM
   K9Jk5Mq8Po1viNFmPORVfv4OCaZ4F9Otwww4ieOVHbthbudsXVuwwVKCH
   AlSTdUwoqYFq+qu4QzR4NraXO+cBT74fclWQnmytZ8092JQcD3xXVUjGX
   M=;
X-IronPort-AV: E=Sophos;i="5.96,317,1665446400"; 
   d="scan'208";a="285681689"
Subject: RE: [PATCH V1 net-next 0/5] Add devlink support to ena
Thread-Topic: [PATCH V1 net-next 0/5] Add devlink support to ena
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 19:31:43 +0000
Received: from EX13D34EUB004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com (Postfix) with ESMTPS id BB19D82FCE;
        Wed, 11 Jan 2023 19:31:40 +0000 (UTC)
Received: from EX19D028EUB004.ant.amazon.com (10.252.61.32) by
 EX13D34EUB004.ant.amazon.com (10.43.166.153) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 11 Jan 2023 19:31:39 +0000
Received: from EX19D047EUB004.ant.amazon.com (10.252.61.5) by
 EX19D028EUB004.ant.amazon.com (10.252.61.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.7; Wed, 11 Jan 2023 19:31:39 +0000
Received: from EX19D047EUB004.ant.amazon.com ([fe80::e4ef:7b7e:20b2:9c20]) by
 EX19D047EUB004.ant.amazon.com ([fe80::e4ef:7b7e:20b2:9c20%3]) with mapi id
 15.02.1118.020; Wed, 11 Jan 2023 19:31:39 +0000
From:   "Arinzon, David" <darinzon@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Thread-Index: AQHZJIzV+wAfc6WK6kuI0VjEEkTbvK6YFPoQgAAKigCAAKbkgIAAzoCAgAAD5VA=
Date:   Wed, 11 Jan 2023 19:31:39 +0000
Message-ID: <29a2fdae8f344ff48aeb223d1c3c78ad@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
        <20230109164500.7801c017@kernel.org>
        <574f532839dd4e93834dbfc776059245@amazon.com>
        <20230110124418.76f4b1f8@kernel.org>
        <865255fd30cd4339966425ea1b1bd8f9@amazon.com>
 <20230111110043.036409d0@kernel.org>
In-Reply-To: <20230111110043.036409d0@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.85.143.177]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, January 11, 2023 9:01 PM
> To: Arinzon, David <darinzon@amazon.com>
> Cc: David Miller <davem@davemloft.net>; netdev@vger.kernel.org;
> Machulsky, Zorik <zorik@amazon.com>; Matushevsky, Alexander
> <matua@amazon.com>; Bshara, Saeed <saeedb@amazon.com>; Bshara,
> Nafea <nafea@amazon.com>; Saidi, Ali <alisaidi@amazon.com>;
> Kiyanovski, Arthur <akiyano@amazon.com>; Dagan, Noam
> <ndagan@amazon.com>; Agroskin, Shay <shayagr@amazon.com>; Itzko,
> Shahar <itzko@amazon.com>; Abboud, Osama <osamaabb@amazon.com>
> Subject: RE: [EXTERNAL][PATCH V1 net-next 0/5] Add devlink support to
> ena
>=20
> CAUTION: This email originated from outside of the organization. Do not
> click links or open attachments unless you can confirm the sender and
> know the content is safe.
>=20
>=20
>=20
> On Wed, 11 Jan 2023 08:58:46 +0000 Arinzon, David wrote:
> > > I read it again - and I still don't know what you're doing.
> > > I sounds like inline header length configuration yet you also use
> > > LLQ all over the place. And LLQ for ENA is documented as basically
> tx_push:
> > >
> > >   - **Low Latency Queue (LLQ) mode or "push-mode":**
> > >
> > > Please explain this in a way which assumes zero Amazon-specific
> > > knowledge :(
> >
> > Low Latency Queues (LLQ) is a mode of operation where the packet
> > headers (up to a defined length) are being written directly to the devi=
ce
> memory.
> > Therefore, you are right, the description is similar to tx_push.
> > However, This is not a configurable option while
> > ETHTOOL_A_RINGS_TX_PUSH configures whether to work in a mode or
> not.
> > If I'm understanding the intent behind ETHTOOL_A_RINGS_TX_PUSH
> and the
> > implementation in the driver that introduced the feature, it refers to
> > a push of the packet and not just the headers, which is not what the
> > ena driver does.
> >
> > In this patchset, we allow the configuration of an extended size of
> > the Low Latency Queue, meaning, allow enabled another, larger,
> > pre-defined size to be used as a max size of the packet header to be
> > pushed directly to device memory. It is not configurable in value,
> > therefore, it was defined as large LLQ.
> >
> > I hope this provides more clarification, if not, I'll be happy to elabo=
rate
> further.
>=20
> Thanks, the large missing piece in my understanding is still what the use=
r
> visible impact of this change is. Without increasing the LLQ entry size, =
a
> user who sends packet with long headers will:
>  a) see higher latency thru the NIC, but everything else is the same
>  b) see higher latency and lower overall throughput in terms of PPS
>  c) will have limited access to offloads, because the device requires
>     full access to headers via LLQ for some offloads
>=20
> which one of the three is the closest?

You're right, I went through the documentation again, and I see that the im=
plications
of a case where packet headers are longer than the LLQ entry size are not m=
entioned
properly. We'll rework it to explain the motivation to turn on this mode in=
 relevant use cases.
If the packet network headers are not within the size of the LLQ entry, the=
n the packet will
be dropped. So I'll say that c) describes the impact the best given that ce=
rtain types of
traffic will not succeed or have disruptions due to dropped TX packets.
