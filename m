Return-Path: <netdev+bounces-2909-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8EB67047E9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:34:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 626581C20DCB
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D4E32C722;
	Tue, 16 May 2023 08:34:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAAE2C720
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:34:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336DE40D5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684226056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L/l0pLc5PrB0GCBVRJIl+xdVcASfDrDe/hZu8/KOYH0=;
	b=fFsn8WoRJxEcP6vmrvqrcxBrnzhnckVngnU6/NlntrDxjyAlgt5MQaQgV9jPE6c3F5BXT7
	BysxjfQs/qFq/ygPe0SFk3dBE6RBEeYSr6HUdK1m2nhBqQsdNZzNJ6418PTGnLzVQz2jF3
	gc3XJydLJced9YiBqXnv2i0Rv8zpN3s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-_nJ7jbEhMHS0figeASrEOw-1; Tue, 16 May 2023 04:34:15 -0400
X-MC-Unique: _nJ7jbEhMHS0figeASrEOw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f4e45813ddso5747015e9.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:34:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684226054; x=1686818054;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L/l0pLc5PrB0GCBVRJIl+xdVcASfDrDe/hZu8/KOYH0=;
        b=TjJB6d5TEslb5HyxuKjb/Foa9ERdM1MtiMh/LrHD6VIx5KofcozfBpTr5w1M3ybBQc
         3DMMahQbfkhcvV05HzSSHO3R8kz6fiBARJdcHb3MdWKliCXEUIWbrU8urJOnboJDj2O4
         EyJMNBqP0L6adMfAcaK6a957NTz/A+i1f8gnLHjFpuEe5Fh2BLiVSXmA1mJzAdjJXUOz
         x53WoGUAp+UlnppCQ/TJbZVn1un5q65WYrVT4DxwylcNe4bqKHwVoYM4G8wCdAUis6Gr
         MF3YfZ3S3yZa3m5uJYDac4WlE2hdLA28ESDZCSxjwYEtJ0rmmVVoFJsIcbF66xCktxPA
         nPwA==
X-Gm-Message-State: AC+VfDzSVL/D/BRPpkzTjxtYiK05hmOxwMJ3i2psKX3qX5qxPT2REbJi
	sUnaICHYY3Dx3vusKbbYejReulQXzLxOWFaiGkdZQ4rNAB5hD7TQ8jaH/bCnLIqjErQImj3+M58
	cnGbqBT9yOH4IjuMG
X-Received: by 2002:a05:600c:3514:b0:3f4:e426:e0b7 with SMTP id h20-20020a05600c351400b003f4e426e0b7mr1866031wmq.3.1684226053884;
        Tue, 16 May 2023 01:34:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4xH2Lq7p3IYsAkm82uIQxTLiTKT1IK0Smzefvlo1QSjAngXJX9xIoDDjtwTfmkycqs6IG0Tw==
X-Received: by 2002:a05:600c:3514:b0:3f4:e426:e0b7 with SMTP id h20-20020a05600c351400b003f4e426e0b7mr1866014wmq.3.1684226053566;
        Tue, 16 May 2023 01:34:13 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-225-74.dyn.eolo.it. [146.241.225.74])
        by smtp.gmail.com with ESMTPSA id f9-20020a7bc8c9000000b003f4253ddb7dsm1451527wml.43.2023.05.16.01.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 01:34:12 -0700 (PDT)
Message-ID: <813be3bd0823bac31dc1b018750fad29d794d9c2.camel@redhat.com>
Subject: Re: [PATCH net] net: fix stack overflow when LRO is disabled for
 virtual interfaces
From: Paolo Abeni <pabeni@redhat.com>
To: Taehee Yoo <ap420073@gmail.com>, Nikolay Aleksandrov
 <razor@blackwall.org>,  davem@davemloft.net, kuba@kernel.org,
 edumazet@google.com, jiri@resnulli.us,  j.vosburgh@gmail.com,
 andy@greyhouse.net, netdev@vger.kernel.org
Cc: jarod@redhat.com, wangyufen@huawei.com, 
	syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
Date: Tue, 16 May 2023 10:34:11 +0200
In-Reply-To: <52da9cd3-508f-eb7d-98b3-cd777acc90eb@gmail.com>
References: <20230515053740.3065735-1-ap420073@gmail.com>
	 <eeff656b-22ac-082d-9b94-62980e806f0f@blackwall.org>
	 <52da9cd3-508f-eb7d-98b3-cd777acc90eb@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-05-15 at 18:12 +0900, Taehee Yoo wrote:
> On 5/15/23 15:24, Nikolay Aleksandrov wrote:
>  > On 15/05/2023 08:37, Taehee Yoo wrote:
>  >> When the virtual interface's feature is updated, it synchronizes the
>  >> updated feature for its own lower interface.
>  >> This propagation logic should be worked as the iteration, not=20
> recursively.
>  >> But it works recursively due to the netdev notification unexpectedly.
>  >> This problem occurs when it disables LRO only for the team and bondin=
g
>  >> interface type.
>  >>
>  >>         team0
>  >>           |
>  >>    +------+------+-----+-----+
>  >>    |      |      |     |     |
>  >> team1  team2  team3  ...  team200
>  >>
>  >> If team0's LRO feature is updated, it generates the NETDEV_FEAT_CHANG=
E
>  >> event to its own lower interfaces(team1 ~ team200).
>  >> It is worked by netdev_sync_lower_features().
>  >> So, the NETDEV_FEAT_CHANGE notification logic of each lower interface
>  >> work iteratively.
>  >> But generated NETDEV_FEAT_CHANGE event is also sent to the upper
>  >> interface too.
>  >> upper interface(team0) generates the NETDEV_FEAT_CHANGE event for=20
> its own
>  >> lower interfaces again.
>  >> lower and upper interfaces receive this event and generate this
>  >> event again and again.
>  >> So, the stack overflow occurs.
>  >>
>  >> But it is not the infinite loop issue.
>  >> Because the netdev_sync_lower_features() updates features before
>  >> generating the NETDEV_FEAT_CHANGE event.
>  >> Already synchronized lower interfaces skip notification logic.
>  >> So, it is just the problem that iteration logic is changed to the
>  >> recursive unexpectedly due to the notification mechanism.
>  >>
>  >> Reproducer:
>  >>
>  >> ip link add team0 type team
>  >> ethtool -K team0 lro on
>  >> for i in {1..200}
>  >> do
>  >>          ip link add team$i master team0 type team
>  >>          ethtool -K team$i lro on
>  >> done
>  >>
>  >> ethtool -K team0 lro off
>  >>
>  >> In order to fix it, the priv_notifier_ctx net_device member is=20
> introduced.
>  >> This variable can be used by each interface in its own way in the
>  >> notification context. The bonding and team interface is going to use =
it
>  >> to avoid duplicated NETDEV_FEAT_CHANGE event handling.
>  >>
>  >> Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
>  >> Fixes: fd867d51f889 ("net/core: generic support for disabling netdev=
=20
> features down stack")
>  >> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>  >> ---
>  >>   drivers/net/bonding/bond_main.c | 6 +++++-
>  >>   drivers/net/team/team.c         | 6 +++++-
>  >>   include/linux/netdevice.h       | 1 +
>  >>   net/core/dev.c                  | 2 ++
>  >>   4 files changed, 13 insertions(+), 2 deletions(-)
>  >>
>  >
>  > Since you're syncing to lower devices, can't you check if the event=
=20
> source device
>  > is lower to the current one (i.e. reverse propagation has happened)=
=20
> in the affected
>  > drivers ? Adding a new struct netdevice member just for this seems=20
> unnecessary to me.
>  > Especially for a setup like a bond of bonds or a team of teams, these=
=20
> are corner case
>  > setups that shouldn't exist in general. :)
>  >
>=20
> I agree that this new variable is unnecessary right now.
> I tried to avoid introducing new variables, but unfortunately, I=20
> couldn't find a solution to detect duplicated notification events.
>=20
> The reason why I introduced the new member of the net_device is that I=
=20
> thought there might be similar problems in the future such as mtu.
> so, I hoped that it can be used as a general variable to avoid similar=
=20
> problems.
> But I really agree that this new variable is over-spec.
> So, adding a new boolean variable into the struct bonding and team, not=
=20
> net_device would be reasonable if I can't find a proper solution.

I think adding a bool variable to bonding/team priv would be better, as
it looks like the issues is specific to such kind of devices.

Thanks!

Paolo


