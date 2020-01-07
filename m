Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D95C8131FE1
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 07:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgAGGjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 01:39:22 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43994 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgAGGjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 01:39:22 -0500
Received: by mail-lf1-f68.google.com with SMTP id 9so38060326lfq.10;
        Mon, 06 Jan 2020 22:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SB8O/5JIMzYKiSuEZZhJIz1BTBaOY4SFu2N4rg13oQw=;
        b=rSTuzj7r+Cfs1/Wvl40AY39m7ODXOwes5dphdCGuNtzSMVxkCIjozPNhi+QtLMja4F
         Svcmc86MaR0XOjVCWWgYHlXzkUKj+FqslOPiM0q0Op3aOM1QbrIL/E8LKlzcxaNoBBFH
         nk+HOAP82/ETwqNc/RHhxeRrs8oeEjkRPhwsNSqobliN8IbXPenAvwHkA7IkbqEKpn9W
         FYva/rgdcIZuWtn0b5DcUJXueOyp9vYqoFJQXGh+uBf1dBiu76prSgQv41zVcakrV0IT
         asghGM+Bw6KRNOZnifh37TMyJd1japsgTddWLZ/4PY4Bm2ibcQ5aWe9qAdFn9tyZe359
         oa+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SB8O/5JIMzYKiSuEZZhJIz1BTBaOY4SFu2N4rg13oQw=;
        b=cfxcy0sPxDqXJKATBn+xxV6agi+VVmjIRYLKJ8GOFCUWtvjJOyaA3qj1TTNxLjV25s
         e/SaSmaeSAcmIGmu/A6183z3eM/uj5G1b1To2VW8zPhddCFcvpkv5yv2s6J+7Po8K3G9
         X7mPhNxs0yjAhybgaN4YViP7DhCNYR36FJmwFO79BycxrQUd2Vvl+oem8BiPjRdRQ7K/
         r13XPvVfxxGNwCAfNg5HfffhmKg85U7/XvFw/d4l7PBzg8f6/3XMO6VhrHd4p478V/rb
         mim9aZ/no4sgo0ldZ3ydyftL0Wq568mPlLeCMSIniysEvrWDWCDCBCXmVt1vdshvpyBV
         yZFw==
X-Gm-Message-State: APjAAAUmL0Thr4q5BUW/sWh0ch9O+d854o6M1oHIF5dhdRFWF87ALVNA
        qXoBACIH9UzCHHqJcenXX1LCBDvhnSoOSQwCxJw=
X-Google-Smtp-Source: APXvYqy0lJXQV/MFyNa8/f6IaFQpoBMXBPmOnZmlJZ17/dmbIJbjTf10vbzRwRN3lBuqRkZpk7hYfpS2Vsy0oLYUrgI=
X-Received: by 2002:ac2:51a4:: with SMTP id f4mr62079590lfk.76.1578379159255;
 Mon, 06 Jan 2020 22:39:19 -0800 (PST)
MIME-Version: 1.0
References: <20191211223344.165549-1-brianvv@google.com> <20191211223344.165549-6-brianvv@google.com>
 <ba15746b-2cd8-5a04-08fa-3c85b94db15b@fb.com>
In-Reply-To: <ba15746b-2cd8-5a04-08fa-3c85b94db15b@fb.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Tue, 7 Jan 2020 00:39:07 -0600
Message-ID: <CABCgpaUHEWg6nwEEy47rF=aeK0AtNpAp3+pJVnObZU87FuUMgw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 05/11] bpf: add generic_batch_ops to lpm_trie map
To:     Yonghong Song <yhs@fb.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yonghong, thanks for reviewing it and sorry for the late reply I
had been traveling.

On Fri, Dec 13, 2019 at 11:46 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/11/19 2:33 PM, Brian Vazquez wrote:
> > This adds the generic batch ops functionality to bpf lpm_trie.
> >
> > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > ---
> >   kernel/bpf/lpm_trie.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
> > index 56e6c75d354d9..92c47b4f03337 100644
> > --- a/kernel/bpf/lpm_trie.c
> > +++ b/kernel/bpf/lpm_trie.c
> > @@ -743,4 +743,8 @@ const struct bpf_map_ops trie_map_ops = {
> >       .map_update_elem = trie_update_elem,
> >       .map_delete_elem = trie_delete_elem,
> >       .map_check_btf = trie_check_btf,
> > +     .map_lookup_batch = generic_map_lookup_batch,
> > +     .map_lookup_and_delete_batch = generic_map_lookup_and_delete_batch,
>
> Not 100% sure whether trie should use generic map
> lookup/lookup_and_delete or not. If the key is not available,
> the get_next_key will return the 'leftmost' node which roughly
> corresponding to the first node in the hash table.
>

I think you're right, we shouldn't use generic
lookup/lookup_and_delete for lpm_trie. That being said, would you be
ok, if we don't add lpm_trie support in this patch series? Also we can
drop the generic_map_lookup_and_delete implementation in this patch
series and add it in the future, if needed. What do you think?

> > +     .map_delete_batch = generic_map_delete_batch,
> > +     .map_update_batch = generic_map_update_batch,with efault
> >   };
> >
