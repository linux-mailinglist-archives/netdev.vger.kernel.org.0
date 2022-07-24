Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F2757F74C
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiGXWOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGXWOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:14:31 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D2FBF5C
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 15:14:30 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q41-20020a17090a1b2c00b001f2043c727aso8633561pjq.1
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 15:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=izqJHYhwD1nBp7ayBKUcvDP4pPLdTgryFshwld2pXc0=;
        b=eQ0MpXWFSx6QldY9BHsF7BYzvW+XSZLFu5aYX0Mpdhyyc0Ijm0Ib7Xz1UortpnuL+r
         QxRYdV1ZZZ34m/S8zP1qAimRWF8dFTAS3s3RK82RDPRIeZrJ6qFUGzkhicLG3stTpNHs
         PSCg0OsA2PHPVtpygeaC8gvg7Nml6FXKzgentEIin1cm9EI2+Ej8B1BdLkpq+v7XahnM
         wFsEIFXFqkC5jQ9u32lh73fuqRe6KOCGRgV8ekEMBV2i9S+lVLoSCFViDSIXisjeIvsV
         lvnuhnKQq3mBeoFVqa0gRyUOxHeSfxKhWFV4uEkjgvlZ6C50fTtvaQVMSob4nW2gFyvx
         rTSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=izqJHYhwD1nBp7ayBKUcvDP4pPLdTgryFshwld2pXc0=;
        b=iLNsEMYd4hJE4iiFUsT4Gtw3zLUBqLMd4YrDmdM2CBfcaHFMf3+i3LD5HzbqaXHHVC
         fSox/aBNeKxq3i0998fHqhiYmUl1LcZRnG9YVmN+RgBJg83VThdgIyGyQs5c9+AW04Dl
         qtKKtQZ/B9XPd7we7nJb85wxloupyaEnrONWpGJdOUoz5DgPM2wT+4tiKSVLR8CUJfRE
         6JBGq+Wzf3/+YaYx6EayhMwxgrlm4FVYEbUdsoW6P4unMG2SVfL7sNq9Sq+QFEUBuCrR
         dY+q23/hyVuAhCuOmjwhJqde6+vbh92jPcXOXPUscTiwet3ZWWAHVD3CRMMshQz154L+
         d4Ow==
X-Gm-Message-State: AJIora8p4ErbsVH/zCaapA4ECfnbi15oLWFaWB/XbAz6NFhuHlXExy5F
        ExJMXKPF3BWm8cEF7rVYPsk=
X-Google-Smtp-Source: AGRyM1tK1T8qba4sXumZjjNdxUzdIKH2z2+zMo6ferIQsHtkxsaWHaBN65GmvcQ39I/JHoYgXPXc0Q==
X-Received: by 2002:a17:90b:2242:b0:1f0:6d85:e196 with SMTP id hk2-20020a17090b224200b001f06d85e196mr11553076pjb.3.1658700870412;
        Sun, 24 Jul 2022 15:14:30 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id i29-20020aa796fd000000b0052b94e74e45sm7908203pfq.204.2022.07.24.15.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 15:14:29 -0700 (PDT)
Date:   Sun, 24 Jul 2022 15:14:27 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 10/15] mlxsw: spectrum_ptp: Initialize the clock
 to zero as part of initialization
Message-ID: <Yt3EQz+OCZDadjAe@hoboy.vegasvil.org>
References: <20220724080329.2613617-1-idosch@nvidia.com>
 <20220724080329.2613617-11-idosch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220724080329.2613617-11-idosch@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 24, 2022 at 11:03:24AM +0300, Ido Schimmel wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> As lately recommended in the mailing list[1], set the clock to zero time as
> part of initialization.
> 
> The idea is that when the clock reads 'Jan 1, 1970', then it is clearly
> wrong and user will not mistakenly think that the clock is set correctly.
> If as part of initialization, the driver sets the clock, user might see
> correct date and time (maybe with a small shift) and assume that there
> is no need to sync the clock.
> 
> Fix the existing code of Spectrum-1 to set the 'timecounter' to zero.

Acked-by: Richard Cochran <richardcochran@gmail.com>
