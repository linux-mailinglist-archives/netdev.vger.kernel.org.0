Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAA4198A9C
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 05:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgCaDn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 23:43:26 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39445 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbgCaDn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 23:43:26 -0400
Received: by mail-pj1-f66.google.com with SMTP id z3so503014pjr.4;
        Mon, 30 Mar 2020 20:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YfVLm822WaIxf+LpzAETaD8faJozYcUOEo6HcGMd9Ck=;
        b=IbNnlW5tJ8EhGyv+0HPUZwBwWgOJeeUqlY1EVaHoiqpFXChUAl8ROBqsakNguEvybj
         TOm5boQbYilYOkrT/tvMVEhhHXNdK+aDq8QiS7nJqy6zMdfb3oCtYjj2jWYkFGavWmVL
         SbopXPztqJhd8PhPLBPOSOiIR4UDjlZ4w1BrxqhNoDt5G0qUdWIUuhfG3p0igzjJHKGY
         K/lDD+fCvfLsY4W1br/4Mbm0lp7sEkcpSdSvldhaj3NSNFlTiFXK1PnNSHXcR+s8VWiv
         oeulcJq7TemO0XdBCOGcV2VGGFbUIEvgSJEi3CEsZAm+eWAeVdbWflHt+N0Jm8harddB
         U63A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YfVLm822WaIxf+LpzAETaD8faJozYcUOEo6HcGMd9Ck=;
        b=ArLc+JHSqyLQhSDZrw0vCNVbc2dcW9hBhWSZAjwervGfe0YI6vUm8NZr++lxNiIk9P
         GJ+ec7yzvOqW+slWyW0kCaZCLuXqFhVLwO1wrWX0G3WDeuOca2xUAYqYYqPqL5MaotWw
         5yJR8fImfV07eQsEVAW1fQzv8N7cWGW7gIURlcdrSYbwWGEl5gul9IB75CQ3rVyM1H+Q
         thlwghA7uJuWu+UnNRsME/yaZwrBcvBbgWHm+Vzd4LzIO+p4qDAAvVhYOqoT+o00QxO/
         PAjtWbuietJ4KGydzoZP+QCm5g8k49AO7C7cV5Jlzf9Y5+WncBqIvZwrEgBm3quPg8V9
         lyow==
X-Gm-Message-State: AGi0Pub46kgvIbYx86Q6eyI64u/yYa14kx9CZrdy1uSNnhuJZEjd/NJk
        lU5Sj+KIrQ55FpZCDs/aezzF2/WB
X-Google-Smtp-Source: APiQypKEiATaaHVj8MlS/O5BhQcT8M3/Tb5Cb2mE7NHB4U4zjSd2bjLeeCpvIk+ul3Z3X+qg3iVfBA==
X-Received: by 2002:a17:90a:757:: with SMTP id s23mr1511702pje.166.1585626205129;
        Mon, 30 Mar 2020 20:43:25 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:442d])
        by smtp.gmail.com with ESMTPSA id b2sm768982pjc.6.2020.03.30.20.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 20:43:24 -0700 (PDT)
Date:   Mon, 30 Mar 2020 20:43:19 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     David Ahern <dsahern@gmail.com>, Lorenz Bauer <lmb@cloudflare.com>,
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
Message-ID: <20200331034319.lg2tgxxs5eyiqebi@ast-mbp>
References: <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk>
 <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com>
 <CACAyw98yYE+eOx5OayyN2tNQeNqFXnHdRGSv6DYX7ehfMHt1+g@mail.gmail.com>
 <9f0ab343-939b-92e3-c1b8-38a158da10c9@gmail.com>
 <20200327230253.txq54keztlwsok2s@ast-mbp>
 <eba2b6df-e2e8-e756-dead-3f1044a061cd@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eba2b6df-e2e8-e756-dead-3f1044a061cd@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 04:25:07PM +0100, Edward Cree wrote:
> On 27/03/2020 23:02, Alexei Starovoitov wrote:
> > On Fri, Mar 27, 2020 at 10:12:05AM -0600, David Ahern wrote:
> >> I had a thought yesterday along similar lines: bpf_link is about
> >> ownership and preventing "accidental" deletes.
> > The mechanism for "human override" is tbd.
> Then that's a question you really need to solve, especially if you're
>  going to push bpf_link quite so... forcefully.
> Everything that a human operator can do, so can any program with the
>  same capabilities/wheel bits.  Especially as the API that the
>  operator-tool uses *will* be open and documented.  The Unix Way does
>  not allow unscriptable interfaces, and heavily frowns at any kind of
>  distinction between 'humans' and 'programs'.

can you share a link on such philosophy?
I was thinking something like CAPTCHA 'confirm if you're not a robot'
type of a button.
So humans doing 'bpftool link show' followed by 'bpftool link del id 123'
will work as expected, but processes cannot use the same api to
nuke other processes.

> So what will the override look like?  A bpf() syscall with a special
>  BPF_F_IM_A_HUMAN_AND_I_KNOW_WHAT_IM_DOING flag?  ptracing the link
>  owner, so that you can close() its fd?  Something in between?

not sure yet.

> In any case, the question is orthogonal to the bpf_link vs. netlink
>  issue: the netlink XDP attach could be done with a flag that means
>  "don't allow replacement/removal without EXPECTED_FD".  No?

Nothing to do with netlink, of course. Both XDP and tc bpf hooks
missing the concept of owner of the attachment.
For tc it's easier to implement and understand, since it allows
multi prog. If process A attaches a tc clsbpf prog via bpf_link
another process B will not be able to nuke it.
