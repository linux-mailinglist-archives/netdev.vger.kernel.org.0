Return-Path: <netdev+bounces-4005-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AACC570A0FE
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 22:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9354281B5D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 20:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F7017AD4;
	Fri, 19 May 2023 20:43:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A91174F5
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 20:43:22 +0000 (UTC)
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B3B116
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:43:20 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-64d3fbb8c1cso705632b3a.3
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684529000; x=1687121000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zP2JiW0s6i7CsnRczgnMBoK2ogXPQTY2MGcULts75HQ=;
        b=is2BEchmVbWZUPYljUKRqkwul3Udx59yJa8kLGXn1JXLZbeey2LIyZNOmlb07lwHjW
         d+9oIl7bL1riqaNnxLhRXdCM056p34fb2eGKMRT9NRVh3ZjKedmqmShyiN+MlQNeuFlP
         vE7UCh7fG0KfBpm2bpJnIWV9MgxVhR+T3+6hxw3MAoNDnUCAIeFKHBVUlCUfap6xz88z
         tmmTyYxOE0oo3jpSxUgVJESzAB9mF8vkzOM+Ca3fanGc+q7LnW+ccWZG1TreKn/cD6mZ
         lv6aCTW24rkeWqeS5u7VXZEoZoy7SeDfnzgGz6Zvpv8pLmduZiGQDTIJYsul2h6D27pm
         bgjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684529000; x=1687121000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zP2JiW0s6i7CsnRczgnMBoK2ogXPQTY2MGcULts75HQ=;
        b=WgQX1gYRG6d9PJkCPl//Nsv8FYS7w1PbVycm5txOZsmdNH9E8mM4+lx8Qg04CS9wgO
         7M8BN5GNDa/3P01qOucV6D379xH/1ISifUo6yrl2Uz/ROH5ZvtclmN0DoM32sCFG/+7w
         b+gnux7e8KWzxkpjdsWyEUgKc/kRllc7EEpBNIz46cdsREtBGy5QDYamLE3OOT8KfH8B
         PuOBWNh/UoO0owJW1e6N9otP98KHRbB6MsGo7RAAOrcZoOPmYvtpBR3CdddEc5cJHfI1
         0P6Tqkv+mknZLO61fHESWYaGxehrMkIKMR/PCibJUNVHN69R8dFkmobkExHkHdz4Gtrl
         FD9A==
X-Gm-Message-State: AC+VfDwqzUKwP1t5OKiUlginObUKRguR852adEQQpn5/bKEDwHqRB1vi
	GllmzMJdFkSjKgbWYEl0DtE51w==
X-Google-Smtp-Source: ACHHUZ6JUOGmiUq8de/Zny///rS9xp1/hSfqjNB8q5hvzUWlcTXGqfu0vJQYMZ2JXrwDAB+vqE00eg==
X-Received: by 2002:a05:6a00:98f:b0:645:cfb0:2779 with SMTP id u15-20020a056a00098f00b00645cfb02779mr4852607pfg.26.1684529000445;
        Fri, 19 May 2023 13:43:20 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id i24-20020aa787d8000000b0064d3e4c7658sm107782pfo.96.2023.05.19.13.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 13:43:20 -0700 (PDT)
Date: Fri, 19 May 2023 13:43:18 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net,
 kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH net] rtnetlink: not allow dev gro_max_size to exceed
 GRO_MAX_SIZE
Message-ID: <20230519134318.6508f057@hermes.local>
In-Reply-To: <25a7b1b138e5ad3c926afce8cd4e08d8b7ef3af6.1684516568.git.lucien.xin@gmail.com>
References: <25a7b1b138e5ad3c926afce8cd4e08d8b7ef3af6.1684516568.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 19 May 2023 13:16:08 -0400
Xin Long <lucien.xin@gmail.com> wrote:

> In commit 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536"),
> it limited GRO_MAX_SIZE to (8 * 65535) to avoid overflows, but also
> deleted the check of GRO_MAX_SIZE when setting the dev gro_max_size.
> 
> Currently, dev gro_max_size can be set up to U32_MAX (0xFFFFFFFF),
> and GRO_MAX_SIZE is not even used anywhere.
> 
> This patch brings back the GRO_MAX_SIZE check when setting dev
> gro_max_size/gro_ipv4_max_size by users.
> 
> Fixes: 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/core/rtnetlink.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 653901a1bf75..59b24b184cb0 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -2886,6 +2886,11 @@ static int do_setlink(const struct sk_buff *skb,
>  	if (tb[IFLA_GRO_MAX_SIZE]) {
>  		u32 gro_max_size = nla_get_u32(tb[IFLA_GRO_MAX_SIZE]);
>  
> +		if (gro_max_size > GRO_MAX_SIZE) {
> +			err = -EINVAL;
> +			goto errout;
> +		}
> +

Please add extack messages so the error can be reported better.

