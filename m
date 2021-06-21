Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30353AE9E6
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhFUNVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhFUNVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:21:34 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C12FC061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 06:19:20 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t3so18899508edc.7
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 06:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LOgfQgRPA5gN1jaOnTR2E2pxeJmJ5LmUsawgq+f0Irk=;
        b=YwRLW60HX33S6AYbrj1jmNdx/R0kfL1xcxjbk5/Bz7sYE03HlUzcMNenImefAwdi/M
         H3y4uAeIJnJpUkMkbXI/czW+88jijEG9XVICjSWfKSWSyUuMray3enIu5uSo4tbQ1mnB
         b68PN/OvNhrjikmWqLMNcTgKGVxQMyOqS+wmOlbr/1GfEL3ytS1SKggUbQqbhp2EQfot
         pBgsBq4wiQ90XYPxpRCWKPBd2Issd7ZVTgOWmSzifE1w8wve0gLBKTr7kwERgb3r/HkJ
         Mjn5hA2ReijGEnHyqSQ9VDXRC/++ENwI8MZ7h5mJ9WWcB0gOF9RA+QKbYsfO/hewutBr
         g3GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LOgfQgRPA5gN1jaOnTR2E2pxeJmJ5LmUsawgq+f0Irk=;
        b=Enp1Bpr+UUGq69L1dRrjKDfmQ3PNZ9TPU6o/ZYppC5uD2KpMut+i4M0eIO5NjyfDZg
         LC42zqqjqAS0rue5+KNc7eC+WJOlUog63xfi1u6uK4dhcSCcycrmkJkYNDg0CwAPMxXv
         QlCeNuvV09BzZ2eeE6X51d2V14Xg6+HqcKvMLG4oELrrwjaFOyBp9jBYajfRgcP6NTsI
         J8krSLQKivIiH47lkF9bkZ4YGhPfNAYQ8xO2iGLgUlrh232T0wEB31UT3PCNs/HCCk5/
         hEa4x0iwFiw2vWodcPXzf8dQ6l1G0rIBaw51MNTKjp9aPTQn6NrcAJ7Yf4sa4+cMObhz
         w8sQ==
X-Gm-Message-State: AOAM5300b529M7yH8GJMxhVU2BdPQcfS98sJmZfFxftIlEDfwrQmSBWq
        tnSY8Efqc5Z3/NaWwd4rG+gUCHB5kHY=
X-Google-Smtp-Source: ABdhPJz0Y/9cQWHiJzpEZK4uOlQnd7Sifu7fLP6ZHwPDEaolI0gIewnc86cobmOgmcaqWCQiKzZftA==
X-Received: by 2002:a05:6402:2913:: with SMTP id ee19mr11921739edb.361.1624281558944;
        Mon, 21 Jun 2021 06:19:18 -0700 (PDT)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id h16sm10469831edb.23.2021.06.21.06.19.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 06:19:17 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso13861906wmh.4
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 06:19:16 -0700 (PDT)
X-Received: by 2002:a1c:2456:: with SMTP id k83mr27507951wmk.87.1624281556215;
 Mon, 21 Jun 2021 06:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
 <CA+FuTSfvdHBLOqAAU=vPmqnUxhp_b61Cixm=0cd7uh_KsJZGGw@mail.gmail.com>
 <51d301ee-8856-daa4-62bd-10d3d53a3c26@redhat.com> <CAADnVQKHpk5aXA-MiuHyvBC7ZCxDPmN_gKAVww8kQAjoZkkmjA@mail.gmail.com>
 <6ae4f189-a3be-075d-167c-2ad3f8d7d975@redhat.com> <CAADnVQL_+oKjH341ccC_--ing6dviAPwWRocgYrTKidkKo-NcA@mail.gmail.com>
 <2fd24801-bf77-02e3-03f5-b5e8fac595b6@redhat.com> <CA+FuTSeuq4K=nA_JPomyZv4SkQY0cGWdEf1jftx_1Znd+=tOZw@mail.gmail.com>
 <8f2fd333-1cc6-6bcc-3e7d-144bbd5e35a3@redhat.com> <CA+FuTSdhL+BsqzRJGJD9XH2CATK5-yDE1Uts8gk8Rf_WTsQAGw@mail.gmail.com>
 <4c80aacf-d61b-823f-71fe-68634a88eaa6@redhat.com> <CA+FuTSffghgcN5Prmas395eH+PAeKiHu0N6EKv5GwvSLZ+Jm8Q@mail.gmail.com>
 <d7e2feeb-b169-8ad6-56c5-f290cdc5b312@redhat.com> <CAF=yD-J7kcXSqrXM1AcctpdBPznWeORd=z+bge+cP9KO_f=_yQ@mail.gmail.com>
 <7a63ca2a-7814-5dce-ce8b-4954326bb661@redhat.com> <CA+FuTScJtyzx4nhoSp1fb2UZ3hPj6Ac_OeV4_4Tjfp8WvUpB1g@mail.gmail.com>
 <58202b1c-945d-fc9e-3f24-2f6314d86eaa@redhat.com>
In-Reply-To: <58202b1c-945d-fc9e-3f24-2f6314d86eaa@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 21 Jun 2021 09:18:39 -0400
X-Gmail-Original-Message-ID: <CA+FuTSekbW9PG_QbA2T6tG6Go2-CGRn9gYyJWUY38Nqz6EqaoA@mail.gmail.com>
Message-ID: <CA+FuTSekbW9PG_QbA2T6tG6Go2-CGRn9gYyJWUY38Nqz6EqaoA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Jason Wang <jasowang@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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

> >> 2) use some general fields instead of virtio-net specific fields, e.g
> >> using device header instead of vnet header in the flow keys strcuture
> > Can you give an example of what would be in the device header?
> >
> > Specific for GSO, we have two sets of constants: VIRTIO_NET_HDR_GSO_..
> > and SKB_GSO_.. Is the suggestion to replace the current use of the
> > first in field flow_keys->virtio_net_hdr.gso_type with the second in
> > flow_keys->gso_type?
>
>
> No, I meant using a general fields like flow_keys->device_hdr. And use
> bpf helpers to access the field.

What would be in this device_hdr field, and what would the bpf helpers
access? I don't fully follow what this is if not vnet_hdr.
