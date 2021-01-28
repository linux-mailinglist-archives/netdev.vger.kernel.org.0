Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75A2308200
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 00:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhA1XiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 18:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbhA1XiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 18:38:00 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB04C061573;
        Thu, 28 Jan 2021 15:37:18 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id y17so6942657ili.12;
        Thu, 28 Jan 2021 15:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=lSJdyA16cLPj4P1izmoGlA3X8t7jSp3IrND4zxNAqCk=;
        b=g9cF7RTV1nRI4ai5S4w4rsKG5OtWxsIp8db7EMLwGReSu0+PpU6YKyFW5HsL5I4uyk
         Stet2v/ILSZh8DCA6BV1/ZYr2ayZIZTpIxc/PcIylGLj8MA+cKR0yvccuHDzrHMNLHNB
         N5pfiG7P8tXPlhLM2d3zMOWzRENu/OrpiIzm48VobeCvrTC+M/nHA954mK4JxUGXg8pb
         wMgChLQRbBqriCvFFcmue7Auphp9zwPK+4zyPy+TM0BQ1RDbkY1b7KCISQNPLT1UODAa
         vwDX++/8ZjoQzUKHOhWeRRKeIZ4ipWatrbtPeJ1DNz2NVYghVaC3s5uh51mgRN+0U3Uf
         xtVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=lSJdyA16cLPj4P1izmoGlA3X8t7jSp3IrND4zxNAqCk=;
        b=jdRnCfIx3x50wYroNuHtU2vAm2rm8PH/KdQsNVhyS07kbt+hCvZ08+0WBkepJDO30/
         ghw6NVY+LJO4ItkuKBiNQrC6Q/dAXqJAHfoJzebF1Vs+Ay+ap+iPW7P9s3bC0zUlVzBp
         SIsOqSnbLN6j7I9QSmAmRu8vcpwO52ZkRInYNJyNUBvatQQ6f33NTRyDk+ExCVAk/kLx
         +JvhrKLHiqmXMcuX00YvZg/JfvUXXLQxbfupGjh/evuXKvKg/mmB4RHAzbe3VS5bCZtJ
         0/+zWj2GJis4oRfm1xkaXTo8TSjxOIGJkqD2UukhkQoyRsPj/Cug5AJz147em2f9tTzQ
         Yz8A==
X-Gm-Message-State: AOAM532gT8k54D8DTMUldj0S6SippDOmoEzhrlW8XEmeZKIL2gor127i
        VVoyxsoGk0kRbVifh3DVWQ4eb7tleS5Ffw==
X-Google-Smtp-Source: ABdhPJzvVcW3upKvwVKYyGkaHFMFRrFg9zUSh1Em8HIXn5+8Bn4E3KeHNJWWhIk+AFLcB1ELsQbfUw==
X-Received: by 2002:a92:1f9b:: with SMTP id f27mr1273303ilf.190.1611877037858;
        Thu, 28 Jan 2021 15:37:17 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id d23sm3186187ioc.2.2021.01.28.15.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 15:37:17 -0800 (PST)
Date:   Thu, 28 Jan 2021 15:37:09 -0800
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
        Hangbin Liu <liuhangbin@gmail.com>
Message-ID: <60134aa5cd92d_f9c120823@john-XPS-13-9370.notmuch>
In-Reply-To: <20210125124516.3098129-7-liuhangbin@gmail.com>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210125124516.3098129-7-liuhangbin@gmail.com>
Subject: RE: [PATCHv17 bpf-next 6/6] selftests/bpf: add xdp_redirect_multi
 test
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> Add a bpf selftest for new helper xdp_redirect_map_multi(). In this
> test we have 3 forward groups and 1 exclude group. The test will
> redirect each interface's packets to all the interfaces in the forward
> group, and exclude the interface in exclude map. We will also test both=

> DEVMAP and DEVMAP_HASH with xdp generic and drv.
> =

> For more test details, you can find it in the test script. Here is
> the test result.
> ]# ./test_xdp_redirect_multi.sh
> Pass: xdpgeneric arp ns1-2
> Pass: xdpgeneric arp ns1-3
> Pass: xdpgeneric arp ns1-4
> Pass: xdpgeneric ping ns1-2
> Pass: xdpgeneric ping ns1-3
> Pass: xdpgeneric ping ns1-4
> Pass: xdpgeneric ping6 ns2-1
> Pass: xdpgeneric ping6 ns2-3
> Pass: xdpgeneric ping6 ns2-4
> Pass: xdpdrv arp ns1-2
> Pass: xdpdrv arp ns1-3
> Pass: xdpdrv arp ns1-4
> Pass: xdpdrv ping ns1-2
> Pass: xdpdrv ping ns1-3
> Pass: xdpdrv ping ns1-4
> Pass: xdpdrv ping6 ns2-1
> Pass: xdpdrv ping6 ns2-3
> Pass: xdpdrv ping6 ns2-4
> Pass: xdpegress mac ns1-2
> Pass: xdpegress mac ns1-3
> Pass: xdpegress mac ns1-4
> Pass: xdpegress ping ns1-2
> Pass: xdpegress ping ns1-3
> Pass: xdpegress ping ns1-4
> Summary: PASS 24, FAIL 0
> =

> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> =

> ---
> v16-v17: no update
> v15: use bpf_object__find_program_by_name instead of
>      bpf_object__find_program_by_title
> v14: no update, only rebase the code
> v13: remove setrlimit
> v12: add devmap prog test on egress
> v9: use NULL directly for arg2 and redefine the maps with btf format
> ---

[...]

> +SEC("xdp_devmap/map_prog")
> +int xdp_devmap_prog(struct xdp_md *ctx)
> +{
> +	void *data_end =3D (void *)(long)ctx->data_end;
> +	void *data =3D (void *)(long)ctx->data;
> +	__u32 key =3D ctx->egress_ifindex;
> +	struct ethhdr *eth =3D data;
> +	__u64 nh_off;
> +	__be64 *mac;
> +
> +	nh_off =3D sizeof(*eth);
> +	if (data + nh_off > data_end)
> +		return XDP_DROP;
> +
> +	mac =3D bpf_map_lookup_elem(&mac_map, &key);
> +	if (mac)
> +		__builtin_memcpy(eth->h_source, mac, ETH_ALEN);
> +
> +	return XDP_PASS;
> +}

Might be nice to also have a test for XDP_DROP. I guess the
above 'data + nh_off > data' case should not happen.

Otherwise, its not the most elegant, but testing XDP at the moment
doesn't fit into the normal test framework very well either.

Acked-by: John Fastabend <john.fastabend@gmail.com>=
