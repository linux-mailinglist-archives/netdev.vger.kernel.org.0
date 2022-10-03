Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116155F3993
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 01:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiJCXHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 19:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiJCXHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 19:07:47 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8958275D6
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 16:07:45 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1322d768ba7so7486851fac.5
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 16:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=3BeP6oL7rlHy5eaTV0QTGQmvLkpww8I9VxSegTq3pQg=;
        b=naUtN//yWziCUYmn/z14ha+/LO9Kf98SRYA/vIavi3PoqKyNRWv2m+kLBjmum7Td/7
         Qi6H1ikc7IlEdVw2FudfMGC9rTMupBtxCV7gAlsaUCSx6aXO7p08V+z3q7C04xB7rijK
         Cb1KtZriCliheK18ScEuzOzr6ojLClngSwWCMCa7SGqRkGCYF3MEPZNudL9tPGKhQ9F1
         2WemQcvwFBRQCktSUfRLYDkTr8dEqhZhdt4jfjJuenrWYwBGY4o+oQ9bIT9b55Zv1lEH
         TJ96s4VoS6R1UMcNf5lsiiS9Af1tv5Po26zvkQnkovWLcqXjDAVsDbhft3kXghHGvD9a
         xyTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=3BeP6oL7rlHy5eaTV0QTGQmvLkpww8I9VxSegTq3pQg=;
        b=REMB8BeaQTU5LcF+kbJJkIwrgHOEm25z/wqRZNJnRgTT/SbNLUd+avaUiV7KmGW3i7
         I6utMDx2g/3oYe1iNCPuI1XnDciLRNWkJAif8dj5Llz+PCXkk7x9UPL9JS4JMugrQUQT
         iv08GSQk8/Bkq5lTIHLVlmdSsbggCCL/U613f4gDEA78B7Lar0sK3xClGHyok6l7SOZ9
         o2vUI1iBDTovGgzUp+fyhFbut1FhTHYeLWlM/i8apVsBLucWNeKNWZifTzT8gt3zApgl
         XJ2TZfYfAi3nO6nNVJnJRbrpG7q3AmT3l+qfqPnXzkgo0sPHa9Zk8+G7WVCBxDSUh0yu
         5PCg==
X-Gm-Message-State: ACrzQf2fmuyDFxJy20rHt0HS4/rteC352a+FAK20XQMpEtbA2f2LO3fB
        7oKHk6AKqI3Sw+pX31kSaiijr9LawL4H2DLrXLB2Dg==
X-Google-Smtp-Source: AMsMyM4UFeXeAQTzoEOOxB5LjBK1bc+XFzc+ZTCIhT+WSOcczjk0/xiRx/xCtma3/5d8fRxNzg9vxkND8hcgwwjN4Ms=
X-Received: by 2002:a05:6870:790:b0:131:b107:5eea with SMTP id
 en16-20020a056870079000b00131b1075eeamr6515504oab.66.1664838465177; Mon, 03
 Oct 2022 16:07:45 -0700 (PDT)
MIME-Version: 1.0
References: <1613402622-11451-1-git-send-email-stefanc@marvell.com>
 <69516f245575e5ed09b3e291bcd784e2@matoro.tk> <CAPv3WKc4LKtZoyW3ixXfhvvYeOTkNVfTSdGWWWuKZS2hmOStDQ@mail.gmail.com>
In-Reply-To: <CAPv3WKc4LKtZoyW3ixXfhvvYeOTkNVfTSdGWWWuKZS2hmOStDQ@mail.gmail.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 4 Oct 2022 01:07:34 +0200
Message-ID: <CAPv3WKcr7B7iM6eDYCmKcHQ8PTVA6q9TzjNwGoWeKHB9AE8TaQ@mail.gmail.com>
Subject: Re: [net-next] net: mvpp2: Add TX flow control support for jumbo frames
To:     matoro <matoro_mailinglist_kernel@matoro.tk>
Cc:     stefanc@marvell.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, andrew@lunn.ch, rmk+kernel@armlinux.org.uk,
        atenart@kernel.org, jon@solid-run.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pon., 3 pa=C5=BA 2022 o 10:30 Marcin Wojtas <mw@semihalf.com> napisa=C5=82(=
a):
>
> Hi,
>
> niedz., 2 pa=C5=BA 2022 o 21:25 matoro
> <matoro_mailinglist_kernel@matoro.tk> napisa=C5=82(a):
> >
> > Hi all, I know this is kind of an old change but I have got an issue
> > with this driver that might be related.  Whenever I change the MTU of
> > any interfacing using mvpp2, it immediately results in the following
> > crash.  Is this change related?  Is this a known issue with this driver=
?
> >
> > [ 1725.925804] mvpp2 f2000000.ethernet eth0: mtu 9000 too high,
> > switching to shared buffers
> > [ 1725.9258[ 1725.935611] mvpp2 f2000000.ethernet eth0: Link is Down
> > 04] mvpp2 f2000000.ethernet eth0: mtu 9000 too high, switching to share=
d
> > buffers
> > [ 17[ 1725.950079] Unable to handle kernel NULL pointer dereference at
> > virtual address 0000000000000000
> > 25.935611]  Mem abort info:
> > [33mmvpp2 f20000[ 1725.963804]   ESR =3D 0x0000000096000004
> > 00.ethernet eth0[ 1725.968960]   EC =3D 0x25: DABT (current EL), IL =3D=
 32
> > bits
> > : Link is Do[ 1725.975685]   SET =3D 0, FnV =3D 0
> > wn
> > [ 1725.980143]   EA =3D 0, S1PTW =3D 0
> > [ 1725.983643]   FSC =3D 0x04: level 0 translation fault
> > [ 1725.988539] Data abort info:
> > [ 1725.991430]   ISV =3D 0, ISS =3D 0x00000004
> > [ 1725.995279]   CM =3D 0, WnR =3D 0
> > [ 1725.998256] user pgtable: 4k pages, 48-bit VAs, pgdp=3D0000000104b83=
000
> > [ 1726.004724] [0000000000000000] pgd=3D0000000000000000,
> > p4d=3D0000000000000000
> > [ 1726.011543] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> > [ 1726.017137] Modules linked in: sfp mdio_i2c marvell mcp3021 mvmdio
> > at24 mvpp2 armada_thermal phylink sbsa_gwdt cfg80211 rfkill fuse
> > [ 1726.029032] CPU: 2 PID: 16253 Comm: ip Not tainted
> > 5.19.8-1-aarch64-ARCH #1
> > [ 1726.036024] Hardware name: SolidRun CN9130 based SOM Clearfog Base
> > (DT)
> > [ 1726.042665] pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO -DIT -SSBS
> > BTYPE=3D--)
> > [ 1726.049656] pc : mvpp2_cm3_read.isra.0+0x8/0x2c [mvpp2]
> > [ 1726.054915] lr : mvpp2_bm_pool_update_fc+0x40/0x154 [mvpp2]
> > [ 1726.060515] sp : ffff80000b17b580
> > [ 1726.063842] x29: ffff80000b17b580 x28: 0000000000000000 x27:
> > 0000000000000000
> > [ 1726.071010] x26: ffff8000013ceb60 x25: 0000000000000008 x24:
> > ffff0001054b5980
> > [ 1726.078177] x23: ffff0001021e2480 x22: 0000000000000038 x21:
> > 0000000000000000
> > [ 1726.085346] x20: ffff0001049dac80 x19: ffff0001054b4980 x18:
> > 0000000000000000
> > [ 1726.092513] x17: 0000000000000000 x16: 0000000000000000 x15:
> > 0000000000000000
> > [ 1726.099680] x14: 0000000000000109 x13: 0000000000000109 x12:
> > 0000000000000000
> > [ 1726.106847] x11: 0000000000000040 x10: ffff80000a3471b8 x9 :
> > ffff80000a3471b0
> > [ 1726.114015] x8 : ffff000100401b88 x7 : 0000000000000000 x6 :
> > 0000000000000000
> > [ 1726.121182] x5 : ffff80000b17b4e0 x4 : 0000000000000000 x3 :
> > 0000000000000000
> > [ 1726.128348] x2 : ffff0001021e2480 x1 : 0000000000000000 x0 :
> > 0000000000000000
> > [ 1726.135514] Call trace:
> > [ 1726.137968]  mvpp2_cm3_read.isra.0+0x8/0x2c [mvpp2]
> > [ 1726.142871]  mvpp2_bm_pool_update_priv_fc+0xc0/0x100 [mvpp2]
> > [ 1726.148558]  mvpp2_bm_switch_buffers.isra.0+0x1c0/0x1e0 [mvpp2]
> > [ 1726.154506]  mvpp2_change_mtu+0x184/0x264 [mvpp2]
> > [ 1726.159233]  dev_set_mtu_ext+0xdc/0x1b4
> > [ 1726.163087]  do_setlink+0x1d4/0xa90
> > [ 1726.166593]  __rtnl_newlink+0x4a8/0x4f0
> > [ 1726.170443]  rtnl_newlink+0x4c/0x80
> > [ 1726.173944]  rtnetlink_rcv_msg+0x12c/0x37c
> > [ 1726.178058]  netlink_rcv_skb+0x5c/0x130
> > [ 1726.181910]  rtnetlink_rcv+0x18/0x2c
> > [ 1726.185500]  netlink_unicast+0x2c4/0x31c
> > [ 1726.189438]  netlink_sendmsg+0x1bc/0x410
> > [ 1726.193377]  sock_sendmsg+0x54/0x60
> > [ 1726.196879]  ____sys_sendmsg+0x26c/0x290
> > [ 1726.200817]  ___sys_sendmsg+0x7c/0xc0
> > [ 1726.204494]  __sys_sendmsg+0x68/0xd0
> > [ 1726.208083]  __arm64_sys_sendmsg+0x28/0x34
> > [ 1726.212196]  invoke_syscall+0x48/0x114
> > [ 1726.215962]  el0_svc_common.constprop.0+0x44/0xec
> > [ 1726.220686]  do_el0_svc+0x28/0x34
> > [ 1726.224014]  el0_svc+0x2c/0x84
> > [ 1726.227082]  el0t_64_sync_handler+0x11c/0x150
> > [ 1726.231455]  el0t_64_sync+0x18c/0x190
> > [ 1726.235134] Code: d65f03c0 d65f03c0 d503233f 8b214000 (b9400000)
> > [ 1726.241253] ---[ end trace 0000000000000000 ]---
> > [ 1726.245888] note: ip[16253] exited with preempt_count 1
> >
>
> Thank you for the report. I will check in my setup. Please provide me
> with the log from the power on until OS prompt (it should include the
> early firmware and the full dmesg).
>

We definitely need to check the differences in our firmware/baseline.
With top of tree TF-A + EDK2, the 6.0 kernel works fine on my 2 CN913x
boards (DB and CEx7 Evaluation Board): I changed mtu back and forth
without and under maximum load (l2 forwarding, 4 flows):

# ifconfig eth0 mtu 9000
# ifconfig eth1 mtu 9000
[  757.427794] mvpp2 MRVL0110:00 eth1: mtu 9000 too high, switching to
shared buffers
[  757.449663] mvpp2 MRVL0110:00 eth1: Link is Down
[  757.527237] mvpp2 MRVL0110:00: using 3 shared buffers
[  757.552967] mvpp2 MRVL0110:00 eth1: configuring for
inband/10gbase-r link mode
[  757.568909] mvpp2 MRVL0110:00 eth1: configuring for
inband/10gbase-r link mode
[  757.576267] mvpp2 MRVL0110:00 eth1: Link is Up - 10Gbps/Full - flow
control rx/tx
#
# ifconfig eth4 mtu 9000
[  774.390814] mvpp2 MRVL0110:01 eth4: mtu 9000 too high, switching to
shared buffers
[  774.400316] mvpp2 MRVL0110:01 eth4: Link is Down
[  774.447092] mvpp2 MRVL0110:01: using 3 shared buffers
[  774.456047] mvpp2 MRVL0110:01 eth4: configuring for
inband/10gbase-r link mode
[  774.463383] mvpp2 MRVL0110:01 eth4: Link is Up - 10Gbps/Full - flow
control rx/tx
[  774.471910] mvpp2 MRVL0110:01 eth4: Link is Down
[  774.479444] mvpp2 MRVL0110:01 eth4: configuring for
inband/10gbase-r link mode
[  774.499499] mvpp2 MRVL0110:01 eth4: Link is Up - 10Gbps/Full - flow
control rx/tx
#
# ifconfig eth1
eth1      Link encap:Ethernet  HWaddr CE:16:63:FF:14:4D
          inet6 addr: fe80::cc16:63ff:feff:144d/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:9000  Metric:1
          RX packets:98227357 errors:0 dropped:0 overruns:0 frame:0
          TX packets:130164308 errors:0 dropped:5771 overruns:0 carrier:0
          collisions:0 txqueuelen:2048
          RX bytes:5893641420 (5.4 GiB)  TX bytes:7809859100 (7.2 GiB)

# ifconfig eth4
eth4      Link encap:Ethernet  HWaddr 2A:E9:F1:EB:01:02
          inet6 addr: fe80::28e9:f1ff:feeb:102/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:9000  Metric:1
          RX packets:152199964 errors:0 dropped:0 overruns:0 frame:0
          TX packets:98227386 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:2048
          RX bytes:9131997840 (8.5 GiB)  TX bytes:5893643810 (5.4 GiB)

Best regards,
Marcin
