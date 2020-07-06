Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2C62158C9
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 15:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbgGFNqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 09:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbgGFNqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 09:46:38 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10B0C061755;
        Mon,  6 Jul 2020 06:46:37 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id t25so40835051lji.12;
        Mon, 06 Jul 2020 06:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ujWmFeI6Flmp+c/ywUJ1ekXf+PPGZevFkwBhKsOKkZ4=;
        b=tz4jIaQhaEshDqBeV8lgZXacy8neCsIUEtB8PrcSndWYQM09hRLZxtkWLy1+VlciKC
         vpOyb/4xTb/CZM++lUZzllbuM4pr8d8oykqgW20mN3Eww+N7nx7QTzmCs+ZaiTqZNRdl
         Tbr1pMhMm4Ha0iEbtNc5hN2oVAqDhiZPt8mXcKMMBgNIh5VzmT5n9M4YzCNr0j7tMoKE
         uf1+rtAdxiVt9IzqxMC5TyE2UuPVrBdVzbW6+6lT4xRTI/6bX42U/UZZ/gxq08ugrWj2
         Cpb4nVTUQ9mHs+o8mKQDbiXw3hUwHk5c7EkXbbpgB5XtlVXgGct4Ha8CjT9+o90JHFrl
         aACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ujWmFeI6Flmp+c/ywUJ1ekXf+PPGZevFkwBhKsOKkZ4=;
        b=ZgTI8XUxZqO5Aw2IStdTIaK1B3TOaAkFBVel9LcF+6MfoDa+wNqphQNzkl+nVfcslR
         NT+WdJKOgfU5d6vSDlGfiq26Dek031+CJXUxUnK4Jy08e7VqZ7vjbx2C+OVzR+NPjEe5
         aKg2HGd/XN67dz/bH+2E+ljBz0tpWHN0G88qYLRcSzSkE7HI4Xh8tZDXT92DawdAna3j
         f3sioJhscdRZWibl772HPYymWyF12+RVYLUxQLKVlRNfcfS4lhcdzKCwmgvnMQnR0brT
         BZ6crNWbixYyEjkje9ehK/kljDWeUAsKIesTkGiQgVxpnTl0yNTu2gt3yBVTfpAhwRRA
         uZYw==
X-Gm-Message-State: AOAM532YjId119q0uEKyQaYLRHQRIj1y/jQ4MYQZ5fSdhZF/RlA0WRUo
        z0fem8SelTpujEezkcGfpgsGrI7pj3YWjI3KTFo=
X-Google-Smtp-Source: ABdhPJxz5qKFA+dIJPADY0uxRaQOwVIv39lIoqD9qN87qufLAZPHvz+99eupHYq3qWL41O33rJVFQF5KF1C6m+TF8L0=
X-Received: by 2002:a2e:808d:: with SMTP id i13mr24444142ljg.452.1594043196179;
 Mon, 06 Jul 2020 06:46:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200702175352.19223-1-TheSven73@gmail.com> <20200702175352.19223-3-TheSven73@gmail.com>
 <CAOMZO5DxUeXH8ZYxmKynA7xO3uF6SP_Kt-g=8MPgsF7tqkRvAA@mail.gmail.com>
 <CAGngYiXGXDqCZeJme026uz5FjU56UojmQFFiJ5_CZ_AywdQiEw@mail.gmail.com>
 <AM6PR0402MB360781DA3F738C2DF445E821FF680@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <CAGngYiWc8rNVEPC-8GK1yH4zXx7tgR9gseYaopu9GWDnSG1oyg@mail.gmail.com> <AM6PR0402MB36073F63D2DE2646B4F71081FF690@AM6PR0402MB3607.eurprd04.prod.outlook.com>
In-Reply-To: <AM6PR0402MB36073F63D2DE2646B4F71081FF690@AM6PR0402MB3607.eurprd04.prod.outlook.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 6 Jul 2020 10:46:24 -0300
Message-ID: <CAOMZO5ATv9o197pH4O-7DV-ftsP7gGVuF1+r-sGd2j44x+n-Ug@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH v5 3/3] ARM: imx6plus: optionally enable
 internal routing of clk_enet_ref
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
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

On Mon, Jul 6, 2020 at 2:30 AM Andy Duan <fugang.duan@nxp.com> wrote:
>
> From: Sven Van Asbroeck <thesven73@gmail.com> Sent: Sunday, July 5, 2020 11:34 PM
> >
> >   ext phy---------| \
> >                   |  |
> >   enet_ref-o------|M |----pad------| \
> >            |      |_/              |  |
> >            |                       |M |----mac_gtx
> >            |                       |  |
> >            o-----------------------|_/
> >
> >
> > How do we tell the clock framework that clk_pad has a mux that can be
> > connected to _any_ external clock? and also enet_ref?
>
> The clock depends on board design, HW refer guide can describe the clk
> usage in detail and customer select one clk path as their board design.
>
> To make thing simple, we can just control the second "M" that is controlled
> by gpr bit.

Would it make sense to use compatible = "mmio-mux"; like we do on
imx7s, imx6qdl.dtsi and imx8mq.dtsi?
