Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63DE69E2B6
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 15:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbjBUOwK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Feb 2023 09:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbjBUOwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 09:52:08 -0500
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EC92B61C;
        Tue, 21 Feb 2023 06:52:02 -0800 (PST)
Received: by mail-qv1-f44.google.com with SMTP id ff4so5045469qvb.2;
        Tue, 21 Feb 2023 06:52:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WSlt8RgFBsoWMBHQKRt7mco4LDvQe0nvEXzQx/tM6Uo=;
        b=eYL67J4Ocv3W7MMBrzLP1L9GdqbyUOKUsdO2ImDpBmSO9aeuRaNjFvRNUvM044OFC6
         H7hkWIMgz9AJIYZYTyAPWZ7PKuzTmJ3vMIpFhgz7yHeR4L7UMo2Jd9zQgQiobGi/PQtd
         CzYfql3KuGLznsjVquj8+6vpU9iCKhgvekZQzA1scI7MDFGv8bUv0csi0beenxxDwfYu
         s0jTrieI8v1XmHnlyk/9ekAcu+8JP+ewfit2lmWi1Aaj8LgTSFAMUnxU28fG6bNP++tr
         MMLACcBQP0nZo+Ogt/S+Xm/FjCzKaoN/PMh8IlIJh+w7FKLfwerAv4unnJzYM3JUDexI
         L/sw==
X-Gm-Message-State: AO0yUKVvuLY36S6pN8P8HIGEuZxAkyVp5DSLDpv2X50knYl6256RXy1V
        mrqGoUO1+6zKJJ59WzKZRQ42iiNGPWT0og==
X-Google-Smtp-Source: AK7set8dQaRitHt4wsaXJL81rtVH5tAfe/v2MJMCYn8ypwPznFRow+TFfBCmDvS922grgQN2Qnc7+A==
X-Received: by 2002:a05:6214:ac6:b0:56e:a34c:d3c0 with SMTP id g6-20020a0562140ac600b0056ea34cd3c0mr11729801qvi.15.1676991121148;
        Tue, 21 Feb 2023 06:52:01 -0800 (PST)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id 138-20020a370a90000000b00706b09b16fasm852160qkk.11.2023.02.21.06.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 06:52:01 -0800 (PST)
Received: by mail-yb1-f181.google.com with SMTP id i7so5539816ybu.6;
        Tue, 21 Feb 2023 06:52:00 -0800 (PST)
X-Received: by 2002:a81:d351:0:b0:536:e16d:23ea with SMTP id
 d17-20020a81d351000000b00536e16d23eamr135830ywl.526.1676990739146; Tue, 21
 Feb 2023 06:45:39 -0800 (PST)
MIME-Version: 1.0
References: <20230209151632.275883-1-clement.leger@bootlin.com> <20230209151632.275883-6-clement.leger@bootlin.com>
In-Reply-To: <20230209151632.275883-6-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 Feb 2023 15:45:27 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWYkEN90MuKvexWnNZKajJ-yee77TMrYSUjC2VzW5gZhw@mail.gmail.com>
Message-ID: <CAMuHMdWYkEN90MuKvexWnNZKajJ-yee77TMrYSUjC2VzW5gZhw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 5/6] net: stmmac: add support for RZ/N1 GMAC
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

On Thu, Feb 9, 2023 at 4:14 PM Clément Léger <clement.leger@bootlin.com> wrote:
> Add support for Renesas RZ/N1 GMAC. This support uses a custom PCS (MIIC)
> which is handle by parsing the pcs-handle device tree property.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Thanks for your patch!

> --- /dev/null
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rzn1.c

> +static int rzn1_dwmac_remove(struct platform_device *pdev)
> +{
> +       struct rzn1_dwmac *dwmac = get_stmmac_bsp_priv(&pdev->dev);
> +       int ret = stmmac_dvr_remove(&pdev->dev);

This needs an update for commit ff0011cf56014b4d ("net: stmmac: Make
stmmac_dvr_remove() return void") in net-next/master.

> +
> +       if (dwmac->pcs)
> +               miic_destroy(dwmac->pcs);
> +
> +       return ret;
> +}

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
