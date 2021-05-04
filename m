Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E209E372C59
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 16:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhEDOrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 10:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhEDOrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 10:47:21 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9263CC061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 07:46:25 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id b25so13587537eju.5
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 07:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ih55El7lBb6oahJFMZnTFx4a9J+6P8E1IXOoIpco+LE=;
        b=O9VXVnHWWvkCoSiFXb+hv2wsaAHKZQRWOt7ixACxNcgzXpGYIOPrdtRdq6nkJ7M/IA
         U2WWpoCPc1S/EkGK0BhC0FryO7OJvkaogtom6oPTW9PL/dY1EvsF5fRUbhOXXI5i0jsi
         zVM3aoy9syVynzv24sqhpO/9jDbqvw2cj0dB3iN1oE2JsYn8OCRVLJbhqk7xfwOgW/2z
         mwWz7Uvmhlg+geT2BGO75n2lEEi3rdqH2dEWJgmJz3/MZtWcRL2801ik1AUgKbm8Ybou
         sG0pzpYC1qPg/OnoqLBbd5ZAmejndhZKvyYrTMORYWMR/WyL8wBtlS6MYHuGsARMlJ1L
         YCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ih55El7lBb6oahJFMZnTFx4a9J+6P8E1IXOoIpco+LE=;
        b=hC/0ZLApekCZNPBkpeo7fE1JqjEKhSwqFBjHvlAV2H8XlT1/1BON02SAYdqo92sV2A
         2ZrRBo35YjJGm8sV8+RLiJjeN7G0ogjm1KKpbZxSlG2/xcBVKP+060PLVy9OtA+oCpNk
         1wYmD3Pr1NXwO1WZhQ5yr9E61ViCl7XsGqlbP6/3IznKFoEEbnCIVCs3qFgqgC7Xg12E
         ru9KwLBVIw/RWtsqVZ40RYqc+4pC3ihjlAKGnscwUTJUVvhYzAgCO4syWyGyz1tb3ETt
         WroOCzYpoaDyUDLhbhrG6eW6QuxAAWb6c56RDbUZbANp+lpClJSoW995yYuX3DS/LyLY
         2CmA==
X-Gm-Message-State: AOAM531quatQY6FsOB3XjZ1xy+XdBPBj6Ud1gTKC+LOy+WnMKbLzTYLH
        Os6Ytdq+6oXWucjcwoP+orRQ5V5FVnthoA==
X-Google-Smtp-Source: ABdhPJyLFyKW0Bv85B0af4TpfP6/Itnhjc/ni4TMQL25Kn3msHkJSqoOGw7icHZL88HJDbYsaf5pkA==
X-Received: by 2002:a17:907:11db:: with SMTP id va27mr22091954ejb.174.1620139583725;
        Tue, 04 May 2021 07:46:23 -0700 (PDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id h9sm2455273ede.93.2021.05.04.07.46.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 07:46:23 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id d11so9728127wrw.8
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 07:46:23 -0700 (PDT)
X-Received: by 2002:a05:6000:1787:: with SMTP id e7mr7304180wrg.12.1620139582544;
 Tue, 04 May 2021 07:46:22 -0700 (PDT)
MIME-Version: 1.0
References: <1620085579-5646-1-git-send-email-rsanger@wand.net.nz>
 <CA+FuTSeDTYMZzT3n3tfm9KPCRx_ObWU-HaU4JxZCSCm_8sf2XA@mail.gmail.com> <CAN6QFNzj9+Y3W2eYTpHzVVjy_sYN+9d_Sa99HgQ0KgKyNmpeNw@mail.gmail.com>
In-Reply-To: <CAN6QFNzj9+Y3W2eYTpHzVVjy_sYN+9d_Sa99HgQ0KgKyNmpeNw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 4 May 2021 10:45:45 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfE9wW55BbYRWNE1=XYAjG7gKVLLLbfAvB-4F+dL=8gHA@mail.gmail.com>
Message-ID: <CA+FuTSfE9wW55BbYRWNE1=XYAjG7gKVLLLbfAvB-4F+dL=8gHA@mail.gmail.com>
Subject: Re: [PATCH] net: packetmmap: fix only tx timestamp on request
To:     Richard Sanger <rsanger@wand.net.nz>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 3, 2021 at 9:22 PM Richard Sanger <rsanger@wand.net.nz> wrote:
>
> Hi Willem,
>
> This is to match up with the documented behaviour; see the timestamping section
> at the bottom of
> https://www.kernel.org/doc/html/latest/networking/packet_mmap.html
>
> If no call to setsockopt(fd, SOL_PACKET, PACKET_TIMESTAMP, ...) is made then
> the tx path ring should not return timestamps, or timestamp flags set in
> tp_status.
>
> As noted in b9c32fb27170
> ("packet: if hw/sw ts enabled in rx/tx ring, report which ts we got")
> this is to retain backwards compatibility with old code.
>
> However, currently, a timestamp can be returned without setting
> PACKET_TIMESTAMP, in the case that skb->tstamp includes a timestamp.
> I only noticed this recently due to:
> aa4e689ed1 (veth: add software timestamping)
> which means skb->tstamp now includes a timestamp.
>
> The issue this bug causes for old/non-timestamp aware code is that tp_status
> may incorrectly have the TP_STATUS_TS_SOFTWARE flag set, so the documented
> check (tp_status == TP_STATUS_AVAILABLE) that a frame in the ring is free fails.
> Causing such code to hang infinitely.

Then this would need a

Fixes: b9c32fb27170 ("packet: if hw/sw ts enabled in rx/tx ring,
report which ts we got")

I don't fully follow the commit message in that patch for why enabling
this unconditionally on Tx is safe:

"
   This should not break
    anything for the following reasons: [..]

    ii) in TX ring path, time stamps with PACKET_TIMESTAMP
    socketoption are not available resp. had no effect except that the
    application setting this is buggy. Next to TP_STATUS_AVAILABLE, the
    user also should check for other flags such as TP_STATUS_WRONG_FORMAT
    to reclaim frames to the application. Thus, in case TX ts are turned
    off (default case), nothing happens to the application logic
"

But I think the point is that tx packets are not timestamped unless
skb_shinfo(skb)->tx_flags holds a timestamp request. Such as for
the software timestamps that veth can now generate:

"
static inline void skb_tx_timestamp(struct sk_buff *skb)
{
        skb_clone_tx_timestamp(skb);
        if (skb_shinfo(skb)->tx_flags & SKBTX_SW_TSTAMP)
                skb_tstamp_tx(skb, NULL);
}
"

So unless this packet socket has SOF_TIMESTAMPING_TX_SOFTWARE
configured, no timestamps should be recorded for its packets, as tx flag
SKBTX_SW_TSTAMP is not set.

> This patch corrects the behaviour for the tx path. But, doesn't change the
> behaviour on the rx path. The rx path still includes a timestamp (hence
> the patch always sets the SOF_TIMESTAMPING_SOFTWARE flag on rx).

Right, this patch suppresses reporting of any recorded timestamps. But
the system should already be suppressing recording of these
timestamps.

Assuming you discovered this with a real application: does it call
setsockopt SOL_SOCKET/SO_TIMESTAMPING at all?

It's safe to suppress on the reporting side as extra precaution against
spuriously timestamped packets. I just want to understand how these
timestamps are even recorded in the first place.

Small nit wrt the patch: the comment "/* always timestamp; prefer an
existing software timestamp */" states what the code does, but more
interesting would be why.
