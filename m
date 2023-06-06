Return-Path: <netdev+bounces-8459-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDFC2724288
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F60E1C209A8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00D8737B72;
	Tue,  6 Jun 2023 12:43:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3DF37B60
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:43:18 +0000 (UTC)
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8131910D5
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 05:42:43 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-43b4ffbaef7so803103137.3
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 05:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686055362; x=1688647362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jfZyeLouyHUn23TIg4nSsb1bIdIyrFUgT4vdal3EAcw=;
        b=WjxES4er3+HIUCqjc4OO36zuiSYuP0yhoyYcEOQV1oIV7wwmX4mQ3u7Nby+KuE4c32
         pCPrVFFfj0mfoVA44DacQGVs3rk3Nkn2XZOsD702YA8p/Ldg2mXJpnl0A8f+iXIz+Qov
         7dh590Seb1VnDxETcWt1rmB9Sg/ki1EMSjbqzXi+lC2xBbuPoivTbFTC3+rlKTqYds5e
         OsFOnZCCWMF3LzQT1Dueij1T3NUxm1DAPhHfEfQtnvf3klELiNNKGC539zUulsUw7CrE
         lxc8DWYeGUG+Jd9fDiNLs8rLitfWD87eoZDsRGEwODG/MXD2b3qwx4fBqwJtmcnNN4K5
         fBEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686055362; x=1688647362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jfZyeLouyHUn23TIg4nSsb1bIdIyrFUgT4vdal3EAcw=;
        b=hLws1y69bJKOgFnlvgvjNVPEYySKy6UFB+V8TJoh+s5F3+fKtLxPgdPv4Gp5uP45vx
         EmqFlN+pd+FX+yL/3/iyTnw+1NhwBfXwQKbsuwERfEYrkXaM/mQIu4oi9xW0wVqPrfMN
         z3s3X1DD5mquNxN+fTEQAsyPdDnqCDX66cyJ8J5O7uWX0aceG7iAbQ+4fO7cMWCq9Jcs
         wTag064O+WEjxjIJlRYGeuEjHKegr1hJCouvYx3DvLFTUh2CO652MQE/MJ6MJVOeYhTO
         nONImKXi/E0v5xf5Xl0V+Nw0T85863T9mTBOuEVAx36sLu0ixeU7dSwupinjmPelxMsZ
         YU9A==
X-Gm-Message-State: AC+VfDwkU0eaa6B4cUr93TE5iIGtxFtSXjHo8uYAHD9Y85i6fVHQJCW/
	/p8WANm/10P6wokeuDOr1LYtrG16OXriDUTiLGo=
X-Google-Smtp-Source: ACHHUZ658TqmNwXeiQNZlHjXpLxEN/3edAyOfB/ryz66DYgNoUfdsCSkscAZgO2U5geiQrGHVOX09nWffYyXqjzWEuQ=
X-Received: by 2002:a67:fbc6:0:b0:43b:1c7a:bb20 with SMTP id
 o6-20020a67fbc6000000b0043b1c7abb20mr1190551vsr.26.1686055362524; Tue, 06 Jun
 2023 05:42:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605190108.809439-1-kuba@kernel.org> <20230605190108.809439-2-kuba@kernel.org>
In-Reply-To: <20230605190108.809439-2-kuba@kernel.org>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 6 Jun 2023 14:42:05 +0200
Message-ID: <CAF=yD-+tGineeMuQCD3ENJ2DZTzffuYTPRzWx974pgQ=Y3eV2w@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/4] tools: ynl-gen: clean up stray new lines
 at the end of reply-less requests
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com, 
	pabeni@redhat.com, simon.horman@corigine.com, sdf@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 9:01=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> Do not print empty lines before closing brackets.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Willem de Bruijn <willemb@google.com>

