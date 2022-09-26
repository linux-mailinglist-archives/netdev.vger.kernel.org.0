Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 786695EB41F
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiIZWEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiIZWDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:03:39 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB32F1924
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:02:59 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so8350654pjl.0
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=iG5IW0JSXvDHPUhBmm25KDoROGtwoeP9Wl6CEV+mS6Q=;
        b=bH3XVvyeNNuMBwR/KDblcgO2wUIe3I4i4JFu4GLyRW3ThKNDfrBq05Phn4EHue23/P
         tawL2FBLBw21ueE0Kq/yI94WBlcQv70rR0t2LTm8B0fHFZmExa3SKYQIjulYbRs/0Tj1
         luG85TwnLv50EaLXnj7tN3qys76U5cG24DrVM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=iG5IW0JSXvDHPUhBmm25KDoROGtwoeP9Wl6CEV+mS6Q=;
        b=P41tVpEBm4eopT2uZs/mL2C1HJzTWGig5/oO23XiNXjNfyXd33JmjBD7zUDFzY3n4D
         amD2lfCfDF4tymEes3RAM8ASUF2wX20jiRlUwNdUV0W1Pv8RWNjOulXNxibzLoCr1OQc
         InnoUWd6z4hw9aDXwjnisryvygOYgdsNkbBQARri13o1+jJnMxXxZeENPe1+QP67Bg3R
         Zk+HMjlSfKE8rG8fBdUFVQptzDKHmFd76ON85zxcFmuQ+mSqUxu2GXlUJ5iVeafRTkxI
         A6HGb3xHO7UhQ6MHi6J7nEm9r8+1RBAO1lUJrGd8PCziYUay8WMLEaWig1lHcCaBIVC2
         4lEA==
X-Gm-Message-State: ACrzQf0nacgskIarf/a0a+o1VomNW9916NJHcs2ZyEdKwJayICBnDXSN
        XU/8qCgSraPHv4juKX5giVvBGw==
X-Google-Smtp-Source: AMsMyM6wNgrqDvRAOHLQVvZqYe6L7XT9isBSFukx03A5p2O37KxwRQFvgSB4cvWDSBH8916sJcBvCA==
X-Received: by 2002:a17:90a:6441:b0:203:6aa1:56f8 with SMTP id y1-20020a17090a644100b002036aa156f8mr888487pjm.25.1664229778898;
        Mon, 26 Sep 2022 15:02:58 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id mn5-20020a17090b188500b001fd66d5c42csm7022967pjb.49.2022.09.26.15.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:02:58 -0700 (PDT)
Date:   Mon, 26 Sep 2022 15:02:57 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] net/mlx5e: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <202209261502.1383266E@keescook>
References: <YzIestBCo0RL7sVi@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzIestBCo0RL7sVi@work>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 04:50:42PM -0500, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
> helper macro.
> 
> This helper allows for flexible-array members in unions.
> 
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/222
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
