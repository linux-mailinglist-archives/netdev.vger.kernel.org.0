Return-Path: <netdev+bounces-10572-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15D8272F28A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 04:20:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 399B51C20A61
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 02:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1402A38E;
	Wed, 14 Jun 2023 02:20:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF577F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:20:00 +0000 (UTC)
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF2019BC
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:19:59 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id 5614622812f47-39c873a5127so3548465b6e.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686709199; x=1689301199;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u552eQOgWUy1rtQH1DAKDFXYRjma9gSVdbRNm6si5vc=;
        b=PFhbgqHQA1xNr78bs+qPG/1YPQrHXQ73+cZFMBn72NzFMP8jHSJk9QTyUyY5JlGJjn
         dxziwHXbvmgDEcBABsEiz9eor7tGklHrfoadAsSwmAVdB6W2Zw4LzQnr35b8i47izDeC
         ppHDcUs643eKqf0eMunASZ4h5E+t/m8z3zjMqBGvoNgPooUHH1iAeKEr73EMhzZNeVZu
         r96LPLF+9Knr7X+KiGv/sv3DE9eqkqYEFw6ToL4GhnNpac42WJTvhqtHAniX4oqEoUJ2
         Pitc9uR4vv8Fc49yqo7o0GkreOXmEiEq0x6EHBTrr63gTmV7hwyQqIeYDs1TNhBXlnUw
         yg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686709199; x=1689301199;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u552eQOgWUy1rtQH1DAKDFXYRjma9gSVdbRNm6si5vc=;
        b=XjJ0oIciKkLPuaacH8OoWV0N/Mt+Klj8TMLFAGF3IY/uEKSiyVpo8MgnnM4vxsc2KQ
         HWlACc3bYLMdZ9hI/+FEx7aF9KcvCTxLg0NYHa0+nGDF1cTL+hk/7RYvyp771i9MbHDu
         ihmRPxV2LGVviqFFZBSc4qVlT/kvPq+fePI2S+TW7hRV87Zh4+g1E3oFmNGFsjo+exdz
         YmP3YaJikBoQx7ngoDio+6I7vLEHZ/g/O9roLVqyiwHTIQWuZmXLXtizyQzBHvwsRA7z
         OLmCuUybgBsGeLGscK90GWYBAjSp8xBI5JPpQ0tIR6pmlfUvZ+oK+YvAYb7pv5jmhyPn
         6n8g==
X-Gm-Message-State: AC+VfDxwm0jFjjHnsSX+kfnsH7BQrBbjpj9jiX6WTA9R+QUWGgciJWib
	xP35Tzm4qnXJOwfAoAAoIO8=
X-Google-Smtp-Source: ACHHUZ4osrhhRlFdK2dZoFcEF9c8SgV6UHsJICDJdFsDuqI1MDi+EyBia5CLc+CsFykqZjrDkl/DZQ==
X-Received: by 2002:a05:6808:14d2:b0:398:182f:2ba1 with SMTP id f18-20020a05680814d200b00398182f2ba1mr11282985oiw.25.1686709198652;
        Tue, 13 Jun 2023 19:19:58 -0700 (PDT)
Received: from [192.168.100.124] (63-157-183-34.dia.static.qwest.net. [63.157.183.34])
        by smtp.googlemail.com with ESMTPSA id u16-20020a17090adb5000b0025df695a02asm224709pjx.17.2023.06.13.19.19.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 19:19:57 -0700 (PDT)
Message-ID: <40616c85-fc60-61fa-c3b5-fcda82a4a46d@gmail.com>
Date: Tue, 13 Jun 2023 19:19:56 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH net-next v2 1/2] net: create device lookup API with
 reference tracking
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
References: <20230612214944.1837648-1-kuba@kernel.org>
 <20230612214944.1837648-2-kuba@kernel.org>
From: David Ahern <dsahern@gmail.com>
In-Reply-To: <20230612214944.1837648-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/12/23 3:49 PM, Jakub Kicinski wrote:
> New users of dev_get_by_index() and dev_get_by_name() keep
> getting added and it would be nice to steer them towards
> the APIs with reference tracking.
> 
> Add variants of those calls which allocate the reference
> tracker and use them in a couple of places.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v2:
>  - convert intermediate dev_put() -> netdev_put() in ethtool
> v1: https://lore.kernel.org/all/20230609183207.1466075-1-kuba@kernel.org/
> ---
>  include/linux/netdevice.h |  4 +++
>  net/core/dev.c            | 75 ++++++++++++++++++++++++++-------------
>  net/ethtool/netlink.c     | 10 +++---
>  net/ipv6/route.c          | 12 +++----
>  4 files changed, 66 insertions(+), 35 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



