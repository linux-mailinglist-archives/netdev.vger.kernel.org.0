Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA43751D585
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 12:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390879AbiEFKWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 06:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390874AbiEFKWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 06:22:35 -0400
X-Greylist: delayed 401 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 May 2022 03:18:51 PDT
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC065F8E4
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 03:18:51 -0700 (PDT)
Received: (qmail 10290 invoked from network); 6 May 2022 10:12:03 -0000
Received: from p200300cf070a0b0076d435fffeb7be92.dip0.t-ipconnect.de ([2003:cf:70a:b00:76d4:35ff:feb7:be92]:41972 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <linux-kernel@vger.kernel.org>; Fri, 06 May 2022 12:12:03 +0200
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org
Subject: Re: [PATCH] ethernet: tulip: fix missing pci_disable_device() on error in tulip_init_one()
Date:   Fri, 06 May 2022 12:11:56 +0200
Message-ID: <5564948.DvuYhMxLoT@eto.sf-tec.de>
In-Reply-To: <20220506094250.3630615-1-yangyingliang@huawei.com>
References: <20220506094250.3630615-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5819534.lOV4Wx5bFT"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart5819534.lOV4Wx5bFT
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Freitag, 6. Mai 2022, 11:42:50 CEST schrieb Yang Yingliang:
> Fix the missing pci_disable_device() before return
> from tulip_init_one() in the error handling case.

I would suggest removing the pci_disable_device() from tulip_remove_one() 
instead and using pcim_enable_device(), i.e. devres, and let the driver core 
handle all these things. Of course more of the used functions could be 
converted them, e.g. using devm_alloc_etherdev() and so on.

Eike
--nextPart5819534.lOV4Wx5bFT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCYnT0bAAKCRBcpIk+abn8
TpRJAKCSFE72ZhtgBsEs3gZhAmNmCY5v1ACgkwsyEadMyOecFRXMtHurVSrfEz0=
=LQcA
-----END PGP SIGNATURE-----

--nextPart5819534.lOV4Wx5bFT--



