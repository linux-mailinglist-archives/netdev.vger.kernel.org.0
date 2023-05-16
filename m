Return-Path: <netdev+bounces-3082-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2490E7055E0
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:20:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B7861C209FE
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 565A23112F;
	Tue, 16 May 2023 18:20:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A0E107A5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 18:20:29 +0000 (UTC)
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E0A93D7
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:20:19 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ae4e49727eso1078035ad.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684261219; x=1686853219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wYBm9GcOUNPh4gLD7fS3/HVK5MmzEpTQ1UYJKsDW6z8=;
        b=ZpDWOGHhmLyAAR3xhqoNa9cHCEOfaCd0mVmq1oY9OAifiLQJPIAeDcvcIht0WKv8cy
         E4P4LnxaKMWlpehlw+14xCiOVeHMnRMwzLYGGBcC/85waa4EQvFMxrt3dhJbR8aZLMZj
         7MB+YXAb06DvCz9MejAWuoSkxao6BIe7GZygE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684261219; x=1686853219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYBm9GcOUNPh4gLD7fS3/HVK5MmzEpTQ1UYJKsDW6z8=;
        b=OHwwXL96iV3Vt1fWG23HnShbnNMu4WcwXNprDnuPVeEXiC5f1WMCkhsYyK9SIVIzxL
         I94PZl2rdRoPKb4pEqiMm+THtmqgiSM+Vtry6N7hiKxOc5OMbW2onKMcJJ5gWtyeBumT
         SJVoHX6K6JjGK2qiduUb2gPpL2Hk9LPN9WhVCbJWcNn0iexClR//621LR8CQroeWjLuE
         weFRInyNnWrQvHpv9B2MS25JM48y/5aTZtvqI/c1DTUPOcPzs0fgP7jWrPh5xhiDGVFl
         3I0A5BFW2eK73OQH2gK9hkcweqcaboiKukOTfQoWv6NX9e8kM73FMVPj25tCB6Ts7+2Q
         VFkA==
X-Gm-Message-State: AC+VfDyJuCCKRCMkQXKtcmrjcjRuvShHeIZ7UW2a2HuxEcmGdTkenWOG
	QXRwYc3K4+4/TtRkLMr1yFFieA==
X-Google-Smtp-Source: ACHHUZ4CrDdQ4iLXNCzFZanLvMVQj9bV0mnZNPCVTJTpjTHbdVtXwUPj91zfKnKk5etlpLq1vX01gA==
X-Received: by 2002:a17:902:d507:b0:1ac:310d:872d with SMTP id b7-20020a170902d50700b001ac310d872dmr50492221plg.52.1684261218846;
        Tue, 16 May 2023 11:20:18 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id q4-20020a170902788400b001a69d1bc32csm15799763pll.238.2023.05.16.11.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 11:20:18 -0700 (PDT)
Date: Tue, 16 May 2023 11:19:54 -0700
From: Kees Cook <keescook@chromium.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] wifi: wil6210: wmi: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <202305161119.A5486474@keescook>
References: <ZGKHM+MWFsuqzTjm@work>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGKHM+MWFsuqzTjm@work>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 01:25:39PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated, and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations alone in structs with the new DECLARE_FLEX_ARRAY()
> helper macro.
> 
> This helper allows for flexible-array members alone in structs.
> 
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/288
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

