Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0E81EBE23
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 16:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgFBOaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 10:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727839AbgFBOaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 10:30:01 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4E3C08C5C1
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 07:30:01 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b27so12667375qka.4
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 07:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BRMN3iW+oQWPEGyzG/UpcFySwPI4120k+UQlkFdg484=;
        b=kK7I4XWxI7j45Cc5kvmTaPzrHmDCP25WmNaXinU+Azay3c4ZdKP+5IlDrppnIqoHoc
         bqx76b84raNpQM4UaYsRcS0J7wNeC6ej+9ZUmF823/bQ5RC7KIzeoAMqneKVHOVAX8+Z
         spHi4PsiPQTDcxjflrqcaA+EGr7RNld40CvgCxnmDQPFHWrWSvEQ5f4qImmLZeFdd2cj
         mTCxrfvK5BVe62c3aBe3Qf/iTVvKm20u+dw8oPAtogsOupBpZfx7idE7We/YPdBYHgxb
         C+TJLkS3Uz47iw6JB1LwjFLtxygGGJMtRadxYUUbU5RGPbDim9jUnY9SPzxaQiMkAnQR
         UXZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BRMN3iW+oQWPEGyzG/UpcFySwPI4120k+UQlkFdg484=;
        b=uZQOBXBPjPFFMdaCq52Zwy96clkYh1Ds9tXxWyVzMxOxV/JgJWWqbghxTedsVwd0hu
         OzBElhRYKwu3WRRRmM/Tl+6cci21qODyJWBkb+91lUfAQ7J6XS9mPrkK6zb43VjG7+qW
         2RHEocmDw/yAQUEfgTyjfpnMFXZkGQJ2HoTRQySf2/QlNX5TaFNnI7atCZLMYwHdBYTS
         NRGJ1RSHVbMJOwRyxqA9KbNqCqt4xea6JVgqW7PaECi+FbYJEIMaM4NEHJqU4+7hHrEA
         KlIAH551ktHxEhRrsj8OAE1xzXokhjd1fGEWVIb9n0Cy5WizFX3/BD31wofi/vCEfP1l
         p36A==
X-Gm-Message-State: AOAM530e3VVjWzTk0oUoKW3fwu662cgbVZ1D3P0z1O6dBFj18198G4AZ
        TDBvTim9G4QYspjNkFOoLzSjCxzH
X-Google-Smtp-Source: ABdhPJwp0kmZItBnFKYMwzKpl50j01Kt0KOXj8rt8RsaKTk/04ghKudMoXnex22wUipwA0kwnlWyxg==
X-Received: by 2002:a37:2e86:: with SMTP id u128mr22681034qkh.26.1591108198840;
        Tue, 02 Jun 2020 07:29:58 -0700 (PDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id n130sm2517614qke.77.2020.06.02.07.29.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 07:29:57 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id j8so7114675ybj.12
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 07:29:56 -0700 (PDT)
X-Received: by 2002:a25:aa70:: with SMTP id s103mr17445033ybi.492.1591108195719;
 Tue, 02 Jun 2020 07:29:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080535.1427-1-victor@inliniac.net>
In-Reply-To: <20200602080535.1427-1-victor@inliniac.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Jun 2020 10:29:19 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfD2-eF0H=Qu09=JXK6WTiWKNtcqRXqv3TfMfB-=0GiMg@mail.gmail.com>
Message-ID: <CA+FuTSfD2-eF0H=Qu09=JXK6WTiWKNtcqRXqv3TfMfB-=0GiMg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] af-packet: new flag to indicate all csums are good
To:     Victor Julien <victor@inliniac.net>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Dumazet <edumazet@google.com>,
        Mao Wenan <maowenan@huawei.com>, Arnd Bergmann <arnd@arndb.de>,
        Neil Horman <nhorman@tuxdriver.com>, linux-doc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Drozdov <al.drozdov@gmail.com>,
        Tom Herbert <tom@herbertland.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 4:05 AM Victor Julien <victor@inliniac.net> wrote:
>
> Introduce a new flag (TP_STATUS_CSUM_UNNECESSARY) to indicate
> that the driver has completely validated the checksums in the packet.
>
> The TP_STATUS_CSUM_UNNECESSARY flag differs from TP_STATUS_CSUM_VALID
> in that the new flag will only be set if all the layers are valid,
> while TP_STATUS_CSUM_VALID is set as well if only the IP layer is valid.

transport, not ip checksum.

But as I understand it drivers set CHECKSUM_COMPLETE if they fill in
skb->csum over the full length of the packet. This does not
necessarily imply that any of the checksum fields in the packet are
valid yet (see also skb->csum_valid). Protocol code later compares
checksum fields against this using __skb_checksum_validate_complete and friends.

But packet sockets may be called before any of this, however. So I wonder
how valid the checksum really is right now when setting TP_STATUS_CSUM_VALID.
I assume it's correct, but don't fully understand where the validation
has taken place..

Similar to commit 682f048bd494 ("af_packet: pass checksum validation
status to the user"), please update tpacket_rcv and packet_rcv.

Note also that net-next is currently closed.




>  for convenience there are also the following defines::
>
> diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_packet.h
> index 3d884d68eb30..76a5c762e2e0 100644
> --- a/include/uapi/linux/if_packet.h
> +++ b/include/uapi/linux/if_packet.h
> @@ -113,6 +113,7 @@ struct tpacket_auxdata {
>  #define TP_STATUS_BLK_TMO              (1 << 5)
>  #define TP_STATUS_VLAN_TPID_VALID      (1 << 6) /* auxdata has valid tp_vlan_tpid */
>  #define TP_STATUS_CSUM_VALID           (1 << 7)
> +#define TP_STATUS_CSUM_UNNECESSARY     (1 << 8)
>
>  /* Tx ring - header status */
>  #define TP_STATUS_AVAILABLE          0
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 29bd405adbbd..94e213537646 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2215,10 +2215,13 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>
>         if (skb->ip_summed == CHECKSUM_PARTIAL)
>                 status |= TP_STATUS_CSUMNOTREADY;
> -       else if (skb->pkt_type != PACKET_OUTGOING &&
> -                (skb->ip_summed == CHECKSUM_COMPLETE ||
> -                 skb_csum_unnecessary(skb)))
> -               status |= TP_STATUS_CSUM_VALID;
> +       else if (skb->pkt_type != PACKET_OUTGOING) {
> +               if (skb->ip_summed == CHECKSUM_UNNECESSARY)
> +                       status |= TP_STATUS_CSUM_UNNECESSARY | TP_STATUS_CSUM_VALID;
> +               else if (skb->ip_summed == CHECKSUM_COMPLETE ||
> +                        skb_csum_unnecessary(skb))
> +                       status |= TP_STATUS_CSUM_VALID;
> +       }
>
>         if (snaplen > res)
>                 snaplen = res;
> --
> 2.17.1
>
