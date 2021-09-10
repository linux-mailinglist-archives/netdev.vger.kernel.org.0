Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B582D406D3A
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 15:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhIJOAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 10:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbhIJOAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 10:00:42 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3063AC061574
        for <netdev@vger.kernel.org>; Fri, 10 Sep 2021 06:59:31 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id l11so4281323lfe.1
        for <netdev@vger.kernel.org>; Fri, 10 Sep 2021 06:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ikobjS39t+2GVrDs1bnGHPZh46dgCpWKl/cyk8+Elkk=;
        b=cWpgnJ6jlhaU2t8p7lGWY3HdbXm3tfjrW6Y5rC0oU3vGwbHGJUYCr/EU1623Ge6lib
         f2gJVxTu3tW+mDSEq2dYpc0VGwYrJ7R+WvoII2g8juSiPFaveEkADWVvR54iD+rhlcCY
         XsHgH9F+uEujTmUDFdrfiK8igAC/k3UUnEgHfrv6V+gjXhpzG72fJysIxKw8DRQztK4+
         CKqK6/sfStfN2ORyWVh6/jUhvpNeNli6pfdq8un3soSXamqGCcLML5ez99vjGL680HdK
         uyVrtAMSPOfvsths1kIE/cJWaWxKm5E5zK1z96h+FALmxVxUbjSaI9NQmugkMgSd5bkt
         yFVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ikobjS39t+2GVrDs1bnGHPZh46dgCpWKl/cyk8+Elkk=;
        b=WziWpkyX47VjEdvItR5fCM5MrN5TDpqesNDBOQJc+4jvSK22r3RsR/fj2TP8qw5n4Q
         S6Z2f+zSbVs4pMnd6I0UO/v3lE/bd+Jk3AYt9RQDEKjNSI9m8jYDe9aqqGeXVAyM8xT6
         V54o69Mcr9u1iqlJeVfcA7w1a7xX5A8+pU0OlZBM4UpcaAwDXWBoOffNlErtz6KxdT9I
         QvDE8P8LpC4+s6W5lD+9XdshLpRG0qxbgYBWiWQgP8rBlXRN/47F8r8p2JRWyC4ILxQ9
         KNmP0ZcBhb/rQXGDzbCjMsqCOb+s1AsGx5EuNNUvXyt12wumg4DPX32uKBr5u5YGNC8E
         G5cQ==
X-Gm-Message-State: AOAM5312SnbPgJ+PRSe83je0ZLz2nv452F3gUFvFLBxSdjTCrF7tQZF9
        5oQ1wy0KZ6yZJwjvq5dGkwWBYqN1crGmGliqO5QEig==
X-Google-Smtp-Source: ABdhPJyj55oSx69re4eSVI+sY5ZDfciG0X/AplwmfF86KlVdAKjCPze0JEwuGO0GV31SIu2Eir1t+3X79J15rKcTpFY=
X-Received: by 2002:a05:6512:132a:: with SMTP id x42mr3903346lfu.291.1631282369433;
 Fri, 10 Sep 2021 06:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-6-linus.walleij@linaro.org> <20210830224626.dvtvlizztfaazhlf@skbuf>
 <CACRpkdb7yhraJNH=b=mv=bE7p6Q_k-Yy0M9YT9QctKC1GLhVEw@mail.gmail.com> <20210908201032.nzej3btytfhfta2u@skbuf>
In-Reply-To: <20210908201032.nzej3btytfhfta2u@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 10 Sep 2021 15:59:18 +0200
Message-ID: <CACRpkdbgq5o3au1LHUM9Ep2B3syB+r-3=vBan1obL5Z4cekBqA@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5 v2] net: dsa: rtl8366rb: Support fast aging
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 8, 2021 at 10:10 PM Vladimir Oltean <olteanv@gmail.com> wrote:

> Your interpretation seems correct (I can't think of anything else being meant),
> but I don't know why you say "duh" about the update of STP state
> resulting in the port losing its dynamic L2 entries. Sure, it makes
> sense, but many other vendors do not do that automatically, and DSA
> calls .port_fast_age whenever the STP state transitions from a value
> capable of learning (LEARNING, FORWARDING) to one incapable of learning
> (DISABLED, BLOCKING, LISTENING).
>
> To prove/disprove, it would be interesting to implement port STP states,
> without implementing .port_fast_age, force a port down and then back up,
> and then run "bridge fdb" and see whether it is true that STP state
> changes also lead to FDB flushing but at a hardware level (whether there
> is any 'self' entry being reported).

I have been looking into this.

What makes RTL8366RB so confusing is a compulsive use of FIDs.

For example Linux DSA has:

ds->ops->port_stp_state_set(ds, port, state);

This is pretty straight forward. The vendor RTL8366RB API however has this:

int32 rtl8368s_setAsicSpanningTreeStatus(enum PORTID port, enum
FIDVALUE fid, enum SPTSTATE state)

So this is set per FID instead of per VID.

I also looked into proper FDB support and there is the same problem.
For example I want to implement:

static int rtl8366rb_port_fdb_add(struct dsa_switch *ds, int port,
                  const unsigned char *addr, u16 vid)

But the FDB static (also autolearn) entries has this format:

struct l2tb_macstatic_st{
    ether_addr_t     mac;
    uint16     fid:3;
    uint16     reserved1:13;
    uint16     mbr:8;
    uint16     reserved2:4;
    uint16    block:1;
    uint16     auth:1;
    uint16     swst:1;
    uint16     ipmulti:1;
    uint16     reserved3;
};

(swst indicates a static entry ipmulti a multicast entry, mbr is apparently
for S-VLAN, which I'm not familiar with.)

So again using a FID rather than port or VID in the database.

I am starting to wonder whether I should just associate 1-1 the FID:s
with the 6 ports (0..5) to simplify things. Or one FID per defined VID
until they run out, as atleast OpenWRT connects VLAN1 to all ports on
a bridge.

Yours,
Linus Walleij
