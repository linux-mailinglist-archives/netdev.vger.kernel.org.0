Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2F06ECFEA
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 16:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbjDXOHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 10:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjDXOHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 10:07:02 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E7549D1
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 07:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1682345220; x=1713881220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pp9C0mULVgRTc7siUjzj93S1hbhCi4vRzlDcyKUiAzY=;
  b=FbwyxckiijpH1efbn3TVgiTLgmSzQIHXf/xQKMfq0rXGjt5Owp+xW9ZS
   fMFBvLuOEL5uQQ9OW68kjsvA+HezduBcXhELNdHIqCy7Nv+bpyKx8KbmI
   AphF3pH1tXf/qX6N411zKwXWrIy7nUrQhV/IUKe/tRpxIh4lrNFIFGxk2
   3BvSs5l//M2ErUXwIamk7FSKYz+GNTLruosd6OYVxlVrLPAkOAVmy/nf2
   QRFGS0RgKqPk9bkwA8Indk5vxZ/oedN8i1Ad5xV6joy3qeQ3uYAHqDT7C
   rQWC0IvxYsApqzTh4Ca9YwBojUTkp17VEGNNMTarqfEhssH5xrSrLjO8y
   g==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677538800"; 
   d="scan'208";a="30520649"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 24 Apr 2023 16:06:59 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 24 Apr 2023 16:06:59 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 24 Apr 2023 16:06:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1682345219; x=1713881219;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pp9C0mULVgRTc7siUjzj93S1hbhCi4vRzlDcyKUiAzY=;
  b=FQI8nNGeUQ2giareVClm4EvD84dDQiOZRzWNIbgGXSXhSEVYBvBIr7cA
   xSH0SXyisWIHPt7dNXSRxtQZT2o4kac6RsyVt5KbxqRD+cf5LQi29OkZT
   PZXMCgekStpWnCSrD6OW1nW0rG6xvFUYmAZL6xMT9920KumiSIFYe54qq
   9UCfSK/FsQjWZqgbzZxT216UbT6f1dD7ymV0J6FDVG/VNX3UE5lhgYURc
   /vY0BTasG+Vio4BgU2JvAS9+9g0DiINg54KQ8U40HOpWkYUE1nu66DpKJ
   GpAun19vlTUrrSrvW0V+vfHff175ktFxDmJUkaWjN42k4l1Zoaf2XCy5E
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677538800"; 
   d="scan'208";a="30520648"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 24 Apr 2023 16:06:58 +0200
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id C4408280056;
        Mon, 24 Apr 2023 16:06:58 +0200 (CEST)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: phy: dp83867: Add led_brightness_set support
Date:   Mon, 24 Apr 2023 16:06:58 +0200
Message-ID: <2142096.irdbgypaU6@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <82043096-636a-41ec-bf97-94f22f1920ce@lunn.ch>
References: <20230424134625.303957-1-alexander.stein@ew.tq-group.com> <82043096-636a-41ec-bf97-94f22f1920ce@lunn.ch>
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

Am Montag, 24. April 2023, 15:51:32 CEST schrieb Andrew Lunn:
> On Mon, Apr 24, 2023 at 03:46:25PM +0200, Alexander Stein wrote:
> > Up to 4 LEDs can be attached to the PHY, add support for setting
> > brightness manually.
>=20
> Hi Alexander
>=20
> Please see
> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
>=20
> You should put in the subject line which network tree this is for.

Ah, sorry wasn't aware of that.

> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Thanks, you want me to resend a v2 with the subject fixed and your tag adde=
d?

Best regards,
Alexander
=2D-=20
TQ-Systems GmbH | M=FChlstra=DFe 2, Gut Delling | 82229 Seefeld, Germany
Amtsgericht M=FCnchen, HRB 105018
Gesch=E4ftsf=FChrer: Detlef Schneider, R=FCdiger Stahl, Stefan Schneider
http://www.tq-group.com/


