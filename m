Return-Path: <netdev+bounces-10105-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 246AD72C46B
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:37:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0B88281180
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26345134A2;
	Mon, 12 Jun 2023 12:37:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188BB804
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 12:37:25 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4064CE4C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:37:23 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-977d0288fd2so721609166b.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686573441; x=1689165441;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GFwR3MjviDWRjDdr6hkUVxEDK/bjTT7/lluzHUdOjCg=;
        b=hQK+hjFCjT7xjGPz0XrlFHJT0FFj3jJoKvsWr6WTWMzh1ZdgiX+cIWrr+FB4NG36uD
         jehZZYwNT6v5NLtkYPsGX5ZMJ3//BvDk1hyteheu8VLP6DtOgHO/jEeBLRIMODZs1+dx
         fkByx/vQiJ626dSiqXjQ9Z8vq5NSy6owRQS34ibONSwpfW9DsiCHDcC+uo2MJPoJtPQk
         SX8+WgckcZchGS+qKfGc4md4h4KoFtLyyqpDXZ5tqDnjd9mUu4tPrEE2iuAJ6cosnKZT
         uRzyHwaIM5SaAihJRjhF4FDQKqfyOwcyFrZ1jyMH2/9uAwR8kurIOS8BubsDIvkRZO9a
         gdJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686573441; x=1689165441;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GFwR3MjviDWRjDdr6hkUVxEDK/bjTT7/lluzHUdOjCg=;
        b=QcAW4dCfkKkSp9+T8AnAxtf+6L5qRHQ4ujfsv+KdMh9gws853PGHH6Mx8cOVQoP1Bh
         O+3ay+Th7fIgwnZixxWUxS+R/3L9Y+sTG2jZ11eIQZ95bFSC4GQSYOJz66igQyT4sX94
         ZYGzk/KhMbsSADax3GltGxbsKNTCoLXPCctG8Vo4GQldJFwtRVjSi9oF6R6cTypIv9uw
         hnH10u3vFtloyKmhI3FS91YFuSSQawxKY3od3a6YIABRw4CO3I+HTz8eu9bUiiIHVTQT
         OvGAwvyawvv+G4XQgZ81wkd4zkuABA2kqIZg7pJEi2D3WsVxgseAYOw9qT32nDjaIsA4
         rIHA==
X-Gm-Message-State: AC+VfDxiEqBu2AG+mK2gRGROJh7l0LzHPNGQJFLVWvjpPEaVWC/SJ8Yu
	yrbIM1I1+BGxhtd4QFV9s6Y=
X-Google-Smtp-Source: ACHHUZ6ZLRahyUjDXndWgCa7VpLxHWjwlWS3sHqRiYCL/WYGhj5lnbDluEx1/OIRng7yj1igzUy8mg==
X-Received: by 2002:a17:907:9454:b0:973:d857:9a33 with SMTP id dl20-20020a170907945400b00973d8579a33mr9451812ejc.11.1686573441379;
        Mon, 12 Jun 2023 05:37:21 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id s8-20020a170906500800b009663582a90bsm5249091ejj.19.2023.06.12.05.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 05:37:21 -0700 (PDT)
Date: Mon, 12 Jun 2023 15:37:18 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl,
	chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230612123718.u6cfggybbtx4owbq@skbuf>
References: <20230607140335.1512-1-asmaa@nvidia.com>
 <20230611181125.GJ12152@unreal>
 <ZIcC2Y+HHHR+7QYq@boxer>
 <20230612115925.GR12152@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612115925.GR12152@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 02:59:25PM +0300, Leon Romanovsky wrote:
> As far as I can tell, the calls to .shutdown() and .remove() are
> mutually exclusive.

In this particular case, or in general?

In general they aren't. If the owning bus driver also implements its .shutdown()
as .remove(), then it will call the .remove() method of all devices on that bus.
That, after .shutdown() had already been called for those same children.

