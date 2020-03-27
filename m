Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC4BA1961C1
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 00:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgC0XJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 19:09:39 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39708 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgC0XJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 19:09:39 -0400
Received: by mail-pf1-f193.google.com with SMTP id k15so92455pfh.6;
        Fri, 27 Mar 2020 16:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N8R66SFaatRG3bpCPd7GFZrr/iJwQydD8sUpVXNI6C4=;
        b=qls0luF/7YnY9B1z+7twnf4QY1JnRebQkDg7AFgY8C7cbepNjbdkjpH+qBx6EUC7/M
         ct/D+OhFMbP2HuNv37K+HTfaGIK23AkMq92BNkK1sgixhvVNCny5RRHEbzpVKNuIR5b4
         S0KoXHal4jUOwKlxweKCcuEkFXe1m6A0PzZb7zEk0SPPOI4+SlQ/r4+k4jes/73LjMUA
         MEC/PWlrEIHn2tbGS3KOT7tQFGbKaeoGcL5zOZNBYi6vgvYQUD23RsKybxrcFYfqbuFq
         UxfIjBwHXFiX23wf2Ml0+PhLb5UpMShKNduqR/yvxU481qI3ILNRtyvlHu0Mq+5QEkXJ
         VbfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N8R66SFaatRG3bpCPd7GFZrr/iJwQydD8sUpVXNI6C4=;
        b=nGHa1LHPbRRKCNJT3qkolHZQONALLsd51mDK/LulFXyKFKLTXqaU4iXLGkZmt/wNq4
         fxQCQ6cJhWo/BJI7A5XgVnBy+J/tgHV30T14m1ke0EnDXw4HuHDAO4B2t559DeQzaZg+
         Jhz1l6zYyvk4lJj2SEUqS0fnByrMx7YAAWUCKDZUcOBqwoAIf0o5d4isLRPhjDgdTB3d
         1fXfbjOZmm9GgXn1tSo+HvIItvZMlfNDIqGGyzpRBbz6HY9EE4nAKWKtH42jAinnXMZW
         puj1bMmVj9ljyLKA8rqBIWp5n7igcYSldTIau28aLZ+awDIL3twbBg7CNUxKRskPfMF3
         Yjdw==
X-Gm-Message-State: ANhLgQ216zgw52CR/2hi2jSo2yoRqvVuJT+1ZzfiN7hA7UNeOGhMj1j+
        d4bDGAylqwLdyp39AWPpWtY=
X-Google-Smtp-Source: ADFU+vtaoyHX9Dhw1+fXsEK3fAqsLSptwH3az4Tf2WGt5lJjTOwV/IDGoY1lJ+wrpS7AV/fgteGKyg==
X-Received: by 2002:a63:f450:: with SMTP id p16mr1716984pgk.211.1585350578164;
        Fri, 27 Mar 2020 16:09:38 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:4ef7])
        by smtp.gmail.com with ESMTPSA id o5sm4490384pgm.70.2020.03.27.16.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 16:09:37 -0700 (PDT)
Date:   Fri, 27 Mar 2020 16:09:34 -0700
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
Message-ID: <20200327230934.gtoc4jthdfc2thu4@ast-mbp>
References: <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk>
 <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com>
 <CACAyw98yYE+eOx5OayyN2tNQeNqFXnHdRGSv6DYX7ehfMHt1+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw98yYE+eOx5OayyN2tNQeNqFXnHdRGSv6DYX7ehfMHt1+g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 11:06:59AM +0000, Lorenz Bauer wrote:
> 
> From your description I like bpf_link, because it'll make attachment easier
> to support, and the pinning behaviour also seems nice. I'm really not fussed
> by netlink vs syscall, whatever.
> 
> However, this behaviour concerns me. It's like Windows not
> letting you delete a file while an application has it opened, which just leads
> to randomly killing programs until you find the right one. It's frustrating
> and counter productive.
> 
> You're taking power away from the operator. In your deployment scenario
> this might make sense, but I think it's a really bad model in general. If I am
> privileged I need to be able to exercise that privilege. This means that if
> there is a netdevice in my network namespace, and I have CAP_NET_ADMIN
> or whatever, I can break the association.

I think I read a lot of assumptions in the above statement that are not the case.
Let me clarify:
bpf_link will not freeze the netdev that you cannot move it.
If you want to ifdown it. It's fine. It can go down.
If you want to move it to another netns it's also fine. bpf_link based attachment
either will become dangling or continue to exist in a different namespace.
That behavior is tbd.
If bpf_link was attached to veth and you want to delete that veth that's also
fine. bpf_link will surely be dangling at this point.

bpf_link is about preserving the ownership of the attachment of a program
to a netdev. I don't see how this is comparable with deletion of files in windows.
