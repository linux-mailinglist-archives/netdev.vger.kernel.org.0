Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC55523FC2
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 23:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344361AbiEKVzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 17:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243339AbiEKVzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 17:55:18 -0400
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD3016ABEB
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 14:55:17 -0700 (PDT)
Received: (qmail 13869 invoked from network); 11 May 2022 21:55:07 -0000
Received: from p200300cf0714e800cc89edd9cd300843.dip0.t-ipconnect.de ([2003:cf:714:e800:cc89:edd9:cd30:843]:36748 HELO daneel.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <kuba@kernel.org>; Wed, 11 May 2022 23:55:07 +0200
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        davem@davemloft.net, edumazet@google.com
Subject: Re: [PATCH] ethernet: tulip: fix missing pci_disable_device() on error in tulip_init_one()
Date:   Wed, 11 May 2022 23:55:04 +0200
Message-ID: <5568353.DvuYhMxLoT@daneel.sf-tec.de>
In-Reply-To: <20220506092152.405ce691@kernel.org>
References: <20220506094250.3630615-1-yangyingliang@huawei.com> <5564948.DvuYhMxLoT@eto.sf-tec.de> <20220506092152.405ce691@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5823012.lOV4Wx5bFT"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart5823012.lOV4Wx5bFT
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Freitag, 6. Mai 2022, 18:21:52 CEST schrieb Jakub Kicinski:
> On Fri, 06 May 2022 12:11:56 +0200 Rolf Eike Beer wrote:
> > Am Freitag, 6. Mai 2022, 11:42:50 CEST schrieb Yang Yingliang:
> > > Fix the missing pci_disable_device() before return
> > > from tulip_init_one() in the error handling case.
> > 
> > I would suggest removing the pci_disable_device() from tulip_remove_one()
> > instead and using pcim_enable_device(), i.e. devres, and let the driver
> > core handle all these things. Of course more of the used functions could
> > be converted them, e.g. using devm_alloc_etherdev() and so on.
> 
> Let's not rewrite the error handling in this dinosaur of a driver
> any more than absolutely necessary, please.

Challenge accepted ;)

[  274.452394] tulip0: no phy info, aborting mtable build
[  274.499041] tulip0:  MII transceiver #1 config 1000 status 782d advertising 01e1
[  274.750691] net eth0: Digital DS21142/43 Tulip rev 65 at MMIO 0xf4008000, 00:30:6e:08:7d:21, IRQ 17
[  283.104520] net eth0: Setting full-duplex based on MII#1 link partner capability of c1e1

Works fine, patch in a minute.
--nextPart5823012.lOV4Wx5bFT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCYnwwuAAKCRBcpIk+abn8
Ti85AJ9kQ7SD83xxU6gnW4mBa4gibh6QfgCeLiMiLBwYV6WZOMq/2YAj4ZVKgf4=
=pjR/
-----END PGP SIGNATURE-----

--nextPart5823012.lOV4Wx5bFT--



