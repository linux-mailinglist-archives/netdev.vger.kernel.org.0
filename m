Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACBA52C2D7
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 21:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241844AbiERS7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 14:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241836AbiERS7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 14:59:43 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B80D3CA5B;
        Wed, 18 May 2022 11:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Fxox5gR67HutVJdNx8kOAn3Tka6TVzmmILwSzdfWpnQ=;
        t=1652900382; x=1654109982; b=kDn/aHwxbECndNhf32nkiAazm+3FWycykYakgUhAGD3gICN
        0tYzgmEU5jyzh6Dfig0ek0Q7izxy1jgpANasfYxzVLyT03pTWs7g7iE5wvk8XL1qQuvWFylXRT1D5
        imF3NAkD2VzJwfIYCCKJAZVlEs/AboZpZtKTiCHbZob5g+6HLI3yf4E0pGVVvKMJcR3ZY1ll3WjJH
        lCYUDs4od4Qznw2oAz5FMQ8fWwY7yYJg9RlY+5XlrVW6tAs00+AwYIDfPdhi8audDxGjK2Y9ZFkzU
        WfzSJS4375I5TG+eYiiV3habXxDgpTHfYNFglhbrG6QYpzQ2iVorNUhMrAbUibKg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nrOtG-00FWJQ-FQ;
        Wed, 18 May 2022 20:59:22 +0200
Message-ID: <d161164cbb1d048ce1b2d99d23ed87c605cfaa8c.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2] net: ifdefy the wireless pointers in struct
 net_device
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        alex.aring@gmail.com, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        linux-wireless@vger.kernel.org, linux-wpan@vger.kernel.org
Date:   Wed, 18 May 2022 20:59:21 +0200
In-Reply-To: <20220518181807.2030747-1-kuba@kernel.org>
References: <20220518181807.2030747-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-05-18 at 11:18 -0700, Jakub Kicinski wrote:
> Most protocol-specific pointers in struct net_device are under
> a respective ifdef. Wireless is the notable exception. Since
> there's a sizable number of custom-built kernels for datacenter
> workloads which don't build wireless it seems reasonable to
> ifdefy those pointers as well.
>=20
> While at it move IPv4 and IPv6 pointers up, those are special
> for obvious reasons.
>=20

Not sure if the "ifdefy" in the subject is intentional, reads a bit odd
to me :) but anyway looks good

Acked-by: Johannes Berg <johannes@sipsolutions.net>


Do you want me to follow up with trying to union the pointer into
ml_priv?

I prefer to union it rather than use ml_priv because we'll not want to
use the getter everywhere when we already know, only on the boundaries.

johannes
