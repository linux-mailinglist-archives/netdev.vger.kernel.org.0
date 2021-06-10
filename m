Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8542E3A2349
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 06:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhFJEWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 00:22:32 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]:37448 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhFJEWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 00:22:30 -0400
Received: by mail-lj1-f181.google.com with SMTP id e2so2846783ljk.4
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 21:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xCCqNcorR12ukb/98Vie1vFnCCh1Sn+2GgiJeyNXKDY=;
        b=HZE6j4nbgRmTT4fCGqOBLKrWlugVWCskABt/hGVD5KbZH8rvkQ5av7u3McR0QFtOB5
         hWUpUPyj518f4kPeAEcTOVqYcKorXYRLRiWsSc2bUwvi4pYU/Gl2WyCeUecgPBmWXDtO
         hxVQI/K7zBWpdygjCpwBJmYHCdfVfC3DIckZzwvmY39Sco5WUTPWJhtFds+R8mXp+KxQ
         c7WSQ8avsVHCV3cdOn5DbJlp5zJaLCVnJM244yGJj0gkEQ7PIP1uWZQWOMII9K1eE8oa
         L9/cay1M6nwNpJA0uYYbH1+ud/1Fzx+tp9fu/AcUJU/Z/0wZcdNonXRA6Ub+UUy2wneK
         Bdig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xCCqNcorR12ukb/98Vie1vFnCCh1Sn+2GgiJeyNXKDY=;
        b=QaFeTTK4cFLqtDg2981SBX9elVQ1NrIlN2jI6Ol/doywoYpsVzujnpvdmadL1LDRVZ
         YU8Z88eorbEc+N6PGDi5MIwn1obRUDyDyHx+QCRFikR2Pheo5bzJKjlh/19UzxRSs5IX
         XTBOq7ABD0sCvfY+pnvbqQMD0KZAQkapHqL28Z6V9SE5xWt4k8+BBogauqIXH+PiJvNB
         uu9oXbayEsTbg58gg2Htu3ZNqwxFT/goU24dg0QFNF3FkfGMJWls7n7cXdqJZMfH+HVK
         q+S54TWyZfGWiGUxLi1rDD8gPtdUdKOXOgghbCxZAfu/1WUD0q9ojiZgMU/2CpaeLCp/
         KQaQ==
X-Gm-Message-State: AOAM533bUt2SsQ8nBCVXUHr33a1PDlIMqcgeY1L1C9ZjWgsrMcQKjXkE
        gkjhYRMRfQzgm1YnQAA/feJXJtu8XBTSGqu7XZA=
X-Google-Smtp-Source: ABdhPJyHTjRvjoBb6/HEndJMUQaRDIkUfrj9n93MBE2NzZJcuIZ0RUmU/WvZxR4TRnLXGL0JHAFbqlenao4pRcLKC40=
X-Received: by 2002:a2e:8153:: with SMTP id t19mr675565ljg.236.1623298762309;
 Wed, 09 Jun 2021 21:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
 <20210608170224.1138264-3-tannerlove.kernel@gmail.com> <17315e5a-ee1c-489c-a6bf-0fa26371d710@redhat.com>
 <CA+FuTSfvdHBLOqAAU=vPmqnUxhp_b61Cixm=0cd7uh_KsJZGGw@mail.gmail.com>
 <51d301ee-8856-daa4-62bd-10d3d53a3c26@redhat.com> <CAADnVQKHpk5aXA-MiuHyvBC7ZCxDPmN_gKAVww8kQAjoZkkmjA@mail.gmail.com>
 <6ae4f189-a3be-075d-167c-2ad3f8d7d975@redhat.com>
In-Reply-To: <6ae4f189-a3be-075d-167c-2ad3f8d7d975@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 9 Jun 2021 21:19:11 -0700
Message-ID: <CAADnVQL_+oKjH341ccC_--ing6dviAPwWRocgYrTKidkKo-NcA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Jason Wang <jasowang@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Tanner Love <tannerlove.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Tanner Love <tannerlove@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 9:13 PM Jason Wang <jasowang@redhat.com> wrote:
>
> So I wonder why not simply use helpers to access the vnet header like
> how tcp-bpf access the tcp header?

Short answer - speed.
tcp-bpf accesses all uapi and non-uapi structs directly.
