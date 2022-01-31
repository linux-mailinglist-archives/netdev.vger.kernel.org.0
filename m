Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890F84A4C2A
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349947AbiAaQct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350040AbiAaQcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:32:48 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8165CC06173D
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 08:32:48 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id i30so13293148pfk.8
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 08:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jrmCnw1vWbPG3vz+B6LPTNIGeWcQyoJjyMn1cPywoW0=;
        b=BLDLfU5xiPEST4k+7rKwaIBto82ggkKMBj1VsQuz/7WQj5EDZjJBX1DvXVtJ/OQ/Re
         WcanpYChyFlDDySnX/x7z0hs7Kqu5V94fwNk8cGdwLAs/YkyL0Syt+mDvv+MQTyuOfeH
         uLCvHWyYZZ7+1SAJC1CSGdkFTxkyK+09724WME18Abdl+pNoxgNjgj53Krx/7z/zKwPT
         aRehDxttuSsbWTGFbeZojvukKZy2FvkX8b5hf7KVaL/0uGCi2FMSllHNmSiRVhxj0wbP
         uJ17BKJSC+eNkMXqjmtejlKYZGVL4WqWYRK/UAeuTy4C5tNOvoahGKD7PFpy5fTwxEhg
         /9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jrmCnw1vWbPG3vz+B6LPTNIGeWcQyoJjyMn1cPywoW0=;
        b=dT6DP4gTUlEqQ/iGAo3B5aGhSpssCv+OPs0V8NDGvfAOq9q2Hcx+Z9NfMBkkEMqtoc
         TEac/xvGzzzgEWH7iifb8xEA0ZGm3t7Y/lbSW8ABwE5/BZIg6tjxTKQRGgrIfm7UpXEC
         SAQKvw2p6u+hOK1SDO/BXpzT7xJIXln6rhnvtNzriRTCOO6k16ekQI9l+9BmivEllHSJ
         WUzRDojH63UD2ocRyxUypNCPtgDACaqJw52ueAMM4oNXeRM9Z5z/rSnQIDAZFMrbDGiU
         cRTrIFQT+CmnsSM4K8hhrUNInb07dw8QGt08SiW20b9s0j3hNtKxT5Nxb5Sayn4TYyzv
         hyIg==
X-Gm-Message-State: AOAM532e5Y4yoYSh8CRK/R7cK1MOgDkPbiwP+I0NnnzAAzyOlTTDfbYI
        vVtmdZjhIsGgS2RsyIcShZk6MkOzeoc=
X-Google-Smtp-Source: ABdhPJxWeAOFqTFc1z6NDk7dS2Nx647umStBvyoKiHvQ4bh+44xt9UND9STECbjrqP4BCkv73CVfKA==
X-Received: by 2002:a63:f942:: with SMTP id q2mr17500139pgk.573.1643646767996;
        Mon, 31 Jan 2022 08:32:47 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id nl12sm12999194pjb.1.2022.01.31.08.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 08:32:47 -0800 (PST)
Date:   Mon, 31 Jan 2022 08:32:40 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     netdev@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: Re: [PATCH net-next 5/5] ptp: start virtual clocks at current system
 time.
Message-ID: <20220131163240.GA22495@hoboy.vegasvil.org>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
 <20220127114536.1121765-6-mlichvar@redhat.com>
 <20220127220116.GB26514@hoboy.vegasvil.org>
 <Yfe4FPHbFjc6FoTa@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yfe4FPHbFjc6FoTa@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 11:21:08AM +0100, Miroslav Lichvar wrote:
> I tried to find the discussion around this decision, but failed. Do
> you have a link?

I'll dig it up for you.
 
> To me, it seems very strange to start the PHC at 0. It makes the
> initial clock correction unnecessarily larger by ~7 orders of
> magnitude. The system clock is initialized from the RTC, which can
> have an error comparable to the TAI-UTC offset, especially if the
> machine was turned off for a longer period of time, so why not
> initialize the PHC from the system time? The error is much smaller
> than billions of seconds.

When the clock reads Jan 1, 1970, then that is clearly wrong, and so a
user might suspect that it is uninititalized.

When the clock is off by 37 seconds, the user will likely post a vague
complaint to linuxptp-users asking why linuxptp doesn't handle leap
seconds.

I prefer the clarity of the first case.

Thanks,
Richard
