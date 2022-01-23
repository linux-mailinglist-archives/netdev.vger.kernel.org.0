Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A94B497588
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 21:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240096AbiAWUnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 15:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240057AbiAWUne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 15:43:34 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC49C06173B;
        Sun, 23 Jan 2022 12:43:34 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id j5-20020a05600c1c0500b0034d2e956aadso26251749wms.4;
        Sun, 23 Jan 2022 12:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/r6am+3N6osUA/Dj/zZE3T0O61T+nuhMcTokJz7x4t4=;
        b=F74q1ACftHexnodeBoYFJHTwiP+7EOpoGurC+YX6RANADb7BRaqgAOXx40HPiX330p
         /blP5JOz16HVHXI1Tvq8pLvNVKEkDjiQHZFXYtuvy2zgPVzwC/BUCzyky4OFj106rtPn
         smc/gu7qXdMZGVepK/8bcc4SItDEOvBL6Ye/FNpGHlHEjowftG1g+r89OfHxglZdQ19z
         dsGnKGE0e+Tc27AxXT/kaXPPei7PNkMGXcS+9/LED/WsoWi+PWI36E6qobIlJY9ttfSG
         JnNVYsM+rENONcokLm0Ae+bqaR2vR28Q+xvXRCX+giHVWSxWgT3w71LUTqe+LcKVL4ZS
         9QxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/r6am+3N6osUA/Dj/zZE3T0O61T+nuhMcTokJz7x4t4=;
        b=s2s5ObxHeef45Vxvvmx6cTIqWbeDe+gFDTwetmzw58NIdJuR+0UgH/bAHz2itXUdUP
         RkCEe7EwfW7oPUj7nE8q+HAYOCh17EJ0xO57wii3xL2hqEGesSP/QfvfTF8V4tfyU2Cy
         bnSfdMGxVQdpMUtomGjrANWGTpZPZlW0ivM9uy6wqsj4fszJqEkVCFZnB+RNjJIy2NgU
         jHc6MnZVQulMYrG7SJXyi9CaYdUaA8C5tDe5kzc24RKuELp0hKQmDvHo4LV1bDaT2Atq
         dry35+x2fhKrVylLn9kZXbZroD/QgNbAdqIEW3HQwNbpQobQRxyPsS8x1qsebsfQZW/Z
         HtBQ==
X-Gm-Message-State: AOAM530j46dyjzXjWOQXNRKdb1xwXtkZDav3dwpoNiQUSOkh9IMxCCzt
        nqCb+aIORk2gnq+Hbfv4R+tPOn+tc71d2PpQpDw=
X-Google-Smtp-Source: ABdhPJxD6EAlgI2Bh9T88FoM41kBM7KAX0HZGuE11nCud0zVPMsm/hzzAf/qanvJFWiNyXLqYERyqjiHqPTaZ6Dyhb8=
X-Received: by 2002:a05:600c:2052:: with SMTP id p18mr1853060wmg.178.1642970613048;
 Sun, 23 Jan 2022 12:43:33 -0800 (PST)
MIME-Version: 1.0
References: <20220120112115.448077-1-miquel.raynal@bootlin.com> <20220120112115.448077-5-miquel.raynal@bootlin.com>
In-Reply-To: <20220120112115.448077-5-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 23 Jan 2022 15:43:21 -0500
Message-ID: <CAB_54W721DFUw+qu6_UR58GFvjLxshmxiTE0DX-DNNY-XLskoQ@mail.gmail.com>
Subject: Re: [wpan-next v2 4/9] net: ieee802154: at86rf230: Stop leaking skb's
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Upon error the ieee802154_xmit_complete() helper is not called. Only
> ieee802154_wake_queue() is called manually. We then leak the skb
> structure.
>
> Free the skb structure upon error before returning.
>
> There is no Fixes tag applying here, many changes have been made on this
> area and the issue kind of always existed.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/net/ieee802154/at86rf230.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
> index 7d67f41387f5..0746150f78cf 100644
> --- a/drivers/net/ieee802154/at86rf230.c
> +++ b/drivers/net/ieee802154/at86rf230.c
> @@ -344,6 +344,7 @@ at86rf230_async_error_recover_complete(void *context)
>                 kfree(ctx);
>
>         ieee802154_wake_queue(lp->hw);
> +       dev_kfree_skb_any(lp->tx_skb);

as I said in other mails there is more broken, we need a:

if (lp->is_tx) {
        ieee802154_wake_queue(lp->hw);
        dev_kfree_skb_any(lp->tx_skb);
        lp->is_tx = 0;
}

in at86rf230_async_error_recover().

Thanks.

- Alex
