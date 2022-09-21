Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87B35E5635
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 00:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiIUWWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 18:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiIUWWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 18:22:00 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E23FA59AC
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 15:21:59 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id m3so10844347eda.12
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 15:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=LIf5TH9JGQQ/iaEojY/AW+9YyJO9O+pApuj6h9Zn+Oo=;
        b=GO0YZ5u+qsCTrf2UCsCtd11NJguu3FYsrmmp2cXMTXd1MRgnUh7fElGtibDnN4pZZ4
         rcgbwy1kuokl42bmZGNaPW56xgqy/yR8+Riw1L+f/fBw5skX/Vy3lIZt6clS9tUkwQCW
         ymj4xi07adCQtwoItop78vj7Kg76SNNY6jXU2o2rpXPzh+02KU6JGg1da6srxce4qpfo
         ZOzY5xmbS8i6lomVykFr8x/t5iykbJNk8miXSLofuMaGGMk/VzYBymOqnG2hpkhXjbB4
         tfeQhpDWWosNczVkgcspCM1k2/StP4Vha8nPSg88w8322jeRDUoxkeW1WSLpiXtVbLZT
         Fb/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=LIf5TH9JGQQ/iaEojY/AW+9YyJO9O+pApuj6h9Zn+Oo=;
        b=hCu3kpQdJ0NhmtoSwxkFnXTkbAA9QMttqeFy+7zyFk/Y+cb1axoVf4qMoV87Z3yI2W
         buul184DHL2gMenNv8KyYVqBznAMYhzO9Oec8nEmlitXEPlxwmjcMfn3NYqwINhG955q
         ungYBPKZ3WC3Rk9eoICG7TkK1hZbHCnPC6bxz3QgR8vfJr8o6fXZCGudPVxEAh4S0vki
         SZqLH2L8VpB5rkqcu9/Vaxrp32EaRldCyfVMsxrHPjmhyI/cHAGzWtiSYopc7HmZMoPT
         CM4ibeocFmOldR1z3mlq/pD/IS7SX+9sqOTpOTkiuyxMyc0NRwjTaSaXbO19rFZF3vBI
         zJdQ==
X-Gm-Message-State: ACrzQf0lis6JHT0fFh7C+4JvJq6AtBvfl8+uxSemC7ga+cdou9Nnely/
        RGHA1yksFz2kguOnyErLjBCJZ7qM/ILHARgt2y4neA==
X-Google-Smtp-Source: AMsMyM5sXqevzJeGEuPIw97S++vgsACiUNTu8c/OID4aGuuNWoGMY96knbApK+ExCEmPoHY3U8UfwNKeCq6atRU2EAw=
X-Received: by 2002:a05:6402:190f:b0:452:d6ba:a150 with SMTP id
 e15-20020a056402190f00b00452d6baa150mr304609edz.126.1663798917664; Wed, 21
 Sep 2022 15:21:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220921140524.3831101-1-yangyingliang@huawei.com> <20220921140524.3831101-15-yangyingliang@huawei.com>
In-Reply-To: <20220921140524.3831101-15-yangyingliang@huawei.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 22 Sep 2022 00:21:46 +0200
Message-ID: <CACRpkdaZH5cujkjt4g0u9m__r1MKRHLjs05_0kf69-Fu3pRpiw@mail.gmail.com>
Subject: Re: [PATCH net-next 14/18] net: dsa: realtek: remove unnecessary set_drvdata()
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, kurt@linutronix.de,
        hauke@hauke-m.de, Woojung.Huh@microchip.com,
        sean.wang@mediatek.com, clement.leger@bootlin.com,
        george.mccollister@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 3:58 PM Yang Yingliang <yangyingliang@huawei.com> wrote:

> Remove unnecessary set_drvdata(NULL) function in ->remove(),
> the driver_data will be set to NULL in device_unbind_cleanup()
> after calling ->remove().
>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
