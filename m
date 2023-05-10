Return-Path: <netdev+bounces-1477-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 212886FDE48
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:15:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 845BA281443
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9425B12B7F;
	Wed, 10 May 2023 13:15:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82442101EE
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:15:23 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDA0195
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 06:15:21 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-965ac4dd11bso1432239766b.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 06:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683724519; x=1686316519;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=riXFz6o+ydIsaTrp1wRkLR8eE5JIRMYKoCxpJXJgmgw=;
        b=Ms7EGo72WAvwjkX67J8f6dcY+sjaCndi2rhRnWLqGCv7LC31Mufm1DwTXk/8U0K4iI
         C0LtYcb4IUMtV3m8Rq7RrZQpLrADXACLuiCsjyRSmMBeB/RX7J3tkwnIvlZrRAJnzT6F
         2YyFGoUqK68SqAyEJcqACqXnsMEmgTthIZ1WXxFaUfAMwGcjgrbTw7kivtAhKyXXUSdU
         9dPbvxV27vWT/aOacPoL/O7Fy4mBOgj0Ut3CHg+InL42SG3AZMr1YeNFQWwp+A7nhIT4
         9YNe+zX8x2EjHVvTGKX4WJLwurH8MBaOomTff9UE1bL9WAfVQ6IVJ3d3mCZhpe4gD8E1
         DJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683724519; x=1686316519;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=riXFz6o+ydIsaTrp1wRkLR8eE5JIRMYKoCxpJXJgmgw=;
        b=enL0jl4RGS7zphBW/XjYcPJCDO6T6vbjO5De3Y+1vfmjPF3P5QIcmRExGgQrINMLT0
         WJMc3I3J6oiaTZDDeOyqIi+T2jcNdgPqg74xzoEPTNH2p+MOatNNeIftzffGQ9CYeFzX
         S60a3j4+Zef0Pa/xNcVqRIUhTs7SbbjyGOM8BH7UnHWD90tVncCCV4NlRxsQA8QarT1f
         ykj7vXjKyx9xd6JF1aoK2eIUQuS5QhlJBEQOr7C7WGgEEVoLPso6PFhkpsdX9xI3SaGU
         45kbxx0GTuWBKBndmxa+5bFoOdhKEi8cZANnj+vdB/fnZT/NarfEsunYLNCwpFjiLDXz
         67vg==
X-Gm-Message-State: AC+VfDwr4pbftlYt/Jp/iJS5c8kGRUMlKPrwk9ea8MBdy8BlQ+Ur242O
	R5VIhrWcN0zdka+Zb6YF4wInBAbzfwo=
X-Google-Smtp-Source: ACHHUZ5EIXAH0H3QZF/5m9AZNX59H1UdyaCeaSLNDBASF9i3DvCflKkzOBwiZhH+EIDK3jkGAhUL/A==
X-Received: by 2002:a17:907:806:b0:953:47fc:3f0b with SMTP id wv6-20020a170907080600b0095347fc3f0bmr13764935ejb.53.1683724519207;
        Wed, 10 May 2023 06:15:19 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id z11-20020a1709067e4b00b00965f6ad266bsm2656773ejr.119.2023.05.10.06.15.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 May 2023 06:15:18 -0700 (PDT)
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
In-Reply-To: <CANn89iKLSBwCnzS8TPSbkH+v_gMobFotOdCbdSMxAkhtx54xQA@mail.gmail.com>
Date: Wed, 10 May 2023 16:15:07 +0300
Cc: Ido Schimmel <idosch@idosch.org>,
 netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <32CBE6C0-DAA7-4470-96FC-628FE69BDD14@gmail.com>
References: <371A6638-8D92-4891-8DF5-C0EA4FBC1977@gmail.com>
 <ZFoeZLOZbNZPUfcg@shredder>
 <CANn89i+=gWwebCHk2qwu12qC+yXTFUqOxWTfnqbJOAFjidcYeg@mail.gmail.com>
 <A4F00E57-AB0E-4211-B9E4-225093EB101F@gmail.com>
 <CANn89iKOm2WPoemiqCsWaMXMyGf9C5xXH=NaSidPSNCpKxf_jQ@mail.gmail.com>
 <FE7CE62C-DBEB-4FE1-8ACB-C8B7DAF15710@gmail.com> <ZFqoNJqwLjaVFGaa@shredder>
 <F6300D47-506F-495B-AFAB-9077DD6D4DC8@gmail.com>
 <CANn89iKLSBwCnzS8TPSbkH+v_gMobFotOdCbdSMxAkhtx54xQA@mail.gmail.com>
To: Eric Dumazet <edumazet@google.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Ok i will try to set CONFIG_HZ to 1000 and will make tests


Thanks Eric

> On 10 May 2023, at 12:40, Eric Dumazet <edumazet@google.com> wrote:
>=20
> On Wed, May 10, 2023 at 8:06=E2=80=AFAM Martin Zaharinov =
<micron10@gmail.com> wrote:
>>=20
>> I think problem is in this part of code in net/core/dev.c
>=20
> What makes you think this ?
>=20
> msleep()  is not called a single time on my test bed.
>=20
> # perf probe -a msleep
> # cat bench.sh
> modprobe dummy 2>/dev/null
> ip link set dev dummy0 up 2>/dev/null
> for i in $(seq 2 4094); do ip link add link dummy0 name vlan$i type
> vlan id $i; done
> for i in $(seq 2 4094); do ip link set dev vlan$i up; done
> time for i in $(seq 2 4094); do ip link del link dummy0 name vlan$i
> type vlan id $i; done
>=20
> #  perf record -e probe:msleep -a -g ./bench.sh
>=20
> real 0m59.877s
> user 0m0.588s
> sys 0m7.023s
> [ perf record: Woken up 6 times to write data ]
> [ perf record: Captured and wrote 8.561 MB perf.data ]
> # perf script
> #   << empty, nothing >>
>=20
>=20
>=20
>=20
>> #define WAIT_REFS_MIN_MSECS 1
>> #define WAIT_REFS_MAX_MSECS 250
>> /**
>> * netdev_wait_allrefs_any - wait until all references are gone.
>> * @list: list of net_devices to wait on
>> *
>> * This is called when unregistering network devices.
>> *
>> * Any protocol or device that holds a reference should register
>> * for netdevice notification, and cleanup and put back the
>> * reference if they receive an UNREGISTER event.
>> * We can get stuck here if buggy protocols don't correctly
>> * call dev_put.
>> */
>> static struct net_device *netdev_wait_allrefs_any(struct list_head =
*list)
>> {
>>        unsigned long rebroadcast_time, warning_time;
>>        struct net_device *dev;
>>        int wait =3D 0;
>>=20
>>        rebroadcast_time =3D warning_time =3D jiffies;
>>=20
>>        list_for_each_entry(dev, list, todo_list)
>>                if (netdev_refcnt_read(dev) =3D=3D 1)
>>                        return dev;
>>=20
>>        while (true) {
>>                if (time_after(jiffies, rebroadcast_time + 1 * HZ)) {
>>                        rtnl_lock();
>>=20
>>                        /* Rebroadcast unregister notification */
>>                        list_for_each_entry(dev, list, todo_list)
>>                                =
call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
>>=20
>>                        __rtnl_unlock();
>>                        rcu_barrier();
>>                        rtnl_lock();
>>=20
>>                        list_for_each_entry(dev, list, todo_list)
>>                                if =
(test_bit(__LINK_STATE_LINKWATCH_PENDING,
>>                                             &dev->state)) {
>>                                        /* We must not have linkwatch =
events
>>                                         * pending on unregister. If =
this
>>                                         * happens, we simply run the =
queue
>>                                         * unscheduled, resulting in a =
noop
>>                                         * for this device.
>>                                         */
>>                                        linkwatch_run_queue();
>>                                        break;
>>                                }
>>=20
>>                        __rtnl_unlock();
>>=20
>>                        rebroadcast_time =3D jiffies;
>>                }
>>=20
>>                if (!wait) {
>>                        rcu_barrier();
>>                        wait =3D WAIT_REFS_MIN_MSECS;
>>                } else {
>>                        msleep(wait);
>>                        wait =3D min(wait << 1, WAIT_REFS_MAX_MSECS);
>>                }
>>=20
>>                list_for_each_entry(dev, list, todo_list)
>>                        if (netdev_refcnt_read(dev) =3D=3D 1)
>>                                return dev;
>>=20
>>                if (time_after(jiffies, warning_time +
>>                               =
READ_ONCE(netdev_unregister_timeout_secs) * HZ)) {
>>                        list_for_each_entry(dev, list, todo_list) {
>>                                pr_emerg("unregister_netdevice: =
waiting for %s to become free. Usage count =3D %d\n",
>>                                         dev->name, =
netdev_refcnt_read(dev));
>>                                =
ref_tracker_dir_print(&dev->refcnt_tracker, 10);
>>                        }
>>=20
>>                        warning_time =3D jiffies;
>>                }
>>        }
>> }
>>=20
>>=20
>>=20
>> m.
>>=20
>>=20
>>> On 9 May 2023, at 23:08, Ido Schimmel <idosch@idosch.org> wrote:
>>>=20
>>> On Tue, May 09, 2023 at 09:50:18PM +0300, Martin Zaharinov wrote:
>>>> i try on kernel 6.3.1
>>>>=20
>>>>=20
>>>> time for i in $(seq 2 4094); do ip link del link eth1 name vlan$i =
type vlan id $i; done
>>>>=20
>>>> real 4m51.633s  =E2=80=94=E2=80=94 here i stop with Ctrl + C  -  =
and rerun  and second part finish after 3 min
>>>> user 0m7.479s
>>>> sys 0m0.367s
>>>=20
>>> You are off-CPU most of the time, the question is what is blocking. =
I'm
>>> getting the following results with net-next:
>>>=20
>>> # time -p for i in $(seq 2 4094); do ip link del dev eth0.$i; done
>>> real 177.09
>>> user 3.85
>>> sys 31.26
>>>=20
>>> When using a batch file to perform the deletion:
>>>=20
>>> # time -p ip -b vlan_del.batch
>>> real 35.25
>>> user 0.02
>>> sys 3.61
>>>=20
>>> And to check where we are blocked most of the time while using the =
batch
>>> file:
>>>=20
>>> # ../bcc/libbpf-tools/offcputime -p `pgrep -nx ip`
>>> [...]
>>>   __schedule
>>>   schedule
>>>   schedule_timeout
>>>   wait_for_completion
>>>   rcu_barrier
>>>   netdev_run_todo
>>>   rtnetlink_rcv_msg
>>>   netlink_rcv_skb
>>>   netlink_unicast
>>>   netlink_sendmsg
>>>   ____sys_sendmsg
>>>   ___sys_sendmsg
>>>   __sys_sendmsg
>>>   do_syscall_64
>>>   entry_SYSCALL_64_after_hwframe
>>>   -                ip (3660)
>>>       25089479
>>> [...]
>>>=20
>>> We are blocked for around 70% of the time on the rcu_barrier() in
>>> netdev_run_todo().
>>>=20
>>> Note that one big difference between my setup and yours is that in =
my
>>> case eth0 is a dummy device and in your case it's probably a =
physical
>>> device that actually implements netdev_ops::ndo_vlan_rx_kill_vid(). =
If
>>> so, it's possible that a non-negligible amount of time is spent =
talking
>>> to hardware/firmware to delete the 4K VIDs from the device's VLAN
>>> filter.
>>>=20
>>>>=20
>>>>=20
>>>> Config is very clean i remove big part of CONFIG options .
>>>>=20
>>>> is there options to debug what is happen.
>>>>=20
>>>> m
>>=20


