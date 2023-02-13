Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F00694E32
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjBMRh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBMRhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:37:54 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF1A5261;
        Mon, 13 Feb 2023 09:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=/IAgSLRmjox+nBqGHLuYLGATEI2cruuib9C6Ju7wXgw=;
        t=1676309872; x=1677519472; b=lrZ65kCta5KK2fdyh7xX6LsgsMlECPohEPZGfmTgWrNOSD0
        2/H3fatOsg+pEHbFcQzm7YSftBhPE4+YIpqFdJFCmQ0m48LwpIdlzZcFXbaS+rCUz+ICrNXWxDL7m
        Ck/5VJXPo06CFNtRx+tK7E/PBGEpOuWqoxpcSlKsYnpjHuF6pALaK/FP3/Rm/onebfIacZiVhajoN
        Blar7J0i5R9qtk/41gkLdFOWW8Cz4MFCmU5WdcfouO2TPJ8aNP732aMO2lAmqB0OUdYXLsMS9YGXC
        N3MfSMI/0ojkBvbHQsoxP6goqPRhq2norISaj24fHtsXGi2zsWd34KGcBVXbgotg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pRcll-00BHbK-0n;
        Mon, 13 Feb 2023 18:37:37 +0100
Message-ID: <3a9e70f9fe5ac0724730cb445b593fdb7eeeaae9.camel@sipsolutions.net>
Subject: Re: [PATCH v2] Set ssid when authenticating
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marc Bornand <dev.mbornand@systemb.ch>
Cc:     linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Yohan Prod'homme <kernel@zoddo.fr>, stable@vger.kernel.org
Date:   Mon, 13 Feb 2023 18:37:36 +0100
In-Reply-To: <NTBtzDurDf0W90JuEPzaHfxCYkWzyZ5jjPwcy6LpqebS6S1NekVcfBU3sNWczfvhHEJGOSyzQrb40UfSIK8AFZpd71MExKldK7EFnMkkdUk=@systemb.ch>
References: <20230213105436.595245-1-dev.mbornand@systemb.ch>
         <5a1d1244c8d3e20408732858442f264d26cc2768.camel@sipsolutions.net>
         <NTBtzDurDf0W90JuEPzaHfxCYkWzyZ5jjPwcy6LpqebS6S1NekVcfBU3sNWczfvhHEJGOSyzQrb40UfSIK8AFZpd71MExKldK7EFnMkkdUk=@systemb.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
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

As an aside - there's little point in encrypting the mail sent to me
when you send it also to a public list :) Just makes it more annoying to
use.

> > This is incorrect, doing an authentication doesn't require doing an
> > association afterwards, and doesn't necessarily imply any state change
> > in the kernel.
>=20
> So is it intended behavior that the ssid in wireless_dev is not set
> or is there a place were this state change should happen?

It's incorrect in that this is the wrong place to set it.

I don't have a strong feeling about whether it _should_ be set, but I
clearly assumed that it is indeed set ...

> > > alternatives:
> > > 1. Do the same but during association and not authentication.
> >=20
> >=20
> > Which should probably be done after successful authentication, even in
> > the CONNECT command case, which currently does it in cfg80211_connect()
> > but I guess that should move to __cfg80211_connect_result().
>=20
> Is there an existing way to get the ssid in __cfg80211_connect_result()?

There's the BSS, or multiple pointers for multi-link.

> Just a side question do the BSSes all have the same SSID?
>=20

In multi-link? Yes, I don't think we actively enforce that wpa_s does
that, but we'd probably fail to connect to the AP if that weren't the
case. So yeah. Maybe we should check it in assoc.

Here I think you can safely just pick any of the BSSes and look at the
SSID. Really we could even do the same in the nl80211 code, but it's
probably easier to fill in the ssid when we already have it anyway.

In the connect case it might be needed to fill it in earlier for use by
the SME state machine, not sure.

johannes
