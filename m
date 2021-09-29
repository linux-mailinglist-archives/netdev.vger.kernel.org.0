Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099F941C2C8
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245492AbhI2Ki2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbhI2Ki1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 06:38:27 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5203AC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 03:36:46 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id x27so8794707lfu.5
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 03:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s2A4qwjh+QojRnqmcrRre03GZr1DktVMBNuyT6iezio=;
        b=QrgxYbNQqBNj7SMCbrmgDnmmr0SjBxocttOZGS9jBuRh2pWeplHJg3LYoePSaNxF8C
         f8D0FDfu1ejrZgAMg05KPVCaLZC8IorzoWvLjupKAsZrA4Y0PxdoLLzMxEDY0uTkY0B7
         JrWCoPxMM7qQfXsiR9ZpSsx9/l87bKjZ/Y+wo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s2A4qwjh+QojRnqmcrRre03GZr1DktVMBNuyT6iezio=;
        b=48ulUlgIQx+O0aJm2Jt6N3hQjI27KR2oURqrsOHAcv0Xpf7ACycqBN3q/x2CzX3BSx
         PV6OFDckCGwfAQ2bZjLDbs2H4IwNSEtJcrwH2EttagdGYGhv9qgoaZmBftg20qlL3Muy
         c8eQXEMs61YTqNENljDMRejdqUvkjC3AJtJsr24jaZZW3D9d3Mp7wM7Vcc/uSnU+NYGf
         FXXvLaCLbLX321pMmKmu537NWa/FwReXLApVNAqJHNpY7ok/mK3ssS6EHMzcfcDRHrEt
         NR2Y8gBam9nQyp9gx1O5hsojn9TmuGqFFOorYSMt7XgRzKkymScWi71b3+rzPWxRr2ef
         2T0g==
X-Gm-Message-State: AOAM5314ovweOxgWQCQ5hZ5wiMcSLpmjPF+uj/K8BMcYTDRaNpoI8LWu
        iJnUADyIEno9Qp2XicJXX4bfpNHJu+vsmFx4pvmMHA==
X-Google-Smtp-Source: ABdhPJxql/qhwYn/BflH6DvfLF8pMO/RfC3D+I8b5Qedz2H49FALz075R16Gutht1J4qa5xvIpbbH3RiOlh0SkmxuFM=
X-Received: by 2002:a2e:5344:: with SMTP id t4mr5073201ljd.212.1632911804601;
 Wed, 29 Sep 2021 03:36:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631289870.git.lorenzo@kernel.org> <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YUSrWiWh57Ys7UdB@lore-desk> <20210917113310.4be9b586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQL15NAqbswXedF0r2om8SOiMQE80OSjbyCA56s-B4y8zA@mail.gmail.com>
 <20210917120053.1ec617c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQKbrkOxfNoixUx-RLJEWULJLyhqjZ=M_X2cFG_APwNyCg@mail.gmail.com>
 <614511bc3408b_8d5120862@john-XPS-13-9370.notmuch> <8735q25ccg.fsf@toke.dk>
 <20210920110216.4c54c9a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87lf3r3qrn.fsf@toke.dk> <20210920142542.7b451b78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87ilyu50kl.fsf@toke.dk>
In-Reply-To: <87ilyu50kl.fsf@toke.dk>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 29 Sep 2021 11:36:33 +0100
Message-ID: <CACAyw98tVmuRbMr5RpPY_0GmU_bQAH+d9=UoEx3u5g+nGSwfYQ@mail.gmail.com>
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

On Mon, 20 Sept 2021 at 23:46, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
> > The draft API was:
> >
> > void *xdp_mb_pointer_flush(struct xdp_buff *xdp_md, u32 flags,
> >                            u32 offset, u32 len, void *stack_buf)
> >
> > Which does not take the ptr returned by header_pointer(), but that's
> > easy to add (well, easy other than the fact it'd be the 6th arg).
>
> I guess we could play some trickery with stuffing offset/len/flags into
> one or two u64s to save an argument or two?

Adding another pointer arg seems really hard to explain as an API.
What happens if I pass the "wrong" ptr? What happens if I pass NULL?

How about this: instead of taking stack_ptr, take the return value
from header_pointer as an argument. Then use the already existing
(right ;P) inlining to do the following:

   if (md->ptr + args->off !=3D ret_ptr)
     __pointer_flush(...)

This means that __pointer_flush has to deal with aliased memory
though, so it would always have to memmove. Probably OK for the "slow"
path?

Lorenz

--=20
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
