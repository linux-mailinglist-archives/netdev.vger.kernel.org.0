Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40272522032
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346500AbiEJP6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346756AbiEJPzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:55:02 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AE9285AC2
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 08:49:06 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id w17-20020a17090a529100b001db302efed6so2494727pjh.4
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 08:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=INhlKhGvpbu7fgZ9vELnJ2sy44vYqZ9ozRxM6uzB+QM=;
        b=kXb7KvLTy7DujcSQyAk8xUP6oTufpB/UG5TBPFNOvIwxey942mY38akAy2aRVoGjR0
         99pU6OXXmdz5Zng0u219mGDLrTqIxto06goatJ7Gc9drNL/LAysOCLtl81MUs4K/l4NP
         pza0Xw89EtEmD8zkZwShTzoruWUxzCjyf8Zkw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=INhlKhGvpbu7fgZ9vELnJ2sy44vYqZ9ozRxM6uzB+QM=;
        b=2cGk0gQzu9aQKL1RR8J9g2rSEQrVXwMg4JCk0jQVLN0xL6J9dsZot3J+M9gD3tbcVn
         81IA3HOqp6dy84jQpBe6qnNxZ9qwKfAsij78iizbIniNrcx3votGSk+aJVQB4L+XkiVA
         OkWY+khQAaZFLAuK0dv1Juo74zhX20TFwuZWX38GdHcHxP0LieS4dt8WDt24YtViimy3
         sYB+BDkHoVNeFj65CQ2V+3pIPMjntQjui1ofuiNbSV44Fz+6gOhUG8FhloRId2vAeUz4
         Z5PRgo5tmItFQ724HR/C3ekTDAF9S/CfSZVnWGmnmqM4vaY88nTLHGu2W6R5g1MdDCXc
         lXgA==
X-Gm-Message-State: AOAM530mbcFPb1Xd6eqC2mbff5Kau8oTk/GLFYd9Eb5J5hzQvqm5sgp5
        vneuIi1kfjzXntx52s0jnxgfWg==
X-Google-Smtp-Source: ABdhPJwimId/P5IhzKoL8Uc2YdZ50wmCJQRH04A+W2g2mcs/4LXkOtBcKfsI8+a4nHfsbaKY9ROEBg==
X-Received: by 2002:a17:90b:1c87:b0:1ca:f4e:4fbe with SMTP id oo7-20020a17090b1c8700b001ca0f4e4fbemr582842pjb.159.1652197745191;
        Tue, 10 May 2022 08:49:05 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d8-20020a170902cec800b0015e8e7db067sm2322580plg.4.2022.05.10.08.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:49:04 -0700 (PDT)
Date:   Tue, 10 May 2022 08:49:03 -0700
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
Message-ID: <202205100846.4E07C4E5@keescook>
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
> On Mon,  9 May 2022 15:21:49 -0700 Eric Dumazet wrote:
> > From: Coco Li <lixiaoyan@google.com>
> > 
> > mlx5 supports LSOv2.
> > 
> > IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
> > with JUMBO TLV for big packets.
> > 
> > We need to ignore/skip this HBH header when populating TX descriptor.
> > 
> > Note that ipv6_has_hopopt_jumbo() only recognizes very specific packet
> > layout, thus mlx5e_sq_xmit_wqe() is taking care of this layout only.
> > 
> > v2: clear hopbyhop in mlx5e_tx_get_gso_ihs()
> > v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=y
> > 
> > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > Cc: Saeed Mahameed <saeedm@nvidia.com>
> > Cc: Leon Romanovsky <leon@kernel.org>
> 
> So we're leaving the warning for Kees to deal with?
> 
> Kees is there some form of "I know what I'm doing" cast 
> that you could sneak us under the table?

Right now, it's switching that memcpy to __builtin_memcpy(), but I'll
send a patch that'll create an unsafe_memcpy() macro that does the right
things vs kasan, fortify, etc.

-- 
Kees Cook
