Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B20365AEA
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbhDTOKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbhDTOKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 10:10:47 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8359AC06174A;
        Tue, 20 Apr 2021 07:10:16 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id p67so20686496pfp.10;
        Tue, 20 Apr 2021 07:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8zukqXhtvNEllv/hGl2ya5yc48tmrYIRWx5ZeIc3rcM=;
        b=Sf1X2kdFWDaCcWS2w4twhoI6na8jvjUQPUI9XJ8dbozgPhmvI2CJtHyh1kJ0NdQ08N
         dccnWzM/cFSUZbKPhYUoComMVzkV9A8hXsF9aYcCWOO1IH0HRIuC4N2TdRk+LcUtMJII
         le8nt5VLNvcpr9Eqib0GL1rdjFMaboDl17PWgDTeF6Bq3pbESdW3EhrSWvaLvJmwQKyz
         8R2IFa6bWTwvV21FFXhuqHWFkHlnyXq7LcE434jsUQA6N4q7aELX7ywjJtCTOCgX3ExP
         DPMf9CoalAW34BKWh0e/kxpFYB6A5v2xmzw0zZBbjNVN80ZZ5Ute337OM5S61OtRzmkc
         0qcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8zukqXhtvNEllv/hGl2ya5yc48tmrYIRWx5ZeIc3rcM=;
        b=sxGDV6ayFmXSdXgJHO/dhGbtPRqsMVtGR+Fx23f4dUb/HW/LKdYvweyGkkdJGpUdPw
         V92+6P21IuBMdGy8X20leM3WD/+cOH7oTaT/2GHkjolgwl0MTDmYoKjfdxA1wCQL+O/X
         gnvCzGKzp/3d99BqN/FoB2pWg8oGLtQ+YMeHX8RSkBFwNVv5Jo0MuOmom8Bpjv3XcJSc
         N621YQtkCdOGfle4QhAajIEgTjiwdooImT3yx6fOLiCoc7I6jXOC/6t9eQAqRtFlN33y
         IOZgskzR589RrBDRNmj+wP9bBCbH8DsV42UIfAJk+v/OruLf+yLnEnYef1WZlYLeuYHe
         hDfg==
X-Gm-Message-State: AOAM530Q2AaGlWHG//YC9kOkvB0Fwv1/bKWNOkxUkOtXpZJobsISrx1X
        3Cwm0Ltg1f/O4CkSh7sib2E=
X-Google-Smtp-Source: ABdhPJwa0niW02MXZGILXnN/iUHq4R2X8YqgNBbPOoJAx6Zdg6B6wYkPeKMpckpjG8j0mHohVusnZQ==
X-Received: by 2002:a62:a515:0:b029:263:214f:27ff with SMTP id v21-20020a62a5150000b0290263214f27ffmr4660367pfm.4.1618927816018;
        Tue, 20 Apr 2021 07:10:16 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id jz8sm2703759pjb.11.2021.04.20.07.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 07:10:15 -0700 (PDT)
Date:   Tue, 20 Apr 2021 07:10:13 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Jianyong Wu <jianyong.wu@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] ptp: Don't print an error if ptp_kvm is not supported
Message-ID: <20210420141013.GB1261@hoboy.vegasvil.org>
References: <20210420132419.1318148-1-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420132419.1318148-1-jonathanh@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 02:24:19PM +0100, Jon Hunter wrote:
> Commit 300bb1fe7671 ("ptp: arm/arm64: Enable ptp_kvm for arm/arm64")
> enable ptp_kvm support for ARM platforms and for any ARM platform that
> does not support this, the following error message is displayed ...
> 
>  ERR KERN fail to initialize ptp_kvm
> 
> For platforms that do not support ptp_kvm this error is a bit misleading
> and so fix this by only printing this message if the error returned by
> kvm_arch_ptp_init() is not -EOPNOTSUPP. Note that -EOPNOTSUPP is only
> returned by ARM platforms today if ptp_kvm is not supported.
> 
> Fixes: 300bb1fe7671 ("ptp: arm/arm64: Enable ptp_kvm for arm/arm64")
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
