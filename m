Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62AE824EEF7
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 19:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgHWRTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 13:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgHWRTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 13:19:48 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0845FC061573
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 10:19:48 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l191so1300738pgd.5
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 10:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BS2nmejjK8PFe/qEJ+mPxfa0gAg77/DJy1RcdnRmJqo=;
        b=kDxSK0Pm+zdmrkB5fd83GDsg1eEmfcLeRDiPeLtUqPUraM/MgAaxOzQuexkQs5YsCm
         XxWSHF9v3a+3gSjRvgG5G7Y1wXGXm4lEnUvvjcDq4tbNyfsd72ZO+d8cgpJqzisZzEb8
         zPPcoyVh/u6RrMbduwuFjE4XHF/+hpyOBLqVJ7WRfM0Nxdi2gazt64njfM3alph30t3t
         hNhAsBXTiuX34GYiDlUKFZ6NjJ0c+d8n0KVh89xRVL1m9tGao9Jmgb22wBVfJWb6/QAe
         ZzISWiXMlZaaASyCKjAHIKr6oLKmUMWQl0rZFSO+xmDactrcpyWgY5+y9Q23VIpr0hvQ
         7UUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BS2nmejjK8PFe/qEJ+mPxfa0gAg77/DJy1RcdnRmJqo=;
        b=WpjNbVcu9NC9vQn1VukkbNOMdsWPyleB2swnhZTaUu5cTVGytOtJ89VtxoFqYvxcqI
         M2aavMnN1998WLILgNA+oTKQEPbpncUbsjBAkLUmNYqjFAO3pS8HVFOWLoAPxy3vQB7x
         vHXlr0R4CLikohnryLv5F5wB9m5/jOhElHub15vOZiCcEi8vgc4D4qkoPA1aCiblzNMo
         nEdPEJRluZAa0D1cagJenX7u6pBFlcZFvD825d7VGHuvVD5lBstlbCKcVQkB95MtacIn
         cukAIiOQdZK9lvj463JzpkJvm2KO29Ij47OybCCcqtvtw1ZEF4sJdJhcA5wB2WUa3kx9
         f15Q==
X-Gm-Message-State: AOAM530dD6v3RPfgkku7+jdEDKEjDX1BdROr4MeQudg6RE2v99qEK/Qg
        qCcSQK4uKCeyfpOMNFgALrbjehCEM5ItGA==
X-Google-Smtp-Source: ABdhPJy0TVFqXEPZRL8Pw/jPagZzQEQNsB0NeQ6x7scWtGbJDHgb1hU0rttkVKd1Me46cUzH4FJqqA==
X-Received: by 2002:a62:7c09:: with SMTP id x9mr1417461pfc.229.1598203186862;
        Sun, 23 Aug 2020 10:19:46 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f20sm8913784pfk.36.2020.08.23.10.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 10:19:46 -0700 (PDT)
Date:   Sun, 23 Aug 2020 10:19:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Linus =?UTF-8?B?TMO8c3Npbmc=?= <linus.luessing@c0d3.blue>
Cc:     netdev@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org, gluon@luebeck.freifunk.net,
        openwrt-devel@lists.openwrt.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [Bridge] [RFC PATCH net-next] bridge: Implement MLD Querier
 wake-up calls / Android bug workaround
Message-ID: <20200823101938.0f956d96@hermes.lan>
In-Reply-To: <20200823154239.GA2302@otheros>
References: <20200816202424.3526-1-linus.luessing@c0d3.blue>
        <20200816150813.0b998607@hermes.lan>
        <20200823154239.GA2302@otheros>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Aug 2020 17:42:39 +0200
Linus L=C3=BCssing <linus.luessing@c0d3.blue> wrote:

> On Sun, Aug 16, 2020 at 03:08:13PM -0700, Stephen Hemminger wrote:
> > Rather than adding yet another feature to the bridge, could this hack b=
e done by
> > having a BPF hook? or netfilter module? =20
>=20
> Hi Stephen,
>=20
> Thanks for the constructive feedback and suggestions!
>=20
> The netfilter approach sounds tempting. However as far as I know
> OpenWrt's firewall has no easy layer 2 netfilter integration yet.
> So it has default layer 3 netfilter rules, but not for layer 2.
>=20
> Ideally I'd want to work towards a solution where things "just
> work as expected" when a user enables "IGMP Snooping" in the UI.
> I could hack the netfilter rules into netifd, the OpenWrt network
> manager, when it configures the bridge. But not sure if the
> OpenWrt maintainers would like that...
>=20
> Any preferences from the OpenWrt maintainers side?
>=20
> Regards, Linus
>=20
>=20
> PS: With BPF I don't have that much experience yet. I would need
> to write a daemon which would parse the MLD packets and would
> fetch the FDB via netlink, right? If so, sounds like that would
> need way more than 300 lines of code. And that would need to be
> maintained within OpenWrt, right?

With BPF you would need to write a small program that transforms the packet
as you want. The BPF program and the userspace program would share a
map table.  The userspace program would monitor netlink messages about
FDB and update the map. Yes it would be a few hundred lines but not huge.
The userspace could even be selective and only do it for devices where
it knows they are using the broken Android code.

Sorry, no idea how OpenWrt manages their packages.
