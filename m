Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEB7397AA4
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 21:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbhFATWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 15:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbhFATWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 15:22:51 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B305C061756
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 12:21:08 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id t28so254432pfg.10
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 12:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=buLhPbHrFpi6KG0ErdpygLDLYcV9LBfIxFbXDWOKBP4=;
        b=nJQJkMdFCEKm3y3/x9E10xUE4aPzsu6vVkMeh1Y89Ap/86sznI718OOCm2FHLR7aVb
         MAep6R53Bjstw0NZACsB0x30q6XYaf1Gt5SBkqPn87sVXoBQLqAvA3ETFbRiz3SvxBhR
         Dx/kqyg1/CwpJHGPbXVmiIMAdJRxVOQl02YuQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=buLhPbHrFpi6KG0ErdpygLDLYcV9LBfIxFbXDWOKBP4=;
        b=THF0p4HzlOL8bnv+toViJfwugC2EwbJUNJoHy+Ct2/yVPUAY3xyEeVXef6UzUWEIFw
         8tBwQHJTg6No435pwUmBJ2uB1Nqx3Ys4Ji5LchenwiDNY2VPn6cFsHt5xfyk+MvjYPHE
         rRJcxq/FyySMixaveNF4i4cTxOv9qQ25m8yoMdPQQkk6DxcQqLaji123WMtqsl1J4e2o
         WVr1tYRAmgnPqXc45rfLXk0pQVRH9/KKI3lslAJszsupWaPLx+DX8eJ41EE39jOw1GkP
         8D1ylmoQ69nuW3H2ad8CTgSgYFVThc5Fq3V+Cn8dPXMfJnvSEoY2Q9+Xhnh+VutI/3lS
         kNsQ==
X-Gm-Message-State: AOAM531IMUp8bS1F5g92OXa8Uo6dLDervF+CXeSrUB4H0DWPz4Ar9nQn
        gFK8Lxvfj0RJUr2ciJ5TCghUhg==
X-Google-Smtp-Source: ABdhPJyteTrnW0BHtAZrMYVkg3K+7X01zzTkWDHpLl34qK/KTkq2FaLhiurwLoG9HZLZaaCo9qlPsQ==
X-Received: by 2002:a63:db01:: with SMTP id e1mr29836130pgg.38.1622575267711;
        Tue, 01 Jun 2021 12:21:07 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s29sm10486657pgm.82.2021.06.01.12.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 12:21:07 -0700 (PDT)
Date:   Tue, 1 Jun 2021 12:21:06 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] octeontx2-pf: Fix fall-through warning for Clang
Message-ID: <202106011221.24B746FA@keescook>
References: <20210528202225.GA39855@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528202225.GA39855@embeddedor>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 03:22:25PM -0500, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of letting the code fall
> through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
