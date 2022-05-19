Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5FC752DEB1
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 22:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244803AbiESUtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 16:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241800AbiESUtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 16:49:35 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECE8985B6
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 13:49:33 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id t26so11053759ybt.3
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 13:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DpIUn7t2KpByY+C3exdjmM1g7bDyPkhbaj3F539P5Ug=;
        b=be4+zMYgHWBD0Fm8gVi2/TF2wY6TpO20KB8n9nn225sOFXquQQ+GoLMQiUSJNsfP6i
         gmJAonvgLrXHYk9VmEPiweCwS65SJMfIVO5JYuA8w9vKBFLNDlShjOZi+KCXwiynlmG9
         S8DHJbSI4WMsxIROerIXKHNZkJoZ+WizMBwk6nnEs8nr4zB4sDOemcxFX5uHEjs3hytF
         Jsxmn+qmKyyz1q+0LMNv6buvXZQ7SrCN29zqwfhIR1UAk2ssVXStQdAqbfDL++oyR1p7
         HQuUylF8EV12p+x5M82glvEBSmbBj26M0qPJoTrlBWv2hVuehOplhtgYQHtqTGZIsRr8
         zW6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DpIUn7t2KpByY+C3exdjmM1g7bDyPkhbaj3F539P5Ug=;
        b=ZkmIYn50gKKTzVOF/flevx6Bkmgb0xlPoYfTSsQQmXGxw3Pkk6rm+Tq9HixIPeYpOw
         dZh0ZriJpHsgz2SlJ/FRktUavEdKRvyG32/0+WmdfdonhWDFgYQYk9FDsQjga2/TTb6x
         hjbu/Mbz5tT08AT9Nq6IkThZXvW3rh/zpl6ljOpJ8yyEqI9TW9zHR9AtStiGxHnvT5Vh
         BumeIe7k3RxPoTncih/KLLSAXMnHaMaASpkB+IavHpw2/uXaYC0TmfULR21/TfaUGNfh
         O3sTwAIkyG788GpFPsUS3iRXB9B30dG4RfVyHs7O4eJ8rICwN+D6V3smcsumO7UF68nn
         MKKQ==
X-Gm-Message-State: AOAM5325U469kN9wwspF/h6ONuxnjTbwIf4P5AmmwXemyJY00ayCE6uK
        9NcdkFd6DfVxOk5h4ShiHb92pjeYL+GbDewpgx/NJQ==
X-Google-Smtp-Source: ABdhPJzPxhkV/Rn/SuoG3prTwHYeGQr3LSPIIJaKxjOHyoF0SbdUm2tlYi6vaiBt8JFzR0b45ZPy7nHSil3uJWZmlz8=
X-Received: by 2002:a05:6902:526:b0:64d:b6ab:f91d with SMTP id
 y6-20020a056902052600b0064db6abf91dmr6490609ybs.295.1652993373117; Thu, 19
 May 2022 13:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1651647576.git.hakan.jansson@infineon.com>
 <64b59ca66cc22e6433a044e7bba2b3e97c810dc2.1651647576.git.hakan.jansson@infineon.com>
 <CACRpkdY3xPcyNcJfdGbSP5rdcUV6hr87yJNDVDGZdRCfN+MqLA@mail.gmail.com>
 <1e8cfbc6-8452-0e87-9713-536d235e5b51@infineon.com> <CACRpkda4ByrS8RGAunno_S59+Y2yado4eObzwsVkM2Q=n-B+CQ@mail.gmail.com>
 <d35fff90-ded7-2b1a-0e1a-f2db14cc4d07@infineon.com> <0dffeb79-3182-fab1-e25a-aab4107beb6e@infineon.com>
In-Reply-To: <0dffeb79-3182-fab1-e25a-aab4107beb6e@infineon.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 19 May 2022 22:49:21 +0200
Message-ID: <CACRpkdaea+35bn-fa0JcfYvi+SMvHUxzmWJHeCHwV82+eodCGw@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: net: broadcom-bluetooth: Add property
 for autobaud mode
To:     Hakan Jansson <hakan.jansson@infineon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org
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

On Thu, May 19, 2022 at 4:04 PM Hakan Jansson
<hakan.jansson@infineon.com> wrote:

> I checked the state of this patch on Devicetree Bindings Patchwork and
> it's marked "Changes Requested". I'd be happy to revise the patch but
> it's not clear to me what changes are requested. Could you please help
> guide me how to proceed?

Sorry if it's not clear but I'm essentially requesting that the document
describe how autobaud mode actually works. The binding documentation
must help DT authors to know what they should do with this property.

Yours,
Linus Walleij
