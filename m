Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A978A29F302
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgJ2RY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgJ2RY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:24:26 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E671C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:24:26 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id b129so1971175vsb.1
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=do61rsM4GwzXoI90CK0QdYPHtZr409f2iOnTWSbjtRE=;
        b=BE19bXcnjjj/ywvtsgpJ98BIPYD0s0YhZ4DS8LEgTe9iBAX5+MgyMc8NNIlfgjtN1n
         Qp2w+ZyUgqC9q7dnCtnG1wWvb8mLvtkZUY4LtesfY9uXkL5iSIVY9IclzMJ1QIAq0tTq
         zrTEE3ikmR9Wk9tASsejJMJWWIkw+KIpOnS0NB/atujWHtrulYNt0xwBHTTO8wAQ53Lv
         WbV2J3aEzkKLgQlGgbdb0sUarJpXHCj0bc14HVORs9NkHec+GMbkfthrVMcjb9AVF9h5
         p6Z4LUf3RSOfLQiI3JDMHXpgDxGqtoYZioYBjvydrw1kHL9agyPERmlWtDz5xZOW4NO/
         01Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=do61rsM4GwzXoI90CK0QdYPHtZr409f2iOnTWSbjtRE=;
        b=OiUItUVA8dvoheWRO+uZ0efF5u3y0QZE5rJGLyHlCsA/gfa08Tx7Qlh2nTszbh47cE
         97rQk9slqkAy8Xr1qu/WO/tStWHG6a3F4g9V6+Mnapux9njMosejr7wq7ZsCqG4RPu8l
         gaLY3moQdKdRlix5AsTDw7ehlMUwW29OrRcLgZnr38sTokgdgoxbHyAweuA+AzJHL1RY
         9ZmhdGRZ1Zhmv6QasTKUmSmqXJSccg47TB0zUMcmAPyvUAomz+xJai0HOEox6XI3IQHP
         s+XLwNvg1mPQJ+oB69tSw/m31NI2zg3LZC8Meh8e7Tv6XirIgOozwFI+fiOovnf0URd6
         tvug==
X-Gm-Message-State: AOAM5329lcrgpr0HkzRby267Hdwil9qnXEpbJFnezFA0x7U1adRJsazq
        0hBrUPovkATvO4NQ+30XdO9EYJyJaZs=
X-Google-Smtp-Source: ABdhPJyM+eAgcm3M+fJIggGccRdxpm1WeEsu5nkp/A6b6ifxQ65+Wz4wgfcoS71Vn4iULODCY8Mq6A==
X-Received: by 2002:a67:310d:: with SMTP id x13mr2825992vsx.19.1603992264826;
        Thu, 29 Oct 2020 10:24:24 -0700 (PDT)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com. [209.85.217.48])
        by smtp.gmail.com with ESMTPSA id 190sm413176vsz.13.2020.10.29.10.24.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 10:24:24 -0700 (PDT)
Received: by mail-vs1-f48.google.com with SMTP id u7so1934943vsq.11
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:24:23 -0700 (PDT)
X-Received: by 2002:a67:c981:: with SMTP id y1mr4130116vsk.14.1603992263354;
 Thu, 29 Oct 2020 10:24:23 -0700 (PDT)
MIME-Version: 1.0
References: <20201028131807.3371-1-xie.he.0141@gmail.com> <20201028131807.3371-5-xie.he.0141@gmail.com>
In-Reply-To: <20201028131807.3371-5-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 29 Oct 2020 13:23:46 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeBZWsy4w4gdPU2sb2-njuEiqbXMgfnA5AdsXkNr__xRA@mail.gmail.com>
Message-ID: <CA+FuTSeBZWsy4w4gdPU2sb2-njuEiqbXMgfnA5AdsXkNr__xRA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/4] net: hdlc_fr: Add support for any Ethertype
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

On Wed, Oct 28, 2020 at 6:58 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> Change the fr_rx function to make this driver support any Ethertype
> when receiving skbs on normal (non-Ethernet-emulating) PVC devices.
> (This driver is already able to handle any Ethertype when sending.)
>
> Originally in the fr_rx function, the code that parses the long (10-byte)
> header only recognizes a few Ethertype values and drops frames with other
> Ethertype values. This patch replaces this code to make fr_rx support
> any Ethertype. This patch also creates a new function fr_snap_parse as
> part of the new code.
>
> Also add skb_reset_mac_header before we pass an skb (received on normal
> PVC devices) to upper layers. Because we don't use header_ops for normal
> PVC devices, we should hide the header from upper layer code in this case.

This should probably be a separate commit

> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  drivers/net/wan/hdlc_fr.c | 76 ++++++++++++++++++++++++++-------------
>  1 file changed, 51 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
> index 3639c2bfb141..e95efc14bc97 100644
> --- a/drivers/net/wan/hdlc_fr.c
> +++ b/drivers/net/wan/hdlc_fr.c
> @@ -871,6 +871,45 @@ static int fr_lmi_recv(struct net_device *dev, struct sk_buff *skb)
>         return 0;
>  }
>
> +static int fr_snap_parse(struct sk_buff *skb, struct pvc_device *pvc)
> +{
> +       /* OUI 00-00-00 indicates an Ethertype follows */
> +       if (skb->data[0] == 0x00 &&
> +           skb->data[1] == 0x00 &&
> +           skb->data[2] == 0x00) {
> +               if (!pvc->main)
> +                       return -1;
> +               skb->dev = pvc->main;
> +               skb->protocol = *(__be16 *)(skb->data + 3); /* Ethertype */

Does it make sense to define a struct snap_hdr instead of manually
casting all these bytes?

> +               skb_pull(skb, 5);
> +               skb_reset_mac_header(skb);
> +               return 0;
> +
> +       /* OUI 00-80-C2 stands for the 802.1 organization */
> +       } else if (skb->data[0] == 0x00 &&
> +                  skb->data[1] == 0x80 &&
> +                  skb->data[2] == 0xC2) {
> +               /* PID 00-07 stands for Ethernet frames without FCS */
> +               if (skb->data[3] == 0x00 &&
> +                   skb->data[4] == 0x07) {


And macros or constant integers to self document these kinds of fields.
