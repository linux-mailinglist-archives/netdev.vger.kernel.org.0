Return-Path: <netdev+bounces-4123-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD4B670AF44
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 19:25:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3171E1C208F4
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 17:25:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FD3F747F;
	Sun, 21 May 2023 17:25:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA736AD8
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 17:25:35 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E1210E
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 10:25:33 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f5dbd8f677so27595e9.1
        for <netdev@vger.kernel.org>; Sun, 21 May 2023 10:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684689932; x=1687281932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lEKfaW0N+DHBog7/ho2Kgeox+l8bp0SvW0U65XKoLcc=;
        b=63wq+ZPE3FvpW0kO+V6sZ8bPYsjvGB57wXW9LiZiiFrfyepJdWN8Jts9tmvJs7/DWm
         nlphAHGNr1RV6WuBIZ+AlHleXJqIBxZbKfgFVh/tmdGmcuU1tvKHj14yiIM6stpxUihq
         WVRlIDSIOpI+PYNd7kGOQp6o+JJxr77z4hTLSgrra/5qoxSbUrN9HVe1g5GemPZuQ9uI
         obwfgxtNuWbFBeNwQTZM/Fjv5TZBCH2gqgOtOinBsnjjU2XLbiBMlSuttMDHFMZHrQOr
         BNHF+afrmRGLsJvEHC6hfzrEteD46CxGNsdR5X3amSheYw2uvuro8IkL8xg5olilH7u+
         zaHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684689932; x=1687281932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lEKfaW0N+DHBog7/ho2Kgeox+l8bp0SvW0U65XKoLcc=;
        b=EVsXnUFJBChvIDOSTEtZsBhG00V5kt0LmDHqeADEJXq8znfEnwJi8ALphU3c7k+aps
         A6w4QMdtf/Smza1yD6xxAKDlBSHyLRMTUuDlZjk7nDwjIO1H2GxQ8fWdXi9tKqrxgvfB
         n1sT5b1/bau10OfU0xyORiHnOKeYGVmNU54NQ/amNYUkBYYnjdceqqyP0Hl6xFeZITXo
         d++AhCmmG55Gk2LUHlfgwzbTVD6exT7T9/MlawFbNgeFjkKYQlzNnNa82BS/pGuTsXjv
         Qs52XlfvEfBn4gf+fE7hf+lu9gUbK5PmilFju/HQvJFWUDm2r4mHu8dzuyWhvINWU4eM
         XBMA==
X-Gm-Message-State: AC+VfDxr+tik7iJbnFZRV0Oalm+k9XdeYHREiAsSMNcm/fZRzVA0AdlS
	kIA7JmkPqgPyuHYJUOOvfm13NiCx9DrfpZgTgfWMjA==
X-Google-Smtp-Source: ACHHUZ45CPreZ4pI6imWE1WSy+Ged4g9qgetdw2sP3gCSWTos0d3fUsTJfX4MlUBg8CzsTwEDyoS3Ti1SXv2Mr0yAwg=
X-Received: by 2002:a05:600c:5117:b0:3f4:fb7:48d4 with SMTP id
 o23-20020a05600c511700b003f40fb748d4mr560972wms.3.1684689931795; Sun, 21 May
 2023 10:25:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <25a7b1b138e5ad3c926afce8cd4e08d8b7ef3af6.1684516568.git.lucien.xin@gmail.com>
 <20230519134318.6508f057@hermes.local>
In-Reply-To: <20230519134318.6508f057@hermes.local>
From: Eric Dumazet <edumazet@google.com>
Date: Sun, 21 May 2023 19:25:20 +0200
Message-ID: <CANn89iLkzO0py2N5TZAFWvcMjidd6R1URh0+D6Xr1enVNp8Sew@mail.gmail.com>
Subject: Re: [PATCH net] rtnetlink: not allow dev gro_max_size to exceed GRO_MAX_SIZE
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, davem@davemloft.net, 
	kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 10:43=E2=80=AFPM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri, 19 May 2023 13:16:08 -0400
> Xin Long <lucien.xin@gmail.com> wrote:
>
> > In commit 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536"),
> > it limited GRO_MAX_SIZE to (8 * 65535) to avoid overflows, but also
> > deleted the check of GRO_MAX_SIZE when setting the dev gro_max_size.
> >
> > Currently, dev gro_max_size can be set up to U32_MAX (0xFFFFFFFF),
> > and GRO_MAX_SIZE is not even used anywhere.
> >
> > This patch brings back the GRO_MAX_SIZE check when setting dev
> > gro_max_size/gro_ipv4_max_size by users.
> >
> > Fixes: 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536")
> > Reported-by: Xiumei Mu <xmu@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/core/rtnetlink.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > index 653901a1bf75..59b24b184cb0 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -2886,6 +2886,11 @@ static int do_setlink(const struct sk_buff *skb,
> >       if (tb[IFLA_GRO_MAX_SIZE]) {
> >               u32 gro_max_size =3D nla_get_u32(tb[IFLA_GRO_MAX_SIZE]);
> >
> > +             if (gro_max_size > GRO_MAX_SIZE) {
> > +                     err =3D -EINVAL;
> > +                     goto errout;
> > +             }
> > +
>
> Please add extack messages so the error can be reported better.

Also, what is the reason for not changing rtnl_create_link() ?

