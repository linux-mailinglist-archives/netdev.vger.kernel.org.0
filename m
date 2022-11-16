Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A64C62CD8A
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbiKPWXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbiKPWXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:23:51 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB44ADF41
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:23:49 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 136so265382pga.1
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/EY1LYuvEeMmWBh0/R1XK2F3auEDRSjaMa5zKaprZf8=;
        b=OpNdNdBCSrHWxNkkZA+E6qZDw1ZDI1QlVv2UKT7FZYMvVG3qQ6kBYLigFU0rlRUFsf
         +XLQscK/ySHtTV9ZPszQB5R7wdU0JKoXOF/MtOh2Pda3FNGpJnfOEJ5H9vNxIgqyVKyy
         6I6j37axPTFE5wrtP7o29MQQprmD9Zrf1d7e0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/EY1LYuvEeMmWBh0/R1XK2F3auEDRSjaMa5zKaprZf8=;
        b=Xh7OUGrtprJd4uAUUtOAUeb6S5ahtr1Kxsgb5oGO6mPnks/ZoooHrv0Hf3+MesbO6e
         b1Ijo4OrI4BIznQwIbkQTwjyRRjbKAL3IzWD+vgLLOrZ6QDhT8Zf9z3tu2XN2R6W8S4o
         yiii4RdL4wcxxxqhTDl1YYKQpXmCKYtYg0jjpt2QYx1jE5HsO62CGmMFB+vTf1YZtHPV
         MieZeZeyLGfERNfpcKe4fwFc7si9hWiptjRnatgmrxPQKnBEdSQOfHN9bJIWn2BEdYka
         RmtX0Gbbsd49kA8vNeHp7QWWCmz/biok9CH5J4A6MF6Fo/vcnPL6yPRGwDoncPc9rSng
         yrxQ==
X-Gm-Message-State: ANoB5pkb7ZUCJszb/v3XIA1FudM9Qo/RU2YHArIDIf3bBdOF+l84amWF
        P77gKTFFVKxCPWTBhXAF1LxH+w==
X-Google-Smtp-Source: AA0mqf7jVOtnYCs2DJkAYYj4qjR6hmOH3/+q5zUbVrwoiAfK3CqG5t96nw+nE8mbH3/VcCM0K+cT1Q==
X-Received: by 2002:a63:a512:0:b0:439:8dd3:c3c2 with SMTP id n18-20020a63a512000000b004398dd3c3c2mr22143106pgf.481.1668637429348;
        Wed, 16 Nov 2022 14:23:49 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id 16-20020a17090a19d000b0020ad53b5883sm2136331pjj.14.2022.11.16.14.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 14:23:48 -0800 (PST)
Date:   Wed, 16 Nov 2022 14:23:48 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Hante Meuleman <hante.meuleman@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        SHA-cyfmac-dev-list@infineon.com,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/2][next] wifi: brcmfmac: replace one-element array with
 flexible-array member in struct brcmf_dload_data_le
Message-ID: <202211161423.1AF172E584@keescook>
References: <cover.1668548907.git.gustavoars@kernel.org>
 <905f5b68cf93c812360d081caae5b15221db09b6.1668548907.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <905f5b68cf93c812360d081caae5b15221db09b6.1668548907.git.gustavoars@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 03:53:27PM -0600, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct brcmf_dload_data_le.
> 
> Important to mention is that doing a build before/after this patch results
> in no binary output differences.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
> on memcpy() and help us make progress towards globally enabling
> -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/230
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
