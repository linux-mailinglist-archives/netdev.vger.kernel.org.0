Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDD629F275
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgJ2RAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgJ2RAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:00:20 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9328DC0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:00:20 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id r9so886761uat.12
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ax/arMJPB5JDU2zSG4zv6HwhK3dEGow1MV8rYaZb7S8=;
        b=ZWP6O1HM6qViVrJRwwc2O/x3cXMdTOnU3eXAkpa2Pp1GHxrclk9NhZUat6kPPRy3Fj
         PkgUWDETcCe6qh2KDNM/EIpkOMFNTohB0Js02VvNCbp9NmGmsmrVb1vEvf2ui43qdZzU
         sdW42IlWexFiJT9gtq8yawPdUwgueh5/RLeEY/1m+ntRm7fooazKeixrd+EPpqKn5KBp
         ey/Hc30faNzZz5Y49vOfuaKo3kPovfOLymGWB7kUU5yD31o9FepGHQSIPnZVHU8bfvcg
         BWvGXu90FSiC+Q+7u8bLrzuTcq2Iab6cnDZoeAr6Q/+hn5i5TZnOhIp6x6WVTks+tgH6
         Gy8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ax/arMJPB5JDU2zSG4zv6HwhK3dEGow1MV8rYaZb7S8=;
        b=QrXTJh85Z38Q4MKjW6GzeoUX19OGY4oyXFLspiKFW/hchMFwuVqueow08ufLt6sVls
         5hsCSS80/rag8vX/TVeysdcdf/tXhVoTZVZsGDm+mqMFvYAt6CGjPHpw3h4tzZ26LKZn
         qvwSEUALjxOMmaRirAaGmUxz4LOtLWOkZVMUqKGEXHI7ALn1mqcu32sIhJy/OyhwEwSS
         XgCjY6ZlvC6T4NW8MJoJdNOkodx7GvOQUVNl2MBED3/ZJ/HA21xFPfPnDU5pd3WNZjVs
         RQQpaFlY+HcoY3sIW8vno/0BB/1kCL3UpnE23z7YYSrbyT+1WFftksCRZS6qaL1rT+DZ
         JTvA==
X-Gm-Message-State: AOAM531qH2I0s6KkiHV284PIK1MJhFXa7vZN8l81rri5sUqi0KWhRqyT
        Jf+X3QmjUEqSqLqEph8jalKy8U91kC8=
X-Google-Smtp-Source: ABdhPJyHYl7XfQ9CWfgn6scojmKHCDyQ0NCK65MeCKDE9QcICunXQxxzDtiwRwMHvFgiGczpfUDZYg==
X-Received: by 2002:ab0:4d42:: with SMTP id k2mr3826616uag.10.1603990819076;
        Thu, 29 Oct 2020 10:00:19 -0700 (PDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id 31sm416682uac.10.2020.10.29.10.00.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 10:00:18 -0700 (PDT)
Received: by mail-vs1-f54.google.com with SMTP id h5so1921920vsp.3
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:00:17 -0700 (PDT)
X-Received: by 2002:a67:f88e:: with SMTP id h14mr3212570vso.22.1603990817501;
 Thu, 29 Oct 2020 10:00:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201028184310.7017-1-xie.he.0141@gmail.com> <20201028184310.7017-2-xie.he.0141@gmail.com>
In-Reply-To: <20201028184310.7017-2-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 29 Oct 2020 12:59:40 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdPrkp4AdNkiQNpPxfwwn0X=xzKccKP+oH-ozcorDKD8Q@mail.gmail.com>
Message-ID: <CA+FuTSdPrkp4AdNkiQNpPxfwwn0X=xzKccKP+oH-ozcorDKD8Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/4] net: hdlc_fr: Simpify fr_rx by using
 "goto rx_drop" to drop frames
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

On Wed, Oct 28, 2020 at 6:01 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> When the fr_rx function drops a received frame (because the protocol type
> is not supported, or because the PVC virtual device that corresponds to
> the DLCI number and the protocol type doesn't exist), the function frees
> the skb and returns.
>
> The code for freeing the skb and returning is repeated several times, this
> patch uses "goto rx_drop" to replace them so that the code looks cleaner.
>
> Also add code to increase the stats.rx_dropped count whenever we drop a
> frame.
>
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  drivers/net/wan/hdlc_fr.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
> index 409e5a7ad8e2..c774eff44534 100644
> --- a/drivers/net/wan/hdlc_fr.c
> +++ b/drivers/net/wan/hdlc_fr.c
> @@ -904,8 +904,7 @@ static int fr_rx(struct sk_buff *skb)
>                 netdev_info(frad, "No PVC for received frame's DLCI %d\n",
>                             dlci);
>  #endif
> -               dev_kfree_skb_any(skb);
> -               return NET_RX_DROP;
> +               goto rx_drop;
>         }
>
>         if (pvc->state.fecn != fh->fecn) {
> @@ -963,14 +962,12 @@ static int fr_rx(struct sk_buff *skb)
>                 default:
>                         netdev_info(frad, "Unsupported protocol, OUI=%x PID=%x\n",
>                                     oui, pid);
> -                       dev_kfree_skb_any(skb);
> -                       return NET_RX_DROP;
> +                       goto rx_drop;
>                 }
>         } else {
>                 netdev_info(frad, "Unsupported protocol, NLPID=%x length=%i\n",
>                             data[3], skb->len);
> -               dev_kfree_skb_any(skb);
> -               return NET_RX_DROP;
> +               goto rx_drop;
>         }
>
>         if (dev) {
> @@ -982,12 +979,13 @@ static int fr_rx(struct sk_buff *skb)
>                 netif_rx(skb);
>                 return NET_RX_SUCCESS;
>         } else {
> -               dev_kfree_skb_any(skb);
> -               return NET_RX_DROP;
> +               goto rx_drop;
>         }
>
> - rx_error:
> +rx_error:
>         frad->stats.rx_errors++; /* Mark error */
> +rx_drop:
> +       frad->stats.rx_dropped++;
>         dev_kfree_skb_any(skb);
>         return NET_RX_DROP;

This does change rx_dropped count on errors. Not sure how important
that is. But perhaps good to call out in the commit explicitly if it's
intentional.
