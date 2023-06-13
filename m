Return-Path: <netdev+bounces-10502-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 286E372EBE2
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:25:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5116E1C208A8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A4633C090;
	Tue, 13 Jun 2023 19:25:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA5917FE6
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:25:14 +0000 (UTC)
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CDF199
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:25:12 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-25bf4b269e0so1735869a91.0
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1686684312; x=1689276312;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pF2h1PhbUZCakO9HzT4Rd+vAXkEtKn6aAJnn/Olzk7Y=;
        b=ZU3MjfCE6Bh7fjFg1BjEDJSesHastV05YBYNgqy41DzneH7oHeJm0hjPHEGpA+EXOf
         SG0w/KdxLi/052dMX5jl+FhfITGRS8mugUn3zKE3/eLMipX8oltrWHNWBmc0cN1ljQZj
         mHbEmFHWq7dz7xcNdDtR8r5WSwa8L+3oVanTE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686684312; x=1689276312;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pF2h1PhbUZCakO9HzT4Rd+vAXkEtKn6aAJnn/Olzk7Y=;
        b=OJIRxVrB/eOZr+O8MX53JlWWzsKlwPr+EfsCUjoNImBybv28JGOmxq3PR8CC3m3w1R
         1fHLhc3Y8DRWHTDojLXtLj1vsiuThAbgCgiF0oEQIQP8DZVk2tqhTm9JM52M2tcbulDZ
         Q1kUUm5nCSBoypGBNQZ16L2CACPb2yudWlYV30Q5TvcrMLly8sppJ4+LEngdmY7TtLcG
         I14ttFmBNhu8Ss65eGcWg/vhD9QB4TsUZ+VGLgIKVWpea5JF4vi1Cdxxdq2jQgMQb0Ry
         ZQHWR4NyoXEtBW0zevgGnYYIRejTUee+dNoGdvTv3EYL5s+ZFfQBTnkihKw3Q38DHC8K
         vzOw==
X-Gm-Message-State: AC+VfDwzryE5S4I3I7294CTuGCjTdZwfRqwVqTfync0IPAhBcJ7kfBT2
	C1w4rhD2JTvLi8lW9PrYPWrDO9Q4y/xzgItLaok=
X-Google-Smtp-Source: ACHHUZ5PcTot62BlDuw88kgBfTRj1f+G5oPoENpd58CdgZFu8Kh7kup0ho97mveBi1GFUbg3BuXnpA==
X-Received: by 2002:a17:90a:d252:b0:25c:2a59:fb2d with SMTP id o18-20020a17090ad25200b0025c2a59fb2dmr1703066pjw.8.1686684312104;
        Tue, 13 Jun 2023 12:25:12 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a194300b00253305f36c4sm12184899pjh.18.2023.06.13.12.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 12:25:11 -0700 (PDT)
Date: Tue, 13 Jun 2023 12:25:11 -0700
From: Kees Cook <keescook@chromium.org>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-hardening@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH] mac80211: Replace strlcpy with strscpy
Message-ID: <202306131225.1480125B66@keescook>
References: <20230613003404.3538524-1-azeemshaikh38@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613003404.3538524-1-azeemshaikh38@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 12:34:04AM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> 
> Direct replacement is safe here since LOCAL_ASSIGN is only used by
> TRACE macros and the return values are ignored.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

