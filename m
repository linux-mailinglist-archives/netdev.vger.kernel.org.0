Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 174C91961BC
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 00:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgC0XC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 19:02:58 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34116 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbgC0XC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 19:02:58 -0400
Received: by mail-pg1-f196.google.com with SMTP id d37so4796846pgl.1;
        Fri, 27 Mar 2020 16:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZSTOHs0uJUooAn9pagNglK3cT6ayiCgMskC9nSrVy4U=;
        b=oOjFI45iMQvpgqZHOAeeBIFOND/qRw3RsG0IWNX4Wkw+bGgidsQFgzHS+uo8LogjxP
         gdYvf1Ig/KMS89yQGVKCDCLosDZHGHARNvQ2kF2Q1zNVqePkuQNLZk7myiETin0ypp7G
         Fdnz9XQSF32YFwJG/WPZviZH05KujEBOj7tAQefdxnpl7TyyZ2wKLtMgmThd6tQsQ1Gb
         eaDcDZkF5dnaMGd03vdKL+OK4YmRk/3NlGgE2ciACXwm1CzxNJONzXdPdJmqdSTasn90
         KOqs+6Sdo0Yqi8Drlsgqn3DH6MdBNGFR/24Qkxid5SME3JEdBLLW0yrw4EOEaZIYAqBJ
         puYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZSTOHs0uJUooAn9pagNglK3cT6ayiCgMskC9nSrVy4U=;
        b=Yz6pHnYP9DUJcrg6zEvw9MZg7Pcl6lGuHQHQcdxYt04OY8wMlHXIHwq1ke8YrLY6bA
         cODgsWs9x/6wSE9LRhZV2HNXY+0ZdMVrVRu2xu6XohlL0MTpJRYsif00XU3jL7RTo5w9
         2IR5mlFaPYXWHqZCppZ8cygiXKFK+wBFewoGhnmNHFuIvVdP+Grm7sM7EcJb8GEu5xZx
         iyHgLG4NJ/1oQ7/ZGI5qruZiahNNOiYrCm/Agee0LQfjE19ytNQApcPO5vpa1NMHpIlB
         X0WHXWe+gBLEOqLIMigsDwIUV9fSMrKXj1YKFvcjYm5/Y/ZZi0fU4yxMQIDJ3lUWqCe+
         9geA==
X-Gm-Message-State: ANhLgQ10upyCX07Zow1JpYJYF5v80Ea9+jy1sBUiOS2qaDDKKM133pjv
        w0+htT8xeouWw/jibB4OAjA=
X-Google-Smtp-Source: ADFU+vsqnmnRjqdkSg8uHxYlwosopshvpcGw0AHgzfpgnvsl5rQawsrrMYKJlh/SkWRX5OKMsywU5A==
X-Received: by 2002:aa7:99c8:: with SMTP id v8mr1500729pfi.151.1585350177084;
        Fri, 27 Mar 2020 16:02:57 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:4ef7])
        by smtp.gmail.com with ESMTPSA id 74sm4888023pfy.120.2020.03.27.16.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 16:02:56 -0700 (PDT)
Date:   Fri, 27 Mar 2020 16:02:53 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Message-ID: <20200327230253.txq54keztlwsok2s@ast-mbp>
References: <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk>
 <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com>
 <CACAyw98yYE+eOx5OayyN2tNQeNqFXnHdRGSv6DYX7ehfMHt1+g@mail.gmail.com>
 <9f0ab343-939b-92e3-c1b8-38a158da10c9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f0ab343-939b-92e3-c1b8-38a158da10c9@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 10:12:05AM -0600, David Ahern wrote:
> On 3/27/20 5:06 AM, Lorenz Bauer wrote:
> > However, this behaviour concerns me. It's like Windows not
> > letting you delete a file while an application has it opened, which just leads
> > to randomly killing programs until you find the right one. It's frustrating
> > and counter productive.
> > 
> > You're taking power away from the operator. In your deployment scenario
> > this might make sense, but I think it's a really bad model in general. If I am
> > privileged I need to be able to exercise that privilege. This means that if
> > there is a netdevice in my network namespace, and I have CAP_NET_ADMIN
> > or whatever, I can break the association.
> > 
> > So, to be constructive: I'd prefer bpf_link to replace a netlink attachment and
> > vice versa. If you need to restrict control, use network namespaces
> > to hide the devices, instead of hiding the bpffs.
> 
> I had a thought yesterday along similar lines: bpf_link is about
> ownership and preventing "accidental" deletes. What's the observability
> wrt to learning who owns a program at a specific attach point and can
> that ever be hidden.

Absolutely. all links should be visible somehow.
idr for links with equivalent get_next_id and get_fd_from_id will be available.
The mechanism for "human override" is tbd.
