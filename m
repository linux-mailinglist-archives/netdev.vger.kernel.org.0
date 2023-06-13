Return-Path: <netdev+bounces-10503-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4458F72EBE4
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:25:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75BE11C20907
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42A093C0B0;
	Tue, 13 Jun 2023 19:25:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3382717FE6
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:25:29 +0000 (UTC)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB141FCD
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:25:25 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b3dd3ca7adso16341465ad.3
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1686684325; x=1689276325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FqljQgltrTWXp4tBsVykV34K/W0vrExZI9E6BwVeYrk=;
        b=Vuk5lprGVMjZyBqOAnxPZ1cP0qnAz1VOxXLVHd6COwWrk6uWeCNnFqJLd5ZlTB4xBN
         dzgZf7Jh9tixFAfZz3fmSPAlXZ/It7xgz3OZdv0ga4USAGY4venLvhA6oqd85Vcqq+o1
         kX6/a+xeL6i8dTiBdduqpe2IX31UD9Xg8A/SY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686684325; x=1689276325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FqljQgltrTWXp4tBsVykV34K/W0vrExZI9E6BwVeYrk=;
        b=Da0CtRXk4VR8dLK4v0VhxvX8jYqV4UYr0SiP+dgROrYzHsEIuwfOLNQS2bO6w1cnVD
         k0Ud5mqIArfhoGVesAzHHReGOXza48IKZYLDzmGY3VMXRcl5oeXkDTYusjkgs2IlVWzl
         Rlon/TC3HYSHlXw6kjLysKbR2gmd9SfInQtXq7jzO0N46ewqojs1Z2ybLoh+oAqXtnuY
         GsuDXy98OIcMNVArtlG4f5bYMnMa8JVOMlHDcaSIykPmfc2J6f5XVv6Cu8LhENBrlZKj
         KG6NNR3P/TQAGHkRl8kbNrmjLwLZ5AfBHSrNNNG0tnx+TUsapnQeS/I4/NMJF/MraNxY
         0kmg==
X-Gm-Message-State: AC+VfDyWTeF1sgi+PkzDQ+OSQHuhHS4Y9Rvhs9FnkiGBRM//duXrCIxW
	ej9wwKRZZvwEC2QCYQ5Ukn3rLA==
X-Google-Smtp-Source: ACHHUZ7qXyztF8y1MkcPh+Rc6qnYC3E972aaXz8caME05mHnNSqufHjosMNobu5acZ7aPD5pnWR3Bg==
X-Received: by 2002:a17:902:e887:b0:1b0:f8:9b2d with SMTP id w7-20020a170902e88700b001b000f89b2dmr12528414plg.29.1686684325037;
        Tue, 13 Jun 2023 12:25:25 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id l10-20020a170902f68a00b001a072aedec7sm10714545plg.75.2023.06.13.12.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 12:25:24 -0700 (PDT)
Date: Tue, 13 Jun 2023 12:25:24 -0700
From: Kees Cook <keescook@chromium.org>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	linux-hardening@vger.kernel.org, linux-wpan@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH] ieee802154: Replace strlcpy with strscpy
Message-ID: <202306131225.779997E@keescook>
References: <20230613003326.3538391-1-azeemshaikh38@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613003326.3538391-1-azeemshaikh38@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 12:33:25AM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> 
> Direct replacement is safe here since the return values
> from the helper macros are ignored by the callers.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

