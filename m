Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19246ECFE0
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 16:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbjDXOCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 10:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjDXOCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 10:02:33 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E065126
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 07:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1682344946; x=1713880946;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XdVEpOJ8DXH/Xn0i2AdvIAQCPkOrHWKidE+dsfL4LEk=;
  b=lkJRMJ8Hct3aI5cKWF7x+vc0nOt1o4deCYkYTeZ3JWHr+VrSM4Yfkwkm
   b/6PBfVFA6mw9yrIdI0dO4kjiojh4zzQgelwQ7HeoQbE80UCD/NcBucJT
   vX1aZBjRQEhlb6tAw4T2EjaemNL1uML5GZS3FrjgSzfnpFm5cgyZraywU
   A77w9bRxCnHi8nSuE0FYuruabeO/pdejl50iXcH6SfyG4jZV3tu7Sf+/A
   sPkmQEPPVVzSkSD91E8LLPrYfJwaF1SKMP4+x4OTketTzLPNSjdxIyVQ2
   o9KScUeUAcjd5TV6pD9HeW5+b5wESSJAdvhfjJHZrP5IU/IsgWFMJJF5e
   w==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677538800"; 
   d="scan'208";a="30520438"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 24 Apr 2023 16:02:24 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 24 Apr 2023 16:02:24 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 24 Apr 2023 16:02:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1682344944; x=1713880944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XdVEpOJ8DXH/Xn0i2AdvIAQCPkOrHWKidE+dsfL4LEk=;
  b=bgTc5Hh/HVY0O5Z5bwgktQk+XWq71m4cQP98QKRwi93qbk/2og6CLh8m
   uUvy517/vfspvHIkBTtPPd69FJhNYHXYEwFLAVr+2xgH+6s6CSSpDw5cs
   Feg1R47mST6cgx1O8b3J5e5YmZY+8gIhbME7QtDuh7eLWwfKeP6rR2Rmd
   bcDJhqC3RNGrTn+0Gs3eIGLQGR4D0oYm05g39MHgESYTPuG3s9S+tlRkS
   sIFXhdGcaoEe3lzfnKNbvDHFCfcDnKP+fPFaTFUziCvBGV05Z3ZJlsYbJ
   F/6hvBC6g8f7/N+gpkNjV2qKzXTWCvaIDx3R5BjUO/Q21tXk30/8bXvzr
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677538800"; 
   d="scan'208";a="30520437"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 24 Apr 2023 16:02:24 +0200
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 1CB0C280056;
        Mon, 24 Apr 2023 16:02:24 +0200 (CEST)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: phy: Fix reading LED reg property
Date:   Mon, 24 Apr 2023 16:02:23 +0200
Message-ID: <4797433.GXAFRqVoOG@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <c01a4c59-6668-4ae7-b7cf-54d5a5a7e897@lunn.ch>
References: <20230424134003.297827-1-alexander.stein@ew.tq-group.com> <c01a4c59-6668-4ae7-b7cf-54d5a5a7e897@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Am Montag, 24. April 2023, 15:47:14 CEST schrieb Andrew Lunn:
> On Mon, Apr 24, 2023 at 03:40:02PM +0200, Alexander Stein wrote:
> > 'reg' is always encoded in 32 bits, thus it has to be read using the
> > function with the corresponding bit width.
>=20
> Hi Alexander
>=20
> Is this an endian thing? Does it return the wrong value on big endian
> systems?

It is an endian issue, but the platform's endianess doesn't matter here. Th=
e=20
encoding for device properties is (always) big-endian, so a 32-bit 'reg' va=
lue=20
of '2' looks like this:

$ hexdump -C /sys/firmware/devicetree/base/soc@0/bus@30800000/
ethernet@30bf0000/mdio/ethernet-phy@3/leds/led@2/reg
00000000  00 00 00 02                                       |....|
00000004

Using of_property_read_u8 will only read the first byte, thus all values of=
=20
reg result in 0.

> I deliberately used of_property_read_u8() because it will perform a
> range check, and if the value is bigger or smaller than 0-256 it will
> return an error. Your change does not include such range checks, which
> i don't like.

Sure, I can added this check.

Best regards,
Alexander
=2D-=20
TQ-Systems GmbH | M=FChlstra=DFe 2, Gut Delling | 82229 Seefeld, Germany
Amtsgericht M=FCnchen, HRB 105018
Gesch=E4ftsf=FChrer: Detlef Schneider, R=FCdiger Stahl, Stefan Schneider
http://www.tq-group.com/


