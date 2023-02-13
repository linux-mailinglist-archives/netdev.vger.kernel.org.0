Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C03695047
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 20:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjBMTFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 14:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjBMTFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 14:05:07 -0500
Received: from mail-4018.proton.ch (mail-4018.proton.ch [185.70.40.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D278383F1
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 11:04:55 -0800 (PST)
Date:   Mon, 13 Feb 2023 19:04:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemb.ch;
        s=protonmail; t=1676315075; x=1676574275;
        bh=IVH1eF2QOi9TT+7Xl+1GNhTkBmO7TAw26Zd/KlgBmsI=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=atLK00mOig7JZShnCGCmXgybNQlEhRsJpxugpMPIekCJptXFftLYyatPTBgdjVvdI
         djmHHIn+0TZ5c3qZI83mhQNFAbtWRlhVnVGm9yXPuywtd2qAtyg1emd1C8RIUVyvne
         WNCMC0Ll7OER/QSfH8tlSSC4oo6DOaUb0JgSiP+1ljGVnDuLeuoRmpoZyS154M2XeU
         pl4fu0d1n2G/nhekEn8aq3GxQlkCtqaF7l+FHgm4vGMqfWficdvYlo2Eg1wM9+RHaH
         l+Yglj6OI0GinwrZFwdQe68FMEWFH4oWIbNQY5SjaDcqmgF8+n9c/p8qOsL/SlJvjy
         j5Z6ZPGn18xOw==
To:     Johannes Berg <johannes@sipsolutions.net>
From:   Marc Bornand <dev.mbornand@systemb.ch>
Cc:     linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Yohan Prod'homme <kernel@zoddo.fr>, stable@vger.kernel.org
Subject: Re: [PATCH v2] Set ssid when authenticating
Message-ID: <IpEe-tq4Ss3KPNzL__A-DUEgn0MKIil7Hf02MWSUxV_mYXALCfMWfoZLQCiV6Rr5JGawMTI0FnKfNuQihm9WzLf-eGfeDOfU8sV9fzmBz8w=@systemb.ch>
In-Reply-To: <3a9e70f9fe5ac0724730cb445b593fdb7eeeaae9.camel@sipsolutions.net>
References: <20230213105436.595245-1-dev.mbornand@systemb.ch> <5a1d1244c8d3e20408732858442f264d26cc2768.camel@sipsolutions.net> <NTBtzDurDf0W90JuEPzaHfxCYkWzyZ5jjPwcy6LpqebS6S1NekVcfBU3sNWczfvhHEJGOSyzQrb40UfSIK8AFZpd71MExKldK7EFnMkkdUk=@systemb.ch> <3a9e70f9fe5ac0724730cb445b593fdb7eeeaae9.camel@sipsolutions.net>
Feedback-ID: 65519157:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, February 13th, 2023 at 18:37, Johannes Berg <johannes@sipsolutio=
ns.net> wrote:


>
>
> Hi,
>
> As an aside - there's little point in encrypting the mail sent to me
> when you send it also to a public list :) Just makes it more annoying to
> use.
Really Sorry, The mail service I am using is currently not letting me deact=
ivate
encryption for recipients with a wkd, I think I will try to contact support
and ask there.

>
> > > This is incorrect, doing an authentication doesn't require doing an
> > > association afterwards, and doesn't necessarily imply any state chang=
e
> > > in the kernel.
> >
> > So is it intended behavior that the ssid in wireless_dev is not set
> > or is there a place were this state change should happen?
>
>
> It's incorrect in that this is the wrong place to set it.
>
> I don't have a strong feeling about whether it should be set, but I
> clearly assumed that it is indeed set ...

The upstream behavior for know is that the SSID is not set in
wireless_dev.u.client.ssid, when cfg80211_connect is not used.
This is the case at least one some setup with iwd and wpa3.

>
> > > > alternatives:
> > > > 1. Do the same but during association and not authentication.
> > >
> > > Which should probably be done after successful authentication, even i=
n
> > > the CONNECT command case, which currently does it in cfg80211_connect=
()
> > > but I guess that should move to __cfg80211_connect_result().
> >
> > Is there an existing way to get the ssid in __cfg80211_connect_result()=
?
>
>
> There's the BSS, or multiple pointers for multi-link.
>
> > Just a side question do the BSSes all have the same SSID?
>
>
> In multi-link? Yes, I don't think we actively enforce that wpa_s does
> that, but we'd probably fail to connect to the AP if that weren't the
> case. So yeah. Maybe we should check it in assoc.
>
> Here I think you can safely just pick any of the BSSes and look at the
> SSID. Really we could even do the same in the nl80211 code, but it's
> probably easier to fill in the ssid when we already have it anyway.
>
> In the connect case it might be needed to fill it in earlier for use by
> the SME state machine, not sure.
>
> johannes


Marc
