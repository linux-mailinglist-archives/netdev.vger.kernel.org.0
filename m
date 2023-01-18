Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3976729C6
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 21:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjARUyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 15:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjARUyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 15:54:38 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06747ED0
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 12:54:36 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id v3so25469066pgh.4
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 12:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=38Ab1ydOxWFoCnQ1hn18tsTd/nLpjWDkMcuz9LcJhgc=;
        b=QcyKTP98pIj4xoEtMVaGgqSYkQu19v4GHm3EeHftxsvlz9FraAkTB6wZdkfNGVLtGd
         ugvtfy72K2zx1HqIbEIzd0CmgQjHeKQaFTLcEiTde2MxVGAPLpBkuXs9i+TD+Oery4rr
         M5Ee7c3RrmztbjIZM61dd1PYrXAP3IddNfsT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=38Ab1ydOxWFoCnQ1hn18tsTd/nLpjWDkMcuz9LcJhgc=;
        b=yrhPe0CfiMDBQDayo1460ZPBrJLVhCgPfYFcm6uLlYtR5SJIkqYVSwGC8V8ESIhNfo
         xLS1v1Nqb494/iGMkYMIVFM5MpBbcFoNnNx4mYB0xtt60gVgHR4wYXSZnrt3Gh2+W1Kr
         Kr6okMiPcNT8AKo65o9zANAOuEXEQCFgYfy4er4nmF6UUfXUraDgn080vUlKQ06P574b
         MzH/jHIWVxRiSYNwKszm7V2pozvqjH+Mmc4xBYA9AEjLyA/LVnrjI35PMvKaxAeTRkq5
         N419bluRA3CDlz5qUdmnRgHxrjdLtOU6K0lhxD6QhpLFkwUYVnC5chnktDF2H//7/8sg
         A6jA==
X-Gm-Message-State: AFqh2kqTTKwi18AkjdubD5hlGwYFQwyLkt0UfVSRF/KmS2i5sQIIPrAQ
        W1UdkbnZ/VuKh8hEkn3Br9EFTg==
X-Google-Smtp-Source: AMrXdXuiNSgEY7oHvEwxaIEKfBUrMnTDuVqSiNAxvJGyyZSQNRNFIyO+qQS75b9JhsA6buYwmwliog==
X-Received: by 2002:a05:6a00:4289:b0:583:319a:4425 with SMTP id bx9-20020a056a00428900b00583319a4425mr8760833pfb.29.1674075276168;
        Wed, 18 Jan 2023 12:54:36 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 66-20020a620645000000b00581172f7456sm5101790pfg.56.2023.01.18.12.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 12:54:35 -0800 (PST)
Date:   Wed, 18 Jan 2023 12:54:34 -0800
From:   Kees Cook <keescook@chromium.org>
To:     caizp2008 <caizp2008@163.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Yupeng Li <liyupeng@zbhlos.com>,
        tariqt@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 1/1] net/mlx4: Fix build error use array_size()
 helper in copy_to_user()
Message-ID: <202301181253.B19EE86@keescook>
References: <20230107072725.673064-1-liyupeng@zbhlos.com>
 <Y7wb1hCpJiGEdbav@ziepe.ca>
 <202301131039.7354AD35CF@keescook>
 <202301131453.D93C967D4@keescook>
 <11689498.158e.185b5471bad.Coremail.caizp2008@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11689498.158e.185b5471bad.Coremail.caizp2008@163.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 15, 2023 at 07:53:34PM +0800, caizp2008 wrote:
> my kernel config is config-mlx4-error.

Where can I find this config?

-- 
Kees Cook
