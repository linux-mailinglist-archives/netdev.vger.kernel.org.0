Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E85F37BFE4
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhELOZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbhELOZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 10:25:55 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E30CC061574
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:24:47 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id b25so35215501eju.5
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lpkTDpn+5Vii2QYKGuBxnfdBc/znQnq57pvup7LN1KA=;
        b=VEBrzF6gajoRx0RO0TGonPFP4DvlJuMmTf2n/U/GRTzzKzPBXjvDmhvbIVJyCn/b7L
         alSIglqYRC53boQmawLCyMLMCA0xYP6Amzn6xHGfycNUVoMJFbzIigjd1T2+LNmCBvJe
         vuWHcjY6sGX8PViczaa0FGk2m16HLseoOMT9jUB1NcNIeZOTz2WpVBnOGClfQE0uDBvW
         0y/16hZOboYJfdCB7+mdPIhjbUp8A1jzQmOsJPoGvf29x8AP61l8nZDnitSfLWgcc8sL
         /RvMT52xPsHB3oeDUOZk0wABzD2k0224Bzu8GWem8iNBV6jxBaGzrOhXA4+7OqligbUK
         MRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lpkTDpn+5Vii2QYKGuBxnfdBc/znQnq57pvup7LN1KA=;
        b=newVnAUcONzLnhzDLTduaTrI4HjbgWzerfPzQVK/ivZJ36LNXQdgAuwP1gA8Nko6Gl
         tz5o/kluqfID7sL5STV13D1MhhIF1PJAPeBosSZhK4gHwg3h0U9uYNpyVIQiGYoo/eWY
         TzUw6HV/gch6f5JY5ptXhA2tqMfRN24cALwgUti56B0D3epTzBjPeYQQyUaNpxCI3un3
         x90ktg3TGlLZRnuYU9GSeSoD1RGgVBNUSHauBiqLjGJDCt4L+FJF0UT2b8uruX/grvse
         +5EFQLE9WfGjVRt+rkdyzLcaPlDnW4YosHkprZjNcoVa+2iuQtTcI5rOoArnIcvY61/9
         dc3w==
X-Gm-Message-State: AOAM531GzYRfza7SqNc90jlx+RvqF5jX3vfSkP4uDeNOjXInl3rILWDk
        92zsymSOfFXooKG8RXFM0J8vhxtKDfkp2w==
X-Google-Smtp-Source: ABdhPJyrRcqgEEjc972Z/+aN3mlDXX79r26lP0qeawyoN8yo8sIKor66G2SER2NO7wOBvKVuiD3GVg==
X-Received: by 2002:a17:906:5652:: with SMTP id v18mr38143812ejr.457.1620829486061;
        Wed, 12 May 2021 07:24:46 -0700 (PDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com. [209.85.128.52])
        by smtp.gmail.com with ESMTPSA id x7sm18171106eds.11.2021.05.12.07.24.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 07:24:45 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id u133so1619580wmg.1
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:24:44 -0700 (PDT)
X-Received: by 2002:a1c:ba05:: with SMTP id k5mr7718933wmf.169.1620829484464;
 Wed, 12 May 2021 07:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <1620783082-28906-1-git-send-email-rsanger@wand.net.nz>
In-Reply-To: <1620783082-28906-1-git-send-email-rsanger@wand.net.nz>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 12 May 2021 10:24:06 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdygqm6WM6NbDuiBn1MwSAezBkr+tez8E_bmZCk4HhihA@mail.gmail.com>
Message-ID: <CA+FuTSdygqm6WM6NbDuiBn1MwSAezBkr+tez8E_bmZCk4HhihA@mail.gmail.com>
Subject: Re: [PATCH v2] net: packetmmap: fix only tx timestamp on request
To:     Richard Sanger <rsanger@wand.net.nz>
Cc:     Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 9:32 PM Richard Sanger <rsanger@wand.net.nz> wrote:
>
> The packetmmap tx ring should only return timestamps if requested via
> setsockopt PACKET_TIMESTAMP, as documented. This allows compatibility
> with non-timestamp aware user-space code which checks
> tp_status == TP_STATUS_AVAILABLE; not expecting additional timestamp
> flags to be set in tp_status.
>
> Fixes: b9c32fb27170 ("packet: if hw/sw ts enabled in rx/tx ring, report which ts we got")
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Signed-off-by: Richard Sanger <rsanger@wand.net.nz>

Code LGTM.

It would be good to capture more of the context: when these spurious
timestamps can appear (network namespaces) and as of which commit (the
one that changes orphaning). As is, I would not be able to understand
the issue addressed from this commit message alone.

Instead of adding context to the commit, you could also add a Link tag
to the archived email thread, if you prefer.

And perhaps: [PATCH net v3] net/packet: return software transmit
timestamp only when requested



> ---
>  net/packet/af_packet.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index ba96db1..ae906eb 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -422,7 +422,8 @@ static __u32 tpacket_get_timestamp(struct sk_buff *skb, struct timespec64 *ts,
>             ktime_to_timespec64_cond(shhwtstamps->hwtstamp, ts))
>                 return TP_STATUS_TS_RAW_HARDWARE;
>
> -       if (ktime_to_timespec64_cond(skb->tstamp, ts))
> +       if ((flags & SOF_TIMESTAMPING_SOFTWARE) &&
> +           ktime_to_timespec64_cond(skb->tstamp, ts))
>                 return TP_STATUS_TS_SOFTWARE;
>
>         return 0;
> @@ -2340,7 +2341,12 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>
>         skb_copy_bits(skb, 0, h.raw + macoff, snaplen);
>
> -       if (!(ts_status = tpacket_get_timestamp(skb, &ts, po->tp_tstamp)))
> +       /* Always timestamp; prefer an existing software timestamp taken
> +        * closer to the time of capture.
> +        */
> +       ts_status = tpacket_get_timestamp(skb, &ts,
> +                                         po->tp_tstamp | SOF_TIMESTAMPING_SOFTWARE);
> +       if (!ts_status)
>                 ktime_get_real_ts64(&ts);
>
>         status |= ts_status;
> --
> 2.7.4
>
