Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831EC319A16
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 08:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhBLHDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 02:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhBLHD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 02:03:26 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36647C061574;
        Thu, 11 Feb 2021 23:02:46 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id z6so5283844pfq.0;
        Thu, 11 Feb 2021 23:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cqb8crGhVkKzzGd941c2UaiHlVzZ3rTlX5jrMS/aJgo=;
        b=Mmvux/2EdFH6qYmNFzk90U9/P+n0RXArvrKEqnDJ59bHVS+fshV1bCImY21WtGr+2s
         KUo0mVfbd/FtnpjPA9f+5bd5L1A0G6m3/Yr3jho6alhvDt5wcnnW2rwWsqGXZmXF9RdU
         g9HnVD24xZbGYpBtk4xx8jDO34zS+dOSay5ME2ImLqvKPhYkXzgt274rTiafPBH9npC6
         uFoQ/GLclU/dBUfzZtXnPD3y/5JTqXs9MYBZo9EXlFlzeKpnRpbvlLgG0Q1G+3ffhMyR
         qUjbi2n9IKbNVG6ai5dWCBYf0yii9T63uY42EP7l2uy5FT4cSeQhxciyzHRRR3eo29VO
         wTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cqb8crGhVkKzzGd941c2UaiHlVzZ3rTlX5jrMS/aJgo=;
        b=t8HtQIGIuM62DucuUbg/k8No/kN++/mMPpk4tob87gN2oT3aXssYyOmKospuyWjmr+
         M0SQ1TOV+E1vJjn2K5KWItiixqVSs3XQEPbAoadNBmm6l6igz6fJjI/WCC8U6CjjNrpf
         I3hnX3TdgQfsdHAOe/CaiaIJ0V2MUtFY1yhLM4uAli3vMdhi08DKb/C0I5PPwcuwP+aV
         YOVb1PILzoossrlB3rDk7KREe+XUlPrQKC/GX3P5mT8ZmkMl2vsBggIyy4As9LGF6qnW
         6aGiEG9IO39rZt5nEJNuCJwm0xhF/HXu/i8aDLq0jE6F3FrYkbvZCR9lYqx4Oh66iARw
         cfYw==
X-Gm-Message-State: AOAM531+JvPrwIxXu/9zrGVT+8hQaI+xgKgO5BY+2+53Y3rtHgGYfhde
        0/G782oKGKkaTQfZ3BHxL++mLFwYsdFJp1d8Tas=
X-Google-Smtp-Source: ABdhPJw0vhaXQf/Vz7m7Mz+KLK/CwAl85SZ7BaTFRUDDQ3jUrlBEe8DZi2ms7wjBYCv1O9cD3gDQQ9v3EAeaaDR6pDo=
X-Received: by 2002:a63:2e01:: with SMTP id u1mr1881382pgu.408.1613113365774;
 Thu, 11 Feb 2021 23:02:45 -0800 (PST)
MIME-Version: 1.0
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201209125223.49096d50@carbon> <e1573338-17c0-48f4-b4cd-28eeb7ce699a@gmail.com>
 <1e5e044c8382a68a8a547a1892b48fb21d53dbb9.camel@kernel.org>
 <cb6b6f50-7cf1-6519-a87a-6b0750c24029@gmail.com> <f4eb614ac91ee7623d13ea77ff3c005f678c512b.camel@kernel.org>
 <d5be0627-6a11-9c1f-8507-cc1a1421dade@gmail.com> <6f8c23d4ac60525830399754b4891c12943b63ac.camel@kernel.org>
 <CAAOQfrHN1-oHmbOksDv-BKWv4gDF2zHZ5dTew6R_QTh6s_1abg@mail.gmail.com>
 <87h7mvsr0e.fsf@toke.dk> <CAAOQfrHA+-BsikeQzXYcK_32BZMbm54x5p5YhAiBj==uaZvG1w@mail.gmail.com>
 <87bld2smi9.fsf@toke.dk> <20210202113456.30cfe21e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAOQfrGqcsn3wu5oxzHYxtE8iK3=gFdTka5HSh5Fe9Hc6HWRWA@mail.gmail.com>
 <20210203090232.4a259958@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <874kikry66.fsf@toke.dk> <20210210103135.38921f85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87czx7r0w8.fsf@toke.dk> <20210211172603.17d6a8f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQJ_juVMxSKUvHBEsLNQoJ4mvkqyAV8XF4mmz-dO8saUzQ@mail.gmail.com>
In-Reply-To: <CAADnVQJ_juVMxSKUvHBEsLNQoJ4mvkqyAV8XF4mmz-dO8saUzQ@mail.gmail.com>
From:   Marek Majtyka <alardam@gmail.com>
Date:   Fri, 12 Feb 2021 08:02:34 +0100
Message-ID: <CAAOQfrHeqKMhZbJoHrdtOtekucuO7K4ASMwT=fS3WTx1XyhjTA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 3:05 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Feb 11, 2021 at 5:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Perhaps I had seen one too many vendor incompatibility to trust that
> > adding a driver API without a validation suite will result in something
> > usable in production settings.
>
> I agree with Jakub. I don't see how extra ethtool reporting will help.
> Anyone who wants to know whether eth0 supports XDP_REDIRECT can already do so:
> ethtool -S eth0 | grep xdp_redirect

Doing things right can never be treated as an addition. It is the
other way around. Option -S is for statistics and additionally it can
show something (AFAIR there wasn't such counter xdp_redirect, it must
be something new, thanks for the info). But  nevertheless it cannot
cover all needs IMO.

Some questions worth to consider:
Is this extra reporting function of statistics clearly documented in
ethtool? Is this going to be clearly documented? Would it be easier
for users/admins to find it?
What about zero copy? Can it be available via statistics, too?
What about drivers XDP transmit locking flag (latest request from Jesper)?






>
> I think converging on the same stat names across the drivers will make
> the whole thing much more user friendly than new apis.
