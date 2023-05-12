Return-Path: <netdev+bounces-2120-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D6577004FE
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:13:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32E991C21130
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091DFD2F7;
	Fri, 12 May 2023 10:13:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D13BE4D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:13:40 +0000 (UTC)
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA7F124B3;
	Fri, 12 May 2023 03:13:10 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6436e075166so7343994b3a.0;
        Fri, 12 May 2023 03:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683886389; x=1686478389;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R5FsU0vvdQKuTXYmnQb/fKvraHaaia5fjLFwaOpzG0E=;
        b=gKopIC0Ejr48prllIgxRsCQpmc0UCbbE0J/p/JeQsDMnu5wwSkuLm5jJtN1x3aGEHv
         cf/5UKnsMWXmF6gZVZ+1xrR4MF5siAKKTPM4lWwCFJJAUPO7ksT5n1CrW+5m0aS2PlxF
         MAZ8nUhFUZMvni4AqwbBF9Jmmm1x2iyqIC8dSyT3L/n+7EbqeYDhib4olC/n92hzcJKv
         /y2ORWqodoipIrbSefE3VXRIy+6mkZNWtncp7U/YqsfphOV+nTpwnSPklWexR7tq7zoe
         kpH5gAqmvw2mDopFV+Qf9i8LfdeNgSJgEIOmGLtQH4ULyL2YbHojZOKrVZIIQ35q9gbu
         YsDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683886389; x=1686478389;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R5FsU0vvdQKuTXYmnQb/fKvraHaaia5fjLFwaOpzG0E=;
        b=ApJizOSo4R2YLf9H/e9uZUIK5z1Yyur0o6/2H6M7ID/lZG+0oC/jmyVY7kwbf4S2YE
         LuEQPxTJ7a5+GV4We6iHbyeOV15W6AhzAfcdni8VhEKOHIr1jcwrpdQfqTlgJ5SoHqke
         M41FQlCjozLdQxeO5W/0tRcBNuXnLil7EhL4yWE1Y4Xy5W0t4JDvTyZhsnmDqGs4rXIk
         3Ra5tNFz0JzrlMhXldIv8TQ4TfZNm4mYYaBdip83+fXSO9blXRu6LumbhyTYygOxRpq2
         815Ua99v9N3FK9oNn+0etje/db725wgPIUy4QKYGaSEvsA1OBh/QFPhNgJ4XUIsPs+6v
         1DpQ==
X-Gm-Message-State: AC+VfDyHWjJKNOjOCM8k7jIOlcpqpGoNd1v2p/Fck4U0G+7HztWqCNu+
	mlLc5LBe7G80o6RBerDB0BxWpcYAqliQJUMUduM=
X-Google-Smtp-Source: ACHHUZ61fMQpTF3gL5Pk8bJT/AuFGjVhuC2bfNcjv1mV+HWWVXLBYLqf/jxgByLJsBHmn85Z2xXgWxcIlfP9BlcgaEk=
X-Received: by 2002:a05:6a00:248d:b0:626:29ed:941f with SMTP id
 c13-20020a056a00248d00b0062629ed941fmr33453173pfv.5.1683886388780; Fri, 12
 May 2023 03:13:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230511151444.162882-1-Mikhail.Golubev-Ciuchea@opensynergy.com> <ZF0MXKkK1tEN6QyV@corigine.com>
In-Reply-To: <ZF0MXKkK1tEN6QyV@corigine.com>
From: Vincent Mailhol <vincent.mailhol@gmail.com>
Date: Fri, 12 May 2023 19:12:57 +0900
Message-ID: <CAMZ6Rq+6vv34Ps0G2SpB-9LHXYiD=esi604rm2tCE5Crp3QLvA@mail.gmail.com>
Subject: Re: [RFC PATCH v3] can: virtio: Initial virtio CAN driver.
To: Simon Horman <simon.horman@corigine.com>
Cc: Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>, 
	virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, 
	Wolfgang Grandegger <wg@grandegger.com>, Marc Kleine-Budde <mkl@pengutronix.de>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>, 
	Harald Mommer <harald.mommer@opensynergy.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon,

On Fri. 12 May 2023 at 00:45, Simon Horman <simon.horman@corigine.com> wrote:
> On Thu, May 11, 2023 at 05:14:44PM +0200, Mikhail Golubev-Ciuchea wrote:

[...]

> > +static u8 virtio_can_send_ctrl_msg(struct net_device *ndev, u16 msg_type)
> > +{
> > +     struct virtio_can_priv *priv = netdev_priv(ndev);
> > +     struct device *dev = &priv->vdev->dev;
> > +     struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
> > +     struct scatterlist sg_out[1];
> > +     struct scatterlist sg_in[1];
> > +     struct scatterlist *sgs[2];
> > +     int err;
> > +     unsigned int len;
>
> nit: For networking code please arrange local variables in reverse xmas
>      tree order - longest line to shortest.

Sorry for my curiosity, but where is it documented that the networking
code is using reverse christmas tree style?

I already inquired in the past here:

  https://lore.kernel.org/linux-can/CAMZ6Rq+zsC4F-mNhjKvqgPQuLhnnX1y79J=qOT8szPvkHY86VQ@mail.gmail.com/

but did not get an answer.

>      You can check this using: https://github.com/ecree-solarflare/xmastree

If we have to check for that, then please have this patch revived and merged:

  https://lore.kernel.org/lkml/1478242438.1924.31.camel@perches.com/

Personally, I am not willing to apply an out of tree linter for one
single use case.

>      In this case I think it would be:
>
>         struct virtio_can_priv *priv = netdev_priv(ndev);
>         struct device *dev = &priv->vdev->dev;
>         struct scatterlist sg_out[1];
>         struct scatterlist sg_in[1];
>         struct scatterlist *sgs[2];
>         struct virtqueue *vq;
>         unsigned int len;
>         int err;
>
>         vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];

