Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FA965FE6E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 10:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbjAFJ6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 04:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjAFJ6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 04:58:04 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB0F6165;
        Fri,  6 Jan 2023 01:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672999082; x=1704535082;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=VZqJLZm6Ci+sGx44e38EWK4CmsPPAKDhPQybyoFfhKE=;
  b=LRqAJHUCyuDFHI0GAG6LhL3Oeyfe1G0tmbAoMCfDPLJhVkadMOIOR0ET
   LCZ2H8T6h7/SdOJH8HeFF2gN6RcT5HoOY8IQxb4IPrrlPI2DQWpMDF/9y
   U9nxZiubBO0MzeLNymaSPFIedRYlbZ3KCWUaz9Td+8cCwsD6T6u2yfmj3
   etn8hLTdthwNipHr4jLuvaPxdHuaQKTV0rifLK+sUmjtrfgs2JwOs2DL+
   yyXz+G7k1vYMG2O4OCVz9y1Ux5f7/lR7tN9C07bu88bENwD6nSDhr6KyQ
   G6uem2/9KmFZSJOksXMEV9smpDAxfARspBUwVaT56ReMscsCL1Y9oYUoG
   g==;
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="194571779"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jan 2023 02:58:01 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 02:57:58 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 02:57:55 -0700
Message-ID: <b6b2db49dfdd2c3809c8b2c99077ca5110d84d97.camel@microchip.com>
Subject: Re: [PATCH net-next v2 0/8] Add support for two classes of VCAP
 rules
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        "Russell King" <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>
Date:   Fri, 6 Jan 2023 10:57:54 +0100
In-Reply-To: <35a9ff9fa0980e1e8542d338c6bf1e0c@walle.cc>
References: <20230106085317.1720282-1-steen.hegelund@microchip.com>
         <35a9ff9fa0980e1e8542d338c6bf1e0c@walle.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,


On Fri, 2023-01-06 at 10:07 +0100, Michael Walle wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> Hi Steen,
>=20
> thanks for adding me on CC :) I was just about to reply on your v1.
>=20
> Am 2023-01-06 09:53, schrieb Steen Hegelund:
> > This adds support for two classes of VCAP rules:
> >=20
> > - Permanent rules (added e.g. for PTP support)
> > - TC user rules (added by the TC userspace tool)
> >=20
> > For this to work the VCAP Loopups must be enabled from boot, so that
> > the
> > "internal" clients like PTP can add rules that are always active.
> >=20
> > When the TC tool add a flower filter the VCAP rule corresponding to
> > this
> > filter will be disabled (kept in memory) until a TC matchall filter
> > creates
> > a link from chain 0 to the chain (lookup) where the flower filter was
> > added.
> >=20
> > When the flower filter is enabled it will be written to the appropriate
> > VCAP lookup and become active in HW.
> >=20
> > Likewise the flower filter will be disabled if there is no link from
> > chain
> > 0 to the chain of the filter (lookup), and when that happens the
> > corresponding VCAP rule will be read from the VCAP instance and stored
> > in
> > memory until it is deleted or enabled again.
>=20
> I've just done a very quick smoke test and looked at my lan9668 board
> that the following error isn't printed anymore. No functional testing.
> =C2=A0=C2=A0 vcap_val_rule:1678: keyset was not updated: -22

Good to hear.

>=20
> And it is indeed gone. But I have a few questions regarding how these
> patches are applied. They were first sent for net, but now due to
> a remark that they are too invasive they are targeted at net-next.
> But they have a Fixes: tag. Won't they be eventually backported to
> later kernels in any case? What's the difference between net and
> net-next then?

I am not sure I can answer that.

>=20
> Also patches 3-8 (the one with the fixes tags) don't apply without
> patch 1-2 (which don't have fixes tags). IMHO they should be
> reordered.

Right.

>=20
> Wouldn't it make more sense, to fix the regression via net (and
> a Fixes: tag) and then make that stuff work without tc? Maybe
> the fix is just reverting the commits.

I have discussed this again with Horatiu and I have the following suggestio=
n of
how to proceed:

1) Create a small LAN966x specific patch for net (see below for the two pos=
sible
   variants).

2) Continue with a net-next V3 without any 'Fixes' tags on top of the patch=
 in
   (1) when it becomes available in net-next.


The LAN966x patch for net (with a Fixes tag) could contain either:

a) No check on enabled lookup

   Removal of the check for enabled lookups:
  =20
   -	if (!ANA_VCAP_S2_CFG_ENA_GET(val))
   -		return -ENOENT;
  =20
   This will remove the error that you have seen, but  will still require a
   matchall rule to enable the PTP rules.  This is compatible with the TC
   framework.
  =20
b) Always enable lookups

   Enable the lookups at startup.
   Remove the lookup enable check as above.
  =20
   This will make the PTP rules (and any other rules) work even without the
   matchall rule to enable them.  It its not ideal, but solves the problem =
that
   you have been experiencing without the 'TC magic'
  =20
   The V3 in net-next will provide the full solution.

I expect that you might prefer the b) version.

>=20
> -michael

BR
Steen
