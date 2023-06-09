Return-Path: <netdev+bounces-9673-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AEA372A2B0
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71F66281A16
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033F9408E8;
	Fri,  9 Jun 2023 18:58:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E325A408D9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:58:03 +0000 (UTC)
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B12E3592
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:58:02 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-33fa4707d03so14955ab.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 11:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686337082; x=1688929082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fwo3Pb7F/378zt3q06gD/igNufVqKxttwPhKCnwA8Rc=;
        b=S+OPvnB2xxdxP4aqMKs1+gQ8lhNH53vYOUpOTQ+A9pbF4FIsgVvMNRzJJs4BgaP2Mg
         4HC+J6mSzgtjYYI5+2sNdAcq5XPFnoNewn/Ah/JBepF3CCEoJ6MwisCwP0eIRwQktbHN
         t3TOC4VeAnYM+e5vERm2aDQY7zOv0Ow2eefSuH8GeVftFYDgbhFqCg1yYa9Zr99d4Nta
         NRizniVLa2jmQsOMMFaWokXTIVNonCwfOhQWYd0yExXLejVzO4X0nG6ZTntdQ/KrApIQ
         ZL0CoQIEIlMDmiIGeasGxSvlY7Kv63mFF1rn9rq47YGiWV9zoEdNr4iEq8GIDJ8A7AGu
         n2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686337082; x=1688929082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fwo3Pb7F/378zt3q06gD/igNufVqKxttwPhKCnwA8Rc=;
        b=YD2bueuRZE9hsm+h6VC7YwbivAheu7E76UzKldXJz1Td5X3+pq6eU+Vvjmh+CiofxU
         mDxSEREhjZAW+PszyaJa3QOXqscodr9nYs66hKrW5M3vuHAWZkbOLyIKeGtblXZseI77
         FCT2B+teQd9rqhYMLfoZEYKI2E1YO9CczmAZfM75aDPIp0IhWj0hUT0xAgZ7segMjS0m
         WvEvBNLC2FsnqCoTUON3xaJ7xh8BrhgxoPjTBSq1HFvBkUFOWNvVM7VRnEYIjZ9xSxo5
         bH1Vxv3Cof8YbGGQVgSeo7eo7UCJmaY4C+olQbxd0QAwGtNnyKXRUERR9eeu6lFyxTV1
         IkWg==
X-Gm-Message-State: AC+VfDxTa7b1ETh5sxQEZugdLnYBaxgDkMCXEelivWuxdrnWdKG6g35a
	Q0UCSnj5rYFvCMJGDQP+sYCEHhVumtxTk0OhL7FqlYd3EMDaulJbmCP4aQ==
X-Google-Smtp-Source: ACHHUZ6dMLQ7iAnYktNJzTdYjDwLIAA5PcVrkrCWRiQZOi7DlJakswRNab+Hl5zw1UcQeOmjl52M/VJxoqHIBaOhaUU=
X-Received: by 2002:a05:6e02:160f:b0:33d:8608:7596 with SMTP id
 t15-20020a056e02160f00b0033d86087596mr17738ilu.15.1686337081773; Fri, 09 Jun
 2023 11:58:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609183207.1466075-1-kuba@kernel.org> <20230609183207.1466075-2-kuba@kernel.org>
In-Reply-To: <20230609183207.1466075-2-kuba@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 9 Jun 2023 20:57:49 +0200
Message-ID: <CANn89iKtQmP6-Q8ydYa9xs8C=O9cy+ER6F3jEEWNx5BNDiGpcg@mail.gmail.com>
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

On Fri, Jun 9, 2023 at 8:32=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>


> +/**
> + *     netdev_get_by_name() - find a device by its name
> + *     @net: the applicable net namespace
> + *     @name: name to find
> + *     @tracker: tracking object for the acquired reference
> + *     @gfp: allocation flags for the tracker
> + *
> + *     Find an interface by name. This can be called from any
> + *     context and does its own locking. The returned handle has
> + *     the usage count incremented and the caller must use netdev_put() =
to
> + *     release it when it is no longer needed. %NULL is returned if no
> + *     matching device is found.
> + */
> +struct net_device *netdev_get_by_name(struct net *net, const char *name,
> +                                     netdevice_tracker *tracker, gfp_t g=
fp)
> +{
> +       struct net_device *dev;
> +
> +       dev =3D dev_get_by_name(net, name);
> +       if (dev)
> +               netdev_tracker_alloc(dev, tracker, gfp);
> +       return dev;
> +}
> +EXPORT_SYMBOL(netdev_get_by_name);


What about making instead dev_get_by_name(net, name) a wrapper around
the real thing ?

static inline struct net_device *dev_get_by_name(struct net *net,
const char *name)
{
    return netdev_get_by_name(net, name, NULL, 0);
}

This means netdev_get_by_name() could directly use netdev_hold()
instead of netdev_tracker_alloc() which is a bit confusing IMO.


diff --git a/net/core/dev.c b/net/core/dev.c
index b3c13e0419356b943e90b1f46dd7e035c6ec1a9c..b99f25c7fa0aad1eeb7fa117aae=
a2a0e16813fe0
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -759,9 +759,11 @@ struct net_device *dev_get_by_name_rcu(struct net
*net, const char *name)
 EXPORT_SYMBOL(dev_get_by_name_rcu);

 /**
- *     dev_get_by_name         - find a device by its name
+ *     netdev_get_by_name              - find a device by its name
  *     @net: the applicable net namespace
  *     @name: name to find
+ *     @tracker: tracker
+ *     @gfp: allocation flag for tracker
  *
  *     Find an interface by name. This can be called from any
  *     context and does its own locking. The returned handle has
@@ -770,17 +772,18 @@ EXPORT_SYMBOL(dev_get_by_name_rcu);
  *     matching device is found.
  */

-struct net_device *dev_get_by_name(struct net *net, const char *name)
+struct net_device *netdev_get_by_name(struct net *net, const char *name,
+                                    netdevice_tracker *tracker, gfp_t gfp)=
)
 {
        struct net_device *dev;

        rcu_read_lock();
        dev =3D dev_get_by_name_rcu(net, name);
-       dev_hold(dev);
+       netdev_hold(dev, tracker, gfp);
        rcu_read_unlock();
        return dev;
 }
-EXPORT_SYMBOL(dev_get_by_name);
+EXPORT_SYMBOL(netdev_get_by_name);

