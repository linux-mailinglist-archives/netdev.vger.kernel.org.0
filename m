Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 575A4105182
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 12:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfKULg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 06:36:28 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44392 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726293AbfKULg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 06:36:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574336186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aQgCg9r/2dGUecDTxLpk5eHc+IzUOk9xvu+4L1ToBKI=;
        b=WqPmEeLCSC2XOVjbtFe+JTxmN6D28MDuwuCBKIH5chqHwnhBAilYBM8NHRhMS0oIV5GXex
        //3YhMOqejY8u0L/hdjPkT+S8/m2Tb/JQw+UtDHVmsHu1IB82eQwXxG94eIP6ZQrSThxxY
        8i3iupVX0v2a4usfpeZe+cP8SRqEhpw=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-yqA8MhotPiKm05RZy-cmlw-1; Thu, 21 Nov 2019 06:36:23 -0500
Received: by mail-lf1-f70.google.com with SMTP id x16so835731lfe.19
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 03:36:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AI3Lz+fe3tgGnmZzp6UnbNwKZ/HmZt3MkWV/7daYNmM=;
        b=skJO+njL0d5E7gDByHB70325gIJ6qUfQwPurxbSfyxK2aHJU7Zod8L5DwqHIJ13DNt
         cv97Y4MHogEXgnpzBhz3PKD7EsTE0iBL1xl4m2vU2fP0L7KvEpQ5OL7fB2mHXvUVb6+i
         njozSZa8HsaeePk9fw5Kx0pkVP7G6VhvWuPD1O2VWX2UP/v/l30cyezglISoKg7LmnNg
         +06FNfS1mVVff6884z2OVbkoXsHrdQU1XTcpCEMhSEz6sKI762RIMKsTUP2PqSgiHZ2B
         hSA+VkPkXvDDC41Nsk/pR3RtnHjn2pi1Z5JwPWB6Jor4n2Ogf7X6PcLX/wBfJ10po9sw
         U/SQ==
X-Gm-Message-State: APjAAAXQ2u2dwYzRNWxC/xbZEPc8NTV2kRhMpoDXV0KIoHaL37gTy6wy
        CEKoizZjrZgw3/CNhoRM9mEonUsbenhT2M5q6UmQcBt9OjVXB8bLLsaXTxN5ygSONQWlkm4OMXm
        faeZ8LvS+VPLmHC1s
X-Received: by 2002:a05:651c:1109:: with SMTP id d9mr6850545ljo.192.1574336181659;
        Thu, 21 Nov 2019 03:36:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqyClpgq0ySxcdbFUXrT7LPszdsXz5qIxbI3zgOlx7KT5l17QqYRjdek47VQoA5ZLEvRq1gdpQ==
X-Received: by 2002:a05:651c:1109:: with SMTP id d9mr6850524ljo.192.1574336181425;
        Thu, 21 Nov 2019 03:36:21 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id d4sm1213174lfi.32.2019.11.21.03.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 03:36:19 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0D9681818B9; Thu, 21 Nov 2019 12:36:19 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        ddstreet@ieee.org, Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
In-Reply-To: <6f69f704-b51d-c3cb-02c6-8e6eb93f4194@i-love.sakura.ne.jp>
References: <00000000000056268e05737dcb95@google.com> <0000000000007d22100573d66078@google.com> <063a57ba-7723-6513-043e-ee99c5797271@I-love.SAKURA.ne.jp> <CAADnVQJ7BZMVSt9on4updWrWsFWq6b5J1qEGwTdGYV+BLqH7tg@mail.gmail.com> <87imopgere.fsf@toke.dk> <6f69f704-b51d-c3cb-02c6-8e6eb93f4194@i-love.sakura.ne.jp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 21 Nov 2019 12:36:18 +0100
Message-ID: <87r2217971.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: yqA8MhotPiKm05RZy-cmlw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> writes:

> Hello.
>
> syzbot is still reporting that bpf(BPF_MAP_UPDATE_ELEM) causes
> unregister_netdevice() to hang. It seems that commit 546ac1ffb70d25b5
> ("bpf: add devmap, a map for storing net device references") assigned
> dtab->netdev_map[i] at dev_map_update_elem() but commit 6f9d451ab1a33728
> ("xdp: Add devmap_hash map type for looking up devices by hashed index")
> forgot to assign dtab->netdev_map[idx] at __dev_map_hash_update_elem()
> when dev is newly allocated by __dev_map_alloc_node(). As far as I and
> syzbot tested, https://syzkaller.appspot.com/x/patch.diff?x=3D140dd206e00=
000
> can avoid the problem, but I don't know whether this is right location to
> assign it. Please check and fix.

Hi Tetsuo

Sorry for missing this email last week :(

I think the issue is not a missing update of dtab->netdev_map (that is
not used at all for DEVMAP_HASH), but rather that dev_map_free() is not
cleaning up properly for DEVMAP_HASH types. Could you please check if
the patch below helps?

-Toke

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 3867864cdc2f..42ccfcb38424 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -74,7 +74,7 @@ struct bpf_dtab_netdev {
=20
 struct bpf_dtab {
 =09struct bpf_map map;
-=09struct bpf_dtab_netdev **netdev_map;
+=09struct bpf_dtab_netdev **netdev_map; /* DEVMAP type only */
 =09struct list_head __percpu *flush_list;
 =09struct list_head list;
=20
@@ -101,6 +101,12 @@ static struct hlist_head *dev_map_create_hash(unsigned=
 int entries)
 =09return hash;
 }
=20
+static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
+=09=09=09=09=09=09    int idx)
+{
+=09return &dtab->dev_index_head[idx & (dtab->n_buckets - 1)];
+}
+
 static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 {
 =09int err, cpu;
@@ -143,24 +149,22 @@ static int dev_map_init_map(struct bpf_dtab *dtab, un=
ion bpf_attr *attr)
 =09for_each_possible_cpu(cpu)
 =09=09INIT_LIST_HEAD(per_cpu_ptr(dtab->flush_list, cpu));
=20
-=09dtab->netdev_map =3D bpf_map_area_alloc(dtab->map.max_entries *
-=09=09=09=09=09      sizeof(struct bpf_dtab_netdev *),
-=09=09=09=09=09      dtab->map.numa_node);
-=09if (!dtab->netdev_map)
-=09=09goto free_percpu;
-
 =09if (attr->map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH) {
 =09=09dtab->dev_index_head =3D dev_map_create_hash(dtab->n_buckets);
 =09=09if (!dtab->dev_index_head)
-=09=09=09goto free_map_area;
+=09=09=09goto free_percpu;
=20
 =09=09spin_lock_init(&dtab->index_lock);
+=09} else {
+=09=09dtab->netdev_map =3D bpf_map_area_alloc(dtab->map.max_entries *
+=09=09=09=09=09=09      sizeof(struct bpf_dtab_netdev *),
+=09=09=09=09=09=09      dtab->map.numa_node);
+=09=09if (!dtab->netdev_map)
+=09=09=09goto free_percpu;
 =09}
=20
 =09return 0;
=20
-free_map_area:
-=09bpf_map_area_free(dtab->netdev_map);
 free_percpu:
 =09free_percpu(dtab->flush_list);
 free_charge:
@@ -228,21 +232,40 @@ static void dev_map_free(struct bpf_map *map)
 =09=09=09cond_resched();
 =09}
=20
-=09for (i =3D 0; i < dtab->map.max_entries; i++) {
-=09=09struct bpf_dtab_netdev *dev;
+=09if (dtab->map.map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH) {
+=09=09for (i =3D 0; i < dtab->n_buckets; i++) {
+=09=09=09struct bpf_dtab_netdev *dev;
+=09=09=09struct hlist_head *head;
+=09=09=09struct hlist_node *next;
=20
-=09=09dev =3D dtab->netdev_map[i];
-=09=09if (!dev)
-=09=09=09continue;
+=09=09=09head =3D dev_map_index_hash(dtab, i);
=20
-=09=09free_percpu(dev->bulkq);
-=09=09dev_put(dev->dev);
-=09=09kfree(dev);
+=09=09=09hlist_for_each_entry_safe(dev, next, head, index_hlist) {
+=09=09=09=09hlist_del_rcu(&dev->index_hlist);
+=09=09=09=09free_percpu(dev->bulkq);
+=09=09=09=09dev_put(dev->dev);
+=09=09=09=09kfree(dev);
+=09=09=09}
+=09=09}
+
+=09=09kfree(dtab->dev_index_head);
+=09} else {
+=09=09for (i =3D 0; i < dtab->map.max_entries; i++) {
+=09=09=09struct bpf_dtab_netdev *dev;
+
+=09=09=09dev =3D dtab->netdev_map[i];
+=09=09=09if (!dev)
+=09=09=09=09continue;
+
+=09=09=09free_percpu(dev->bulkq);
+=09=09=09dev_put(dev->dev);
+=09=09=09kfree(dev);
+=09=09}
+
+=09=09bpf_map_area_free(dtab->netdev_map);
 =09}
=20
 =09free_percpu(dtab->flush_list);
-=09bpf_map_area_free(dtab->netdev_map);
-=09kfree(dtab->dev_index_head);
 =09kfree(dtab);
 }
=20
@@ -263,12 +286,6 @@ static int dev_map_get_next_key(struct bpf_map *map, v=
oid *key, void *next_key)
 =09return 0;
 }
=20
-static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
-=09=09=09=09=09=09    int idx)
-{
-=09return &dtab->dev_index_head[idx & (dtab->n_buckets - 1)];
-}
-
 struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u3=
2 key)
 {
 =09struct bpf_dtab *dtab =3D container_of(map, struct bpf_dtab, map);

