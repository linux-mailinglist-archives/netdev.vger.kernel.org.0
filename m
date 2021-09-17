Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD05840FFAB
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 21:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240863AbhIQTMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 15:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhIQTMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 15:12:08 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B8FC061574;
        Fri, 17 Sep 2021 12:10:45 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f21so6821156plb.4;
        Fri, 17 Sep 2021 12:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HwxK+YqpENHgGuG8yym74+S0PpE2xFj7pJ0EzdVBFpg=;
        b=jNmO9Irag4pFM754+7+B7oCXxJClQEQ3frW0A/V320C1kVXJOmR4JaRoDlGmpTCP/d
         4o0eajanihDKjW3a0NpGtLfjZDMmBM6OxV6OAC1nhtyCGJOM2rSAJeXLwYyEV8c2nBHS
         0hKk3vX7Ba8zHDz8NJqx/NTLu2YuW2xTyiDwVbXvKq2+8O/KRqCjEeQLC6jFkTJIu8jq
         9TcbMU0UZLziLvqcnH9Y1WcsTRbqmd/ThQNsBT4AT7bYFULQtrAcY+l5ttQRfaHIAzS6
         Rn+KuiMDkjAzLmmt5WKjdFa0w7gwyIYBcKSSQ6IkUoZUMVORuJPJKf/yC0NH7v98i2E1
         DfcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HwxK+YqpENHgGuG8yym74+S0PpE2xFj7pJ0EzdVBFpg=;
        b=6nULEpGCdysyZwztbmd8erXvZAG8lTeDaP9tUDuMVIvg2TbdB7CTPXrVvwyOAPm5lW
         o6D2Qm/me4Yo7RCXbvGBJoX54Hqb4qi7RJK1oE5ef0BAF79w4JyY3e/olVvYf9YwIhH3
         KE2MCwhVkYXZhfwFI5FEAUwyPn++DfqOV5kJGtdHd/Y1VHzbzvsyCUYI6A5uvx7Cr8dr
         2h68AhOVxiZJDTIuMhVAW/6lFpBVRGDJ3+gzTmenfYfFR1LDbjT1PQ3j/to/aZCvpRH+
         WGt6eIn9xc95Dwm5wGg0MdXbpK+Rq3aYvDb5QYpj6RKMbLQwzKOtXEblFM7tmVLDJ1T2
         KVqw==
X-Gm-Message-State: AOAM533fSM6s2cnv593I5PXeVxjDLMyZW+7WWehfK2iFFBxGgp8Ge2Yq
        b2to09Q+ysnNE0dDSC57StEr78q8R0jTAXT2EA8=
X-Google-Smtp-Source: ABdhPJyAyQ2HEe3XdZOaYH1l8wMv3p+rdnXtCU8E7RKhvcvW8uMFEmAXi2trAW1yUaZRzMJbovwZFys2YE97N2rFxPc=
X-Received: by 2002:a17:902:7246:b0:138:a6ed:66cc with SMTP id
 c6-20020a170902724600b00138a6ed66ccmr11140819pll.22.1631905845177; Fri, 17
 Sep 2021 12:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631289870.git.lorenzo@kernel.org> <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YUSrWiWh57Ys7UdB@lore-desk> <20210917113310.4be9b586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQL15NAqbswXedF0r2om8SOiMQE80OSjbyCA56s-B4y8zA@mail.gmail.com> <20210917120053.1ec617c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210917120053.1ec617c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 17 Sep 2021 12:10:34 -0700
Message-ID: <CAADnVQKbrkOxfNoixUx-RLJEWULJLyhqjZ=M_X2cFG_APwNyCg@mail.gmail.com>
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

On Fri, Sep 17, 2021 at 12:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 17 Sep 2021 11:43:07 -0700 Alexei Starovoitov wrote:
> > > If bpf_xdp_load_bytes() / bpf_xdp_store_bytes() works for most we
> > > can start with that. In all honesty I don't know what the exact
> > > use cases for looking at data are, either. I'm primarily worried
> > > about exposing the kernel internals too early.
> >
> > I don't mind the xdp equivalent of skb_load_bytes,
> > but skb_header_pointer() idea is superior.
> > When we did xdp with data/data_end there was no refine_retval_range
> > concept in the verifier (iirc or we just missed that opportunity).
> > We'd need something more advanced: a pointer with valid range
> > refined by input argument 'len' or NULL.
> > The verifier doesn't have such thing yet, but it fits as a combination of
> > value_or_null plus refine_retval_range.
> > The bpf_xdp_header_pointer() and bpf_skb_header_pointer()
> > would probably simplify bpf programs as well.
> > There would be no need to deal with data/data_end.
>
> What are your thoughts on inlining? Can we inline the common case
> of the header being in the "head"? Otherwise data/end comparisons
> would be faster.

Yeah. It can be inlined by the verifier.
It would still look like a call from bpf prog pov with llvm doing spill/fill
of scratched regs, but it's minor.

Also we can use the same bpf_header_pointer(ctx, ...)
helper for both xdp and skb program types. They will have different
implementation underneath, but this might make possible writing bpf
programs that could work in both xdp and skb context.
I believe cilium has fancy macros to achieve that.
