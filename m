Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE44F4930C1
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349890AbiARWaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234750AbiARWaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 17:30:17 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229BCC061574;
        Tue, 18 Jan 2022 14:30:17 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so4220223pja.1;
        Tue, 18 Jan 2022 14:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a3PB+idKHXhmAlhl7G3BP20QiJsDog8EfC0CRcHrlH8=;
        b=qP7JJsd0P1WDKOsr+DiI/oTP//imopE7DuIJd3Hu7Pquvp6qZun5Ez7EvMMx9RRSJJ
         UDg1IboodVaPg8cNGWm4j4J4pIjW9GkOafNK7QCpmWbMdFuaoXi23DqXZzmP3cnh306G
         lphR6I0DlqOx73sajqNQompJHG7A2kMH8j0jBSiw3o+GpcMiajWftgELnjS8jB0m2rCU
         VURp1jm9CdcywL2+KsrDZUTWmeHvI9i402cepL2sFZZqRTkv0sZM74s0NdaKm6cywwHQ
         YHmNlouNRelsSFmao2w267I5SyPBzecfR1BqzyM1qWxtH9cSekEkNwi+3dGJuEZ0fLic
         Dfeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a3PB+idKHXhmAlhl7G3BP20QiJsDog8EfC0CRcHrlH8=;
        b=c6PFUxf4eTEvJBSZjycU1x5mCItuC3ubE/h2OnGEWYzeHYtyHMKrHXQJr4cLsz5V5E
         jDJKKNZ6I1f2kroHaJQElA7HaPYlzazrKdyHS9dGeEKcFrmtqjB3LsQp+ufWDIdEUQZo
         xcOEicPTJDT4WWgmtpE4vRe25uJhBFUwtwA9Fi2RlKDYYkphIqwmf5uVitfIVfvga+nd
         zQSDe/wUbtzlMsp3t+yOFBJ9axJXcMqijNtDjxJm8eu5NAJUqb9GWGU7iVfyyj7Rqv4J
         qU66saukKRIjWt1EhKte8kf6VuAqs2QE6xQbs87jY+TkOoG1IvDY25/Z8l6WvBIu0F0Q
         S7sQ==
X-Gm-Message-State: AOAM530QgYtttbCg6wcctgpRiXkQI0zwd+8nkGquLx/en23bc4nMezLy
        izhcC8dO+B+XFY4FDsf/8ATnozshZfFhMbQYGe8=
X-Google-Smtp-Source: ABdhPJz5UkSwlvlAcYIzbWYsqKyMIK/oo8pQgr+VH0jnj2kPoTjJHtTriQBvlBKWMQKWPX4Af+8RG42idUxlMYjLEzo=
X-Received: by 2002:a17:90b:224c:: with SMTP id hk12mr825071pjb.62.1642545016551;
 Tue, 18 Jan 2022 14:30:16 -0800 (PST)
MIME-Version: 1.0
References: <cover.1642439548.git.lorenzo@kernel.org> <f7d7d5ba9c132be0dbbebe3a2e4c2377ffa05834.1642439548.git.lorenzo@kernel.org>
 <20220118201647.lwnexycnk2dq25z3@ast-mbp.dhcp.thefacebook.com> <Yec90EIkR931IGwA@lore-desk>
In-Reply-To: <Yec90EIkR931IGwA@lore-desk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Jan 2022 14:30:05 -0800
Message-ID: <CAADnVQJr8wC0hnwkKyqegf+byovzPPTzHNYK7jyckMpw7vHHHw@mail.gmail.com>
Subject: Re: [PATCH v22 bpf-next 17/23] bpf: selftests: update xdp_adjust_tail
 selftest to include multi-frags
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 2:23 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > On Mon, Jan 17, 2022 at 06:28:29PM +0100, Lorenzo Bianconi wrote:
> > > +
> > > +   CHECK(err || retval != XDP_TX || size != exp_size,
> > > +         "9k-10b", "err %d errno %d retval %d[%d] size %d[%u]\n",
> > > +         err, errno, retval, XDP_TX, size, exp_size);
> > ...
> > > +   CHECK(err || retval != XDP_TX || size != exp_size,
> > > +         "9k-1p", "err %d errno %d retval %d[%d] size %d[%u]\n",
> > > +         err, errno, retval, XDP_TX, size, exp_size);
> > ...
> > > +   CHECK(err || retval != XDP_TX || size != exp_size,
> > > +         "9k-2p", "err %d errno %d retval %d[%d] size %d[%u]\n",
> > > +         err, errno, retval, XDP_TX, size, exp_size);
> >
> > CHECK is deprecated.
> > That nit was mentioned many times. Please address it in all patches.
>
> I kept the CHECK macro because there were other CHECK occurrences in
> xdp_adjust_tail.c (e.g. in test_xdp_adjust_tail_grow()).
> I guess we can add a preliminary patch to convert the other CHECK
> occurrences used in xdp_adjust_tail.c (the same for xdp_bpf2bpf.c).
> What do you think?

Please do.
