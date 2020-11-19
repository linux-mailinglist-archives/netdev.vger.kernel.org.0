Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710982B9A4E
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 19:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgKSSCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 13:02:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:35608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728609AbgKSSCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 13:02:12 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6749A246AD;
        Thu, 19 Nov 2020 18:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605808932;
        bh=0bEdyfce/8V63RfRzL6f7jJBz4XGol2pzLisJ0Jtp2E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uCI86sCQ2cNg54CYKAKBUpsV209yBI39/sktsS5ws8fEaNUTAJdOdCY/QSYzN0fJp
         +rS+oljLFYCkXE+GPQX7xTzIksB2c9ewruiD47PWlpLka6UJxFaI7k4n8gLChYJTdo
         58un1CNNKRdoMklTMk4bLGFicQqcm4LmHpjXCRzA=
Date:   Thu, 19 Nov 2020 10:02:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@intel.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH net-next] MAINTAINERS: Update XDP and AF_XDP entries
Message-ID: <20201119100210.08374826@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <160580680009.2806072.11680148233715741983.stgit@firesoul>
References: <160580680009.2806072.11680148233715741983.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 18:26:40 +0100 Jesper Dangaard Brouer wrote:
> Getting too many false positive matches with current use
> of the content regex K: and file regex N: patterns.
>=20
> This patch drops file match N: and makes K: more restricted.
> Some more normal F: file wildcards are added.
>=20
> Notice that AF_XDP forgot to some F: files that is also
> updated in this patch.
>=20
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Ah! Sorry, I missed that you sent this before replying to Joe.

Would you mind respining with his regex?

> diff --git a/MAINTAINERS b/MAINTAINERS
> index af9f6a3ab100..230917ee687f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19105,12 +19105,17 @@ L:	netdev@vger.kernel.org
>  L:	bpf@vger.kernel.org
>  S:	Supported
>  F:	include/net/xdp.h
> +F:	include/net/xdp_priv.h
>  F:	include/trace/events/xdp.h
>  F:	kernel/bpf/cpumap.c
>  F:	kernel/bpf/devmap.c
>  F:	net/core/xdp.c
> -N:	xdp
> -K:	xdp
> +F:	samples/bpf/xdp*
> +F:	tools/testing/selftests/bpf/*xdp*
> +F:	tools/testing/selftests/bpf/*/*xdp*
> +F:	drivers/net/ethernet/*/*/*/*/*xdp*
> +F:	drivers/net/ethernet/*/*/*xdp*
> +K:	[^a-z0-9]xdp[^a-z0-9]
>=20
>  XDP SOCKETS (AF_XDP)
>  M:	Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> @@ -19119,9 +19124,12 @@ R:	Jonathan Lemon <jonathan.lemon@gmail.com>
>  L:	netdev@vger.kernel.org
>  L:	bpf@vger.kernel.org
>  S:	Maintained
> +F:	Documentation/networking/af_xdp.rst
>  F:	include/net/xdp_sock*
>  F:	include/net/xsk_buff_pool.h
>  F:	include/uapi/linux/if_xdp.h
> +F:	include/uapi/linux/xdp_diag.h
> +F:	include/net/netns/xdp.h
>  F:	net/xdp/
>  F:	samples/bpf/xdpsock*
>  F:	tools/lib/bpf/xsk*
>=20
>=20

