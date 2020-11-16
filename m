Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572132B5246
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 21:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732118AbgKPUQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 15:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729248AbgKPUQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 15:16:26 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0769C0613CF;
        Mon, 16 Nov 2020 12:16:26 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id t18so8970741plo.0;
        Mon, 16 Nov 2020 12:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hn+QJJDM3c7nvolPdWtjfb/V2c3QL8eTTV7HryUasbo=;
        b=cdi3E7QjT4b66BWeXGUrBBDZIbJKQThCrL0W53RsvoMm2a//jNUHh6pHiaqvJS2Kbe
         RpOAetEqtWzyq1iRqCD/LSGNh3xOlU15idieIZFU/HnTxSkVpaUcNZkfs4zqI5ThbJet
         6iyFT7NhPHEQgiGPo1ig97kjlx6iyEWl3u/afLJV3y2/vX9MTnpY0f6rhq4hm1+9jypK
         1xYLZSCNr5SrSj1fxWx5uDqLIAW0l+DEkNXJuTW0cpjUDRcg4yTrGBDBFMh5vG+pY2wP
         N70HazL0C5Id+NrpmoQLKweS99qytySxUHrMuGBFg+HQhMtPA0Z80V1uMpgYlLCNhCDh
         IbiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hn+QJJDM3c7nvolPdWtjfb/V2c3QL8eTTV7HryUasbo=;
        b=nMTli9p665STwWCustCMThqOOK2Evqi0dk6PHtp8VnP1OTht/GUQjDGD/RGf9NhWO5
         GCHCGpymyUF3GA6oaVNiGtk0Le4wgNfxU1p0Ofxuq+tdVES1Q7hjxTqY2nK9XyJzh1FA
         pWLJal6n0lDQjsWJqvvC810l8bgRFf18a+/V2tnI92frm2CpX8RIcfM7gu01P7Hkd+x7
         +cH2Y/9EBXU6qfvFjBbYMS8q5DnYzajAT15e7+Cm/BrgUne4c/ILnNcUp4Sk0rgoSaWT
         q5RN63/IncftljitKbwTvVWU+Gfd84k+NVJwIN6WMiYhNr9CEGxplYH+IMnWn8yYpVQ4
         vXUQ==
X-Gm-Message-State: AOAM531ZwB1auMbAeb1buviiBMdUjcEquA5Z/YTErv9zHqbpz8Pe3rpF
        Y/gnn3NVCfEgMEwPfxWV5jM4eD5/PpM0v+brEWQ=
X-Google-Smtp-Source: ABdhPJyL+y1xH5sr2TKEBqm0M4D0KAnaF4ZjERv2Fle2d3KauMybjjPrfwBbv9G8STA3C9Q3NkrfXbybTkDEc0y8740=
X-Received: by 2002:a17:902:9890:b029:d8:e265:57ae with SMTP id
 s16-20020a1709029890b02900d8e26557aemr9905692plp.78.1605557786241; Mon, 16
 Nov 2020 12:16:26 -0800 (PST)
MIME-Version: 1.0
References: <20201116135522.21791-1-ms@dev.tdt.de> <20201116135522.21791-6-ms@dev.tdt.de>
In-Reply-To: <20201116135522.21791-6-ms@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 16 Nov 2020 12:16:15 -0800
Message-ID: <CAJht_EM-ic4-jtN7e9F6zcJgG3OTw_ePXiiH1i54M+Sc8zq6bg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 5/6] net/lapb: support netdev events
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 6:01 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> This makes it possible to handle carrier loss and detection.
> In case of Carrier Loss, layer 2 is terminated
> In case of Carrier Detection, we start timer t1 on a DCE interface,
> and on a DTE interface we change to state LAPB_STATE_1 and start
> sending SABM(E).

> +                               lapb_dbg(0, "(%p): Carrier detected: %s\n",
> +                                        dev, dev->name);
> +                               if (lapb->mode & LAPB_DCE) {
> +                                       lapb_start_t1timer(lapb);
> +                               } else {
> +                                       if (lapb->state == LAPB_STATE_0) {
> +                                               lapb->state = LAPB_STATE_1;
> +                                               lapb_establish_data_link(lapb);
> +                                       }
> +                               }

Do you mean we will now automatically establish LAPB connections
without upper layers instructing us to do so?

If that is the case, is the one-byte header for instructing the LAPB
layer to connect / disconnect no longer needed?
