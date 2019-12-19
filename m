Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D14CB1258DA
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 01:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfLSAtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 19:49:40 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43892 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLSAtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 19:49:39 -0500
Received: by mail-qk1-f195.google.com with SMTP id t129so3220360qke.10;
        Wed, 18 Dec 2019 16:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6mGyyUCF9j+culY5LRSHnKGFLW14lBd2OHWps1dVqgY=;
        b=SKjgyT+U9EQij+SQJLG7KjIp4wALmlaVeN1Ni/ZqwDldRVVg8hGBtBtL6jbzHhfCTe
         MWk1ola827erClF77Cla0PDtvMrCxQ0xio2WgFxZV8WYmimpeocRfqBBWq0rqWo3gsUT
         p0o8ADMXDCZIrR50y39n39j6AHoZB4Owa+JRpGNgBFw4ErWnlTBqpwuH2knfea/qBalA
         cRBnW3n3CQY35e3tEG9KZetsKDiTNZiTE64QdKJT8sbvj0/3XuZ7gGGbJK8xYFyky3gz
         kcxUy0ZbbiDJ49HRDKazRVL+zOQ7VLGLAvWyEurz7AfQrVZiOiqA0hhaA+j1mOgszigE
         RxWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6mGyyUCF9j+culY5LRSHnKGFLW14lBd2OHWps1dVqgY=;
        b=XsNEfkFNRkpy9JfyLyHbeXUDFvPQ+mXpVF5XshM4jnsBJXi+poaXq20pr3H2i0+/qs
         +1DSrYQgpqMBOECTajvvb+dOrh9PQgw8yTvxuhSpRylsEGZYCyeZDN3nqIRcHqJh8Ft8
         bwt+HOIZCFxsCktf2B1GqU/t6qmw8AGyjo+5x4GcNqT9KsITJ+Dg0Olpp2GLQkBn0i/+
         sgVhmMlE5g3RnQpLhf+8vMFICsVCtamboqQ/FIUcolf3I0MXDKqRazhHdm6vd2RDKuIJ
         iDDDIGo7V1K80YHEzVNBpvYqeD5NuKeY4Yg4sOy6853uWN9sFq0tBnKpr6+T3TFt+v5S
         3++w==
X-Gm-Message-State: APjAAAUTS4Pd0Q4pjJ2a3y+11ByiEayM5LFRJe7ROhaVEAfJwr/J8OBK
        YhjJVMv2mibao7hdkH9OCQJfL203S6Enj3gtQ0o=
X-Google-Smtp-Source: APXvYqz+GtMUOjE8EuAJbAsfEgZe5osvaGLNibegzFzWPpes5jE3JnQ3/tAEQrkjDiVlCXfBcyXEV+/79VxYQzYa6Rg=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr5789145qkq.437.1576716578643;
 Wed, 18 Dec 2019 16:49:38 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576673841.git.paul.chaignon@orange.com>
 <ec8fd77bb20881e7149f7444e731c510790191ce.1576673842.git.paul.chaignon@orange.com>
 <377d5ad0-cf4f-4c8b-c23d-ed37dce4ad9f@fb.com>
In-Reply-To: <377d5ad0-cf4f-4c8b-c23d-ed37dce4ad9f@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Dec 2019 16:49:27 -0800
Message-ID: <CAEf4BzZe7hoq1CsCf8am=w2pHr6j+S5dKE08K38PP8RL6At2Zg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Single-cpu updates for per-cpu maps
To:     Yonghong Song <yhs@fb.com>
Cc:     Paul Chaignon <paul.chaignon@orange.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "paul.chaignon@gmail.com" <paul.chaignon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 11:11 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/18/19 6:23 AM, Paul Chaignon wrote:
> > Currently, userspace programs have to update the values of all CPUs at
> > once when updating per-cpu maps.  This limitation prevents the update of
> > a single CPU's value without the risk of missing concurrent updates on
> > other CPU's values.
> >
> > This patch allows userspace to update the value of a specific CPU in
> > per-cpu maps.  The CPU whose value should be updated is encoded in the
> > 32 upper-bits of the flags argument, as follows.  The new BPF_CPU flag
> > can be combined with existing flags.
> >
> >    bpf_map_update_elem(..., cpuid << 32 | BPF_CPU)
>
> Some additional comments beyond Alexei's one.
>
> >
> > Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
> > ---
> >   include/uapi/linux/bpf.h       |  4 +++
> >   kernel/bpf/arraymap.c          | 19 ++++++++-----
> >   kernel/bpf/hashtab.c           | 49 ++++++++++++++++++++--------------
> >   kernel/bpf/local_storage.c     | 16 +++++++----
> >   kernel/bpf/syscall.c           | 17 +++++++++---
> >   tools/include/uapi/linux/bpf.h |  4 +++
> >   6 files changed, 74 insertions(+), 35 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index dbbcf0b02970..2efb17d2c77a 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -316,6 +316,10 @@ enum bpf_attach_type {
> >   #define BPF_NOEXIST 1 /* create new element if it didn't exist */
> >   #define BPF_EXIST   2 /* update existing element */
> >   #define BPF_F_LOCK  4 /* spin_lock-ed map_lookup/map_update */
> > +#define BPF_CPU              8 /* single-cpu update for per-cpu maps */
> > +
> > +/* CPU mask for single-cpu updates */
> > +#define BPF_CPU_MASK 0xFFFFFFFF00000000ULL
> BPF_F_CPU_MASK?

Maybe even define this as a function-like macro:

#define BPF_F_CPU_NR(cpu) ((cpu) << 32)

so that it can be easily combined with other flags in code like so:

bpf_map_update_element(...., BPF_F_LOCK | BPF_F_CPU_NR(10))

BPF_F_CPU_NR can automatically set BPF_F_CPU flag as well, btw.

[...]
