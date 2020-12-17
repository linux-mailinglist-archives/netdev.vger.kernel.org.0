Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E252DCCDF
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 08:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgLQHRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 02:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgLQHRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 02:17:04 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4877EC061794;
        Wed, 16 Dec 2020 23:16:24 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id m6so8729742pfm.6;
        Wed, 16 Dec 2020 23:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jThrRAJfWnIe1Jvy0RWseTH8BCbAGXHskZcNtWSoEY8=;
        b=AKZX7XiyNCqz95/QP6yKeWDHHwVJZoP4fdAFUfyWbkzd7QveokreSRF3DMN+hRaQjd
         48y8wzTtK+CA+2T9vls6u5o0/4mBZWG/pMPAOQGnf0o1SYkmcMcazaBpqlFWs/64sm1D
         i71U60FwCcCck8Zm/JGXyrHwYkVN24lXu9aPrslnjMkuQHt0wiZmatCDcQ+ON7I0TbXi
         t6LS7hIp+yXkeGrM0KUS7BdexCqELCudusIHOdvJNP3SkB02/qSb7Yil+0k1ng3H6B0q
         OIGRAotDH96wbU5CQmc+SiZAzPtF7H7oFjn+FYGA7ljFDguvOpvGlB0L/JmaSt8/fS+W
         /l1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jThrRAJfWnIe1Jvy0RWseTH8BCbAGXHskZcNtWSoEY8=;
        b=MHHPJxY1zvU7ezWqLiA40aCekBvBLQa3JZtTUgDRX7FHH46HAEJF4aKoMknSbUuycx
         mmp+19tK2su7ny3Degs+ou5Ysx1gvPhVV7sU3MUwmWRPoOKyVgVxdkMpe04ozjBVx90i
         lg1+WXVbAvTp7YkIIWIplazClZT2pDeuoeH4vRfgTFMDIRVN31NfjoBBbVbzEssxAuTp
         PULq1AcFQJVzmMx0wHVGdoxtVJGGvptHoRlI8mP6l8frLh988FnNKIJSFrisc8x8eUYh
         own5zbuvW0N3lUVvxoVqcbczkuEf0b4aNI36pLKwEnNn59I6W7IYTgqYIo2enXwKXSNL
         B8pw==
X-Gm-Message-State: AOAM533WM0VR8ZGBMcFYmsqlis2T+L5V/OBuVLYp9USCRZYpE/1r3Okd
        QVTwCYlO7IIaUFJieoLeJe0=
X-Google-Smtp-Source: ABdhPJy0IxNiaGE7N8ISAO1rCfDDsnoYF78zwU9CkOd0uY0zlGWLcOK6vLaaUfbb9uUXDPVusgH1KQ==
X-Received: by 2002:aa7:85d2:0:b029:1a2:73fe:5c28 with SMTP id z18-20020aa785d20000b02901a273fe5c28mr24083575pfn.40.1608189383768;
        Wed, 16 Dec 2020 23:16:23 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:5c8d])
        by smtp.gmail.com with ESMTPSA id o9sm4148967pjw.9.2020.12.16.23.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 23:16:22 -0800 (PST)
Date:   Wed, 16 Dec 2020 23:16:20 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: one prog multi fentry. Was: [PATCH bpf-next] libbpf: support
 module BTF for BPF_TYPE_ID_TARGET CO-RE relocation
Message-ID: <20201217071620.j3uehcshue3ug7fy@ast-mbp>
References: <20201205025140.443115-1-andrii@kernel.org>
 <alpine.LRH.2.23.451.2012071623080.3652@localhost>
 <20201208031206.26mpjdbrvqljj7vl@ast-mbp>
 <CAEf4BzaXvFQzoYXbfutVn7A9ndQc9472SCK8Gj8R_Yj7=+rTcg@mail.gmail.com>
 <alpine.LRH.2.23.451.2012082202450.25628@localhost>
 <20201208233920.qgrluwoafckvq476@ast-mbp>
 <alpine.LRH.2.23.451.2012092308240.26400@localhost>
 <8d483a31-71a4-1d8c-6fc3-603233be545b@fb.com>
 <alpine.LRH.2.23.451.2012161457030.27611@localhost>
 <CAEf4BzZ0_iGqnzqz3qAEggdTRhXkddtdYRUgs0XxibUyA_KH3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ0_iGqnzqz3qAEggdTRhXkddtdYRUgs0XxibUyA_KH3w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 02:27:23PM -0800, Andrii Nakryiko wrote:
> 
> But this seems more "verifiable" and nicer to use, even though it
> won't substituting an arbitrary btf_id and btf_obj (but that's sort of
> a goal, I think):
> 
> skb = bpf_get_btf_arg(ctx, 1, bpf_core_type_id_kernel(skb));

yep. makes sense to me.
Assuming that ctx has both:
- BTF of the func and the helper will follow to arg's BTF at run-time
  to check that it matches 3rd arg btf_id.
- and the actual arg values as well. So that helper will return them.

> > - default mode where we trace function arguments for kprobe and return value
> >   for kretprobe; that's covered by the above; and
> > - a mode where the user specifies what they want. For example running
> >
> > $ ksnoop "ip_send_skb"
> >
> > ...is an example of default mode, this will trace entry/return and print
> > arguments and return values, while
> >
> > $ ksnoop "ip_send_skb(skb)"
> >
> > ...will trace the skb argument only, and
> >
> > $ ksnoop "ip_send_skb(skb->sk)"
> >
> > ...will trace the skb->sk value.  The user-space side of the program
> > matches the function/arg name and looks up the referenced type, setting it
> > in the function's map.  For field references such as skb->sk, it also
> > records offset and whether that offset is a pointer (as is the case for
> > skb->sk) - in such cases we need to read the offset value via bpf_probe_read()
> > and use it in bpf_snprintf_btf() along with the referenced type.  Only a
> > single simple reference like the above is supported currently, but
> > multiple levels of reference could be made to work too.

Alan,

I'm not sure why the last example is so different form the first two.
I think ksnoop tool will generate the program on the fly, right?
So it can generate normal LDX insn with CO-RE relocation (instead of bpf_probe_read)
to access skb->sk. It can also add relo for that LDX to point to
struct sk_buff's btf_id defined inside prog's BTF.
The 'sk' offset inside bpf program and inside BTF can be anything: 0, 4, ...
libbpf relocation logic will find the right offset in kernel's sk_buff.
If ksnoop doesn't have an ability to parse vmlinux.h file or kernel's BTF
it can 'cheat'.
If the cmdline looks like:
$ ksnoop "ip_send_skb(skb->sk)"
It can generate BTF:
struct sk_buff {
   struct sock *sk;
};

If cmdline looks like:
$ ksnoop "ip_send_skb(skb->sock)"
It can generate BTF:
struct sk_buff {
   struct sock *sock;
};
Obviously there is no 'sock' field inside kernel's struct sk_buff, but tool
doesn't need to care. It can let libbpf do the checking and match
fields properly.

> > into that a bit more if you don't mind because I think some form of
> > user-space-specified BTF ids may be the easiest approach for more flexible
> > generic tracing that covers more than function arguments.

I think you're trying to figure out kernel's btf_ids in ksnoop tool.
I suggest to leave that job to libbpf. Generate local BTFs in ksnoop
with CO-RE relocs and let libbpf handle insn patching.
No FDs to worry about from ksnoop side either.
