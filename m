Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF7A17E3DA
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 16:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCIPnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 11:43:19 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:45061 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbgCIPnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 11:43:19 -0400
Received: by mail-yw1-f65.google.com with SMTP id d206so10504666ywa.12
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 08:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=485SssXkW+H0mLX40BLOHwY75nYIzJ98vMhLiSaXO4E=;
        b=TBWHDZVh/IUXDpbMbnC7qBGK2AoV46NiJVIUG8NalFrPzyBaDXYRWFiu/DRt5hG+Re
         32F0L+WA0ZHWaBgH52CTC6j6sJ19EoYnz+6YhDdvEuACK8N+wFxsz9qAwEsD3UCayTiC
         mOfIIkNmBGLq2Dzj2bsR0a6Aap6wYvn6hD6yLgdkJiiyVHWIJC4aohuPjxKFFRiuwWxU
         MliMMKqLH3CkirCWO+PyjLZW+xm70PJZUNVgYjUiaAgt0cN/JYXaYDPfjo1yjfsMFA1+
         Jcb3GHMK/9kIK1XribTStEi5aBSlgd76yUR78RgWXplIf1YbgAuHDseD+FdGCQrgXZMv
         7ijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=485SssXkW+H0mLX40BLOHwY75nYIzJ98vMhLiSaXO4E=;
        b=VG0/McU7WWFXvY3CR8TCEkTySocr8h9Vj37A2/Wgxpsf/LDQ58yrT2IWKXBspwLAz3
         pOXj6/iP6B4xnnkFinbtZuiA0k/AG2fY21Bhv4YX2RHNyHI8CxK8w0TZp9wFD9OvuAo1
         1/Saryabjf8qXavRPe90ehU/UwRo6y7cPa9X4P6EJe7mSGoU8QuYqfKSxig5EfbBOklV
         GyDR1NuDE9KWn8vCtpjLScEYVB7S7uKyx/dIXydSn8E/CwEw2LB1ERXsEf3CInEm5/qi
         gfWMXlLbmQjbMU9+9fbNkdayPteFuXulVkiSJz1z8wYNnTrNvKeNAspAUS4EYF7BpSP7
         ygxA==
X-Gm-Message-State: ANhLgQ2ZcKvWqylPsrdA/3vBCzIL+PtehjxCxsAI6d/Z2fPYZCKV3TIZ
        vQTBe/octfG26HRP7OQGZLbOfLjR
X-Google-Smtp-Source: ADFU+vv1C9CgLORRnNaaAodoxDdax/M8c0Q1dR+pTORDrfF5v24K66W6zDi9KG9tLGuGN8YmitvGBg==
X-Received: by 2002:a5b:c8d:: with SMTP id i13mr17281654ybq.480.1583768597827;
        Mon, 09 Mar 2020 08:43:17 -0700 (PDT)
Received: from mail-yw1-f53.google.com (mail-yw1-f53.google.com. [209.85.161.53])
        by smtp.gmail.com with ESMTPSA id o127sm18107413ywf.43.2020.03.09.08.43.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 08:43:17 -0700 (PDT)
Received: by mail-yw1-f53.google.com with SMTP id d206so10504576ywa.12
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 08:43:17 -0700 (PDT)
X-Received: by 2002:a25:cc8a:: with SMTP id l132mr18224208ybf.178.1583768596496;
 Mon, 09 Mar 2020 08:43:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 9 Mar 2020 11:42:40 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfTac=Ut43nFJdB_z605Y-NO7En8AqKT3X8q8=SjFHe6Q@mail.gmail.com>
Message-ID: <CA+FuTSfTac=Ut43nFJdB_z605Y-NO7En8AqKT3X8q8=SjFHe6Q@mail.gmail.com>
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring index
 on drop
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 9, 2020 at 11:34 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> In one error case, tpacket_rcv drops packets after incrementing the
> ring producer index.
>
> If this happens, it does not update tp_status to TP_STATUS_USER and
> thus the reader is stalled for an iteration of the ring, causing out
> of order arrival.
>
> The only such error path is when virtio_net_hdr_from_skb fails due
> to encountering an unknown GSO type.
>
> Signed-off-by: Willem de Bruijn <willemb@google.com>


Fixes: bfd5f4a3d605 ("packet: Add GSO/csum offload support.")

I forgot to add the Fixes tag, sorry. This goes back to the
introduction of GSO support for virtio_net.

The discussion then explicitly arrived at deciding to fail on an
unknown type (SKB_GSO_FCOE). Which is why I asked the question here
whether we want to revisit that choice or leave as is.
