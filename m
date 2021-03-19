Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06421342105
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhCSPeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhCSPdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:33:51 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCAAC06174A;
        Fri, 19 Mar 2021 08:33:50 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id z8so12446634ljm.12;
        Fri, 19 Mar 2021 08:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r2m7MTSjA4rnSzTDMPsjd8IDozpayK6VTsVZGZVnC1Q=;
        b=uBjF5lQLBZiiumq0YZ5me9gHwz34Ik/vbGc+KXTVVVgjOYROvvRpBv87eilAzMX/db
         2HuTU6C4hBb0xMBfYZM6whHLwNQVXu+yUwQ9IKWjL+U1z9DkaOVHTZ8S0+pP/vT1c4Zw
         h1JLdx8A4V1SG80obBn0EhYQXSbh8Ti2AbleFkTeWTNfubzZWRBQalc2eGMVuKL+5Syn
         evSQuiW7qoi+8eWQzSBTR416zmrHLIRlWtX62SnPluoKHimHduIymANlQxvbg21vASWH
         2W2ECN4p1niH/XAr11DkzWeQTnyQj9O4kZ2urusfMWLsJQhP1uLvFOzQBNT9EwRoqLve
         DpcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r2m7MTSjA4rnSzTDMPsjd8IDozpayK6VTsVZGZVnC1Q=;
        b=uCqtyDWyW2sTTjuE1hvJNEtSAkBQ0HiGfyT4v68+7WZQRDE2PQV4QdfKEwUfO5RPeF
         m4iYKCLG8Lda106BjvAz2pk5R0vKEeuMFa53tC08jXJwARkGKSwSvnGGKz60JhrBYpJv
         ePfZYof2dHr7TwR7lHCojZXAx+ynCWlgEoqU0E52rnuxKsgQOp9QBIZJklB3HptoNTYD
         5Esnt7v7imJupSabqa/ENaCGKXg8cyqTCuXw53awvy1ApjgbzWSNUzjqJL/PPJ2ZsIU/
         pr7FLiy7RH760qa6GkywEq2KixwZhLWgvky2pmoXspi/Bk0fuF1eK3RRrAxSY/BtgbM0
         oytQ==
X-Gm-Message-State: AOAM532MzbW1C+gqhiBe2gR24BHh9s32az3EypzNa4AloE3jopjnGSOl
        TDioOmimZdfTbZFAgs/hE4VrVelT5GeTWSCzAuC+8EJ8
X-Google-Smtp-Source: ABdhPJzpF4TWQznngDJXH3QO0WjoeBLQP65YZc6vf4KMW/QuCClTsO+FT2ub1TWw/Uj0nD3WKm7G1ArhIBnPW0LuyI4=
X-Received: by 2002:a2e:981a:: with SMTP id a26mr1278220ljj.204.1616168029442;
 Fri, 19 Mar 2021 08:33:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210319111652.474c0939@canb.auug.org.au> <CAFzhf4pCdJStzBcveahKYQFHJCKenuT+VZAP+8PWSEQcooKLgQ@mail.gmail.com>
 <4f90ff09-966c-4d86-a3bc-9b52107b6d8a@iogearbox.net> <70b99c99-ed58-3b05-92c9-3eaa1e18d722@fb.com>
In-Reply-To: <70b99c99-ed58-3b05-92c9-3eaa1e18d722@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 19 Mar 2021 08:33:37 -0700
Message-ID: <CAADnVQJTXiqZYY1bbKCKwm8_sUvLfUoNaMo8b_Buf=CMhOa+CA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
To:     Yonghong Song <yhs@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Piotr Krysiuk <piotras@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 8:17 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 3/19/21 12:21 AM, Daniel Borkmann wrote:
> > On 3/19/21 3:11 AM, Piotr Krysiuk wrote:
> >> Hi Daniel,
> >>
> >> On Fri, Mar 19, 2021 at 12:16 AM Stephen Rothwell <sfr@canb.auug.org.au>
> >> wrote:
> >>
> >>> diff --cc kernel/bpf/verifier.c
> >>> index 44e4ec1640f1,f9096b049cd6..000000000000
> >>> --- a/kernel/bpf/verifier.c
> >>> +++ b/kernel/bpf/verifier.c
> >>> @@@ -5876,10 -6056,22 +6060,23 @@@ static int
> >>> retrieve_ptr_limit(const str
> >>>                  if (mask_to_left)
> >>>                          *ptr_limit = MAX_BPF_STACK + off;
> >>>                  else
> >>>   -                      *ptr_limit = -off;
> >>>   -              return 0;
> >>>   +                      *ptr_limit = -off - 1;
> >>>   +              return *ptr_limit >= max ? -ERANGE : 0;
> >>> +       case PTR_TO_MAP_KEY:
> >>> +               /* Currently, this code is not exercised as the only use
> >>> +                * is bpf_for_each_map_elem() helper which requires
> >>> +                * bpf_capble. The code has been tested manually for
> >>> +                * future use.
> >>> +                */
> >>> +               if (mask_to_left) {
> >>> +                       *ptr_limit = ptr_reg->umax_value + ptr_reg->off;
> >>> +               } else {
> >>> +                       off = ptr_reg->smin_value + ptr_reg->off;
> >>> +                       *ptr_limit = ptr_reg->map_ptr->key_size - off;
> >>> +               }
> >>> +               return 0;
> >>>
> >>
> >> PTR_TO_MAP_VALUE logic above looks like copy-paste of old
> >> PTR_TO_MAP_VALUE
> >> code from before "bpf: Fix off-by-one for area size in creating mask to
> >> left" and is apparently affected by the same off-by-one, except this time
> >> on "key_size" area and not "value_size".
> >>
> >> This needs to be fixed in the same way as we did with PTR_TO_MAP_VALUE.
> >> What is the best way to proceed?
> >
> > Hm, not sure why PTR_TO_MAP_KEY was added by 69c087ba6225 in the first
> > place, I
> > presume noone expects this to be used from unprivileged as the comment
> > says.
> > Resolution should be to remove the PTR_TO_MAP_KEY case entirely from
> > that switch
> > until we have an actual user.
>
> Alexei suggested so that we don't forget it in the future if
> bpf_capable() requirement is removed.
>     https://lore.kernel.org/bpf/c837ae55-2487-2f39-47f6-a18781dc6fcc@fb.com/
>
> I am okay with either way, fix it or remove it.

I prefer to fix it.
