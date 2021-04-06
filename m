Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647AD3549A1
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 02:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242928AbhDFAZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 20:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhDFAZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 20:25:02 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C361C06174A;
        Mon,  5 Apr 2021 17:24:56 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id v26so13682685iox.11;
        Mon, 05 Apr 2021 17:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=gnttbxOe1V4rUWVOujc0qtXaW5lXaOb9WDIXymlBh9E=;
        b=m5Z1l4RvPtt+K5w2WRVQjrPhVzKMwA22sARqAGd/ZS154p7ovTSOx4wwGZr66sW1DW
         BEs1jpYQ5G3IEo5MVGo9tXHFGMUauNiau0DTvc/KwEp7oCcRpwY9+XFy/Mt1fEjIjysk
         Ajwad1rw03G7u1hGduEfuqWugRRxLxe4ePL/oNpTSPYSbAbaEUIC+V6oIk2aejUQnI42
         9O6TMM7W5NS3T3nNIm3HvYmuHGC/MR8GUEuAA0pIWKHLJ/RHkhuiVRNGe99E2W2DrhwV
         XFlaVAtmZEU2uvMFzHVXrgfLvDqKd68BWXjzP83oLqOG0VAfFwPcFTx/ZiHQBYMN3UMz
         hJ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=gnttbxOe1V4rUWVOujc0qtXaW5lXaOb9WDIXymlBh9E=;
        b=bxwme8XsXw/lkZuS/YkA26mjEVmnQp5ipWPRMm5U14ulEav9LsIQlcYkYhTXkjFvVT
         ISbxr/PhoVM0/rB8DqRFDTXmDvZceM7/hgJWmRARSjsI7KJZcPxIwqyickGeO+FcS6Lo
         BeqKalaclt21Oc5BGlio+jvxSc79z3WMgu7xOoW7vVz5TF3+fqj5f6Qf8IBLleQ5Ifvj
         gYJgIhE78sffaD89a1saC5P/nRNb9UWVWTKKXlfAYQ57+8djDzrGP8nXA3wX2o91K6Zi
         AfZrw3N/nrZos7aPwk3Art3SUEomfSB3Trdqu4W02al5VANdhxrroofsnRPuKyLtMGbU
         z/mg==
X-Gm-Message-State: AOAM532ickqRdn5migeOR+oPJrYiqqJqEFgsiIkDUKKafc6EWTosBDm0
        UELzjcgqvC2hTrbU/05LCpo=
X-Google-Smtp-Source: ABdhPJxx0psIY01wwJvmtqNViLRQJzsJr6jqrkvad7KNlqpTCLf/eqZ1DhSZwn/Yjl9dj6wqzckCbg==
X-Received: by 2002:a05:6638:218f:: with SMTP id s15mr26269248jaj.58.1617668695468;
        Mon, 05 Apr 2021 17:24:55 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id d1sm12039733ils.49.2021.04.05.17.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 17:24:54 -0700 (PDT)
Date:   Mon, 05 Apr 2021 17:24:48 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Message-ID: <606baa5025735_d46462085b@john-XPS-13-9370.notmuch>
In-Reply-To: <20210402121954.3568992-3-liuhangbin@gmail.com>
References: <20210402121954.3568992-1-liuhangbin@gmail.com>
 <20210402121954.3568992-3-liuhangbin@gmail.com>
Subject: RE: [PATCHv4 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> This patch add two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGRESS to e=
xtend
> xdp_redirect_map for broadcast support.
> =

> Keep the general data path in net/core/filter.c and the native data
> path in kernel/bpf/devmap.c so we can use direct calls to get better
> performace.
> =

> Here is the performance result by using xdp_redirect_{map, map_multi} i=
n
> sample/bpf and send pkts via pktgen cmd:
> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -=
t 10 -s 64
> =

> There are some drop back as we need to loop the map and get each interf=
ace.
> =

> Version          | Test                                | Generic | Nati=
ve
> 5.12 rc2         | redirect_map        i40e->i40e      |    2.0M |  9.8=
M
> 5.12 rc2         | redirect_map        i40e->veth      |    1.8M | 12.0=
M

Are these are 10gbps i40e ports? Sorry if I asked this earlier, maybe
add a note in the commit if another respin is needed.

> 5.12 rc2 + patch | redirect_map        i40e->i40e      |    2.0M |  9.6=
M
> 5.12 rc2 + patch | redirect_map        i40e->veth      |    1.7M | 12.0=
M
> 5.12 rc2 + patch | redirect_map multi  i40e->i40e      |    1.6M |  7.8=
M
> 5.12 rc2 + patch | redirect_map multi  i40e->veth      |    1.4M |  9.3=
M
> 5.12 rc2 + patch | redirect_map multi  i40e->mlx4+veth |    1.0M |  3.4=
M
> =

> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> =

> ---
> v4:
> a) add a new argument flag_mask to __bpf_xdp_redirect_map() filter out
> invalid map.
> b) __bpf_xdp_redirect_map() sets the map pointer if the broadcast flag
> is set and clears it if the flag isn't set
> c) xdp_do_redirect() does the READ_ONCE/WRITE_ONCE on ri->map to check
> if we should enqueue multi
> =

> v3:
> a) Rebase the code on Bj=C3=B6rn's "bpf, xdp: Restructure redirect acti=
ons".
>    - Add struct bpf_map *map back to struct bpf_redirect_info as we nee=
d
>      it for multicast.
>    - Add bpf_clear_redirect_map() back for devmap.c
>    - Add devmap_lookup_elem() as we need it in general path.
> b) remove tmp_key in devmap_get_next_obj()
> =

> v2: Fix flag renaming issue in v1
> ---
>  include/linux/bpf.h            |  22 ++++++
>  include/linux/filter.h         |  18 ++++-
>  include/net/xdp.h              |   1 +
>  include/uapi/linux/bpf.h       |  17 ++++-
>  kernel/bpf/cpumap.c            |   3 +-
>  kernel/bpf/devmap.c            | 133 ++++++++++++++++++++++++++++++++-=

>  net/core/filter.c              |  97 +++++++++++++++++++++++-
>  net/core/xdp.c                 |  29 +++++++
>  net/xdp/xskmap.c               |   3 +-
>  tools/include/uapi/linux/bpf.h |  17 ++++-
>  10 files changed, 326 insertions(+), 14 deletions(-)
> =


[...]

>  static int cpu_map_btf_id;
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 3980fb3bfb09..c8452c5f40f8 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -198,6 +198,7 @@ static void dev_map_free(struct bpf_map *map)
>  	list_del_rcu(&dtab->list);
>  	spin_unlock(&dev_map_lock);
>  =

> +	bpf_clear_redirect_map(map);

Is this a bugfix? If its needed here wouldn't we also need it in the
devmap case.

>  	synchronize_rcu();
>  =

>  	/* Make sure prior __dev_map_entry_free() have completed. */

[...]

> +
> +static struct bpf_dtab_netdev *devmap_get_next_obj(struct xdp_buff *xd=
p,
> +						   struct bpf_map *map,
> +						   u32 *key, u32 *next_key,
> +						   int ex_ifindex)
> +{
> +	struct bpf_dtab_netdev *obj;
> +	struct net_device *dev;
> +	u32 index;
> +	int err;
> +
> +	err =3D devmap_get_next_key(map, key, next_key);
> +	if (err)
> +		return NULL;
> +
> +	/* When using dev map hash, we could restart the hashtab traversal
> +	 * in case the key has been updated/removed in the mean time.
> +	 * So we may end up potentially looping due to traversal restarts
> +	 * from first elem.
> +	 *
> +	 * Let's use map's max_entries to limit the loop number.
> +	 */
> +	for (index =3D 0; index < map->max_entries; index++) {
> +		obj =3D devmap_lookup_elem(map, *next_key);
> +		if (!obj || dst_dev_is_ingress(obj, ex_ifindex))
> +			goto find_next;
> +
> +		dev =3D obj->dev;
> +
> +		if (!dev->netdev_ops->ndo_xdp_xmit)
> +			goto find_next;
> +
> +		err =3D xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
> +		if (unlikely(err))
> +			goto find_next;
> +
> +		return obj;
> +
> +find_next:
> +		key =3D next_key;
> +		err =3D devmap_get_next_key(map, key, next_key);
> +		if (err)
> +			break;
> +	}

I'm missing something. Either an elaborated commit message or comment
is probably needed. I've been looking at this block for 30 minutes and
can't see how we avoid sending duplicate frames on a single interface?
Can you check this code flow, =


  dev_map_enqueue_multi()
   for (;;) {
     next_obj =3D devmap_get_next_obj(...)
        for (index =3D 0; index < map->max_entries; index++) {
           obj =3D devmap_lookup_elem();
           if (!obj) goto find_next
           key =3D next_key;
           err =3D devmap_get_next_key() =

                  if (!key) goto find_first
                  for (i =3D 0; i < dtab->n_buckets; i++)
                     return *next <- now *next_key is point back
                                     at first entry
           // loop back through and find first obj and return that
        }
      bq_enqueue(...) // enqueue original obj
      obj =3D next_obj;
      key =3D next_key; =

      ...  // we are going to enqueue first obj, but how do we know
           // this hasn't already been sent? Presumably if we have
           // a delete in the hash table in the middle of a multicast
           // operation this might happen?
   }
     =


> +
> +	return NULL;
> +}
> +
> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev=
_rx,
> +			  struct bpf_map *map, bool exclude_ingress)
> +{
> +	struct bpf_dtab_netdev *obj =3D NULL, *next_obj =3D NULL;
> +	struct xdp_frame *xdpf, *nxdpf;
> +	u32 key, next_key;
> +	int ex_ifindex;
> +
> +	ex_ifindex =3D exclude_ingress ? dev_rx->ifindex : 0;
> +
> +	/* Find first available obj */
> +	obj =3D devmap_get_next_obj(xdp, map, NULL, &key, ex_ifindex);
> +	if (!obj)
> +		return -ENOENT;
> +
> +	xdpf =3D xdp_convert_buff_to_frame(xdp);
> +	if (unlikely(!xdpf))
> +		return -EOVERFLOW;
> +
> +	for (;;) {

A nit take it or not. These for (;;) loops always seem a bit odd to me
when we really don't want it to run forever. I prefer

        while (!next_obj)

but a matter of style I guess.

> +		/* Check if we still have one more available obj */
> +		next_obj =3D devmap_get_next_obj(xdp, map, &key, &next_key, ex_ifind=
ex);
> +		if (!next_obj) {
> +			bq_enqueue(obj->dev, xdpf, dev_rx, obj->xdp_prog);
> +			return 0;
> +		}
> +
> +		nxdpf =3D xdpf_clone(xdpf);
> +		if (unlikely(!nxdpf)) {
> +			xdp_return_frame_rx_napi(xdpf);
> +			return -ENOMEM;
> +		}
> +
> +		bq_enqueue(obj->dev, nxdpf, dev_rx, obj->xdp_prog);
> +
> +		/* Deal with next obj */
> +		obj =3D next_obj;
> +		key =3D next_key;
> +	}
> +}
> +

Thanks,
John=
