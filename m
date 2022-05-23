Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CF1530B46
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 11:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbiEWIdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 04:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbiEWIdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 04:33:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D82937025;
        Mon, 23 May 2022 01:33:51 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 67EE91F383;
        Mon, 23 May 2022 08:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653294830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HGRKxMXzRmZxPbqeCp3nH/JisTTafTR7VNUx1nyPrA0=;
        b=Fw4PPATbwIAM/+syB+5pNwbui6zzq48ItTTCRJoCdZxsq1oeLi5HUjJKkrHQrYOXiy6R17
        +bqvRSVTHw/Y39VQRaeeBUmpmR9qt0hE+UyJ/+X1a4TgPBvLPcIIB0sxPok9Tx4Bv0fXn6
        kTeFy5M9c1ROaqtzP+uCIdCFqncmFrs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653294830;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HGRKxMXzRmZxPbqeCp3nH/JisTTafTR7VNUx1nyPrA0=;
        b=w1UJ/lv2rM4pTCF88m3xyXaSpKqwbsTOVq4QJVvJSftW4VhvLptpMJJebYswy7a/fb5RBS
        BC3ow6030YTwz3Dw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4FA872C141;
        Mon, 23 May 2022 08:33:50 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E652760294; Mon, 23 May 2022 10:33:49 +0200 (CEST)
Date:   Mon, 23 May 2022 10:33:49 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: REGRESSION (?) (Re: [PATCH] net: af_key: add check for
 pfkey_broadcast in function pfkey_process)
Message-ID: <20220523083349.zzgdmoq2bzstxla6@lion.mk-sys.cz>
References: <20220517094231.414168-1-jiasheng@iscas.ac.cn>
 <20220523022438.ofhehjievu2alj3h@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r6vmbsg4u3vtaqzd"
Content-Disposition: inline
In-Reply-To: <20220523022438.ofhehjievu2alj3h@lion.mk-sys.cz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--r6vmbsg4u3vtaqzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 23, 2022 at 04:24:38AM +0200, Michal Kubecek wrote:
> After upgrading from 5.18-rc7 to 5.18 final, my racoon daemon refuses to
> start because it cannot find some algorithms (it says "aes"). I have not
> finished the debugging completely but this patch, mainline commit
> 4dc2a5a8f675 ("net: af_key: add check for pfkey_broadcast in function
> pfkey_process"), seems to be the most promising candidate.

Tested now, reverting commit 4dc2a5a8f675 ("net: af_key: add check for
pfkey_broadcast in function pfkey_process") seems to fix the issue,
after rebuilding the af_key module with this commit reverted and
reloading it, racoon daemon starts and works and /proc/crypto shows
algrorithms it did not without the revert.

We might get away with changing the test to

	if (err && err != -ESRCH)
		return err;

but I'm not sure if bailing up on failed notification broadcast is
really what we want. Also, most other calling sites of pfkey_broadcast()
do not check the return value either so if we want to add the check, it
should probably be done more consistently. So for now, a revert is IMHO
more appropriate.

Michal

--r6vmbsg4u3vtaqzd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmKLRuIACgkQ538sG/LR
dpWMpwgA0INRLLZ4ZINyjhZoeu1j1yh4Mwtsb/aGEW3OB2E+pZHsWwqDwoq++1vH
um5qLGrN6mrKIi9X3LhVKuXry2RGNW8rbTUaXihcg0JFl72XAXySQUwEh13Rn7D9
MgvSq4MznjNLuvfFBEWvkNaYbZ6NTVtlG2thTKi4GfftwsYsDWVQisCI4z2ZZ0Pn
Pd1j8thJreCJSNxoK8ylNyNkCAzLksItEivKz/UM+Y7HMpkI3nYZJLVAUVYZQKO6
97qCnqcMriy3XpDz6IVn6nVUHfGay8bmlfet67IOCrxYghyR47Wy147LP8+tVzrb
O46GqysFnczjK0px39AqsMrgUkp9sQ==
=ZgNq
-----END PGP SIGNATURE-----

--r6vmbsg4u3vtaqzd--
