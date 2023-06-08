Return-Path: <netdev+bounces-9245-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F34AE72833A
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:05:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0664E1C20F3B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDF8512B80;
	Thu,  8 Jun 2023 15:05:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24B1D2FA
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 15:05:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD21B2D61
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 08:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686236712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n9DQyeVPqiHPj8YrryZ9yiwKZv7WusIMiEyAhefqDyM=;
	b=dLAr6+sGDRJWqr+L8K1Uk8UWfIm2HL6xmqTNmEehHiH2EgQ+lMI0acb7aKuwdgYYtPskaR
	O4GbgLvzj34hVJHCHdCRTzUjitRGiEgp0tqUJN7saGZVk553H+jBqzQbqdnn47sjF2iRFe
	nEkLX79DiNgYT7WSFt/jdLM8jCxoBWE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-fi8jaPWJPyWGKThANUBgZA-1; Thu, 08 Jun 2023 11:05:11 -0400
X-MC-Unique: fi8jaPWJPyWGKThANUBgZA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b1abdb8ef9so3738821fa.2
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 08:05:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686236709; x=1688828709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n9DQyeVPqiHPj8YrryZ9yiwKZv7WusIMiEyAhefqDyM=;
        b=RMFbOCJ60OBpJV5jPtOEBKFajno1ZBV9KRrX8T5lHY7Knoq+hk92g5InopFxFNlono
         oEJ/kND87lX51h7BYbsO6egRp7/QMFY9fehGmfA0ofj9d70vl6u6EBO0FYGSU+rMNB8F
         Oq9irsEwepPEHh1hvLR9ULXKmGgec1andEh6unkYCCZrecMtQhbAyt+//9qAGzyVAxlc
         WQ/UFhdJbKZbvoPcjZ3e1MxXU950CSEM4vxY8tSnw1OifZ/fnpKGApPEtZucm/9LL0fo
         2vBRYYt1NWp472M0r5NS6e0/7nzbL99Z+VKpynC9LWvPZ9YKXKrl21/570eO1a5ndlnE
         P7Rg==
X-Gm-Message-State: AC+VfDxcN1YUwENUbfBCOZgerYa1NZhyDedZsTMa7/gQHRb3CvKtA/NE
	txgeFV7oxRH3uztFlnm8z6DWJKqdsfA7KqJbFMzWMyyfCSTa1vbwjMh+fopaaPjogGjfvqkXNcv
	lPRD2FuWN4DM2SI44DSQpstuRxVZhPMxN
X-Received: by 2002:a2e:7c01:0:b0:2b1:b647:2782 with SMTP id x1-20020a2e7c01000000b002b1b6472782mr3139071ljc.45.1686236709547;
        Thu, 08 Jun 2023 08:05:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6uP1EqrR8KdqwSgFsfiAVx/Ilq1qJJ4Z/jedklINYudqjMIUQLfY6Hm6spvRi50Y8J+Y1mYQGaRVXUtTatAJ4=
X-Received: by 2002:a2e:7c01:0:b0:2b1:b647:2782 with SMTP id
 x1-20020a2e7c01000000b002b1b6472782mr3139054ljc.45.1686236709186; Thu, 08 Jun
 2023 08:05:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230608140246.15190-1-fw@strlen.de> <20230608140246.15190-3-fw@strlen.de>
In-Reply-To: <20230608140246.15190-3-fw@strlen.de>
From: Davide Caratti <dcaratti@redhat.com>
Date: Thu, 8 Jun 2023 17:04:57 +0200
Message-ID: <CAKa-r6uyObXeAUTj28=f+V8BvrUQpXGP12JHRikct3SB=x48GA@mail.gmail.com>
Subject: Re: [PATCH net v2 2/3] net/sched: act_ipt: add sanity checks on skb
 before calling target
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com, 
	davem@davemloft.net, pabeni@redhat.com, jhs@mojatatu.com, 
	xiyou.wangcong@gmail.com, jiri@resnulli.us, 
	Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

hello Florian,

On Thu, Jun 8, 2023 at 4:04=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Netfilter targets make assumptions on the skb state, for example
> iphdr is supposed to be in the linear area.
>
[...]

> @@ -244,9 +264,22 @@ TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff *sk=
b,
>                 .pf     =3D NFPROTO_IPV4,
>         };
>
> +       if (skb->protocol !=3D htons(ETH_P_IP))
> +               return TC_ACT_UNSPEC;
> +

maybe this can be converted to skb_protocol(skb, ...)  so that it's
clear how VLAN packets are treated ?
thanks!
--=20
davide


