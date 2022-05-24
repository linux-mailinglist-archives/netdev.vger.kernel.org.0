Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5BF5324F0
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiEXIJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiEXIJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:09:12 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5968020C
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 01:09:10 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id x2so29205865ybi.8
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 01:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dkLTcxs8LVH0sqAqHX3zwE0YhNnh+xIZuZ0uAeaShmw=;
        b=musaGlIUesSSFQdYuAzfEmgjChU/RErADTpoJGqFYDxCjSKWv4SZgrtDjy2TU2cJ7V
         6IcuLSp4qou81OsuCdHC8fOLeimdtdOQGQnqdkPprKogeMQ33ZnzhIDjIDCzbl+BGrOT
         9gljfGF/KKtyhiBggP6XepXiQhNVSbx7DCLzz76L8nCVN723cAbgYo8Z3pxo14FzA+Fk
         NuX2oNJKs21TPwEJlzAbXd8x6LyzNhDDD/EwaVQF7MSHy6WTZ8mYYjGC6Timo3iszaY/
         FDzE+T18UfrMu5qO0fIWDjDS7Vvm2GgGuGV5tOlzybHZNxMcLOYyMPWoQd8P14IX4Cmk
         3FqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dkLTcxs8LVH0sqAqHX3zwE0YhNnh+xIZuZ0uAeaShmw=;
        b=GY958v1WNv58kOMin8Z3MJtwXqOkvYl7oReGe68mAWz8Eny9KezUO7mhTcJPj9G2C7
         ilI8lWFvLnQF+rF5WMHTSbLKFqaeISOX2qdJb830BHEfYmpSSlpLMj8bpX1UhNH22VCF
         QMcwMcjZiu0iI1Id69B5FvXdGT5oCDhDLpk0aRjdvqe2VnYdh3cgUCao6yneUcJfcMGI
         B0NW8MMbG2Z2uk/bfwTMGWFPHGZk4pLEjrmO7//sEXSyLkYvN21bfQD/ylbpwWnRxiNy
         buea1yObwrErt7ukQElBA7HZssnK+d/tnoNIw7bmu+na9SPZN2bAbXpF3AiV9LNvojT2
         9QPw==
X-Gm-Message-State: AOAM531RFndlJ+QOaxchXokvYWfaiznsA7a3YZCB5VzGvR+4KVFG91ys
        g9+7wnljMPp8E6ibRPt7Fh7fVRaDDLVY+wuz6Sl31A==
X-Google-Smtp-Source: ABdhPJyf5gbDLLFA40Cy6Js44+0uWmYjUNjCN43UMga6ZpyrkAqN6ZT1g0cZE+VhRqLEzvShzX0tpLzLf20WBd/xV48=
X-Received: by 2002:a25:6cd6:0:b0:64f:c489:5382 with SMTP id
 h205-20020a256cd6000000b0064fc4895382mr10347226ybc.514.1653379749486; Tue, 24
 May 2022 01:09:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220524055642.1574769-1-a.fatoum@pengutronix.de> <20220524055642.1574769-2-a.fatoum@pengutronix.de>
In-Reply-To: <20220524055642.1574769-2-a.fatoum@pengutronix.de>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 24 May 2022 10:08:58 +0200
Message-ID: <CACRpkdZm0XHfPpWwBB0Nn1h=_oOgj6xKDj24iAVqFPxtextSoA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Bluetooth: hci_bcm: Add BCM4349B1 variant
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     kernel@pengutronix.de, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 7:56 AM Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:

> The BCM4349B1, aka CYW/BCM89359, is a WiFi+BT chip and its Bluetooth
> portion can be controlled over serial.
>
> Two subversions are added for the chip, because ROM firmware reports
> 002.002.013 (at least for the chips I have here), while depending on
> patchram firmware revision, either 002.002.013 or 002.002.014 is
> reported.
>
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> ---
> v1 -> v2:
>   - No changes

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
