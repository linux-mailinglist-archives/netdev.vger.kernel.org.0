Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E586215A0E
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 16:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgGFOxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 10:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729323AbgGFOxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 10:53:36 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4665DC061755;
        Mon,  6 Jul 2020 07:53:36 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id w17so31503717oie.6;
        Mon, 06 Jul 2020 07:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GFpfVj0m9GIjBHaPOWNr/J7dthCRMh3m8RTK3vZekkY=;
        b=FG6yNBsdFyaLnOU8mBfBB/Q8Je3J9Eas3f8oj2nCD10CZkPUTBuNVP9U8M+fIaEKb6
         nhKqT8qm22ivfb9lCGijiCLP+VL+cKM0JfVx9i2ziczDfH3cm8b6w9uguuTaPtDYzTGv
         5qgwmBhNs223mkQP+r8ujZc27qYWMSJVJE9BEF5sqYKir+CEr+kerUWXpxslq7sEaZiS
         KNoknGRBZJZz/j7I0NJ7pwrEirrh8rZ3FaRhGRa1hwWSB3pMhyFzZEMXw7LTdHQ6X9Iu
         6DjHGByAClVQs7vBe4bBr5zImS0HpTYSyROQaeG3naIHVNlCV336B1q/uKOP+DGfn77C
         rmbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GFpfVj0m9GIjBHaPOWNr/J7dthCRMh3m8RTK3vZekkY=;
        b=iNpxyx9nAKV1kpdbO2cwXcBokOglOXhK3C4Lyh+dnBdRMIw2j/HAdaYiLhJN+Jt3Gl
         N3+YTM6Kzc8kk6sJsQH50VCn31ViJbrh4Bd2NPfv/cbk0RvKXm/Wl8cSi3jiMLpsKkZV
         mg/eoI902cYuxqYdNtHBxMkrr+vurS8qkqAz1p+qgiwDxzp/4928GtzSMhodKhd97O5T
         j3Pn3Yl9GmoawbCfL9IXxg+q7QnwILS9m5vT6UTBDmh7hqWuuDkC4Nr/VoxekapZm0H/
         /AKGirV+DLwjQRSONJwpUqEjDZkkp7zcWJ+XJe3DBFKOacstJ++QE0mvHuXSjMtFsrgg
         Zu9Q==
X-Gm-Message-State: AOAM5301eSXfjHh4q5aCqcrWELD+mFICYTEwhvHxrs963civW1cNwTKX
        Y6RIpmH1A8U+ym7TUEf6gjFutgFKv+6jOFN6Pl4=
X-Google-Smtp-Source: ABdhPJzJN6n42s0UuWBiB0DP5cE1wqRwiFpGP9kCvAjBsDOjqYQv6xKtCp/mECIcHLh3snyruyuShOQylIS0S7sSex8=
X-Received: by 2002:aca:ecc7:: with SMTP id k190mr34028677oih.92.1594047215580;
 Mon, 06 Jul 2020 07:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200702175352.19223-1-TheSven73@gmail.com> <20200702175352.19223-3-TheSven73@gmail.com>
 <CAOMZO5DxUeXH8ZYxmKynA7xO3uF6SP_Kt-g=8MPgsF7tqkRvAA@mail.gmail.com>
 <CAGngYiXGXDqCZeJme026uz5FjU56UojmQFFiJ5_CZ_AywdQiEw@mail.gmail.com>
 <AM6PR0402MB360781DA3F738C2DF445E821FF680@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <CAGngYiWc8rNVEPC-8GK1yH4zXx7tgR9gseYaopu9GWDnSG1oyg@mail.gmail.com> <AM6PR0402MB36073F63D2DE2646B4F71081FF690@AM6PR0402MB3607.eurprd04.prod.outlook.com>
In-Reply-To: <AM6PR0402MB36073F63D2DE2646B4F71081FF690@AM6PR0402MB3607.eurprd04.prod.outlook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Mon, 6 Jul 2020 10:53:24 -0400
Message-ID: <CAGngYiXY=0Q3MH+F6+5eeUy8-Wh2yNdUc2=fAQ=dZd3N2YaFow@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH v5 3/3] ARM: imx6plus: optionally enable
 internal routing of clk_enet_ref
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Mon, Jul 6, 2020 at 1:30 AM Andy Duan <fugang.duan@nxp.com> wrote:
>
> The clock depends on board design, HW refer guide can describe the clk
> usage in detail and customer select one clk path as their board design.
>

Yes, I agree. But how does a board designer practically describe this
in the devicetree?

Example: mac_gtx -> clk_pad (the default)

Imagine I have a fixed oscillator on the board:

phy_ref_clk: oscillator {
    compatible = "fixed-clock";
    #clock-cells = <0>;
    clock-frequency = <50000000>;
};

How can I now make <&phy_ref_clk> the parent of
<&clks CLK_PAD> ?
