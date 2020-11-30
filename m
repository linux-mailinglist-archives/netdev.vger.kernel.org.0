Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF6E2C91FA
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730323AbgK3XFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgK3XFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:05:05 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FFCC0613D2;
        Mon, 30 Nov 2020 15:04:19 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id 2so29369ybc.12;
        Mon, 30 Nov 2020 15:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FcdCh/v5NxhzKO7B/LcAhxjhmyB/cop9iS9YZdJH0eo=;
        b=Xa7AQOjkFhsgA7UULwuIXPXK3BAXNuiItzYS03ZtU6F0tocGaunbNYd7nohn7KUago
         H86tmIye4RHkA0GaMhJEdvBoNtEUliC0QDfUG0FBA25vqRHtQj2x1nXfGXN3BTyNL45R
         fdS9HHD7XlGHdsxePUxYxr6VKqU7TOR29DiiuMv8O4QEUpo2TrTI7DoSmEQwGfz/jfEy
         BdJ5H8axWN5VBicW7QgddSu5O2/Q1caZM7wTA8xb1JjKFGfeG574+5YPm5FeqUTmRq0p
         iHgxxpoEIcvD++7XHhjOlfoZsaOvRXD4wtCGswEXg0FKG3Xa1xOv+jtqRmphSdmybFID
         auvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FcdCh/v5NxhzKO7B/LcAhxjhmyB/cop9iS9YZdJH0eo=;
        b=e7aDzHFe81smcfbnpB6ZiL/HDyQ0oYK1zbVqlCbfhAtjOAkrZLaAgln6uHKsGmsqEe
         oolACGtSgPBCoyWnBONJKBKPefu5fdYhQH7uuwCwScqdv4AeShXIcrdTj/PehLneVMia
         Du29p1SgTsx0i4hfhjrG7DkXjF1kT6rygRd2Wwox48mmtBJxXka+PY9XezdvVFNGqAAQ
         33i2Np6/uGdiMxnDT7I6arILZ1t8MV9IlD9te/aujMHk3OU30JSphBx7+BKXpw+ojc5b
         sP5ws7jVP3crFcBWhzCkKXQsWq0fsq+6nEbprCnhbxxq0uswy8EzxyY/tW3aVJxBsrF5
         nl1w==
X-Gm-Message-State: AOAM530FQFXs/2QxLtsAHrL6lzw7Hq8sHMslbt96KXoAIzWd+UUZ6/0c
        K3loXnOHrKReOONI98EcA8t2KPxJ3Rd+MUkEEao=
X-Google-Smtp-Source: ABdhPJxFTU8gyjgsT9aYEkgOAQ5WhggXk1xc0XKwPRN67yVtQNn7pkNw+/1yKoDdWFtnqRKdB+gqqt+5Te3s3HVgSyE=
X-Received: by 2002:a25:df82:: with SMTP id w124mr33565910ybg.347.1606777459095;
 Mon, 30 Nov 2020 15:04:19 -0800 (PST)
MIME-Version: 1.0
References: <20201121024616.1588175-1-andrii@kernel.org> <20201121024616.1588175-2-andrii@kernel.org>
 <20201129015628.4jxmeesxfynowpcn@ast-mbp>
In-Reply-To: <20201129015628.4jxmeesxfynowpcn@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Nov 2020 15:04:07 -0800
Message-ID: <CAEf4BzZN5RZ4qfMRKz0MGgEvX19TpzbmeMyTvf3misxvHuRGOg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/7] bpf: remove hard-coded btf_vmlinux
 assumption from BPF verifier
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 5:56 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Nov 20, 2020 at 06:46:10PM -0800, Andrii Nakryiko wrote:
> >
> > @@ -52,12 +53,19 @@ struct bpf_reg_state {
> >                */
> >               struct bpf_map *map_ptr;
> >
> > -             u32 btf_id; /* for PTR_TO_BTF_ID */
> > +             /* for PTR_TO_BTF_ID */
> > +             struct {
> > +                     struct btf *btf;
> > +                     u32 btf_id;
> > +             };
>
> bpf_reg_state is the main structure contributing to the verifier memory consumption.
> Is it possible to do the tracking without growing it?

The only way to keep this at 8 bytes in the existing union is to use
ID for BTF, but that has tons of problems: need to do look up all the
time, plus there is now a possibility of that BTF instance going away
(e.g., if kernel module is unloaded), etc. Pain.

But, I just looked at bpf_reg_state with pahole, and there are two
4-byte holes: before this union and after ref_obj_id. So if I move
"off" to before the union, the overall size of the struct won't
change, even if the union itself grows to 16 bytes. And it won't break
states_equal() logic, from what I can see.


So with that, bpf_reg_state BEFORE:

struct bpf_reg_state {
        enum bpf_reg_type          type;                 /*     0     4 */

        /* XXX 4 bytes hole, try to pack */

        union {
                int                range;                /*     8     4 */
                struct bpf_map *   map_ptr;              /*     8     8 */
                u32                btf_id;               /*     8     4 */
                u32                mem_size;             /*     8     4 */
                long unsigned int  raw;                  /*     8     8 */
        };                                               /*     8     8 */
        s32                        off;                  /*    16     4 */
        u32                        id;                   /*    20     4 */
        u32                        ref_obj_id;           /*    24     4 */

        /* XXX 4 bytes hole, try to pack */

        struct tnum                var_off;              /*    32    16 */
        s64                        smin_value;           /*    48     8 */
        s64                        smax_value;           /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        u64                        umin_value;           /*    64     8 */
        u64                        umax_value;           /*    72     8 */
        s32                        s32_min_value;        /*    80     4 */
        s32                        s32_max_value;        /*    84     4 */
        u32                        u32_min_value;        /*    88     4 */
        u32                        u32_max_value;        /*    92     4 */
        struct bpf_reg_state *     parent;               /*    96     8 */
        u32                        frameno;              /*   104     4 */
        s32                        subreg_def;           /*   108     4 */
        enum bpf_reg_liveness      live;                 /*   112     4 */
        bool                       precise;              /*   116     1 */

        /* size: 120, cachelines: 2, members: 19 */
        /* sum members: 109, holes: 2, sum holes: 8 */
        /* padding: 3 */
        /* last cacheline: 56 bytes */
};

And with BTF pointer AFTER:

struct bpf_reg_state {
        enum bpf_reg_type          type;                 /*     0     4 */
        s32                        off;                  /*     4     4 */
        union {
                int                range;                /*     8     4 */
                struct bpf_map *   map_ptr;              /*     8     8 */
                struct {
                        struct btf * btf;                /*     8     8 */
                        u32        btf_id;               /*    16     4 */
                };                                       /*     8    16 */
                u32                mem_size;             /*     8     4 */
                struct {
                        long unsigned int raw1;          /*     8     8 */
                        long unsigned int raw2;          /*    16     8 */
                } raw;                                   /*     8    16 */
        };                                               /*     8    16 */
        u32                        id;                   /*    24     4 */
        u32                        ref_obj_id;           /*    28     4 */
        struct tnum                var_off;              /*    32    16 */
        s64                        smin_value;           /*    48     8 */
        s64                        smax_value;           /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        u64                        umin_value;           /*    64     8 */
        u64                        umax_value;           /*    72     8 */
        s32                        s32_min_value;        /*    80     4 */
        s32                        s32_max_value;        /*    84     4 */
        u32                        u32_min_value;        /*    88     4 */
        u32                        u32_max_value;        /*    92     4 */
        struct bpf_reg_state *     parent;               /*    96     8 */
        u32                        frameno;              /*   104     4 */
        s32                        subreg_def;           /*   108     4 */
        enum bpf_reg_liveness      live;                 /*   112     4 */
        bool                       precise;              /*   116     1 */

        /* size: 120, cachelines: 2, members: 19 */
        /* padding: 3 */
        /* last cacheline: 56 bytes */
};

No more holes, but the same overall size. Does that work?



>
> >
> >               u32 mem_size; /* for PTR_TO_MEM | PTR_TO_MEM_OR_NULL */
> >
> >               /* Max size from any of the above. */
> > -             unsigned long raw;
> > +             struct {
> > +                     unsigned long raw1;
> > +                     unsigned long raw2;
> > +             } raw;
