Return-Path: <netdev+bounces-1401-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 784786FDAF8
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EB8F28125C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEFC66FD5;
	Wed, 10 May 2023 09:40:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2D020B41
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:40:58 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B2359D2
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:40:53 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f42397f41fso100555e9.1
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683711652; x=1686303652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TX5alCvzrkJuD2LWGn4chNBGuFcNwA/6OWtCWQMv8Rw=;
        b=6dQcQvDlrMYmOpX7GosMBsrslivunRB2alvZl1PZGWA7SyAgSkEI8/021k41KHIfJR
         ZVJpfZXlCg+dV+N/5/lzCez1QUWUUUKCl9i9lLl3wm1+zcy4fuHEO42KYs4u6S9tF3Sm
         xxfUCE+9TRPSNiDXUsxV+9F7v9TtybQUn5fesjIXJ0YCBu2s0Xk+NuCMFsNaHGm+n452
         18qKaonLb+eWd3inkEQhjxMxCxvS/udf3eHb4grjfcAnYJUIwSgp7aEBH1RGq7S4kBNz
         8qfJldeFnH4QZHbq7FWgLxeW94WTqirQSUFc+a4Vl/T32EsvxBNxcJzA14E+ZLlbhbEK
         8VJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683711652; x=1686303652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TX5alCvzrkJuD2LWGn4chNBGuFcNwA/6OWtCWQMv8Rw=;
        b=cIDU9ODtsh3XVzc5V4pakDW1t4lcZeZj7hlvUtet0voErYsZbjMT26mbf6NazVRc7V
         2JOdijj4N5qOUGh6YkzKFeqcsA6HGVoJm5qLqTiyMYi+9G45rciwBhCJybO+jGVTbDOq
         tbr5CP7FUdpVfeVKw9jyVuXu4Rblb6tZnaWjSt8B94n5Xf4JhPeCniIJ1TNnQ2c//VPE
         Fch7tjprTA+Vj5kj1MTJ2rQp2w8agiFVB7QXbPvi/un+G3Eaok1D50ihoc5SiZ09/8BU
         WQbRxZmdQpDbrvaHXnDlq/Rbk/sakvLZj9bSgif13t8OAWg+hC9k+s8sLo5A/HKxohlJ
         mDRQ==
X-Gm-Message-State: AC+VfDx1jgwde/ffFuV41fqVKUQK3LI9s8e9b0bciUdc8S7ZntT1gOnP
	qsmyUTJY0VYUzoC5u8GESOrwt0dzuR6k+67hphtWBg==
X-Google-Smtp-Source: ACHHUZ6Uakn9Cf59uEmujytn1J93CaOQU2dLJTgqx6GgeCO9u4vxnx0mfAkfi311JH4daEAjHlLn+WgI5MDHHfTEs3M=
X-Received: by 2002:a05:600c:3b97:b0:3f2:4fd2:e961 with SMTP id
 n23-20020a05600c3b9700b003f24fd2e961mr169328wms.0.1683711651501; Wed, 10 May
 2023 02:40:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <371A6638-8D92-4891-8DF5-C0EA4FBC1977@gmail.com>
 <ZFoeZLOZbNZPUfcg@shredder> <CANn89i+=gWwebCHk2qwu12qC+yXTFUqOxWTfnqbJOAFjidcYeg@mail.gmail.com>
 <A4F00E57-AB0E-4211-B9E4-225093EB101F@gmail.com> <CANn89iKOm2WPoemiqCsWaMXMyGf9C5xXH=NaSidPSNCpKxf_jQ@mail.gmail.com>
 <FE7CE62C-DBEB-4FE1-8ACB-C8B7DAF15710@gmail.com> <ZFqoNJqwLjaVFGaa@shredder> <F6300D47-506F-495B-AFAB-9077DD6D4DC8@gmail.com>
In-Reply-To: <F6300D47-506F-495B-AFAB-9077DD6D4DC8@gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 May 2023 11:40:39 +0200
Message-ID: <CANn89iKLSBwCnzS8TPSbkH+v_gMobFotOdCbdSMxAkhtx54xQA@mail.gmail.com>
Subject: Re: Very slow remove interface from kernel
To: Martin Zaharinov <micron10@gmail.com>
Cc: Ido Schimmel <idosch@idosch.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 8:06=E2=80=AFAM Martin Zaharinov <micron10@gmail.co=
m> wrote:
>
> I think problem is in this part of code in net/core/dev.c

What makes you think this ?

msleep()  is not called a single time on my test bed.

# perf probe -a msleep
# cat bench.sh
modprobe dummy 2>/dev/null
ip link set dev dummy0 up 2>/dev/null
for i in $(seq 2 4094); do ip link add link dummy0 name vlan$i type
vlan id $i; done
for i in $(seq 2 4094); do ip link set dev vlan$i up; done
time for i in $(seq 2 4094); do ip link del link dummy0 name vlan$i
type vlan id $i; done

#  perf record -e probe:msleep -a -g ./bench.sh

real 0m59.877s
user 0m0.588s
sys 0m7.023s
[ perf record: Woken up 6 times to write data ]
[ perf record: Captured and wrote 8.561 MB perf.data ]
# perf script
#   << empty, nothing >>




> #define WAIT_REFS_MIN_MSECS 1
> #define WAIT_REFS_MAX_MSECS 250
> /**
>  * netdev_wait_allrefs_any - wait until all references are gone.
>  * @list: list of net_devices to wait on
>  *
>  * This is called when unregistering network devices.
>  *
>  * Any protocol or device that holds a reference should register
>  * for netdevice notification, and cleanup and put back the
>  * reference if they receive an UNREGISTER event.
>  * We can get stuck here if buggy protocols don't correctly
>  * call dev_put.
>  */
> static struct net_device *netdev_wait_allrefs_any(struct list_head *list)
> {
>         unsigned long rebroadcast_time, warning_time;
>         struct net_device *dev;
>         int wait =3D 0;
>
>         rebroadcast_time =3D warning_time =3D jiffies;
>
>         list_for_each_entry(dev, list, todo_list)
>                 if (netdev_refcnt_read(dev) =3D=3D 1)
>                         return dev;
>
>         while (true) {
>                 if (time_after(jiffies, rebroadcast_time + 1 * HZ)) {
>                         rtnl_lock();
>
>                         /* Rebroadcast unregister notification */
>                         list_for_each_entry(dev, list, todo_list)
>                                 call_netdevice_notifiers(NETDEV_UNREGISTE=
R, dev);
>
>                         __rtnl_unlock();
>                         rcu_barrier();
>                         rtnl_lock();
>
>                         list_for_each_entry(dev, list, todo_list)
>                                 if (test_bit(__LINK_STATE_LINKWATCH_PENDI=
NG,
>                                              &dev->state)) {
>                                         /* We must not have linkwatch eve=
nts
>                                          * pending on unregister. If this
>                                          * happens, we simply run the que=
ue
>                                          * unscheduled, resulting in a no=
op
>                                          * for this device.
>                                          */
>                                         linkwatch_run_queue();
>                                         break;
>                                 }
>
>                         __rtnl_unlock();
>
>                         rebroadcast_time =3D jiffies;
>                 }
>
>                 if (!wait) {
>                         rcu_barrier();
>                         wait =3D WAIT_REFS_MIN_MSECS;
>                 } else {
>                         msleep(wait);
>                         wait =3D min(wait << 1, WAIT_REFS_MAX_MSECS);
>                 }
>
>                 list_for_each_entry(dev, list, todo_list)
>                         if (netdev_refcnt_read(dev) =3D=3D 1)
>                                 return dev;
>
>                 if (time_after(jiffies, warning_time +
>                                READ_ONCE(netdev_unregister_timeout_secs) =
* HZ)) {
>                         list_for_each_entry(dev, list, todo_list) {
>                                 pr_emerg("unregister_netdevice: waiting f=
or %s to become free. Usage count =3D %d\n",
>                                          dev->name, netdev_refcnt_read(de=
v));
>                                 ref_tracker_dir_print(&dev->refcnt_tracke=
r, 10);
>                         }
>
>                         warning_time =3D jiffies;
>                 }
>         }
> }
>
>
>
> m.
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

