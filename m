Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931CB25625E
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 23:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgH1VKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 17:10:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24804 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726379AbgH1VKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 17:10:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598649015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TqwTtONj5KNOC/pnXhqbs+sbySt/5ow/XPS2c3mPNYg=;
        b=aSH/P/47MnzLhkZKtI6zPJbLc7nnLdvEt0TeE1CVbzURphmova5CjyD5HNRJzAMfu9O4VQ
        hsQH39JtTbst5SmbVo1p/qJmuVB7kiHEG6G/EHYzFeBU+KIG392SrySu4hs6cizeliuAjy
        i7GzByEKPdHh3ZMWZcKXlZrIJepOJZQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-D5R-xQskPf-KTGUK-yIOUw-1; Fri, 28 Aug 2020 17:10:13 -0400
X-MC-Unique: D5R-xQskPf-KTGUK-yIOUw-1
Received: by mail-ej1-f69.google.com with SMTP id by23so1113335ejb.14
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 14:10:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=TqwTtONj5KNOC/pnXhqbs+sbySt/5ow/XPS2c3mPNYg=;
        b=Tppthges22mmMbGJEoXDKwPlL4AO4cFxUfNjabNmkc7qRNYPA3xnoUyWkSOo8DSA0G
         Th2UVy62BV+2vxtpqdb1JBjr5AM9Tr4+k3OlfpybRGmRy2l28kNtUSEmezt8W07OBKU+
         oYEQaZBodz9Q50zqWZx4Ppn588BNfbArKAuziciGeo+HvqelVbxIEHXvQCWMosFN5iBa
         EbyIrvcGdqrSV04RkM0CP06zescvuu7lnnZdgX0CeKopTGkqz19JidS7LOFTiR5KrwmI
         vB737j3EbszEDR4Um/fK0kZafdPIDOnoXpmbKGGc1klszvx9Ygcyz/AL+PpQ19uMkTxq
         5ADA==
X-Gm-Message-State: AOAM533c3dkKavSuAWt+aBmayEnWEVuH7WVnoTy9f4sDq6ne1Fma3Woz
        GCqEMAWYMh5S/vqvwRs2RRhmfYmj97SQ/HOgOb9y0fanH+Epfa6YpmasgWHyfm9yWdrN/f6NosU
        GJ5FFvgetOsfj7DTF
X-Received: by 2002:a05:6402:d8:: with SMTP id i24mr691643edu.294.1598649012316;
        Fri, 28 Aug 2020 14:10:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmbKmlKE7UpE06nJ0b5dBXyOxC1WdWIIjyBaw5a/W8DPMDLZAjjh3y/1hPuUPPIWWdsBYG2w==
X-Received: by 2002:a05:6402:d8:: with SMTP id i24mr691629edu.294.1598649012008;
        Fri, 28 Aug 2020 14:10:12 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a18sm285837ejy.71.2020.08.28.14.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 14:10:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3BB97182B5E; Fri, 28 Aug 2020 23:10:10 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Subject: Re: [PATCH bpf-next v3 4/8] libbpf: implement bpf_prog_find_metadata
In-Reply-To: <20200828193603.335512-5-sdf@google.com>
References: <20200828193603.335512-1-sdf@google.com>
 <20200828193603.335512-5-sdf@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 28 Aug 2020 23:10:10 +0200
Message-ID: <874koma34d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> This is a low-level function (hence in bpf.c) to find out the metadata
> map id for the provided program fd.
> It will be used in the next commits from bpftool.
>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/lib/bpf/bpf.c      | 74 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/bpf.h      |  1 +
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 76 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 5f6c5676cc45..01c0ede1625d 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -885,3 +885,77 @@ int bpf_prog_bind_map(int prog_fd, int map_fd,
>=20=20
>  	return sys_bpf(BPF_PROG_BIND_MAP, &attr, sizeof(attr));
>  }
> +
> +int bpf_prog_find_metadata(int prog_fd)
> +{
> +	struct bpf_prog_info prog_info =3D {};
> +	struct bpf_map_info map_info;
> +	__u32 prog_info_len;
> +	__u32 map_info_len;
> +	int saved_errno;
> +	__u32 *map_ids;
> +	int nr_maps;
> +	int map_fd;
> +	int ret;
> +	int i;
> +
> +	prog_info_len =3D sizeof(prog_info);
> +
> +	ret =3D bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
> +	if (ret)
> +		return ret;
> +
> +	if (!prog_info.nr_map_ids)
> +		return -1;
> +
> +	map_ids =3D calloc(prog_info.nr_map_ids, sizeof(__u32));
> +	if (!map_ids)
> +		return -1;
> +
> +	nr_maps =3D prog_info.nr_map_ids;
> +	memset(&prog_info, 0, sizeof(prog_info));
> +	prog_info.nr_map_ids =3D nr_maps;
> +	prog_info.map_ids =3D ptr_to_u64(map_ids);
> +	prog_info_len =3D sizeof(prog_info);
> +
> +	ret =3D bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
> +	if (ret)
> +		goto free_map_ids;
> +
> +	ret =3D -1;
> +	for (i =3D 0; i < prog_info.nr_map_ids; i++) {
> +		map_fd =3D bpf_map_get_fd_by_id(map_ids[i]);
> +		if (map_fd < 0) {
> +			ret =3D -1;
> +			goto free_map_ids;
> +		}
> +
> +		memset(&map_info, 0, sizeof(map_info));
> +		map_info_len =3D sizeof(map_info);
> +		ret =3D bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len);
> +		saved_errno =3D errno;
> +		close(map_fd);
> +		errno =3D saved_errno;
> +		if (ret)
> +			goto free_map_ids;

If you get to this point on the last entry in the loop, ret will be 0,
and any of the continue statements below will end the loop, causing the
whole function to return 0. While this is not technically a valid ID, it
still seems odd that the function returns -1 on all error conditions
except this one.

Also, it would be good to be able to unambiguously distinguish between
"this program has no metadata associated" and "something went wrong
while querying the kernel for metadata (e.g., permission error)". So
something that amounts to a -ENOENT return; I guess turning all return
values into negative error codes would do that (and also do away with
the need for the saved_errno dance above), but id does clash a bit with
the convention in the rest of the file (where all the other functions
just return -1 and set errno)...

-Toke

