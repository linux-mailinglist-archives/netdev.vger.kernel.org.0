Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC32A1BBBD1
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 13:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgD1LDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 07:03:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29308 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726364AbgD1LDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 07:03:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588071793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=em3cAOHQGnvt5dPtSaqA3KqEw17BoNQHhUGrz/i4GhA=;
        b=O7ddw2KfWzXZJ8d39864BiUdAw8NjUWtrzuHq6AoYW+d03LDWh3oufwO4+vKUZXm2fs1Ey
        zJX5iryk569BNX1JdslStiSAcSdvLki18v0seHh6J0TGECx0tkR1plQ47hLG4Z4pUrPD+F
        dVYdXeVE3ZOe3IfiHYC8M1eBBWApT0E=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-S0ex1URHM4il16KpR4m99w-1; Tue, 28 Apr 2020 07:03:11 -0400
X-MC-Unique: S0ex1URHM4il16KpR4m99w-1
Received: by mail-lf1-f72.google.com with SMTP id v22so8820868lfa.1
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 04:03:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=em3cAOHQGnvt5dPtSaqA3KqEw17BoNQHhUGrz/i4GhA=;
        b=GG83BTlMdq4Ceh8IAucDuyfv0NBY5TI5tEGZsytNKPv3pkc9itJih5vFCIJLumxhjb
         /6BQpsnsuql5zloLtSbEzYaMpgQISOmHN+R8An3hE8UazJ73UQ2PjHYn7geF4GnFQdpg
         DMZ2Pa/Otda95o5/6vcnXtFhfOvJIKcV1yo0eOmc0uJb767MGiQVcjsxpRiBEOgKKKSZ
         kapvELM/TIqwUG53H0+/88bYi3ZY+TKrceNqFlGoneZQyfWCHe78jsgAdx6K9w3aDYX3
         TfARIUyffPF4yfI/nQ/pCQNlK15AOJM8LttWaAkHKOEpAmgrYEuLFk6RGhtPF0BtR/Ud
         v8PA==
X-Gm-Message-State: AGi0PubQyi4MIaVUtlyClT1++D8GDzwuPcfodRcc1TJnZeurg5Pe574a
        vaqhdqPIhVSz5GtTe0uQ2cw+cx7kMZEpzaLK8QZfw2Jgu+IChtqJFmaq9U565kyl0h+lLFzxRAm
        vIjLlcXzz92fJMZWn
X-Received: by 2002:a2e:9012:: with SMTP id h18mr9859727ljg.28.1588071790106;
        Tue, 28 Apr 2020 04:03:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypLwLTSJjvjWBg8fmmv84VcV9VxdazrKZMo6fuGa1M+W6YyIpXdgDlBosvxYF5TqeCxo30Dw2w==
X-Received: by 2002:a2e:9012:: with SMTP id h18mr9859703ljg.28.1588071789799;
        Tue, 28 Apr 2020 04:03:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j13sm13817709lfb.19.2020.04.28.04.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 04:03:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 89DDB1814FF; Tue, 28 Apr 2020 13:03:07 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v2 bpf-next 3/3] libbpf: add BTF-defined map-in-map support
In-Reply-To: <20200428064140.122796-4-andriin@fb.com>
References: <20200428064140.122796-1-andriin@fb.com> <20200428064140.122796-4-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 28 Apr 2020 13:03:07 +0200
Message-ID: <878sifx47o.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> As discussed at LPC 2019 ([0]), this patch brings (a quite belated) suppo=
rt
> for declarative BTF-defined map-in-map support in libbpf. It allows to de=
fine
> ARRAY_OF_MAPS and HASH_OF_MAPS BPF maps without any user-space initializa=
tion
> code involved.
>
> Additionally, it allows to initialize outer map's slots with references to
> respective inner maps at load time, also completely declaratively.
>
> Despite a weak type system of C, the way BTF-defined map-in-map definition
> works, it's actually quite hard to accidentally initialize outer map with
> incompatible inner maps. This being C, of course, it's still possible, but
> even that would be caught at load time and error returned with helpful de=
bug
> log pointing exactly to the slot that failed to be initialized.
>
> As an example, here's a rather advanced HASH_OF_MAPS declaration and
> initialization example, filling slots #0 and #4 with two inner maps:
>
>   #include <bpf/bpf_helpers.h>
>
>   struct inner_map {
>           __uint(type, BPF_MAP_TYPE_ARRAY);
>           __uint(max_entries, 1);
>           __type(key, int);
>           __type(value, int);
>   } inner_map1 SEC(".maps"),
>     inner_map2 SEC(".maps");
>
>   struct outer_hash {
>           __uint(type, BPF_MAP_TYPE_HASH_OF_MAPS);
>           __uint(max_entries, 5);
>           __uint(key_size, sizeof(int));
>           __inner(values, struct inner_map);
>   } outer_hash SEC(".maps") =3D {
>           .values =3D {
>                   [0] =3D &inner_map2,
>                   [4] =3D &inner_map1,
>           },
>   };

I like the syntax (well, to the extent you can 'like' C syntax and its
esoteric (ab)uses), and am only mildly horrified at what it takes to
achieve it ;)

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

