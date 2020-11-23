Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0352BFEC2
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 04:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgKWDhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 22:37:35 -0500
Received: from conssluserg-06.nifty.com ([210.131.2.91]:60881 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgKWDhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 22:37:35 -0500
X-Greylist: delayed 114773 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Nov 2020 22:37:34 EST
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 0AN3atLh032027;
        Mon, 23 Nov 2020 12:36:56 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 0AN3atLh032027
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1606102616;
        bh=YL64JWX8+POTNkn/GZ7B+nszuW5O8YQqSfoss8+OVhk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ooQtKrxm1EI5JJsobUKyeYXAjIV+RoefFSoPmKabq0sodI0Y1kw+Yxf5jMgOU3v1w
         W5HSJfgC7Ej7Hg80VGtMAFcmNyxPtUQaK73w6lhwLwGliH3flZ7yc57MtqiU0FIx1m
         6ei0KbX+XgpmmGOGSBQzYwXM2775PqN2AfMu9nvZqWvl9UpfrzAvVIN8/t7ILYBwYH
         45J1SGSHpQVjwYtVGtQYTkEn2Kr42iG243csfHSuHHxaWZznhqAqqXpo8QhOA2CISk
         fTy4GoIZHjWNKw1q5jrUotX5w6+Bpqm4pJdEapeAZihlZrCYUbcY4lRZB9/0cdKDIn
         5Z0iWPVnvOMWg==
X-Nifty-SrcIP: [209.85.214.174]
Received: by mail-pl1-f174.google.com with SMTP id p6so5794187plr.7;
        Sun, 22 Nov 2020 19:36:55 -0800 (PST)
X-Gm-Message-State: AOAM531WfhrVdtMP9OyP5ISyB7HQDflJ/SYNzwEHso0Q801m5Q3ktDC6
        0MTESIXBhHJtfiI9lAS6ceYpFz0FcBrgmLPCrqE=
X-Google-Smtp-Source: ABdhPJzNuqDamg2p4M+v2AI8oS/thdIABCwyrr94QP7NGfbG5kGWuCZOsctgZMaDSWL8YqmDoi92WL62fYY5d0QrEd4=
X-Received: by 2002:a17:902:ff0e:b029:d6:820d:cb81 with SMTP id
 f14-20020a170902ff0eb02900d6820dcb81mr22899656plj.47.1606102615011; Sun, 22
 Nov 2020 19:36:55 -0800 (PST)
MIME-Version: 1.0
References: <20201121194339.52290-1-masahiroy@kernel.org> <CANiq72nL7yxGj-Q6aOxG68967g_fB6=hDED0mTBrZ_SjC=U-Pg@mail.gmail.com>
In-Reply-To: <CANiq72nL7yxGj-Q6aOxG68967g_fB6=hDED0mTBrZ_SjC=U-Pg@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 23 Nov 2020 12:36:18 +0900
X-Gmail-Original-Message-ID: <CAK7LNARjU5HTcTjJG1-sQTJBFqohC1O8aAvFs3Hn_sXscH_pdg@mail.gmail.com>
Message-ID: <CAK7LNARjU5HTcTjJG1-sQTJBFqohC1O8aAvFs3Hn_sXscH_pdg@mail.gmail.com>
Subject: Re: [PATCH] compiler_attribute: remove CONFIG_ENABLE_MUST_CHECK
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Shuah Khan <shuah@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        wireguard@lists.zx2c4.com,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 5:45 AM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Sat, Nov 21, 2020 at 8:44 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> >
> > Our goal is to always enable __must_check where appreciate, so this
> > CONFIG option is no longer needed.
>
> This would be great. It also implies we can then move it to
> `compiler_attributes.h` since it does not depend on config options
> anymore.
>
> We should also rename it to `__nodiscard`, since that is the
> standardized name (coming soon to C2x and in C++ for years).
>
> Cc'ing the Clang folks too to make them aware.
>

I can move it to compiler_attribute.h

This attribute is supported by gcc, clang, and icc.
https://godbolt.org/z/ehd6so

I can send v2.



I do not mind renaming, but it should be done in a separate patch.




-- 
Best Regards
Masahiro Yamada
