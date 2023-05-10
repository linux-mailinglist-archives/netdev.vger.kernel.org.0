Return-Path: <netdev+bounces-1385-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C85E6FDAA5
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:22:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC8E0281369
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269D5811;
	Wed, 10 May 2023 09:22:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FD265D
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:22:53 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1794203
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:22:24 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f423c17bafso104485e9.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683710542; x=1686302542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IjFXoK8wfbqLd7gYO5GChzfd/0qPRNLjRWApqwn5Evs=;
        b=Uk8jRYIcYz2LZdamGzQWf/3Ma1khMgKfPWXNU9EwMyarFbdBwIC4fH5cUTBY57HsUB
         KkWs7JpB5oW4rPFp7vT29jNKtPgSZLVk7hG61g/zHBx+UaecPlTZHo9U9OIKiN6ac5gX
         XG4zDms5KJKbA2LAqB1hzE8WkMaWNoGNHDGexi6uxVWfCkmEHx7DP33GAIXMsgEeReHp
         Ym82z83FLsrbEluUb39f6CnjeDSn/DWCgoJ2i49SlxyScMhZxmFfa2mFbOP/IeUnhiE/
         nCbCi/c6fI3PuYA0dvimjwRjLJsa9ErWNIEWTWUIOEYSpQhDO3R0QelgE/Lnyq7vOJpl
         qf3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683710542; x=1686302542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IjFXoK8wfbqLd7gYO5GChzfd/0qPRNLjRWApqwn5Evs=;
        b=JUC7t14birhwNieLEND4JCLTrmblpt3WAGTPW3FMoQOBRFhSPy6OSp3GwkVX7Yahx4
         wLOvAhvbQJVka7Xa3Pwtau7qSwwU232w8u4mK6ZDQ0G5qXkcNJY4WPHNW+izgClXKd58
         p1TITq9oaPCF3TKcARH0nyZVKB45w5zwTK/8o2xp4ozoHIsS5yhWXghiR8HjkqGNjRpu
         uitSGKsDaexV0i4SflGz9kBe516zneQh03aSMqFfB6wXLS5Swkio71UPTILw6F3Ytfab
         wqKcqORDJ2XkuCxBfl0MR88hgZ0SkuYhRR1ZxejkK/qbM2BngjcDc90gehjN30htQRiV
         d2ww==
X-Gm-Message-State: AC+VfDzVCOUhFiYxEKPvxzWdz8TVinl/9wBSTl7nCOdJDGbmCoGH2WVC
	VNWVDbdVfC/s7Qp4vE+0Dh//58a1fhulRQ73PPPG0pUg07nSQw1dV5s=
X-Google-Smtp-Source: ACHHUZ75cQCEIBEaixtKKJdQXmfravQIg5yQGOloOGbnHRDTkrbTmuxoD597CCCBFZVYYMNFtSwgEQZ9sOGbpZBmrxQ=
X-Received: by 2002:a05:600c:500f:b0:3f4:2736:b5eb with SMTP id
 n15-20020a05600c500f00b003f42736b5ebmr102534wmr.1.1683710542464; Wed, 10 May
 2023 02:22:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <371A6638-8D92-4891-8DF5-C0EA4FBC1977@gmail.com>
 <ZFoeZLOZbNZPUfcg@shredder> <CANn89i+=gWwebCHk2qwu12qC+yXTFUqOxWTfnqbJOAFjidcYeg@mail.gmail.com>
 <A4F00E57-AB0E-4211-B9E4-225093EB101F@gmail.com> <CANn89iKOm2WPoemiqCsWaMXMyGf9C5xXH=NaSidPSNCpKxf_jQ@mail.gmail.com>
 <FE7CE62C-DBEB-4FE1-8ACB-C8B7DAF15710@gmail.com> <ZFqoNJqwLjaVFGaa@shredder> <E187AF3F-CF56-408C-B89D-6CC99563D242@gmail.com>
In-Reply-To: <E187AF3F-CF56-408C-B89D-6CC99563D242@gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 May 2023 11:22:10 +0200
Message-ID: <CANn89i+=gQ8501d-rSf_wM_DDUgYj+uJJQPpCFev5CgaSsKrQg@mail.gmail.com>
Subject: Re: Very slow remove interface from kernel
To: Martin Zaharinov <micron10@gmail.com>
Cc: Ido Schimmel <idosch@idosch.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 11:17=E2=80=AFAM Martin Zaharinov <micron10@gmail.c=
om> wrote:
>
> Hi all
>
> one more update
>
> i test with Proxmox direct  with kernel 6.2.6
>
> modprobe dummy numdummies=3D1
> ip link set dev dummy0 up
> for i in $(seq 2 1999); do ip link add link dummy0 name vlan$i type vlan =
id $i; done
> for i in $(seq 2 1999); do ip link set dev vlan$i up; done
>  time for i in $(seq 2 1999); do ip link del link dummy0 name vlan$i type=
 vlan id $i; done
>
> real    1m6.308s
> user    0m4.451s
> sys     0m1.589s
>
>
> This kernel is configured with CONFIG_HZ 250 and as you see i add 1998 vl=
ans  if add 4094 is time up to 4-5 min to remove
>
> in test kernel i set CONFIG_HZ to 1000 but i dont this this is fine for a=
ny server.

We use CONFIG_HZ=3D1000 on server builds.

Other values cause suboptimal behavior, for instance in TCP stack.


>
>
> > On 9 May 2023, at 23:08, Ido Schimmel <idosch@idosch.org> wrote:
> >
> > On Tue, May 09, 2023 at 09:50:18PM +0300, Martin Zaharinov wrote:
> >> i try on kernel 6.3.1
> >>
> >>
> >> time for i in $(seq 2 4094); do ip link del link eth1 name vlan$i type=
 vlan id $i; done
> >>
> >> real 4m51.633s  =E2=80=94=E2=80=94 here i stop with Ctrl + C  -  and r=
erun  and second part finish after 3 min
> >> user 0m7.479s
> >> sys 0m0.367s
> >
> > You are off-CPU most of the time, the question is what is blocking. I'm
> > getting the following results with net-next:
> >
> > # time -p for i in $(seq 2 4094); do ip link del dev eth0.$i; done
> > real 177.09
> > user 3.85
> > sys 31.26
> >
> > When using a batch file to perform the deletion:
> >
> > # time -p ip -b vlan_del.batch
> > real 35.25
> > user 0.02
> > sys 3.61
> >
> > And to check where we are blocked most of the time while using the batc=
h
> > file:
> >
> > # ../bcc/libbpf-tools/offcputime -p `pgrep -nx ip`
> > [...]
> >    __schedule
> >    schedule
> >    schedule_timeout
> >    wait_for_completion
> >    rcu_barrier
> >    netdev_run_todo
> >    rtnetlink_rcv_msg
> >    netlink_rcv_skb
> >    netlink_unicast
> >    netlink_sendmsg
> >    ____sys_sendmsg
> >    ___sys_sendmsg
> >    __sys_sendmsg
> >    do_syscall_64
> >    entry_SYSCALL_64_after_hwframe
> >    -                ip (3660)
> >        25089479
> > [...]
> >
> > We are blocked for around 70% of the time on the rcu_barrier() in
> > netdev_run_todo().
> >
> > Note that one big difference between my setup and yours is that in my
> > case eth0 is a dummy device and in your case it's probably a physical
> > device that actually implements netdev_ops::ndo_vlan_rx_kill_vid(). If
> > so, it's possible that a non-negligible amount of time is spent talking
> > to hardware/firmware to delete the 4K VIDs from the device's VLAN
> > filter.
> >
> >>
> >>
> >> Config is very clean i remove big part of CONFIG options .
> >>
> >> is there options to debug what is happen.
> >>
> >> m
>

