Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97525215A1B
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 16:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgGFO6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 10:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729224AbgGFO6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 10:58:12 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37358C061755;
        Mon,  6 Jul 2020 07:58:12 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id 95so21229766otw.10;
        Mon, 06 Jul 2020 07:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0AQx4ILLvVzJy8XIP/Y7mxc5IgoWZcwRZZKrUnYA8Tc=;
        b=GxaaLVUv2OEBe5fB1eBXiUEVxmGUoDle+PeupjIzb1dnLK8f8gW3TR3FDVBkTc4wsL
         NSvTfXPSIEV+tRvQ+IUPty7CVJrS1oKFtpvCD3mDOBGFUTjuAZVoW4ZGurGl6C+gS4/U
         sZvrJRff1z50bF1krucG91qwO5xKF2iPIxnURK/f4AN9/BdkcetQKoOSIIsP4a7LkB/f
         3t3FgYr3tpsFC5xRCb3NBjkTu0DGnDqsB8MK5CelpxlpHaCaYyBktkGOcYS01IsoksUP
         JmuhoSF3XASteXvW1LcvZx9yNRaIx7uxTUCq5pbMvfCG8xJbRsGbd+BgcVruH4nz9JVJ
         x6Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0AQx4ILLvVzJy8XIP/Y7mxc5IgoWZcwRZZKrUnYA8Tc=;
        b=nbbIiyGPHAlILa/YBEVunvgX7+7TKzjUPm5UZVjGHv8PjOBDYT14waYi+GrDl5NmxB
         wXn8lz7hQvcARacqq21x2+IY3fWnKMzcEGDgnNA6aiMncAeLxLh+GwYGmmgtiz0qtXU4
         bjLIVHkDd/jNZ9uCSYCCeADdvcwri2PGvV7ftpirQeL3weNxm7g+CrxXSbtFuuu69IA5
         /nKHftuQOyElxxkDfHiPNaUaoZ0Pr1NBzuqWRKCCKYe2OI9kNs/2wfxODgWbPTKhsbe3
         yilK6pKuyny8oCtNjwUnak+ueYGl2Ubh0aCxS47aZo1UdeWkvFlZQPUs8C4+EJym/xq1
         XaIg==
X-Gm-Message-State: AOAM531Hjd/qs4CMduyU7KerT1cwvdcldAlCpF7On8kDYyintFdI8tYY
        Ov2bz9hYScq0x7K3pHZkxRrBcAMktoqmIkNK3GJ+dhMv
X-Google-Smtp-Source: ABdhPJxKqJnossusAHMInEeVexkQKjxH68XgV3YATMgYQ+8o6YTE/YjHuzn3u/sTPHzvkHN3MCBzhw8QHonvJV2NooM=
X-Received: by 2002:a9d:2c26:: with SMTP id f35mr43698324otb.232.1594047491587;
 Mon, 06 Jul 2020 07:58:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200702175352.19223-1-TheSven73@gmail.com> <20200702175352.19223-3-TheSven73@gmail.com>
 <CAOMZO5DxUeXH8ZYxmKynA7xO3uF6SP_Kt-g=8MPgsF7tqkRvAA@mail.gmail.com>
 <CAGngYiXGXDqCZeJme026uz5FjU56UojmQFFiJ5_CZ_AywdQiEw@mail.gmail.com>
 <AM6PR0402MB360781DA3F738C2DF445E821FF680@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <CAGngYiWc8rNVEPC-8GK1yH4zXx7tgR9gseYaopu9GWDnSG1oyg@mail.gmail.com>
 <AM6PR0402MB36073F63D2DE2646B4F71081FF690@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <CAOMZO5ATv9o197pH4O-7DV-ftsP7gGVuF1+r-sGd2j44x+n-Ug@mail.gmail.com>
In-Reply-To: <CAOMZO5ATv9o197pH4O-7DV-ftsP7gGVuF1+r-sGd2j44x+n-Ug@mail.gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Mon, 6 Jul 2020 10:58:00 -0400
Message-ID: <CAGngYiVeNQits4CXiXmN2ZBWyoN32zqUYtaxKCqwtKztm-Ky8A@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH v5 3/3] ARM: imx6plus: optionally enable
 internal routing of clk_enet_ref
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Andy Duan <fugang.duan@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
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

Hi Fabio,

On Mon, Jul 6, 2020 at 9:46 AM Fabio Estevam <festevam@gmail.com> wrote:
>
> Would it make sense to use compatible = "mmio-mux"; like we do on
> imx7s, imx6qdl.dtsi and imx8mq.dtsi?

Maybe "fixed-mmio-clock" is a better candidate ?
