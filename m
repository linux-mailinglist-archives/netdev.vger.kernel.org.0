Return-Path: <netdev+bounces-8198-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21BC572315A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:28:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE4C028146A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDD5261D9;
	Mon,  5 Jun 2023 20:28:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4174C1118D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 20:28:07 +0000 (UTC)
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2636298
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:28:04 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id 71dfb90a1353d-45bcbd77636so1247091e0c.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 13:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685996883; x=1688588883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/hKS2P6FkZ5viotOpP0sMkhgEF23M9qM6vB4xYqbjI=;
        b=sjZDgj1NYKg5c9Ueu5bJVjV8FGNyEwC+MjXkeRhu5jXBkmD4wzg3ivSevgVB/8UdOa
         EZD/LDmV/efWqsphG+ZIyNJ4Tgvz30uv1lMfYeOSeZd570YJqK2zqR9GkaNgiaPZBp5P
         UnHWgjd+opWzgJVtwpMS0d6oW1pAcFFP4GmFA2HJ9SLRpHKynMwBGwQpzo8GW+eaMj1P
         NOYOAP+T4QrxeUXipZScBth6YFVcTGVdldGfqPi2ocihwkDK3/LT5+I9BeXwSVjbiu2U
         WZEvczRoNETAGLIQa9QSVEnJhP++NrbmIonp1P496cfxkn2BeoGW+AAcCfVMcEoRTIDC
         EhOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685996883; x=1688588883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6/hKS2P6FkZ5viotOpP0sMkhgEF23M9qM6vB4xYqbjI=;
        b=M/2SKWJw7tuNkI17awBKlX/PvQGWcyovbrJzgbZlcZ163PodTrVN/rV+teS2ZRUipq
         2KP2LkmPwinzEzzWz1YC3ImLduU+Z0WfpvYU7t9lCy4Piji9n69lKZxdAEYsA8ZjZu8N
         Spjki3P5C1ZqUDa6AbdkFOj9gnaVeuH9es7c3EhTs0z55iRXZznkIghVIBCzw98QQQ7M
         peiE1xfAeIqJEouPndJTiUB/4eA5+QhBuwKA/czdm9mrbc5X6XQfuAhdGbhoKVAiQ4hX
         W6ywsMZDbKqp7KH7I/Um0UjxU6heqh/O9d+dxURkHgRZVEw4m8QePsCrCs151RJnEaBY
         6obQ==
X-Gm-Message-State: AC+VfDz1uF156pzIWgPpLBT5ZwHQak28xDJ/vkgrokAs1ffenetHZTGS
	nGw86I9NXhhob6YVv8Vidufkks38MCbKGevMYqQ=
X-Google-Smtp-Source: ACHHUZ6d656a0qFxjKoBiZVGAep6TQ8dXiANlfan2Pkun+Q0WvGf+XKUiE+pOVzzzI54xXsSIZqSgAc3xaDDah8jzTM=
X-Received: by 2002:a1f:43cd:0:b0:45f:9a8f:bc06 with SMTP id
 q196-20020a1f43cd000000b0045f9a8fbc06mr5063590vka.10.1685996883200; Mon, 05
 Jun 2023 13:28:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230604175843.662084-1-kuba@kernel.org> <20230604175843.662084-5-kuba@kernel.org>
 <647dab8865654_d27b6294f8@willemb.c.googlers.com.notmuch> <20230605115432.05769008@kernel.org>
In-Reply-To: <20230605115432.05769008@kernel.org>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon, 5 Jun 2023 22:27:26 +0200
Message-ID: <CAF=yD-+19GQJbFJOVm-FjAEh1XzEvkXvrqpzVx-krZEdtt91=w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/4] tools: ynl: add sample for netdev
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com, 
	pabeni@redhat.com, simon.horman@corigine.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 8:54=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Mon, 05 Jun 2023 05:31:52 -0400 Willem de Bruijn wrote:
> > > +CFLAGS=3D-std=3Dgnu99 -O2 -W -Wall -Wextra -Wno-unused-parameter -Ws=
hadow \
> > > +   -I../lib/ -I../generated/
> >
> > Should new userspace code also use gnu11?
>
> Well, 99.9% sure it doesn't matter, but okay. Let me send v3.

Thanks. Certainly not that important. I just figured it might set a
good example for future userspace changes, to keep up with the kernel
default.

