Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC19381DB0
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 11:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhEPJlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 05:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229455AbhEPJlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 May 2021 05:41:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21D7261183;
        Sun, 16 May 2021 09:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621158032;
        bh=HPHAfZvAU6XXPJgmrCVIHUbZpsx6IlX29XORpnfKmZQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YsQKZIwJh5KvtGgZZPg96UE6XZMndaOHN1BQahTZPkKub0arKiKy8nUhS4EylwQmp
         uF12aKbaukquUbBvW85QVTimNP0n3ZIdSbkDfEKkpWqBysPrJc+you91MBBvRdaJGI
         4w9/87kk0BkK1M2TsfnCuBIROHhTXe32KuEqkz/5q9RC3yFQxle6ffFfzHGxsCEVTM
         Z5vSgMQCzkSJdLPZOucsXuhhu6MlILCwjJIIGIHa6JDv81j/kJzs7iJYcXOssPElKz
         SmtHD0DptDzst7SO51cUyhGQxfNILB830mZb+GJNdOCuIwEPqISBnYzY9NUEon4a5U
         VWbZkYC7CJnxA==
Received: by mail-ot1-f41.google.com with SMTP id u19-20020a0568302493b02902d61b0d29adso3097549ots.10;
        Sun, 16 May 2021 02:40:32 -0700 (PDT)
X-Gm-Message-State: AOAM530+QdxvXH2XboYsyU4ORuzNmzgCDBtBusflAuUauCOt4ANUJSxh
        ChdmMa/dJSO6V0q2ItPoExu9yj02qU0HBIfWFFU=
X-Google-Smtp-Source: ABdhPJxEqdUoPYIQolx6YQg/gEdLuTmzfjwCY3mv54XNgVpzvySgnm359ZNikGDhue2q1sOqh/OPJhwqvmsGMVVpSdU=
X-Received: by 2002:a9d:222a:: with SMTP id o39mr44734707ota.246.1621158031417;
 Sun, 16 May 2021 02:40:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210515221320.1255291-1-arnd@kernel.org> <20210515221320.1255291-14-arnd@kernel.org>
 <d4e42d3-9920-8fe0-1a71-6c6de8585f4c@nippy.intranet> <CAMuHMdUJGxyL0kcj06Uxsxmf6bDj4UO_YKZPsZfxtTxCBXf=xg@mail.gmail.com>
In-Reply-To: <CAMuHMdUJGxyL0kcj06Uxsxmf6bDj4UO_YKZPsZfxtTxCBXf=xg@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 16 May 2021 11:39:25 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0BzbGFnWLKsdsFkRJ+GyxO7xgxeuipQrCi-p_JEeZNPQ@mail.gmail.com>
Message-ID: <CAK8P3a0BzbGFnWLKsdsFkRJ+GyxO7xgxeuipQrCi-p_JEeZNPQ@mail.gmail.com>
Subject: Re: [RFC 13/13] [net-next] 8390: xsurf100: avoid including lib8390.c
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        netdev <netdev@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Michael Schmitz <schmitzmic@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 16, 2021 at 11:04 AM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> On Sun, May 16, 2021 at 6:24 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> > On Sun, 16 May 2021, Arnd Bergmann wrote:
> > > From: Arnd Bergmann <arnd@arndb.de>
> > >
> > > This driver always warns about unused functions because it includes
> > > an file that it doesn't actually need:
> >
> > I don't think you can omit #include "lib8390.c" here without changing
> > driver behaviour, because of the macros in effect.
> >
> > I think this change would need some actual testing unless you can show
> > that the module binary does not change.
>
> Michael posted a similar but different patch a while ago, involving
> calling ax_NS8390_reinit():
> https://lore.kernel.org/linux-m68k/1528604559-972-3-git-send-email-schmitzmic@gmail.com/

Ah nice. As far as I can tell, the two versions are functionally equivalent
based on my reading of the port accessors, but he probably tested his
version, so I'll drop mine from this series. Nothing else depends on this
one, I just included it since it was an obvious thing to fix.

        Arnd
