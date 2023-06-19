Return-Path: <netdev+bounces-12034-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A967735BE8
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:07:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45E32281104
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 908AA134D4;
	Mon, 19 Jun 2023 16:06:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8575A12B72
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 16:06:57 +0000 (UTC)
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00908B1
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:06:54 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-570002c9b38so42201837b3.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1687190814; x=1689782814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E6Gz+pnHILNa9vWsNogxJJDOmyqbXg0zg3q5EITIlyc=;
        b=cBZoYDbHUrKhlJCdSIqjbSOIiuXD8YwnymLZ9S75FsrsLTa4U/5c289R7l8No3uhUo
         /V8c/HXr9O8bUYXlY+C0kyTeIPWtdxflMTa7eGHyqRd203pDb0pkmv6rTaQyg8JIEwQh
         E7IobhpfiNG8CkR/P/kzC6DkDsPTp93jUcawIzWVc8gNYPgThtGA0hXHgHLclnn1QNnh
         5r2kceqYplEfKZE8TtCcXzjLcZMeamsZZwFgjv8GktBBo5CshHurrT+dLk8m740EYRAD
         fQ2JbmcLZxJbrAVH2rOHKM/vHktRkG3sAhLKPMkMiGVUC9G49tlAxFWx8xsqn6aRAHso
         3tWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687190814; x=1689782814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E6Gz+pnHILNa9vWsNogxJJDOmyqbXg0zg3q5EITIlyc=;
        b=WSkJ4a0IeylkMrP4uKfk/96bR87Kgje24ufcdTALLjPqjeI7MI0cWLcytRTdWMlxMB
         +Bf96SuHc9ys3n/kxwxgB/zw/yIyr+bECqK8drx1vaDRvxnC7+oRY2NVdMXtFUF17GCu
         w/FGkdoyc8nrhT1/tTVPAkl3VlxU3emiBzI+FBVd1ie33d+PyR/5pW3vlfiL9BS7qEBY
         yODrAVHNzWVC/6p4pfF6YBhf1WHSoTwdzvf2i2LTMaF40OG6F1L/kE3dTBM0Wf0/zHzX
         44Jry2cL71cYbzWhyGsvYTfTflmMNIftui3/Sw3s7afs7Yy29xKdvIhcghDharSlIxmz
         utNw==
X-Gm-Message-State: AC+VfDzx2pXUrKE+A+gb0bL7/2874k4HzHmShhT+TkDEpY9GwTKpW2Nx
	bmcJhZoypEo7sgaFiI2wcORZQYmxdbjNppceJ05x
X-Google-Smtp-Source: ACHHUZ6Pm/zBPHr7GxLINf+kQ3ucnOJrHhsX5RZRZ7fWZLZ3aeqR5bT2dsKcT1WNl0Mxf4joP/ftAF6WpPnMN8Kw06I=
X-Received: by 2002:a0d:e892:0:b0:573:527b:747b with SMTP id
 r140-20020a0de892000000b00573527b747bmr2700111ywe.36.1687190813964; Mon, 19
 Jun 2023 09:06:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aa109847260e51e174c823b6d1441f75be370f01.1687083361.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <aa109847260e51e174c823b6d1441f75be370f01.1687083361.git.christophe.jaillet@wanadoo.fr>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 19 Jun 2023 12:06:43 -0400
Message-ID: <CAHC9VhTu4dEbi0Sj1F9R+OR=5BfOzQNq5fBF9MWag2QxxMtfwg@mail.gmail.com>
Subject: Re: [PATCH net-next] netlabel: Reorder fields in 'struct netlbl_domaddr6_map'
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, netdev@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 18, 2023 at 6:16=E2=80=AFAM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> Group some variables based on their sizes to reduce hole and avoid paddin=
g.
> On x86_64, this shrinks the size of 'struct netlbl_domaddr6_map'
> from 72 to 64 bytes.
>
> It saves a few bytes of memory and is more cache-line friendly.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Using pahole
>
> Before:
> =3D=3D=3D=3D=3D=3D
> struct netlbl_dom_map {
>         char *                     domain;               /*     0     8 *=
/
>         u16                        family;               /*     8     2 *=
/
>
>         /* XXX 6 bytes hole, try to pack */
>
>         struct netlbl_dommap_def   def;                  /*    16    16 *=
/
>         u32                        valid;                /*    32     4 *=
/
>
>         /* XXX 4 bytes hole, try to pack */
>
>         struct list_head           list;                 /*    40    16 *=
/
>         struct callback_head       rcu __attribute__((__aligned__(8))); /=
*    56    16 */
>
>         /* size: 72, cachelines: 2, members: 6 */
>         /* sum members: 62, holes: 2, sum holes: 10 */
>         /* forced alignments: 1 */
>         /* last cacheline: 8 bytes */
> } __attribute__((__aligned__(8)));
>
>
> After:
> =3D=3D=3D=3D=3D
> struct netlbl_dom_map {
>         char *                     domain;               /*     0     8 *=
/
>         struct netlbl_dommap_def   def;                  /*     8    16 *=
/
>         u16                        family;               /*    24     2 *=
/
>
>         /* XXX 2 bytes hole, try to pack */
>
>         u32                        valid;                /*    28     4 *=
/
>         struct list_head           list;                 /*    32    16 *=
/
>         struct callback_head       rcu __attribute__((__aligned__(8))); /=
*    48    16 */
>
>         /* size: 64, cachelines: 1, members: 6 */
>         /* sum members: 62, holes: 1, sum holes: 2 */
>         /* forced alignments: 1 */
> } __attribute__((__aligned__(8)));
> ---
>  net/netlabel/netlabel_domainhash.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

