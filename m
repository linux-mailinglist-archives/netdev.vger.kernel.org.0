Return-Path: <netdev+bounces-5754-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E965F712A69
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A12FF1C20FFD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 040302771A;
	Fri, 26 May 2023 16:14:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5EB742EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:14:27 +0000 (UTC)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814A2BC
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:14:26 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-510e419d701so1734883a12.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685117665; x=1687709665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mlRPwp5Aeh3BF65UhqW02azq7DpYHrGGvyWVH1qyaxE=;
        b=FrxxK7bf+p1Z7fn2OUEyPBzvSfPAYXepIBgYN6rUA6uY6/Xwm8Urje2B6gItt7ZM+8
         kqaYYSLd/Ql37Onz4eVofLwmDkEhXykE705swqsdLlHAXyVTqXi8lFjv+wBG2oNDEd4P
         Mh10bfqEN2bgXfagvGXT71LvP8iUZuY9cIo9/oNg/ykaeG6D4Zv86yrLv/1f73mfbKWw
         nglVaGXjbMVDwuqKdQTy4/C5X8grHMYNVaC06ZhJbz+mx+gNyhTK+xZUiLtmamOND2P6
         gM0kLBh/JOvLFyy/ZlInUK0/NEdXeucogFyC7szcEWp/0Srgy2J4ZUL+NaKsXSZP2NGm
         C3gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685117665; x=1687709665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mlRPwp5Aeh3BF65UhqW02azq7DpYHrGGvyWVH1qyaxE=;
        b=eKBupXImqoQMTwwE0Osu+morP91nOc0STw0bXVcDpmzlaJvfM40ZY2k4kFmHE9ObHD
         sUYWvvkMod8AkOhVyqY34jZLUFyft4yFTtBU33y44760wxRv4G0rTPjLUE0YHOSpbm2F
         bmpCvrCHFhcO2+JvUi6y7x7oBjCrUTGfbmdHbGWjze91YfrjXkuLtL+hEJw5xIcbNJ5T
         YorjNeTiBt8Kt9/udMgOQmhKOHgBOlekHzrfQPDx2q2EHeQmhYhIotrp68gOg+5JYHkq
         ZnmQmO4BsVIuw6dqiUWng2N9np8qSOzZTdWL1S0mi8LJoPPENrteENNUVDShMHGab7eO
         0y9A==
X-Gm-Message-State: AC+VfDwqmop4LcA6PR1A9PJVpH3O951CjlZuLaTgJqlA4PyeSyenxB49
	hQgr/bhjrskvZqe2YTeD770v9w==
X-Google-Smtp-Source: ACHHUZ5kMofxmwKVOsTRYnRdIkZx/eRJea6iaxh5U7DBZQoztmJzlgggfZxADz4S//N2aASx2S7JCw==
X-Received: by 2002:a17:906:da88:b0:96f:45cd:6c21 with SMTP id xh8-20020a170906da8800b0096f45cd6c21mr2690449ejb.30.1685117664697;
        Fri, 26 May 2023 09:14:24 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j23-20020a17090643d700b0095850aef138sm2322192ejn.6.2023.05.26.09.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 09:14:23 -0700 (PDT)
Date: Fri, 26 May 2023 18:14:22 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, eric.dumazet@gmail.com,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] af_packet: do not use READ_ONCE() in packet_bind()
Message-ID: <ZHDa3kJH7+cmBV/4@nanopsycho>
References: <20230526154342.2533026-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526154342.2533026-1-edumazet@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, May 26, 2023 at 05:43:42PM CEST, edumazet@google.com wrote:
>A recent patch added READ_ONCE() in packet_bind() and packet_bind_spkt()
>
>This is better handled by reading pkt_sk(sk)->num later
>in packet_do_bind() while appropriate lock is held.

Nit: easier to understand the desctiption if you use imperative mood,
telling the codebase what to do.


>
>READ_ONCE() in writers are often an evidence of something being wrong.
>
>Fixes: 822b5a1c17df ("af_packet: Fix data-races of pkt_sk(sk)->num.")
>Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

