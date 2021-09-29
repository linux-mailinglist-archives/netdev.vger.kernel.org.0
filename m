Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2726141C4CC
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343818AbhI2MeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343735AbhI2MeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 08:34:09 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17849C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 05:32:28 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id g41so10179627lfv.1
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 05:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ndDKb4ocgk1iK0hmC5H/ny854jlbnAfasAKNdkETtL4=;
        b=KfftChFrLOLM8wlW4kmiNVvAoNKl9qqCwKqwfT+RP5bRXl5T4baBvHKk9efzO7vYVk
         +E8KRD40L/mPbLJpZdb71SUDKqd41phKxet34zq+q7xjoIONjnad5clcGUD/cPR9rwdr
         jiEaiQAvaZJzPyNvLU7aTFix7ixi4oJk3eJTQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ndDKb4ocgk1iK0hmC5H/ny854jlbnAfasAKNdkETtL4=;
        b=HbKjxE95TEcZQcfv2rwMkOjoNjQyLgylq+kD6TLH/vRLrkKfdcYtz1D2Fx0e2+sXNe
         XmWmtBD/zI7pigYnTbxhgb+EhJcrU4oAI2ZMCQeiZ7JsKLEP/6sgPwa+M9k+pFUrh4zA
         QC3/zSdgzt9rRX+SmNe5+AqewwEcpG4Pc/WtFSLwv5G+dZI+RjFdx1T+2Jt9OQxgLdXG
         H7VrlnzBjImcHL+yd/Nty/dNl260ixLKXeA22PmaNk0wRwm8ySAPf+p5VtjUQc60MAqt
         Xz8Yt/X1KK2D3fpDsn9NatsviQXCDZ3JXlnQCcw25HbNg7OuzSjV3quw79CEgH8fwaD7
         1P/Q==
X-Gm-Message-State: AOAM53089xl+rWE4QicIwfvh4+j91j2S3krNxBLOWUkZaqJZ+VxN+MRY
        6OoiK+qQKalCJDcx6jaeLHLakWBakfD9U9bjT46zsw==
X-Google-Smtp-Source: ABdhPJyhIkFlhqEH6hUVdyzJzolTdBw/zS6TUI63McPfkMK8YRiz5FojUSAdpY25pMgcHh3nmcANAnV7mQAcpjsbBjk=
X-Received: by 2002:ac2:4c45:: with SMTP id o5mr11382759lfk.620.1632918746426;
 Wed, 29 Sep 2021 05:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631289870.git.lorenzo@kernel.org> <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YUSrWiWh57Ys7UdB@lore-desk> <20210917113310.4be9b586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQL15NAqbswXedF0r2om8SOiMQE80OSjbyCA56s-B4y8zA@mail.gmail.com>
 <20210917120053.1ec617c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQKbrkOxfNoixUx-RLJEWULJLyhqjZ=M_X2cFG_APwNyCg@mail.gmail.com>
 <614511bc3408b_8d5120862@john-XPS-13-9370.notmuch> <8735q25ccg.fsf@toke.dk>
 <20210920110216.4c54c9a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87lf3r3qrn.fsf@toke.dk> <20210920142542.7b451b78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87ilyu50kl.fsf@toke.dk> <CACAyw98tVmuRbMr5RpPY_0GmU_bQAH+d9=UoEx3u5g+nGSwfYQ@mail.gmail.com>
 <87sfxnin6i.fsf@toke.dk>
In-Reply-To: <87sfxnin6i.fsf@toke.dk>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 29 Sep 2021 13:32:15 +0100
Message-ID: <CACAyw9-Ni4UaZuUOJHpO2xm2y6Dwtcn98gWsYW1ShmQg-W8TxQ@mail.gmail.com>
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer support
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sept 2021 at 13:25, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> > Then use the already existing (right ;P) inlining to do the following:
> >
> >    if (md->ptr + args->off !=3D ret_ptr)
> >      __pointer_flush(...)
>
> The inlining is orthogonal, though, right? The helper can do this check
> whether or not it's a proper CALL or not (although obviously for
> performance reasons we do want it to inline, at least eventually). In
> particular, I believe we can make progress on this patch series without
> working out the inlining :)

Yes, I was just worried that your answer would be "it's too expensive" ;)

> > This means that __pointer_flush has to deal with aliased memory
> > though, so it would always have to memmove. Probably OK for the "slow"
> > path?
>
> Erm, not sure what you mean here? Yeah, flushing is going to take longer
> if you ended up using the stack pointer instead of writing directly to
> the packet. That's kinda intrinsic? Or am I misunderstanding you?

I think I misunderstood your comment about memcpy to mean "want to
avoid aliased memory for perf reasons". Never mind!

--=20
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
