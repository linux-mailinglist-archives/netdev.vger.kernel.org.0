Return-Path: <netdev+bounces-10669-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C1A72FA34
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:13:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C54BC1C20C22
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 574206D18;
	Wed, 14 Jun 2023 10:13:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDB2612E
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:13:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C9711B
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686737606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jr0Ra4FJke4ZvkZCg3+qjwMQfo/JJ81HlhDGgW4oA68=;
	b=gBAQLU+2EPJpF7MbYz188uHR1kk6kvx9J1kREWkldRAvhMSyh0A4DVSovwI4cudeGODxbN
	LKnl2XiZsCuqyzqJIKrY6klupS2of973ofYNb8xi5CEr6+QPQpicVSm35P5pFlOqtRPW2A
	A4isdJxr7xDRu+3/fvLo3O7gP/LYze8=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-YbWjhaDFOUe0lvj58v1dXw-1; Wed, 14 Jun 2023 06:13:24 -0400
X-MC-Unique: YbWjhaDFOUe0lvj58v1dXw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4f256ddef3aso4702730e87.2
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686737603; x=1689329603;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jr0Ra4FJke4ZvkZCg3+qjwMQfo/JJ81HlhDGgW4oA68=;
        b=TZualVWlpMmjFfALIz9hpJerQitA6IoikQhp47LaOZAtj7+tvqzuCBz4vGwMJyGYZP
         NzXWAlnBhyI/ICbnIfPGWxpGHRuhl+V65h5qEL+u/RqNDuD+tA/aiBEoJ7oh6G22IBL4
         zZqfZabYwRopEz6em2TowB1ahe4EeVvGXcUexVc4lBzqZ0yBz4xUz/vvXQYAClxYazmI
         azNBdn7QmHx5FqWGC5QzhFNV7orNF+wcqPuo+2bWjatV7jt3bKSdx/Lpvvkv/KzPKpWk
         vpv/+cYDactBMlTbfaS8/CkC3GSt7H1IPWdiV+z/fY9bkgUxEFWHl7KYTEPbeW3ag3ym
         lrTQ==
X-Gm-Message-State: AC+VfDynQfIJDAW+Efg3/4WLSH/nZBEtBvaXh8WCLYpuPhLmi5EFaY7J
	IjKEl9B55stYgcMpT4IrhMTvDszZ1lG5t/3K+Moe/XXlTN5CCJLxI4C3GUeKuxZ5LRLihdLlgDV
	ry6UOyEhzGOh6X1LI/ogZOAoRk5ZQUQvq
X-Received: by 2002:a05:6512:329c:b0:4f1:3ca4:926f with SMTP id p28-20020a056512329c00b004f13ca4926fmr7642087lfe.21.1686737603387;
        Wed, 14 Jun 2023 03:13:23 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5YYuD2oA6AU2kQHVxScXc4b0yMM387nluPj2ySdlo6eoXkxU+aWj9WUmaUOS95pb54/8Ytw/ccXS0FE0w9hFo=
X-Received: by 2002:a05:6512:329c:b0:4f1:3ca4:926f with SMTP id
 p28-20020a056512329c00b004f13ca4926fmr7642072lfe.21.1686737602961; Wed, 14
 Jun 2023 03:13:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612144254.21039-1-ihuguet@redhat.com> <ZIdCFbjr0nEiS6+m@boxer>
 <CACT4oucSRrddFYaNDBsuvK_4imDZUvy9r2pvHp8Ji_E=oP6ecg@mail.gmail.com> <ZIl2Dw9Ve0b30WmV@gmail.com>
In-Reply-To: <ZIl2Dw9Ve0b30WmV@gmail.com>
From: =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date: Wed, 14 Jun 2023 12:13:11 +0200
Message-ID: <CACT4oufPV6FbQ7xOU8uPOS2SsA6R-F+D5H80SnrH3BEOe+WoMA@mail.gmail.com>
Subject: Re: [PATCH net] sfc: use budget for TX completions
To: =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>, 
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ecree.xilinx@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	netdev@vger.kernel.org, linux-net-drivers@amd.com, Fei Liu <feliu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 10:03=E2=80=AFAM Martin Habets <habetsm.xilinx@gmai=
l.com> wrote:
>
> On Mon, Jun 12, 2023 at 04:42:54PM +0200, =C3=8D=C3=B1igo Huguet wrote:
> > Documentations says "drivers can process completions for any number of =
Tx
> > packets but should only process up to budget number of Rx packets".
> > However, many drivers do limit the amount of TX completions that they
> > process in a single NAPI poll.
>
> I think your work and what other drivers do shows that the documentation =
is
> no longer correct. I haven't checked when that was written, but maybe it
> was years ago when link speeds were lower.
> Clearly for drivers that support higher link speeds this is an issue, so =
we
> should update the documentation. Not sure what constitutes a high link sp=
eed,
> with current CPUs for me it's anything >=3D 50G.

I reproduced with a 10G link (with debug kernel, though)

> > +#define EFX_NAPI_MAX_TX 512
>
> How did you determine this value? Is it what other driver use?

A bit of trial and error. I wanted to find a value high enough to not
decrease performance but low enough to solve the issue.

Other drivers use lower values too, from 128. However, I decided to go
to the high values in sfc because otherwise it can affect too much to
RX. The most common case I saw in other drivers was: First process TX
completions up to the established limit, then process RX completions
up to the NAPI budget. But sfc processes TX and RX events serially,
intermixed. We need to put a limit to TX events, but if it was too
low, very few RX events would be processed with high TX traffic.

> > I would better like to hear the opinion from the sfc maintainers, but
> > I don't mind changing it because I'm neither happy with the chosen
> > location.
>
> I think we should add it in include/linux/netdevice.h, close to
> NAPI_POLL_WEIGHT. That way all drivers can use it.
> Do we need to add this TX poll weight to struct napi_struct and
> extend netif_napi_add_weight()?
> That way all drivers could use the value from napi_struct instead of usin=
g
> a hard-coded define. And at some point we can adjust it.

That's what I thought too, but then we'd need to determine what's the
exact meaning for that TX budget (as you see, it doesn't mean exactly
the same for sfc than for other drivers, and between the other drivers
there were small differences too).

We would also need to decide what the default value for the TX budget
is, so it is used in netif_napi_add. Right now, each driver is using
different values.

If something is done in that direction, it can take some time. May I
suggest including this fix until then?

--
=C3=8D=C3=B1igo Huguet


