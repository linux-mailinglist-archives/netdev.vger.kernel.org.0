Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF80468D93B
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjBGNY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbjBGNY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:24:28 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9803C643
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 05:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1675776267; x=1707312267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yuTc+an2vt+XHQY2FqB0enOePJ4k/sSCwiXIWZkfupY=;
  b=dXpvSSv1oGB/9qBoyHqfwn+DMmfiGT48wyfrGqo/xQmKkmlVpMC1oyNa
   Gh3uy/QzUhczK5t5Mqr0ba8WHl5gHX++/r/L5uFhrvvb8HMVs/eD1I30T
   BiHQFwmhXA0LGClpf9X9Y5UQQ8Zn9qMbEdS0MtMJBkdajCi7TwMyRu97b
   VMD9H3hwWzQBrhFBPqw9E94fFXrLX6/meME27joVO5062WSlovGS/JAj0
   fkGUW79vxTba/1IVPwROYezF/UCl+KY8+lMTfPrI46YmQxihnV7A5EZYk
   RinbQnKyyLRGk1VWIkoD9MtQ5w4W/pTx6ME7mz9OHPmAJZufLA4pqxbQm
   A==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669071600"; 
   d="scan'208";a="28921672"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 07 Feb 2023 14:24:25 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Tue, 07 Feb 2023 14:24:25 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Tue, 07 Feb 2023 14:24:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1675776265; x=1707312265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yuTc+an2vt+XHQY2FqB0enOePJ4k/sSCwiXIWZkfupY=;
  b=W7bFnL9JkF2l8gqOHv8xGsQ/Cc1ode3qLK/zwelLBnSK29EbC1vHzJ+W
   nrQZN4BVclRAVG8DB7IYcb9Uj2M1XPw3K2/lbT2kd0QjiMmXwtyUk78e4
   g2racaOcU7k9B7iZk5GvxTIBLBbFghBy3/VcG/T7aLEucctNx7HhKz9VH
   WnSMw71Mo+mdE6UwiW4wcuyfi1I3WU10UlfYw0u22yfzd5asZT4YKVgLG
   00pppJyb8bilzzj+ei9Z9/8o7xzQhbUbe4i92mWg8SW69DYIpewFMGUHs
   dU38+XCoPUrQRdplDH4JIQj3PSw0GquP3MWdtu2s+xpJ0an8m9R4gZAka
   A==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669071600"; 
   d="scan'208";a="28921671"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 07 Feb 2023 14:24:24 +0100
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 784B3280056;
        Tue,  7 Feb 2023 14:24:24 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Wei Fang <wei.fang@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Lunn <andrew@lunn.ch>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: fec: Don't fail on missing optional phy-reset-gpios
Date:   Tue, 07 Feb 2023 14:24:22 +0100
Message-ID: <21769138.EfDdHjke4D@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <20230206223027.0d65ce10@kernel.org>
References: <20230203132102.313314-1-alexander.stein@ew.tq-group.com> <20230206223027.0d65ce10@kernel.org>
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

Am Dienstag, 7. Februar 2023, 07:30:27 CET schrieb Jakub Kicinski:
> On Fri,  3 Feb 2023 14:21:02 +0100 Alexander Stein wrote:
> > The conversion to gpio descriptors accidentally removed the short return
> > if there is no 'phy-reset-gpios' property, leading to the error
> > 
> > fec 30be0000.ethernet: error -ENOENT: failed to get phy-reset-gpios
> > 
> > This is especially the case when the PHY reset GPIO is specified in
> > the PHY node itself.
> > 
> > Fixes: 468ba54bd616 ("fec: convert to gpio descriptor")
> > Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> 
> Fixed around the same time by commit d7b5e5dd669436 right?

Yes, this does the trick as well. Thanks

Best regards
Alexander


