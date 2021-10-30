Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B81440871
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 13:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhJ3LDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 07:03:25 -0400
Received: from mout.gmx.net ([212.227.15.19]:42625 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231810AbhJ3LDY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 07:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1635591623;
        bh=Sso8wu+v9wINI+4QOvDqQTS1ctlLeyRDNcCfedRHNgA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:References;
        b=FBJA0hMA+h0HNy1Zol/Qvmpg9nFnhYrYrWCopWgvMFTXAdvq2okApv32qZbFcn6Po
         774AQ+n9ufgN2VF68dVjMgjhEzeTKUJ0fzB9Mw2P36214SrsJVccXHmqD5DekztgQE
         oeHXfX9Nn6onwkWg+JWmnY2z3qDfSdPMIfi2zqWk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.156.239] ([217.61.156.239]) by web-mail.gmx.net
 (3c-app-gmx-bs28.server.lan [172.19.170.80]) (via HTTP); Sat, 30 Oct 2021
 13:00:23 +0200
MIME-Version: 1.0
Message-ID: <trinity-9f00fd01-211f-41ba-9905-c3cbf9587b5b-1635591623134@3c-app-gmx-bs28>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [mt76] BUG: WARN_ONCE using mt7615/mt7622 in Mesh-mode
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 30 Oct 2021 13:00:23 +0200
Importance: normal
Sensitivity: Normal
References: <trinity-3fbfd53f-2547-4ff3-ab99-f0dc752c6b08-1634836529437@3c-app-gmx-bap12>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:ZztNrl3TBkdi3+0i+1UfIG8jIepSbfs7+bCmIkt0WYHWYkIIpxS60vSmjL2wMZLccvS62
 EIG+E5ZKhK4eGU1R9cXjH1igM4/WnDxC3qjBjU2W6lNtn/HfKF9ao8hjbxT9YhTLYKPeftS/3lqI
 tSWNzpZHxv3RWtCuePaMSt2wcPWdUyJEcLVuIaYw7E3uoeXPb+zqMF8gePGnJ9MNirk+LALr+one
 iRRPMyT4gz8FtsgD06ci0+tezUbjWG20EyDH3CunzMZdvswwU4Gt0LXKsCHt7bc1kDKBG2Dfll9k
 2g=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:l+66smc/Bvc=:CUxc8JGh8L5+I2u0oy6C2g
 fXR9y47eOB0f/SjZQPkT5xqXwKucOMjt/dJc4r6YRvEr9vcPB6TIlr/Iona9ZbU6seC5yk9UG
 JaH3JQGp41MCpQf5KeLIqbGHrzh/cCTNTaKlD/E9MzYF9f8L+VWteqzbbS7EyibNt1y7kryCJ
 RI6khqW2ZywBksiZFGZntDmOZqB7Q5b28tYavbZUlqNOvzNSjP/aVqCVRmwd8AafqQM4K9ewG
 WnGq5x4mBTBS8IIxvTSbThZBwGnkFAOI/jXkVsxUNj05v3+d7xjwZ31GJrO7BvfGTRKkailpr
 zC0xPtMGHuv64HLDq/LGFBM8tZffw6LW5ZgTxZGIvxl8+DW0f9QpBAKbQZ9vz/W2zVZ6IuliP
 K1cARU1rnBNls+n/udxgzQEwSkAm98OzxQEI8IJFVcjv0Qj4Ee1BMPD98U4zYboehYnId7qMY
 LhC9b9r18808raBr4yb4LPH3CA2Z0a1uGwRWu5LvLCbowFnxYfHm9TRyLGdd6aMO6sZqQSIIq
 e5w8NHfDYO6dviFeEGVjXd8WM0+9h5EMQTrEBDRxaYvOKouM5tdFh9YMp9wrFmGXdLkfw9oYs
 ppMNqwUeL7QYM9SRHFxvV3mNu/EhjbhqRdDVM/4zKGBNvode0RY2u6kpP0+xm8Wx8L12xaU+j
 nyAyuokGdOX8464i3JzOG1xHkbNgkwVb6dZiFpk2oGCFkae0IK2Wi3WMwu0EZ4WqTKQ9PTc4B
 DpdktJ+kkqglyj0O/fN8D9UTBYQoUBPaGd7CoyMUIBsUITl0b1FsLUe5/JEreV+7aG+Ribe1r
 XVM6ijM
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

i got a Kernel-Warning when using mt7615/mt7622 (mt7915 also reported, but=
 not tested by me yet) in Mesh-Mode:

[ 1009.473796] ------------[ cut here ]------------
[ 1009.478485] WARNING: CPU: 1 PID: 288 at net/core/flow_dissector.c:984 _=
_skb_4
[ 1009.487735] Modules linked in: xt_CHECKSUM nft_chain_nat xt_MASQUERADE =
nf_nas
[ 1009.517477] CPU: 1 PID: 288 Comm: napi/phy0-19 Not tainted 5.15.0-rc4-b=
pi-r21
[ 1009.524803] Hardware name: Mediatek Cortex-A7 (Device Tree)
[ 1009.530384] Backtrace:
[ 1009.532838] [<c0cb3878>] (dump_backtrace) from [<c0cb3ac0>] (show_stack=
+0x20)
[ 1009.540431]  r7:000003d8 r6:c0a22cf8 r5:60010013 r4:c1012ecc
[ 1009.546090] [<c0cb3aa0>] (show_stack) from [<c0cb7870>] (dump_stack_lvl=
+0x48)
[ 1009.553673] [<c0cb7828>] (dump_stack_lvl) from [<c0cb7894>] (dump_stack=
+0x18)
[ 1009.561258]  r5:00000009 r4:c10db094
[ 1009.564839] [<c0cb787c>] (dump_stack) from [<c0127350>] (__warn+0xfc/0x=
114)
[ 1009.571822] [<c0127254>] (__warn) from [<c0cb4118>] (warn_slowpath_fmt+=
0x74/)
[ 1009.579328]  r7:c0a22cf8 r6:000003d8 r5:c10db094 r4:00000000
[ 1009.584988] [<c0cb40a8>] (warn_slowpath_fmt) from [<c0a22cf8>] (__skb_f=
low_d)
[ 1009.593799]  r8:00000000 r7:c5c40418 r6:c5d8dd00 r5:c1306360 r4:c5adcc0=
0
[ 1009.600502] [<c0a22afc>] (__skb_flow_dissect) from [<c0a24258>] (__skb_=
get_h)
[ 1009.608878]  r10:c5a6c520 r9:c7329264 r8:00000074 r7:00000001 r6:c73286=
00 r50
[ 1009.616713]  r4:c1439b78
[ 1009.619246] [<c0a241d4>] (__skb_get_hash) from [<bf1adf24>] (ieee80211_=
queue)
[ 1009.629519]  r6:c7328600 r5:c5adcc00 r4:c5a6c520
[ 1009.634140] [<bf1ada20>] (ieee80211_queue_skb [mac80211]) from [<bf1ae1=
8c>] )
[ 1009.645154]  r10:c5a6c520 r9:c5a6c520 r8:00000074 r7:00000001 r6:c73286=
00 r50
[ 1009.652995]  r4:c5adcc00
[ 1009.655530] [<bf1ae094>] (ieee80211_tx [mac80211]) from [<bf1af9e8>] (i=
eee80)
[ 1009.666705]  r9:00000000 r8:00000000 r7:c5a6ca3c r6:c7328600 r5:c5a6cb8=
4 r4:0
[ 1009.674454] [<bf1af910>] (ieee80211_tx_pending [mac80211]) from [<c012f=
384>])
[ 1009.685943]  r10:c5d8c000 r9:00000040 r8:00000006 r7:00000000 r6:dedaa2=
ec r54
[ 1009.693780]  r4:c5a6cc84
[ 1009.696313] [<c012f2c4>] (tasklet_action_common.constprop.0) from [<c01=
2f3c0)
[ 1009.705908]  r9:00000040 r8:00000101 r7:c14583e0 r6:00000006 r5:0000000=
7 r4:8
[ 1009.713655] [<c012f398>] (tasklet_action) from [<c0101460>] (__do_softi=
rq+0x)
[ 1009.721591] [<c0101318>] (__do_softirq) from [<c012ee00>] (do_softirq+0=
x7c/0)
[ 1009.729014]  r10:c5f95820 r9:c5d8c000 r8:c10db338 r7:00000001 r6:c0a35f=
60 r50
[ 1009.736850]  r4:60010013
[ 1009.739383] [<c012ed84>] (do_softirq) from [<c012eedc>] (__local_bh_ena=
ble_i)
[ 1009.747495]  r5:ffffe000 r4:00000001
[ 1009.751070] [<c012ee04>] (__local_bh_enable_ip) from [<c0a35f8c>] (napi=
_thre)
[ 1009.759966]  r5:c5a6e768 r4:c5d8c000
[ 1009.763541] [<c0a35ed0>] (napi_threaded_poll) from [<c014f010>] (kthrea=
d+0x1)
[ 1009.771394]  r8:c5a6e768 r7:c0a35ed0 r6:c253ba6c r5:c5f95800 r4:c5fd6d4=
0
[ 1009.778096] [<c014eeb8>] (kthread) from [<c0100130>] (ret_from_fork+0x1=
4/0x2)
[ 1009.785333] Exception stack(0xc5d8dfb0 to 0xc5d8dff8)
[ 1009.790390] dfa0:                                     ???????? ????????=
 ?????
[ 1009.798575] dfc0: ???????? ???????? ???????? ???????? ???????? ????????=
 ?????
[ 1009.806760] dfe0: ???????? ???????? ???????? ???????? ???????? ????????
[ 1009.813383]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:000000=
00 r58
[ 1009.821220]  r4:c5fd6d40 r3:00000017
[ 1009.824871] ---[ end trace 86a4ea831c8189bf ]---


i have applied this Patch to get mesh basicly working (ping works - only t=
his warning shows up):

https://patchwork.kernel.org/project/linux-wireless/patch/20211007225725.2=
615-1-vincent@systemli.org/#24506297

configuration is basicly this:

iw phy phy0 interface add mesh0 type mp
ip addr add 192.168.80.1/24 dev mesh0
./wpa_supplicant -i mesh0 -c /etc/wpa_supplicant/meshpoint.conf &

where config is this:

user_mpm=3D1
network=3D{
	ssid=3D"bpi-mesh"
	mode=3D5
	frequency=3D2412
	key_mgmt=3DNONE
}

as far as i have debugged it happens here:

https://github.com/frank-w/BPI-R2-4.14/blob/b61ad126d9da67a52fa395215dc3a4=
219ff58121/net/core/flow_dissector.c#L984

all 3 possible sources of net are NULL when this happens

[  104.656046] DEBUG: Passed __skb_flow_dissect 975 skb:0xc5ad9540 net:0x0
[  104.662738] DEBUG: Passed __skb_flow_dissect 977 skb-dev:0x0,skb-sk:0x0

possible flow as far as i've debugged (most in flow_dissector.c):

__skb_get_hash() =3D> ___skb_get_hash() =3D> skb_flow_dissect_flow_keys() =
(include/linux/skbuff.h) =3D> __skb_flow_dissect(NULL, skb,...)

so net have to be always taken from the skb, either from skb->dev or skb->=
sk, both are NULL, so i need to know where the problematic skb is created

from trace i do not see where net/skb-dev is set :(

based on some similar bugs i've found i tried to change this in drivers/ne=
t/wireless/mediatek/mt76/mcu.c mt76_mcu_msg_alloc:

-       skb =3D alloc_skb(length, GFP_KERNEL);
+       skb =3D netdev_alloc_skb(&dev->napi_dev,length);

without success.

crash happens on first device when connection is established, on second wh=
en starting ping (which works)

i got Information that this trace is not there in openwrt master, but have=
 not yet found out why.

more infos here:
https://forum.banana-pi.org/t/solved-bpi-r64-mesh-802-11s-on-internal-wifi=
-card-mt7622av/12610/51?u=3Dfrank-w

have anyone an idea why this happens and how to fix it?

regards Frank
