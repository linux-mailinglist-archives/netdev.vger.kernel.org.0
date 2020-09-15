Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7AD26A141
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgIOIr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:47:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46057 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbgIOIrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:47:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600159666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gHqMMhcef71Vz4nIIhCc753F8Sj6cnpzNuOswe+NHDE=;
        b=E/Xa6tNAvX/bWVwb/R8Jfz6AebC/WNob/1xZBFsUGC05hj9MHjPpZ9SsXAaP3bVCaSl2jh
        UlEtI4VZcC9r4nsJ7gxSI0gI9xi7e1BXm6brsrtVJbClwysaQDclk/Cdiq5Tp6AYn01qnw
        C91TFNx5mGcKi0F0QPKyjznEJEE+eS4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-1CrF7alaPYiI4usUx9r6sQ-1; Tue, 15 Sep 2020 04:47:39 -0400
X-MC-Unique: 1CrF7alaPYiI4usUx9r6sQ-1
Received: by mail-wm1-f69.google.com with SMTP id q205so2304432wme.0
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 01:47:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gHqMMhcef71Vz4nIIhCc753F8Sj6cnpzNuOswe+NHDE=;
        b=sxUQ4jAtYpKX6+a8y0EYpdXkvFOudnKWnsf9ylZx/MBiLi3iISiRP5oKyIVQBjlCjx
         2/bRtl9Lj10TSIU5QFP/pRrRTkkMv+SUO+XB8nJt+Kj+yRNunIaJiYJOmFLjXYhASAt1
         sKyukDfOW3gzPi/nX4XkQ8eUcfPq44q/s7CcwEMz5+wZA8F6EXgOFSWFNV+6AQfsOPTy
         2GTVlnokzV3CoBab9jdebjSIM62aJyhbiXofDW2WelN1IzJGpV+TKxYufp8UflmU9Rb4
         OvwTp6rfsfTuKTuJ+/SnVgzjMGyHYPxfDBqbvYuz709A5HhXQvJKEg+s39p4xJPwtRlj
         /0HA==
X-Gm-Message-State: AOAM533gpyo3iuApBGESZnTfn5gliqiDtxpoXqKAln2IS0RW7pnce8ze
        gTzJw8SLPMKmYolxRsQPuJjX320skg54A+nWro/ruTU/OQ/3em3mc/XSf11AyEwE7cPh5wWCbSg
        yFzmy4qofC/faqtJQ
X-Received: by 2002:adf:e407:: with SMTP id g7mr20040879wrm.349.1600159657884;
        Tue, 15 Sep 2020 01:47:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbWanePA3VlARamVJW+Nyg1rmLNkw3TQwnaiY4YIqTex+hDI5pSlEWKYWWhGWrf9aw3oq7Gg==
X-Received: by 2002:adf:e407:: with SMTP id g7mr20040856wrm.349.1600159657574;
        Tue, 15 Sep 2020 01:47:37 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u66sm23666792wmg.44.2020.09.15.01.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 01:47:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 68E401829CB; Tue, 15 Sep 2020 10:47:36 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next] bpf: don't check against device MTU in
 __bpf_skb_max_len
In-Reply-To: <CANP3RGftg2-_tBc=hGGzxjGZUq9b1amb=TiKRVHSBEyXq-A5QA@mail.gmail.com>
References: <159921182827.1260200.9699352760916903781.stgit@firesoul>
 <20200904163947.20839d7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200907160757.1f249256@carbon>
 <CANP3RGfjUOoVH152VHLXL3y7mBsF+sUCqEZgGAMdeb9_r_Z-Bw@mail.gmail.com>
 <20200914160538.2bd51893@carbon>
 <CANP3RGftg2-_tBc=hGGzxjGZUq9b1amb=TiKRVHSBEyXq-A5QA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 15 Sep 2020 10:47:36 +0200
Message-ID: <87ft7jzas7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ just jumping in to answer this bit: ]

> Would you happen to know what ebpf startup overhead is?
> How big a problem is having two (or more) back to back tc programs
> instead of one?

With a jit'ed BPF program and the in-kernel dispatcher code (which
avoids indirect calls), it's quite close to a native function call.

> We're running into both verifier performance scaling problems and code
> ownership issues with large programs...
>
> [btw. I understand for XDP we could only use 1 program anyway...]

Working on that! See my talk at LPC:
https://linuxplumbersconf.org/event/7/contributions/671/

Will post a follow-up to the list once the freplace multi-attach series
lands.

-Toke

