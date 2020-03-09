Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6257117E3F1
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 16:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCIPvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 11:51:03 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:37089 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgCIPvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 11:51:03 -0400
Received: by mail-yw1-f65.google.com with SMTP id i1so6329666ywf.4
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 08:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J5H4Mtth232NqBlIZT4m6T+vzyRxMtyCSk83lnva1Ls=;
        b=q2U/9ZPtgkWrIiN4DbWxmzjMtGsunPEb1o/plq/47o+NC9msRctwgw3sNT6sGuXAvs
         SQxwCJ5ZtZwhNAHSeAO7X5Di2dfiOAxLUeEs9+YWphnz21dF1RmBodcr2Ooi/jDjFRBC
         R8/bQa2bkG0FLQMV6fy0ro1NuVZxkugRrKVAkU5gysemc8YJtPXRpddbBNsRb+Au2o94
         87JOnmaPJtlplm7IQB+zNXXRgzE05Vu48xTrZko71zSScazT/WZY0tWZrtBdxdEfr7DY
         tnLcw7pLZaOTxhfGTXO9FjcuymyB6q3T8A7+oXVycHcvXdR4hxUazfNPPRlWpxL8EQUo
         IwqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J5H4Mtth232NqBlIZT4m6T+vzyRxMtyCSk83lnva1Ls=;
        b=fDRwE1wIAGeVPV+bL49ncBmxTsFmM4s8TM+x4RcQjcxNq8Yy516BZhafI1YPwb2edI
         Baz26yo9Po5/lOjWbVHVY0S7xrCycfqHQwU1jNTKgwW/xnLeAh7aau5yJxowqevNXyVT
         ywdaDVsbiWObYiUuW542enjwjxWjvP/fL3uhMADVJcN/eRNUdbiaUJt0NoFJtz3xkO8w
         UWxf0ltNJxvxVVj8yMkScJWENmkfV+Jl+ckItahs+ETTkt+zUaP00r5XJYuTy3PNE3+0
         3j3jJQOI1bAR9QuRVlkK4nxA/Ekjm1Aw2G/3n43/IP9d3DcaYqsFT56tvFfK1Jgd5/K/
         1P0w==
X-Gm-Message-State: ANhLgQ1i2pvLLFKSO+EmGbBSFkhUOl0Yi1BcuoMPfMyiLTHjhC33sSrC
        vfUo2F854oBkCLUkK/s849Z7T3L2
X-Google-Smtp-Source: ADFU+vufWQARFscCixteF71bfgPjNup+0JSMF6zhQ8+FFneGL+xcAEKDJXtR42ZjQ9567O3cFHhgsw==
X-Received: by 2002:a5b:50d:: with SMTP id o13mr16583573ybp.366.1583769062031;
        Mon, 09 Mar 2020 08:51:02 -0700 (PDT)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id l68sm2100198ywg.23.2020.03.09.08.51.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 08:51:01 -0700 (PDT)
Received: by mail-yw1-f49.google.com with SMTP id c15so5973250ywn.7
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 08:51:00 -0700 (PDT)
X-Received: by 2002:a81:f10a:: with SMTP id h10mr17393255ywm.109.1583769060462;
 Mon, 09 Mar 2020 08:51:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com> <CA+FuTSfTac=Ut43nFJdB_z605Y-NO7En8AqKT3X8q8=SjFHe6Q@mail.gmail.com>
In-Reply-To: <CA+FuTSfTac=Ut43nFJdB_z605Y-NO7En8AqKT3X8q8=SjFHe6Q@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 9 Mar 2020 11:50:23 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc9gdNO1O1HxOz+j-KVhL_+24LyQjb_gB0tF6uH++ykGg@mail.gmail.com>
Message-ID: <CA+FuTSc9gdNO1O1HxOz+j-KVhL_+24LyQjb_gB0tF6uH++ykGg@mail.gmail.com>
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

On Mon, Mar 9, 2020 at 11:42 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, Mar 9, 2020 at 11:34 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > From: Willem de Bruijn <willemb@google.com>
> >
> > In one error case, tpacket_rcv drops packets after incrementing the
> > ring producer index.
> >
> > If this happens, it does not update tp_status to TP_STATUS_USER and
> > thus the reader is stalled for an iteration of the ring, causing out
> > of order arrival.
> >
> > The only such error path is when virtio_net_hdr_from_skb fails due
> > to encountering an unknown GSO type.
> >
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
>
>
> Fixes: bfd5f4a3d605 ("packet: Add GSO/csum offload support.")
>
> I forgot to add the Fixes tag, sorry. This goes back to the
> introduction of GSO support for virtio_net.

The problem of blinding receivers to certain packet types goes back to
that commit.

But the specific issue of ring out of order arrival is added later,
when vnet_hdr support is extended to tpacket_rcv:

Fixes: 58d19b19cd99 ("packet: vnet_hdr support for tpacket_rcv")
