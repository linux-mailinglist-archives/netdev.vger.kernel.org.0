Return-Path: <netdev+bounces-3080-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E54A37055D9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA303280F23
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6723112D;
	Tue, 16 May 2023 18:19:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AA7171CA
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 18:19:14 +0000 (UTC)
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8282735
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:19:10 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-643ac91c51fso9496585b3a.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684261150; x=1686853150;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S2KXWalTdvuGRBWwyxeiECFs48vb0kc6jIG6BVZ17mo=;
        b=Z+oc/RnmkqCau1eig8XC59UFZDXTkKpJLVIle+4Fox0TpnKXHVaVyftTO51uf+LWTX
         IcxX+7w1jlQ3yRO8Q4hNA1rbsRiqf14wZo1H/OmgD0pGGRHlElIMPYPqO0hK9ONPzhL0
         U3caLl/jlIPZqNdr5fhCkQQMWIz7+cJDQYnY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684261150; x=1686853150;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S2KXWalTdvuGRBWwyxeiECFs48vb0kc6jIG6BVZ17mo=;
        b=V06aw/62mqnwIrRDWvjBtE8ptuKMgtEifn4FqY1ezRw9ZQkxw6KXx1WKXkpnADWMe7
         Qhijbim9ajVVj269XyefsHy7nZA7DsWVNIEPQlyPtDcOuEz21QwCb90TtqqvlfzJq3CO
         Pw8YCnpFvjqZsJjKSXP+q5aeStY4026rwqIu58EpDtT+MqRqQbNz00SzSHJTe/lJAj+H
         jR5+bVmM9MkjYD6D5LJ7FZjNbpWekASnO8zoJNiTih/gUoI4HU4YNpqAWZmlOjK+m3/t
         YvPbd7t2QmpipzEBxTNwO9Dl1P9ZrPhDu2rH+8FMqUQy7b1gCaheH3F4QvbJly3RcqxV
         a9yw==
X-Gm-Message-State: AC+VfDx00XRFPYvqiDKoXs1+BO1zjJwjN5Voxmr0BUTyymuUnl0EA4Dd
	rLNTSsbXBKOUImqJrm+HdIaj81b02nxRdFN0nk4=
X-Google-Smtp-Source: ACHHUZ5JIQKxCPQ27BHIeg2iA39AMfvy4E6QWK0tSVz7aRpKK8uGONHyNmjFI2YOy2GrosvFVaFsWA==
X-Received: by 2002:a05:6a00:22d3:b0:64a:a432:f313 with SMTP id f19-20020a056a0022d300b0064aa432f313mr22510808pfj.31.1684261150336;
        Tue, 16 May 2023 11:19:10 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a6-20020aa78646000000b0062607d604b2sm13768911pfo.53.2023.05.16.11.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 11:19:09 -0700 (PDT)
Date: Tue, 16 May 2023 11:19:09 -0700
From: Kees Cook <keescook@chromium.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Jiawen Wu <jiawenwu@trustnetic.com>,
	Mengyuan Lou <mengyuanlou@net-swift.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] net: libwx: Replace zero-length array with
 flexible-array member
Message-ID: <202305161119.B6E9737124@keescook>
References: <ZGKGwtsobVZecWa4@work>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGKGwtsobVZecWa4@work>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 01:23:46PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated, and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Transform zero-length array into flexible-array member in struct
> wx_q_vector.
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/286
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

