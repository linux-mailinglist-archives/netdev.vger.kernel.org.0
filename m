Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75D034D47C
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhC2QGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhC2QGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 12:06:44 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A757C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 09:06:39 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id v15so19254912lfq.5
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 09:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o1jWAdRSwYi7T17YmKUQ+ZmNxlISmA9ZSzxUAVBNgG0=;
        b=CcO2yVkDv4E60vi+zJoVkDsLszyxYZ5B6RGGwg/XuiRq5KFy5YxGKItfgi037gCRcU
         HV7pGaOanQXOhzHbRSxBmSRmKcMsae8z8jRAV4T7m0gb54107/1pwnHZdhjzRiRLXqJt
         4CRuZhepSSpkwVN/fyrKFh9edQh3kUHFuS2fk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o1jWAdRSwYi7T17YmKUQ+ZmNxlISmA9ZSzxUAVBNgG0=;
        b=L7n3lgTDQ/H5hSt+/2AHVj/6w7BtXvYGHxg8sqKh9dAIzbj7UNznbUNwNz9D2URvly
         iIN+wRdoAcn8rn9RC3Pg9TsMhVDL69dO7emITWiC6Y6E7HitsOm4tAcno+/OdftDFoOK
         Ner5xwh8W0VBadC6IA9s3j584vXnyEpidue8096Fvp2f8uhPEBUwOS7JF3sfd/Q87RR5
         8rTicalWDYsvkiF9hUvKqhKIPWswC7LAu54azE9FiRJZ80BPgCzP6wuEmEpVQz1uOi7W
         Hl2Ozgxz9rI8E17MIwlfrE+xUqmn2khENCRja6DZUDL5EmZo4rx8+qQF5E9Eukqvnf73
         KTow==
X-Gm-Message-State: AOAM530a6kzPkWbPycFvvuSqik8vyK4RGvjFVSFrbdFD5cGotGQE4Hk9
        tvMLUYMo9ELyEQXJdSzc2zOG6ZtoH6TpvKtdC+q8ow==
X-Google-Smtp-Source: ABdhPJw9ppCW/DUnzfABsOFfvTHpEZ+hh9wpKoY1A7i6YG5uZjGrL9U6isYcmqSkaOOg78/1dhDImWtEI0TD4tghWd8=
X-Received: by 2002:a19:4347:: with SMTP id m7mr6049998lfj.13.1617033997527;
 Mon, 29 Mar 2021 09:06:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210325015124.1543397-1-kafai@fb.com> <CAM_iQpWGn000YOmF2x6Cm0FqCOSq0yUjc_+Up+Ek3r6NrBW3mw@mail.gmail.com>
 <CAADnVQKAXsEzsEkxhUG=79V+gAJbv=-Wuh_oJngjs54g1xGW7Q@mail.gmail.com>
 <CAM_iQpU7y+YE9wbqFZK30o4A+Gmm9jMLgqPqOw6SCDP8mHibTQ@mail.gmail.com>
 <CAADnVQJoeEqZK8eWfCi-BkHY4rSzaPuXYVEFvR75Ecdbt+oGgA@mail.gmail.com>
 <CAM_iQpUTFs_60vkS6LTRr5VBt8yTHiSgaHoKrtt4GGDe4tCcew@mail.gmail.com> <20210329012437.somtubekt2dqzz3x@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210329012437.somtubekt2dqzz3x@kafai-mbp.dhcp.thefacebook.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 29 Mar 2021 17:06:26 +0100
Message-ID: <CACAyw99gXvpnCwkz4vniABV5OQ29BE2K2iJY0tB898Fd9_8h6Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Mar 2021 at 02:25, Martin KaFai Lau <kafai@fb.com> wrote:
>
> > > >
> > > > # pahole --version
> > > > v1.17
> > >
> > > That is the most likely reason.
> > > In lib/Kconfig.debug
> > > we have pahole >= 1.19 requirement for BTF in modules.
> > > Though your config has CUBIC=y I suspect something odd goes on.
> > > Could you please try the latest pahole 1.20 ?
> >
> > Sure, I will give it a try tomorrow, I am not in control of the CI I ran.
> Could you also check the CONFIG_DYNAMIC_FTRACE and also try 'y' if it
> is not set?

I hit the same problem on newer pahole:

$ pahole --version
v1.20

CONFIG_DYNAMIC_FTRACE=y resolves the issue.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
