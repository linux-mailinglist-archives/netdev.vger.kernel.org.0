Return-Path: <netdev+bounces-9675-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA7CB72A2B7
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:59:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45C011C21040
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB21408EF;
	Fri,  9 Jun 2023 18:59:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF44408C0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:59:54 +0000 (UTC)
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED533592
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:59:53 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-33d928a268eso17205ab.0
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 11:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686337193; x=1688929193;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/swegptWn5QTad71UAMD1WdQvGD16t6T3Gp7FJJW/mE=;
        b=iFYf+ID49avfwFDuAEiG/P3Ckvyfe+dilUFFzE5ZLxcZkX8g/FE//sHdHSwjNMIMjU
         wjMrnuIDa38SOGK/VAolWH/WI8NXgMereEIaLWkUNKjucISzn5HHvVT72R+6+1PksKlR
         x4wtC2CDO+oA6HrBWjcpwHsj4z7B+FJ+wqcL28yDb1/5zOExPVSPK2lJoB/vrJaKxtDl
         y5h+NYb+m4Ik5LIjKmYoxQXiyaE1XoJij5Jnx53W1MjoX59kM1zp9mhIZCtEZAQAjH95
         /qaf7CgGwjqp1n/1JcihSR/SrS3jZ30iUxk/KGJYEgZgbFkywwqN1iraBNGpoqkt8HPS
         40Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686337193; x=1688929193;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/swegptWn5QTad71UAMD1WdQvGD16t6T3Gp7FJJW/mE=;
        b=LWhi3gRdtusqJL5O1tCKnHm38WW0xohc8YhQ2pNbY4IhMkWOk7Vl74PjD/CRGoz8SG
         2ILJ/4tKxBATcDsgkAqs6gz7MBilh2nugwdaDNI1ezdNbjuG9/a6fa6uQFUbiq2eXSq9
         y5q+m0EE3x5WnZ77JeGya8OSYWXGnbnJmU2GkuwZaBkx6sstBkPJv5A28SXuYPUuIFKq
         49FDkTMeU3plbNAmOZy2Au6r1hK3x228FxWN3K5lzICvE7bCD41lg6TLPQE1TO33Firq
         YEH6zFQwGLwv1iQDVL5qoVCHfpzEMsc/XudjwIcat8mAsthNUxG1sM/zNCsnGIMmQseV
         o8ig==
X-Gm-Message-State: AC+VfDy1t6+aeLoG2lmQHKS+VQ9QIc9ABvQpXxUDplsThYRhfylX1Lnc
	nYNI/b9c5kowTqOy+cnz78M1Pull++MCotyMuHFziA==
X-Google-Smtp-Source: ACHHUZ4Dc70Py9Vg0jIq3jI7qrPPKBmruqtOJLETUKx1S0Ns+vGWfN5/yYzX4clqkPJo8zsmmbofHiLsK0ZojXcR8TM=
X-Received: by 2002:a05:6e02:1448:b0:331:a582:1c63 with SMTP id
 p8-20020a056e02144800b00331a5821c63mr25404ilo.3.1686337192839; Fri, 09 Jun
 2023 11:59:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609183207.1466075-1-kuba@kernel.org> <20230609183207.1466075-2-kuba@kernel.org>
 <CANn89iKtQmP6-Q8ydYa9xs8C=O9cy+ER6F3jEEWNx5BNDiGpcg@mail.gmail.com>
In-Reply-To: <CANn89iKtQmP6-Q8ydYa9xs8C=O9cy+ER6F3jEEWNx5BNDiGpcg@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 9 Jun 2023 20:59:40 +0200
Message-ID: <CANn89iKe0XUMHqpSM7aKr1r=O-g3K2FwMyHVqvmEU17LhKy5SQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: create device lookup API with reference tracking
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

On Fri, Jun 9, 2023 at 8:57=E2=80=AFPM Eric Dumazet <edumazet@google.com> w=
rote:
>
> On Fri, Jun 9, 2023 at 8:32=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
> >
>
>
> > +/**
> > + *     netdev_get_by_name() - find a device by its name
> > + *     @net: the applicable net namespace
> > + *     @name: name to find
> > + *     @tracker: tracking object for the acquired reference
> > + *     @gfp: allocation flags for the tracker
> > + *
> > + *     Find an interface by name. This can be called from any
> > + *     context and does its own locking. The returned handle has
> > + *     the usage count incremented and the caller must use netdev_put(=
) to
> > + *     release it when it is no longer needed. %NULL is returned if no
> > + *     matching device is found.
> > + */
> > +struct net_device *netdev_get_by_name(struct net *net, const char *nam=
e,
> > +                                     netdevice_tracker *tracker, gfp_t=
 gfp)
> > +{
> > +       struct net_device *dev;
> > +
> > +       dev =3D dev_get_by_name(net, name);
> > +       if (dev)
> > +               netdev_tracker_alloc(dev, tracker, gfp);
> > +       return dev;
> > +}
> > +EXPORT_SYMBOL(netdev_get_by_name);
>
>
> What about making instead dev_get_by_name(net, name) a wrapper around
> the real thing ?
>
> static inline struct net_device *dev_get_by_name(struct net *net,
> const char *name)
> {
>     return netdev_get_by_name(net, name, NULL, 0);
> }
>
> This means netdev_get_by_name() could directly use netdev_hold()
> instead of netdev_tracker_alloc() which is a bit confusing IMO.
>
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b3c13e0419356b943e90b1f46dd7e035c6ec1a9c..b99f25c7fa0aad1eeb7fa117a=
aea2a0e16813fe0
> 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -759,9 +759,11 @@ struct net_device *dev_get_by_name_rcu(struct net
> *net, const char *name)
>  EXPORT_SYMBOL(dev_get_by_name_rcu);
>
>  /**
> - *     dev_get_by_name         - find a device by its name
> + *     netdev_get_by_name              - find a device by its name
>   *     @net: the applicable net namespace
>   *     @name: name to find
> + *     @tracker: tracker
> + *     @gfp: allocation flag for tracker
>   *
>   *     Find an interface by name. This can be called from any
>   *     context and does its own locking. The returned handle has
> @@ -770,17 +772,18 @@ EXPORT_SYMBOL(dev_get_by_name_rcu);
>   *     matching device is found.
>   */
>
> -struct net_device *dev_get_by_name(struct net *net, const char *name)
> +struct net_device *netdev_get_by_name(struct net *net, const char *name,
> +                                    netdevice_tracker *tracker, gfp_t gf=
p))
>  {
>         struct net_device *dev;
>
>         rcu_read_lock();
>         dev =3D dev_get_by_name_rcu(net, name);
> -       dev_hold(dev);
> +       netdev_hold(dev, tracker, gfp);

Oh well, this would need GFP_ATOMIC, I guess this might be the reason
you kept netdev_tracker_alloc()
that can run after rcu_read_unlock()

>         rcu_read_unlock();
>         return dev;
>  }
> -EXPORT_SYMBOL(dev_get_by_name);
> +EXPORT_SYMBOL(netdev_get_by_name);

