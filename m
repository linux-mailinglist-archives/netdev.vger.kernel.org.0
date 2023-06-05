Return-Path: <netdev+bounces-8086-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 987B0722A84
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:11:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACA181C209CD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39BC01F93A;
	Mon,  5 Jun 2023 15:11:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8536FDE
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:11:15 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48171196
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:10:52 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f736e0c9a8so13505835e9.2
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 08:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685977852; x=1688569852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VywkTRlm66UyW5toiBcyg63jgGIZDp5t63NiR5LLW1A=;
        b=PF0cyPDt7hs733V1dbLy+IDGK1iZAR8wNoHvAyoXym3VA9l8yWU7GxSTfpK2JJYSnu
         eLUf44dmsYSS7qrbzK5fcQQAYZNfYqn2ZSRa2NLgmhFgJQ5WHz0cAv9XlvDbHbqRIw8s
         YPvDtLlpA3iIxUfa4LX+kE+8mb/eL7OmKu3Oeb7goz7wOt2zoAn+3NEf1pBzCzsSz3lS
         ePW7VeiPPMU6Nee5JdpWpNONH/tWhAZ4OCfpHZGDlQbOK3Ea9Bvb57+4p2wsRJjoIxLw
         47M3wVTaUOkj24TY99oiT0vOj5jhpBV/vPPDpKP2jLsMuqui9dN6z/FbYan1azd5/Fsj
         WbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685977852; x=1688569852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VywkTRlm66UyW5toiBcyg63jgGIZDp5t63NiR5LLW1A=;
        b=mEuADJgXGtMvp03AmxAKtumM+IM6UbnlS8LUqrQOYnTAvXbeYVCCXA+gWhhUKqy3gh
         Q2g8uBwStPVkuY5rXAKFTsb2Scx9XRKxsmcL0yAsFMBz0IsMbV2UXy0CJWXMgA2xgwW0
         g2iKOmX3R8st6dfpqxuq58R5q+xnNrymjiO6kVJDnagLtGX3cQ3RCu3f8MLL7zSzrw//
         cPqztZbQVN5GV4gDiVHgA6d7HECf8ZrKBlWJLeVJVV8DdpEArPT12XqfObaD2i3criq7
         DzBbCxYdNikQ6ld7qb9u5qYXICT86Yi0tgjHWPoRCBit1FfHIO+2DHiOl5qc8iBh68Rz
         5A8Q==
X-Gm-Message-State: AC+VfDx0wGPD5Ae17+6lQtxk5Wb8LiHEqouKuyTm026AEAydesCzefP3
	NrSiSvTLFXr8X2NSwvmqaweoSA==
X-Google-Smtp-Source: ACHHUZ6G9l4y8NXZB0LFM5AIrvOKTmvx3e/g9LzlkF7XrL356QdT41I+XsO+1NLUJfrkCqogmbOC9g==
X-Received: by 2002:a7b:c393:0:b0:3f1:bb10:c865 with SMTP id s19-20020a7bc393000000b003f1bb10c865mr7191603wmj.38.1685977851747;
        Mon, 05 Jun 2023 08:10:51 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id w1-20020a5d6081000000b0030adc30e9f1sm9977238wrt.68.2023.06.05.08.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:10:49 -0700 (PDT)
Date: Mon, 5 Jun 2023 18:10:45 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Simon Horman <horms@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Mengyuan Lou <mengyuanlou@net-swift.com>,
	Dan Carpenter <dan.carpenter@linaro.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: txgbe: Avoid passing uninitialised
 parameter to pci_wake_from_d3()
Message-ID: <3d2a0e2d-a72f-45f1-b9b6-c43c19a8fb16@kadam.mountain>
References: <20230605-txgbe-wake-v1-1-ea6c441780f9@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605-txgbe-wake-v1-1-ea6c441780f9@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 04:20:28PM +0200, Simon Horman wrote:
> txgbe_shutdown() relies on txgbe_dev_shutdown() to initialise
> wake by passing it by reference. However, txgbe_dev_shutdown()
> doesn't use this parameter at all.
> 
> wake is then passed uninitialised by txgbe_dev_shutdown()
> to pci_wake_from_d3().
> 
> Resolve this problem by:
> * Removing the unused parameter from txgbe_dev_shutdown()
> * Removing the uninitialised variable wake from txgbe_dev_shutdown()
> * Passing false to pci_wake_from_d3() - this assumes that
>   although uninitialised wake was in practice false (0).
> 
> I'm not sure that this counts as a bug, as I'm not sure that
> it manifests in any unwanted behaviour. But in any case, the issue
> was introduced by:
> 
>   bbd22f34b47c ("net: txgbe: Avoid passing uninitialised parameter to pci_wake_from_d3()")
> 
> Flagged by Smatch as:
> 
>   .../txgbe_main.c:486 txgbe_shutdown() error: uninitialized symbol 'wake'.
> 
> No functional change intended.
> Compile tested only.
> 

Almost everyone turns on the AUTO_VAR_INIT stuff these days so that's
why we don't see these bugs in testing but they are still bugs and they
will affect people who have that turned off.

CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_BARE=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y
# CONFIG_INIT_STACK_NONE is not set
CONFIG_INIT_STACK_ALL_PATTERN=y
# CONFIG_INIT_STACK_ALL_ZERO is not set
CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y
CONFIG_INIT_ON_FREE_DEFAULT_ON=y

I did report this bug, but I only sent it to the original author and I
CC'd kernel-janitors.  In 2009 when Smatch was quite new the netdev list
was annoyed by static analysis bug reports so I stopped CCing netdev.

https://lore.kernel.org/all/YsWWXYal9ZwmIo2G@kili/

regards,
dan carpenter


