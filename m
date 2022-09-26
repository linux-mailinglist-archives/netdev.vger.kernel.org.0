Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBF55EB3FD
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiIZWAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiIZWAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:00:34 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C089FA92
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:00:33 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d10so6902069pfh.6
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=vA/6myQNQnJHYk+EUx6DGwR93ze/m7/gJ74a1YFBZ2E=;
        b=U8sJtotxHMan7w/+4cTY25Ek0IfBdX5nCMlrmk+usONkjHNzmc7aD7dc0o8CYs171r
         tQ/XiitLYP4hzQ8L64lYJumQEojtI9TgQluFVjbRZDcyZ4/NDftB8giHUEk0o/af7Yca
         4HFZaiM/0R/tiAmzw0SY5Bbr5mQZqxk6Esb7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=vA/6myQNQnJHYk+EUx6DGwR93ze/m7/gJ74a1YFBZ2E=;
        b=dwjUEHidcrvhyl41gmMHHBdTFWF4QFgtLohjCjzsm2w+PTcEJkuCc0JDsTSn6e8y/e
         uZneBMpIFc+uxOeap3WGV9LKb5/ggZBbnKevC8+ct101b/+P18BUv+HoxuKeGhzEO1vp
         5KWol/MVnUsbMNvaS5eqwxP3O5Otv5GF5K93kI3GhTusqLXHVrlHb55lxLAoFUjNGCow
         orbKLO0BPXjpOWLUTYwp1325vTB+SkytrGw9TB+pcjJ9+mFowSk8rTbmiG49Ar/9PMb2
         Sdcz4S2uVnzZmaaVH/qbmuc5yh59lyjBkDUBJ8h4KuHgeMMy2mhwgFOa4/Dw4MUHv51t
         jCMw==
X-Gm-Message-State: ACrzQf3GMiIC+HkY4fVvELj4oAlinWbY9Lcxcz7F4Erl7+kqJBYglsvU
        uWU3GO9iaaR7SikqgWG9gwdmug==
X-Google-Smtp-Source: AMsMyM5JiIgVIgSTi23Z1w9ajKUhq1aAliulpHYeL13NSOYqKW4HOG61sl4hc17hHP8PREpsKCyqHA==
X-Received: by 2002:a63:fc5b:0:b0:43c:3f90:ca07 with SMTP id r27-20020a63fc5b000000b0043c3f90ca07mr18295865pgk.110.1664229632744;
        Mon, 26 Sep 2022 15:00:32 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 7-20020a621507000000b0053e80515df8sm12685410pfv.202.2022.09.26.15.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:00:32 -0700 (PDT)
Date:   Mon, 26 Sep 2022 15:00:31 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] ath10k: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <202209261500.38CBB07FB0@keescook>
References: <YzIcoloIQBDqGlgc@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzIcoloIQBDqGlgc@work>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 04:41:54PM -0500, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
> helper macro.
> 
> This helper allows for flexible-array members in unions.
> 
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/212
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
