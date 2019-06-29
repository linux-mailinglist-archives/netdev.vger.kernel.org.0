Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3A15ACDA
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 20:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfF2SY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 14:24:58 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45745 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbfF2SY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 14:24:58 -0400
Received: by mail-pg1-f196.google.com with SMTP id z19so4029137pgl.12
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 11:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Xh+trNKBZ3WDbcJVq9m5LKHCXDOI3OQ3I7I7/hRT+jQ=;
        b=ZhgplxuE2kzJvh/gaJY+58LsZKEXpJgAYiVUqd/BSCwLktPoUSrjNy8h1C9VEGJyB9
         vXz51ki+RHwabDFFwgn9nCQjvieWZIA1ABZctewUHzc1sA5ZSSPbmKLS1JarEsYNg1M0
         RvGNT8cVYZvhAmN07MFReAzCHUHlklz1jozuic7BeUgImIOOHVnHiSRiHQQXItgO/svG
         XLwvFcoIr5+LBicH/0MHoGi/ff2MTSKxszPI4D04S8m8bvbmAuBVJgp6rhHDSE1UcXOE
         FhD8WPCGghl0vsux7+uJjAohxRUQ4ymxvE/Hs3l5dN6jOzHFbUoTrjbjZEywytKDhGBN
         RuHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Xh+trNKBZ3WDbcJVq9m5LKHCXDOI3OQ3I7I7/hRT+jQ=;
        b=st2oweY1huufK41Y+itnpg0m9OVUzD7IfBj8tb6uG4NuFU/wWpoSzKhAcDqU7IPHO0
         2GXuJgaE8tJ1XSKJ9SYkOYDPDVrzC7gTULHd1GWe8SFz8rai6gHlUk0JShK70HLvsFbP
         Jx4tdR69YGm9Go1C/sVayZ8XKFPuSEnmtWXPCHprMuYK3tIyniJw3SpHeQeI/DlGDtOP
         KRNWvX8riq5dGbAQ4I2FmuCBxDTdEAX8KYz4b6v/nyW119QgcEWosxT2EcBsQl73JMl8
         9uWyRnZha/a80RG9gIv6VSfVX+VDAo13cX65AmKPwi0s8a+gXmoHzynxdb5qGCSggm9k
         59nA==
X-Gm-Message-State: APjAAAX7c4bL4vyxSazEe/WZ0bi2s5N6f/Dqumn7i2whsTirb9N5ZQDv
        RH/6Xiwerjb2CfG438yP7ZHfsg==
X-Google-Smtp-Source: APXvYqzz5dqymxb0wW5XzE71dRyZivy1BOQ4nQxD4XT9uL8VLBu5FlyclL3Ub1sa1Lo1Nd7HnPiMZw==
X-Received: by 2002:a63:fd0d:: with SMTP id d13mr16086847pgh.423.1561832697043;
        Sat, 29 Jun 2019 11:24:57 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id e6sm5859917pfn.71.2019.06.29.11.24.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 29 Jun 2019 11:24:56 -0700 (PDT)
Date:   Sat, 29 Jun 2019 11:24:53 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>, <songliubraving@fb.com>
Subject: Re: [PATCH v3 bpf-next 4/4] tools/bpftool: switch map event_pipe to
 libbpf's perf_buffer
Message-ID: <20190629112453.2c46a114@cakuba.netronome.com>
In-Reply-To: <20190629055309.1594755-5-andriin@fb.com>
References: <20190629055309.1594755-1-andriin@fb.com>
        <20190629055309.1594755-5-andriin@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 22:53:09 -0700, Andrii Nakryiko wrote:
>  	map_info_len =3D sizeof(map_info);
>  	map_fd =3D map_parse_fd_and_info(&argc, &argv, &map_info, &map_info_len=
);
> -	if (map_fd < 0)
> +	if (map_fd < 0) {
> +		p_err("failed to get map info");

Can't do, map_parse_fd_and_info() prints an error already, we can't
have multiple errors in JSON.

>  		return -1;
> +	}
> =20
>  	if (map_info.type !=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY) {
>  		p_err("map is not a perf event array");
> @@ -205,7 +157,7 @@ int do_event_pipe(int argc, char **argv)
>  			char *endptr;
> =20
>  			NEXT_ARG();
> -			cpu =3D strtoul(*argv, &endptr, 0);
> +			ctx.cpu =3D strtoul(*argv, &endptr, 0);
>  			if (*endptr) {
>  				p_err("can't parse %s as CPU ID", **argv);
>  				goto err_close_map;
> @@ -216,7 +168,7 @@ int do_event_pipe(int argc, char **argv)
>  			char *endptr;
> =20
>  			NEXT_ARG();
> -			index =3D strtoul(*argv, &endptr, 0);
> +			ctx.idx =3D strtoul(*argv, &endptr, 0);
>  			if (*endptr) {
>  				p_err("can't parse %s as index", **argv);
>  				goto err_close_map;
> @@ -228,45 +180,32 @@ int do_event_pipe(int argc, char **argv)
>  			goto err_close_map;
>  		}
> =20
> -		do_all =3D false;
> +		ctx.all_cpus =3D false;
>  	}
> =20
> -	if (!do_all) {
> -		if (index =3D=3D -1 || cpu =3D=3D -1) {
> +	if (!ctx.all_cpus) {
> +		if (ctx.idx =3D=3D -1 || ctx.cpu =3D=3D -1) {
>  			p_err("cpu and index must be specified together");
>  			goto err_close_map;

Now that you look at err looks like we're missing an err =3D -1 assignment
here?  but...

>  		}
> -
> -		nfds =3D 1;
>  	} else {
> -		nfds =3D min(get_possible_cpus(), map_info.max_entries);
> -		cpu =3D 0;
> -		index =3D 0;
> +		ctx.cpu =3D 0;
> +		ctx.idx =3D 0;
>  	}
> =20
> -	rings =3D calloc(nfds, sizeof(rings[0]));
> -	if (!rings)
> +	opts.attr =3D &perf_attr;
> +	opts.event_cb =3D print_bpf_output;
> +	opts.ctx =3D &ctx;
> +	opts.cpu_cnt =3D ctx.all_cpus ? 0 : 1;
> +	opts.cpus =3D &ctx.cpu;
> +	opts.map_keys =3D &ctx.idx;
> +
> +	pb =3D perf_buffer__new_raw(map_fd, MMAP_PAGE_CNT, &opts);
> +	err =3D libbpf_get_error(pb);
> +	if (err) {
> +		p_err("failed to create perf buffer: %s (%d)",
> +		      strerror(err), err);
>  		goto err_close_map;
> -
> -	pfds =3D calloc(nfds, sizeof(pfds[0]));
> -	if (!pfds)
> -		goto err_free_rings;
> -
> -	for (i =3D 0; i < nfds; i++) {
> -		rings[i].cpu =3D cpu + i;
> -		rings[i].key =3D index + i;
> -
> -		rings[i].fd =3D bpf_perf_event_open(map_fd, rings[i].key,
> -						  rings[i].cpu);
> -		if (rings[i].fd < 0)
> -			goto err_close_fds_prev;
> -
> -		rings[i].mem =3D perf_event_mmap(rings[i].fd);
> -		if (!rings[i].mem)
> -			goto err_close_fds_current;
> -
> -		pfds[i].fd =3D rings[i].fd;
> -		pfds[i].events =3D POLLIN;
>  	}
> =20
>  	signal(SIGINT, int_exit);
> @@ -277,35 +216,25 @@ int do_event_pipe(int argc, char **argv)
>  		jsonw_start_array(json_wtr);
> =20
>  	while (!stop) {
> -		poll(pfds, nfds, 200);
> -		for (i =3D 0; i < nfds; i++)
> -			perf_event_read(&rings[i], &tmp_buf, &tmp_buf_sz);
> +		err =3D perf_buffer__poll(pb, 200);
> +		if (err < 0 && err !=3D -EINTR) {
> +			p_err("perf buffer polling failed: %s (%d)",
> +			      strerror(err), err);
> +			goto err_close_pb;
> +		}
>  	}
> -	free(tmp_buf);
> =20
>  	if (json_output)
>  		jsonw_end_array(json_wtr);
> =20
> -	for (i =3D 0; i < nfds; i++) {
> -		perf_event_unmap(rings[i].mem);
> -		close(rings[i].fd);
> -	}
> -	free(pfds);
> -	free(rings);
> +	perf_buffer__free(pb);
>  	close(map_fd);
> =20
>  	return 0;
> =20
> -err_close_fds_prev:
> -	while (i--) {
> -		perf_event_unmap(rings[i].mem);
> -err_close_fds_current:
> -		close(rings[i].fd);
> -	}
> -	free(pfds);
> -err_free_rings:
> -	free(rings);
> +err_close_pb:
> +	perf_buffer__free(pb);
>  err_close_map:
>  	close(map_fd);
> -	return -1;
> +	return err ? -1 : 0;

... how can we return 0 on the error path? =F0=9F=98=95

>  }

