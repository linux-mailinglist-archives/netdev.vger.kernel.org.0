Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9D527A08D
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 12:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgI0K6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 06:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgI0K6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 06:58:37 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA831C0613CE;
        Sun, 27 Sep 2020 03:58:36 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x14so8517511wrl.12;
        Sun, 27 Sep 2020 03:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LKoRLUepQ4VZcCInc1ZWb0QZsddQAw2nMhBfFTWYIEE=;
        b=AEykn3yqJ8jk8UYWLYjRk02fU7D5TOSfQSL/b9w08iRPTbgBb8+I3qiVzCi5NcUkE1
         Ap7pThACS46cqGkgDYZUxwEBi98LCI83xCoS4l6LJjM8Z7jVtb4eOZc2QAzIwHprWd05
         TSaFhegBK4/MM+3I5FJ5AQBuLdY9rbUyhOrA94on0BCzFeAQD70nyUYM4zi4W2zXLjlu
         F/3A0AnbgHVOfrcigk6BxkTQB3F3T2k36GGe5cCj1AdcV1hIribpaL+mhYBucde56aaG
         nXrydLrs8AAzv0UqL5qoSBw98dHLWVBUXzFheWde3qXSqxraeCltOCGEV962F9r9Vxn5
         Tv3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LKoRLUepQ4VZcCInc1ZWb0QZsddQAw2nMhBfFTWYIEE=;
        b=ukMaqAU6R7fHpMt5ZMkuv9kf7C9p9y+0exwvKvN+LRuwQ9AkfW/DKZtHqX5IMxBmHc
         WVtpsfYowttXL7+pJ2xbaVjGky9TponADCtHZCuieE+bVoF0E74pQhRMOrYCrIF7+lxG
         1svZujswjsko+VoU08PKpfPMIXCtTB41hdsphabMvFJb5YOUj2cniRiSiJNbxTk2noj3
         93kdBZjFXvJAJ3Yqjn20aaFHbvINUz6fUmgNaAqgym1QYA7t20YHxYDVUplBBOWfeohk
         YY3YjdYIXB6mcOhyr+4Tmx4QoCmrPvOtyjmg4fnJuodoEqAQ/cyjvpasM/43Z+tGQrTA
         J1bQ==
X-Gm-Message-State: AOAM532xjdFc17JiKIqaoBdekap2qMstlLlOx5Gk+PlzVfOIyqFiAQH2
        9ALF79Iec09IrO5rlXy+RA6e18A+qr9Q9Q==
X-Google-Smtp-Source: ABdhPJyiyAsCxfQAz9UD5X1y1A4U9OeyXXCgiHypeRTMLUPNFg0zEnAsGYxQUhLSm0dqIR6XAvfvZQ==
X-Received: by 2002:a5d:50c3:: with SMTP id f3mr13370984wrt.125.1601204315374;
        Sun, 27 Sep 2020 03:58:35 -0700 (PDT)
Received: from medion (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id l19sm5145950wmi.8.2020.09.27.03.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 03:58:34 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Sun, 27 Sep 2020 11:58:28 +0100
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Julian Calaby <julian.calaby@gmail.com>,
        Alex Dewar <alex.dewar90@gmail.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, ath10k@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] ath10k: sdio: remove redundant check in for loop
Message-ID: <20200927105828.522fabbpyxx2mt3n@medion>
References: <c2987351e3bdad16510dd35847991c2412a9db6b.camel@nvidia.com>
 <20200916165748.20927-1-alex.dewar90@gmail.com>
 <CAGRGNgWoFfCnK9FcWTf_f0b57JNEjsm6ZNQB5X_AMf8L3FyNcQ@mail.gmail.com>
 <87h7rnnnrb.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7rnnnrb.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I agree. Anyone can come up with a patch?

Hi Kalle,

I was thinking of having a go at this. Have you applied the v2 of this
patch yet though? I couldn't see it in wireless-drivers-next. I just
don't want to have to rebase the patch if you were going to apply this
v2.

Best,
Alex

> 
> -- 
> https://patchwork.kernel.org/project/linux-wireless/list/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
