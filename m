Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 636EB132D13
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 18:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgAGRcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 12:32:43 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:41907 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728325AbgAGRcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 12:32:42 -0500
Received: by mail-il1-f194.google.com with SMTP id f10so257125ils.8;
        Tue, 07 Jan 2020 09:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=5/kHjCEs62h1faHWfCUdOVVEQSiVDI+7+0pArTEC4Tw=;
        b=MlAN7OTONzWQICMe80rTKHut2UQJGNNOPyx8Wclo+BBy4pXRERNHznOw1BU84DIJ4g
         0gEzBFT06FwqdvUkDI0f7Mptq3axi242xZt+UNQGPrRp0ayDF5ujQxaiT7Jjr9+aLTfJ
         Y1BqVaBeydVK1vLBFA0Ss+Sz4UgHbVpLHkCWu7YhPqdX249JcjR1FGgVMis+Ih/RKx/f
         JFBOyY1aFfFjTjzwEbUSQ0RD08rH894GcWS3m/NUDBnx4m+YzjKztH0Y/O5w+7v5mC68
         RhxV91GNH8d5s5YHAli5lYChBGfnAlJ+Lq1zbVjJERR1eoU/tlABtVTRwYmFTH6y9XJT
         FSyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=5/kHjCEs62h1faHWfCUdOVVEQSiVDI+7+0pArTEC4Tw=;
        b=qBNtUYhJp04xVmsQD5Qxxdb3oEmb4MUW7+eFtl+QVliBBubCFCeGPCiTGm6B8sWBaq
         d9fWqvIeCL1Ywvv257BQeQ74FjT3j/OkTzyWE2NjztoRBubKcxHkKtPcT7txMV/OY31U
         s35nK39zrheT22mDjkC7KPOYSb0HBuqF+D0FVK75LZ/oJ3eZvAr+5OaI6QO0AlwWR1gY
         43lYmjbEFkWPk0JQCEaDBKYi+ldiiYs6wlPVoWusLpcdxDxa95KLhOqMs0XhGAIUAkIa
         Mkn2qNM03vLIVwp/p9CqQPdxGpqSuTDm7ONgoxkvHBdFKS8o7IeY+WkYtGvJW5GuRlXa
         uruQ==
X-Gm-Message-State: APjAAAULKy+Mq71mSFyHewnV4AdXgUXknsidmTfFtIWVXeJ/0FpsDxRo
        pBWWm641c23ZmfRx3REEBlA=
X-Google-Smtp-Source: APXvYqys0Ci4OFCUjTb9h8G30XjjNZSlpzB6cSx8PE+JktmIp4Xd0EV9K+791h2+SmQefbTiUbSs2Q==
X-Received: by 2002:a92:a1c7:: with SMTP id b68mr208205ill.134.1578418361778;
        Tue, 07 Jan 2020 09:32:41 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g3sm27915ioq.75.2020.01.07.09.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:32:41 -0800 (PST)
Date:   Tue, 07 Jan 2020 09:32:33 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Message-ID: <5e14c0b1740ca_67962afd051fc5c0a5@john-XPS-13-9370.notmuch>
In-Reply-To: <20191219061006.21980-2-bjorn.topel@gmail.com>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
 <20191219061006.21980-2-bjorn.topel@gmail.com>
Subject: RE: [PATCH bpf-next v2 1/8] xdp: simplify devmap cleanup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> =

> After the RCU flavor consolidation [1], call_rcu() and
> synchronize_rcu() waits for preempt-disable regions (NAPI) in addition
> to the read-side critical sections. As a result of this, the cleanup
> code in devmap can be simplified

OK great makes sense. One comment below.

> =

> * There is no longer a need to flush in __dev_map_entry_free, since we
>   know that this has been done when the call_rcu() callback is
>   triggered.
> =

> * When freeing the map, there is no need to explicitly wait for a
>   flush. It's guaranteed to be done after the synchronize_rcu() call
>   in dev_map_free(). The rcu_barrier() is still needed, so that the
>   map is not freed prior the elements.
> =

> [1] https://lwn.net/Articles/777036/
> =

> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  kernel/bpf/devmap.c | 43 +++++--------------------------------------
>  1 file changed, 5 insertions(+), 38 deletions(-)
> =

> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 3d3d61b5985b..b7595de6a91a 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -201,7 +201,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr=
 *attr)
>  static void dev_map_free(struct bpf_map *map)
>  {
>  	struct bpf_dtab *dtab =3D container_of(map, struct bpf_dtab, map);
> -	int i, cpu;
> +	int i;
>  =

>  	/* At this point bpf_prog->aux->refcnt =3D=3D 0 and this map->refcnt =
=3D=3D 0,
>  	 * so the programs (can be more than one that used this map) were
> @@ -221,18 +221,6 @@ static void dev_map_free(struct bpf_map *map)
>  	/* Make sure prior __dev_map_entry_free() have completed. */
>  	rcu_barrier();
>  =


The comment at the start of this function also needs to be fixed it says,=


  /* At this point bpf_prog->aux->refcnt =3D=3D 0 and this map->refcnt =3D=
=3D 0,
   * so the programs (can be more than one that used this map) were
   * disconnected from events. Wait for outstanding critical sections in
   * these programs to complete. The rcu critical section only guarantees=

   * no further reads against netdev_map. It does __not__ ensure pending
   * flush operations (if any) are complete.
   */

also comment in dev_map_delete_elem() needs update.

> -	/* To ensure all pending flush operations have completed wait for flu=
sh
> -	 * list to empty on _all_ cpus.
> -	 * Because the above synchronize_rcu() ensures the map is disconnecte=
d
> -	 * from the program we can assume no new items will be added.
> -	 */
> -	for_each_online_cpu(cpu) {
> -		struct list_head *flush_list =3D per_cpu_ptr(dtab->flush_list, cpu);=

> -
> -		while (!list_empty(flush_list))
> -			cond_resched();
> -	}
> -
>  	if (dtab->map.map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH) {
>  		for (i =3D 0; i < dtab->n_buckets; i++) {
>  			struct bpf_dtab_netdev *dev;
> @@ -345,8 +333,7 @@ static int dev_map_hash_get_next_key(struct bpf_map=
 *map, void *key,
>  	return -ENOENT;
>  }

Otherwise LGTM thanks.=
