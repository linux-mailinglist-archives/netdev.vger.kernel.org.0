Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E401E3DD2
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgE0Jpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbgE0Jpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 05:45:30 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA12C061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 02:45:30 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id 9so4877217ilg.12
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 02:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ylOLIZmgoLrafcWMOCtZQ7GWkqQGKLy7EBA7Ai1qPIQ=;
        b=McLPoF75QZ0Bh0EkfzbbltM3qNDz9bMdgUAwWjl2mqUgM/h4MZWYjFd3PfmRNQeKP/
         w0ICXniJuIwVrbvheWoFEubjaObUSeAgP/Zqzapzj8SI+6hhgTah1urCfBgtUepxcQwI
         chDUeeKWk1cAm13Rkq7I5kOkjFUCTwdOrg6DppYNqb7pZ+GFn0hMJIaGXkG6YfM17nIl
         bf340xY+mRIDJ1tTXZnsoOKhY1grSRzrujQFz0a52T1vq4EdGhIEqQnt2vdNkriLlGHF
         C5l5pzSUmT0tsvXR0IoWdVBHhsElhdDav3rbahvafREwxVTdOzyk8Bip3CMxwKrKl1Az
         TqNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ylOLIZmgoLrafcWMOCtZQ7GWkqQGKLy7EBA7Ai1qPIQ=;
        b=DG8Qky62Xw2sSHdiDoGlwgj12LP54bieKZYpIy5jYLcKo3d8PYWIaCEUCsAvAN/xyi
         tOhVAjfvrhH+EU/bsFfiKAgNmfGpgXiDEtRUlFfMkos2hTKa0yseqoek4n1toDQ5hYJb
         AuGSTqan8vr1B8aV0b0QR6OLHg+if7n8sJO/tiQsqg5DAm9TSz/YPOJaqyI3WpDbzjOn
         0m0A0KEbc1SLcq8dRItnZ5U0Id2VdzCVQqRy/RT/HmR/pY3NAuU6x+w6bvY1zqdUrC2G
         iYzVnl7LoE2K5RZpw+gUamsoQ0QtynQEzB83vcSiBp4pjVgUDtqManXhgai+clWKbhep
         OGYw==
X-Gm-Message-State: AOAM530URlJvUm75mXK/UelkUujjkI4mDFm7Bj1lNNBRtvBFB5FWvFwy
        mqMy2kXgkLw8i6dL+yfJBUHU3EqKOYpoIrSqxKJ0TA==
X-Google-Smtp-Source: ABdhPJz6vpHeGkRkiFn4BLn30H6XdjWxiDXExwhEqTkWGsK5oWtjgvQnfENj/n/IY8ZVsQgh0ssnU5ZtihQm96Ov1GE=
X-Received: by 2002:a92:d188:: with SMTP id z8mr4558104ilz.60.1590572729663;
 Wed, 27 May 2020 02:45:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200519120748.115833-1-brambonne@google.com> <CAKD1Yr2T2S__ZpPOwvwcUqbm=60E9OGODD7RXq+dUFAGQkWPWA@mail.gmail.com>
 <CABWXKLxGwWdYhzuUPFukUZ4F7=yHsYg+BJBi=OViyc42WSfKJg@mail.gmail.com>
In-Reply-To: <CABWXKLxGwWdYhzuUPFukUZ4F7=yHsYg+BJBi=OViyc42WSfKJg@mail.gmail.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Wed, 27 May 2020 18:45:18 +0900
Message-ID: <CAKD1Yr0ryFE+7ysrUKPvTfi5KNeibRBZjEzQX1K+oKQa0WNEhw@mail.gmail.com>
Subject: Re: [PATCH] ipv6: Add IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC mode
To:     =?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 10:17 PM Bram Bonn=C3=A9 <brambonne@google.com> wro=
te:
> The intention here (and below) was to keep the existing default
> behavior of using IN6_ADDR_GEN_MODE_STABLE_PRIVACY if stable_secret is
> set, while allowing to override this behavior by setting add_gen_mode
> to IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC. I tested this locally,
> and it seems to work as expected, but please let me know if you think
> the above approach does not make sense (or if you'd prefer
> IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC to be the default instead).

Yes, sorry, I think I was misreading the code.

> The RFC considers the generated identifiers as: "stable for each
> network interface within each subnet, but [changing] as a host moves
> from one network to another". If the MAC address stays stable for a
> specific subnet, this implementation fits that definition.

Makes sense to me.
