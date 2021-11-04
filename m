Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF194450ED
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 10:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhKDJPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 05:15:18 -0400
Received: from mail-ua1-f48.google.com ([209.85.222.48]:43682 "EHLO
        mail-ua1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhKDJPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 05:15:17 -0400
Received: by mail-ua1-f48.google.com with SMTP id v3so9529967uam.10;
        Thu, 04 Nov 2021 02:12:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VwSciq2dX0/2ZCTgtxnNVSoNv/2aephQkEPPnAPTvsc=;
        b=lB4bGups8iJWGDK4ghBf1Kx2SoM+yjFMVmeIs5lMctPhFLmm6gIaqBmM71hGZ7b59c
         hC0xvnDLZ0cmsG4AKEJCus+4IGm/kXCpRfqcXYJfA3V0U5H5H26Gyq98xaYLHH2jIpCN
         VXRD++thtaI5K1fNp44YJwvMQ1NfmxHYjVagI1opeBFVIIEQkmAK+KTHOpa9dbu2w1fO
         ZnZWv0+KwMFaCR3ft/R2ZuAj8z310cwkaapFyBMSiGSSgHRRpV0MSxofk9a+y5MoEUEJ
         oofyLGPWxeBeX5KJSpgMzv+1LnHOfMLBQnfEshJ4dERbUECnQDFMh6MclkavxFrnt2ou
         KjKA==
X-Gm-Message-State: AOAM5315b+dGv3zCyptdk0kP3ifDHRHvC+CsvVfX51uDvOV2sC4Thh2i
        tIm6szSl/Nh9gNbb5/0whG2efZWaNl9zXw==
X-Google-Smtp-Source: ABdhPJyrEmhcIuHvV8xSEsTcfM+f39xbkRZofS8VDaOpFnZ7cTN+grRoPYC9eRxAZwJLlXfvOF80KA==
X-Received: by 2002:a67:2fd0:: with SMTP id v199mr46128793vsv.35.1636017159382;
        Thu, 04 Nov 2021 02:12:39 -0700 (PDT)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id v4sm757393vsq.7.2021.11.04.02.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 02:12:38 -0700 (PDT)
Received: by mail-ua1-f50.google.com with SMTP id v3so9529827uam.10;
        Thu, 04 Nov 2021 02:12:38 -0700 (PDT)
X-Received: by 2002:ab0:2bd2:: with SMTP id s18mr54221819uar.78.1636017158102;
 Thu, 04 Nov 2021 02:12:38 -0700 (PDT)
MIME-Version: 1.0
References: <1635933244-6553-1-git-send-email-volodymyr.mytnyk@plvision.eu>
In-Reply-To: <1635933244-6553-1-git-send-email-volodymyr.mytnyk@plvision.eu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 4 Nov 2021 10:12:26 +0100
X-Gmail-Original-Message-ID: <CAMuHMdU9jRtsQhHHVDrJ8ZBLO1bSOuEo-haJ2PwMcYmMfnOXgA@mail.gmail.com>
Message-ID: <CAMuHMdU9jRtsQhHHVDrJ8ZBLO1bSOuEo-haJ2PwMcYmMfnOXgA@mail.gmail.com>
Subject: Re: [PATCH net v2] net: marvell: prestera: fix hw structure laid out
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        mickeyr@marvell.com, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Volodymyr,

On Wed, Nov 3, 2021 at 10:56 AM Volodymyr Mytnyk
<volodymyr.mytnyk@plvision.eu> wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
>
> - fix structure laid out discussed in:
>     [PATCH net-next v4] net: marvell: prestera: add firmware v4.0 support
>     https://www.spinics.net/lists/kernel/msg4127689.html
>
> - fix review comments discussed in:
>     [PATCH] [-next] net: marvell: prestera: Add explicit padding
>     https://www.spinics.net/lists/kernel/msg4130293.html
>
> - fix patchwork issues
> - rebase on net master
>
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0 support")
> Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>

Thanks for your patch!

> --- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c

>  struct prestera_msg_port_flood_param {
>         u8 type;
>         u8 enable;
> -};
> +       u8 __pad[2];
> +} __packed;

What's the point of having __packed on a struct of bytes?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
