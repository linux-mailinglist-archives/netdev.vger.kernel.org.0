Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A2D29E981
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgJ2Kv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:51:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbgJ2Kv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:51:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603968685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wo1MURne1pPoQywmHfVL+vA75iRnzvStQtotC3YcIKM=;
        b=fPG/D0B0uS3Af2ef7oSpmyUvbWloa5ZJrfX21zXovNPNfoU8sKakT6LYSNcwQHdIucR43K
        NJnxvJNAoxKXkB9gwqNW34uQWuMWslRSeuOsQPqPOohde0FGbJvlzKd7u4Q/llltfLnqrQ
        ZaZhrd2TQvejGMrdjohYaZWDT4Dqbwg=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-nr3NsdbUOLO-cExWawrYVg-1; Thu, 29 Oct 2020 06:51:24 -0400
X-MC-Unique: nr3NsdbUOLO-cExWawrYVg-1
Received: by mail-il1-f199.google.com with SMTP id c8so1604318ilh.9
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 03:51:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wo1MURne1pPoQywmHfVL+vA75iRnzvStQtotC3YcIKM=;
        b=XPSPuGbvy4Jw4mjUY1SXkDXPz5av+Z1zFdrYSiWf86or1RQ92dFPK5S7mYdy6c+3fC
         z6KRgm8rzhaC4Fba4HIlEiNNi/nX63oxLPVe7/ddH5KXytfORLIbLWpCY3cVoudTD26S
         HQeb3kbt6G+KaQnwaFC3jaxcT2kwwslk65Rd2q49YuYGhDKb3JzMvTTYFbTOgbJ2fOja
         npTiZeK5NPXalp3OjNAXOjcFKSvx7/PqO9Q3lh5v5Q1nF7njfaJ0IQDP3AuOi4ZX9U3W
         z9rFPufsywece63nX7VAU9qNDanDa6wfZ5qfiSUyygL5DPE0SrF4n8HphXKc56p6MtlH
         u2ng==
X-Gm-Message-State: AOAM530cIHxGgN/zAkrD8qsQKWLpw8Z2XuSmkrqEgSilPfRS+9AkKu6G
        IPeB5yxOPmvPm0GvcBgc7Y8nVQnC1VI24ynkJncXVHrGIYMI0jg0lfOek/rQhZJVBb0QtDnNQWW
        hScnLwVY28cTBtmcW
X-Received: by 2002:a92:9944:: with SMTP id p65mr2543909ili.127.1603968683334;
        Thu, 29 Oct 2020 03:51:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylVRz942a/PiLEaeJa5Y8bNYpwa4pEHKBVrfO1ld+5U+Z8qKZGIiVcssTINxCWcqFrPoEaRA==
X-Received: by 2002:a92:9944:: with SMTP id p65mr2543883ili.127.1603968682986;
        Thu, 29 Oct 2020 03:51:22 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r12sm1892194ilm.28.2020.10.29.03.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:51:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3A600181CED; Thu, 29 Oct 2020 11:51:19 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <haliu@redhat.com>, David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
In-Reply-To: <20201029102656.GU2408@dhcp-12-153.nay.redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201028132529.3763875-1-haliu@redhat.com>
 <7babcccb-2b31-f9bf-16ea-6312e449b928@gmail.com>
 <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
 <7a412e24-0846-bffe-d533-3407d06d83c4@gmail.com>
 <20201029024506.GN2408@dhcp-12-153.nay.redhat.com>
 <99d68384-c638-1d65-5945-2814ccd2e09e@gmail.com>
 <20201029102656.GU2408@dhcp-12-153.nay.redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 29 Oct 2020 11:51:19 +0100
Message-ID: <874kmdmhjs.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <haliu@redhat.com> writes:

> On Wed, Oct 28, 2020 at 09:00:41PM -0600, David Ahern wrote:
>> >> nope. you need to be able to handle this. Ubuntu 20.10 was just
>> >> released, and it has a version of libbpf. If you are going to integrate
>> >> libbpf into other packages like iproute2, it needs to just work with
>> >> that version.
>> > 
>> > OK, I can replace bpf_program__section_name by bpf_program__title().
>> 
>> I believe this one can be handled through a compatability check. Looks
>> the rename / deprecation is fairly recent (78cdb58bdf15f from Sept 2020).
>
> Hi David,
>
> I just come up with another way. In configure, build a temp program and update
> the function checking every time is not graceful. How about just check the
> libbpf version, since libbpf has exported all functions in src/libbpf.map.
>
> Currently, only bpf_program__section_name() is added in 0.2.0, all other
> needed functions are supported in 0.1.0.
>
> So in configure, the new check would like:

Why is this easier than just checking for the function you need? In
xdp-tools configure we have a test like this:

check_perf_consume()
{
    cat >$TMPDIR/libbpftest.c <<EOF
#include <bpf/libbpf.h>
int main(int argc, char **argv) {
    perf_buffer__consume(NULL);
    return 0;
}
EOF
    libbpf_err=$($CC -o $TMPDIR/libbpftest $TMPDIR/libbpftest.c $LIBBPF_CFLAGS $LIBBPF_LDLIBS 2>&1)
    if [ "$?" -eq "0" ]; then
        echo "HAVE_LIBBPF_PERF_BUFFER__CONSUME:=y" >>"$CONFIG"
        echo "yes"
    else
        echo "HAVE_LIBBPF_PERF_BUFFER__CONSUME:=n" >>"$CONFIG"
        echo "no"
    fi
}

Just do that for __section_name(), and you'll also be able to work with
custom libbpf versions using LIBBPF_DIR.

> static const char *get_bpf_program__section_name(const struct bpf_program *prog)
> {
> #ifdef HAVE_LIBBPF_SECTION_NAME
> 	return bpf_program__section_name(prog);
> #else
> 	return bpf_program__title(prog, false);
> #endif
> }

This bit is fine :)

-Toke

