Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE285EB7B6
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 04:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiI0CcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 22:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiI0Cbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 22:31:55 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA57E1716
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 19:31:53 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id l65so8445174pfl.8
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 19:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9ewTPKheQH/VeUeUiLVY8qIwxsi5cTHr9IDNehA24WA=;
        b=ceUgxe/lC5UBEuGusxsxqzbk90I+VRqqgcguETsJRXfKbyb8zrK1hg9YIE5JlhVEg5
         URXKy3fH3YnoK1O6XjVEfJj794ySV3BXKo2PBpA0KQEn77s1hAAAJyNvP4CMwZ38c3Ik
         YGVWmTp6yL9XcrUlmqJy0/z09zMbE9RSNCkHY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9ewTPKheQH/VeUeUiLVY8qIwxsi5cTHr9IDNehA24WA=;
        b=LKXXenasjgTcuIRnpGfatW/qWZG9i1D2QCOc1nb86OzcJFFxS5kEsTW/rSKU18Mhib
         X5bFYwuhWDCWVYMfc6oRqssAmmoRz4Uqj+0MRIn2lNvzdNRHZL0tzR0nS8GxLVSFHH5g
         AZ631nSayKDu1pOuKRi7WFmgWS0nCUln4Od4WyUDWNCaMaV8HYhs+I764t3yp1ZLNOpa
         BnyEraZv6uA5+uJTzzw+tbCCd9ygs1/oa3uYT5fNiD5K15XN2b2p48p9OVWzOkdio2Ug
         /zynJrbxBFVG5no9eYISU9tgU3aiNKLGTGcnFVQ3TKhswVpahHYeXNGsluXmvhdds4SP
         K9gA==
X-Gm-Message-State: ACrzQf1P3F8IBHIs30/szE2mGesC8l3+imy2TOT17/1ZGG3yzNujaWME
        qQlokVPrcLhv8cKL91JNHk6H5w==
X-Google-Smtp-Source: AMsMyM5gEWRHn2o1zuyvj0dRXD8PdoFzFHrXCz4JBSPqHHGptBvX5j2Odrepujc2SJSxuBD4q9WI+w==
X-Received: by 2002:a05:6a00:9a7:b0:54c:27c4:3ad6 with SMTP id u39-20020a056a0009a700b0054c27c43ad6mr27287556pfg.9.1664245913313;
        Mon, 26 Sep 2022 19:31:53 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f13-20020a170902684d00b0017872bc9865sm168795pln.63.2022.09.26.19.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 19:31:52 -0700 (PDT)
Date:   Mon, 26 Sep 2022 19:31:51 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Stanislaw Gruszka <stf_xl@wp.pl>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] iwlegacy: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <202209261931.EB84C573@keescook>
References: <YzIvzc0jsYLigO8a@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzIvzc0jsYLigO8a@work>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 06:03:41PM -0500, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
> helper macro.
> 
> This helper allows for flexible-array members in unions.
> 
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/223
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
