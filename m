Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494421947F4
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 20:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgCZTxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 15:53:46 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36214 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbgCZTxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 15:53:45 -0400
Received: by mail-pg1-f193.google.com with SMTP id j29so3440880pgl.3;
        Thu, 26 Mar 2020 12:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NdH/RCw4Q9rf6SjZIz3IXuqfxmQt5miEwXKIUBifQsk=;
        b=tKQk06MVQ9bF14Y+Pqshqqr2fmtu+laSp6grxWXU5dwmRrrpY2ZwWO4jqCUUMkWKri
         Yyoj6PjRLpcGe3J1eJoukUXhtPLy9IVvZwBMSZbJWZbgsmgrnh9JVMh/PqpWDKzwmHNn
         qyOaOx7T2BnLcvEwcuifCvC92IRXULxzv2ql6Rfzu4MBPyl/+Rka+xb6dTxBWmzpEdso
         wadnBlfpfYkq95IbBsxmpnS7tZ9Bp4AThTGowOts/3UZijqL8jJRO80nVjHQOD/8RAMV
         6FLPwW+3lDbXKpBeBZd7hgaVN6o2+/Hu32NpHc8/ILBi3J7zBrrxIRLwanTX4JmwH5fs
         RtEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NdH/RCw4Q9rf6SjZIz3IXuqfxmQt5miEwXKIUBifQsk=;
        b=JELS7wQt+KRd4nh+pio0+b4vUpVZdiaXlUjoAYE5Z89Xl0ORC2RDdTJ33CVpxnSA8b
         CzzWDejgQIxQ4K/fqVL5oWa7zAfooNZZIq28BCJMul5QzvPV2pO8Wp7l8TT/klZ6ve7n
         ZJwbnZlenKnufiPDGnEPOrTTbWzZ4vFZGqD/aVYhLAPatxTp0CeYeeON8UQMeIOcP/Ak
         7g6MkneOog6/TZAtueluR1aj1GmfikJMHb6srhI86sNCkcz1L+kGX/Ot31eY/D12TK1P
         TBodt42FjddrRt6EyOZiERWN9VPLLyk5uu8AIW6pyiIc5n6F4l2lRZ5G5Dd1ASt9pzmU
         ShFQ==
X-Gm-Message-State: ANhLgQ3DsaqJEvB1SXH57r80046iJZKUtitrOnLnqiOMyZVThIKV1Spm
        YVS0j7I3WVeMWyPAYfz+n0Q=
X-Google-Smtp-Source: ADFU+vtEBadQJ/7WLewVkoRffEujzREBUpWBH8tvz2053lUuuHSThPk6P0UjgNTDncExuxwsttfRrQ==
X-Received: by 2002:a63:d10c:: with SMTP id k12mr9722824pgg.392.1585252424830;
        Thu, 26 Mar 2020 12:53:44 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c7d9])
        by smtp.gmail.com with ESMTPSA id 74sm2304925pfy.120.2020.03.26.12.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 12:53:43 -0700 (PDT)
Date:   Thu, 26 Mar 2020 12:53:40 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200326195340.dznktutm6yq763af@ast-mbp>
References: <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 10:04:53AM +0000, Lorenz Bauer wrote:
> On Thu, 26 Mar 2020 at 00:16, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> [...]
> >
> > Those same folks have similar concern with XDP. In the world where
> > container management installs "root" XDP program which other user
> > applications can plug into (libxdp use case, right?), it's crucial to
> > ensure that this root XDP program is not accidentally overwritten by
> > some well-meaning, but not overly cautious developer experimenting in
> > his own container with XDP programs. This is where bpf_link ownership
> > plays a huge role. Tupperware agent (FB's container management agent)
> > would install root XDP program and will hold onto this bpf_link
> > without sharing it with other applications. That will guarantee that
> > the system will be stable and can't be compromised.
> 
> Thanks for the extensive explanation Andrii.
> 
> This is what I imagine you're referring to: Tupperware creates a new network
> namespace ns1 and a veth0<>veth1 pair, moves one of the veth devices
> (let's says veth1) into ns1 and runs an application in ns1. On which veth
> would the XDP program go?

As you can imagine there are many teams and use cases in the data center.
If I say that netns is not used it won't be true. Since there are folks
that use netns. Though it's strongly discouraged.
For container usage though netns is not used. IP virtualization is done
via cgroup-bpf bind/connect override.
But it's also not in 100% of containers.
There are various teams that use XDP already and some that want to start
using it. The XDP orchestration is lacking. That's all the discussions
around libxdp (and now renamed to libdispatcher, right Toke?) are about.
The design of libdispatcher will evolve over time.
No one is saying that we thought through of everything.
