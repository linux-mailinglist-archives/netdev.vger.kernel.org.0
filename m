Return-Path: <netdev+bounces-6680-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E94D7176CB
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:24:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF3111C20C5F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E01A63D3;
	Wed, 31 May 2023 06:24:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AB54A3E
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:24:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CCA12B
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685514247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=71UZc/0E4WQ63ptPNUPQhKpoo7tka2Zc9zO8cAHyWCo=;
	b=Mf/nCvNCXNrVc4yKmyZIJ2IOqnmTeah+c5ntY/aXUoUWCIIFDZr7DR+jTNZGgcGm6I5Nc9
	vZJgiQqQXrbtAZ1DfKHXLXCnZJ1ba1BjoKrJV8PM9IzUscso+jLJRlwsA7KkedS7b9Re65
	ou0ed3LgqfKL1zIPGs4/0gHfdh1nA3c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-BrL6bzFfOAmrIbEcuaho6Q-1; Wed, 31 May 2023 02:24:06 -0400
X-MC-Unique: BrL6bzFfOAmrIbEcuaho6Q-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f602cec801so7888155e9.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:24:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685514244; x=1688106244;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=71UZc/0E4WQ63ptPNUPQhKpoo7tka2Zc9zO8cAHyWCo=;
        b=ltqBL8ZjBjftUcmP4C5Lnh7wunRAlZAZTaT/of1Qr8qy/xNbsNsZr5RW1/xM6x3JGU
         xaE1M3Y5LMEnVUq0HIHmpCtL8o3t+97hqKJOoXwNGoq+A6puRShqxgJFEaCl+iWY8+VJ
         MA/3/GyWSK+utmHq7UuQ2EsowhpMz9ImC2WAuobGzs8IWD2thR9EqIXLltM3/8wILI7z
         2hxS5GFTUs9KwDE9N+3NcYfSk8TaOh8h1Dh7C3JKtrs7FOdKPzWLPBJ0n4f5dWWJ6jo3
         zNvV6iCFiowyYHz9E5MXzxaCuwRWhnixvfYTx/nRCw+CiXWIoentPal+6Kwvj5W/oEWN
         BMOw==
X-Gm-Message-State: AC+VfDxvYcqsDpxRXN15yXeyzWWYyxg8rY0GojkIL/ffMbfqr887sZQU
	cL0cmlgnMWEXHMOTITUPujMU4BXqWNXY3hNEIz1mdf1HkbaL8DvZZ4Qlt7oT+Fimz+hQ0VyHk+k
	n4JCeCDUPDTRNuiDc7IuJbjfQ
X-Received: by 2002:a05:600c:1c86:b0:3f6:d8f:63a8 with SMTP id k6-20020a05600c1c8600b003f60d8f63a8mr1048315wms.0.1685514244763;
        Tue, 30 May 2023 23:24:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4ytxLWmZ59hWnquzw7IQ0dCkw1OCiTPVzMAktkCfsBDQN3T1EpcR3UqVgCC2JMxvB7abhyWQ==
X-Received: by 2002:a05:600c:1c86:b0:3f6:d8f:63a8 with SMTP id k6-20020a05600c1c8600b003f60d8f63a8mr1048299wms.0.1685514244504;
        Tue, 30 May 2023 23:24:04 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-89.dyn.eolo.it. [146.241.242.89])
        by smtp.gmail.com with ESMTPSA id r10-20020adfda4a000000b0030644bdefd8sm5467651wrl.52.2023.05.30.23.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 23:24:04 -0700 (PDT)
Message-ID: <f5d311452eba0a4d49d18682e9f143e6c69277dd.camel@redhat.com>
Subject: Re: [PATCH v1 net-next 00/14] udp: Farewell to UDP-Lite.
From: Paolo Abeni <pabeni@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>, davem@davemloft.net, 
	dsahern@kernel.org, kuni1840@gmail.com, netdev@vger.kernel.org, 
	willemdebruijn.kernel@gmail.com
Date: Wed, 31 May 2023 08:24:02 +0200
In-Reply-To: <20230530221043.5ae05030@kernel.org>
References: <20230530151401.621a8498@kernel.org>
	 <20230531010130.43390-1-kuniyu@amazon.com>
	 <CANn89iKK4Si92z91ACV_mgh4vqbecxQCHmB-SYEbq6Bsqei_Qg@mail.gmail.com>
	 <20230530221043.5ae05030@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-30 at 22:10 -0700, Jakub Kicinski wrote:
> On Wed, 31 May 2023 06:25:33 +0200 Eric Dumazet wrote:
> > > Yes, if it's ok, it would be better to add a WARN_ONCE() to stable.
> > >=20
> > > If we added it only in net-next, no one might notice it and we could
> > > remove UDP-Lite before the warning is available in the next LTS stabl=
e
> > > tree. =20
> >=20
> > WARN_ONCE() will fire a syzbot report.
> >=20
> > Honestly I do not  think UDP-Lite is a significant burden.
> >=20
> > What about instead adding a CONFIG_UDPLITE and default it to
> > "CONFIG_UDPLITE is not set" ?
> >=20
> > And add a static key, with /proc/sys/net/core/udplite_enable to
> > eventually save some cycles in various fast paths
> > and let the user opt-in, in case it is using a distro kernel. with
> > CONFIG_UDPLITE=3Dy
>=20
> oohm, fair point user-reachable WARN() is a liability.

What about a plain pr_warn_once() banner, verbose enough to be
noticeable? Alike:

https://lwn.net/ml/linux-fsdevel/20220225125445.29942-1-jack@suse.cz/


Cheers,

Paolo


