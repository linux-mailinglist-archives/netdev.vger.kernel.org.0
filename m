Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F47A5F3D79
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 09:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiJDHvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 03:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiJDHvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 03:51:12 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4BA2B624;
        Tue,  4 Oct 2022 00:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Uf9y1Q5FeZRo3Kn1eduleYE4tdmn/F4uNHOsG12u5R8=;
        t=1664869871; x=1666079471; b=Ygcy8V3w9RADDTIhY8JdG3s8rA6LhfYERJHjik4A4C3V4U1
        0OmykRGmP3iKo/YZLoohbTRQI7oQm+KidH4lb3qXKT94BOiPZ5kPLPu/ddvy/CXhH7kMPGHEn6lqE
        e0WvTe/MEIwvMhEm4go8SIReMCM9mJ3Qb7v6npq9vwvfABWA5Joe6V0AYgIrswvIJsujiokBenZbR
        z8pU1n8OuBg5WxbsAeneEu1Vy+wLh+NgEfqoC05NP6ZTqRvOBnYDeWz+0y5EGQn1y5LLsRJdAnZHB
        olGrd+dPjvyZcn1D55MEIX6bYCpdPJ61j+DXhNr7qKzuwIZAcoTHp1bZ07JCVdeQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ofcho-00F5x0-1m;
        Tue, 04 Oct 2022 09:51:08 +0200
Message-ID: <62b8bf6f739d1e6e0320864ed0660c9c52b767c4.camel@sipsolutions.net>
Subject: Re: doc warnings in *80211
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Date:   Tue, 04 Oct 2022 09:51:07 +0200
In-Reply-To: <20221003191128.68bfc844@kernel.org>
References: <20221003191128.68bfc844@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> doing basic sanity checks before submitting the net-next PR I spotted
> that we have these warnings when building documentation on net-next:
>=20
> Documentation/driver-api/80211/cfg80211:48: ./include/net/cfg80211.h:6960=
: WARNING: Duplicate C declaration, also defined at driver-api/80211/cfg802=
11:6924.
> Declaration is '.. c:function:: void cfg80211_rx_assoc_resp (struct net_d=
evice *dev, struct cfg80211_rx_assoc_resp *data)'.

Hmm. That's interesting. I guess it cannot distinguish between the type
of identifier?

struct cfg80211_rx_assoc_resp vs. cfg80211_rx_assoc_resp()

Not sure what do about it - rename one of them?

> Documentation/driver-api/80211/mac80211:109: ./include/net/mac80211.h:504=
6: WARNING: Duplicate C declaration, also defined at driver-api/80211/mac80=
211:1065.
> Declaration is '.. c:function:: void ieee80211_tx_status (struct ieee8021=
1_hw *hw, struct sk_buff *skb)'.

Same here actually!

I don't think either of these is new.

johannes


