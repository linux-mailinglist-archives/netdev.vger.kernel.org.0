Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2433B9404
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhGAPgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbhGAPgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 11:36:49 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EF7C061762;
        Thu,  1 Jul 2021 08:34:19 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id kt19so4492850pjb.2;
        Thu, 01 Jul 2021 08:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hM48D/tfWkKwtaJqEBYo4LKCs7wLgMCLr8CTnLjZ3ds=;
        b=FwT/3Ybvlf54T1QM2fsHElcQWpBh+xuJ9nqlmdIH85OgBeGTlx39mvZA10IqqZEDjv
         CyoxIgOHqEnHPihzUAl90UdU4knf6i9EMquID6CBiZdw/bshnHtU/7C26wShQmGpNGOD
         bRsNAXAl9qHNGGMCMd38ABQmiAipbxBygOYtrqH5lW4k2kPYIEgGbmj6oH34B6FEKNOR
         BrwTY9f3nFpZEvAsG9KHa5zXVB+cDHZJ+hW6fPjcMdvN0rzyXcQCVLUfVHG3dpJ0sRf9
         rPmTZLLfl3mm3xtknOOQRR1/JDd+STPxBQCm/dufVLewlpNB4d/b7oM720et0HNFb57i
         tILw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hM48D/tfWkKwtaJqEBYo4LKCs7wLgMCLr8CTnLjZ3ds=;
        b=e3dXhmHEWMXtYi4fSaCRyKvdQVIyFYRMe5ZJ3SmGU6Gg+T9Z8eh8msixe8UN9j+4f5
         0ar+LjGxNSzuM1v3zRRm3PA3Olfm1VgQ9YH8O0O9aECOog3UUYr0L3HFUl62yBUVJ/4n
         jemckd72/8dxfvdEBn3dnotEmDRbYaw/JJwdPrpWIFD3X5/msMORKziH8HqF6Wzsf+Sq
         BdiGJoBXtOKdEEuG/W1E1b5r49Cp6BHpCqWGAm+MjQNksEssXC3cUGfOg3ZL18XUoJ5o
         APSP0vD9HqV/hQpSg5ehY/VdSPk0byO5OfAhSLy5v3Y2xULEOwDXZGn9BLLbqYvRx67P
         rdqw==
X-Gm-Message-State: AOAM533mbW0zneI9SIKKqc1EoUeacvV4Dl6Q0Y0ixHRxi9OY4n0L6FXV
        t6rMrm1DPtiQaQU7BPpwuHg=
X-Google-Smtp-Source: ABdhPJzEOH8b31RRmBXOt7nPL2VmzJZ+x8vhtAbyK99mV4VcWK0EUkGYr3+S3pEN2fxzWeZi1dXZFQ==
X-Received: by 2002:a17:902:e890:b029:129:3bb0:37cf with SMTP id w16-20020a170902e890b02901293bb037cfmr159850plg.68.1625153658826;
        Thu, 01 Jul 2021 08:34:18 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f1f2])
        by smtp.gmail.com with ESMTPSA id m18sm391725pff.88.2021.07.01.08.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 08:34:18 -0700 (PDT)
Date:   Thu, 1 Jul 2021 08:34:14 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
Message-ID: <20210701153414.5kxste77mejnv4yp@ast-mbp.dhcp.thefacebook.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-2-alexei.starovoitov@gmail.com>
 <CAADnVQJrZdC3f8SxxBqQK9Ov4Kcgao0enBNAhmwJuZPgxwjQUg@mail.gmail.com>
 <878s2q1cd3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <878s2q1cd3.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 01:51:04PM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Wed, Jun 23, 2021 at 7:25 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >>
> >> The bpf_timer_init() helper is receiving hidden 'map' argument and
> > ...
> >> +               if (insn->imm == BPF_FUNC_timer_init) {
> >> +                       aux = &env->insn_aux_data[i + delta];
> >> +                       if (bpf_map_ptr_poisoned(aux)) {
> >> +                               verbose(env, "bpf_timer_init abusing map_ptr\n");
> >> +                               return -EINVAL;
> >> +                       }
> >> +                       map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
> >> +                       {
> >> +                               struct bpf_insn ld_addrs[2] = {
> >> +                                       BPF_LD_IMM64(BPF_REG_3, (long)map_ptr),
> >> +                               };
> >
> > After a couple of hours of ohh so painful debugging I realized that this
> > approach doesn't work for inner maps. Duh.
> > For inner maps it remembers inner_map_meta which is a template
> > of inner map.
> > Then bpf_timer_cb() passes map ptr into timer callback and if it tries
> > to do map operations on it the inner_map_meta->ops will be valid,
> > but the struct bpf_map doesn't have the actual data.
> > So to support map-in-map we need to require users to pass map pointer
> > explicitly into bpf_timer_init().
> > Unfortunately the verifier cannot guarantee that bpf timer field inside
> > map element is from the same map that is passed as a map ptr.
> > The verifier can check that they're equivalent from safety pov
> > via bpf_map_meta_equal(), so common user mistakes will be caught by it.
> > Still not pretty that it's partially on the user to do:
> > bpf_timer_init(timer, CLOCK, map);
> > with 'timer' matching the 'map'.
> 
> The implication being that if they don't match, the callback will just
> get a different argument and it'll be up to the developer to deal with
> any bugs arising from that?

Right. The kernel won't crash, of course.

> > Another option is to drop 'map' arg from timer callback,
> > but the usability of the callback will suffer. The inner maps
> > will be quite painful to use from it.
> > Anyway I'm going with explicit 'map' arg in the next respin.
> > Other ideas?
> 
> So the problem here is that the inner map pointer is not known at
> verification time but only at runtime? Could the verifier inject code to

yep.

> always spill inner map pointers to a known area of the stack after a
> map-in-map lookup, and then just load them back from there when needed?

interesting idea. That made me thinking that the verifier has
"map_lookup tracking" ability with increasing reg->id.
Since in some cases we had to distinguish that
val1 = map_lookup(map1, key1);
val2 = map_lookup(map1, key1);
val1 != val2, though they could be from the same map and key.
Maybe building on top of that feature will address the map vs timer
equivalence issue.

> Not sure that would be worth the complexity (and overhead!), though;
> having to supply an explicit callback arg is not that uncommon a pattern
> after all...
> 
> -Toke
> 

-- 
