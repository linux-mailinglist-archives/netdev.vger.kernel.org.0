Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB6123262E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 22:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgG2U3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 16:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgG2U3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 16:29:15 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAFEC0619D6
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 13:29:14 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f5so26464995ljj.10
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 13:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=eXXlgM+MUPpPPfTh3rHsvZA+GfPreMuU57DQ0ya/UJE=;
        b=W9RbE66qoU1T8TntFNi8gXgAothfJbZNOtTO9R0N0QKAw7+PmzwiIkG8gGKQGsULXP
         v/Ms+3cRPoqtcgnRRPYTzaO1ZjEPRSfLOC+gN05Y6A21GgsUocmOoEDOWaDMQYwzPmtN
         SbshNFq1bkv/XGqNC4nbLHuEo2l+GjUwjQ2t8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=eXXlgM+MUPpPPfTh3rHsvZA+GfPreMuU57DQ0ya/UJE=;
        b=U99nIVhRyQCHTnK/iLfl1tIec2vAkdQmjWfzlhWUuMeUWJwKhfqXNzP4VG5Td/QSt8
         fOn2k0fgE7GXu6MsQhPHcT1Kp3jGghlUBx86ANuinerfm0t34c7QBO/CoL5vqgzZt+P9
         +4lKmRVX571/kk/u2BVhlG3YwvJyL4kQTBGeg4Rz45CUswaeBOs4fl2DfESNXXp6/8RL
         Xe0C0AOS/zZaxi4mVA2mTF2VsMJq1rqx4qhOTXeuTSVW47Ily2aypG5wVqHtVRpmF/5p
         UmVtDCMcUIJS1MeKFvh5ne2m65HkJIdHsvJbSIlff/Qs1MJ/llhWiCfCAeuCF74EnZmT
         58mg==
X-Gm-Message-State: AOAM531wic3mh2EZ+6hBpiCaBuX0JISxUvPcEgF0CWcATIS5vwNEeILQ
        Gk7twrsFg7m4tyuKSKWSum7xaw==
X-Google-Smtp-Source: ABdhPJwZxwsuEcU0z0+1V4tYm22WH4f9ZWQlTyR3HSmtnordW8+QKQYgmMw1o6qpr0Ffru6oah60pA==
X-Received: by 2002:a2e:905a:: with SMTP id n26mr87224ljg.254.1596054552552;
        Wed, 29 Jul 2020 13:29:12 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id i26sm426493ljj.102.2020.07.29.13.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 13:29:11 -0700 (PDT)
References: <20200729040913.2815687-1-andriin@fb.com> <20200729040913.2815687-2-andriin@fb.com> <87k0ymwg2b.fsf@cloudflare.com> <CAEf4BzYagTebczsojJJfn0viy07dhRUq3oysezEO_LSYSuwfRQ@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH v4 bpf 2/2] selftests/bpf: extend map-in-map selftest to detect memory leaks
In-reply-to: <CAEf4BzYagTebczsojJJfn0viy07dhRUq3oysezEO_LSYSuwfRQ@mail.gmail.com>
Date:   Wed, 29 Jul 2020 22:29:10 +0200
Message-ID: <87ime6vze1.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 07:48 PM CEST, Andrii Nakryiko wrote:
> On Wed, Jul 29, 2020 at 7:29 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> On Wed, Jul 29, 2020 at 06:09 AM CEST, Andrii Nakryiko wrote:

[...]

>> > +/*
>> > + * Trigger synchronize_cpu() in kernel.
>>
>> Nit: synchronize_*r*cu().
>
> welp, yeah
>
>>
>> > + *
>> > + * ARRAY_OF_MAPS/HASH_OF_MAPS lookup/update operations trigger
>> > + * synchronize_rcu(), if looking up/updating non-NULL element. Use this fact
>> > + * to trigger synchronize_cpu(): create map-in-map, create a trivial ARRAY
>> > + * map, update map-in-map with ARRAY inner map. Then cleanup. At the end, at
>> > + * least one synchronize_rcu() would be called.
>> > + */
>>
>> That's a cool trick. I'm a bit confused by "looking up/updating non-NULL
>> element". It looks like you're updating an element that is NULL/unset in
>> the code below. What am I missing?
>
> I was basically trying to say that it has to be a successful lookup or
> update. For lookup that means looking up non-NULL (existing) entry.
> For update -- setting valid inner map FD.
>
> Not sure fixing this and typo above is worth it to post v5.

I just wanted to understand that the helper is working as intended. It
seems handy. I agree that it's not worth respinning the patches just for
this.

>
>>
>> > +static int kern_sync_rcu(void)
>> > +{
>> > +     int inner_map_fd, outer_map_fd, err, zero = 0;
>> > +
>> > +     inner_map_fd = bpf_create_map(BPF_MAP_TYPE_ARRAY, 4, 4, 1, 0);
>> > +     if (CHECK(inner_map_fd < 0, "inner_map_create", "failed %d\n", -errno))
>> > +             return -1;
>> > +
>> > +     outer_map_fd = bpf_create_map_in_map(BPF_MAP_TYPE_ARRAY_OF_MAPS, NULL,
>> > +                                          sizeof(int), inner_map_fd, 1, 0);
>> > +     if (CHECK(outer_map_fd < 0, "outer_map_create", "failed %d\n", -errno)) {
>> > +             close(inner_map_fd);
>> > +             return -1;
>> > +     }
>> > +
>> > +     err = bpf_map_update_elem(outer_map_fd, &zero, &inner_map_fd, 0);
>> > +     if (err)
>> > +             err = -errno;
>> > +     CHECK(err, "outer_map_update", "failed %d\n", err);
>> > +     close(inner_map_fd);
>> > +     close(outer_map_fd);
>> > +     return err;
>> > +}
>> > +
>
> [...]
>
> trimming's good ;)

You caught me. Just being lazy. No excuses :-)
