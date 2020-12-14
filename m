Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD402D91A4
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 03:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437830AbgLNCBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 21:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730596AbgLNCBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 21:01:12 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E2AC0613CF
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 18:00:32 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id x16so20375748ejj.7
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 18:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ezj8MckI+MTr2T2ucmiHxHADoYtgYcT3sRnRFkxh2o=;
        b=tvJzYlWMMF6ekrxMjL5EAmqZ3j5zNdiMVi403ldoBWAIhAdXa+q+QxAju7sODvMXam
         zVjD2Av+LQbBDVyg1XEWNUAePdZTccCF1yFcO5jeXUIWNNloLB7JEeoTLxA5HIJUDYUf
         aIZVHhRGCuWlWNZPQoG5z2XgGbKBV8yD2Sfz+rnnflfUqRJKM16glkpfc0/i3JrragqS
         FB6rvwa+Uku3tbH3SzGLir0D7VGoanXQ1aCd34jrFuM/Ud5f52NGiz/GCV0I7zobmgAP
         kZMin13686IPWXs7UVTHE7bCaZdiTNCohoXu1tnBO/hYhgQHaedd39XQ5FukRtWWCv5A
         R5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ezj8MckI+MTr2T2ucmiHxHADoYtgYcT3sRnRFkxh2o=;
        b=hFapX0Uq3C+YVtiPUc3HtxhqCxs8vUALaUMNT0GS2JZetE/LlZf/8cE055Az1C/6XJ
         rNrKyEc84Cd/pg90VYhEDki4w8MxOdobE+8nTtfELODBFwBsfvEB8hMVu3CmqhaGT0iB
         HNTzM1bUmXasUdaqTglvWNL6Hn952t3otg8BlMZm1NrK0PHo4+VNgIirfIj8jL/7A0D6
         weOG0H3+sxNbh4MwRBjFfkQHGyiHum+QtZJsrzvWjORe2dpleYXV9KMNuAJHOzx7IIgu
         jV9nP9kGETsI4hA23Q2cLwsw4j1gxDs+uLwD87BXbGZ5F55wEtG3O7NuXsJWIDsKy9CK
         hckQ==
X-Gm-Message-State: AOAM533JW4FbntNQSKf3S+xQpwkEKv7UAIQMbzQkD8xz+X+Bsok3K86P
        uNCJa/W5qsCLgdOMgZtDzbYqdf7mFCONfGrXdAsPPzN/Rmc=
X-Google-Smtp-Source: ABdhPJxmKYD5zZGtePiGjCc/V95cBcrUWy2viuR4HVLRrz1hIkbroQn986Mgtng1nkOAxcbyF0Z9zNapIjW4Go2NJck=
X-Received: by 2002:a17:906:4bd2:: with SMTP id x18mr20308130ejv.464.1607911230737;
 Sun, 13 Dec 2020 18:00:30 -0800 (PST)
MIME-Version: 1.0
References: <7080e8a3-6eaa-e9e1-afd8-b1eef38d1e89@virtuozzo.com>
 <1f8e9b9f-b319-9c03-d139-db57e30ce14f@virtuozzo.com> <3749313e-a0dc-5d8a-ad0f-b86c389c0ba4@virtuozzo.com>
 <CA+FuTScG1iW6nBLxNSLrTXfxxg66-PTu3_5GpKdM+h2HjjY6KA@mail.gmail.com> <98675d3c-62fb-e175-60d6-c1c9964af295@virtuozzo.com>
In-Reply-To: <98675d3c-62fb-e175-60d6-c1c9964af295@virtuozzo.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 13 Dec 2020 20:59:54 -0500
Message-ID: <CAF=yD-JqVEQTKzTdO1BaR_2w6u2eyc6FvtghFb9bp3xYODHnqg@mail.gmail.com>
Subject: Re: [PATCH] net: check skb partial checksum offset after trim
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 2:37 PM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> On 12/13/20 2:49 AM, Willem de Bruijn wrote:
> > On Sat, Dec 12, 2020 at 5:01 AM Vasily Averin <vvs@virtuozzo.com> wrote:
> >>
> >> On 12/11/20 6:37 PM, Vasily Averin wrote:
> >>> It seems for me the similar problem can happen in __skb_trim_rcsum().
> >>> Also I doubt that that skb_checksum_start_offset(skb) checks in
> >>> __skb_postpull_rcsum() and skb_csum_unnecessary() are correct,
> >>> becasue they do not guarantee that skb have correct CHECKSUM_PARTIAL.
> >>> Could somebody confirm it?
> >>
> >> I've rechecked the code and I think now that other places are not affected,
> >> i.e. skb_push_rcsum() only should be patched.
> >
> > Thanks for investigating this. So tun was able to insert a packet with
> > csum_start + csum_off + 2 beyond the packet after trimming, using
> > virtio_net_hdr.csum_...
> >
> > Any packet with an offset beyond the end of the packet is bogus
> > really. No need to try to accept it by downgrading to CHECKSUM_NONE.
>
> Do you mean it's better to force pskb_trim_rcsum() to return -EINVAL instead?

I would prefer to have more strict input validation in
tun/virtio/packet (virtio_net_hdr_to_skb), rather than new checks in
the hot path. But that is a larger change and not feasible
unconditionally due to performance impact and likely some false
positive drops. So out of scope here.

Instead of adding a workaround in the not path, I thought about
converting the two checks in skb_checksum_help

  BUG_ON(offset >= skb_headlen(skb));
  BUG_ON(offset + sizeof(__sum16) > skb_headlen(skb));

to normal error paths and return EINVAL. But most callers, including
this one (checksum_tg), don't check the return value to drop the
packet.

Given that, your approach sounds the most reasonable. I would still
drop these packets, as they are clearly bad and the only source of
badness we know is untrusted user input.

In that case, perhaps the test can move into pskb_trim_rcsum_slow,
below the CHECKSUM_COMPLETE branch.
