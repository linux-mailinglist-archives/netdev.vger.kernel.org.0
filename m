Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90773C990B
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 09:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfJCHf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 03:35:28 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23647 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbfJCHf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 03:35:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570088125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ahlNzkuv1Gr7jChvdoijfKpS0UvBbY8sDdSq0LbHVqs=;
        b=ceBv8y5mI5VIEowhPdLptDA1OxQ6KyJbnQ6hBl2Gjy3HnDebTj7NMMHmVQ9SDAerXp2i4f
        zBeGcuj8RoP5kRrWzv4fI+9flNgux5c6GmFiM3/ehwCSA+8xdeFgcmbMuZwEoX8Q1TTJ1b
        xa9/g4OsrdzJ38KqjHkcF0X/XJfRQKM=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-fb66GCSRMLi4yAfSyQdUvA-1; Thu, 03 Oct 2019 03:35:23 -0400
Received: by mail-lj1-f198.google.com with SMTP id r22so550445ljg.15
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 00:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5opDUu41kY9xgEvZBTw/lIEBtyZIajraEgqdBUvC+1w=;
        b=hY+msrKgb3iQTo35uW394fD/DMi+9FU9i/LmGdwtBsaM7lqdH/F/MCAYMTzfEXnPMz
         kWjTsAHL+saH2AnODsKC56LO71Q7dulNGevKW7+PQVxMBVVPcESL7JgDNxkiJp45gVJv
         R9OjuHlZGeXkKLLSNuN9WAJlfs4VDOPofIYMj2Z72jVbKrD3xS2k8f+HBAtMe/SpAKsA
         bTfsiCFXZbgz4YhX6CjAZY4KLCAv2RyQlcLuyVfOYYUGU+EkZI1R6GF0MiiimYVsCB3S
         EfoFThaFVGgPFUgIHnPd6SaO2rm0t7dR40KU3uyLk9RsO7F8ls8+Wocas+e50SqNUsbQ
         mWlw==
X-Gm-Message-State: APjAAAWErKl3FFn0F/SVgQBnL7TX76NkYhvNZbfpyKaiuIJ9BgYYLht1
        lHPUaaoMksIYkaACMDupiqnD2MoGjeIP56/+6/lvZfnlkW1kYvwtk5h1OcZwLgYvogDcXVQ5LQE
        8gFdDiQ268jTj8wwM
X-Received: by 2002:a2e:5dc6:: with SMTP id v67mr2506726lje.247.1570088122288;
        Thu, 03 Oct 2019 00:35:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzDWZjrhNPsTmkARGvOvjAvXnChZdtor1vHsiLqai4F+X6XM68slctRaXw6jVQI8cgsaLzylg==
X-Received: by 2002:a2e:5dc6:: with SMTP id v67mr2506713lje.247.1570088122101;
        Thu, 03 Oct 2019 00:35:22 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id k15sm351208ljg.65.2019.10.03.00.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 00:35:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5B5C318063D; Thu,  3 Oct 2019 09:35:20 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/7] selftests/bpf: samples/bpf: split off legacy stuff from bpf_helpers.h
In-Reply-To: <20191002215041.1083058-3-andriin@fb.com>
References: <20191002215041.1083058-1-andriin@fb.com> <20191002215041.1083058-3-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 03 Oct 2019 09:35:20 +0200
Message-ID: <87k19mqo1z.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: fb66GCSRMLi4yAfSyQdUvA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test=
_kern.c
> index 2b2ffb97018b..f47ee513cb7c 100644
> --- a/samples/bpf/map_perf_test_kern.c
> +++ b/samples/bpf/map_perf_test_kern.c
> @@ -9,25 +9,26 @@
>  #include <linux/version.h>
>  #include <uapi/linux/bpf.h>
>  #include "bpf_helpers.h"
> +#include "bpf_legacy.h"
> =20
>  #define MAX_ENTRIES 1000
>  #define MAX_NR_CPUS 1024
> =20
> -struct bpf_map_def SEC("maps") hash_map =3D {
> +struct bpf_map_def_legacy SEC("maps") hash_map =3D {
>  =09.type =3D BPF_MAP_TYPE_HASH,
>  =09.key_size =3D sizeof(u32),
>  =09.value_size =3D sizeof(long),
>  =09.max_entries =3D MAX_ENTRIES,
>  };

Why switch these when they're not actually using any of the extra fields
in map_def_legacy?
> =20
> -struct bpf_map_def SEC("maps") lru_hash_map =3D {
> +struct bpf_map_def_legacy SEC("maps") lru_hash_map =3D {
>  =09.type =3D BPF_MAP_TYPE_LRU_HASH,
>  =09.key_size =3D sizeof(u32),
>  =09.value_size =3D sizeof(long),
>  =09.max_entries =3D 10000,
>  };
> =20
> -struct bpf_map_def SEC("maps") nocommon_lru_hash_map =3D {
> +struct bpf_map_def_legacy SEC("maps") nocommon_lru_hash_map =3D {
>  =09.type =3D BPF_MAP_TYPE_LRU_HASH,
>  =09.key_size =3D sizeof(u32),
>  =09.value_size =3D sizeof(long),
> @@ -35,7 +36,7 @@ struct bpf_map_def SEC("maps") nocommon_lru_hash_map =
=3D {
>  =09.map_flags =3D BPF_F_NO_COMMON_LRU,
>  };
> =20
> -struct bpf_map_def SEC("maps") inner_lru_hash_map =3D {
> +struct bpf_map_def_legacy SEC("maps") inner_lru_hash_map =3D {
>  =09.type =3D BPF_MAP_TYPE_LRU_HASH,
>  =09.key_size =3D sizeof(u32),
>  =09.value_size =3D sizeof(long),
> @@ -44,20 +45,20 @@ struct bpf_map_def SEC("maps") inner_lru_hash_map =3D=
 {
>  =09.numa_node =3D 0,
>  };

Or are you just switching everything because of this one?


-Toke

