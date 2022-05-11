Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFA8522A19
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 04:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiEKCzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 22:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiEKCzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 22:55:19 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAE3245A1
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 19:55:18 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id e24so965810pjt.2
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 19:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e5TSQmlaIE97V89CsywSF+QHSB2mdkRsJ1zhFO0li3k=;
        b=HNEmXx5yKJfZlK79TRxc76Fi0dg1ENK4ytkbziq0xdFm88B8LqofYUV3OWGP+OiX9e
         gyF6OaKmDtkd06comB0u5fpHe7GZiwMZdBWGD/QES/nPdeTSk6TB4zrKSLiV9ak/Igoi
         0B9vR8GLI6PfuhJK8PmzsxtasCp7ukGcgQPoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e5TSQmlaIE97V89CsywSF+QHSB2mdkRsJ1zhFO0li3k=;
        b=Us9b3kVNJVrCNIxZ+sFNm6prB5fJcpW3yRk7xze9JKHxeeInScVHDA7wtgAhLSpzKE
         XH7nRzyYZY25oAqZj/QvQ0/BxsXY/70i11Qt1qJS/t2sFhdQiosL0y9jhocurI0aFKZb
         LaF5HeVIT/BCwW75d/elreC1RjJpUa++FKBGpxZSTm56I+O3H5peCFL2CrXdxmr0SjGB
         TmU5C++Kti4/24pl4QWHspOWr1rwBvSRAJaM2EaI2kUZ+3yrcSX4Y7otekYBhKsb1NW3
         l/nWZOqVHw6O3IaHzR9ZT/oKYf+OdSuZWXjMc5XEUlx/FjQTUFhuLPmiQhEH4RefaFhB
         c0YQ==
X-Gm-Message-State: AOAM530D3jNmE+0dBg4+BwGcu8xe/G7cxXAMwamdDbwIc4Qne62MJXi4
        83sUoVQaobhlX1w7RuLsvO/fBg==
X-Google-Smtp-Source: ABdhPJyrWApA8UEMZpSM6gQ2LnLcbj2vFNyozpreJgBtsJpytNcU29a8WX77PpuOeo9w89z1GTKGkQ==
X-Received: by 2002:a17:903:2406:b0:158:f6f0:6c44 with SMTP id e6-20020a170903240600b00158f6f06c44mr23227935plo.88.1652237717893;
        Tue, 10 May 2022 19:55:17 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id ft16-20020a17090b0f9000b001dc1e6db7c2sm2570541pjb.57.2022.05.10.19.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 19:55:17 -0700 (PDT)
Date:   Tue, 10 May 2022 19:55:16 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v5 net-next 13/13] mlx5: support BIG TCP packets
Message-ID: <202205101953.3C76196@keescook>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
 <20220509222149.1763877-14-eric.dumazet@gmail.com>
 <20220509183853.23bd409d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509183853.23bd409d@kernel.org>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 06:38:53PM -0700, Jakub Kicinski wrote:
> So we're leaving the warning for Kees to deal with?
> 
> Kees is there some form of "I know what I'm doing" cast 
> that you could sneak us under the table?

Okay, I've sent this[1] now. If that looks okay to you, I figure you'll
land it via netdev for the coming merge window?

-Kees

[1] https://lore.kernel.org/netdev/20220511025301.3636666-1-keescook@chromium.org/

-- 
Kees Cook
