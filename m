Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F17F4BA5B1
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 17:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239320AbiBQQYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 11:24:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiBQQYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 11:24:54 -0500
X-Greylist: delayed 162 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Feb 2022 08:24:39 PST
Received: from condef-02.nifty.com (condef-02.nifty.com [202.248.20.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBEC23C869
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 08:24:39 -0800 (PST)
Received: from conssluserg-03.nifty.com ([10.126.8.82])by condef-02.nifty.com with ESMTP id 21HGIPTQ027374;
        Fri, 18 Feb 2022 01:18:25 +0900
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id 21HGI8NA031377;
        Fri, 18 Feb 2022 01:18:08 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 21HGI8NA031377
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1645114688;
        bh=Evn3QxAJ3AK623czP1KMQcw+4ELyfCxTkHQ5Lw0/E5s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jySjE2TzRv0gSlv7h6ZRl9dlkxrzl7OH8OqFVMQ4aN60wdW1UG3P99QU/SIDcnPYj
         /ICUgKlYytLyV0isp2pXf90jmA3ySgld25u06yDQQS+Yk5/3okj8fm9mmSmxvY1J6u
         bj0I2BA32pRAiVLkeAZm7lb1gSoZYX5KxiTQTbW8Hip72bUJ3GkChhf2zPUrg6hNID
         2/KGdWCSlXJqiJQOIzRRnzdJJlJV+E3vVnCNhhyEFS78EbmPx8fBKVM+Lwl6xnWemu
         fYS4UB2JYIQ/Xillu+F2HkX7Mqn6ih8gWlrlzV3dvosCGinGQbvF7+1Tn9ww00rsa6
         uwJz8gADf32CA==
X-Nifty-SrcIP: [209.85.210.180]
Received: by mail-pf1-f180.google.com with SMTP id z16so98666pfh.3;
        Thu, 17 Feb 2022 08:18:08 -0800 (PST)
X-Gm-Message-State: AOAM533Tdgg+QppF39AS1md67zTSOUvkjcao/o+s9VdAjM0OW/jJvNfk
        7ykohGGYkxj3wVdSq1f/Bnx1aE+sEdDIaxasgGg=
X-Google-Smtp-Source: ABdhPJxG74jrNQGUDFWqFZtiqdH5h/m+m6m6q6zil5UZDbpeBqPqUekmytPGczpLxC7Oa4jn7eJzRi7FeZ65GrbyJEc=
X-Received: by 2002:a65:5341:0:b0:363:da77:99df with SMTP id
 w1-20020a655341000000b00363da7799dfmr2959567pgr.126.1645114687528; Thu, 17
 Feb 2022 08:18:07 -0800 (PST)
MIME-Version: 1.0
References: <978951d76d8cb84bab347c7623bc163e9a038452.1645100305.git.christophe.leroy@csgroup.eu>
 <35bcd5df0fb546008ff4043dbea68836@AcuMS.aculab.com> <d38e5e1c-29b6-8cc6-7409-d0bdd5772f23@csgroup.eu>
 <9b8ef186-c7fe-822c-35df-342c9e86cc88@csgroup.eu> <3c2b682a7d804b5e8749428b50342c82@AcuMS.aculab.com>
In-Reply-To: <3c2b682a7d804b5e8749428b50342c82@AcuMS.aculab.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Fri, 18 Feb 2022 01:17:27 +0900
X-Gmail-Original-Message-ID: <CAK7LNASWTJ-ax9u5yOwHV9vHCBAcQTazV-oXtqVFVFedOA0Eqw@mail.gmail.com>
Message-ID: <CAK7LNASWTJ-ax9u5yOwHV9vHCBAcQTazV-oXtqVFVFedOA0Eqw@mail.gmail.com>
Subject: Re: [PATCH net v3] net: Force inlining of checksum functions in net/checksum.h
To:     David Laight <David.Laight@aculab.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 12:15 AM David Laight <David.Laight@aculab.com> wro=
te:
>
> From: Christophe Leroy
> > Sent: 17 February 2022 14:55
> >
> > Le 17/02/2022 =C3=A0 15:50, Christophe Leroy a =C3=A9crit :
> > > Adding Ingo, Andrew and Nick as they were involved in the subjet,
> > >
> > > Le 17/02/2022 =C3=A0 14:36, David Laight a =C3=A9crit :
> > >> From: Christophe Leroy
> > >>> Sent: 17 February 2022 12:19
> > >>>
> > >>> All functions defined as static inline in net/checksum.h are
> > >>> meant to be inlined for performance reason.
> > >>>
> > >>> But since commit ac7c3e4ff401 ("compiler: enable
> > >>> CONFIG_OPTIMIZE_INLINING forcibly") the compiler is allowed to
> > >>> uninline functions when it wants.
> > >>>
> > >>> Fair enough in the general case, but for tiny performance critical
> > >>> checksum helpers that's counter-productive.
> > >>
> > >> There isn't a real justification for allowing the compiler
> > >> to 'not inline' functions in that commit.
> > >
> > > Do you mean that the two following commits should be reverted:
> > >
> > > - 889b3c1245de ("compiler: remove CONFIG_OPTIMIZE_INLINING entirely")
> > > - 4c4e276f6491 ("net: Force inlining of checksum functions in
> > > net/checksum.h")
> >
> > Of course not the above one (copy/paste error), but:
> > - ac7c3e4ff401 ("compiler: enable CONFIG_OPTIMIZE_INLINING forcibly")
>
> That's the one I looked at.



No.  Not that one.

The commit you presumably want to revert is:

a771f2b82aa2 ("[PATCH] Add a section about inlining to
Documentation/CodingStyle")

This is now referred to as "__always_inline disease", though.




CONFIG_OPTIMIZE_INLINING has 14 years of history for x86.
See commit 60a3cdd06394 ("x86: add optimized inlining").
We always give gcc freedom to not inline functions marked as inline.




--=20
Best Regards
Masahiro Yamada
