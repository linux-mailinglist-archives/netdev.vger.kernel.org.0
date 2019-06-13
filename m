Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E2644AC7
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfFMSgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:36:16 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43298 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfFMSgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 14:36:16 -0400
Received: by mail-qk1-f194.google.com with SMTP id m14so9808qka.10
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 11:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iBOB/Ya2Vqp6fNbEvPITsCaUOQls9vyzFGMBK5yaNX4=;
        b=YK3iHW96C1CoZXfZA2hLR4Gx1qx0Mb54NgMw/Z9riqd3AFInHbJSGDOI1ape81JCs6
         F96cJ15X52gnhb0rmPWuTjMvfy8ROuenpz62FOxt81e3kvuRCW+HC4Q9tREDpv9g2Eoc
         JYjC9lzXiNf05VvJl4dqaRn+D4wk0G1NL3rl78xaqW3oI1L6Dq77Kqu+r6yksCjR6ueH
         //B363L00WssO4XCW3nxsy0xlL+yT5mVUQO6GcOhaTmsWGG6TBX2Fkyiffav3OBAUWXm
         q/N1UpNVqIxvx5648CoGPyMjralgJur4tHKFDH9bgGhedDw1Hi/9aSvkNca0+M0NMFVd
         mE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iBOB/Ya2Vqp6fNbEvPITsCaUOQls9vyzFGMBK5yaNX4=;
        b=EZtUQZZNEJVrzFkOjqK8V8Vzo9o2vGCCzgmaJSr1NvgQxSvrAxwEUzTKAKwOZQ8uX9
         T5hOMadL0MWnsTjvm+uzapbcEAvNo6adxO+BZSR/lY7UjVFIcf7hTC0NkvArEvywx30P
         GBQWDkqxVcSxCLvnfv4rskuYiFr/Tp4x6mch1g0QiurELfJ8p67l8GKpI9UQB6BizRJh
         2jC61EYEk3fyanrQdiWt7OKBcrTz5qp/KH0CDgkw8OeWm3mbzmXpMAMMgbrar03G2EDy
         iUL68maHXpot1fExtAQXdtZ4ZQD+OrQ5fJSY6GX02wvg1IOdSY0uC8+Vkx79GA3366Pt
         hEpQ==
X-Gm-Message-State: APjAAAWIe11WGSwH1myl1YWiVhYKsURbcifKZWluammNSXtjfAnGsPKY
        +iInnRqU/ugX/ravNZNm6wRcm5pEfP5LSNjjzhY=
X-Google-Smtp-Source: APXvYqzW8RjETllLSSRz8SRVhkRe0yoHVidwxpHuzSg5aFGkUlOSpVucYxs3HpxmtcgkzqzHSLM2pok3AbebK8cZwV0=
X-Received: by 2002:a05:620a:147:: with SMTP id e7mr71612762qkn.247.1560450974027;
 Thu, 13 Jun 2019 11:36:14 -0700 (PDT)
MIME-Version: 1.0
References: <156042464138.25684.15061870566905680617.stgit@alrua-x1> <156042464148.25684.11881534392137955942.stgit@alrua-x1>
In-Reply-To: <156042464148.25684.11881534392137955942.stgit@alrua-x1>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Jun 2019 11:36:03 -0700
Message-ID: <CAEf4BzaBinFfbCL+rx48Sj7gBAomM1TPU9_kutARf-RLxioWeQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/3] devmap/cpumap: Use flush list instead of bitmap
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 8:32 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> The socket map uses a linked list instead of a bitmap to keep track of
> which entries to flush. Do the same for devmap and cpumap, as this means =
we
> don't have to care about the map index when enqueueing things into the
> map (and so we can cache the map lookup).
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/cpumap.c |  106 +++++++++++++++++++++++----------------------=
------
>  kernel/bpf/devmap.c |  107 +++++++++++++++++++++++----------------------=
------
>  net/core/filter.c   |    2 -
>  3 files changed, 97 insertions(+), 118 deletions(-)
>
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index b31a71909307..a8dc49b04e9b 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -32,14 +32,19 @@
>
>  /* General idea: XDP packets getting XDP redirected to another CPU,
>   * will maximum be stored/queued for one driver ->poll() call.  It is
> - * guaranteed that setting flush bit and flush operation happen on
> + * guaranteed that queueing the frame and the flush operation happen on
>   * same CPU.  Thus, cpu_map_flush operation can deduct via this_cpu_ptr(=
)
>   * which queue in bpf_cpu_map_entry contains packets.
>   */
>
>  #define CPU_MAP_BULK_SIZE 8  /* 8 =3D=3D one cacheline on 64-bit archs *=
/
> +struct bpf_cpu_map_entry;
> +struct bpf_cpu_map;
> +
>  struct xdp_bulk_queue {
>         void *q[CPU_MAP_BULK_SIZE];
> +       struct list_head flush_node;
> +       struct bpf_cpu_map_entry *obj;
>         unsigned int count;
>  };
>
> @@ -52,6 +57,8 @@ struct bpf_cpu_map_entry {
>         /* XDP can run multiple RX-ring queues, need __percpu enqueue sto=
re */
>         struct xdp_bulk_queue __percpu *bulkq;
>
> +       struct bpf_cpu_map *cmap;
> +
>         /* Queue with potential multi-producers, and single-consumer kthr=
ead */
>         struct ptr_ring *queue;
>         struct task_struct *kthread;
> @@ -65,23 +72,17 @@ struct bpf_cpu_map {
>         struct bpf_map map;
>         /* Below members specific for map type */
>         struct bpf_cpu_map_entry **cpu_map;
> -       unsigned long __percpu *flush_needed;
> +       struct list_head __percpu *flush_list;
>  };
>
> -static int bq_flush_to_queue(struct bpf_cpu_map_entry *rcpu,
> -                            struct xdp_bulk_queue *bq, bool in_napi_ctx)=
;
> -
> -static u64 cpu_map_bitmap_size(const union bpf_attr *attr)
> -{
> -       return BITS_TO_LONGS(attr->max_entries) * sizeof(unsigned long);
> -}
> +static int bq_flush_to_queue(struct xdp_bulk_queue *bq, bool in_napi_ctx=
);
>
>  static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
>  {
>         struct bpf_cpu_map *cmap;
>         int err =3D -ENOMEM;
> +       int ret, cpu;
>         u64 cost;
> -       int ret;
>
>         if (!capable(CAP_SYS_ADMIN))
>                 return ERR_PTR(-EPERM);
> @@ -105,7 +106,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *=
attr)
>
>         /* make sure page count doesn't overflow */
>         cost =3D (u64) cmap->map.max_entries * sizeof(struct bpf_cpu_map_=
entry *);
> -       cost +=3D cpu_map_bitmap_size(attr) * num_possible_cpus();
> +       cost +=3D sizeof(struct list_head) * num_possible_cpus();
>
>         /* Notice returns -EPERM on if map size is larger than memlock li=
mit */
>         ret =3D bpf_map_charge_init(&cmap->map.memory, cost);
> @@ -114,12 +115,13 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr=
 *attr)
>                 goto free_cmap;
>         }
>
> -       /* A per cpu bitfield with a bit per possible CPU in map  */
> -       cmap->flush_needed =3D __alloc_percpu(cpu_map_bitmap_size(attr),
> -                                           __alignof__(unsigned long));
> -       if (!cmap->flush_needed)
> +       cmap->flush_list =3D alloc_percpu(struct list_head);
> +       if (!cmap->flush_list)
>                 goto free_charge;
>
> +       for_each_possible_cpu(cpu)
> +               INIT_LIST_HEAD(per_cpu_ptr(cmap->flush_list, cpu));
> +
>         /* Alloc array for possible remote "destination" CPUs */
>         cmap->cpu_map =3D bpf_map_area_alloc(cmap->map.max_entries *
>                                            sizeof(struct bpf_cpu_map_entr=
y *),
> @@ -129,7 +131,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *=
attr)
>
>         return &cmap->map;
>  free_percpu:
> -       free_percpu(cmap->flush_needed);
> +       free_percpu(cmap->flush_list);
>  free_charge:
>         bpf_map_charge_finish(&cmap->map.memory);
>  free_cmap:
> @@ -331,7 +333,8 @@ static struct bpf_cpu_map_entry *__cpu_map_entry_allo=
c(u32 qsize, u32 cpu,
>  {
>         gfp_t gfp =3D GFP_KERNEL | __GFP_NOWARN;
>         struct bpf_cpu_map_entry *rcpu;
> -       int numa, err;
> +       struct xdp_bulk_queue *bq;
> +       int numa, err, i;
>
>         /* Have map->numa_node, but choose node of redirect target CPU */
>         numa =3D cpu_to_node(cpu);
> @@ -346,6 +349,11 @@ static struct bpf_cpu_map_entry *__cpu_map_entry_all=
oc(u32 qsize, u32 cpu,
>         if (!rcpu->bulkq)
>                 goto free_rcu;
>
> +       for_each_possible_cpu(i) {
> +               bq =3D per_cpu_ptr(rcpu->bulkq, i);
> +               bq->obj =3D rcpu;
> +       }
> +
>         /* Alloc queue */
>         rcpu->queue =3D kzalloc_node(sizeof(*rcpu->queue), gfp, numa);
>         if (!rcpu->queue)
> @@ -402,7 +410,7 @@ static void __cpu_map_entry_free(struct rcu_head *rcu=
)
>                 struct xdp_bulk_queue *bq =3D per_cpu_ptr(rcpu->bulkq, cp=
u);
>
>                 /* No concurrent bq_enqueue can run at this point */
> -               bq_flush_to_queue(rcpu, bq, false);
> +               bq_flush_to_queue(bq, false);
>         }
>         free_percpu(rcpu->bulkq);
>         /* Cannot kthread_stop() here, last put free rcpu resources */
> @@ -485,6 +493,7 @@ static int cpu_map_update_elem(struct bpf_map *map, v=
oid *key, void *value,
>                 rcpu =3D __cpu_map_entry_alloc(qsize, key_cpu, map->id);
>                 if (!rcpu)
>                         return -ENOMEM;
> +               rcpu->cmap =3D cmap;
>         }
>         rcu_read_lock();
>         __cpu_map_entry_replace(cmap, key_cpu, rcpu);
> @@ -511,14 +520,14 @@ static void cpu_map_free(struct bpf_map *map)
>         synchronize_rcu();
>
>         /* To ensure all pending flush operations have completed wait for=
 flush
> -        * bitmap to indicate all flush_needed bits to be zero on _all_ c=
pus.
> -        * Because the above synchronize_rcu() ensures the map is disconn=
ected
> -        * from the program we can assume no new bits will be set.
> +        * list be empty on _all_ cpus. Because the above synchronize_rcu=
()
> +        * ensures the map is disconnected from the program we can assume=
 no new
> +        * items will be added to the list.
>          */
>         for_each_online_cpu(cpu) {
> -               unsigned long *bitmap =3D per_cpu_ptr(cmap->flush_needed,=
 cpu);
> +               struct list_head *flush_list =3D per_cpu_ptr(cmap->flush_=
list, cpu);
>
> -               while (!bitmap_empty(bitmap, cmap->map.max_entries))
> +               while (!list_empty(flush_list))
>                         cond_resched();
>         }
>
> @@ -535,7 +544,7 @@ static void cpu_map_free(struct bpf_map *map)
>                 /* bq flush and cleanup happens after RCU graze-period */
>                 __cpu_map_entry_replace(cmap, i, NULL); /* call_rcu */
>         }
> -       free_percpu(cmap->flush_needed);
> +       free_percpu(cmap->flush_list);
>         bpf_map_area_free(cmap->cpu_map);
>         kfree(cmap);
>  }
> @@ -587,9 +596,9 @@ const struct bpf_map_ops cpu_map_ops =3D {
>         .map_check_btf          =3D map_check_no_btf,
>  };
>
> -static int bq_flush_to_queue(struct bpf_cpu_map_entry *rcpu,
> -                            struct xdp_bulk_queue *bq, bool in_napi_ctx)
> +static int bq_flush_to_queue(struct xdp_bulk_queue *bq, bool in_napi_ctx=
)
>  {
> +       struct bpf_cpu_map_entry *rcpu =3D bq->obj;
>         unsigned int processed =3D 0, drops =3D 0;
>         const int to_cpu =3D rcpu->cpu;
>         struct ptr_ring *q;
> @@ -618,6 +627,9 @@ static int bq_flush_to_queue(struct bpf_cpu_map_entry=
 *rcpu,
>         bq->count =3D 0;
>         spin_unlock(&q->producer_lock);
>
> +       __list_del(bq->flush_node.prev, bq->flush_node.next);
> +       bq->flush_node.prev =3D NULL;
> +
>         /* Feedback loop via tracepoints */
>         trace_xdp_cpumap_enqueue(rcpu->map_id, processed, drops, to_cpu);
>         return 0;
> @@ -628,10 +640,11 @@ static int bq_flush_to_queue(struct bpf_cpu_map_ent=
ry *rcpu,
>   */
>  static int bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *=
xdpf)
>  {
> +       struct list_head *flush_list =3D this_cpu_ptr(rcpu->cmap->flush_l=
ist);
>         struct xdp_bulk_queue *bq =3D this_cpu_ptr(rcpu->bulkq);
>
>         if (unlikely(bq->count =3D=3D CPU_MAP_BULK_SIZE))
> -               bq_flush_to_queue(rcpu, bq, true);
> +               bq_flush_to_queue(bq, true);
>
>         /* Notice, xdp_buff/page MUST be queued here, long enough for
>          * driver to code invoking us to finished, due to driver
> @@ -643,6 +656,10 @@ static int bq_enqueue(struct bpf_cpu_map_entry *rcpu=
, struct xdp_frame *xdpf)
>          * operation, when completing napi->poll call.
>          */
>         bq->q[bq->count++] =3D xdpf;
> +
> +       if (!bq->flush_node.prev)
> +               list_add(&bq->flush_node, flush_list);
> +
>         return 0;
>  }
>
> @@ -662,41 +679,16 @@ int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu,=
 struct xdp_buff *xdp,
>         return 0;
>  }
>
> -void __cpu_map_insert_ctx(struct bpf_map *map, u32 bit)
> -{
> -       struct bpf_cpu_map *cmap =3D container_of(map, struct bpf_cpu_map=
, map);
> -       unsigned long *bitmap =3D this_cpu_ptr(cmap->flush_needed);
> -
> -       __set_bit(bit, bitmap);
> -}
> -
>  void __cpu_map_flush(struct bpf_map *map)
>  {
>         struct bpf_cpu_map *cmap =3D container_of(map, struct bpf_cpu_map=
, map);
> -       unsigned long *bitmap =3D this_cpu_ptr(cmap->flush_needed);
> -       u32 bit;
> -
> -       /* The napi->poll softirq makes sure __cpu_map_insert_ctx()
> -        * and __cpu_map_flush() happen on same CPU. Thus, the percpu
> -        * bitmap indicate which percpu bulkq have packets.
> -        */
> -       for_each_set_bit(bit, bitmap, map->max_entries) {
> -               struct bpf_cpu_map_entry *rcpu =3D READ_ONCE(cmap->cpu_ma=
p[bit]);
> -               struct xdp_bulk_queue *bq;
> -
> -               /* This is possible if entry is removed by user space
> -                * between xdp redirect and flush op.
> -                */
> -               if (unlikely(!rcpu))
> -                       continue;
> -
> -               __clear_bit(bit, bitmap);
> +       struct list_head *flush_list =3D this_cpu_ptr(cmap->flush_list);
> +       struct xdp_bulk_queue *bq, *tmp;
>
> -               /* Flush all frames in bulkq to real queue */
> -               bq =3D this_cpu_ptr(rcpu->bulkq);
> -               bq_flush_to_queue(rcpu, bq, true);
> +       list_for_each_entry_safe(bq, tmp, flush_list, flush_node) {
> +               bq_flush_to_queue(bq, true);
>
>                 /* If already running, costs spin_lock_irqsave + smb_mb *=
/
> -               wake_up_process(rcpu->kthread);
> +               wake_up_process(bq->obj->kthread);
>         }
>  }
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 5ae7cce5ef16..5cb04a198139 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -25,9 +25,8 @@
>   * datapath always has a valid copy. However, the datapath does a "flush=
"
>   * operation that pushes any pending packets in the driver outside the R=
CU
>   * critical section. Each bpf_dtab_netdev tracks these pending operation=
s using
> - * an atomic per-cpu bitmap. The bpf_dtab_netdev object will not be dest=
royed
> - * until all bits are cleared indicating outstanding flush operations ha=
ve
> - * completed.
> + * a per-cpu flush list. The bpf_dtab_netdev object will not be destroye=
d  until
> + * this list is empty, indicating outstanding flush operations have comp=
leted.
>   *
>   * BPF syscalls may race with BPF program calls on any of the update, de=
lete
>   * or lookup operations. As noted above the xchg() operation also keep t=
he
> @@ -56,9 +55,13 @@
>         (BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY)
>
>  #define DEV_MAP_BULK_SIZE 16
> +struct bpf_dtab_netdev;
> +
>  struct xdp_bulk_queue {
>         struct xdp_frame *q[DEV_MAP_BULK_SIZE];
> +       struct list_head flush_node;
>         struct net_device *dev_rx;
> +       struct bpf_dtab_netdev *obj;
>         unsigned int count;
>  };
>
> @@ -73,23 +76,19 @@ struct bpf_dtab_netdev {
>  struct bpf_dtab {
>         struct bpf_map map;
>         struct bpf_dtab_netdev **netdev_map;
> -       unsigned long __percpu *flush_needed;
> +       struct list_head __percpu *flush_list;
>         struct list_head list;
>  };
>
>  static DEFINE_SPINLOCK(dev_map_lock);
>  static LIST_HEAD(dev_map_list);
>
> -static u64 dev_map_bitmap_size(const union bpf_attr *attr)
> -{
> -       return BITS_TO_LONGS((u64) attr->max_entries) * sizeof(unsigned l=
ong);
> -}
> -
>  static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
>  {
>         struct bpf_dtab *dtab;
>         int err =3D -EINVAL;
>         u64 cost;
> +       int cpu;
>
>         if (!capable(CAP_NET_ADMIN))
>                 return ERR_PTR(-EPERM);
> @@ -107,7 +106,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *=
attr)
>
>         /* make sure page count doesn't overflow */
>         cost =3D (u64) dtab->map.max_entries * sizeof(struct bpf_dtab_net=
dev *);
> -       cost +=3D dev_map_bitmap_size(attr) * num_possible_cpus();
> +       cost +=3D sizeof(struct list_head) * num_possible_cpus();
>
>         /* if map size is larger than memlock limit, reject it */
>         err =3D bpf_map_charge_init(&dtab->map.memory, cost);
> @@ -116,28 +115,30 @@ static struct bpf_map *dev_map_alloc(union bpf_attr=
 *attr)
>
>         err =3D -ENOMEM;
>
> -       /* A per cpu bitfield with a bit per possible net device */
> -       dtab->flush_needed =3D __alloc_percpu_gfp(dev_map_bitmap_size(att=
r),
> -                                               __alignof__(unsigned long=
),
> -                                               GFP_KERNEL | __GFP_NOWARN=
);
> -       if (!dtab->flush_needed)
> +       dtab->flush_list =3D alloc_percpu(struct list_head);
> +       if (!dtab->flush_list)
>                 goto free_charge;
>
> +       for_each_possible_cpu(cpu)
> +               INIT_LIST_HEAD(per_cpu_ptr(dtab->flush_list, cpu));
> +
>         dtab->netdev_map =3D bpf_map_area_alloc(dtab->map.max_entries *
>                                               sizeof(struct bpf_dtab_netd=
ev *),
>                                               dtab->map.numa_node);
>         if (!dtab->netdev_map)
> -               goto free_charge;
> +               goto free_percpu;
>
>         spin_lock(&dev_map_lock);
>         list_add_tail_rcu(&dtab->list, &dev_map_list);
>         spin_unlock(&dev_map_lock);
>
>         return &dtab->map;
> +
> +free_percpu:
> +       free_percpu(dtab->flush_list);
>  free_charge:
>         bpf_map_charge_finish(&dtab->map.memory);
>  free_dtab:
> -       free_percpu(dtab->flush_needed);
>         kfree(dtab);
>         return ERR_PTR(err);
>  }
> @@ -166,14 +167,14 @@ static void dev_map_free(struct bpf_map *map)
>         rcu_barrier();
>
>         /* To ensure all pending flush operations have completed wait for=
 flush
> -        * bitmap to indicate all flush_needed bits to be zero on _all_ c=
pus.
> +        * list to empty on _all_ cpus.
>          * Because the above synchronize_rcu() ensures the map is disconn=
ected
> -        * from the program we can assume no new bits will be set.
> +        * from the program we can assume no new items will be added.
>          */
>         for_each_online_cpu(cpu) {
> -               unsigned long *bitmap =3D per_cpu_ptr(dtab->flush_needed,=
 cpu);
> +               struct list_head *flush_list =3D per_cpu_ptr(dtab->flush_=
list, cpu);
>
> -               while (!bitmap_empty(bitmap, dtab->map.max_entries))
> +               while (!list_empty(flush_list))
>                         cond_resched();
>         }
>
> @@ -188,7 +189,7 @@ static void dev_map_free(struct bpf_map *map)
>                 kfree(dev);
>         }
>
> -       free_percpu(dtab->flush_needed);
> +       free_percpu(dtab->flush_list);
>         bpf_map_area_free(dtab->netdev_map);
>         kfree(dtab);
>  }
> @@ -210,18 +211,10 @@ static int dev_map_get_next_key(struct bpf_map *map=
, void *key, void *next_key)
>         return 0;
>  }
>
> -void __dev_map_insert_ctx(struct bpf_map *map, u32 bit)
> -{
> -       struct bpf_dtab *dtab =3D container_of(map, struct bpf_dtab, map)=
;
> -       unsigned long *bitmap =3D this_cpu_ptr(dtab->flush_needed);
> -
> -       __set_bit(bit, bitmap);
> -}
> -
> -static int bq_xmit_all(struct bpf_dtab_netdev *obj,
> -                      struct xdp_bulk_queue *bq, u32 flags,
> +static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags,
>                        bool in_napi_ctx)
>  {
> +       struct bpf_dtab_netdev *obj =3D bq->obj;
>         struct net_device *dev =3D obj->dev;
>         int sent =3D 0, drops =3D 0, err =3D 0;
>         int i;
> @@ -248,6 +241,8 @@ static int bq_xmit_all(struct bpf_dtab_netdev *obj,
>         trace_xdp_devmap_xmit(&obj->dtab->map, obj->bit,
>                               sent, drops, bq->dev_rx, dev, err);
>         bq->dev_rx =3D NULL;
> +       __list_del(bq->flush_node.prev, bq->flush_node.next);
> +       bq->flush_node.prev =3D NULL;
>         return 0;
>  error:
>         /* If ndo_xdp_xmit fails with an errno, no frames have been
> @@ -270,30 +265,17 @@ static int bq_xmit_all(struct bpf_dtab_netdev *obj,
>   * from the driver before returning from its napi->poll() routine. The p=
oll()
>   * routine is called either from busy_poll context or net_rx_action sign=
aled
>   * from NET_RX_SOFTIRQ. Either way the poll routine must complete before=
 the
> - * net device can be torn down. On devmap tear down we ensure the ctx bi=
tmap
> - * is zeroed before completing to ensure all flush operations have compl=
eted.
> + * net device can be torn down. On devmap tear down we ensure the flush =
list
> + * is empty before completing to ensure all flush operations have comple=
ted.
>   */
>  void __dev_map_flush(struct bpf_map *map)
>  {
>         struct bpf_dtab *dtab =3D container_of(map, struct bpf_dtab, map)=
;
> -       unsigned long *bitmap =3D this_cpu_ptr(dtab->flush_needed);
> -       u32 bit;
> -
> -       for_each_set_bit(bit, bitmap, map->max_entries) {
> -               struct bpf_dtab_netdev *dev =3D READ_ONCE(dtab->netdev_ma=
p[bit]);
> -               struct xdp_bulk_queue *bq;
> +       struct list_head *flush_list =3D this_cpu_ptr(dtab->flush_list);
> +       struct xdp_bulk_queue *bq, *tmp;
>
> -               /* This is possible if the dev entry is removed by user s=
pace
> -                * between xdp redirect and flush op.
> -                */
> -               if (unlikely(!dev))
> -                       continue;
> -
> -               __clear_bit(bit, bitmap);
> -
> -               bq =3D this_cpu_ptr(dev->bulkq);
> -               bq_xmit_all(dev, bq, XDP_XMIT_FLUSH, true);
> -       }
> +       list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
> +               bq_xmit_all(bq, XDP_XMIT_FLUSH, true);
>  }
>
>  /* rcu_read_lock (from syscall and BPF contexts) ensures that if a delet=
e and/or
> @@ -319,10 +301,11 @@ static int bq_enqueue(struct bpf_dtab_netdev *obj, =
struct xdp_frame *xdpf,
>                       struct net_device *dev_rx)
>
>  {
> +       struct list_head *flush_list =3D this_cpu_ptr(obj->dtab->flush_li=
st);
>         struct xdp_bulk_queue *bq =3D this_cpu_ptr(obj->bulkq);
>
>         if (unlikely(bq->count =3D=3D DEV_MAP_BULK_SIZE))
> -               bq_xmit_all(obj, bq, 0, true);
> +               bq_xmit_all(bq, 0, true);
>
>         /* Ingress dev_rx will be the same for all xdp_frame's in
>          * bulk_queue, because bq stored per-CPU and must be flushed
> @@ -332,6 +315,10 @@ static int bq_enqueue(struct bpf_dtab_netdev *obj, s=
truct xdp_frame *xdpf,
>                 bq->dev_rx =3D dev_rx;
>
>         bq->q[bq->count++] =3D xdpf;
> +
> +       if (!bq->flush_node.prev)
> +               list_add(&bq->flush_node, flush_list);
> +
>         return 0;
>  }
>
> @@ -382,16 +369,11 @@ static void dev_map_flush_old(struct bpf_dtab_netde=
v *dev)
>  {
>         if (dev->dev->netdev_ops->ndo_xdp_xmit) {
>                 struct xdp_bulk_queue *bq;
> -               unsigned long *bitmap;
> -
>                 int cpu;
>
>                 for_each_online_cpu(cpu) {
> -                       bitmap =3D per_cpu_ptr(dev->dtab->flush_needed, c=
pu);
> -                       __clear_bit(dev->bit, bitmap);
> -
>                         bq =3D per_cpu_ptr(dev->bulkq, cpu);
> -                       bq_xmit_all(dev, bq, XDP_XMIT_FLUSH, false);
> +                       bq_xmit_all(bq, XDP_XMIT_FLUSH, false);
>                 }
>         }
>  }
> @@ -437,8 +419,10 @@ static int dev_map_update_elem(struct bpf_map *map, =
void *key, void *value,
>         struct net *net =3D current->nsproxy->net_ns;
>         gfp_t gfp =3D GFP_ATOMIC | __GFP_NOWARN;
>         struct bpf_dtab_netdev *dev, *old_dev;
> -       u32 i =3D *(u32 *)key;
>         u32 ifindex =3D *(u32 *)value;
> +       struct xdp_bulk_queue *bq;
> +       u32 i =3D *(u32 *)key;
> +       int cpu;
>
>         if (unlikely(map_flags > BPF_EXIST))
>                 return -EINVAL;
> @@ -461,6 +445,11 @@ static int dev_map_update_elem(struct bpf_map *map, =
void *key, void *value,
>                         return -ENOMEM;
>                 }
>
> +               for_each_possible_cpu(cpu) {
> +                       bq =3D per_cpu_ptr(dev->bulkq, cpu);
> +                       bq->obj =3D dev;
> +               }
> +
>                 dev->dev =3D dev_get_by_index(net, ifindex);
>                 if (!dev->dev) {
>                         free_percpu(dev->bulkq);
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 55bfc941d17a..7a996887c500 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3526,7 +3526,6 @@ static int __bpf_tx_xdp_map(struct net_device *dev_=
rx, void *fwd,
>                 err =3D dev_map_enqueue(dst, xdp, dev_rx);
>                 if (unlikely(err))
>                         return err;
> -               __dev_map_insert_ctx(map, index);
>                 break;
>         }
>         case BPF_MAP_TYPE_CPUMAP: {
> @@ -3535,7 +3534,6 @@ static int __bpf_tx_xdp_map(struct net_device *dev_=
rx, void *fwd,
>                 err =3D cpu_map_enqueue(rcpu, xdp, dev_rx);
>                 if (unlikely(err))
>                         return err;
> -               __cpu_map_insert_ctx(map, index);
>                 break;
>         }
>         case BPF_MAP_TYPE_XSKMAP: {
>
