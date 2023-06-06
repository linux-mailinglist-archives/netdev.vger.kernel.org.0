Return-Path: <netdev+bounces-8455-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03293724263
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37D3D1C20F93
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2C837B63;
	Tue,  6 Jun 2023 12:40:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AF637B60
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:40:16 +0000 (UTC)
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC52E5D
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 05:40:15 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id 71dfb90a1353d-45739737afcso861929e0c.2
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 05:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686055214; x=1688647214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iOyJYdM+Uc5GoO2gSfr67tjftoLqnOafxPQ/tLF9ZzE=;
        b=MGgz/C+RiV8rbJdBAX/EivJfj1POf3uSa2MgX2DR4TcdOSkehKMWa0MQsp5tYqcrN7
         YxA6Qi4G+IXh2VEMkvIN7HkPufj/GQ1mSEslE3wY96Fim0H8eldF+HrOdPKfekyq75oA
         GruTeqByNJ6I5XMWmTgF5P2uubQhxbddIvA/kdVxvuxMGFzzKn9O5Aji4oXPEyjfENTc
         nOHXaBBEFRmqkmeEt1aOjRSHpznpcvgEU8PqGAVMp3Th2C4eRLnQ9KrHtALn3Kc9uo16
         Jh6PCj/gzMXoC/7cyDz8J1q9/d1zfOXYPBTMM7VYOedTCC/Dp9d6FBQgdZt3M85imZ5u
         phpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686055214; x=1688647214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iOyJYdM+Uc5GoO2gSfr67tjftoLqnOafxPQ/tLF9ZzE=;
        b=ezJVJ95EkHxImxnH5BrwjpeHhV1zOIiaXNwOVT2NU2Y/PGlB5IC+4SqXuMyq5p+VK2
         xzUzV6au+LwwD7YOLYbOnWK8brdwoWLQlhgxWtVtWjo3CFbN1RxoDCNwHDZpk78gTxGE
         ze8buM0AKrwnuCceRyMwZWO5jSjDcUruuBUxstep4wYM2901wrOsvLQel1nW7c7kEVGN
         yfy9L9ASfFrR30JFwjmiDbgbaMVzFLhf3l6iHjgkFYS7S0Z5ZeFHHl7PxEv3je9/hXRi
         iiy1Oh93tY4rHGxyPB2Q5MlONHEjF1/2M5Ed1DGr+CPCAv+JnaaBVf3x1LEu8uDvkG9J
         pEmg==
X-Gm-Message-State: AC+VfDzLjJNXH5dumhZKutu4c1mjoT7rysmzlVQ9HrCCUKzUQm0o2wLo
	iVk5jjTreWVP5PFGKeQQCLTGTzrHYbGJCptA8kQ=
X-Google-Smtp-Source: ACHHUZ62SoR3jFW3AqC/0cfm4RQH9tq/KdG66sWIVf9oNuqoDvbTRBnkguB+UNbk6I+RWvBOihvczwc/dPd5+x1cw60=
X-Received: by 2002:a1f:dbc1:0:b0:456:ffb8:88ff with SMTP id
 s184-20020a1fdbc1000000b00456ffb888ffmr611729vkg.5.1686055214380; Tue, 06 Jun
 2023 05:40:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605190108.809439-1-kuba@kernel.org> <20230605190108.809439-5-kuba@kernel.org>
In-Reply-To: <20230605190108.809439-5-kuba@kernel.org>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 6 Jun 2023 14:39:37 +0200
Message-ID: <CAF=yD-J0VohQxcvUuNMhPPV7Ad2wb_3O6oPWgnN4g+hVxf-j7Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/4] tools: ynl: add sample for netdev
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
> Add a sample application using the C library.
> My main goal is to make writing selftests easier but until
> I have some of those ready I think it's useful to show off
> the functionality and let people poke and tinker.
>
> Sample outputs - dump:
>
> $ ./netdev
> Select ifc ($ifindex; or 0 =3D dump; or -2 ntf check): 0
>       lo[1]     0:
>   enp1s0[2]     23: basic redirect rx-sg
>
> Notifications (watching veth pair getting added and deleted):
>
> $ ./netdev
> Select ifc ($ifindex; or 0 =3D dump; or -2 ntf check): -2
> [53]    0: (ntf: dev-add-ntf)
> [54]    0: (ntf: dev-add-ntf)
> [54]    23: basic redirect rx-sg (ntf: dev-change-ntf)
> [53]    23: basic redirect rx-sg (ntf: dev-change-ntf)
> [53]    23: basic redirect rx-sg (ntf: dev-del-ntf)
> [54]    23: basic redirect rx-sg (ntf: dev-del-ntf)
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Willem de Bruijn <willemb@google.com>

