Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E151DEF78
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbgEVSsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730849AbgEVSsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 14:48:22 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D619CC061A0E;
        Fri, 22 May 2020 11:48:20 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id c24so9095224qtw.7;
        Fri, 22 May 2020 11:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m1mNHc6/hAjoWFrBNVm6ycm0CW8JEi3JHpb/McV2Ky0=;
        b=PQ9D+GRhJMZpGhXuKeEHOvUHaxsAjiEMYF25wAdRbXUFAJEr5DrKiOxyJKNQXJBXti
         X9y9o4Xfy9SCO1Bx9icsmDPdhJJkWU7nYQpf4JScxSkpMCEwHdZK+7qwtK6czkGB0cXE
         +KU5dVG63t+sLYuathfgv2lKV9zaA19kRFEdkaNTNr2kFIFT/Ovjxyrf9piyhFRXpqY1
         wGIa48FrbDSZ55iKKhgk6mV2fWhcwhgpnIl5IQOncODjSNCfqeNHqAQlkrqtAJnGeAKi
         M4BypWF77pkcvJhB+0f7kE2wq6I4lHZh3lmCT+73MZF2370NxyLNhxJYE3ggmGiycE3Z
         6NwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m1mNHc6/hAjoWFrBNVm6ycm0CW8JEi3JHpb/McV2Ky0=;
        b=MeaGmJkBPzmq0KWzLEDPZqVH8ELetxzjdfkpRRDbogrVr5VuF6Bjx83ou7gRbnIN0X
         +hJC26nALbo2T8yLG0rAv51hwTEyFS7uGKyog/tm+mD7LbokLpWp356giBrYMdIOA/wH
         U+zwjtV+e1HY9naumjy5cPJnbv9PWfhWGOXsu3ddocCXSoXNej8TGg1vn/mYgyIwo+n2
         +pnjr56gPxUG9CIrT4nef+tx3Qq/Rb+zOQlH+J+yB0zROad4w4Dnu9qUjtFYuSSSZog+
         r4roN4CS4/TzOHwtSTxYUax7Yrb8cQ4xYzCWyv310dgwlCOGgIE6y+7Wx/Vni/ZurLkw
         qDwQ==
X-Gm-Message-State: AOAM530I5NuMY1HTLCzzDBb3k41ob/VMYhffOJgx/yqQL5ueda5dsAxl
        Ae4DZsy836B2qASe8S60LvtLP4LOpwGZDXwEmHo=
X-Google-Smtp-Source: ABdhPJyliiTzhVW1YkVMdO0/ciBIKHrpq3kK/xHilE5Wb003Wf/7zuF94t6z1fOaTGp1lk0e3T0lE6vlMydmGzsFBZQ=
X-Received: by 2002:ac8:424b:: with SMTP id r11mr17237033qtm.171.1590173300022;
 Fri, 22 May 2020 11:48:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200517195727.279322-1-andriin@fb.com> <20200517195727.279322-2-andriin@fb.com>
 <20200522010722.2lgagrt6cmw6dzmm@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200522010722.2lgagrt6cmw6dzmm@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 May 2020 11:48:09 -0700
Message-ID: <CAEf4BzZLYtgZg8caSpMkFf4-NJXQHbiTXhwnY7wnq7qDbgA9Gw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/7] bpf: implement BPF ring buffer and
 verifier support for it
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 6:07 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, May 17, 2020 at 12:57:21PM -0700, Andrii Nakryiko wrote:
> > -     if (off < 0 || size < 0 || (size == 0 && !zero_size_allowed) ||
> > -         off + size > map->value_size) {
> > -             verbose(env, "invalid access to map value, value_size=%d off=%d size=%d\n",
> > -                     map->value_size, off, size);
> > -             return -EACCES;
> > -     }
> > -     return 0;
> > +     if (off >= 0 && size_ok && off + size <= mem_size)
> > +             return 0;
> > +
> > +     verbose(env, "invalid access to memory, mem_size=%u off=%d size=%d\n",
> > +             mem_size, off, size);
> > +     return -EACCES;
>
> iirc invalid access to map value is one of most common verifier errors that
> people see when they're use unbounded access. Generalizing it to memory is
> technically correct, but it makes the message harder to decipher.
> What is 'mem_size' ? Without context it is difficult to guess that
> it's actually size of map value element.
> Could you make this error message more human friendly depending on
> type of pointer?

yep, sure, better verifier errors are extremely important, I think

>
> >       if (err) {
> > -             verbose(env, "R%d min value is outside of the array range\n",
> > +             verbose(env, "R%d min value is outside of the memory region\n",
> >                       regno);
> >               return err;
> >       }
> > @@ -2518,18 +2527,38 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
> >        * If reg->umax_value + off could overflow, treat that as unbounded too.
> >        */
> >       if (reg->umax_value >= BPF_MAX_VAR_OFF) {
> > -             verbose(env, "R%d unbounded memory access, make sure to bounds check any array access into a map\n",
> > +             verbose(env, "R%d unbounded memory access, make sure to bounds check any memory region access\n",
> >                       regno);
> >               return -EACCES;
> >       }
> > -     err = __check_map_access(env, regno, reg->umax_value + off, size,
> > +     err = __check_mem_access(env, reg->umax_value + off, size, mem_size,
> >                                zero_size_allowed);
> > -     if (err)
> > -             verbose(env, "R%d max value is outside of the array range\n",
> > +     if (err) {
> > +             verbose(env, "R%d max value is outside of the memory region\n",
> >                       regno);
>
> I'm not that worried about above three generalizations of errors,
> but if you can make it friendly by describing type of memory region
> I think it will be a plus.

I agree, will update
