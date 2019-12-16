Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B89120231
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 11:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfLPKUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 05:20:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40590 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727198AbfLPKUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 05:20:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576491603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pl5GAP1jRdC0CwpXN80CHmPpQecKuMfnUQwsIaRGCLg=;
        b=a3G2pgRV9VOEGzJTpKcZNTmEqOaKD54sscxsuXprpThH5wzGSiq6Ui78XNILz4Cs/1ny7F
        gOf0WTfjntSe3BONYA+3tUBVPIXcR+W/IUGW15Y0fFpZbK7by5RVeOQjkK9ZnPZgpybe5X
        NA2DOQaazdtbjvGdDeUcWV53sILYWXI=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-kZczb-xNOKSY_SD0Zg7kdA-1; Mon, 16 Dec 2019 05:20:02 -0500
X-MC-Unique: kZczb-xNOKSY_SD0Zg7kdA-1
Received: by mail-lj1-f199.google.com with SMTP id q191so1974398ljb.8
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 02:20:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Pl5GAP1jRdC0CwpXN80CHmPpQecKuMfnUQwsIaRGCLg=;
        b=SIRYpyZTQvvwRbVOeAhcnAb7uhW1FzlpQmvBD6kykp7nzc1m8etfo7qwgHtghsd4pr
         9E27YBzJj2aQb8O4lyRUEyDZdiaNhB5rDHcczZez7hrNMI1wnfOERIObc4jEoh9/mitO
         U/Z9mILEE5qdPj6IyTitdM8ZhKsm5BUZMiqbJ5R1o3d62EcRvOiRuF0k/KxLdIg3ppYr
         Ez13Bge/J3xyIsQNCQIO9BMy05KsszRqmUN2Uv8FrVszSvRqGP8nW9ZzBM+PKWPda2a5
         sgFVUYCi0SAqCSaKQyVcy2mhHd3h2TSWTBfZ6vEphMe3Q/Rm66Qqsj08vU+L4ba7o7+s
         aSFQ==
X-Gm-Message-State: APjAAAXvbtNcan2fmd8PP2B+GmB2jv2kAsklwLn3bD8ExdOsnCnRi0CW
        6+tSUr+ax+O/LteMFAUCCm0NDb8xGC37OW0HeGVRpgeVWkUNbRebqgzD7ekdFgMLF1TCX3Pv2w1
        UgmJ6xgRldX02KV3k
X-Received: by 2002:a2e:9b55:: with SMTP id o21mr19034869ljj.147.1576491601247;
        Mon, 16 Dec 2019 02:20:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqwJx0qXq+MZ+uifWsTqgT8cEn7YRedwq70nttDtYJ0IrjCI91lWWU020Lk/7Q1NnPxsz7LkBg==
X-Received: by 2002:a2e:9b55:: with SMTP id o21mr19034857ljj.147.1576491601054;
        Mon, 16 Dec 2019 02:20:01 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 192sm8640914lfh.28.2019.12.16.02.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 02:20:00 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8681B1819EB; Mon, 16 Dec 2019 11:19:59 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] libbpf: fix build by renaming variables
In-Reply-To: <20191216082738.28421-1-prashantbhole.linux@gmail.com>
References: <20191216082738.28421-1-prashantbhole.linux@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 16 Dec 2019 11:19:59 +0100
Message-ID: <875zigbmi8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prashant Bhole <prashantbhole.linux@gmail.com> writes:

> In btf__align_of() variable name 't' is shadowed by inner block
> declaration of another variable with same name. Patch renames
> variables in order to fix it.
>
>   CC       sharedobjs/btf.o
> btf.c: In function =E2=80=98btf__align_of=E2=80=99:
> btf.c:303:21: error: declaration of =E2=80=98t=E2=80=99 shadows a previou=
s local [-Werror=3Dshadow]
>   303 |   int i, align =3D 1, t;
>       |                     ^
> btf.c:283:25: note: shadowed declaration is here
>   283 |  const struct btf_type *t =3D btf__type_by_id(btf, id);
>       |
>
> Fixes: 3d208f4ca111 ("libbpf: Expose btf__align_of() API")
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>

Seems there are quite a few build errors in bpf today; this at least
fixes libbpf. Thank you!

Tested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

