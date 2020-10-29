Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FE229EFB9
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 16:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgJ2P0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 11:26:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727917AbgJ2P0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 11:26:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603985179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bFT/mv0cVOBo5IGHGBpeqskPm/yJWdVp4gAP5dsaoNM=;
        b=cdq2FoecT5qE7ff87u3S3EUYWWdkNyZqjXYJJRvztDk9dE26i5LWDxVbwcgRjXzXCG2f6c
        FvBlVRAPUmcVWgeqVSSHnXYz9VBDrPIpOa7aCpwXqNuZWmzuLpxegq+wcX2h0r6QQo1eNe
        l+76pzmmtjKc/t66yCBvLgimyELHcKQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-49SgZBzNPNSIR-XsvxVs8Q-1; Thu, 29 Oct 2020 11:26:17 -0400
X-MC-Unique: 49SgZBzNPNSIR-XsvxVs8Q-1
Received: by mail-il1-f197.google.com with SMTP id c19so2223497ilk.21
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 08:26:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=bFT/mv0cVOBo5IGHGBpeqskPm/yJWdVp4gAP5dsaoNM=;
        b=LOh+xumTq2Qrc+vVVZVn92UzFtHjas2dTRMaV7pM0IJBpYMGUFCb+MX9pMxXOYzs9V
         RZlvht5mKMwouDV9/BmN8c5z18Qsu3WbC9q9ToAKN12VmsN1U7+OM9uIvFTjakPS13Wx
         nmgdEYJD3Xp2eOksVorwJUQRckf5zdc5Ls+GIuM7zu218u1AC+meRh5XZoeRht2VU9jD
         Euh4+l0/8EcKr+sYvmCIJsQJ23GO+1ZwD4f2/fAFk9elMgaP9/dB/b0yWc89CToa29I3
         NG0zintG+cF0amRIMDai/WrjCVfYAWjk9I4h9AeXlJ+uUCJczNkAtbDnNGDtReQ+/Oab
         DskQ==
X-Gm-Message-State: AOAM533gCAUXQGAkgGa3OP2cUoQlqZI9+3/qwsjWfNe/GTgHV5w2cMoP
        Y9p6rP64Ts/hwGTXaJ9UHtRjeEDzRd071TLG6SD/OLl79hx0LVTlHvbbdo0QDW0Ame2nt1W/2CK
        UolAKBBHOAvzjUjiS
X-Received: by 2002:a05:6e02:ea5:: with SMTP id u5mr3344008ilj.18.1603985176605;
        Thu, 29 Oct 2020 08:26:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLVaxkHj+HEgYAhcEtL0SM9HuHpMkCymmxM9PkJWxr2148ycQh2WJkBB3MmmvyHg6rciBOJg==
X-Received: by 2002:a05:6e02:ea5:: with SMTP id u5mr3343978ilj.18.1603985176327;
        Thu, 29 Oct 2020 08:26:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x5sm2723867ilc.15.2020.10.29.08.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 08:26:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 043EF181CED; Thu, 29 Oct 2020 16:26:12 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Hangbin Liu <haliu@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 1/5] configure: add check_libbpf() for
 later libbpf support
In-Reply-To: <20201029151146.3810859-2-haliu@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <20201029151146.3810859-2-haliu@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 29 Oct 2020 16:26:12 +0100
Message-ID: <87h7qdkq97.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <haliu@redhat.com> writes:

> This patch adds a check to see if we support libbpf. By default the
> system libbpf will be used, but static linking against a custom libbpf
> version can be achieved by passing LIBBPF_DIR to configure. FORCE_LIBBPF
> can be set to force configure to abort if no suitable libbpf is found,
> which is useful for automatic packaging that wants to enforce the
> dependency.
>
> Signed-off-by: Hangbin Liu <haliu@redhat.com>

With one nit below, feel free to add back my:

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

> ---
> v3:
> Check function bpf_program__section_name() separately and only use it
> on higher libbpf version.
>
> v2:
> No update
> ---
>  configure | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 94 insertions(+)
>
> diff --git a/configure b/configure
> index 307912aa..58a7176e 100755
> --- a/configure
> +++ b/configure
> @@ -240,6 +240,97 @@ check_elf()
>      fi
>  }
>=20=20
> +have_libbpf_basic()
> +{
> +    cat >$TMPDIR/libbpf_test.c <<EOF
> +#include <bpf/libbpf.h>
> +int main(int argc, char **argv) {
> +    bpf_program__set_autoload(NULL, false);
> +    bpf_map__ifindex(NULL);
> +    bpf_map__set_pin_path(NULL, NULL);
> +    bpf_object__open_file(NULL, NULL);
> +    return 0;
> +}
> +EOF
> +
> +    $CC -o $TMPDIR/libbpf_test $TMPDIR/libbpf_test.c $LIBBPF_CFLAGS $LIB=
BPF_LDLIBS >/dev/null 2>&1
> +    local ret=3D$?
> +
> +    rm -f $TMPDIR/libbpf_test.c $TMPDIR/libbpf_test
> +    return $ret
> +}
> +
> +have_libbpf_sec_name()
> +{
> +    cat >$TMPDIR/libbpf_sec_test.c <<EOF
> +#include <bpf/libbpf.h>
> +int main(int argc, char **argv) {
> +    void *ptr;
> +    bpf_program__section_name(NULL);
> +    return 0;
> +}
> +EOF
> +
> +    $CC -o $TMPDIR/libbpf_sec_test $TMPDIR/libbpf_sec_test.c $LIBBPF_CFL=
AGS $LIBBPF_LDLIBS >/dev/null 2>&1
> +    local ret=3D$?
> +
> +    rm -f $TMPDIR/libbpf_sec_test.c $TMPDIR/libbpf_sec_test
> +    return $ret
> +}
> +
> +check_force_libbpf()
> +{
> +    # if set FORCE_LIBBPF but no libbpf support, just exist the config
> +    # process to make sure we don't build without libbpf.
> +    if [ -n "$FORCE_LIBBPF" ]; then
> +        echo "FORCE_LIBBPF set, but couldn't find a usable libbpf"
> +        exit 1
> +    fi
> +}
> +
> +check_libbpf()
> +{
> +    if ! ${PKG_CONFIG} libbpf --exists && [ -z "$LIBBPF_DIR" ] ; then
> +        echo "no"
> +        check_force_libbpf
> +        return
> +    fi
> +
> +    if [ $(uname -m) =3D=3D x86_64 ]; then
> +        local LIBSUBDIR=3Dlib64
> +    else
> +        local LIBSUBDIR=3Dlib
> +    fi
> +
> +    if [ -n "$LIBBPF_DIR" ]; then
> +        LIBBPF_CFLAGS=3D"-I${LIBBPF_DIR}/include -L${LIBBPF_DIR}/${LIBSU=
BDIR}"
> +        LIBBPF_LDLIBS=3D"${LIBBPF_DIR}/${LIBSUBDIR}/libbpf.a -lz -lelf"
> +    else
> +        LIBBPF_CFLAGS=3D$(${PKG_CONFIG} libbpf --cflags)
> +        LIBBPF_LDLIBS=3D$(${PKG_CONFIG} libbpf --libs)
> +    fi
> +
> +    if ! have_libbpf_basic; then
> +        echo "no"
> +        echo "	libbpf version is too low, please update it to at least 0=
.1.0"
> +        check_force_libbpf
> +        return
> +    else
> +        echo "HAVE_LIBBPF:=3Dy" >>$CONFIG
> +        echo 'CFLAGS +=3D -DHAVE_LIBBPF ' $LIBBPF_CFLAGS >> $CONFIG
> +        echo 'LDLIBS +=3D ' $LIBBPF_LDLIBS >>$CONFIG
> +    fi
> +
> +    # bpf_program__title() is deprecated since libbpf 0.2.0, use
> +    # bpf_program__section_name() instead if we support
> +    if have_libbpf_sec_name; then
> +        echo "HAVE_LIBBPF_SECTION_NAME:=3Dy" >>$CONFIG
> +        echo 'CFLAGS +=3D -DHAVE_LIBBPF_SECTION_NAME ' $LIBBPF_CFLAGS >>=
 $CONFIG

You already added $LIBBPF_CFLAGS above, so with this it ends up being
duplicated, doesn't it?

-Toke

