Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3CE3D43F0
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 02:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhGWXpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 19:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbhGWXpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 19:45:05 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1BEC061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 17:25:37 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id w17so4847112ybl.11
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 17:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j68OU+ycWL3SzqKi7bNfehmzJTv9tSg8LB+4SCqzo8Y=;
        b=AqYco1cOhJN99VOUxqZsS5BSVZFJ8lfFUX2nzsPYdSbmBnvUd4VR8cFVJ8pMY51J2a
         w5DYrnPSWztd9+fj6bdr+gP/syg5cyTlTGkKeVYg/+3gScI3wj8I9AWM2RAJeOGAUyKq
         YvBSmJuKNFTOw4XkJJwBe0nKNvMXVwsSf6DYCjXHaC4MOSafDQ7jszUb603AZ8uFz84c
         Zyj+FPZPfX0MOyZzpXuON2jb2+wcrsvnCcSHV2ySX7W/+SgkNZRl8u1MAGJpMZQW8rKj
         9jnLwNVmINeUqrl598qHCGzX8v1eyvgZr10zD96+gG0ALAVFIpCWKowwdOspq9vno7QB
         K7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j68OU+ycWL3SzqKi7bNfehmzJTv9tSg8LB+4SCqzo8Y=;
        b=JQ3VUoL+lQn47uwNSU6vpvJf29vZcm75y43EbpNTiYE7BqRREtK32g3jSG0GrkTiSG
         ChD45/UVp9cmqIRIeU7kuG1PylrehQnW2lE3Zf/Ptq2/+GSGbi1lWNByyIWIsNmFhixb
         W6nYIbYGq2Fs3iQiXyACx3EapmsZ3BlbtaGVXxdD8TzlMQhamiBXEbBn7xrlQ/9dVqji
         cLODOEqWUuXgMmcrcEesiA2o2oGopfU+sWAgivXXqqjvAfJkbu7JgAjE8nbR1gsFLFw8
         4cQI2wZU5R1hq3axBTHXHsQiMf7hx+zttUe5MRVR3ZqhUQFA6DohlM050OSfr/UHbY70
         vzGw==
X-Gm-Message-State: AOAM532NdLXy9fYyuQfrCxtEppjn/HMg9rgA1GRqHgQNPROLEZFoLsxv
        xPaqC3KAiPSgu9JMtzwSORlugiuO+ZVhN4fomkE=
X-Google-Smtp-Source: ABdhPJxsxZ0vyVvNPqbBmcJI0VlnbSwRtOKBS6+1UQK2jNRrbPw+wbwfODbhZaalCT521M/1OF76O2qkHbO7Km6qaY8=
X-Received: by 2002:a25:1455:: with SMTP id 82mr9571720ybu.403.1627086336815;
 Fri, 23 Jul 2021 17:25:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210705124307.201303-1-m@lambda.lt> <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
 <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt> <YPpIeppWpqFCSaqZ@Laptop-X1>
 <CAEf4Bzavevcn=p7iBSH6iXMOCXp5kCu71a1kZ7PSawW=LW5NSQ@mail.gmail.com> <0cc404df-078a-686e-c5ce-8473c0e220f5@gmail.com>
In-Reply-To: <0cc404df-078a-686e-c5ce-8473c0e220f5@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Jul 2021 17:25:25 -0700
Message-ID: <CAEf4Bza3gMzfSQcv_QDzVP=vsCzxy=8DHwU-EVqOt8XagK7OHw@mail.gmail.com>
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple sections
To:     David Ahern <dsahern@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>, Martynas Pumputis <m@lambda.lt>,
        Networking <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 5:12 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 7/22/21 10:51 PM, Andrii Nakryiko wrote:
> > On Thu, Jul 22, 2021 at 9:41 PM Hangbin Liu <haliu@redhat.com> wrote:
> >>
> >> On Wed, Jul 21, 2021 at 04:47:14PM +0200, Martynas Pumputis wrote:
> >>>>> diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
> >>>>> index d05737a4..f76b90d2 100644
> >>>>> --- a/lib/bpf_libbpf.c
> >>>>> +++ b/lib/bpf_libbpf.c
> >>>>> @@ -267,10 +267,12 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
> >>>>>          }
> >>>>>
> >>>>>          bpf_object__for_each_program(p, obj) {
> >>>>> +               bool prog_to_attach = !prog && cfg->section &&
> >>>>> +                       !strcmp(get_bpf_program__section_name(p), cfg->section);
> >>>>
> >>>> This is still problematic, because one section can have multiple BPF
> >>>> programs. I.e., it's possible two define two or more XDP BPF programs
> >>>> all with SEC("xdp") and libbpf works just fine with that. I suggest
> >>>> moving users to specify the program name (i.e., C function name
> >>>> representing the BPF program). All the xdp_mycustom_suffix namings are
> >>>> a hack and will be rejected by libbpf 1.0, so it would be great to get
> >>>> a head start on fixing this early on.
> >>>
> >>> Thanks for bringing this up. Currently, there is no way to specify a
> >>> function name with "tc exec bpf" (only a section name via the "sec" arg). So
> >>> probably, we should just add another arg to specify the function name.
> >>
> >> How about add a "prog" arg to load specified program name and mark
> >> "sec" as not recommended? To keep backwards compatibility we just load the
> >> first program in the section.
> >
> > Why not error out if there is more than one program with the same
> > section name? if there is just one (and thus section name is still
> > unique) -- then proceed. It seems much less confusing, IMO.
> >
>
> Let' see if I understand this correctly: libbpf 1.0 is not going to
> allow SEC("xdp_foo") or SEC("xdp_bar") kind of section names - which is
> the hint for libbpf to know program type. Instead only SEC("xdp") is
> allowed.

Right.

>
> Further, a single object file is not going to be allowed to have
> multiple SEC("xdp") instances for each program name.

On the contrary. Libbpf already allows (and will keep allowing)
multiple BPF programs with SEC("xdp") in a single object file. Which
is why section_name is not a unique program identifier.

>
> Correct? If so, it seems like this is limiting each object file to a
> single XDP program or a single object file can have 1 XDP program and 1
> tc program.
