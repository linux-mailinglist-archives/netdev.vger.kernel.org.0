Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701E92D89CB
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 20:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501953AbgLLTjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 14:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388996AbgLLTjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 14:39:01 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D5FC0613CF;
        Sat, 12 Dec 2020 11:38:21 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id r17so12043974ilo.11;
        Sat, 12 Dec 2020 11:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ed86JCFkhqrw2FizD1MHvIk0o1cDOKUQ8JXozTaLJU=;
        b=ft+8MdXIhIo7GCkVK1CssvoJTPZaWtMji3R9/E3gOvJ04Oxi+SKjxdnbrjuwcK8Sqq
         KPJy8bW/3GsiGl3nU5Hge87I3PWXXRNrLvIh+ovn+qCbNsOS6wXpta6OpsREFF8tFHtB
         Fy9oc3C1MIEvYNARYNSt1vhgW9+Ntxp9nHQU0MRZrkCPoj67mZZoWov0kP54kicpbgW+
         Ml0truKI/bBkF+DmDWhAPyvd+r8hCKBi2m0wlTFoVPLlN/KRB+0nKabcXAJStJv+gnVz
         YTSTEujrI3xi7Kh/0G/29DSUzA+87BmsKNHxI/SO1VkSDxc8/oMR54MZAMGUIxpenTyB
         Hdrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ed86JCFkhqrw2FizD1MHvIk0o1cDOKUQ8JXozTaLJU=;
        b=ZBVv2xvMPGZdfe77IHmJIYvRF3ahE+G+JOgLAR99S2C1ZxvwYKJ15vd97oLu37DLdG
         kDTGiWS0dAWW8Gwpcc3aoEZE5LjuTiZ/lFSiF2rHhefn+7ruaGSgR0PNjDY/9cZi9yrf
         jYZm8d8zFfYxP2OvCqDJjptl46FqWPcTzpwvCpePHz9m9HUJEw3SsKN5qZfVU7hyUzP0
         ywMprqyxPRFwNDlGUJHS73CYH7dyk6slZbIRNiLihl9B/yeVm7E+tFfLn/iaEgemxBGu
         hnfNYXfForDDB7jsPGsVai1x/DEAKtjMZZpl5Xt8dB5Ry4FYOXe5FwIyy+FJDuSKK6WQ
         EkQA==
X-Gm-Message-State: AOAM532pf6kb6W3BXhu1GirgyZBZlmWSJLYtr2YO8nvsxHbyGSRwtODn
        1wxF3yg1gfwLMmUbd/Q5b0Vb8pdHp10WBodTMvU=
X-Google-Smtp-Source: ABdhPJz3mxXDZcTO4S4g/QokeJ2IJDAIEavfxn/VBpSsZ/zrsgf8VYFVai9TC7JMdt1ZxYFZzT1C9ZM7O5hKhLSeyhE=
X-Received: by 2002:a92:d0c8:: with SMTP id y8mr22783097ila.46.1607801900716;
 Sat, 12 Dec 2020 11:38:20 -0800 (PST)
MIME-Version: 1.0
References: <20201212165648.166220-1-aford173@gmail.com> <7f5f8ef2-3e4f-5076-0558-26b48e75b674@gmail.com>
In-Reply-To: <7f5f8ef2-3e4f-5076-0558-26b48e75b674@gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Sat, 12 Dec 2020 13:38:09 -0600
Message-ID: <CAHCN7xKbcO0-h1mEWe7vZYdJ6bQ8_KzN-MpFRhDbBVpQznAMzg@mail.gmail.com>
Subject: Re: [RFC] ravb: Add support for optional txc_refclk
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Charles Stevens <charles.stevens@logicpd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 11:55 AM Sergei Shtylyov
<sergei.shtylyov@gmail.com> wrote:
>
> Hello!
>
> On 12.12.2020 19:56, Adam Ford wrote:
>
> > The SoC expects the txv_refclk is provided, but if it is provided
> > by a programmable clock, there needs to be a way to get and enable
> > this clock to operate.  It needs to be optional since it's only
> > necessary for those with programmable clocks.
> >
> > Signed-off-by: Adam Ford <aford173@gmail.com>
> [...]
> > diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> > index bd30505fbc57..4c3f95923ef2 100644
> > --- a/drivers/net/ethernet/renesas/ravb_main.c
> > +++ b/drivers/net/ethernet/renesas/ravb_main.c
> > @@ -2148,6 +2148,18 @@ static int ravb_probe(struct platform_device *pdev)
> >               goto out_release;
> >       }
> >
> > +     priv->ref_clk = devm_clk_get(&pdev->dev, "txc_refclk");
>
>     Why not devm_clk_get_optional()?

I am not that familiar with the clock API.  I'll look into that
function. It looks like it makes more sense.  I'll send a V2.

adam
>
> > +     if (IS_ERR(priv->ref_clk)) {
> > +             if (PTR_ERR(priv->ref_clk) == -EPROBE_DEFER) {
> > +                     /* for Probe defer return error */
> > +                     error = PTR_ERR(priv->ref_clk);
> > +                     goto out_release;
> > +             }
> > +             /* Ignore other errors since it's optional */
> > +     } else {
> > +             (void)clk_prepare_enable(priv->ref_clk);
> > +     }
> > +
> >       ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
> >       ndev->min_mtu = ETH_MIN_MTU;
> >
>
> MBR, Sergei
