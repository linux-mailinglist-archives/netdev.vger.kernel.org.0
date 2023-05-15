Return-Path: <netdev+bounces-2646-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD23B702CD7
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:37:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3DA9281386
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E45EC154;
	Mon, 15 May 2023 12:37:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D26279D4
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:37:51 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D16F1716
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:37:49 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f509ec3196so28169715e9.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684154267; x=1686746267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rqwGGQO/8Sh/XFdLOTcr1YotCV/Ssz2PnHwYjGJ7xbU=;
        b=o9bCATSnaviEvDLOPOCKt4zsAMVneEjW9Ang/CIyR1S/nN5Irubj928qHvTz377nZz
         LOt6x2PHYUFTBb6UM5XoQzzfD7RyaQFouvJJxPy8bnfu/mXNyS/NbZgHSFbUd/ssH+Bt
         YpZyj40YoIH3tSVeXsuHQiqpHFKUJSdarpT7yyK0N3g2HGuhpF92qAnuvJzzp7f2QSzU
         bXBu0THQEr8h46blKsatQI/wkmVzFu2n99/nij+zZGdk5ZUNVFUDgMrF8M+71ytJtL6w
         doquDDaIX5V4uHcJcof6DckTJ8ZYgda48gHfaQc9qIb67KT6h/B1DB28jX57W2YJJWRm
         w9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684154267; x=1686746267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rqwGGQO/8Sh/XFdLOTcr1YotCV/Ssz2PnHwYjGJ7xbU=;
        b=R7m1KohoQfz85bUDzA2gO2Lc3X9+N5Je3xUa6sjRdA78xpnHq4UQy2tTHK2X1w/ZtR
         kLtFMToQHE6jtFY3WSdkLmJ4YtM9NgcoRbekt9zT6k/uADAI6X6PHhiuFXOxofiv/qeu
         YQiu3A2WiC77kuxZWfbbwtsHHySacOd3n5BdYu0f01jznIwUQE+XfJflKiJceMS1HSE2
         OBGvvWNtsEIqmp6Tl9U07nzyXFG+W9PY48xf9g06zuK16eCLAahJ27obzIWUsLlrlc0h
         a72DLOBuIpH5e9+hfb1AjwnBERuLi7MLIkH6u+bZIg3kHTdHp4EOD7cc3RySlhMhGSqT
         0CFw==
X-Gm-Message-State: AC+VfDyVdPqxtnaQ+YciHkc91ZCNBi7NVQgKRRFyXxciZ0ARu0HjHn0P
	suy3+AczD+/SG2e2ITUfnmlVRA==
X-Google-Smtp-Source: ACHHUZ4ypHMMx5kNGYrK+heSisIwrzfuVk6ZuaMdQ40FjI3yGLE9FUccbuY8493lZLYIlLIa85pV/w==
X-Received: by 2002:a7b:cbc1:0:b0:3f1:89de:7e51 with SMTP id n1-20020a7bcbc1000000b003f189de7e51mr21918642wmi.12.1684154267527;
        Mon, 15 May 2023 05:37:47 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j10-20020adff54a000000b00304b5b2f5ffsm32444687wrp.53.2023.05.15.05.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 05:37:46 -0700 (PDT)
Date: Mon, 15 May 2023 14:37:45 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Ido Schimmel <idosch@idosch.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, netdev@vger.kernel.org,
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, jacob.e.keller@intel.com, saeedm@nvidia.com,
	moshe@nvidia.com
Subject: Re: [patch net] devlink: change per-devlink netdev notifier to
 static one
Message-ID: <ZGInmY/2Rl7xheq6@nanopsycho>
References: <20230510144621.932017-1-jiri@resnulli.us>
 <CGME20230515090912eucas1p2489efdc97f9cf1fddf2aad0449e8a2c7@eucas1p2.samsung.com>
 <600ddf9e-589a-2aa0-7b69-a438f833ca10@samsung.com>
 <ZGIY9jOHkHxbnTjq@nanopsycho>
 <ZGIgIglwmOTX3IbS@shredder>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGIgIglwmOTX3IbS@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mon, May 15, 2023 at 02:05:54PM CEST, idosch@idosch.org wrote:
>On Mon, May 15, 2023 at 01:35:18PM +0200, Jiri Pirko wrote:
>> Thanks for the report. From the first sight, don't have a clue what may
>> be wrong. Debugging.
>
>I guess he has CONFIG_NET_NS disabled which turns "__net_initdata" to
>"__initdata" and frees the notifier block after init. "__net_initdata"
>is a NOP when CONFIG_NET_NS is enabled.
>
>Maybe this will help:
>
>diff --git a/net/devlink/core.c b/net/devlink/core.c
>index 0e58eee44bdb..c23ebabadc52 100644
>--- a/net/devlink/core.c
>+++ b/net/devlink/core.c
>@@ -294,7 +294,7 @@ static struct pernet_operations devlink_pernet_ops __net_initdata = {
>        .pre_exit = devlink_pernet_pre_exit,
> };
> 
>-static struct notifier_block devlink_port_netdevice_nb __net_initdata = {
>+static struct notifier_block devlink_port_netdevice_nb = {
>        .notifier_call = devlink_port_netdevice_event,
> };

Yeah I just ended up with the same assumption. That is going to fix it.
Are you sending the proper patch?

