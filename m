Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58902637979
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 13:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiKXM6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 07:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiKXM6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 07:58:08 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E0488B60;
        Thu, 24 Nov 2022 04:58:05 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id l39-20020a05600c1d2700b003cf93c8156dso1186281wms.4;
        Thu, 24 Nov 2022 04:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NUKXTRGWkZvy33LWexufhZpcbTxeI8565DJ+o09pLwU=;
        b=US4JzUz1rJ15fOTpsVOIFFvz2Q7pLsp2fMKhwe1Yhv/0x7jVEOGAjkVIxo4DGRcCN5
         9ROb/WZdYAJsh+QbReHXOxRfl++Poblc39VuIxFBr763blDgNLNY4rJP5q//y/4fwGGE
         kso6EMWEdItljLQShmxpQ8CN+sr47TORcCnwvOZNnDu8uNemKLDwbYsmoajXAPlFHjZT
         bh9XVv01bPIt3jemjtLuTT/H3wFocOFryXqJJAPWRIKGS9Za1vzhAjtPWzq9maRobweB
         YTUpfLNsN2fXPr829F9R2Qblsykm4FrtS7m1fOZkBtEzCfH5Rqv/ST7Qo/gCfuvjOyc3
         WvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NUKXTRGWkZvy33LWexufhZpcbTxeI8565DJ+o09pLwU=;
        b=PgFUtxn8XMusLTkWgNJhJEiyb6I6Dohr+OpM18p0RQUwIW43gwjy8yscMPbzCxFSDh
         PeltQrEiWWtauvg9FT5Wn80LthHp+s8aCdUO97VcNK8KfLmpZgpYYc+OqvrFc0MSMr0Z
         6az2+MKQC0uYv+OKNeXnG3P2bwX7U6/QMd89iq1w5sqIkMBiNDu1dQATJ+mXdjualJJY
         3ocA/81UXmYbmOyBXBtM42SkGju2m8bvdTDJvkMhsr9qx4RxbTHdpaIirL3mUQNw71u6
         1Mnafi0pruzuq32dHxbYqVY39TEibtC/UdnVm6PNHn84uMDEmXlblNYyYg+bkrLW7oMI
         h9/Q==
X-Gm-Message-State: ANoB5plFX3LtdCDtVPt+UY6HXbAbcbKFsePWYYKGa2BoZ2HErjplna2l
        vZB7q2WWbRs/T/0G5/7kF03EZ3TXbt9qQc8PP9FqG+WsLE0=
X-Google-Smtp-Source: AA0mqf4yEpdFnK+0gDlvcTcfYZPiAtsUqb4EOeK9BAe7y0n8viNx/p9GGChearvg+kqKlxxXWjCvIJmNU0M59b/yjfc=
X-Received: by 2002:a05:600c:4f45:b0:3cf:9be3:8d26 with SMTP id
 m5-20020a05600c4f4500b003cf9be38d26mr15753786wmq.185.1669294683640; Thu, 24
 Nov 2022 04:58:03 -0800 (PST)
MIME-Version: 1.0
References: <20221121100521.56601-1-xiangxia.m.yue@gmail.com>
 <20221121100521.56601-2-xiangxia.m.yue@gmail.com> <7ed2f531-79a3-61fe-f1c2-b004b752c3f7@huawei.com>
 <CAMDZJNUiPOcnpNg8tM4xCoJABJz_3=AaXLTm5ofQg64mGDkB_A@mail.gmail.com>
 <9278cf3f-dfb6-78eb-8862-553545dac7ed@huawei.com> <41eda0ea-0ed4-1ffb-5520-06fda08e5d38@huawei.com>
In-Reply-To: <41eda0ea-0ed4-1ffb-5520-06fda08e5d38@huawei.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 24 Nov 2022 20:57:25 +0800
Message-ID: <CAMDZJNVSv3Msxw=5PRiXyO8bxNsA-4KyxU8BMCVyHxH-3iuq2Q@mail.gmail.com>
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
To:     Hou Tao <houtao1@huawei.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 12:06 PM Hou Tao <houtao1@huawei.com> wrote:
>
> Hi,
>
> On 11/22/2022 12:01 PM, Hou Tao wrote:
> > Hi,
> >
> > On 11/22/2022 11:12 AM, Tonghao Zhang wrote:
> >> .
> >>
> >> On Tue, Nov 22, 2022 at 9:16 AM Hou Tao <houtao1@huawei.com> wrote:
> >>> Hi,
> >>>
> >>> On 11/21/2022 6:05 PM, xiangxia.m.yue@gmail.com wrote:
> >>>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >>>>
> >>>> The commit 20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked"),
> >>>> try to fix deadlock, but in some case, the deadlock occurs:
> >>>>
> >>>> * CPUn in task context with K1, and taking lock.
> >>>> * CPUn interrupted by NMI context, with K2.
> >>>> * They are using the same bucket, but different map_locked.
> >>> It is possible when n_buckets is less than HASHTAB_MAP_LOCK_COUNT (e.g.,
> >>> n_bucket=4). If using hash & min(HASHTAB_MAP_LOCK_MASK, n_bucket - 1) as the
> >>> index of map_locked, I think the deadlock will be gone.
> >> Yes, but for saving memory, HASHTAB_MAP_LOCK_MASK should not be too
> >> large(now this value is 8-1).
> >> if user define n_bucket ,e.g 8192, the part of bucket only are
> >> selected via hash & min(HASHTAB_MAP_LOCK_MASK, n_bucket - 1).
> I don't mean to extend map_locked. Using hash & min(HASHTAB_MAP_LOCK_MASK,
> n_bucket - 1) as index of map_locked  can guarantee the same map_locked will be
> used if different update processes are using the same bucket lock.
Thanks, I got it. but I tried it using the hash = hash &
min(HASHTAB_MAP_LOCK_MASK, htab->n_buckets -1) in
htab_lock_bucket/htab_unlock_bucket.
But the warning occur again.
  > > SNIP
> >>>> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> >>>> index 22855d6ff6d3..429acd97c869 100644
> >>>> --- a/kernel/bpf/hashtab.c
> >>>> +++ b/kernel/bpf/hashtab.c
> >>>> @@ -80,9 +80,6 @@ struct bucket {
> >>>>       raw_spinlock_t raw_lock;
> >>>>  };
> >>>>
> >>>> -#define HASHTAB_MAP_LOCK_COUNT 8
> >>>> -#define HASHTAB_MAP_LOCK_MASK (HASHTAB_MAP_LOCK_COUNT - 1)
> >>>> -
> >>>>  struct bpf_htab {
> >>>>       struct bpf_map map;
> >>>>       struct bpf_mem_alloc ma;
> >>>> @@ -104,7 +101,6 @@ struct bpf_htab {
> >>>>       u32 elem_size;  /* size of each element in bytes */
> >>>>       u32 hashrnd;
> >>>>       struct lock_class_key lockdep_key;
> >>>> -     int __percpu *map_locked[HASHTAB_MAP_LOCK_COUNT];
> >>>>  };
> >>>>
> >>>>  /* each htab element is struct htab_elem + key + value */
> >>>> @@ -146,35 +142,26 @@ static void htab_init_buckets(struct bpf_htab *htab)
> >>>>       }
> >>>>  }
> >>>>
> >>>> -static inline int htab_lock_bucket(const struct bpf_htab *htab,
> >>>> -                                struct bucket *b, u32 hash,
> >>>> +static inline int htab_lock_bucket(struct bucket *b,
> >>>>                                  unsigned long *pflags)
> >>>>  {
> >>>>       unsigned long flags;
> >>>>
> >>>> -     hash = hash & HASHTAB_MAP_LOCK_MASK;
> >>>> -
> >>>> -     preempt_disable();
> >>>> -     if (unlikely(__this_cpu_inc_return(*(htab->map_locked[hash])) != 1)) {
> >>>> -             __this_cpu_dec(*(htab->map_locked[hash]));
> >>>> -             preempt_enable();
> >>>> -             return -EBUSY;
> >>>> +     if (in_nmi()) {
> >>>> +             if (!raw_spin_trylock_irqsave(&b->raw_lock, flags))
> >>>> +                     return -EBUSY;
> >>>> +     } else {
> >>>> +             raw_spin_lock_irqsave(&b->raw_lock, flags);
> >>>>       }
> >>>>
> >>>> -     raw_spin_lock_irqsave(&b->raw_lock, flags);
> >>>>       *pflags = flags;
> >>>> -
> >>>>       return 0;
> >>>>  }
> >>> map_locked is also used to prevent the re-entrance of htab_lock_bucket() on the
> >>> same CPU, so only check in_nmi() is not enough.
> >> NMI, IRQ, and preempt may interrupt the task context.
> >> In htab_lock_bucket, raw_spin_lock_irqsave disable the preempt and
> >> irq. so only NMI may interrupt the codes, right ?
> > The re-entrance here means the nesting of bpf programs as show below:
> >
> > bpf_prog A
> > update map X
> >     htab_lock_bucket
> >         raw_spin_lock_irqsave()
> >     lookup_elem_raw()
> >         // bpf prog B is attached on lookup_elem_raw()
I am confused, bpf_prog A disables preempt and irq with
raw_spin_lock_irqsave. Why bpf prog B run here?
> >         bpf prog B
> >             update map X again and update the element
> >                 htab_lock_bucket()
> >                     // dead-lock
> >                     raw_spinlock_irqsave()
> > .
> >
> >>>> -static inline void htab_unlock_bucket(const struct bpf_htab *htab,
> >>>> -                                   struct bucket *b, u32 hash,
> >>>> +static inline void htab_unlock_bucket(struct bucket *b,
> >>>>                                     unsigned long flags)
> >>>>  {
> >>>> -     hash = hash & HASHTAB_MAP_LOCK_MASK;
> >>>>       raw_spin_unlock_irqrestore(&b->raw_lock, flags);
> >>>> -     __this_cpu_dec(*(htab->map_locked[hash]));
> >>>> -     preempt_enable();
> >>>>  }
> >>>>
> >>>>  static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node);
> >>>> @@ -467,7 +454,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
> >>>>       bool percpu_lru = (attr->map_flags & BPF_F_NO_COMMON_LRU);
> >>>>       bool prealloc = !(attr->map_flags & BPF_F_NO_PREALLOC);
> >>>>       struct bpf_htab *htab;
> >>>> -     int err, i;
> >>>> +     int err;
> >>>>
> >>>>       htab = bpf_map_area_alloc(sizeof(*htab), NUMA_NO_NODE);
> >>>>       if (!htab)
> >>>> @@ -513,15 +500,6 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
> >>>>       if (!htab->buckets)
> >>>>               goto free_htab;
> >>>>
> >>>> -     for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++) {
> >>>> -             htab->map_locked[i] = bpf_map_alloc_percpu(&htab->map,
> >>>> -                                                        sizeof(int),
> >>>> -                                                        sizeof(int),
> >>>> -                                                        GFP_USER);
> >>>> -             if (!htab->map_locked[i])
> >>>> -                     goto free_map_locked;
> >>>> -     }
> >>>> -
> >>>>       if (htab->map.map_flags & BPF_F_ZERO_SEED)
> >>>>               htab->hashrnd = 0;
> >>>>       else
> >>>> @@ -549,13 +527,13 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
> >>>>       if (htab->use_percpu_counter) {
> >>>>               err = percpu_counter_init(&htab->pcount, 0, GFP_KERNEL);
> >>>>               if (err)
> >>>> -                     goto free_map_locked;
> >>>> +                     goto free_buckets;
> >>>>       }
> >>>>
> >>>>       if (prealloc) {
> >>>>               err = prealloc_init(htab);
> >>>>               if (err)
> >>>> -                     goto free_map_locked;
> >>>> +                     goto free_buckets;
> >>>>
> >>>>               if (!percpu && !lru) {
> >>>>                       /* lru itself can remove the least used element, so
> >>>> @@ -568,12 +546,12 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
> >>>>       } else {
> >>>>               err = bpf_mem_alloc_init(&htab->ma, htab->elem_size, false);
> >>>>               if (err)
> >>>> -                     goto free_map_locked;
> >>>> +                     goto free_buckets;
> >>>>               if (percpu) {
> >>>>                       err = bpf_mem_alloc_init(&htab->pcpu_ma,
> >>>>                                                round_up(htab->map.value_size, 8), true);
> >>>>                       if (err)
> >>>> -                             goto free_map_locked;
> >>>> +                             goto free_buckets;
> >>>>               }
> >>>>       }
> >>>>
> >>>> @@ -581,11 +559,10 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
> >>>>
> >>>>  free_prealloc:
> >>>>       prealloc_destroy(htab);
> >>>> -free_map_locked:
> >>>> +free_buckets:
> >>>>       if (htab->use_percpu_counter)
> >>>>               percpu_counter_destroy(&htab->pcount);
> >>>> -     for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
> >>>> -             free_percpu(htab->map_locked[i]);
> >>>> +
> >>>>       bpf_map_area_free(htab->buckets);
> >>>>       bpf_mem_alloc_destroy(&htab->pcpu_ma);
> >>>>       bpf_mem_alloc_destroy(&htab->ma);
> >>>> @@ -782,7 +759,7 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
> >>>>       b = __select_bucket(htab, tgt_l->hash);
> >>>>       head = &b->head;
> >>>>
> >>>> -     ret = htab_lock_bucket(htab, b, tgt_l->hash, &flags);
> >>>> +     ret = htab_lock_bucket(b, &flags);
> >>>>       if (ret)
> >>>>               return false;
> >>>>
> >>>> @@ -793,7 +770,7 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
> >>>>                       break;
> >>>>               }
> >>>>
> >>>> -     htab_unlock_bucket(htab, b, tgt_l->hash, flags);
> >>>> +     htab_unlock_bucket(b, flags);
> >>>>
> >>>>       return l == tgt_l;
> >>>>  }
> >>>> @@ -1107,7 +1084,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
> >>>>                */
> >>>>       }
> >>>>
> >>>> -     ret = htab_lock_bucket(htab, b, hash, &flags);
> >>>> +     ret = htab_lock_bucket(b, &flags);
> >>>>       if (ret)
> >>>>               return ret;
> >>>>
> >>>> @@ -1152,7 +1129,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
> >>>>       }
> >>>>       ret = 0;
> >>>>  err:
> >>>> -     htab_unlock_bucket(htab, b, hash, flags);
> >>>> +     htab_unlock_bucket(b, flags);
> >>>>       return ret;
> >>>>  }
> >>>>
> >>>> @@ -1198,7 +1175,7 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
> >>>>       copy_map_value(&htab->map,
> >>>>                      l_new->key + round_up(map->key_size, 8), value);
> >>>>
> >>>> -     ret = htab_lock_bucket(htab, b, hash, &flags);
> >>>> +     ret = htab_lock_bucket(b, &flags);
> >>>>       if (ret)
> >>>>               return ret;
> >>>>
> >>>> @@ -1219,7 +1196,7 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
> >>>>       ret = 0;
> >>>>
> >>>>  err:
> >>>> -     htab_unlock_bucket(htab, b, hash, flags);
> >>>> +     htab_unlock_bucket(b, flags);
> >>>>
> >>>>       if (ret)
> >>>>               htab_lru_push_free(htab, l_new);
> >>>> @@ -1255,7 +1232,7 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
> >>>>       b = __select_bucket(htab, hash);
> >>>>       head = &b->head;
> >>>>
> >>>> -     ret = htab_lock_bucket(htab, b, hash, &flags);
> >>>> +     ret = htab_lock_bucket(b, &flags);
> >>>>       if (ret)
> >>>>               return ret;
> >>>>
> >>>> @@ -1280,7 +1257,7 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
> >>>>       }
> >>>>       ret = 0;
> >>>>  err:
> >>>> -     htab_unlock_bucket(htab, b, hash, flags);
> >>>> +     htab_unlock_bucket(b, flags);
> >>>>       return ret;
> >>>>  }
> >>>>
> >>>> @@ -1321,7 +1298,7 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
> >>>>                       return -ENOMEM;
> >>>>       }
> >>>>
> >>>> -     ret = htab_lock_bucket(htab, b, hash, &flags);
> >>>> +     ret = htab_lock_bucket(b, &flags);
> >>>>       if (ret)
> >>>>               return ret;
> >>>>
> >>>> @@ -1345,7 +1322,7 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
> >>>>       }
> >>>>       ret = 0;
> >>>>  err:
> >>>> -     htab_unlock_bucket(htab, b, hash, flags);
> >>>> +     htab_unlock_bucket(b, flags);
> >>>>       if (l_new)
> >>>>               bpf_lru_push_free(&htab->lru, &l_new->lru_node);
> >>>>       return ret;
> >>>> @@ -1384,7 +1361,7 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
> >>>>       b = __select_bucket(htab, hash);
> >>>>       head = &b->head;
> >>>>
> >>>> -     ret = htab_lock_bucket(htab, b, hash, &flags);
> >>>> +     ret = htab_lock_bucket(b, &flags);
> >>>>       if (ret)
> >>>>               return ret;
> >>>>
> >>>> @@ -1397,7 +1374,7 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
> >>>>               ret = -ENOENT;
> >>>>       }
> >>>>
> >>>> -     htab_unlock_bucket(htab, b, hash, flags);
> >>>> +     htab_unlock_bucket(b, flags);
> >>>>       return ret;
> >>>>  }
> >>>>
> >>>> @@ -1420,7 +1397,7 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
> >>>>       b = __select_bucket(htab, hash);
> >>>>       head = &b->head;
> >>>>
> >>>> -     ret = htab_lock_bucket(htab, b, hash, &flags);
> >>>> +     ret = htab_lock_bucket(b, &flags);
> >>>>       if (ret)
> >>>>               return ret;
> >>>>
> >>>> @@ -1431,7 +1408,7 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
> >>>>       else
> >>>>               ret = -ENOENT;
> >>>>
> >>>> -     htab_unlock_bucket(htab, b, hash, flags);
> >>>> +     htab_unlock_bucket(b, flags);
> >>>>       if (l)
> >>>>               htab_lru_push_free(htab, l);
> >>>>       return ret;
> >>>> @@ -1494,7 +1471,6 @@ static void htab_map_free_timers(struct bpf_map *map)
> >>>>  static void htab_map_free(struct bpf_map *map)
> >>>>  {
> >>>>       struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> >>>> -     int i;
> >>>>
> >>>>       /* bpf_free_used_maps() or close(map_fd) will trigger this map_free callback.
> >>>>        * bpf_free_used_maps() is called after bpf prog is no longer executing.
> >>>> @@ -1517,10 +1493,10 @@ static void htab_map_free(struct bpf_map *map)
> >>>>       bpf_map_area_free(htab->buckets);
> >>>>       bpf_mem_alloc_destroy(&htab->pcpu_ma);
> >>>>       bpf_mem_alloc_destroy(&htab->ma);
> >>>> +
> >>>>       if (htab->use_percpu_counter)
> >>>>               percpu_counter_destroy(&htab->pcount);
> >>>> -     for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
> >>>> -             free_percpu(htab->map_locked[i]);
> >>>> +
> >>>>       lockdep_unregister_key(&htab->lockdep_key);
> >>>>       bpf_map_area_free(htab);
> >>>>  }
> >>>> @@ -1564,7 +1540,7 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
> >>>>       b = __select_bucket(htab, hash);
> >>>>       head = &b->head;
> >>>>
> >>>> -     ret = htab_lock_bucket(htab, b, hash, &bflags);
> >>>> +     ret = htab_lock_bucket(b, &bflags);
> >>>>       if (ret)
> >>>>               return ret;
> >>>>
> >>>> @@ -1602,7 +1578,7 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
> >>>>                       free_htab_elem(htab, l);
> >>>>       }
> >>>>
> >>>> -     htab_unlock_bucket(htab, b, hash, bflags);
> >>>> +     htab_unlock_bucket(b, bflags);
> >>>>
> >>>>       if (is_lru_map && l)
> >>>>               htab_lru_push_free(htab, l);
> >>>> @@ -1720,7 +1696,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
> >>>>       head = &b->head;
> >>>>       /* do not grab the lock unless need it (bucket_cnt > 0). */
> >>>>       if (locked) {
> >>>> -             ret = htab_lock_bucket(htab, b, batch, &flags);
> >>>> +             ret = htab_lock_bucket(b, &flags);
> >>>>               if (ret) {
> >>>>                       rcu_read_unlock();
> >>>>                       bpf_enable_instrumentation();
> >>>> @@ -1743,7 +1719,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
> >>>>               /* Note that since bucket_cnt > 0 here, it is implicit
> >>>>                * that the locked was grabbed, so release it.
> >>>>                */
> >>>> -             htab_unlock_bucket(htab, b, batch, flags);
> >>>> +             htab_unlock_bucket(b, flags);
> >>>>               rcu_read_unlock();
> >>>>               bpf_enable_instrumentation();
> >>>>               goto after_loop;
> >>>> @@ -1754,7 +1730,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
> >>>>               /* Note that since bucket_cnt > 0 here, it is implicit
> >>>>                * that the locked was grabbed, so release it.
> >>>>                */
> >>>> -             htab_unlock_bucket(htab, b, batch, flags);
> >>>> +             htab_unlock_bucket(b, flags);
> >>>>               rcu_read_unlock();
> >>>>               bpf_enable_instrumentation();
> >>>>               kvfree(keys);
> >>>> @@ -1815,7 +1791,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
> >>>>               dst_val += value_size;
> >>>>       }
> >>>>
> >>>> -     htab_unlock_bucket(htab, b, batch, flags);
> >>>> +     htab_unlock_bucket(b, flags);
> >>>>       locked = false;
> >>>>
> >>>>       while (node_to_free) {
> > .
>


-- 
Best regards, Tonghao
