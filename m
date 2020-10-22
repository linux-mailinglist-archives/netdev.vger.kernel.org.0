Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AE02960CA
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 16:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900769AbgJVOTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 10:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2900666AbgJVOTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 10:19:38 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5454DC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 07:19:38 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id p9so1886568ilr.1
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 07:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xMUtvpan88Ge3846vksyEMrhRvz63V7NUsP6JGFKyHw=;
        b=is+YoGrhpxO/wdV9sbEaVWw+G0VASaFgExSL1icMMr3jx7uHW17zOA9aF93tXlEiYM
         3xVzMSwuUBA740nMagZbtnEzWpgrndokRNxZhM7xem+isN5XlXdArRVD+/ZfohjCM6oO
         1SfzxIHCZLEGyRThTv/k7IDWcex87AMV4MlJXJKDmW4xNEvVYhAWf5dWHyxg3WhYrQ+q
         koQX0DonpfHZhKDKO+t5FN2lAOQlTT/InUHalEdUYY/rWZMIl6ECAKCzDydX5+kiS1ZT
         tSK2PGMw2kCMOh7pYgjCrntKvR07XEEdRBM9HOi0FMo79AAL/3D0r3GsNRvbrVF90Hxt
         BP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xMUtvpan88Ge3846vksyEMrhRvz63V7NUsP6JGFKyHw=;
        b=YBHAc+eKSvb7pXajGWJTUWh4H4mocRHGOry4/5Ljg5cGvN4sRTe7avuVBHKf7c776e
         o+o5UBVsqAMwFTtHg2J1k58apSYsjGw7dzOTZo6ovwLgTMPXgnoJ1a9iIKVmw5QgnjA5
         VYIQ+gRBTyzbg1yBKRYq3tT1G3QK5i+2M8xyGLRdr4go8YDxn9P2kxG7x9Xa1jxsX91C
         k18g60+AP07ZKXK8SzKZ/5tf45eNn+9IMvlgWQCt3K8jbNQVpFzJvq2oq1J1umaYkkkN
         ObWd2rRDeEcfo1Pj2gM/bnzE8GwcutMsyZTCNLhd8BjexEVpJ5v8loNiDYtXIqc7xMGf
         O2QA==
X-Gm-Message-State: AOAM531l6oqNH1pLpuu0xh0KoZD8j4qHg4IA55Gip5s42iXDKLIVfY7q
        nCi9VsoWsIyLfIXFLI04lkZ0dsWgGLZkgb8A53w9/A==
X-Google-Smtp-Source: ABdhPJyhJcZAY2lBqY/vhwPr5TFX4ZJHGXZMLuq/qCGaNkrqhrAu5O4KqkSAGO8dt5PvEQQmNHUP1eqg0ExaH4kzrlU=
X-Received: by 2002:a92:1b97:: with SMTP id f23mr2057484ill.216.1603376377267;
 Thu, 22 Oct 2020 07:19:37 -0700 (PDT)
MIME-Version: 1.0
References: <20201022064146.79873-1-keli@akamai.com> <CANn89iJxBMph1EZX9mYOjHsex-6thhTqSLpXA-1RDGv-QBhxaw@mail.gmail.com>
 <C781E7ED-D9E2-4FB4-87DA-88E6AFD35F0E@akamai.com>
In-Reply-To: <C781E7ED-D9E2-4FB4-87DA-88E6AFD35F0E@akamai.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 22 Oct 2020 16:19:25 +0200
Message-ID: <CANn89iKL_+LkPqYzOMe0sTB0Y_vOaeq5Twd6q5v9exWMDXxZ2g@mail.gmail.com>
Subject: Re: [PATCH net v2] net: Properly typecast int values to set sk_max_pacing_rate
To:     "Li, Ke" <keli@akamai.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "kli@udel.edu" <kli@udel.edu>, "Li, Ji" <jli@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 10:43 AM Li, Ke <keli@akamai.com> wrote:
>
> Thank you, Eric!
>
> Nice to know the recent change to wrap-at-100. Will this be reflected som=
ewhere, like, in Documentation/process/coding-style.rst?
>

commit bdc48fa11e46f867ea4d75fa59ee87a7f48be144
Author: Joe Perches <joe@perches.com>
Date:   Fri May 29 16:12:21 2020 -0700

    checkpatch/coding-style: deprecate 80-column warning

    Yes, staying withing 80 columns is certainly still _preferred_.  But
    it's not the hard limit that the checkpatch warnings imply, and other
    concerns can most certainly dominate.

    Increase the default limit to 100 characters.  Not because 100
    characters is some hard limit either, but that's certainly a "what are
    you doing" kind of value and less likely to be about the occasional
    slightly longer lines.

    Miscellanea:

     - to avoid unnecessary whitespace changes in files, checkpatch will no
       longer emit a warning about line length when scanning files unless
       --strict is also used

     - Add a bit to coding-style about alignment to open parenthesis

    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>



> Best,
> -Ke
>
> =EF=BB=BFOn 10/22/20, 12:49 AM, "Eric Dumazet" <edumazet@google.com> wrot=
e:
>
>     On Thu, Oct 22, 2020 at 8:42 AM Ke Li <keli@akamai.com> wrote:
>     >
>     > In setsockopt(SO_MAX_PACING_RATE) on 64bit systems, sk_max_pacing_r=
ate,
>     > after extended from 'u32' to 'unsigned long', takes unintentionally
>     > hiked value whenever assigned from an 'int' value with MSB=3D1, due=
 to
>     > binary sign extension in promoting s32 to u64, e.g. 0x80000000 beco=
mes
>     > 0xFFFFFFFF80000000.
>     >
>     > Thus inflated sk_max_pacing_rate causes subsequent getsockopt to re=
turn
>     > ~0U unexpectedly. It may also result in increased pacing rate.
>     >
>     > Fix by explicitly casting the 'int' value to 'unsigned int' before
>     > assigning it to sk_max_pacing_rate, for zero extension to happen.
>     >
>     > Fixes: 76a9ebe811fb ("net: extend sk_pacing_rate to unsigned long")
>     > Signed-off-by: Ji Li <jli@akamai.com>
>     > Signed-off-by: Ke Li <keli@akamai.com>
>     > Cc: Eric Dumazet <edumazet@google.com>
>     > ---
>     > v2: wrap the line in net/core/filter.c to less than 80 chars.
>
>     SGTM (the other version was also fine, the 80 chars rule has been
>     relaxed/changed to 100 recently)
>
>     Reviewed-by: Eric Dumazet <edumazet@google.com>
>
