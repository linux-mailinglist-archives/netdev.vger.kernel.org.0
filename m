Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E541E100679
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 14:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfKRN3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 08:29:13 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:33443 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfKRN3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 08:29:13 -0500
Received: by mail-oi1-f170.google.com with SMTP id m193so15301425oig.0
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 05:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ovAJYovZYjZU4hcUSshEHbT9BJVE8bJhx2pPheEKXE=;
        b=sahE+/4JT7F6S0O6k0q0350Nur3ydfr1m5Gy360HQV6DMzYdIyTq2c/pGcPcXovGpI
         f9xyp7gNzaCDm2paR8UwXoOk0XEsoJpdxYLo0OuWFGaHvPleE1UlTRsa0wml2pxCEXrz
         5gu0hqpZpdXkbrcgmypCTTKDjtKip+lL1P5xg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ovAJYovZYjZU4hcUSshEHbT9BJVE8bJhx2pPheEKXE=;
        b=rtCLWwafIaj1tPCos6RsPrAIKRjInZaNRHNqMzctjs3w43dC+mH3Dx0ARkYhdcKrf6
         yjFxEbPFlbSVuO6z966LKNaoQSZjxTijKsTEPzpIRrZHX1O/wC/CtfMMexWMXElXIbIJ
         wHiMphhdnqxEOvY39FLmKJr+La8TwgZd2sGDNgR5a3jqZBklLkwJw25slQXLTCdmHv3v
         5CXgfwjKTRq20h/OBCahReSQK7b2puNYW2GEjcXWSS0w7QCRs+sWOG6spR3rf+9jTl80
         PkCE/Ocve8ZYcVOxTCUdKrMtsIdmeLp7v37+soazR/xBB3gufGskZ7X15Jhi7tdHXH0i
         iVAA==
X-Gm-Message-State: APjAAAVIXjNJpKproN3ZcwQfJcy48f6ZgmJtAM9Dgzs7h6X4pBM8nV6U
        8dS+bu+lYST1OTTPWbLp+FleyvoZAlhm+5IY8Py9Jw==
X-Google-Smtp-Source: APXvYqxBhuyrgZ7wDd4guY83J86yV6FBSBc8FRv9Gv9CN9Oob7CAlKWX6IUhgKPQN3Ik5tVBl8iK/GLaMY+19vHQ7m4=
X-Received: by 2002:aca:f50c:: with SMTP id t12mr19191728oih.78.1574083752567;
 Mon, 18 Nov 2019 05:29:12 -0800 (PST)
MIME-Version: 1.0
References: <5da4ab712043c_25f42addb7c085b83b@john-XPS-13-9370.notmuch>
 <87eezfi2og.fsf@toke.dk> <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com>
 <87r23egdua.fsf@toke.dk> <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk> <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk> <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
 <CACAyw98dcpu1b2nUf7ize2SJGJGd=mhqRK+PYQTx96gSBtbkNQ@mail.gmail.com> <20191115230229.qd6plwnvrmcm4pfo@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191115230229.qd6plwnvrmcm4pfo@ast-mbp.dhcp.thefacebook.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 18 Nov 2019 13:29:00 +0000
Message-ID: <CACAyw9-Sx8jBY2HiO0idLk_HE5R5R229w5qEqVkaQ92YUKM0kg@mail.gmail.com>
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Nov 2019 at 23:02, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> imo all bpf attach api-s that are not FD-based are fragile and error prone
> operationally. We've seen people adding a ton of TC ingress progs because of
> bugs. Then there were issues with roolet being removed due to bugs. The issues
> with overriding wrong entries in prog_array. When multiple teams working on
> common infra having globally visible and unprotected state is dangerous. imo
> XDP and TC have to move to FD based api. When application holds the 'link fd'
> that attached program will not be detached by anything else accidentally.
> The operation 'attach rootlet XDP prog to netdev eth0' should return FD.
> While that FD is held by application (or pinned in bpffs) nothing should be
> able to override XDP prog on that eth0. We don't have such api yet, but I think
> it's necessary.

Ok, I wasn't aware you're planning this. Having a separate fd for the
link resolves
my concerns, since now the lifetime of the program and the link are independent.

Re: the rootlet example, the API would be load (with attach_prog_fd) followed by
override / attach (without arguments?) which then returns a "link fd"?

> Same thing with replacing rootlet's placeholder subprogram with
> fw1. When fw1's application links fw1 prog into rootlet nothing should be able
> to break that attachment. But if fw1 application crashes that fw1 prog will be
> auto-detached from rootlet. The admin can ssh into the box and kill fw1. The
> packets will flow into rootlet and will flow into dummy placeholder. No
> cleanups to worry about.

Nice!

> > I'd much prefer if the API didn't require attach_prog_fd and id at
> > load time, and
> > rather have an explicit replace_sub_prog(prog_fd, btf_id, sub_prog_fd).
>
> The verifier has to see the target prog and its full BTF at load time. The
> fentry prog needs target prog's BTF. XDP replacement prog needs target prog's
> BTF too. So prog_fd+btf_id has to be passed at load time. I think
> tgt_prog->refcnt++ should be done at load time too. The ugly alternative would
> be to do tgt_prog->refcnt++ before verification. Then after verification
> duplicate tgt_prog BTF, store it somewhere, and do tgr_prog->refcnt--. Then
> later during attach/replace compare saved BTF with tgt_prog's BTF. That's imo a
> ton of unncessary work for the kernel.

I've not looked at the fentry patch set, so I don't understand the
technical reasons why
having prog_fd at load time is necessary, I'm just not a fan of the
implied UAPI.
I'll take a look, hopefully I'll understand the trade off better afterwards.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
