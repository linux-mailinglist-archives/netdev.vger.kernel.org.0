Return-Path: <netdev+bounces-5751-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D4D7712A40
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:10:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 828331C20C79
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61B127711;
	Fri, 26 May 2023 16:10:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F8A742EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:10:45 +0000 (UTC)
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463FBE41
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:10:36 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4f3a9ad31dbso1035747e87.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685117434; x=1687709434;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gRqtf20Zyw/eUJigoBjplcoiLQHtDmcweGJHFBjhwxw=;
        b=G9QwBt5smZ2pr868PDTwGskX9AEfSOkOccrEEw9aL8IgbmTTmePzjioIOfu8aMUJ3j
         xok3/sCPu0lRngMIb/kKzS/tztrNdsoFQYPgaB1vRypxUwaNgsMe6bIlEMbbh6GBd3lr
         q4fGWWFGyN336Y+eMn0+l9Qqlj88Pz6JDQomcmomBR7Qyb4dTJ7Au+liBaNEFoZ0rIiL
         Lu+f2xfbwyzeJcurhx7WbbibUIgHvk+q4cIOM1YxHXFZJ5/t/D/yHiMhP2dRvRpCZa9g
         0ZQcHOvRXw/q1mgJoh3gkUAGYrL5B5CXoQnKxQqKvCQLWUIkZbm3AXWZiPWQwwUx3x3k
         3hDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685117434; x=1687709434;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gRqtf20Zyw/eUJigoBjplcoiLQHtDmcweGJHFBjhwxw=;
        b=SdmQJw5c7mIJnRYYjckryawKV4hsYMGo9LX9V21bk0YweOsS1R6WMJ5bO5mSKYDcYB
         mc1RPoZc/GZqpnxcKZJTNgeETh6/vzUPtX3vqsbIXINcn3gXF92QUCgSpCKQBpbb4nvZ
         ozagIlikC8CND3R/iChWE7c9YEMhk+smkTK9L0nz29mgHLlpRvG6afFoZWd5jw6DhBun
         L/QAgU+DCprGy/KKOY4UPCooQ0tcSTbgFWUdNE7o2e+vT8UsnaQp3+BcRBZ2RQiUoUEc
         3ibO4BtcyV13jAt/urlFLOFz988Hmbek5K+VebpVKid6IsxJrm8ijvFzlNQQIO8OEfu0
         4iZQ==
X-Gm-Message-State: AC+VfDwNwAQFVia2GAGKGbKDimvI+1HBB6IxgznWbg7URaIBbHhAAYyT
	ApN1ZNEjsJOsZSoecn3CkGZALg==
X-Google-Smtp-Source: ACHHUZ5N2NAgrMVINU3eq0ZhD3xFOoGgyWy1XrAbjL42a3dgVehAoxgdTwxyg1A9sG7VK8/37Zr4oQ==
X-Received: by 2002:ac2:51ad:0:b0:4e0:a426:6ddc with SMTP id f13-20020ac251ad000000b004e0a4266ddcmr776070lfk.0.1685117434326;
        Fri, 26 May 2023 09:10:34 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y16-20020ac255b0000000b004eed8de597csm679541lfg.32.2023.05.26.09.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 09:10:33 -0700 (PDT)
Date: Fri, 26 May 2023 18:10:32 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kees Cook <keescook@chromium.org>, Jiri Benc <jbenc@redhat.com>,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: fix signedness bug in
 skb_splice_from_iter()
Message-ID: <ZHDZ+G51wKK3/XMi@nanopsycho>
References: <366861a7-87c8-4bbf-9101-69dd41021d07@kili.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <366861a7-87c8-4bbf-9101-69dd41021d07@kili.mountain>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, May 26, 2023 at 03:39:15PM CEST, dan.carpenter@linaro.org wrote:
>The "len" variable needs to be signed for the error handling to work
>correctly.
>
>Fixes: 2e910b95329c ("net: Add a function to splice pages into an skbuff for MSG_SPLICE_PAGES")
>Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

