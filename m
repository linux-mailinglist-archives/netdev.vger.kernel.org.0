Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652FC1E893C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgE2UwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgE2UwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 16:52:21 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15146C03E969;
        Fri, 29 May 2020 13:52:21 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y18so412411pfl.9;
        Fri, 29 May 2020 13:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R8k6wlWp3ZVnuPtqfYzoqe4mzNpOl/eHvjFStkX5sCw=;
        b=bsWLuirEnvwAwyHTJwHe+2dPMylNWYcnW7SalvtsV6yJmwucAjjwB93zg+6KGMjjbC
         ilrn3OnkVeplNvJ+2iDufq15o5FAwPtilmBhfTLE+Ax7XW/VFAr4kmhCrRPBW9R3TKUm
         c+tka530+YDj7shDrdT7Txi58c/3wCQr47pVEcdpxu3R4A9fPh8khsQiR5bJ8y/mAYgU
         G5KKOUKXNEzviQaMfgvThTwpYwknDI8KF9HcS0BtIII9Gi94Tv9LvFfD2u0Uee6BEaOW
         dwa5j/ejPZzK7RX3zCyPv+QAONEF+bz7NvI4Jjomy/av+Jvmz1A0hFq/m0Udi+6YWXR7
         3wMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R8k6wlWp3ZVnuPtqfYzoqe4mzNpOl/eHvjFStkX5sCw=;
        b=Y5uoWshc1PGQYaeDj3FFqOO9VK0j3zs/14uz5gUw/LU5xXopZ6xW4kSGKaG+f25fZT
         y/RHnp3+cXErbk13L8XCCLglcZj1OlyKh7RBWzSRuoSc8jk62Rx3JVNPdGEFIvpz+TZf
         LqWk4XPm7OiCykJ2/S5AdOPP9/rjvqBtuYHFosBoUWa0tRwfONqWXt5Ulr8oOoTBZbyl
         6Qt0TWHC0a1+tCUFxA80wNCPc876FjjLlBGMzJcLzpW4CtxWzQWpkpfHI5dMwbPs8QLJ
         x2CrrVmxkNzmWU0iIOSrLO2VI4GcLDw/XOSSmDbYBvqay5rMmAGqgGsS2qxNYsrnqdOo
         PwLA==
X-Gm-Message-State: AOAM5329+bo09uZnFnVtv9RbUvqktB+YjqI+UtpaImx4AUeW4u8IvAWv
        aYhUgw9IoJjFYkmLEEk5WLo=
X-Google-Smtp-Source: ABdhPJyNZmkxE0EdoNh7Gsb/4VdeilYHDGcTb+jAvEfBURIYBtdjw9bGBeSz9ric3jbJXrIgjhv72Q==
X-Received: by 2002:aa7:9543:: with SMTP id w3mr10342041pfq.191.1590785540587;
        Fri, 29 May 2020 13:52:20 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:6ddc])
        by smtp.gmail.com with ESMTPSA id d8sm8061898pfq.123.2020.05.29.13.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 13:52:19 -0700 (PDT)
Date:   Fri, 29 May 2020 13:52:17 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: Introduce sleepable BPF programs
Message-ID: <20200529205217.kfwc646svq5cb4bv@ast-mbp.dhcp.thefacebook.com>
References: <20200529043839.15824-1-alexei.starovoitov@gmail.com>
 <20200529043839.15824-3-alexei.starovoitov@gmail.com>
 <CAEf4BzZXnqLwhJaUVKX0ExVa+Sw5mnhg5FLJN-VKPX59f6EAoQ@mail.gmail.com>
 <20200529201228.oixjsibn6uwktkgh@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaVHD7HyRDQGRCUKBDOZq-LcZpHrBoOjuOP+443Xc+Vaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaVHD7HyRDQGRCUKBDOZq-LcZpHrBoOjuOP+443Xc+Vaw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 01:38:40PM -0700, Andrii Nakryiko wrote:
> > > >         if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
> > > >                 return check_struct_ops_btf_id(env);
> > > >
> > > > @@ -10762,8 +10801,29 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
> > > >                         if (ret)
> > > >                                 verbose(env, "%s() is not modifiable\n",
> > > >                                         prog->aux->attach_func_name);
> > > > +               } else if (prog->aux->sleepable) {
> > > > +                       switch (prog->type) {
> > > > +                       case BPF_PROG_TYPE_TRACING:
> > > > +                               /* fentry/fexit progs can be sleepable only if they are
> > > > +                                * attached to ALLOW_ERROR_INJECTION or security_*() funcs.
> > > > +                                */
> > > > +                               ret = check_attach_modify_return(prog, addr);
> > >
> > > I was so confused about this piece... check_attach_modify_return()
> > > should probably be renamed to something else, it's not for fmod_ret
> > > only anymore.
> >
> > why? I think the name is correct. The helper checks whether target
> > allows modifying its return value. It's a first while list.
> 
> check_attach_modify_return() name implies to me that it's strictly for
> fmod_ret-specific attachment checks, that's all. It's minor, if you
> feel like name is appropriate I'm fine with it.

ahh. i see the confusion. I've read check_attach_modify_return as
whether target kernel function allows tweaking it's return value.
whereas it sounds that you've read it as it's check whether target
func is ok for modify_return bpf program type.

> 
> > When that passes the black list applies via check_sleepable_blacklist() function.
> >
> > I was considering using whitelist for sleepable as well, but that's overkill.
> > Too much overlap with mod_ret.
> > Imo check whitelist + check blacklist for white list exceptions is clean enough.
> 
> I agree about whitelist+blacklist, my only point was that
> check_attach_modify_return() is not communicating that it's a
> whitelist. check_sleepable_blacklist() is clear as day,
> check_sleepable_whitelist() would be as clear, even if internally it
> (for now) just calls into check_attach_modify_return(). Eventually it
> might be evolved beyond what's in check_attach_modify_return(). Not a
> big deal and can be changed later, if necessary.

got it. I will wrap it into another helper.
