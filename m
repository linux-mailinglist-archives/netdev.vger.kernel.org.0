Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9EA666580
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 22:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjAKVVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 16:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjAKVVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 16:21:21 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639D5DEB
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 13:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673472081; x=1705008081;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=mg9funHJU3Hw+xLpA12qLFyFfaQLtGJ2UxVjs53nGTM=;
  b=HvJwhuq1JyprxD5eOdg/tfJkCX2hSriwR0feL+0fF1OymIIQTvgjO+CP
   +Y4DQ1YbtjxUNAJTCZ5BXCZTORC7EBrsZfRm6iA9CycIkiXAgap/KZvfb
   ttQRE5kN8YTLBE+kgYx6RaDLbMrVk1ZpjJyiVu9IGTdlg/UC/Dd515AdN
   Y=;
X-IronPort-AV: E=Sophos;i="5.96,317,1665446400"; 
   d="scan'208";a="170268668"
Subject: RE: [PATCH V1 net-next 0/5] Add devlink support to ena
Thread-Topic: [PATCH V1 net-next 0/5] Add devlink support to ena
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 21:21:18 +0000
Received: from EX13D46EUB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id 9B5B9C3005;
        Wed, 11 Jan 2023 21:21:17 +0000 (UTC)
Received: from EX19D028EUB002.ant.amazon.com (10.252.61.43) by
 EX13D46EUB001.ant.amazon.com (10.43.166.230) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Wed, 11 Jan 2023 21:21:16 +0000
Received: from EX19D047EUB004.ant.amazon.com (10.252.61.5) by
 EX19D028EUB002.ant.amazon.com (10.252.61.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.7; Wed, 11 Jan 2023 21:21:16 +0000
Received: from EX19D047EUB004.ant.amazon.com ([fe80::e4ef:7b7e:20b2:9c20]) by
 EX19D047EUB004.ant.amazon.com ([fe80::e4ef:7b7e:20b2:9c20%3]) with mapi id
 15.02.1118.020; Wed, 11 Jan 2023 21:21:16 +0000
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
        "Abboud, Osama" <osamaabb@amazon.com>,
        "Schmeilin, Evgeny" <evgenys@amazon.com>
Thread-Index: AQHZJIzV+wAfc6WK6kuI0VjEEkTbvK6YFPoQgAAKigCAAKbkgIAAzoCAgAAD5VCAAAyvgIAAEaxQ
Date:   Wed, 11 Jan 2023 21:21:16 +0000
Message-ID: <2ad9b7b544d745aebd5ddd79bf2efa12@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
        <20230109164500.7801c017@kernel.org>
        <574f532839dd4e93834dbfc776059245@amazon.com>
        <20230110124418.76f4b1f8@kernel.org>
        <865255fd30cd4339966425ea1b1bd8f9@amazon.com>
        <20230111110043.036409d0@kernel.org>
        <29a2fdae8f344ff48aeb223d1c3c78ad@amazon.com>
 <20230111120003.1a2e2357@kernel.org>
In-Reply-To: <20230111120003.1a2e2357@kernel.org>
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
> Sent: Wednesday, January 11, 2023 10:00 PM
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
> On Wed, 11 Jan 2023 19:31:39 +0000 Arinzon, David wrote:
> > If the packet network headers are not within the size of the LLQ
> > entry, then the packet will be dropped. So I'll say that c) describes
> > the impact the best given that certain types of traffic will not succee=
d or
> have disruptions due to dropped TX packets.
>=20
> I see. Sounds like it could be a fit for
> DEVLINK_ATTR_ESWITCH_INLINE_MODE ? But that one configures the
> depth of the headers copied inline, rather than bytes. We could add a val=
ue
> for "tunneled" and have that imply 256B LLQ in case of ena.
>=20
> The other option is to introduce the concept of "max length of inline dat=
a"
> to ethtool, and add a new netlink attribute to ethtool -g.
>=20
> Either way - the length of "inline|push" data is not a ena-specific conce=
pt,
> so using private knobs (devlink params or ethtool flags) is not appropria=
te
> upstream. We should add a bona fide uAPI for it.

I've looked into the original commit of DEVLINK_ATTR_ESWITCH_INLINE_MODE
and it seems to be more related to encapsulation and adding a tunneling con=
cept
here would be misleading, as it doesn't cover all the use-cases affected he=
re.
It is true that in case of tunneling and if there's a need to access the en=
capsulated
headers, the length of the headers might be larger than the default value i=
n LLQ,
but this may be also the case for non-tunneled traffic, for example,
IPv6 with TCP SACK option.

I'll note again that this is not a configurable value, meaning, the only op=
tion is
to have 128B (standard) or 256B (large) LLQ, there's no option to set other=
 values,
but only choose between the modes, therefore, I don't see how having such a=
n
option through ethtool, as you suggested (setting the max length) can be
beneficial in our use-case (might be good overall, as you noted, it's a mor=
e
generic concept). Will put more thought into it.
