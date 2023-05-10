Return-Path: <netdev+bounces-1383-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C16AA6FDA82
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:17:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D75A281349
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95E965C;
	Wed, 10 May 2023 09:17:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC35E63E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:17:09 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76953A82
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:17:07 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-50bc070c557so13331097a12.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683710226; x=1686302226;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eYxhVCw/20SUhQDflMPpZ87ItbhP7dsjeSoNPU5JA3I=;
        b=JbPPBj8Hggrhz+OovZD8OIPhkrLQNatznxXs7GOhet+2LG6iQrigaHMBattONY7H4u
         SMMmzZxN+2Zf156wszjboFR2gxCrN7O+zLi5PTpBR03D7Y9MTBgR2oBEWRb0iirIBXw0
         kvukjnF/kFptCoaPOjNP+XX8TlCJlF9l0EWb7kxNtidDyg8KaUMoOTxbl+4O+IPdqkj8
         mwgLRB7y37pURkdPOrF0CdvVwJ9vBjPz5x6wZlpaDd6D35Xr4yk+LrP2isboy7E4yduD
         a7K1xKX7/Ml8NbsvuEz0MDq1mKBNo7watgOmdi67zDk1J4yTdsP2BDj9NJwr4EC1Ouqr
         zQtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683710226; x=1686302226;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eYxhVCw/20SUhQDflMPpZ87ItbhP7dsjeSoNPU5JA3I=;
        b=g4+10xI0dDeamRWrWhjBK4wlr4xAnEIvE/Z2pun4Byv0J83nbfoiS6WnS6IuawwjB2
         7VsdQde+AqujCDbVuMSqFwikHrD3uUTO2j+Rm+dyfAUftNFmeVXCKSfpyXeq2HGDzK+U
         3L8n9+a0b8V6GrIPXjB1MA9krZL5fefH4EmfmjU0oafIo6PEwyds93kiJl+IMqj74BrI
         jAY3IwdyFkP8Tno7DZr3cUedxIQ5WC6NHWgJIs1qCTbLvHKUNBcjFNin1egueZ5KWuPE
         pKsIHzSEOpWsTCJGLloqiJGypLQYp+9N5UnUj91XyoxL/gL5YjCJAOTd+HylW54GjwZs
         HarA==
X-Gm-Message-State: AC+VfDzIulNgJFbShKXJ7FddAJAAxNz0b4L1cMuz96rEyq3xAZzD2aLs
	jqRQ1RV+u1RPOvrEX8Y444lrnwfwrHE=
X-Google-Smtp-Source: ACHHUZ6Oays/W2jXzuj6ndEc6r9HBC12Lv6etSWlFMJMCRJHeibv85IPFwh+E/LDUPOfEX9tAJCjhQ==
X-Received: by 2002:aa7:dd0f:0:b0:50c:4b1:8912 with SMTP id i15-20020aa7dd0f000000b0050c04b18912mr14313249edv.15.1683710225968;
        Wed, 10 May 2023 02:17:05 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id x14-20020aa7d38e000000b0050c0d651fb1sm1666158edq.75.2023.05.10.02.17.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 May 2023 02:17:05 -0700 (PDT)
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
Date: Wed, 10 May 2023 12:16:54 +0300
Cc: Eric Dumazet <edumazet@google.com>,
 netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E187AF3F-CF56-408C-B89D-6CC99563D242@gmail.com>
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

Hi all=20

one more update

i test with Proxmox direct  with kernel 6.2.6

modprobe dummy numdummies=3D1
ip link set dev dummy0 up
for i in $(seq 2 1999); do ip link add link dummy0 name vlan$i type vlan =
id $i; done
for i in $(seq 2 1999); do ip link set dev vlan$i up; done
 time for i in $(seq 2 1999); do ip link del link dummy0 name vlan$i =
type vlan id $i; done

real	1m6.308s
user	0m4.451s
sys	0m1.589s


This kernel is configured with CONFIG_HZ 250 and as you see i add 1998 =
vlans  if add 4094 is time up to 4-5 min to remove=20

in test kernel i set CONFIG_HZ to 1000 but i dont this this is fine for =
any server.




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


