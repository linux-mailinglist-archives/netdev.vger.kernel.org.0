Return-Path: <netdev+bounces-10318-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 101A272DD65
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:14:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02DB21C209EA
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:14:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031EF27219;
	Tue, 13 Jun 2023 09:14:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC622915
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 09:14:39 +0000 (UTC)
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E831A7
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 02:14:38 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-3f98276f89cso145711cf.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 02:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686647678; x=1689239678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vOOqFOsZD/no1atuYcZwfvTG65YDlmslb67xaMMMgQE=;
        b=LF4J+jEvk/Ti/d71QvnajPe96/pviBUe7LW4d/hhDFWQw1xLzlkcoyA//+v2nRVlxO
         hDl+dESvghD7zr0mKyIKsP07EVQ0Kp0u0D9Fxvrl2XxkVeA9MogyFqp31eeQk7wdkZ2p
         FilMKQceH00e/u7caWnuMmcSbXXqsEpSXYRgVbyE34WuLC6Q3WNLM5XJyE/fUYTbF8RA
         qZ3/vzsJtXePB5IajmAmaWtFGynUZaa6IkMqiiIyBFrjEugWpx5SIdpSN3d5erqVQsbR
         WAvKZKSeok1JKGP1C5VUR6ACt+iDTlSq4r7cY8DjtQdDn9eF90h27q34FTYyuGj8ditw
         VRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686647678; x=1689239678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vOOqFOsZD/no1atuYcZwfvTG65YDlmslb67xaMMMgQE=;
        b=YNX7MjIlYdD3i2jaFwoB7B0nlj0eP7wFzwi9Gu74SF8ifxl18/ImzXmIvYt9KJhdPH
         ELPs9bhgCy107o+SklAkFKUXzAWbY+bC2q/uaEsscY3/GLSdx7agidefl544GfI3Quqp
         kzGNNCDr8EbkzG0po97yyTqTtNq+wuw70Gjv0TvZfQlFrWSL5FcD6EWVcpN9Wxksk+eX
         whACqX+P7HUDvfGR9ZbWbcS53RcjGNofZKeSFi1nprTGvVHa3Kcix8Bz7gRpf//Za68l
         Zcar/rBSNXfqeRRb7+mZdeivt3k13Eg7KSgFomb3bZAGQ/cDaUL3EuEIpw62iTMv+fC9
         SUjw==
X-Gm-Message-State: AC+VfDyKhuhlUR7/3nNSY3/fwnVTSR4osIv01rLdC2u1T93S5diei8/T
	nipY9CzDvRLzoPsPlLshpbjWRoz980gh4hZMNLOm1g==
X-Google-Smtp-Source: ACHHUZ4SVPFjjv0vURe2Wi8MCnzbQKVXsNc17ZYckO/d4oceW7bq1ycOl/Fo06K84o310suvAx9pySTSjQFwjj994oQ=
X-Received: by 2002:a05:622a:3c6:b0:3ef:4319:c6c5 with SMTP id
 k6-20020a05622a03c600b003ef4319c6c5mr48757qtx.19.1686647677690; Tue, 13 Jun
 2023 02:14:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612214944.1837648-1-kuba@kernel.org> <20230612214944.1837648-2-kuba@kernel.org>
In-Reply-To: <20230612214944.1837648-2-kuba@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 13 Jun 2023 11:14:26 +0200
Message-ID: <CANn89iJYtngKVJKChtVX4mmfcB-2gpn96k09B_bWWsSqUEEN5A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] net: create device lookup API with
 reference tracking
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

On Mon, Jun 12, 2023 at 11:49=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> New users of dev_get_by_index() and dev_get_by_name() keep
> getting added and it would be nice to steer them towards
> the APIs with reference tracking.
>
> Add variants of those calls which allocate the reference
> tracker and use them in a couple of places.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

