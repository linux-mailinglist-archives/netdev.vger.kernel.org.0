Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 740D41514B3
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 04:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgBDDlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 22:41:45 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36333 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgBDDlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 22:41:45 -0500
Received: by mail-qk1-f195.google.com with SMTP id w25so16617816qki.3;
        Mon, 03 Feb 2020 19:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zzYHmVOeeAxyamF8Kpa4bj+CdDiTycRp7RrsQdQg0AY=;
        b=mJKKo1RQtv+WDSf/3pSDCmDci33yAJiV06eQYYLIdu4e7ZcLhNPFHFgxFd3T0I3pEQ
         dmBxStjANxkZJ816lIX6vWaxH+Tdek1eU9ozIp7BhQApEAgCxLSZoGB4mk4GEFzrACAL
         vzmudr5PdRWb6Q3NHqA+X2H/NY5ba5PQ0kAwiHSMnjojk8iSiEv1Wid+VhhH3BHXPgp/
         BSZsis6TG9eVY2BGyrHOsMq3mtsLk1sXeoc9FnUzPPYXoKIaQ/3jTKa2HHhmO1gAmfga
         VJh67RF+tQ4GYxsWY6yjDasSSh/wD9ByJxPpj6BZLWAcMjh+QzWGkjeTCp/Ix2zc0dF3
         oSqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zzYHmVOeeAxyamF8Kpa4bj+CdDiTycRp7RrsQdQg0AY=;
        b=jzdz3WqkmW9Bx2L1Q1gnPRLiQcKH7InLKU8KT2QvhEyysxQ1uec9FJBtpzdmUpkdAx
         ojcIoEx5h6RZFXnn3i+2nMazIuyTv1Xl/lfsoxMSe9PtN47/nUBTtgWYSBkvvVkPA5Uh
         a/eT+Cg3F7gqOlJQyAUZq7JOqVj1UOWEtIOiALlaIKHVaEfGXHLQ7/k9JvLz5uW9/hwc
         ylh+swYcvyQ2KPmDkhw1F41dD4gHanGGqnPVvN/fobscMRRyyKs0VNGtPyp0alwuVLyU
         3hPAhIkSc5ySme9PMbc8/HhLF13531VCbynHJV41vqKi47rbzqiHkLPYiLIDHx7VGd2h
         90oQ==
X-Gm-Message-State: APjAAAXmgEuBoqnMzfhy0SZJUf/Ny+7EiweIWN7ScAle5HWMBLHRsJY9
        JoVVJMxoKda/g6LsrcU6tAsQaCruWrZVpDx18Y4=
X-Google-Smtp-Source: APXvYqzWq7Dxw5rd0EK8LUD75fgPlTfxQC1yBmBMWvRyA0+QvNRl9jkSbvqY2Op7lY0KrXJWYjMFin7LK0qwU9XMwJA=
X-Received: by 2002:a05:620a:a54:: with SMTP id j20mr26563989qka.92.1580787704060;
 Mon, 03 Feb 2020 19:41:44 -0800 (PST)
MIME-Version: 1.0
References: <20190820114706.18546-1-toke@redhat.com> <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
 <87blwiqlc8.fsf@toke.dk> <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
 <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net> <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com>
 <87tva8m85t.fsf@toke.dk> <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com>
 <CAEf4BzZOAukJZzo4J5q3F2v4MswQ6nJh6G1_c0H0fOJCdc7t0A@mail.gmail.com>
 <87blqfcvnf.fsf@toke.dk> <CAEf4Bza4bSAzjFp2WDiPAM7hbKcKgAX4A8_TUN8V38gXV9GbTg@mail.gmail.com>
 <0bf50b22-a8e2-e3b3-aa53-7bd5dd5d4399@gmail.com>
In-Reply-To: <0bf50b22-a8e2-e3b3-aa53-7bd5dd5d4399@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 Feb 2020 19:41:33 -0800
Message-ID: <CAEf4Bzbzz3s0bSF_CkP56NTDd+WBLAy0QrMvreShubetahuH0g@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
To:     David Ahern <dsahern@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 3, 2020 at 5:46 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/3/20 5:56 PM, Andrii Nakryiko wrote:
> > Great! Just to disambiguate and make sure we are in agreement, my hope
> > here is that iproute2 can completely delegate to libbpf all the ELF
> >
>
> iproute2 needs to compile and continue working as is when libbpf is not
> available. e.g., add check in configure to define HAVE_LIBBPF and move
> the existing code and move under else branch.

Wouldn't it be better to statically compile against libbpf in this
case and get rid a lot of BPF-related code and simplify the rest of
it? This can be easily done by using libbpf through submodule, the
same way as BCC and pahole do it.
