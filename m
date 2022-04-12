Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC8C4FE2FE
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345666AbiDLNsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356316AbiDLNrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:47:55 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F645159A
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:45:34 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2ebf4b91212so103248207b3.8
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y+95UQNr5ADFBE+AaXdQTrnS8iQt1u7b5lSGLz5HpP4=;
        b=GQNhROvvlsggOBL7u4NxRAPQkyV3Vc+MoXYI9CqyQeqxE03PQ4HX6W0Py1Kd3svdCR
         hZ8eFz5u6ePb0FUDbVnQ4yRiD6/SBTy9+AVCXGuq9EYfCVoK4E+J4JNkS5EyKikpNIxM
         WXXBh9kIndUEkyLcXTC/gxXIgTCwkEMrKnPT3p+L0tVEfnmioNhSR7CPp2UmwGE8Co9F
         pWIrgj//CY2y54KZ3BU8AbhXDdRwhN3p5T9hGRQcTcrBtJq3JQTuThUbnbQ50u8Dy7ef
         Jk4o3L+l3AAkkdBLH3kKdBgGwKqRjdhaCTf+2CdyPiUfDsmNxbByTAHpV/typPNOZO5s
         i/LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y+95UQNr5ADFBE+AaXdQTrnS8iQt1u7b5lSGLz5HpP4=;
        b=cNlfRuM1BJzoE7uqJoi7xILfe4/0Xu5PMn7e+09Fts4D+TmZI8dFAkP8qYFibr2BIO
         DQCS0how2D9VnksxAzT9g7HKdaXjXaVsjfmZisYq4UERH+kYHIM7zu0/w4O3n9Jqqdpe
         hArd2/hbcdjbUzS3vFAfSwxQeuRGJeqhvidxCb48ckOHAJahBJywi19uCdED37404WZ1
         ZslN0LnEOciPLzYqm0UlhtkV5xcWh2nVxsDUsgjiV/Wb9jK0d9qElQnJhdigEtkqN94z
         2k215EsBJ1rrldiOQEvnL9UNRil9pilLTgCD3wyKIzB2ZGi7n1Qb9R24kgqESkxMG8mC
         poow==
X-Gm-Message-State: AOAM5318roZWkHQlE4ZX9/INAwdF1Ar4ZqsIG1efoHcAdJl/ZVGhGqOf
        fUOIz+9jLnsvugJTWlaGmhkER5ekNnUOmf6Z7Y44Dg==
X-Google-Smtp-Source: ABdhPJxSIRzsRJxTMaEyrqsvgxiFAvFxfbJoASvinet9u3rz8+YuEtJfwrpRO7FLqYTR826wAVE3fMaUkuEcT7TSfSM=
X-Received: by 2002:a81:6d14:0:b0:2eb:fbdf:639 with SMTP id
 i20-20020a816d14000000b002ebfbdf0639mr12333305ywc.126.1649771133314; Tue, 12
 Apr 2022 06:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220412085126.2532924-1-lv.ruyi@zte.com.cn>
In-Reply-To: <20220412085126.2532924-1-lv.ruyi@zte.com.cn>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 12 Apr 2022 15:45:21 +0200
Message-ID: <CACRpkdY87j7-Gm6fPM_MXBZvLsHWCPVU3gdbv1b=vB+L-Mn5QA@mail.gmail.com>
Subject: Re: [PATCH] ixp4xx_eth: fix error check return value of platform_get_irq()
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        arnd@arndb.de, lv.ruyi@zte.com.cn, wanjiabing@vivo.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
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

On Tue, Apr 12, 2022 at 10:51 AM <cgel.zte@gmail.com> wrote:

> From: Lv Ruyi <lv.ruyi@zte.com.cn>
>
> platform_get_irq() return negative value on failure, so null check of
> return value is incorrect. Fix it by comparing whether it is less than
> zero.
>
> Fixes: 9055a2f59162 ("ixp4xx_eth: make ptp support a platform driver")
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
