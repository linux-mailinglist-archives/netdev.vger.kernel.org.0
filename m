Return-Path: <netdev+bounces-5251-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D89AD7106B5
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:51:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 684731C20E55
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9640BE78;
	Thu, 25 May 2023 07:50:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D89BE6A
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:50:59 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9C48F
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 00:50:57 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-51446bdfb77so332320a12.1
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 00:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685001056; x=1687593056;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a7QV07IZ64hn9uM4fMtaZ5LqHDUJ7j/1En86BJb2+yU=;
        b=FG1gYR06FKzsF0ArIFEjin2iQaQFwhehCykNcxNQNvQKUHa68kxVNUpKhhFFWw2UcY
         BT366yt4rSdaGBTcfK/uoXT3lp4b5B1pZPl3Kkpfx5MsvOkEa/oSDlJHWbjJIxCUtWeD
         L37f1Qo4KohjKwgYQlIuWh75LeYicJ0HrVHcld825oEsJxjY47Lmo7VdAaXBGzcSDLfN
         XdHfmJ+qY39JTs621r8mwju64jFmJk9nqhutMbvTYyrPaytl5HO7Labc6SufM0k9N8OP
         O2u1YHg1ZQY3Gf1aUgAR9NAClPROMBQ7pMVL3dvACUBbQORHDOvAnfkxac23D85OAsLp
         CaZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685001056; x=1687593056;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a7QV07IZ64hn9uM4fMtaZ5LqHDUJ7j/1En86BJb2+yU=;
        b=S6+s/OTnyZZojDLxxn28YsFUD+1ZnjgsqTgMwpJ0M3BzSBhR0nx2N5ABgQhgAFSqcP
         AvCPBTpKmw2FjZbgOf3kO2g3i8a1qqsaGQXVo+tceLzsoFP7vUn52KL9IpOz4UDcrOkv
         h9LvaVF2Sj29Ra/0f8eUVqKXn1xJjcMWNel6d9wqxpPOEnoou+kyqRmavdvz4zuEyBz0
         q7r0mn76CYy04AMsjBureCHf4KEB0lohc1Xby8FZ4YtJX4JZr/XkWhkxJLgMgrMrGQ8r
         pFRIOdyrZQY8ppZGI8xbpF9GRC8DhelGJEEo7LsBEw/WEtCJOPT7b+Vpl0NRvEIPKKkO
         7Xqg==
X-Gm-Message-State: AC+VfDyrHKflTFuW4AKGGWrswvQv6PJ2lC7yP2Cr7SEPLY1ER10wTDGW
	P1PxocPOainzY0Q3eyBXfhA4vDU0YTs=
X-Google-Smtp-Source: ACHHUZ52sj17I/+UwxvTJ2uQFTHL3YPzykyZJ/oEOMQb6L9OF7hlR1j5RbgtxZszgmbOGasTSfhXbA==
X-Received: by 2002:a17:907:da3:b0:96f:678:d2e2 with SMTP id go35-20020a1709070da300b0096f0678d2e2mr790451ejc.11.1685001055810;
        Thu, 25 May 2023 00:50:55 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090686c900b00965e68b8df5sm482799ejy.76.2023.05.25.00.50.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 May 2023 00:50:55 -0700 (PDT)
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
Date: Thu, 25 May 2023 10:50:44 +0300
Cc: Ido Schimmel <idosch@idosch.org>,
 netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D1743DF0-79B9-44C4-900C-22159B65CE59@gmail.com>
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

Hi Eric=20
after switch to HZ 1666 reduce time to 30 sec for remove 4093 vlans .

Do you think there will be a problem?

Best regards,
martin

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


