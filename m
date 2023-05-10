Return-Path: <netdev+bounces-1331-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE0216FD678
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:06:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 963852813C7
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 06:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3970567B;
	Wed, 10 May 2023 06:06:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA6A5677
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 06:06:34 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0102740F7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 23:06:32 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-50bc456cc39so10228053a12.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 23:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683698791; x=1686290791;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1OVCffNKLh37p/IsLwSd6cfXC6i/v+KdPLYGVKYjYI=;
        b=GQOABI4e7cA/nRC5wqGQam0M7HtrMGrbWU2PZgJGCKr9F3uQH9Tff3Clacfbro7WMt
         AQlfOaU55P1oSEy2hCm82FUiTb154Q6+W5geBRXOpdBoLI1Fj+0tpHlREP6CA0PaQGja
         c98qgQG4n0rxuP4ZSwojqvWz+YYfhDf0j27PlWQ6VGL1u+ZsBnTpxfz6g7jcJ8KNiHyU
         7dlY6W9otcANorrDC2g4jwzQSmAystc1yy6YdlcYpQXZ1zf5tE61gXKuU0aBIfMEf08d
         hpmCZ3/TiAw3uJQpVZPGTIyuX6datwZ4rk4As7NJzV3QOHWvpQ4NIfGHGv4b24XN8SME
         44nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683698791; x=1686290791;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T1OVCffNKLh37p/IsLwSd6cfXC6i/v+KdPLYGVKYjYI=;
        b=RFr84LxHFyt5IrQM8ubt3ndiNsZKb7myHFFQNoJNHK0vWaI8XQ6J9nRGvyl6R8u0xg
         cCTuKSNUebb5rM5xxmFiOGVWPCKGG/LT+XDe1h6RRsf0X6mZbZP4t7OJo5vUH1UldbLg
         owdI7o8tB6LYDd3xTY/NVqkMMe27MZfsI84dYYzhp6XU6UkxtcsBaqWRNQKS/HyFTCoK
         fR90Iw/oySKjW7W4kUrkSAYx7tLU3CHYpIXkVTiCUv8WbZiSbaxcTJVBqlF1X+H0xurZ
         bLX5FukC3oybKVZqsosea7oL5TzPAQ0RFKjeeLS5M/orLK52sew6WrUSQ1SrrYAO66Zt
         Fh7Q==
X-Gm-Message-State: AC+VfDyHvmgM7eC2E5fq8nLMmgLEop0jAPN54Z+Ujwz2o58e2EQQe07+
	DwA4IZcP8QeD6Lb0wBl2QAw=
X-Google-Smtp-Source: ACHHUZ4yiYWHFmCKdES2ClxSljs9ASyWpudtmxYUgGCP1PZDgexJtNqVyrQSrUOizeQWvNg1VsNj4g==
X-Received: by 2002:a05:6402:51:b0:50d:bd2e:6dfa with SMTP id f17-20020a056402005100b0050dbd2e6dfamr2733076edu.17.1683698791194;
        Tue, 09 May 2023 23:06:31 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id g14-20020aa7c58e000000b005067d089aafsm1495577edq.11.2023.05.09.23.06.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 May 2023 23:06:30 -0700 (PDT)
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
Date: Wed, 10 May 2023 09:06:19 +0300
Cc: Eric Dumazet <edumazet@google.com>,
 netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F6300D47-506F-495B-AFAB-9077DD6D4DC8@gmail.com>
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

I think problem is in this part of code in net/core/dev.c



#define WAIT_REFS_MIN_MSECS 1
#define WAIT_REFS_MAX_MSECS 250
/**
 * netdev_wait_allrefs_any - wait until all references are gone.
 * @list: list of net_devices to wait on
 *
 * This is called when unregistering network devices.
 *
 * Any protocol or device that holds a reference should register
 * for netdevice notification, and cleanup and put back the
 * reference if they receive an UNREGISTER event.
 * We can get stuck here if buggy protocols don't correctly
 * call dev_put.
 */
static struct net_device *netdev_wait_allrefs_any(struct list_head =
*list)
{
        unsigned long rebroadcast_time, warning_time;
        struct net_device *dev;
        int wait =3D 0;

        rebroadcast_time =3D warning_time =3D jiffies;

        list_for_each_entry(dev, list, todo_list)
                if (netdev_refcnt_read(dev) =3D=3D 1)
                        return dev;

        while (true) {
                if (time_after(jiffies, rebroadcast_time + 1 * HZ)) {
                        rtnl_lock();

                        /* Rebroadcast unregister notification */
                        list_for_each_entry(dev, list, todo_list)
                                =
call_netdevice_notifiers(NETDEV_UNREGISTER, dev);

                        __rtnl_unlock();
                        rcu_barrier();
                        rtnl_lock();

                        list_for_each_entry(dev, list, todo_list)
                                if =
(test_bit(__LINK_STATE_LINKWATCH_PENDING,
                                             &dev->state)) {
                                        /* We must not have linkwatch =
events
                                         * pending on unregister. If =
this
                                         * happens, we simply run the =
queue
                                         * unscheduled, resulting in a =
noop
                                         * for this device.
                                         */
                                        linkwatch_run_queue();
                                        break;
                                }

                        __rtnl_unlock();

                        rebroadcast_time =3D jiffies;
                }

                if (!wait) {
                        rcu_barrier();
                        wait =3D WAIT_REFS_MIN_MSECS;
                } else {
                        msleep(wait);
                        wait =3D min(wait << 1, WAIT_REFS_MAX_MSECS);
                }

                list_for_each_entry(dev, list, todo_list)
                        if (netdev_refcnt_read(dev) =3D=3D 1)
                                return dev;

                if (time_after(jiffies, warning_time +
                               READ_ONCE(netdev_unregister_timeout_secs) =
* HZ)) {
                        list_for_each_entry(dev, list, todo_list) {
                                pr_emerg("unregister_netdevice: waiting =
for %s to become free. Usage count =3D %d\n",
                                         dev->name, =
netdev_refcnt_read(dev));
                                =
ref_tracker_dir_print(&dev->refcnt_tracker, 10);
                        }

                        warning_time =3D jiffies;
                }
        }
}



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


