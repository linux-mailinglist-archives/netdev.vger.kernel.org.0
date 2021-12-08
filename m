Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0E446CCF3
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhLHF1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbhLHF1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:27:40 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE8FC061756
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 21:24:09 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id r5so1098215pgi.6
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 21:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jN21r6OJSTFsgj9r64Hh1jCiMPIix6wU4qgpRwHwfG8=;
        b=hMsTpPd8gWi3Ujy3PvMKm2AhRb2ML1jyzMuE/erpda/1/AF+rUNIald/GfGViq/tLd
         o2y4W8cc2ICUanBvcqepDNezWtTFgQCoX+Qfcc5GqmL6Bn1U9t7Lny66rM704bugnGTq
         9X3HvHzswrV2tjhfCa9a4cA09icmI/vCPfxNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jN21r6OJSTFsgj9r64Hh1jCiMPIix6wU4qgpRwHwfG8=;
        b=N0Yo9T/gCdkIgcDwTUBq7Y9l0qyUE8Sf+BBQaJ9ECn8ad/jWtGqhcG60c/hY3nAiXQ
         VN0FvPl5pu5gAZren+tJctbnVSVFvaJM5U/7Epy8d4ND+2fucoDLrNuoa9aYLk15A0WR
         FpgTDiAQS/sd1Hb9hYJLRQldMIBY45Zz61CFTQiaavZuojguGEf83E3dGkXyi/EfuXyD
         Cfu7WTFzyaaG3KCVS5947sECBV0v8Y3TRrG1tUcD4thUJEeG914RzVB11UvkgZsaQ+QR
         BzaNAJx3G6VfoNV5osGvvUMLbqGqFMLmOARaw2Y+c5TUaoSBPLaKmUilaP46LX2W4tYn
         8xiQ==
X-Gm-Message-State: AOAM533UMVEndAhapKE/sVAyUV1I1HqlRMsIBgL+BY0z5JWK7eps7x2K
        VIsdxuKdxgOsjoluD+XysGFWEivsVOr5zA==
X-Google-Smtp-Source: ABdhPJzlHAKuLFlj8TFLJdbJpyf/D+l9/UBbiFuXowho3aLkJt0awiY6BtPP69mJOwjO/M528bBz0w==
X-Received: by 2002:a63:8148:: with SMTP id t69mr28164809pgd.79.1638941048615;
        Tue, 07 Dec 2021 21:24:08 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id md6sm1202665pjb.22.2021.12.07.21.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 21:24:08 -0800 (PST)
Date:   Tue, 7 Dec 2021 21:24:07 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] net: huawei: hinic: Use devm_kcalloc() instead of
 devm_kzalloc()
Message-ID: <202112072124.16F7CD13@keescook>
References: <20211208040311.GA169838@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208040311.GA169838@embeddedor>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 10:03:11PM -0600, Gustavo A. R. Silva wrote:
> Use 2-factor multiplication argument form devm_kcalloc() instead
> of devm_kzalloc().
> 
> Link: https://github.com/KSPP/linux/issues/162
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
