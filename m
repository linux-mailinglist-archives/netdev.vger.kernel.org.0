Return-Path: <netdev+bounces-5608-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 019577123F1
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AEC4281229
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F8D15496;
	Fri, 26 May 2023 09:46:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACDD10953
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:46:10 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8F6B3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 02:46:08 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f606e111d3so34675e9.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 02:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685094367; x=1687686367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pXZfG+fuxvD2egLxyBmuYyk/GBMQ3uRBw1xw4vLyPuE=;
        b=nI9ppoj4eEJCdaKXdE6djWdXsqTq3OagcwtyeT4jXUxfXRwvpF8n27sqHIJh6EfbWw
         3xAUsDRaOd7CNx0qfXNJ2lUU/jDpelB0ugois59vXDgWQnmUEE1f0+jcNqBT22pk+3ob
         q6ZknZJ/MUDvFfZP+lzOXYcmvmT4wcZcomeq1BbY1cvtwwKV2UIDMvLqPQeOCdCGsHfs
         K7NG/cTGiKyhyzZG7J2SO1dhgX3lFp3NpwZz/fe462FyeAq5xx5Prti5Grg46NjMKbWq
         1nLKDMYMXWUn+N6jaLd2bGfCj2GpTuoAwXCJdZo8wIpUD3fg1WXAmN8qkw+1LoOFjezn
         45tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685094367; x=1687686367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pXZfG+fuxvD2egLxyBmuYyk/GBMQ3uRBw1xw4vLyPuE=;
        b=PFGTgbAAOFwGerk5fRrZRtY7kyzWFG8Oxk0xmyXBQJxcvndcR0qM7sP8CYl7faRIee
         lscC3xaoDkcArKzKs5IYEAySmhqJs926mfNJCXElTJFrwGVos7kNXbUsUTh6XAV9kAvS
         0Ro7eauUaLNsLysZw+SbxiT4YIIoWX05/v02cdV6qOodBroGeRlxaVpYaBNpybC40t25
         Xf36Nl4N1NQMqzOP+sq6k2EUjW8829FWFZuhRD5nDyYKDJLR4/EAf3ywKG+4AM0mQJTH
         Ewn6pAFX2HxKfXTY4dGu8ws5JLjgp8anB2nXWJEDdsqeRAAKBKAQlKtrD+DVQH6h+i2e
         6OIQ==
X-Gm-Message-State: AC+VfDy4J0u1NwTzxO7ADWQT40RnoeiHiHO2itnfdVYA7RzccFz4pgrC
	5fHYw97pVOkf3alCdcWWnlLPGbEillecqub0TiLKfg==
X-Google-Smtp-Source: ACHHUZ4eEE3aYdr6WSDynX8XFLKMPYa4+uAM9+kBjD4bmKPxI+zFSS8KXMc55xuijk23jcfXi11uChTrI0rdt/tdQr0=
X-Received: by 2002:a05:600c:4f16:b0:3f1:73b8:b5fe with SMTP id
 l22-20020a05600c4f1600b003f173b8b5femr41143wmq.3.1685094366737; Fri, 26 May
 2023 02:46:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230525145736.2151925-1-ncardwell.sw@gmail.com>
In-Reply-To: <20230525145736.2151925-1-ncardwell.sw@gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 26 May 2023 11:45:54 +0200
Message-ID: <CANn89iJAuA51g2cT5z-22fu0nrHYBqXN51kiRjuAL9szcQumWA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: remove unused TCP_SYNQ_INTERVAL definition
To: Neal Cardwell <ncardwell.sw@gmail.com>
Cc: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 4:57=E2=80=AFPM Neal Cardwell <ncardwell.sw@gmail.c=
om> wrote:
>
> From: Neal Cardwell <ncardwell@google.com>
>
> Currently TCP_SYNQ_INTERVAL is defined but never used.
>
> According to "git log -S TCP_SYNQ_INTERVAL net-next/main" it seems
> the last references to TCP_SYNQ_INTERVAL were removed by 2015
> commit fa76ce7328b2 ("inet: get rid of central tcp/dccp listener timer")
>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Someone is cleaning up packetdrill tests ;)

