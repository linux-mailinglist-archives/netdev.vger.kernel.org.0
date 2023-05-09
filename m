Return-Path: <netdev+bounces-1253-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 758AD6FCF46
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:16:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4880A2811E6
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 20:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E24C18C13;
	Tue,  9 May 2023 20:16:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F7518C01
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 20:16:52 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB272102
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:16:50 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-50bd875398dso9788479a12.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 13:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683663409; x=1686255409;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0g9Qkv5HZ0/HuusO/Ks/hnj9DOmVIST6GRSZsc8DuD0=;
        b=ZN1+6jP0T1BvJIuMUVhQgJUlwZiaoT8V2RXddStq9K7WqVwexXvOeB6SHjRiJhqjEU
         lPEgjWo8g3a3a3tNCv//Pi3Yw/gzK0Fg0dm8SWJ0LOgVG86aFCWKgxTYjzvNJJqAsbHS
         JGya0Hgt4tzAnNGvOyqD3clga4dHCrZHJMVRKLmNCx1Pz+LT9bYfpwOKQ3t2Q63dSrmU
         wBzXDKYA9mH1EzQnmVwU8JsXRKw+HwVCU2/Sir/0b5gc/epQEqpS406uJCAEIYpUJnmS
         +pGWVeta/rJubNxD5n2W6tGlcGU6Km7U0KSbQ5OxC9xEL2QAO1B6It6Qi0yTWDZyswxY
         8L0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683663409; x=1686255409;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0g9Qkv5HZ0/HuusO/Ks/hnj9DOmVIST6GRSZsc8DuD0=;
        b=Qf58pMm5Ks29NcU9VSVFZehdOKLBSRXxc4ptx15GK7cXG8MtBkCUrsOKhNIA4zhrIk
         nG2eS1iFfkB5VNcq9DBBgJFoX868eDcKvqOq/GLAJ0jo0jrr/KE3LI4x6F1sfl3MrbOZ
         aOyb6ifpQn/J6NVOh8rYQy8/rXPpEK+zm3lPV/Dz5DAUgEZuE51udtzZf2abxGo0APb3
         /++ZGBC3pS/n+EU+rZWiiobJatXM3XhkmAu7A3SVdhCc1658JfRbAzQjOEiXVedozf5D
         nj/abf2eblzFemP3As1UeG/VEm074ypW5YDR4Ky0HqTFfucvio25jtJlDmiPKHZd4t1C
         I+Uw==
X-Gm-Message-State: AC+VfDyFpeG+AlcGFH0WP0pmUNu7M6lpffNh8DIs8OZUQjgAzUFRQRsW
	d3gW1hx+tRhELhRpGCh6k18=
X-Google-Smtp-Source: ACHHUZ5IPF2XqiijQuEaLXTQGUQY4Z5FGfUm5qaz8BfGxHhE4/1xGgCv/EguQbtxqP1FlbUOExcFAQ==
X-Received: by 2002:a17:906:fe01:b0:94f:322d:909d with SMTP id wy1-20020a170906fe0100b0094f322d909dmr13064051ejb.63.1683663408679;
        Tue, 09 May 2023 13:16:48 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id og40-20020a1709071de800b0095807ab4b57sm1740531ejc.178.2023.05.09.13.16.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 May 2023 13:16:48 -0700 (PDT)
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
Date: Tue, 9 May 2023 23:16:37 +0300
Cc: Eric Dumazet <edumazet@google.com>,
 netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <18787829-0189-40EF-9AD2-B270F3EBA2C6@gmail.com>
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

Hi Ido

yes is physical card intel 82599 dual port 10G on 2 socket system with =
24 core on 3Ghz

this is time :=20

time ./vlanadd

real	0m12.347s
user	0m8.863s
sys	0m2.594s

time ./vlanrem

real	8m59.105s
user	0m11.931s
sys	0m0.035s


for 1sec with : watch -n.1 "ip a | grep UP | wc=E2=80=9D

and run vlanrem=20

in 1sec ~ remove 4-5 vlans

and i think rcu make problem.

i found one post from 2009 : =
https://lore.kernel.org/all/20091024144610.GC6638@linux.vnet.ibm.com/T/

yes is old and may be is make many changes after that .

i have same case with slow remove interface and with ppp interface when =
drop users over 800-900 make same problem to remove device and reconnect =
(readd)

m.

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


