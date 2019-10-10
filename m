Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF577D3079
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 20:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfJJSgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 14:36:44 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44057 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfJJSgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 14:36:44 -0400
Received: by mail-pg1-f196.google.com with SMTP id e10so213413pgd.11
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 11:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tOmO4TKHm16DClzfcXRVekZnE4Pzae9554ZSqpGnQas=;
        b=BtpcT8QFG7edZBSS1TEqho8k+vBnuo4VQDPFZGWgcN4vuj/ol7Gp/8FdJ3chxCd9qZ
         HpiGsLAIn0g8hNm4vLiUYtLeb3FTtox8k7UQCBCf5hobq2XGPn94NiyshMWAYNQlplw0
         4AR0txN5QokKV3ubtTFiqHLeaFJA+GCZVsFQmzTl3J6qpSChpD5W83GrxEePCqXgotfA
         /fCEXO/dejrky37jKe3rpGRAKFRB6cikH0GzwD7DxgLgA0uLjmPVGu3QYg5VBCarVFAm
         yrnp82ZarmVHkLNOcXhBpv/tv60bqScQPC8Nn7mckJ1G5QzGwgcfuw4nYHQddxcPDkr6
         Ljvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tOmO4TKHm16DClzfcXRVekZnE4Pzae9554ZSqpGnQas=;
        b=eWVQQ+wNirA2g4XA+Er1v1sZdAqrJavtDS2Vz6Z9BCfvTi4AtoYXUHC3hEC7BPoI2D
         QsGoJh8Mo31FHgKX2XUXtFzO1GmO6mPA/Vzu8Bkyzb19/oCTxH4iEdlAohYwqdT4WaMN
         SzOIRTtPFmFopjbA8NG/gQ1KwxBPIDvElMTUeaNuEFxz88m6OBqpQkA8nkxk/WCjQxbx
         TJuMbz26OlWUjIbyV2T/9kxggqJzlo6zmEbJHSRG+SeLOBy9qg3wQTqE/MZW0RDSXwDX
         RVDLsoLFK6AOJmz3F09Gtzsb8RsTW7cA8b4y6VMfDXf9DTNNWszvs48rylGcwvL0OwNU
         /zdw==
X-Gm-Message-State: APjAAAVkVLEskuSdQDA7MLyXK/I+o+TAC6X6Vqf9Lebd2OmyusFjF1aD
        eCtazf6J+CTpg/Oo9IOmQhZKHFHslgUAKuptxwc=
X-Google-Smtp-Source: APXvYqycXXRjEIa7e2H98e2EQdP1WTKogNoYfo0eroBKMQfyLACFYUysZP6LoblIIshNQ3bZqfrqHVpkiWrP50GlkSA=
X-Received: by 2002:a62:28b:: with SMTP id 133mr11802787pfc.242.1570732601725;
 Thu, 10 Oct 2019 11:36:41 -0700 (PDT)
MIME-Version: 1.0
References: <20191008053507.252202-1-zenczykowski@gmail.com>
 <20191008053507.252202-2-zenczykowski@gmail.com> <20191008060414.GB25052@breakpoint.cc>
 <CAHo-OowyjPdV-WbnDVqE4dJrHQUcT2q7JYfayVDZ9hhBoxY4DQ@mail.gmail.com> <CAHo-Ooy=UC9pEQ8xGuJO+8-c0ZaBYind3mo7UHEz1Oo387hyww@mail.gmail.com>
In-Reply-To: <CAHo-Ooy=UC9pEQ8xGuJO+8-c0ZaBYind3mo7UHEz1Oo387hyww@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 10 Oct 2019 11:36:30 -0700
Message-ID: <CAM_iQpV7D73p7k=806u+2vxiDDK-ecFuW5Rbk6j_BDO0K-FEGg@mail.gmail.com>
Subject: Re: [PATCH 2/2] netfilter: revert "conntrack: silent a memory leak warning"
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 12:10 AM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> Here's my reasoning:
>
>         old =3D ct->ext;
>
>         //... stuff that doesn't change old.
>
>         alloc =3D max(newlen, NF_CT_EXT_PREALLOC);  <-- will be >=3D 128,
> so not zero
>         kmemleak_not_leak(old);
>         new =3D __krealloc(old, alloc, gfp);
>         if (!new)
>                 return NULL;  <--- if we return here, ct->ext still
> holds old, so no leak.
>
>         if (!old) {
>                 memset(new->offset, 0, sizeof(new->offset));
>                 ct->ext =3D new;  <--- old is NULL so can't leak
>         } else if (new !=3D old) {
>                 kfree_rcu(old, rcu);  <-- we free old, so doesn't leak
>                 rcu_assign_pointer(ct->ext, new);
>         } <--- else new =3D=3D old && it's still in ct->ext, so it doesn'=
t leak
>

So you conclude as it is not leak too? Then what are you trying to
fix?

I am becoming more confused after this. :-/

> Basically AFAICT our use of __krealloc() is exactly like krealloc()
> except instead of kfree() we do kfree_rcu().
>
> And thus I don't understand the need for kmemleak_not_leak(old).

kfree_rcu() is a callback deferred after a grace period, so if we
allocate the memory again before that callback, it is reported to
kmemleak as a memory leak unless we mark it as not, right?

Or kfree_rcu() works nicely with kmemleak which I am not aware
of?

Thanks.
