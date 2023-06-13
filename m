Return-Path: <netdev+bounces-10504-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83B9372EBF1
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:26:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA6C41C20365
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD07C3C0B5;
	Tue, 13 Jun 2023 19:26:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCF817FE6
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:26:35 +0000 (UTC)
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657941BE9
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:26:29 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-25bc4c0101dso1904179a91.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1686684389; x=1689276389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+SosEkKxrJ4iAWZXd5DjfQpM6I+3FcUNGS4ZB6BQj4A=;
        b=JdzTuCqkydZaMrlBB6HTchxSO433vMvvLmkR4+JQpTxqGXNu1MkqdKezS1kWnXeC1Q
         grWqoJ4OFbqkQarU9txPOzOt9IXUAlOrWIE+XgJGBzLtDYyifdcngX8QR/fZVRlL/+vX
         rDkjGqQQ/sbh8tygrKUmbTadtIv4M6LPXRaLA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686684389; x=1689276389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+SosEkKxrJ4iAWZXd5DjfQpM6I+3FcUNGS4ZB6BQj4A=;
        b=UW67xF5WwXHgtP7fslgbgYuEPHqUpFs0Eglz0E79qtzSH41Vd9nOh9cGK1lG9MGINv
         kGHDj3ReKCwFjpJFSaD2RntnLQas4yF78Cpg22kzzTDjhFK7c54bTg2oBTiVNeXxqSj5
         3qwJFnvL5Q5CHBrlZZWXeZshg9OS7lj5hZdJLpWMp1E5zO9IB7d37Tq7xbbUsBBJT4yA
         ibHxBMc/79Ut3RlylywLCyNAcczZq9l6yK2VL/qSiVd6tQaS3/klMIzM6unFTtPl9awe
         AbBEF4m1+ItO+H/TfKRAprXWAmAknL1dnm/gXKzQfEUsQBcL1OPhkhm8ljOqwIENSHer
         9GVw==
X-Gm-Message-State: AC+VfDxorT+spKxkGZq19g0BjK2c6av6SLtbOFbps6kNsa7v8jlw9Uxn
	STxbsKMRVzWZBF/F/qw1IiGelg==
X-Google-Smtp-Source: ACHHUZ44VzTwH+0xXpJiQxXjGR6yiAwRkrzjcnEdzxWQzJhz/bD17uN1IGN7Ir14/V9fVnunMHnE4A==
X-Received: by 2002:a17:90b:4f44:b0:253:727e:4b41 with SMTP id pj4-20020a17090b4f4400b00253727e4b41mr10151302pjb.34.1686684388826;
        Tue, 13 Jun 2023 12:26:28 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id s64-20020a635e43000000b0053efc8ac7e9sm9724096pgb.29.2023.06.13.12.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 12:26:28 -0700 (PDT)
Date: Tue, 13 Jun 2023 12:26:28 -0700
From: Kees Cook <keescook@chromium.org>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, linux-hardening@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: Replace strlcpy with strscpy
Message-ID: <202306131225.6EADAF4@keescook>
References: <20230613003437.3538694-1-azeemshaikh38@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613003437.3538694-1-azeemshaikh38@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 12:34:37AM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> 
> Direct replacement is safe here since return value from all
> callers of STRLCPY macro were ignored.

Yeah, the macro name is probably not super helpful here. It seems like
it should have originally be named IFNAME_CPY or something.

> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

But, regardless:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

