Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421F1258A5F
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 10:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgIAId6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 04:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgIAIdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 04:33:52 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA72C061244;
        Tue,  1 Sep 2020 01:33:52 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u126so335020iod.12;
        Tue, 01 Sep 2020 01:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G+VmgoO8vIbvtjcVYz620lwA/qI81jwMNO0XxxHQoX0=;
        b=ZTSIDzuANrxX4hUFOaMXVu7wF4/c558yhxyDvVPjauI/aUI0aZ7PNHCbAtaiPdXbRS
         EVRU8kkXPTFlac7Y8blhAe9S/x8T+bxGMNP/CGrXLC31/XltqecIWpZxVJd7LULbT6HB
         u0zNpKC591mnmMRMa7OanZFVidpYmnc8Lo/QhwmVeKANEKLJ8lbDkSC5LBUK0/nsdmRZ
         lWQlv3wu0Y4Ji19zZlctiAP0YdMD+AvKrYsTY/iInQQ9bHcy9T8l4Na0rR1+KIr5n6de
         mAJGjhsPTS6FN9n2Jpvz4YbOUlMTybwKUD6H+qGGRyTuA3CE+0mse/UYzfEd0xNYXnCF
         MHYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G+VmgoO8vIbvtjcVYz620lwA/qI81jwMNO0XxxHQoX0=;
        b=dAPHgQWjhl+XgozpnzjjdhyKqBO1JoozRXbPuhyOHz/XywUwXfLlAzbdxGvqy29pJe
         /MUQmQTdzz1Fe5rig9n/r60h6KJrbJGFP3UtVFD2zHFp/HCUF8/0GJlb1mI24+Bs3YzR
         lpgWWQ7CGedmuKrm7YGZOe9GhpDULpprbnO+56KgMsPKKEVzQ631KPZ1ka1LqU95aBok
         J1maA/6as/EbMs3CPhonS/cIq48ktXZtMe+YaKaoPBPsYKYgNgCHluWOsZCKl+o1db+9
         tuecDdJjOUJLUcm9NjI+ZDUUCs7S+0ESWWU1hKstMYDaetqpFMUF7h+M9+1wct+J07Nt
         U9tA==
X-Gm-Message-State: AOAM533QWBQnKNpFClEhjvPwfwaH3znKUz85/iizsVl8HxOdvJPyqcKg
        PYpk9UOdgnBbLPVqzaQMABGM+WUYIVW+aw/xDUU=
X-Google-Smtp-Source: ABdhPJxK3IGtjiFvMrAqzvJvwH7YzJI5OPNUrPLhcB7AnTZEsDb4a3fORFOe60of6Ls24kECKpAzUmt0naDBA+0pl04=
X-Received: by 2002:a05:6638:2653:: with SMTP id n19mr384136jat.34.1598949231460;
 Tue, 01 Sep 2020 01:33:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200901064302.849-1-w@1wt.eu> <20200901064302.849-2-w@1wt.eu>
In-Reply-To: <20200901064302.849-2-w@1wt.eu>
From:   Yann Ylavic <ylavic.dev@gmail.com>
Date:   Tue, 1 Sep 2020 10:33:40 +0200
Message-ID: <CAKQ1sVM9SMYVTSZYaGuPDhQHfyEOFSxBL8PNixyaN4pR2PWMxQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] random32: make prandom_u32() output unpredictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     linux-kernel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        George Spelvin <lkml@sdf.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, tytso@mit.edu,
        Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 8:45 AM Willy Tarreau <w@1wt.eu> wrote:
>
> +/*
> + *     Generate some initially weak seeding values to allow
> + *     the prandom_u32() engine to be started.
> + */
> +static int __init prandom_init_early(void)
> +{
> +       int i;
> +       unsigned long v0, v1, v2, v3;
> +
> +       if (!arch_get_random_long(&v0))
> +               v0 = jiffies;
> +       if (!arch_get_random_long(&v1))
> +               v0 = random_get_entropy();

Shouldn't the above be:
                  v1 = random_get_entropy();
?

> +       v2 = v0 ^ PRND_K0;
> +       v3 = v1 ^ PRND_K1;
> +
> +       for_each_possible_cpu(i) {
> +               struct siprand_state *state;
> +
> +               v3 ^= i;
> +               PRND_SIPROUND(v0, v1, v2, v3);
> +               PRND_SIPROUND(v0, v1, v2, v3);
> +               v0 ^= i;
> +
> +               state = per_cpu_ptr(&net_rand_state, i);
> +               state->v0 = v0;  state->v1 = v1;
> +               state->v2 = v2;  state->v3 = v3;
> +       }
> +
> +       return 0;
> +}
> +core_initcall(prandom_init_early);


Regards;
Yann.
