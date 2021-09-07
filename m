Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFED402DF4
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 19:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239840AbhIGRuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 13:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234449AbhIGRuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 13:50:03 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A772C061757
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 10:48:56 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id s10so21015165lfr.11
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 10:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bjCisZtyiZU0LQwOeq50RsYJm8zh3sRUcejawyWs6lU=;
        b=wmteHSfRwqG/ySfkjHDD1r+FmFQRX81yD5yQXmvHKwRnAtmnYC0LodQXNR0HrGOT0x
         pTKCzmkazPZJzoRM1P+TWSX8t3zWJpuuCd9uRVKiL9BBEpn1uaErmNrI8YJLJ9ciDLcR
         Q6NMfu2b7qpIWt8YLvDsNUgIZKkN13PYsW/F4YwyIzvTDwcTWlx4WIAFdeoncm42CFm9
         nUaDEx7vA32VrmTM3/i7mTz3OtL1fuUxNBjdLZVNtKLi5oDJE2pl6k/YND45MP/YPg/w
         BNMQFt9KIRmznWlN19UKMhU+O/ddHGm13HnR/jnAgLrcyTq1dhTp5Onf3MKRa1Ausb47
         6n5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bjCisZtyiZU0LQwOeq50RsYJm8zh3sRUcejawyWs6lU=;
        b=IJf1PG1qCF7Kr5xgpUTEL20D5pl9D/c1PjGI4/JQrMJyBXD1MS3GLg3bEsQ73nJ7MR
         k5vPyuuX/pEg7k51b3uQ+aJ+NFZidH4bzm5/uoLQjOZoBSmWNCv+p3LcxRWUFa02qNFn
         cPdTxGt47PYqKay2TWNE/sfSDHUTz40koJl2nsNfwL9FiwibBQ9DYaH5fR+0mKf68mee
         ROWfyQFMLTKxPe8IazI5iPLu+jEHoXc5+UoRQmRpKIo3MOXaYH8q0qrOn9fETLs2uBgT
         XpNWAto31K8kl+O1LHgAV6rkvPalbd6PGVAUZqzduz++wV82b1PtvKySpnRkRq5bMnqI
         VuYQ==
X-Gm-Message-State: AOAM533dcatI19vjD23m9v65Ifu2PJoBadd3NYLbe75SWbXyQkKJzmeI
        IvpmDfQrRjQfgQsF8Oj3N12n1Kwda3wHA1RrRe0Fzw==
X-Google-Smtp-Source: ABdhPJz2EPzZMWVdfMnV0euqBbeBksWmA24e9yEzRb7znw9ktyTzcukxU2qVnjFEfMl96VazxonrFDsBh9Gyk4c7w68=
X-Received: by 2002:a19:6455:: with SMTP id b21mr13171889lfj.656.1631036934764;
 Tue, 07 Sep 2021 10:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-6-linus.walleij@linaro.org> <20210830224626.dvtvlizztfaazhlf@skbuf>
In-Reply-To: <20210830224626.dvtvlizztfaazhlf@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 7 Sep 2021 19:48:43 +0200
Message-ID: <CACRpkdb7yhraJNH=b=mv=bE7p6Q_k-Yy0M9YT9QctKC1GLhVEw@mail.gmail.com>
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

On Tue, Aug 31, 2021 at 12:46 AM Vladimir Oltean <olteanv@gmail.com> wrote:

> > +     /* This will age out any L2 entries */
>
> Clarify "any L2 entries". The fdb flushing process should remove the
> dynamically learned FDB entries, it should keep the static ones. Did you
> say "any" because rtl8366rb does not implement static FDB entries via
> .port_fdb_add, and therefore all entries are dynamic, or does it really
> delete static FDB entries?

It's what Realtek calls "L2 entries" sadly I do not fully understand
their lingo.

The ASIC can do static L2 entries as well, but I haven't looked into
that. The (confused) docs for the function that set these bits is
the following:

"ASIC will age out L2 entry with fields Static, Auth and IP_MULT are 0.
 Aging out function is for new address learning LUT update because
 size of LUT is limited, old address information should not be kept and
 get more new learning SA information. Age field of L2 LUT is updated
 by following sequence {0b10,0b11,0b01,0b00} which means the LUT
 entries with age value 0b00 is free for ASIC. ASIC will use this aging
 sequence to decide which entry to be replace by new SA learning
 information. This function can be replace by setting STP state each
 port."

Next it sets the bit for the port in register
RTL8366RB_SECURITY_CTRL.

Realtek talks about "LUT" which I think is the same as "FDB"
(which I assume is forwarding database, I'm not good with this stuff).

My interpretation of this convoluted text is that static, auth and ip_mult
will *not* be affected ("are 0"), but only learned entries in the LUT/FDB
will be affected. The sequence listed in the comment I interpret as a
reference to what the ASIC is doing with the age field for the entry
internally to achieve this. Then I guess they say that one can also
do fast aging by stopping the port (duh).

I'll update the doc to say "any learned L2 entries", but eager to hear
what you say about it too :)

Yours,
Linus Walleij
