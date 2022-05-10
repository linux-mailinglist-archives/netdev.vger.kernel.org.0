Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0158E521EEF
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346005AbiEJPit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346027AbiEJPii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:38:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9D38B09F;
        Tue, 10 May 2022 08:34:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B61E60AF0;
        Tue, 10 May 2022 15:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C76C385A6;
        Tue, 10 May 2022 15:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652196839;
        bh=pgb8769OYxRhML/WwKBmoyYizEniG9tvEh7SwUZMywI=;
        h=In-Reply-To:References:Cc:From:To:Subject:Date:From;
        b=iXE5LLq9iG+srf2kxMaLw6s9YbZsMkQkjosCYhdc9RPoF+dvJpDXaHj3W5S3Jc/RB
         fGcEWhBqe0H8MarAeNkp395L/lCjJWh2yFP3mLKVF3FNH/+2jMm/v/IpoALT52BN1E
         R8u/EnVAWB0zpw1qfmStZP2lVX0ZaILfdj8jG4LgwME3UJSkFcAmyx1uURSAFwP4wB
         WAQo4Qr0eyaLj6GildfaOzvkrt52ORyfXxihwvLzxZ+X+KSuXgGYBgEh8IC8mVh1QE
         XsvX7jdJzncFDLrpWwAnfH/03Tjz1LiPD2KuE74ZlW6TX/TxN8nVkORDAB9mAnEIJL
         Fn4xTcRWa4Rnw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Ynp/124xVt+lUa6f@lunn.ch>
References: <20220510142247.16071-1-wanjiabing@vivo.com> <165219411356.3924.11722336879963021691@kwain> <Ynp/124xVt+lUa6f@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
From:   Antoine Tenart <atenart@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2 net] net: phy: mscc: Add error check when __phy_read() failed
Message-ID: <165219683693.3924.12337336334738761045@kwain>
Date:   Tue, 10 May 2022 17:33:56 +0200
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Andrew Lunn (2022-05-10 17:08:07)
>=20
> But i doubt this impacts real users. MDIO tends to either work or not
> work at all. And not working is pretty noticeable, and nobody has
> reported issues.

Right. On top of that there are other calls to __phy_read in this driver
not checking the returned value. Plus all __phy_write calls. If that was
found by code inspection I would suggest to improve the whole driver and
not this function alone.

Thanks,
Antoine
