Return-Path: <netdev+bounces-2999-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE050704F4C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:29:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 030F81C20DC4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38BC52771D;
	Tue, 16 May 2023 13:29:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC2E34CD9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:29:23 +0000 (UTC)
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7AC30D2;
	Tue, 16 May 2023 06:29:21 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-643557840e4so15179009b3a.2;
        Tue, 16 May 2023 06:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684243761; x=1686835761;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3wrNPJ1N98rVkDqpmYGeRIPO4+D5MBPm+JHAP5bi0lI=;
        b=SjRtJegJE4MAr3atEsh5GrsX4kXV3ummaSZDrZ73xCZ/6kfoKd46bGOkXMQZb54Jj1
         4puqH8dQO7OZTsvvpSjwvp8K8RfvAP0ko13wSCMifnh2TWHbJUGJLXQ/SwjbP2NGtYzN
         DUQOEPhwWew1+J81Mb7HdX2Hwg81LxoND9KpbzHdgaS79Kwvj7KLzNg7AagAewAiIgqO
         d3Ng/7OU1xOn9AUAnpP5r9+hDoVNWvzD5kWguU2cqii3HaJO1JZb1lTSsNydYYFw8/IM
         Ag7PWA5GTd9PB/B0/ZMc+TocjtWwMxfu3E9cmVPYea2NRcT9areWz+DrQhiDX2w2i3aR
         BUiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684243761; x=1686835761;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3wrNPJ1N98rVkDqpmYGeRIPO4+D5MBPm+JHAP5bi0lI=;
        b=VX/8P+3YNZ3aZ4+0pSGeQ+/hxhofAYdkNTJBe4V1ZciIPwSE9mGcWNQBJgMjiz0umU
         mMt30o2w2j7jeNaaCXFMnjVK6luwjipk8i+mZFLkPYtpbSJ7oV2TKGYUwjAVkInXm5K1
         /nB/tJx/9WzS/4vvWT8LisGrfcpmeJ6+Jq2jyVVudSkabg5FZL/yy19MBIJEpwQxYR2T
         JqluFYry85OzZaw41CDkYE4cWdx7vomXWQBqhZQ/tE3nlUNaAOMfbqnXiGLxhiunF+8f
         pkhePQfN7vKW7w9LgCby9I8r0gXauV3niRFOh8uc779uhWsPv5o2dA/r4C6J9Er4JXj6
         JI0g==
X-Gm-Message-State: AC+VfDxYhaTTJmM4qh/pbEX0lHPfG+M3lHLQSND3CE3522vQvFFC0a7E
	gKiVSoaDFkTlXVij0zuBeiC+pHO/P14=
X-Google-Smtp-Source: ACHHUZ7DPpDU7B5C2wwyP8aaXoM7xL1h9DVr5nZxlgJlahgICYkqDuYBEUd17Bm2S0qNhqXqre3jMw==
X-Received: by 2002:a05:6a00:801:b0:63d:2260:f7d with SMTP id m1-20020a056a00080100b0063d22600f7dmr52997270pfk.8.1684243760730;
        Tue, 16 May 2023 06:29:20 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-8.three.co.id. [180.214.232.8])
        by smtp.gmail.com with ESMTPSA id g25-20020a62e319000000b006414289ab69sm13379952pfh.52.2023.05.16.06.29.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 06:29:20 -0700 (PDT)
Message-ID: <30df7ad7-3b8b-c578-b153-7bf0a38fa0cc@gmail.com>
Date: Tue, 16 May 2023 20:29:04 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v2 0/4] Documentation fixes for Mellanox mlx5 devlink
 info
Content-Language: en-US
To: Linux Networking <netdev@vger.kernel.org>,
 Remote Direct Memory Access Kernel Subsystem <linux-rdma@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>, Gal Pressman <gal@nvidia.com>,
 Rahul Rameshbabu <rrameshbabu@nvidia.com>,
 Maher Sanalla <msanalla@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>
References: <20230510035415.16956-1-bagasdotme@gmail.com>
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20230510035415.16956-1-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/10/23 10:54, Bagas Sanjaya wrote:
> Here are fixes for mlx5 devlink info documentation. The first fixes
> htmldocs warnings on the mainline, while the rest is formatting fixes.
> 
> Changes since v1 [1]:
> 
>   * Pick up Reviewed-by tags from Leon Romanovsky
>   * Rebase on current net tree
> 
> [1]: https://lore.kernel.org/linux-doc/20230503094248.28931-1-bagasdotme@gmail.com/
> 
> Bagas Sanjaya (4):
>   Documentation: net/mlx5: Wrap vnic reporter devlink commands in code
>     blocks
>   Documentation: net/mlx5: Use bullet and definition lists for vnic
>     counters description
>   Documentation: net/mlx5: Add blank line separator before numbered
>     lists
>   Documentation: net/mlx5: Wrap notes in admonition blocks
> 
>  .../ethernet/mellanox/mlx5/devlink.rst        | 60 ++++++++++++-------
>  1 file changed, 37 insertions(+), 23 deletions(-)
> 

Hi jon,

If there is no response from mellanox and/or netdev maintainers,
would you like to review and pick this series up?

Thanks.

-- 
An old man doll... just what I always wanted! - Clara


