Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35E2623D2C
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 09:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiKJIO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 03:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiKJIOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 03:14:55 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2387DAE4D
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 00:14:54 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id r14so1896260edc.7
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 00:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VR+kTN7aVdKjhZh8NlZXP5V5bz3cZz2vO+9MinMVc7w=;
        b=rOY8sgDcj25ldmp4a6NduPUBo/VTKGkfNrvySWJQJwTl3HHqEdexbl0vRemE+6zL7G
         D5aGVjge4274ClNujScxiWgY2VZVCI5ygrC+GnwSIgATjr5ixXpY3zftuPODxzq/pH7N
         LyjdedhH3zHT+f9lak2ejhWKhfA3Lu1iPOuzVO08y4wgyAO2LNVnBYsCyC2uqDw8aAe+
         rzMvvQDp9Ymf+emKucky2DWzL9DXBrqRL49exEDr7mStf92P67E0wJ5ac+JP6C2gbzLK
         8SkidjB9fMK1PJJ7AGzGbc9yr9Ewg30hmtDJftB7oZBTmZl8JxKdgJ/nXDeIYqKoynkp
         r32A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VR+kTN7aVdKjhZh8NlZXP5V5bz3cZz2vO+9MinMVc7w=;
        b=FJ4VgxAErBhbeNwNEl/WC+9OmAA4El2Lc6C4yAqYGDCsJGDqOfvx9EcPERyE9NgL4i
         SHBJ3qCRrzZTS/J4YcvERkgW43K33EvsL1H7T8O5+8y6op61UYzs6WWaY2nPUay1s8rc
         2DcLd07rLI5sIpNyxPIhfhKI6YYT5iV/kYd0j5DJZVPp1qbTJm5elSxMqK25+/8ZTr6U
         0ZNy1VvWUDZ+32ZnRZGBc231jIWGLOOpodzDZa0KIKsJI1Q/0aC8VxE+svW6Hdyockh9
         PmHaMidbeZOWlnQd+YDHg3RHMWy1SfpYTGXtkUxdGSJy4zfL4Ifjr0VMV+l9Jtrq1XVi
         NdaQ==
X-Gm-Message-State: ACrzQf2O7F9By0sOaT4f6uM/sPjrTm1dtoDdwwCgN3/o4O/iJBtd0EMz
        OzblBYLAqPnE+pr5reypYIvmbrgVkrg7hiAaxNNgIVSnfCI=
X-Google-Smtp-Source: AMsMyM7Q/i/WvgLUB0geOsT/aGAxBc6WiGU8NoeFeM20MOvmnKbxtdBWGGDsCfAjiRYM0spSgiS4zE5A3uAQIvQ7KWY=
X-Received: by 2002:aa7:d6d1:0:b0:463:ba50:e574 with SMTP id
 x17-20020aa7d6d1000000b00463ba50e574mr44237526edr.158.1668068092682; Thu, 10
 Nov 2022 00:14:52 -0800 (PST)
MIME-Version: 1.0
References: <20221109230945.545440-1-jacob.e.keller@intel.com> <20221109230945.545440-3-jacob.e.keller@intel.com>
In-Reply-To: <20221109230945.545440-3-jacob.e.keller@intel.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 10 Nov 2022 09:14:41 +0100
Message-ID: <CACRpkdZhkWfDBEVwM+pXbwo5C+pdQG_EeOwqnXpqbdhOugviDA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/9] ptp_ixp46x: convert .adjfreq to .adjfine
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 12:09 AM Jacob Keller <jacob.e.keller@intel.com> wrote:

> The ptp_ixp46x implementation of .adjfreq is implemented in terms of a
> straight forward "base * ppb / 1 billion" calculation.
>
> Convert this to the newer .adjfine, using the recently added
> adjust_by_scaled_ppm helper function.
>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Oh that's neat!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

What is also neat is that now I can claim that sometimes Intel actually
maintains XScale IXP4xx ;)

Yours,
Linus Walleij
