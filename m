Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35133E77E3
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 18:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390746AbfJ1RzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 13:55:13 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44353 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730395AbfJ1RzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 13:55:13 -0400
Received: by mail-pg1-f195.google.com with SMTP id e10so7363243pgd.11
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 10:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=XzpTan8+i3B861bOkzCgxWVBcpdZyq9MdPABjYUZBgQ=;
        b=oSy+4rOh8KWTH/gIyqSaytcg7to4HP8L8rh7yGFyrKygpn7vuTWG1Y4quilc3aX4dW
         Quq+GiHWZ1SiV3QId+vN6XMHjSJsmTnwsvdsvp/zAPO9ELfFpHyj6yZZpJNSfym+NVgw
         HzSvO5YaC9G6UiBFjUsIQ6dw70Ujc+c8gGusIZp94sB4exmhtoOb9URSq1Dx/RfOPFEs
         a9bD12RsLVBhYkRmFwEyZDi6xkiwKshdO5lYIhI7SmGlL7S/NahyCgXZF0EzZ9F71L3q
         oWqiDkaVJUtS9jf6otdaODvMAhqRD3INHQ8qey5joUdm8UfFYeu3t3TpgYlcKoKImkjU
         KaRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=XzpTan8+i3B861bOkzCgxWVBcpdZyq9MdPABjYUZBgQ=;
        b=NpzWaD5KJg+13Y+O36kFYdJqIZ1OWGObJgQXSOTA+AwhNJeB++FTq8SzsirBbxt6Lq
         VCq9zeagy2x+QrZvxGQnwxL1Ezll5u5OWmk2SUHweFIHSyoAA++aLlhbPrr/LXm7JHAn
         2zsU4xm1AStUg3M9J/uCxFsRCFjltoryqithHHAAmYSdXW6u+7sJGmc56mpK3kP4z3yT
         hVYwlzieb8vfR/3FEXaOzc6WkWZw7tRMUb71L5i8XxlGTgXzoTahd5Quq19oh/OYFwkG
         GeINCClPytGq/DDSNYQopqmlb5gVpBZgInFYF1Ck+D1m2sEdL9gCmftzL34foqd8f0VH
         w4pg==
X-Gm-Message-State: APjAAAUakCf5ZWoPFnpTUCMxqHn+03WQNbOorn/+Xk2qFNTf+LvtTkw2
        Tg3ojyqBJ1/P36Q0DcawxSBtwQ==
X-Google-Smtp-Source: APXvYqw9h0io44UIDPb6BEpXUzgy/w877Ppb+p+ryUkh+wd7UWlExOeW5pyTQArXeU2xjBzv2aqfKQ==
X-Received: by 2002:aa7:9295:: with SMTP id j21mr22355815pfa.223.1572285312139;
        Mon, 28 Oct 2019 10:55:12 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w27sm9763868pgc.20.2019.10.28.10.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 10:55:11 -0700 (PDT)
Date:   Mon, 28 Oct 2019 10:55:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        toke@redhat.com
Subject: Re: [PATCH bpf-next v2 1/2] xsk: store struct xdp_sock as a
 flexible array member of the XSKMAP
Message-ID: <20191028105508.4173bf8b@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191025071842.7724-2-bjorn.topel@gmail.com>
References: <20191025071842.7724-1-bjorn.topel@gmail.com>
        <20191025071842.7724-2-bjorn.topel@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Oct 2019 09:18:40 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> Prior this commit, the array storing XDP socket instances were stored
> in a separate allocated array of the XSKMAP. Now, we store the sockets
> as a flexible array member in a similar fashion as the arraymap. Doing
> so, we do less pointer chasing in the lookup.
>=20
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Thanks for the re-spin.

> diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> index 82a1ffe15dfa..a83e92fe2971 100644
> --- a/kernel/bpf/xskmap.c
> +++ b/kernel/bpf/xskmap.c

> @@ -92,44 +93,35 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *=
attr)
>  	    attr->map_flags & ~(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY))
>  		return ERR_PTR(-EINVAL);
> =20
> -	m =3D kzalloc(sizeof(*m), GFP_USER);
> -	if (!m)
> +	numa_node =3D bpf_map_attr_numa_node(attr);
> +	size =3D struct_size(m, xsk_map, attr->max_entries);
> +	cost =3D size + array_size(sizeof(*m->flush_list), num_possible_cpus());

Now we didn't use array_size() previously because the sum here may
overflow.

We could use __ab_c_size() here, the name is probably too ugly to use
directly and IDK what we'd have to name such a accumulation helper...

So maybe just make cost and size a u64 and we should be in the clear.

> +	err =3D bpf_map_charge_init(&mem, cost);
> +	if (err < 0)
> +		return ERR_PTR(err);
> +
> +	m =3D bpf_map_area_alloc(size, numa_node);
> +	if (!m) {
> +		bpf_map_charge_finish(&mem);
>  		return ERR_PTR(-ENOMEM);
> +	}
> =20
>  	bpf_map_init_from_attr(&m->map, attr);
> +	bpf_map_charge_move(&m->map.memory, &mem);
>  	spin_lock_init(&m->lock);
> =20
> -	cost =3D (u64)m->map.max_entries * sizeof(struct xdp_sock *);
> -	cost +=3D sizeof(struct list_head) * num_possible_cpus();
> -
> -	/* Notice returns -EPERM on if map size is larger than memlock limit */
> -	err =3D bpf_map_charge_init(&m->map.memory, cost);
> -	if (err)
> -		goto free_m;
> -
> -	err =3D -ENOMEM;
> -
>  	m->flush_list =3D alloc_percpu(struct list_head);
> -	if (!m->flush_list)
> -		goto free_charge;
> +	if (!m->flush_list) {
> +		bpf_map_charge_finish(&m->map.memory);
> +		bpf_map_area_free(m);
> +		return ERR_PTR(-ENOMEM);
> +	}
> =20
>  	for_each_possible_cpu(cpu)
>  		INIT_LIST_HEAD(per_cpu_ptr(m->flush_list, cpu));
> =20
> -	m->xsk_map =3D bpf_map_area_alloc(m->map.max_entries *
> -					sizeof(struct xdp_sock *),
> -					m->map.numa_node);
> -	if (!m->xsk_map)
> -		goto free_percpu;
>  	return &m->map;
> -
> -free_percpu:
> -	free_percpu(m->flush_list);
> -free_charge:
> -	bpf_map_charge_finish(&m->map.memory);
> -free_m:
> -	kfree(m);
> -	return ERR_PTR(err);
>  }
> =20
>  static void xsk_map_free(struct bpf_map *map)
