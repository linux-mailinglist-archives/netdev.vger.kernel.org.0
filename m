Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A950A1B7840
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 16:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgDXOWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 10:22:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28570 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728146AbgDXOWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 10:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587738124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZrQ0+S8cAfqz2wvQm3yDdi4ppUuq38E+wMjT8dCVDJU=;
        b=TTFUl8GmT2qc8fcx/GNBt423BrG4tGimjjF0lLe2LYV1VWEfyV5Lxnxpu4zb+4I/qXJldS
        VvMPOwZxjR0jltu6JUNdBdddsULv9EhA5kD7D9+AjpIIWLk9UiYfI6nLQC/Q/U/HWaI+Du
        NcX4nm7uuM//bi2hIBLxug1wIBkWhck=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-qcjm5cdPNomxKV08SgSZqg-1; Fri, 24 Apr 2020 10:21:53 -0400
X-MC-Unique: qcjm5cdPNomxKV08SgSZqg-1
Received: by mail-wm1-f69.google.com with SMTP id b203so4257893wmd.6
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 07:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZrQ0+S8cAfqz2wvQm3yDdi4ppUuq38E+wMjT8dCVDJU=;
        b=DsocFlvDz7NI1NDUzm/sR8mQC7gJQf13TU58KViMtilmRKDsBr6ojYxqqvwAvELVXt
         JQH3fznciYBkUu6DNiycz/HCmvx3j4jCyCbzJ0kzXyRRxdPIgcJOIxXWY8/w+oOWwT/s
         p/1O37SM39rrzgLYHcOXvjdtEMx+L0cPbYptwbJ2VfClIoZsPPAq3+z+Ob4pf5ICI16s
         cHC8EycAOxHtyUtMNpuULjeZ+NmzslYzYE1N7Zk/UNPLB3+l4uIg81Efg8m9B0U8bzXD
         HIpQ0mJrrEYoqPJfxWk/8eIW3Y08KKXxQIfrXthGZUfR1fpCcD4Wxl3Fqyk2LOKwpcY+
         iypA==
X-Gm-Message-State: AGi0PubIqNX4b2eqh6sd1rZr5liYzZlf5ZA4WCbN9nsvnWoxoeynJIoC
        jd3LzGL3LnVXUA6vdiJGGHBmf3/jvBn+Xfp3HYtf/o6yv6FaQmxSxC4J3iJizHC4gvPOnNm5U0T
        YUsUzYSmfhinXx2/Y
X-Received: by 2002:adf:fc11:: with SMTP id i17mr12197863wrr.152.1587738112340;
        Fri, 24 Apr 2020 07:21:52 -0700 (PDT)
X-Google-Smtp-Source: APiQypIoqb6Eebao8kRFG7AhdYhRd9eaUYGV5yK98fqp2Ix2Egsag48OEO+lj2lgqOCMEQk835A99A==
X-Received: by 2002:adf:fc11:: with SMTP id i17mr12197848wrr.152.1587738112120;
        Fri, 24 Apr 2020 07:21:52 -0700 (PDT)
Received: from localhost.localdomain ([151.66.196.206])
        by smtp.gmail.com with ESMTPSA id z10sm8584537wrg.69.2020.04.24.07.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 07:21:51 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:21:43 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [RFC PATCHv2 bpf-next 2/2] sample/bpf: add
 xdp_redirect_map_multicast test
Message-ID: <20200424142143.GB6295@localhost.localdomain>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200424085610.10047-1-liuhangbin@gmail.com>
 <20200424085610.10047-3-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <20200424085610.10047-3-liuhangbin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Apr 24, Hangbin Liu wrote:
> This is a sample for xdp multicast. In the sample we have 3 forward
> groups and 1 exclude group. It will redirect each interface's
> packets to all the interfaces in the forward group, and exclude
> the interface in exclude map.
>=20
> For more testing details, please see the test description in
> xdp_redirect_map_multi.sh.
>=20
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  samples/bpf/Makefile                      |   3 +
>  samples/bpf/xdp_redirect_map_multi.sh     | 124 ++++++++++++++++
>  samples/bpf/xdp_redirect_map_multi_kern.c | 100 +++++++++++++
>  samples/bpf/xdp_redirect_map_multi_user.c | 170 ++++++++++++++++++++++
>  4 files changed, 397 insertions(+)
>  create mode 100755 samples/bpf/xdp_redirect_map_multi.sh
>  create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
>  create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
>=20
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 424f6fe7ce38..eb7306efe85e 100644

[...]

> +
> +SEC("xdp_redirect_map_multi")
> +int xdp_redirect_map_multi_prog(struct xdp_md *ctx)
> +{
> +	u32 key, mcast_group_id, exclude_group_id;
> +	void *data_end =3D (void *)(long)ctx->data_end;
> +	void *data =3D (void *)(long)ctx->data;
> +	struct ethhdr *eth =3D data;
> +	int *inmap_id;
> +	u16 h_proto;
> +	u64 nh_off;
> +
> +	nh_off =3D sizeof(*eth);
> +	if (data + nh_off > data_end)
> +		return XDP_DROP;
> +
> +	h_proto =3D eth->h_proto;
> +
> +	if (h_proto =3D=3D htons(ETH_P_IP))
> +		return bpf_redirect_map_multi(&forward_map_v4, &exclude_map,
> +					      BPF_F_EXCLUDE_INGRESS);

Do we need the 'BPF_F_EXCLUDE_INGRESS' here?

> +	else if (h_proto =3D=3D htons(ETH_P_IPV6))
> +		return bpf_redirect_map_multi(&forward_map_v6, &exclude_map,
> +					      BPF_F_EXCLUDE_INGRESS);

ditto

> +	else
> +		return bpf_redirect_map_multi(&forward_map_all, NULL,
> +					      BPF_F_EXCLUDE_INGRESS);
> +}
> +
> +SEC("xdp_redirect_dummy")
> +int xdp_redirect_dummy_prog(struct xdp_md *ctx)
> +{
> +	return XDP_PASS;
> +}
> +
> +char _license[] SEC("license") =3D "GPL";
> diff --git a/samples/bpf/xdp_redirect_map_multi_user.c b/samples/bpf/xdp_=
redirect_map_multi_user.c
> new file mode 100644
> index 000000000000..2fcd15322201
> --- /dev/null
> +++ b/samples/bpf/xdp_redirect_map_multi_user.c
> @@ -0,0 +1,170 @@
> +/* SPDX-License-Identifier: GPL-2.0-only
> + */
> +#include <linux/bpf.h>
> +#include <linux/if_link.h>
> +#include <errno.h>
> +#include <signal.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <net/if.h>
> +#include <unistd.h>
> +#include <libgen.h>
> +
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +
> +#define MAX_IFACE_NUM 32
> +
> +static int ifaces[MAX_IFACE_NUM] =3D {};
> +static __u32 xdp_flags =3D XDP_FLAGS_UPDATE_IF_NOEXIST;
> +
> +static void int_exit(int sig)
> +{
> +	__u32 prog_id =3D 0;
> +	int i;
> +
> +	for (i =3D 0; ifaces[i] > 0; i++) {
> +		if (bpf_get_link_xdp_id(ifaces[i], &prog_id, xdp_flags)) {
> +			printf("bpf_get_link_xdp_id failed\n");
> +			exit(1);
> +		}
> +		if (prog_id)
> +			bpf_set_link_xdp_fd(ifaces[i], -1, xdp_flags);
> +	}
> +
> +	exit(0);
> +}
> +
> +static void usage(const char *prog)
> +{
> +	fprintf(stderr,
> +		"usage: %s [OPTS] <IFNAME|IFINDEX> <IFNAME|IFINDEX> ... \n"
> +		"OPTS:\n"
> +		"    -S    use skb-mode\n"
> +		"    -N    enforce native mode\n"
> +		"    -F    force loading prog\n",
> +		prog);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	int prog_fd, group_all, group_v4, group_v6, exclude;
> +	struct bpf_prog_load_attr prog_load_attr =3D {
> +		.prog_type      =3D BPF_PROG_TYPE_XDP,
> +	};
> +	int i, ret, opt, ifindex;
> +	char ifname[IF_NAMESIZE];
> +	struct bpf_object *obj;
> +	char filename[256];
> +
> +	while ((opt =3D getopt(argc, argv, "SNF")) !=3D -1) {
> +		switch (opt) {
> +		case 'S':
> +			xdp_flags |=3D XDP_FLAGS_SKB_MODE;
> +			break;
> +		case 'N':
> +			/* default, set below */
> +			break;
> +		case 'F':
> +			xdp_flags &=3D ~XDP_FLAGS_UPDATE_IF_NOEXIST;
> +			break;
> +		default:
> +			usage(basename(argv[0]));
> +			return 1;
> +		}
> +	}
> +
> +	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
> +		xdp_flags |=3D XDP_FLAGS_DRV_MODE;
> +
> +	if (optind =3D=3D argc) {
> +		printf("usage: %s <IFNAME|IFINDEX> <IFNAME|IFINDEX> ...\n", argv[0]);
> +		return 1;
> +	}
> +
> +	printf("Get interfaces");
> +	for (i =3D 0; i < MAX_IFACE_NUM && argv[optind + i]; i ++) {
> +		ifaces[i] =3D if_nametoindex(argv[optind + i]);
> +		if (!ifaces[i])
> +			ifaces[i] =3D strtoul(argv[optind + i], NULL, 0);
> +		if (!if_indextoname(ifaces[i], ifname)) {
> +			perror("Invalid interface name or i");
> +			return 1;
> +		}
> +		printf(" %d", ifaces[i]);
> +	}
> +	printf("\n");
> +
> +	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> +	prog_load_attr.file =3D filename;
> +
> +	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
> +		return 1;
> +
> +	group_all =3D bpf_object__find_map_fd_by_name(obj, "forward_map_all");
> +	group_v4 =3D bpf_object__find_map_fd_by_name(obj, "forward_map_v4");
> +	group_v6 =3D bpf_object__find_map_fd_by_name(obj, "forward_map_v6");
> +	exclude =3D bpf_object__find_map_fd_by_name(obj, "exclude_map");
> +
> +	if (group_all < 0 || group_v4 < 0 || group_v6 < 0 || exclude < 0) {
> +		printf("bpf_object__find_map_fd_by_name failed\n");
> +		return 1;
> +	}
> +
> +	signal(SIGINT, int_exit);
> +	signal(SIGTERM, int_exit);
> +
> +	/* Init forward multicast groups and exclude group */
> +	for (i =3D 0; ifaces[i] > 0; i++) {
> +		ifindex =3D ifaces[i];
> +
> +		/* Add all the interfaces to group all */
> +		ret =3D bpf_map_update_elem(group_all, &ifindex, &ifindex, 0);
> +		if (ret) {
> +			perror("bpf_map_update_elem");
> +			goto err_out;
> +		}
> +
> +		/* For testing: remove the 2nd interfaces from group v4 */
> +		if (i !=3D 1) {
> +			ret =3D bpf_map_update_elem(group_v4, &ifindex, &ifindex, 0);
> +			if (ret) {
> +				perror("bpf_map_update_elem");
> +				goto err_out;
> +			}
> +		}
> +
> +		/* For testing: remove the 1st interfaces from group v6 */
> +		if (i !=3D 0) {
> +			ret =3D bpf_map_update_elem(group_v6, &ifindex, &ifindex, 0);
> +			if (ret) {
> +				perror("bpf_map_update_elem");
> +				goto err_out;
> +			}
> +		}
> +
> +		/* For testing: add the 3rd interfaces to exclude map */
> +		if (i =3D=3D 2) {
> +			ret =3D bpf_map_update_elem(exclude, &ifindex, &ifindex, 0);
> +			if (ret) {
> +				perror("bpf_map_update_elem");
> +				goto err_out;
> +			}
> +		}
> +
> +		/* bind prog_fd to each interface */
> +		ret =3D bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags);
> +		if (ret) {
> +			printf("Set xdp fd failed on %d\n", ifindex);
> +			goto err_out;
> +		}
> +
> +	}
> +
> +	sleep(600);
> +	return 0;
> +
> +err_out:
> +	return 1;
> +}
> --=20
> 2.19.2
>=20

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXqL18gAKCRA6cBh0uS2t
rIYiAP0bCC4pLYxnBBU57ImGg6bfHzSh05UD2L4dwdJVLsDlqAD9GmZ8+FD1OuT3
EMdvAN1e665zvr57Dr929r38Utk12ws=
=L9tC
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--

