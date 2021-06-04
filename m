Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85DE39B121
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 05:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFDDxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 23:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhFDDxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 23:53:53 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF08C06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 20:52:07 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id c10so12307362eja.11
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 20:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/4L/S+ziT9zZRS51oMaLvPt8LeGdXeAn9/h/hVqAyRM=;
        b=HIpWWXqmxXIO4Dl7GQIh1qgX3+bvGrlb87m3vbm3WlHaSSYTtTlK6IlRb9aOXk1rAz
         GnZnVSvhTGlPRV+8a/YLnWrMUfWs9NaeAMZXnkjCzm3HbcCDBDGy5z+WuCanfED95jIR
         AWt4jHNUzlGD6KlzaA/mzYs9vlZE0T3nj1kX7eme9AcbvoFB/6FOiufunuQZX8B5HU53
         5mT/7s62KMPnlDHqAbqjv+O11Rsuoo99N9IJ65hLnQJd9mOO58eKbBjvbnHnucZocjm5
         WljhxEnOwCduqstM1aJc+0MsK+iHjhTI1SGpZrqLiblUBHA2sxFfpapTQ5y48bYsk6jL
         iu4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/4L/S+ziT9zZRS51oMaLvPt8LeGdXeAn9/h/hVqAyRM=;
        b=Fv6FyKeNul54Gy9CfUv79u/ncOWgo9ft4Bl0zAuDzix4+/bEPl6LzgWVi/N217iZcn
         csJE0P0I8iYQucVyFHVs8la+BR2wjX/O/xGxOSOcGRQm7/JcfS5wZWXcQa/3JBywfX4u
         2ArSxi8BUNgnN3UXKR0XhGY9Zj9sXKaa9qy4Pg6fPMAILjhFMol+uDTyF7T2BhCuAmNO
         GhR7s/Gl/DUikOgKTTPRfKadoGJ8DjY6Q0N4bmfjTI+HmKs3IWsVAezUnqzN3He8PPXz
         cvMkNWSqptCHXSF0lHEyhQR/ZHwB5xQYZRt4nBh/9l8KDbt/fh0tZXmHPNRtZ8kZ9uhh
         QqIw==
X-Gm-Message-State: AOAM531O07Alv48Gj9ppeQNM56pVAnebDwxMaA3HjLbgYd3x0oaeNS9K
        ZMi6ZM6Bf/eDGVYRkTXn6M2/ErRsaGhevA==
X-Google-Smtp-Source: ABdhPJxZU80jDH3k4hEd8SNVaTcx0n88qS83r4NOLbxyIqyDzyysM94YS8mKxJxLIDahrVnaLVRg8g==
X-Received: by 2002:a17:906:1848:: with SMTP id w8mr2209997eje.277.1622778726219;
        Thu, 03 Jun 2021 20:52:06 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id w13sm2581814edc.52.2021.06.03.20.52.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 20:52:05 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id h12-20020a05600c350cb029019fae7a26cdso4780852wmq.5
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 20:52:04 -0700 (PDT)
X-Received: by 2002:a1c:2456:: with SMTP id k83mr1386888wmk.87.1622778724368;
 Thu, 03 Jun 2021 20:52:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210601221841.1251830-1-tannerlove.kernel@gmail.com> <eef275f7-38c5-6967-7678-57dd5d59cf76@redhat.com>
In-Reply-To: <eef275f7-38c5-6967-7678-57dd5d59cf76@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 3 Jun 2021 23:51:27 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdEF7dONWZWR3t9EZ5VU3XrfWTb0CmWKe7pQBL-tje0WA@mail.gmail.com>
Message-ID: <CA+FuTSdEF7dONWZWR3t9EZ5VU3XrfWTb0CmWKe7pQBL-tje0WA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Jason Wang <jasowang@redhat.com>
Cc:     Tanner Love <tannerlove.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tanner Love <tannerlove@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 10:55 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/6/2 =E4=B8=8A=E5=8D=886:18, Tanner Love =E5=86=99=E9=81=93=
:
> > From: Tanner Love <tannerlove@google.com>
> >
> > First patch extends the flow dissector BPF program type to accept
> > virtio-net header members.
> >
> > Second patch uses this feature to add optional flow dissection in
> > virtio_net_hdr_to_skb(). This allows admins to define permitted
> > packets more strictly, for example dropping deprecated UDP_UFO
> > packets.
> >
> > Third patch extends kselftest to cover this feature.
>
>
> I wonder why virtio maintainers is not copied in this series.

Sorry, an oversight.

> Several questions:
>
> 1) having bpf core to know about virito-net header seems like a layer
> violation, it doesn't scale as we may add new fields, actually there's
> already fields that is not implemented in the spec but not Linux right no=
w.

struct virtio_net_hdr is used by multiple interfaces, not just virtio.
The interface as is will remain, regardless of additional extensions.

If the interface is extended, the validation can be extended with it.

Just curious: can you share what extra fields may be in the pipeline?
The struct has historically not seen (m)any changes.

> 2) virtio_net_hdr_to_skb() is not the single entry point, packet could
> go via XDP

Do you mean AF_XDP? As far as I know, vnet_hdr is the only injection
interface for complex packets that include offload instructions (GSO,
csum) -- which are the ones mostly implicated in bug reports.

> 3) I wonder whether we can simply use XDP to solve this issue (metadata
> probably but I don't have a deep thought)
> 4) If I understand the code correctly, it should deal with all dodgy
> packets instead of just for virtio

Yes. Some callers of virtio_net_hdr_to_skb, such as tun_get_user and
virtio receive_buf, pass all packets to it. Others, like tap_get_user
and packet_snd, only call it if a virtio_net_hdr is passed. Once we
have a validation hook, ideally all packets need to pass it. Modifying
callers like tap_get_user can be a simple follow-on.
