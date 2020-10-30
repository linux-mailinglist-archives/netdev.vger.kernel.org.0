Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCBF2A102F
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 22:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgJ3V2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 17:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbgJ3V2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 17:28:46 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D328C0613CF;
        Fri, 30 Oct 2020 14:28:46 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p9so10556567eji.4;
        Fri, 30 Oct 2020 14:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KIEqmAs1XvFA4WtieDpHn8W98wDndtvbNRzM5vlXQqQ=;
        b=OXwM1aBFDr0JDNTu4U+hStfZXgkHxfwMJZ9aeai0r+0Jaz2wn+KfqpOYzUSKCUSUct
         Zt7GLhvUl8H+TYFgZRSRfRaKV0+97ZnPe58X+YhbJurwjt7R4t4L/TGxRJaYSl2iiFSi
         MxfPm6TijKpmrBZ/CxfxZRIxm1fCrU6vRRF9jpaCzUxwRUkKTGAjfXgz9Eac5tioO3E3
         HDptKXy3ELgbqTqaC6NHZHTfVSMCJSE0JhoYWffusHV/82dXgelNY3NMI9XY2BaEScda
         a5LFIJvbsfrUz69oueA1HiYPygw7gL9oTln4s4xYDPFYOPHX33DPtbGloP5r2mFMOS/c
         Zhxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KIEqmAs1XvFA4WtieDpHn8W98wDndtvbNRzM5vlXQqQ=;
        b=ZzoxSiZwJ6SbG8oUMTdcG0m0myVLmrEHR7/uDGEawKFZS0BM/NoSFZKsxUlP9E09X0
         iCIAynVR59gpBW6Z+BqjPrGRRPScmBuqiJs9wji8ReiPugUXGASwuL1lW0hULphcXXyB
         EfFCz9Oe+679prdhHk45kj3B9eQghFDqH9tVc7P95FqVdANgSehscUjCCuhZ3c2Y9heN
         QbhWSZ912a9Gt7qf/YCIXgWd3lpTx9fGBiWeFRNve0xyByrWoNMQ5UCdD86D0LFfOGEh
         pEozN6zFiH+2azz63m6a8vE1pO8WdnYLuZ/Dh6C12ayYHvrXp3VkIyz02FLFjBdSw1Mi
         5q3g==
X-Gm-Message-State: AOAM5308BrKOCo5dq5Gz0Cdo4Y509+7OI/RBrDmI/vUzbmgeTlxmyV9r
        BZjyA0paCPMnbVJkUu+wU0esUFvewvKDEsyTjGg=
X-Google-Smtp-Source: ABdhPJyK6dBJGoNM+fMJRcP3Tpi3M/H1TgR+Y+WgDjqkvnPfDFipzAReO0qgJolyelEiXrSYCUSsiVOHqiSPNe2r3BU=
X-Received: by 2002:a17:906:3b91:: with SMTP id u17mr4421859ejf.504.1604093324767;
 Fri, 30 Oct 2020 14:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
 <20201030022839.438135-5-xie.he.0141@gmail.com> <CA+FuTSczR03KGNdksH2KyAyzoR9jc6avWNrD+UWyc7sXd44J4w@mail.gmail.com>
 <CAJht_ENORPqd+GQPPzNfmCapQ6fwL_YGW8=1h20fqGe4_wDe9Q@mail.gmail.com>
In-Reply-To: <CAJht_ENORPqd+GQPPzNfmCapQ6fwL_YGW8=1h20fqGe4_wDe9Q@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 17:28:07 -0400
Message-ID: <CAF=yD-J8PvkR5xTgv8bb6MHJatWtq5Y_mPjx4+tpWvweMPFFHA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 4/5] net: hdlc_fr: Do skb_reset_mac_header for
 skbs received on normal PVC devices
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 4:08 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Fri, Oct 30, 2020 at 9:30 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > Acked-by: Willem de Bruijn <willemb@google.com>
>
> Thanks for your ack!
>
> > Should this go to net if a bugfix though?
>
> Yes, this should theoretically be a bug fix. But I didn't think this
> was an important fix, because af_packet.c already had workarounds for
> this issue for all drivers that didn't have header_ops. We can
> separate this patch to make it go to "net" though, but I'm afraid that
> this will cause merging conflicts between "net" and "net-next".

Yes, it might require holding off the other patches until net is
merged into net-next.

Packet sockets are likely not the only way these packets are received?
It changes mac_len as computed in __netif_receive_skb_core.

If there is no real bug that is fixed, net-next is fine.
