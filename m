Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A06616D76
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 20:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiKBTIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 15:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiKBTID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 15:08:03 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F51C4D
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 12:08:01 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso2751962pjc.5
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 12:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vw1PeYfYrmcqxsdFm8vSKj6yNnyKJrjXBsCDkZ8l7vk=;
        b=XNJLSicRjEN8rmTBOFq4nZjBNIwb3bfbU77PQOf7hvq7/KsYyf4RBy+5zc2UAJlGhc
         TMgcRxRmNxosn3VWIIRRCpYt9DoDGwFFE5H6e1NdTJGJbA1bAcnhH8n7lpiKmKZMfShp
         b+fHS0RnxesbdRP/UtHxZ3cWF55CBAMmG0h1c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vw1PeYfYrmcqxsdFm8vSKj6yNnyKJrjXBsCDkZ8l7vk=;
        b=C5S6utpiPxeZAvolihWckxjM+CNROQNalTenAaknnVZHwPUWWlWx1LNAM31wxmMCTC
         j4Aliy6EFfvsab1HrMOxcTeLPiK/BkxB5T5ryRsN3MRSbn1/8Ln2wwC0C1Q0plbXtxu2
         5djZ9WWX75VpE49OdwoD6rEdfq7IRUVbjO3oDRhLUtyD9WrYYk7XRM5BRiVEsyQXw2Hv
         +fRfEwKnStuO5fGXN7BrUFjNiL5XPsEAdxSltmaWqweKRbbNstJvYA4pCsVWvxcN+Gal
         nsIV+7dGaqvSwNowuqVGqQyLrz4+RrBTf6WjJY8dpBZeO3zvVS0Yu0O7ou+Z+L6K7i6X
         wTqw==
X-Gm-Message-State: ACrzQf1ZFmVNJryz2y3uXuqMFvRamEYFxhhxVmGBm2ukcEOqlmY4iBRu
        k2UGpiwgrwcxk/t1+WOra+7l7w==
X-Google-Smtp-Source: AMsMyM7I9I7fudr6NNXqLACM4CekbYXQHH71Q92LDGS3KIiSUx5BXYQkZEVhg3knX05G924q3TSVHA==
X-Received: by 2002:a17:90a:3947:b0:213:ebeb:2cf3 with SMTP id n7-20020a17090a394700b00213ebeb2cf3mr16561908pjf.9.1667416081215;
        Wed, 02 Nov 2022 12:08:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h23-20020aa796d7000000b0056d2e716e01sm8015248pfq.139.2022.11.02.12.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:08:00 -0700 (PDT)
Date:   Wed, 2 Nov 2022 12:08:00 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Thomas Sailer <t.sailer@alumni.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] hamradio: baycom_epp: Fix return type of
 baycom_send_packet()
Message-ID: <202211021207.E41AE398@keescook>
References: <20221102160610.1186145-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102160610.1186145-1-nathan@kernel.org>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 02, 2022 at 09:06:10AM -0700, Nathan Chancellor wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>   drivers/net/hamradio/baycom_epp.c:1119:25: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .ndo_start_xmit      = baycom_send_packet,
>                                 ^~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> ->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
> 'netdev_tx_t', not 'int'. Adjust the return type of baycom_send_packet()
> to match the prototype's to resolve the warning and CFI failure.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Heh, this one was already using the enum for the argument to "return",
too. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
