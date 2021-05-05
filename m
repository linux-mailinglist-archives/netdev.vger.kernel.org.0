Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A891237473C
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbhEERwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:52:06 -0400
Received: from conssluserg-01.nifty.com ([210.131.2.80]:52091 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235138AbhEERvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 13:51:37 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 145Ho7xR027133;
        Thu, 6 May 2021 02:50:07 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 145Ho7xR027133
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1620237007;
        bh=jvguRX8pqZ4XJCYrxdDcZZ1jIBmYyFi1DYiU2rFpI+Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=g8v3452gN8HaY+3KgC7mg7IEMQEerT886lesiQ1r8/d0W1p4gS6kMxU8C9A/AgNsc
         4BqbErAbLtcOu/6o4aQd6nH+hNpSzMarCyqxdV6c+502rITlc8wHMIjEF/g5SnrqTn
         5Lu+vBoxlC0O5LS7DrQfhTyudOyP5URKBYS2EPTUaxGNJzvAjW+FHIFA5buPeP9itZ
         1SbdmcqgX23H+/1g0Yj9WmLTXKIcOUr4I9iAwMHg4oSlVsMM/CU+6Dzyr5zL2qJSH8
         sD48jJq2vZKch0zuYbexhyEioo1Zfg/1aBYyv20rTNZLOTiGMMoQtUPVGuDMmicqGg
         iSg69+xvxX+Dg==
X-Nifty-SrcIP: [209.85.216.46]
Received: by mail-pj1-f46.google.com with SMTP id gj14so1231987pjb.5;
        Wed, 05 May 2021 10:50:07 -0700 (PDT)
X-Gm-Message-State: AOAM533qZoZhWSjvsN8NPC2DfuR77N+87QqjuuDm8KasFqHwWAaBSnig
        PXP4XAy+JXYnJPLQlqplLX9VJZSMFM6j6vrtOwE=
X-Google-Smtp-Source: ABdhPJwOlYfRNDTIvaamvhcY4mlQDjji6m4TpH8m4X/qsM5m/Jz/mF2aR5QVqUmET8K1YE+Ov90kjSkFJG3e6YThBA0=
X-Received: by 2002:a17:902:32b:b029:ee:fa93:9551 with SMTP id
 40-20020a170902032bb02900eefa939551mr216769pld.47.1620237006584; Wed, 05 May
 2021 10:50:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210424114841.394239-1-masahiroy@kernel.org> <2f8ccc46-16a1-e0fe-7cb0-0912295153ee@tessares.net>
In-Reply-To: <2f8ccc46-16a1-e0fe-7cb0-0912295153ee@tessares.net>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 6 May 2021 02:49:26 +0900
X-Gmail-Original-Message-ID: <CAK7LNASz11t3YQ509CYbpLDFOmo7eJkT78KKQjCqLR-FKKLZnA@mail.gmail.com>
Message-ID: <CAK7LNASz11t3YQ509CYbpLDFOmo7eJkT78KKQjCqLR-FKKLZnA@mail.gmail.com>
Subject: Re: [PATCH] kbuild: replace LANG=C with LC_ALL=C
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthias Maennich <maennich@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, mptcp@lists.01.org,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 4:30 AM Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
>
> Hi,
>
> Thank you for the patch!
>
> On 24/04/2021 13:48, Masahiro Yamada wrote:
> > LANG gives a weak default to each LC_* in case it is not explicitly
> > defined. LC_ALL, if set, overrides all other LC_* variables.
> >
> >   LANG  <  LC_CTYPE, LC_COLLATE, LC_MONETARY, LC_NUMERIC, ...  <  LC_ALL
> >
> > This is why documentation such as [1] suggests to set LC_ALL in build
> > scripts to get the deterministic result.
> >
> > LANG=C is not strong enough to override LC_* that may be set by end
> > users.
> >
> > [1]: https://reproducible-builds.org/docs/locales/
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > ---
> >
> >  arch/powerpc/boot/wrapper                          | 2 +-
> >  scripts/nsdeps                                     | 2 +-
> >  scripts/recordmcount.pl                            | 2 +-
> >  scripts/setlocalversion                            | 2 +-
> >  scripts/tags.sh                                    | 2 +-
> >  tools/testing/selftests/net/mptcp/mptcp_connect.sh | 2 +-
>
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net> (mptcp)
>
> Cheers,
> Matt
> --
> Tessares | Belgium | Hybrid Access Solutions
> www.tessares.net


Applied to linux-kbuild.


-- 
Best Regards
Masahiro Yamada
