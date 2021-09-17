Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3CC40FF92
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 20:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245610AbhIQSom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 14:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245407AbhIQSol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 14:44:41 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10852C061574;
        Fri, 17 Sep 2021 11:43:19 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y8so9996238pfa.7;
        Fri, 17 Sep 2021 11:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y/Lis8qy+ZwqCePhYjvN8JfjZghLWbTSnICeGNaq4RY=;
        b=Av/x3Un31X7KgeIn9kwB2Qi2nDbxmJswvxFq8EuqOIZ5wGAASHd08HGxBr9GOUWY73
         SG2R0qCBLzMJ1WL9+J6RFQrwsoHvuG0N/lj40029i+77BRT58JkIiUzXluzu3Zw+Akht
         6ftA+HTF4yGNfSVzrjNsPVYOW+OGJljmbarRxbyuxSF0mFYVX0M5qNIb2cWuRWOmuvn2
         HmX2I6dsTX/S6Q8nX3yQZz5pOCTsdZtfSFrb5oZ/MIQ6fKIfCHeV731dVeQPJdmCcJD5
         BeWs16HGaJumYsIbz44fDzV189Z9K2UM99+SY0wMkKZy/Z+BWFjkdUNfeDkhJZpuALIe
         60xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y/Lis8qy+ZwqCePhYjvN8JfjZghLWbTSnICeGNaq4RY=;
        b=c4syAWeXLZnDBkF0eASv5/QvsYR+++iAx6kuFqaSUgJcoF2ILBKFDkFrfe+A/uovPE
         YR0binaSCgrNYrjshhFfyDXdzBJ+bYFv8HldUzoRL+0AxA1Uh88/gItpI/ADo3B7h0Kj
         VvJ+rgFD7xaUSqhc0+2jY1zdarjHZNJj5tF1C86Sw3IwInq68BVc3um0D3LiplLQf84J
         o85BRTRfxI0AMTJruYvSqw5q0LL9ll//RykT9vFYlX9b8nkD5sG28F5uxb1sfWcGfD5S
         C69phMaDtY9V/H1bDI53yFtOURJZZC9zTfbh/nnLvg5DWRgbwBgBskDPKCZqq1wj52R0
         B9ww==
X-Gm-Message-State: AOAM5333oNg2yVx8Z+IlYTwEAl5oqEgLRzWZz54Ior4HsBDAo6isUSQj
        gtYIy17e8kYX7kDQ/ogO3PNp15uwdLvxJNIa9r8=
X-Google-Smtp-Source: ABdhPJyotYdqzvoFKPOahqSKJrrHg6SAY3JttyGYcd2Gqt8CUpu/yzfOxHcMIQvaSyeCqCIR3Qnb5RcqtRchBSWGLdM=
X-Received: by 2002:a65:4008:: with SMTP id f8mr10839472pgp.310.1631904198479;
 Fri, 17 Sep 2021 11:43:18 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631289870.git.lorenzo@kernel.org> <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YUSrWiWh57Ys7UdB@lore-desk> <20210917113310.4be9b586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210917113310.4be9b586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 17 Sep 2021 11:43:07 -0700
Message-ID: <CAADnVQL15NAqbswXedF0r2om8SOiMQE80OSjbyCA56s-B4y8zA@mail.gmail.com>
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 11:33 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> > >
> > > Alternatively how about we produce a variation on skb_header_pointer()
> > > (use on-stack buffer or direct access if the entire region is in one
> > > frag).
>
> If bpf_xdp_load_bytes() / bpf_xdp_store_bytes() works for most we
> can start with that. In all honesty I don't know what the exact
> use cases for looking at data are, either. I'm primarily worried
> about exposing the kernel internals too early.

I don't mind the xdp equivalent of skb_load_bytes,
but skb_header_pointer() idea is superior.
When we did xdp with data/data_end there was no refine_retval_range
concept in the verifier (iirc or we just missed that opportunity).
We'd need something more advanced: a pointer with valid range
refined by input argument 'len' or NULL.
The verifier doesn't have such thing yet, but it fits as a combination of
value_or_null plus refine_retval_range.
The bpf_xdp_header_pointer() and bpf_skb_header_pointer()
would probably simplify bpf programs as well.
There would be no need to deal with data/data_end.
