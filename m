Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E56151530
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 06:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgBDFAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 00:00:50 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39675 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgBDFAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 00:00:49 -0500
Received: by mail-qt1-f193.google.com with SMTP id c5so13386776qtj.6;
        Mon, 03 Feb 2020 21:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oH2168lVN0oQLJlQ6ANE+ecGDwUg2wE/2zMjiFokCE0=;
        b=FGAi28OKGXINIxNUrjAikt9lD51IL6zT96kCdCbGC4zI5mWMagGPf/4/znQe/ZnwJQ
         VXzDKqbRmEFBEuss8KAlkSADgSn4iT9Xbn9waWIDkSyAlxmVpv+WjGHwl6k1GU0YLJfk
         8YA29w168yt7vDGb9/QRw/7tNZsE8su0PVa6NqpN26qYcqJFRiLJpE/v8sv/LGs4Hfvm
         uS0lpd+CcT8e4p1aVBY/dDWeRrLuZUFnPtvbC4itjSG0RCvqollrLx5sXUVSHLXinZ+x
         t5LPH1Uy8U6P0n7to20Z1J0IiAtZEP76vsWV0sRzMgHmCQKOPqUJXUm0hQoKUJgV2gfw
         6KDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oH2168lVN0oQLJlQ6ANE+ecGDwUg2wE/2zMjiFokCE0=;
        b=oOMulqIRSd4U2X4TC4qNFQ6AcK6YJy9/qyamH9kjOFNaM4W01fu66OicXpALRSgCXw
         rnOqSIhOb9qVUiC2K8K79sqxxpTKsS6y45qbyO1dpXgrBtXGYQxwvC8ksk6YO2OGAjVo
         Ttmx8i0C7oZlo58VlHJVmyDr7hys09zW5ebzOI04TBnuKnSYmbAi//1ktu+Bw7gAl5yA
         SG+8nhrY+jfTmNfO9yLbBOeb4rK6lTz9WYPyja+1C3xkXWX0KyTGmmewwFpoNTkQU2YF
         qav3Q8FHXGebqEiiDcwyF2p2cWYu4vmzg1zLBNLE2qdcVmE8tBKBRjbFftuqYP38FLzh
         KMgQ==
X-Gm-Message-State: APjAAAXyGmSvzMIh0bDbOZbPvQneG8Hf21UoPYfc7G1sZW8qPC09qo2g
        9B5UwK5KQB7ByTCNjjzbWKOXP4RkspltMuprs+Y=
X-Google-Smtp-Source: APXvYqz6kXDqnEVUjlI5CIjFy6hPZOJusOV1vyn2arjCXGSwmfPBw6AU9t2Yd9PukOs2fd+1hD8yQ/YgggmOMUDG5U4=
X-Received: by 2002:ac8:1385:: with SMTP id h5mr26257889qtj.59.1580792448750;
 Mon, 03 Feb 2020 21:00:48 -0800 (PST)
MIME-Version: 1.0
References: <20190820114706.18546-1-toke@redhat.com> <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
 <87blwiqlc8.fsf@toke.dk> <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
 <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net> <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com>
 <87tva8m85t.fsf@toke.dk> <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com>
 <CAEf4BzZOAukJZzo4J5q3F2v4MswQ6nJh6G1_c0H0fOJCdc7t0A@mail.gmail.com>
 <87blqfcvnf.fsf@toke.dk> <CAEf4Bza4bSAzjFp2WDiPAM7hbKcKgAX4A8_TUN8V38gXV9GbTg@mail.gmail.com>
 <0bf50b22-a8e2-e3b3-aa53-7bd5dd5d4399@gmail.com> <CAEf4Bzbzz3s0bSF_CkP56NTDd+WBLAy0QrMvreShubetahuH0g@mail.gmail.com>
 <2cf136a4-7f0e-f4b7-1ecb-6cbf6cb6c8ff@gmail.com>
In-Reply-To: <2cf136a4-7f0e-f4b7-1ecb-6cbf6cb6c8ff@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 Feb 2020 21:00:37 -0800
Message-ID: <CAEf4Bzb1fXdGFz7BkrQF7uMhBD1F-K_kudhLR5wC-+kA7PMqnA@mail.gmail.com>
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

On Mon, Feb 3, 2020 at 8:53 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/3/20 8:41 PM, Andrii Nakryiko wrote:
> > On Mon, Feb 3, 2020 at 5:46 PM David Ahern <dsahern@gmail.com> wrote:
> >>
> >> On 2/3/20 5:56 PM, Andrii Nakryiko wrote:
> >>> Great! Just to disambiguate and make sure we are in agreement, my hope
> >>> here is that iproute2 can completely delegate to libbpf all the ELF
> >>>
> >>
> >> iproute2 needs to compile and continue working as is when libbpf is not
> >> available. e.g., add check in configure to define HAVE_LIBBPF and move
> >> the existing code and move under else branch.
> >
> > Wouldn't it be better to statically compile against libbpf in this
> > case and get rid a lot of BPF-related code and simplify the rest of
> > it? This can be easily done by using libbpf through submodule, the
> > same way as BCC and pahole do it.
> >
>
> iproute2 compiles today and runs on older distributions and older
> distributions with newer kernels. That needs to hold true after the move
> to libbpf.

And by statically compiling against libbpf, checked out as a
submodule, that will still hold true, wouldn't it? Or there is some
complications I'm missing? Libbpf is designed to handle old kernels
with no problems.
