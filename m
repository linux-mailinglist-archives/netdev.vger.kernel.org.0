Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127FE6D4FD9
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbjDCSBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjDCSBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:01:24 -0400
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A55F3AAF;
        Mon,  3 Apr 2023 11:01:12 -0700 (PDT)
Received: by mail-ot1-f52.google.com with SMTP id r17-20020a05683002f100b006a131458abfso13500844ote.2;
        Mon, 03 Apr 2023 11:01:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680544871;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n+2HyVBZpgIAk4A8UQ7TPXHjOeuEm1wa0e7V0v5arzY=;
        b=D+mf2KUY3Qb17H/BgD9gHZYhHxG91N05+An1M6TiE7loZwLVgRwbAMzGi2kftDTkY/
         0yi+UJ2D4D3sdyPupBNvviknCfiuCDrKMEuMTxWw7aUWAjWbuZaCv2QwIuE3kphjsBtj
         2/zIc5yUSgLl4QzlhtI/FNlA972TQnZsQPYrYm9rhHXMb3IfDntWygpZBV79QgLVCKJi
         qzYjDcz4hnXrxoPBbbfLjPeyGxsfD5IL82eioISgLkENqmVMDHQky8edGiybVS4CRTdl
         5Wjygu+wcQ55wLmbcCrHJwJTlCNY7Xnlw8fx+LVMhfX74/Pe3Gk65/OEiDpqL0w957eJ
         d8xA==
X-Gm-Message-State: AAQBX9cN3Iyc5deHrM9QlrX3Fp5boWC+ajKyrvG4STstCUMXXgIEXaEc
        PuDdizaw9orhQzHXAtrhAA==
X-Google-Smtp-Source: AKy350YbposOHjUqSKPLp1r0c5pZmS2vrYBOO8PRSBJMRbIsZ8g5xLashYmoygD9IWOODdA8MPrzFQ==
X-Received: by 2002:a9d:63c5:0:b0:697:a381:a8f8 with SMTP id e5-20020a9d63c5000000b00697a381a8f8mr41722otl.3.1680544871315;
        Mon, 03 Apr 2023 11:01:11 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id d11-20020a9d5e0b000000b006a3170fe3efsm2707835oti.27.2023.04.03.10.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 10:59:56 -0700 (PDT)
Received: (nullmailer pid 1164679 invoked by uid 1000);
        Mon, 03 Apr 2023 17:59:39 -0000
Date:   Mon, 3 Apr 2023 12:59:39 -0500
From:   Rob Herring <robh@kernel.org>
To:     Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sebastian Reichel <sre@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH RFC 06/20] dt-bindings: clk: oxnas: remove obsolete
 bindings
Message-ID: <20230403175939.GA1162106-robh@kernel.org>
References: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
 <20230331-topic-oxnas-upstream-remove-v1-6-5bd58fd1dd1f@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331-topic-oxnas-upstream-remove-v1-6-5bd58fd1dd1f@linaro.org>
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 10:34:44AM +0200, Neil Armstrong wrote:
> Due to lack of maintainance and stall of development for a few years now,

I can't spell it either, but checkpatch tells me it is: maintenance

> and since no new features will ever be added upstream, remove the
> OX810 and OX820 clock bindings.
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  .../devicetree/bindings/clock/oxnas,stdclk.txt     | 28 ----------------------
>  1 file changed, 28 deletions(-)

Always great to see fewer bindings. 

Rob
