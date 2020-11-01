Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F552A1D44
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 11:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgKAKaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 05:30:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgKAKaO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 05:30:14 -0500
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49B0320719;
        Sun,  1 Nov 2020 10:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604226613;
        bh=94+nsV21TCqPoQNytCQG0IKS8G6JKXA1BQCEGgBvOmg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jpl4s+CKL4r7Jo/ROrTKbk7WH77giR+DXA9ycpn/YZUtQEXnLLm2KgPmIssT6S/1l
         5BjCDWlhWRZceVpWT9effRu4xVM0PeSLqsE+83M8aAdhpsMS7vAKLmDqbrE1f28ZmD
         aoOAqclViZSIqB+0+QbNQtknNj/EczDOR13YEOGk=
Received: by mail-qk1-f179.google.com with SMTP id r7so9066382qkf.3;
        Sun, 01 Nov 2020 02:30:13 -0800 (PST)
X-Gm-Message-State: AOAM532O3ZWU310DC6kXc3TctrQw7YEsN8fEpAPgU/FjcvpV+DDLeHvN
        2CKNFBFTOz2sgcvneOYP8tnb28zboodThusx44o=
X-Google-Smtp-Source: ABdhPJxrDcnNF+ZfUz7cZqBpqxU984u3Rvdm9pSv7LtkG0JvPMTpve03xqgR9kGYa+LCzYjLy+h4BNbmfcixsRWJG1E=
X-Received: by 2002:a37:4e57:: with SMTP id c84mr10050470qkb.394.1604226612532;
 Sun, 01 Nov 2020 02:30:12 -0800 (PST)
MIME-Version: 1.0
References: <20201028070504.362164-1-xie.he.0141@gmail.com>
 <20201030200705.6e2039c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAJht_EOk43LdKVU4qH1MB5pLKcSONazA9XsKJUMTG=79TJ-3Rg@mail.gmail.com>
 <20201031095146.5e6945a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAK8P3a1kJT50s+BVF8-fmX6ctX2pmVtcg5rnS__EBQvseuqWNA@mail.gmail.com> <CAJht_EO0Wp=TVdLZ_8XK7ShXTUAmX-wb0UssTtn51DkPE266yQ@mail.gmail.com>
In-Reply-To: <CAJht_EO0Wp=TVdLZ_8XK7ShXTUAmX-wb0UssTtn51DkPE266yQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 1 Nov 2020 11:29:56 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1s58-u-T5cax+eW7_Q0=Yj7T3mfnBZSw24RErV5vCBJw@mail.gmail.com>
Message-ID: <CAK8P3a1s58-u-T5cax+eW7_Q0=Yj7T3mfnBZSw24RErV5vCBJw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dlci: Deprecate the DLCI driver (aka the
 Frame Relay layer)
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 1, 2020 at 12:37 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Sat, Oct 31, 2020 at 2:41 PM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > I think it can just go in the bin directly. I actually submitted a couple of
> > patches to clean up drivers/net/wan last year but didn't follow up
> > with a new version after we decided that x.25 is still needed, see
> > https://lore.kernel.org/netdev/20191209151256.2497534-1-arnd@arndb.de/
> >
> > I can resubmit if you like.
>
> Should we also remove the two macro definitions in
> "include/uapi/linux/sockios.h" (SIOCADDDLCI / SIOCDELDLCI), too? It
> seems to be not included in your original patch.

Not sure, it should probably at least be marked as 'obsolete' in the header
like SIOCGIFDIVERT, but removing the definitions might risk that someone
later reuses the numbers for a new command. I don't know if there is an
official policy for this. I see a couple of other definitions in the same file
that have no apparent implementation:
SIOCGIFCOUNT, SIOCDRARP, SIOCGRARP and SIOCSRARP. These
were still referenced in 2.6.12, but only in dead code that has since
been removed.

      arnd
