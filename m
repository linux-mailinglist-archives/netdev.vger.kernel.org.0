Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3471516896
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 00:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344728AbiEAWOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 18:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378208AbiEAWNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 18:13:51 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887692609
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 15:10:24 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2f7ca2ce255so131827827b3.7
        for <netdev@vger.kernel.org>; Sun, 01 May 2022 15:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8WXuaqzf5H6JbTMCrSNoDEe2cTNFwsekkVTcYWtQXX8=;
        b=NIMD1MgHFUA8qDcBtlkRUl6QwAMsrYm2LFtmvl8/1tnPPHxRUpA1yQ5LUAYctdi06T
         TOsD/Pv8VDI71Se+5p7Pej/mhD4qgf+k14w13KqKouOzghHkUgz02mr9ht1C5Q+AQUuh
         0KviUgNPzfaZP4wqvtLikTYkYLlECRohNbsEu9h/EpakyyZgJrAzbiZa3kK32wRWZAP8
         v8ZanNeCIK/+zl9E9gG5DRVG3Hrx7mW8dweXwuLE07vm1+xVHs5Z+8j39wJwgxAr3TB0
         sIVDxA8IhVVZXSJeGhmsZmd4DHlgLnJXoULjO7WRPuijicppJaGPBhttKcLNbK4Ul/z4
         EqFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8WXuaqzf5H6JbTMCrSNoDEe2cTNFwsekkVTcYWtQXX8=;
        b=QmQEVkmxa4uJs5urgHzzyfzexIMjH+ImyxfJxnqmAlIB2/otZ66FXM8X2bSSevpP2E
         n6T8UGIv6OzaNHKnvfdVUW4FWJw7nx8n546tLMC56kZ6HyOTM9agINNPDYaC0dYRJ2t4
         KFhdTXmmYCiLI1uoCyswDVMuWoGUuZnB0DCxOW9N49EW6Xs29iRTe9ubIgZuf9g5KZvp
         EC0AXdVxVIeMGpJNEHTpsDTPYa2R/Ig2EGto4PfItxSIzpt6gaHQW7elKlkgrrD/ER9Q
         Jg+IVX468nKOlnlyGRTc+gn4KEm8smlNn//i+Nv+IBZxHSUQqrQQQ/Sn/UXdbnfEA8s8
         r6Hw==
X-Gm-Message-State: AOAM533Ju+AUu8IzV8mZuZSwFoB5ZekR/mhS849bIHBiGB2bbl+bJeOd
        TM/t0Do0pEStxz7yu6SD08NFH0RmhMotqt78OAuYBA==
X-Google-Smtp-Source: ABdhPJwVRMVN6PYWPNDrbRGkbqET+tO2dajvHrcjRYlUisQxn4zRaAT7N9xEe7+WAUzHysUVA7VWrMEEZM+qWd2jZ7k=
X-Received: by 2002:a81:2154:0:b0:2f4:d79e:35dc with SMTP id
 h81-20020a812154000000b002f4d79e35dcmr9302689ywh.126.1651443023815; Sun, 01
 May 2022 15:10:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220427154111.529975-1-kuba@kernel.org> <20220427154111.529975-2-kuba@kernel.org>
In-Reply-To: <20220427154111.529975-2-kuba@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 2 May 2022 00:10:12 +0200
Message-ID: <CACRpkdYOrUkVCW6Bq2V0wkk+2AEP3tkw18m4ra83Gn29knxhYA@mail.gmail.com>
Subject: Re: [PATCH net-next 01/14] eth: remove copies of the NAPI_POLL_WEIGHT define
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        ulli.kroll@googlemail.com, mlindner@marvell.com,
        stephen@networkplumber.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com, grygorii.strashko@ti.com,
        wei.liu@kernel.org, paul@xen.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-omap@vger.kernel.org,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 5:41 PM Jakub Kicinski <kuba@kernel.org> wrote:

> Defining local versions of NAPI_POLL_WEIGHT with the same
> values in the drivers just makes refactoring harder.
>
> Drop the special defines in a bunch of drivers where the
> removal is relatively simple so grouping into one patch
> does not impact reviewability.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: ulli.kroll@googlemail.com
> CC: linus.walleij@linaro.org
> CC: mlindner@marvell.com
> CC: stephen@networkplumber.org
> CC: nbd@nbd.name
> CC: john@phrozen.org
> CC: sean.wang@mediatek.com
> CC: Mark-MC.Lee@mediatek.com
> CC: matthias.bgg@gmail.com
> CC: grygorii.strashko@ti.com
> CC: wei.liu@kernel.org
> CC: paul@xen.org
> CC: prabhakar.mahadev-lad.rj@bp.renesas.com
> CC: linux-arm-kernel@lists.infradead.org
> CC: linux-mediatek@lists.infradead.org
> CC: linux-omap@vger.kernel.org
> CC: xen-devel@lists.xenproject.org

Looks good to me!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
