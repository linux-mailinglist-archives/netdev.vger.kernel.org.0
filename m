Return-Path: <netdev+bounces-3081-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A5607055DD
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51B071C20925
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E42D3112E;
	Tue, 16 May 2023 18:19:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4213B107A5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 18:19:47 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9476A7EE1
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:19:37 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1ae4c5e1388so3231285ad.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684261177; x=1686853177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=alPm1FkLfJCzAk9pEVOJArmhF62w6dqf91iv/i5ryBk=;
        b=GfVb7bP9VkgyQIpD6rmCEdxEa2h4o48x0FB0TnkzXoe0SUE9nRrwUQ0Qx4s+FJPmUN
         o+GTZGH33myPwTlPd14fYLgg3Dbpev6hLXs3CIuI+C+mXv0lsQGdfzbsgR4KXgYJwRlL
         o5om+MRUpKCRVwbB+6dHjMS696gCKLhrt9p4M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684261177; x=1686853177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=alPm1FkLfJCzAk9pEVOJArmhF62w6dqf91iv/i5ryBk=;
        b=GujTof653sYOSDPDsqVpCEJdzaxuD1DuuQoYGCOAnwv3J8QkBi0D5uyU4MT16uw+wT
         TAtkQD3Ck/bRP5NAdXbASkvdEp8QLGbQLqZr429Grmk4Y11uk5Z2HXRb4p1QNFjmL8GQ
         3M8MxPH9DzWb5qAaylfaTWbpzFyu6+2lxFTFCVua9wvsSFSIOp7bPkPd6lagwe7EnTgO
         MXmmfo7tBpowbYnKFIqLhP8vXZ7t9m00Hd4KHpsAoO2WxbzVH1ImnAXBT+TUuxY5WnHS
         QeXUMXvs7QBWr7MDb7uVWI7eOJ5FRkIGmsU8VYJaYls+LkwlS3Sky5mSd4hGCRB6OxU/
         +a4A==
X-Gm-Message-State: AC+VfDykKS5gwMAEWUSH/oxQwFhhCLTloEorrylmqE73EysrJVOEZsIh
	1aZgWP1Fx/yuaCuNnQBpHCEpLA==
X-Google-Smtp-Source: ACHHUZ6uVa+nfzK9d6+UKGJYTR7xfDV6f0n91uwgaR0OIfF6UxU7TS/xzV7gJVCr5GhfD4qejQviBQ==
X-Received: by 2002:a17:902:db02:b0:1ac:815e:320b with SMTP id m2-20020a170902db0200b001ac815e320bmr36577912plx.17.1684261177044;
        Tue, 16 May 2023 11:19:37 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id g14-20020a1709029f8e00b001ac68a87255sm15831519plq.93.2023.05.16.11.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 11:19:36 -0700 (PDT)
Date: Tue, 16 May 2023 11:19:35 -0700
From: Kees Cook <keescook@chromium.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] wifi: wil6210: fw: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <202305161119.2158E464CF@keescook>
References: <ZGKHByxujJoygK+l@work>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGKHByxujJoygK+l@work>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 01:24:55PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated, and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations alone in structs with the new DECLARE_FLEX_ARRAY()
> helper macro.
> 
> This helper allows for flexible-array members alone in structs.
> 
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/287
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

