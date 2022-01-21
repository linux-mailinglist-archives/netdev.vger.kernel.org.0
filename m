Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E29495897
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiAUDnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbiAUDnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 22:43:09 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67D4C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 19:43:08 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id v74so4453007pfc.1
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 19:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yqhczBMRKsOUw24Qte/I7JFi4WVSDDwpH9M4zhQm5Cw=;
        b=jhS+UwOXraTlDz7g0YmQpk/Wi6cK4vngfTjMDIWFz145li5UMsrnt5G1/pNJgvKZKI
         Gq313UYDahAJWl2xJ5MWw/yNjcE8xkaVBrJwQJVTTycHW+YxYMThwVn7eotN8Ecvrdm1
         A7/dBY3pFp9k1at45VATbDfGJyXyzxD38i7X62sTNNigipei8VTziQMhVMj9GHBQXchE
         pUU4kZzYm2R+FFn37TciC+Y6GB4AgAPHDLP118sx534NnasEgsmEXwz4VYi7nG3j2RRx
         ZlsAbMZeYvPZHWkC9ZvNpV4XUMC/Nl2/nS0deGQrXT115EStsxqdlb1uLPlcAW4x9lov
         T0ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yqhczBMRKsOUw24Qte/I7JFi4WVSDDwpH9M4zhQm5Cw=;
        b=RaZbA2bllLf7SIW9A6FUZKFySz2egN/gw6VyN6jAl1vVTDV36znlfRjviJn3P70OPt
         UVDaSA9CLCSBPt0JIIJMCj4CZ/KS2P+Rd40zYXOJGz7lLYC7pn/jKOoT201rssefD5VZ
         tXRj7DUEoGqrN5G5Wjsj4ZP0vEjqwwDz9dfFECCfGGxnV7ft4Rs0Qb3icwLUTMZFwJvd
         XY9l4kNCBls7QB217YAfm2C/Fbl3maAeqzMQbgayqN0KRHuoUu4Z8SnmOaE1ueaCCII0
         7e3YTn2X8svoS0w59A88a503bAqeQH5XgaiK0op3M4Jnk5QDttDhvO32/3AEfaxJaPrq
         7ovQ==
X-Gm-Message-State: AOAM531GCav7z/5vBNUiSTNthVp+UmMrNgQuy6c7IOBrYrHxJyFw1LO6
        x2RiCjpr3qYhFNYySzRITQYjjIJcraBen0kEnDM=
X-Google-Smtp-Source: ABdhPJwbAlYt+vsnlqRkSbK4Gw2XsrMOVf7BpXO7pCCCL/HnrTGSU1x5azEgFuk7Qyvms949/D2RHkHThsAaiE0lluQ=
X-Received: by 2002:a63:8a44:: with SMTP id y65mr1556168pgd.456.1642736588103;
 Thu, 20 Jan 2022 19:43:08 -0800 (PST)
MIME-Version: 1.0
References: <87ee5fd80m.fsf@bang-olufsen.dk> <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk> <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk> <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <Yea+uTH+dh9/NMHn@lunn.ch> <20220120151222.dirhmsfyoumykalk@skbuf>
 <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
 <20220121020627.spli3diixw7uxurr@skbuf> <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
 <f85dcb52-1f66-f75a-d6de-83d238b5b69d@gmail.com>
In-Reply-To: <f85dcb52-1f66-f75a-d6de-83d238b5b69d@gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 21 Jan 2022 00:42:57 -0300
Message-ID: <CAJq09z5Pvo4tJNw0yKK2LYSNEdQTd4sXPpKFJbCNA-jUwmNctw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Are we talking about an in tree driver? If so which is it?

Yes, the one the patch touches: rtl8365mb.

My device uses a mt7620a SoC and traffic passes through its mt7530
switch with vlan disabled before reaching the realtek switch. It still
loads a swconfig driver but I think it might work without one.
I just didn't stop to try it yet.
