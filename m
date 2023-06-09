Return-Path: <netdev+bounces-9668-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29DC272A288
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:46:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2B8B281A0F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14457408D8;
	Fri,  9 Jun 2023 18:46:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059CB408C0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:46:44 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B91198C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:46:43 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f7f7dfc037so9935e9.0
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 11:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686336402; x=1688928402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vr8aH8ZfK5ryA0jOjapDKJT2GEVRFy3j4D+kzYGoRXU=;
        b=rNa2xBaVKGzESTnDXUu8RuQEI2qAv+EXP6tu8COi/Ihc65pqd8uWViYjhLeR4KiSGZ
         2+r/OSDhnQTXd1eJVq37yamWCNSJL2gs7OUvGh6p/iEi2Hc+1h295zcoFCYJcx4+rx1e
         mnNKzxqDegoORWyU3EWAVhN5ONkL3nwS3jx5t1Pq+zZnwY1Cr2is/9IitsnBJnvtN4NJ
         LDUYjzRvRn9YJzPAap50tLrgb/R93XzKahgKcutL8EIaEe+c/bE4Qa7MbEPIbuFREleG
         IJn88h2jzcgOWxn7cyqovjVHFwec6DooRpGo2gmujXRfYXnZnZuRlF4rXu/nd+pNJsvQ
         KCFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686336402; x=1688928402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vr8aH8ZfK5ryA0jOjapDKJT2GEVRFy3j4D+kzYGoRXU=;
        b=JHEeBi9GJYkuAYq5EDXio/xrKw4i2p49YLAurrFf3puhl38pQx/lcUnQLZKc7uQAmw
         2gNx5eljQ9FzzknAWD3bpgTH9wcXgtKTvkcjIu5rDTqDe5li9o3wI/Z56kOzGyy/w8j4
         wQPl5jQdohJXqkN53SYd5/XpQtJnaTpch2WnEkTiAWFDjk80vA8X0DMPhX80Nn8wkjsd
         ZbTpiDXtIwnbsAh4/GJllZyxQYhZTsvtlZqDYiB4kT9y+v3/Iuxo8uM61ThDIdaC+Oy6
         qVXwf0AJZOgiiax7YuAlpbo+5LpQU3auAtb48ei9XBuhvwC7I9bur/kY6ZmvQG1i0VFj
         sEUA==
X-Gm-Message-State: AC+VfDz5m2jVbE4ChYSoTI7JGp36TZndY41f/eThN8RjcKWFnNezzugr
	cHkbUf3y/fCp9F9s1NdA25VoIixFslyutDq3AmwIKQ==
X-Google-Smtp-Source: ACHHUZ6FLqboZtTdpjjZtuGKmhtpIf67N3V9PF7D6+ggymyQne+C6hS0jkU8oAyO8kNgpOb+qumtKG7aqCeDu+0sjxY=
X-Received: by 2002:a05:600c:3513:b0:3f7:e4d8:2569 with SMTP id
 h19-20020a05600c351300b003f7e4d82569mr16250wmq.5.1686336401732; Fri, 09 Jun
 2023 11:46:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609183207.1466075-1-kuba@kernel.org> <20230609183207.1466075-3-kuba@kernel.org>
In-Reply-To: <20230609183207.1466075-3-kuba@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 9 Jun 2023 20:46:17 +0200
Message-ID: <CANn89iKTjxqmAfa+HY3MX42aGezqgMQNGhJmfgTyaH+C+41Ebw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] netpoll: allocate netdev tracker right away
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com, 
	dsahern@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 8:32=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> Commit 5fa5ae605821 ("netpoll: add net device refcount tracker to struct =
netpoll")
> was part of one of the initial netdev tracker introduction patches.
> It added an explicit netdev_tracker_alloc() for netpoll, presumably
> because the flow of the function is somewhat odd.
> After most of the core networking stack was converted to use
> the tracking hold() variants, netpoll's call to old dev_hold()
> stands out a bit.
>
> np is allocated by the caller and ready to use, we can use
> netdev_hold() here, even tho np->ndev will only be set to
> ndev inside __netpoll_setup().
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.

