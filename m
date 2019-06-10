Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB7E3B5C1
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390254AbfFJNG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:06:26 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37296 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388848AbfFJNG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 09:06:26 -0400
Received: by mail-ed1-f66.google.com with SMTP id w13so14472340eds.4;
        Mon, 10 Jun 2019 06:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NWUz1aHqiW4DAbvEa0aXgvCzvwmagYC0x0cLUe4LUzs=;
        b=lVHS+rvVZBNNzX16vb+nHxt79PUNxbNEetX7iQeKrY9v6mupSrGBwom58jdVOsXzG8
         V+JR6CwvoT29M7S0UPxIYnBcS09QSKr/ytPsDgnElQzuYf9ophRaOCpPmYxhfeexndlw
         vclK+NuWCLD+BRdmlGnG6PJ5lyyx/2BSyMH31TVhcj2zjNHVxRJS0sTit3vwl73yDPyA
         w2U8wU7uqVMD9gTcbchk19Xzs0ECYIKPIC0UstCft61fSap1VZOe96jxi4RhBBsbCBVq
         oG+pxb6M3OqU6e59m/ElqjegcZ2UlDOCsEHtsstY5aHv5KN6Qb3snJA8y+BQwaPbwosW
         ULTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NWUz1aHqiW4DAbvEa0aXgvCzvwmagYC0x0cLUe4LUzs=;
        b=gpKndljPb0ue9E3S+j3pwKPQuDqddtpA8zxlLO0A04fpT5IvtZbfHQJH1bCySY9JTf
         wNgYBR7V+29bD+zlg4QzLuVS718gpXybRBGrMx8c/ni++xRfSLuNd8Hx0pOTKudxWcj/
         GLxD0JBEz5XFr3Kc9dUvvQpkG9UP8rvtOFjF5hRs8uIVEAJ2yEqoNTCia8xmlraTgh30
         k333FSyYX/vuWrjGgccqguHm+Hcnjw/PsSWdRbnDwSrky4iIsG5oc7tqCbQ6tsoTFDiY
         jJHqXxq4mrovEdmlEFAQYlUmBQdHVtvx9pwDMQy1vHs6d7+5lm7YJ5SAxDyDmY4hdrs2
         SscQ==
X-Gm-Message-State: APjAAAWZtE1NU/pq3dQ2M2Dn2lCwFjNsSOZIMMXlDRBDeZGtk+uzDZVL
        apLOY0C+zgScEoeancnXZC5MXeKXX7tfyfXx0j8=
X-Google-Smtp-Source: APXvYqxSS0J+uIlJ1ZM3+zGWrrtrh/UcBN3VIHfnnDEiaHbzwTuF+97AIOaYkGCC5d3W7EopU7hzI73Od3NB1wrWPDQ=
X-Received: by 2002:a50:bdc2:: with SMTP id z2mr73352300edh.245.1560171984540;
 Mon, 10 Jun 2019 06:06:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190610115831.175710-1-maowenan@huawei.com>
In-Reply-To: <20190610115831.175710-1-maowenan@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 10 Jun 2019 09:05:48 -0400
Message-ID: <CAF=yD-JOCZHt6q3ArCqY5PMW1vP5ZmNkYMKUB14TrgU-X30cSQ@mail.gmail.com>
Subject: Re: [PATCH -next] packet: remove unused variable 'status' in __packet_lookup_frame_in_block
To:     Mao Wenan <maowenan@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 8:17 AM Mao Wenan <maowenan@huawei.com> wrote:
>
> The variable 'status' in  __packet_lookup_frame_in_block() is never used since
> introduction in commit f6fb8f100b80 ("af-packet: TPACKET_V3 flexible buffer
> implementation."), we can remove it.
> And when __packet_lookup_frame_in_block() calls prb_retire_current_block(),
> it can pass macro TP_STATUS_KERNEL instead of 0.
>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  net/packet/af_packet.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index a29d66d..fb1a79c 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1003,7 +1003,6 @@ static void prb_fill_curr_block(char *curr,
>  /* Assumes caller has the sk->rx_queue.lock */
>  static void *__packet_lookup_frame_in_block(struct packet_sock *po,
>                                             struct sk_buff *skb,
> -                                               int status,
>                                             unsigned int len
>                                             )
>  {
> @@ -1046,7 +1045,7 @@ static void *__packet_lookup_frame_in_block(struct packet_sock *po,
>         }
>
>         /* Ok, close the current block */
> -       prb_retire_current_block(pkc, po, 0);
> +       prb_retire_current_block(pkc, po, TP_STATUS_KERNEL);

I don't think that 0 is intended to mean TP_STATUS_KERNEL here.

prb_retire_current_block calls prb_close_block which sets status to

  TP_STATUS_USER | stat

where stat is 0 or TP_STATUS_BLK_TMO.
