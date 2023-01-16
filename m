Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18AE666B845
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 08:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjAPHfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 02:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbjAPHfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 02:35:52 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE061CDFD;
        Sun, 15 Jan 2023 23:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1673854551; x=1705390551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YszkHojPOFwKeLehYtOFvn3DFCgr8dW4CyaPruyHuVg=;
  b=jfc9N4Hvdi3gSQbC8i2nz1+0j0C5coSvQQ6TOoe0PQJrYFQKkSd+EVAr
   p69HK5NMRGgnglYfPIpcmmLLZNItDPKWf5pky2bN3taxTS+KyBuMU+hn2
   9MPL8NkSnxN0aIK5loSJjsOZMDrIRpXNdaKu5WaYcTFjt2dp+DZrq79Gn
   RG0sJ55i5c4rEAJKu8OxUGlGMu46w8eVGAuYhHbw7gvNiykG4hbgM8ldd
   PSob1H3NrSs6+JNIRqsIdxtt9jtkDnXSM0jMPOl9eoQKIT5VGFYY2Wz+w
   AYd9f82lj0PRFC13RXlM94HcR5XaOQZc9hwTSBiVK63U0jx5NQBGSPiFH
   w==;
X-IronPort-AV: E=Sophos;i="5.97,220,1669071600"; 
   d="scan'208";a="28437135"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 16 Jan 2023 08:35:48 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 16 Jan 2023 08:35:48 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 16 Jan 2023 08:35:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1673854548; x=1705390548;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YszkHojPOFwKeLehYtOFvn3DFCgr8dW4CyaPruyHuVg=;
  b=V05ZCuVQ0P+P7pIZXxuZzDIVOpW8NGDLQQ6vBAv2F5yTNr3TdUYXn90P
   anCVKU+wNqO3Dli0ABt4NlaL924jq1ewMEatIVaKuOEoQ4z2e9c6YyUJo
   s/8YY1VrS6hDX95szewhNKtnKmFxuie9Zo7UItYA1N1SGfQX5pcgnw6V5
   sANpjK47YtdMGk0Qf7jh8n25F2Y3vn8oAoVCFQzdo+0qHzaoktC7oWJK4
   uXyKZJUNC5Ro2UgPz5GQNL0Y+KCq1MG+DIrIL9LWnPF6hgiYW9HA5/4P4
   WkZUobrUt0qAKhdQtwNNPm3g9ygyFxqWo47NdNmuMq0gmgShIcgC7alH4
   g==;
X-IronPort-AV: E=Sophos;i="5.97,220,1669071600"; 
   d="scan'208";a="28437134"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 16 Jan 2023 08:35:48 +0100
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 2B9DF280056;
        Mon, 16 Jan 2023 08:35:48 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Pierluigi Passaro <pierluigi.passaro@gmail.com>
Cc:     Pierluigi Passaro <pierluigi.p@variscite.com>, wei.fang@nxp.com,
        shenwei.wang@nxp.com, xiaoning.wang@nxp.com, linux-imx@nxp.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eran.m@variscite.com,
        nate.d@variscite.com, francesco.f@variscite.com
Subject: Re: [PATCH v2] net: fec: manage corner deferred probe condition
Date:   Mon, 16 Jan 2023 08:35:46 +0100
Message-ID: <5899558.lOV4Wx5bFT@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <CAJ=UCjXvcpV9gAfXv8An-pp=CK8J=sGE_adAoKeNFG1C-sMgJA@mail.gmail.com>
References: <20230115213804.26650-1-pierluigi.p@variscite.com> <Y8R2kQMwgdgE6Qlp@lunn.ch> <CAJ=UCjXvcpV9gAfXv8An-pp=CK8J=sGE_adAoKeNFG1C-sMgJA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am Sonntag, 15. Januar 2023, 23:23:51 CET schrieb Pierluigi Passaro:
> On Sun, Jan 15, 2023 at 10:56 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > On Sun, Jan 15, 2023 at 10:38:04PM +0100, Pierluigi Passaro wrote:
> > > For dual fec interfaces, external phys can only be configured by fec0.
> > > When the function of_mdiobus_register return -EPROBE_DEFER, the driver
> > > is lately called to manage fec1, which wrongly register its mii_bus as
> > > fec0_mii_bus.
> > > When fec0 retry the probe, the previous assignement prevent the MDIO bus
> > > registration.
> > > Use a static boolean to trace the orginal MDIO bus deferred probe and
> > > prevent further registrations until the fec0 registration completed
> > > succesfully.
> > 
> > The real problem here seems to be that fep->dev_id is not
> > deterministic. I think a better fix would be to make the mdio bus name
> > deterministic. Use pdev->id instead of fep->dev_id + 1. That is what
> > most mdiobus drivers use.
> 
> Actually, the sequence is deterministic, fec0 and then fec1,
> but sometimes the GPIO of fec0 is not yet available.

Not in every case though. On i.MX6UL has the following memory map for FEC:
* FEC2: 0x020b4000
* FEC1: 0x02188000

Which essentially means that fec2 will be probed first.

> The EPROBE_DEFER does not prevent the second instance from being probed.
> This is the origin of the problem.

Is this the actual cause? There is also a problem in the case above if the 
MDIO controlling interface (fec2) is not probed first, e.g. using fec1 for 
MDIO access. But then again there is i.MX6ULG1 which only has fec1 
interface...

Best regards,
Alexander



