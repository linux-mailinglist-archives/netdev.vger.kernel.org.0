Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E435A21465A
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 16:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgGDOIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 10:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgGDOIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 10:08:54 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2858EC061794;
        Sat,  4 Jul 2020 07:08:54 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id w17so27994411oie.6;
        Sat, 04 Jul 2020 07:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sruIXwAXhVbyB5irGxpmieYBkvT+Yh76sngiyp81DSY=;
        b=bGGfNXswYZe14/cuzAmIfTCOrYwfHvCH4h2te1yO88pI7RbPNA7Czv4reMww8I8SbP
         s7KT5FPP1bFRY4eFbAuO4gaa8m7yQVpHAYj/lMxb4yc97Az2qudXG0cbkRsYUUD3wZoF
         VcfO/PuPPWvtKdkXdSKu7vcI1ir7FriWYlg+YA0IYCfpVJH0UvzY1LXnLM1XgzBP40WZ
         jfTvdG/d7nzvQcNmMNtQZZGcTvo0v8HkU6ccy9hOpu+mYF/Sq7YbmlKkHIMZJk+UZhaH
         yQZa/f4ADWlFCb+UE+CsDdnFeAWIn9DAei37pKrH6P/kqqxK70mAp9uaEyAIA+AGLOPT
         fSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sruIXwAXhVbyB5irGxpmieYBkvT+Yh76sngiyp81DSY=;
        b=opqxa+FgwjmJqkAq856nfqoAgVdogaV50658Qsj9tBg0TB+7jGuFu9v+OkyHv69dZk
         Yl7fa90kDXtefzmPwLOGxCspKyhlDFIdxae9Sfc7EgHEBvSuVJBIOkdsMPERd9fxEu1e
         xaSfILW86HUKQjoDuHFKj4zzKrwnRCZZd+liWB7au2U2kFj7uu7qeKOqd2yNDg8jC5Cp
         BTpLD8iWlNnrDDIuCbIQ8NaU6MV6yYTy7H6qAf8dBLAmNoKzvaqjsHKr5G02DKwxL4yh
         wau5HJYUJXEMUyfXi0Q+H7+w+VwuEyFfcU42p7oLRcjxvT8eMCn9ynD7FZTd1KcjuM13
         pNgA==
X-Gm-Message-State: AOAM533rNVbfuEN2xltMvguTaJ9NoDKRWn7E0NftZRkdlxboxKr2lIxD
        65Y9ld4j0NjkJ/g5G1DVZ61oG9fQrBbM0JNNiEA=
X-Google-Smtp-Source: ABdhPJztoFfvdTLj2yMn1sCGZxmmBOCYmRIuPcHWgshbnsn/EhxPtETALm2xO46URFZ5cicFgCzGhlj5YWM8/IMYuUI=
X-Received: by 2002:aca:b205:: with SMTP id b5mr32722874oif.103.1593871733367;
 Sat, 04 Jul 2020 07:08:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200702175352.19223-1-TheSven73@gmail.com> <20200702175352.19223-3-TheSven73@gmail.com>
 <CAOMZO5DxUeXH8ZYxmKynA7xO3uF6SP_Kt-g=8MPgsF7tqkRvAA@mail.gmail.com>
In-Reply-To: <CAOMZO5DxUeXH8ZYxmKynA7xO3uF6SP_Kt-g=8MPgsF7tqkRvAA@mail.gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Sat, 4 Jul 2020 10:08:42 -0400
Message-ID: <CAGngYiXGXDqCZeJme026uz5FjU56UojmQFFiJ5_CZ_AywdQiEw@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] ARM: imx6plus: optionally enable internal routing
 of clk_enet_ref
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Shawn Guo <shawnguo@kernel.org>, Fugang Duan <fugang.duan@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Fabio, Andy,

On Thu, Jul 2, 2020 at 6:29 PM Fabio Estevam <festevam@gmail.com> wrote:
>
> With the device tree approach, I think that a better place to touch
> GPR5 would be inside the fec driver.
>

Are we 100% sure this is the best way forward, though?

All the FEC driver should care about is the FEC logic block
inside the SoC. It should not concern itself with the way a SoC
happens to bring a clock (PTP clock) to the input of the FEC
logic block - that is purely a SoC implementation detail.

It makes sense to add fsl,stop-mode (= a GPR bit) to the FEC driver,
as this bit is a logic input to the FEC block, which the driver needs
to dynamically flip.

But the PTP clock is different, because it's statically routed by
the SoC.

Maybe this problem needs a clock routing solution?
Isn't there an imx6q plus clock mux we're not modelling?

  enet_ref-o------>ext>---pad_clk--| \
           |                       |M |----fec_ptp_clk
           o-----------------------|_/

Where M = mux controlled by GPR5[9]

The issue here is that pad_clk is routed externally, so its parent
could be any internal or external clock. I have no idea how to
model this in the clock framework.
