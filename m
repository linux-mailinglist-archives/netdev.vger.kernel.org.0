Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115C816B0E1
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 21:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgBXUVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 15:21:33 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:35953 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbgBXUVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 15:21:33 -0500
Received: by mail-yw1-f67.google.com with SMTP id n184so5840114ywc.3
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 12:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0nEJM8yTdyUbhN2ATPuO/jWnU2UZaTd8jjC8sXAHqFQ=;
        b=ft0SFe/z22U1TyjHYjZhIL1FD0josSLoJX2cTgyBz7Kyp2KAsA6pSpkZfC6FS/FF4v
         mZEkEluTSY18I+ksbZghWDXr4dZpNqkDvK1mvdFErJfTOZda86m1A9XGKnoZEZcMxzzC
         qKPWp3NGt7Ic8ap5OiZgcrFY0prGNB6DkytrIrfzEUxD4H4a1JlgoPQUiKz+woN6EoxY
         /KZt2S+DSHeSslmeKecNpBtgbYKjm99AbLx9sRJqBWcIE+rqluo5g4XMuYJunu7PVwtG
         tcKdlleikMrQIc8BJlMLDCu3BqCmjNcxYZGYc6+Btj4MpExIAekAzdG0uZehvfY1s2ew
         Tf7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0nEJM8yTdyUbhN2ATPuO/jWnU2UZaTd8jjC8sXAHqFQ=;
        b=B0JP0yCn6lT5lbkDeO7tMHEYXcGPvwLMOUTpGCpsysYKiODRGFiaS9b+/2+nqoMsPz
         0oQQRp9QuMRU1XCFs390x3z+D901dHUB7uGvQ4FYjlgnwMBskh4req/0lzy/ffriyoEq
         Yl9VgrXyEVxoH0o9ChH/h4q3LSUBK2BebvPScEcdxN1N803+/IR8PB6eOUq6y402Dymf
         YzP4U89XM05lIGNhBASavN5Woy64JQnIs25QTto3Qn4tkQqmzpRHEgcW0mfhZuyIru11
         cbNeQrsnBsTq2bEX5y8OdR/PUZOBTCEZdyVKf7DQ5D8g2c984A7syVHBSv0PHmRVff0d
         EUjg==
X-Gm-Message-State: APjAAAUjMO0tcj1HWzCGYp5lkiOWzUDsstBBBpssnwMwm4dK/kfBsKx5
        OisGgBPoyKZIKCxQOz29gSVH5Mo5
X-Google-Smtp-Source: APXvYqwkBzhh0tUkWwzICfHNS6vcjgIgcgbdClgTcAWxO29L3pK+ixvRA+Nkufs3/BXMOPI4AvF5WA==
X-Received: by 2002:a81:6c8b:: with SMTP id h133mr43643301ywc.239.1582575691964;
        Mon, 24 Feb 2020 12:21:31 -0800 (PST)
Received: from mail-yw1-f47.google.com (mail-yw1-f47.google.com. [209.85.161.47])
        by smtp.gmail.com with ESMTPSA id b195sm5814704ywh.80.2020.02.24.12.21.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 12:21:31 -0800 (PST)
Received: by mail-yw1-f47.google.com with SMTP id i190so5846443ywc.2
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 12:21:30 -0800 (PST)
X-Received: by 2002:a81:6588:: with SMTP id z130mr39338605ywb.355.1582575690106;
 Mon, 24 Feb 2020 12:21:30 -0800 (PST)
MIME-Version: 1.0
References: <20200224132550.2083-1-anton.ivanov@cambridgegreys.com>
 <CA+FuTSd8P6uQnwisZEh7+nfowW9qKLBEvA4GPg+xUkjBa-6TDA@mail.gmail.com> <4e7757cf-148e-4585-b358-3b38f391275d@cambridgegreys.com>
In-Reply-To: <4e7757cf-148e-4585-b358-3b38f391275d@cambridgegreys.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 24 Feb 2020 15:20:53 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdOCJZCVS4xohx+BQmkmq8JALnK=gGc0=qy1TbjY707ag@mail.gmail.com>
Message-ID: <CA+FuTSdOCJZCVS4xohx+BQmkmq8JALnK=gGc0=qy1TbjY707ag@mail.gmail.com>
Subject: Re: [PATCH v3] virtio: Work around frames incorrectly marked as gso
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-um@lists.infradead.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 2:55 PM Anton Ivanov
<anton.ivanov@cambridgegreys.com> wrote:
>
> On 24/02/2020 19:27, Willem de Bruijn wrote:
> > On Mon, Feb 24, 2020 at 8:26 AM <anton.ivanov@cambridgegreys.com> wrote:
> >>
> >> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> >>
> >> Some of the locally generated frames marked as GSO which
> >> arrive at virtio_net_hdr_from_skb() have no GSO_TYPE, no
> >> fragments (data_len = 0) and length significantly shorter
> >> than the MTU (752 in my experiments).
> >
> > Do we understand how these packets are generated?
>
> No, we have not been able to trace them.
>
> The only thing we know is that this is specific to locally generated
> packets. Something arriving from the network does not show this.
>
> > Else it seems this
> > might be papering over a deeper problem.
> >
> > The stack should not create GSO packets less than or equal to
> > skb_shinfo(skb)->gso_size. See for instance the check in
> > tcp_gso_segment after pulling the tcp header:
> >
> >          mss = skb_shinfo(skb)->gso_size;
> >          if (unlikely(skb->len <= mss))
> >                  goto out;
> >
> > What is the gso_type, and does it include SKB_GSO_DODGY?
> >
>
>
> 0 - not set.

Thanks for the follow-up details. Is this something that you can trigger easily?

An skb_dump() + dump_stack() when the packet socket gets such a
packet may point us to the root cause and fix that.
