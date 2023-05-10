Return-Path: <netdev+bounces-1329-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B630B6FD637
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 07:31:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB5161C20CDA
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 05:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD941441E;
	Wed, 10 May 2023 05:31:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4AE20EA
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 05:31:53 +0000 (UTC)
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A101107
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:31:51 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so65571118a12.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 22:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683696710; x=1686288710;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lBUoUlGaXFvJTy3aAMNoDcnH1Qvpi/B0cwgv97yLm/0=;
        b=ZHTsc7wc5Kr/6IuGPOi/WwP4DBGw53QoLeMBWjVZTOc+K+TNcgJ92h8UMnQAEjieG5
         LZUVGXro6n5fIbUsryLBmvZNcdeyIwjdDeDF0Zwxy7NjXJyxFUgkzgd/zwAvI/wgFFfF
         59tJnD9C7mWWj8fl6ICXyR36DVG51o5F+IfDFdIX7zQH1+rjNT9SARO1pjgdDnhAqsYU
         4IBltDh176tmRrz+QOptNIY9eSM+TCW9Loj7tNan22VvH+YHFm/0HQ9tOxx9UGUf6qDL
         UrT2J6egn8lKf4TWEBG9apzzi+lR1vFHABrrkG00yQRkejbHGDkonkzVMAeCmktBodFn
         jsGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683696710; x=1686288710;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lBUoUlGaXFvJTy3aAMNoDcnH1Qvpi/B0cwgv97yLm/0=;
        b=e2rt3j/PI53DAHfDrMotrjSzMu6uK+r3ZDf82npcpivhK8UmtVXxn+xeOSZoaqDSEk
         bEvQ2Ku1qBIlwMbCQptFSabCJFVtGkmCN215YolxIHmsw95REk9SiQ2/+cmkVK4zlvoq
         EXsJObRacwUcXvqPJ/K2aBpZ+MmAhmSVN0sAECZqzxBVKB0P/kzyXmz6UZQNuiX50T3N
         DIsnXZRcJjIQS5LStRsjHacrOuBvJH9ydODbxzVJaD6pknrzel2w6YHhMd/I7lakOsMA
         ts0KtFagsUC2JuXb/ECeu4SCgtJjIvpjtZqVfMLIV9psd2I5w+S7wm2CM6ADf4bF3Cvo
         ExEg==
X-Gm-Message-State: AC+VfDzgH3DR7K0vP6iy1Up95I1yXId6tR/by0plXLsYCwbVWRX5+Hso
	Pwt/D+EfHHMwG+Zs8Pjq/lHqSeRDqmc=
X-Google-Smtp-Source: ACHHUZ4FhmxGJyTXzWZQqlGIZhAWx6UfxeFOUoZ/wNQW2gibVzZ7w+co5+faMiLnnbg5OGqi/Ye8Yg==
X-Received: by 2002:a05:6402:2794:b0:508:3c23:ae95 with SMTP id b20-20020a056402279400b005083c23ae95mr14266904ede.3.1683696709722;
        Tue, 09 May 2023 22:31:49 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id r16-20020a170906c29000b0094f3e169ca5sm2177800ejz.158.2023.05.09.22.31.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 May 2023 22:31:49 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: Very slow remove interface from kernel
From: Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <ZFqoNJqwLjaVFGaa@shredder>
Date: Wed, 10 May 2023 08:31:38 +0300
Cc: Eric Dumazet <edumazet@google.com>,
 netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BF88F3F8-68F0-4A6B-AA98-EE4D00491532@gmail.com>
References: <371A6638-8D92-4891-8DF5-C0EA4FBC1977@gmail.com>
 <ZFoeZLOZbNZPUfcg@shredder>
 <CANn89i+=gWwebCHk2qwu12qC+yXTFUqOxWTfnqbJOAFjidcYeg@mail.gmail.com>
 <A4F00E57-AB0E-4211-B9E4-225093EB101F@gmail.com>
 <CANn89iKOm2WPoemiqCsWaMXMyGf9C5xXH=NaSidPSNCpKxf_jQ@mail.gmail.com>
 <FE7CE62C-DBEB-4FE1-8ACB-C8B7DAF15710@gmail.com> <ZFqoNJqwLjaVFGaa@shredder>
To: Ido Schimmel <idosch@idosch.org>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Eric and Ido

after little research after change CONFIG_HZ_100 > CONFIG_HZ_1000=20


vlanadd

real	0m15.106s
user	0m2.420s
sys	0m13.250s

vlandel:=20

real	1m10.995s
user	0m1.045s
sys	0m7.678s

i use 100 last 10 years all installation is server for networking.

do you have any recommendations

best regards,
m


> On 9 May 2023, at 23:08, Ido Schimmel <idosch@idosch.org> wrote:
>=20
> On Tue, May 09, 2023 at 09:50:18PM +0300, Martin Zaharinov wrote:
>> i try on kernel 6.3.1=20
>>=20
>>=20
>> time for i in $(seq 2 4094); do ip link del link eth1 name vlan$i =
type vlan id $i; done
>>=20
>> real 4m51.633s  =E2=80=94=E2=80=94 here i stop with Ctrl + C  -  and =
rerun  and second part finish after 3 min
>> user 0m7.479s
>> sys 0m0.367s
>=20
> You are off-CPU most of the time, the question is what is blocking. =
I'm
> getting the following results with net-next:
>=20
> # time -p for i in $(seq 2 4094); do ip link del dev eth0.$i; done
> real 177.09
> user 3.85
> sys 31.26
>=20
> When using a batch file to perform the deletion:
>=20
> # time -p ip -b vlan_del.batch=20
> real 35.25
> user 0.02
> sys 3.61
>=20
> And to check where we are blocked most of the time while using the =
batch
> file:
>=20
> # ../bcc/libbpf-tools/offcputime -p `pgrep -nx ip`
> [...]
>    __schedule
>    schedule
>    schedule_timeout
>    wait_for_completion
>    rcu_barrier
>    netdev_run_todo
>    rtnetlink_rcv_msg
>    netlink_rcv_skb
>    netlink_unicast
>    netlink_sendmsg
>    ____sys_sendmsg
>    ___sys_sendmsg
>    __sys_sendmsg
>    do_syscall_64
>    entry_SYSCALL_64_after_hwframe
>    -                ip (3660)
>        25089479
> [...]
>=20
> We are blocked for around 70% of the time on the rcu_barrier() in
> netdev_run_todo().
>=20
> Note that one big difference between my setup and yours is that in my
> case eth0 is a dummy device and in your case it's probably a physical
> device that actually implements netdev_ops::ndo_vlan_rx_kill_vid(). If
> so, it's possible that a non-negligible amount of time is spent =
talking
> to hardware/firmware to delete the 4K VIDs from the device's VLAN
> filter.
>=20
>>=20
>>=20
>> Config is very clean i remove big part of CONFIG options .
>>=20
>> is there options to debug what is happen.
>>=20
>> m


