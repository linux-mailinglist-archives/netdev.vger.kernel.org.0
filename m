Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1262130A1
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 02:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgGCAvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 20:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgGCAvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 20:51:11 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6F8C08C5C1;
        Thu,  2 Jul 2020 17:51:11 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id 12so18698141oir.4;
        Thu, 02 Jul 2020 17:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cLLLMZUR/6NcDoIAUKZCfeEO4cTwXIXp/IGipSTCgM8=;
        b=GwQaxRGCbnasx8DWiHFhDlrwzmWBOHcGheJtKYUqjVVyFtfbKusmoontyMuHgAOfaP
         o4SV+UDvZzHnj+lJN4NppeSVXutG3t51HIceKc4RT9lcnI4udody5Pdk8jPRFfY9htJ8
         iY5qtSY+20XTzfWAb5w30z7Yq2RdmZAD6otOFQo6rWPri9NZ9CnCZZ7KZ26bgJyzoyoO
         I+DlI561Wa27wG4kEgWb4CHc7ey71nz/0YdBhp1xhHrbsq4Otlr+RU9ZyCyJDHN7F277
         NMXH1Z3a6FbofPm8MKnb+5g02JfKfk2X0XLY/fdTR4Yq+zniOu1q/qe6R+YNx8TAHVcp
         ckWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cLLLMZUR/6NcDoIAUKZCfeEO4cTwXIXp/IGipSTCgM8=;
        b=X7R5SoBTb/urthC3iAWWFWylIr3iyrvwhpJZ1sO6L71y8KS4ZUZkOo4xytJFi3E/58
         yQOPbyfcRvD5irorFkaTbgqhA4M4kg51iwM7cRY8GrsXosh7JjfoR2prz6Y3nC9Gczq+
         NlRiEprVGTe3g0ctnPsOTcdDI4EP53S0DDGG+N7z7dUYcq8/GZFO2AslkVCbhXkU8zj0
         N6JQOBUCyRhZeVcu/VM2YUfH60PGv1SCN90XBIbs9adtr8f2H+r0IzmBJQmuecV0oHBB
         a8CG9LzevkxKrhgyy7tgmJL5sd0aaO3G2ZPIjcAwwURaa91tMP9N8yguHW1t747lqLN9
         aF4g==
X-Gm-Message-State: AOAM533o4rgntvvuHdyJYcpOaCrRhhMMyjsAr8h7n/LiVfOVrv0iAdny
        4knX/cF4njX7BN82U+Sc5no4bOQeZTAxcgVHQyU=
X-Google-Smtp-Source: ABdhPJy61q3Idfrag2OeVEA2neP+3T4xxQKco9bEs1E0DjbYJOa8bO6QRIyg9Ssc31gOmEgKy1boa6OKXkw8U9LJzIk=
X-Received: by 2002:aca:b205:: with SMTP id b5mr27298242oif.103.1593737470608;
 Thu, 02 Jul 2020 17:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200702175352.19223-1-TheSven73@gmail.com> <20200702175352.19223-3-TheSven73@gmail.com>
 <CAOMZO5DxUeXH8ZYxmKynA7xO3uF6SP_Kt-g=8MPgsF7tqkRvAA@mail.gmail.com>
In-Reply-To: <CAOMZO5DxUeXH8ZYxmKynA7xO3uF6SP_Kt-g=8MPgsF7tqkRvAA@mail.gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 2 Jul 2020 20:50:59 -0400
Message-ID: <CAGngYiUEx98QUAHrzFNWzMr5+oPS4-7Nqq91JzhtzGUG7=kagQ@mail.gmail.com>
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

Hi Fabio,

On Thu, Jul 2, 2020 at 6:29 PM Fabio Estevam <festevam@gmail.com> wrote:
>
> With the device tree approach, I think that a better place to touch
> GPR5 would be inside the fec driver.
>

Cool idea. I notice that the latest FEC driver (v5.8-rc3) accesses individual
bits inside the gpr (via fsl,stop-mode). So perhaps I can do the same here,
and populate that gpr node in imx6qp.dtsi - because it doesn't exist on other
SoCs.

> For the property name, what about fsl,txclk-from-pll?

Sounds good. Does anyone have more suggestions?
