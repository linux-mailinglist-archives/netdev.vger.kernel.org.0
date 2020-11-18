Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172072B8384
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgKRSBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:01:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726255AbgKRSBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 13:01:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605722470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4vmQKgbFa0Rpv5fosaEwaZdu0uag9ylrCYuKjnjwy+E=;
        b=aFiK4X7FZ85bcC0r5KCO6+ihd3apRX059wb8g29XiEC4GjcVQ6EwCljBsqYZA7PxRIrH8i
        k4WS+ZgaOZ0DDxkQI1ulOwUtkxx4j45uy8F3sfOR4/YIARmq+zsAeDI3RQSJb33W9KfbTc
        dQId+NFGxHsQk+Lta5hhg2gWrcZa58U=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-5kPLiJaXNcmx3vGfPUsk6w-1; Wed, 18 Nov 2020 13:01:06 -0500
X-MC-Unique: 5kPLiJaXNcmx3vGfPUsk6w-1
Received: by mail-oo1-f70.google.com with SMTP id u13so1121863ooj.14
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 10:01:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=4vmQKgbFa0Rpv5fosaEwaZdu0uag9ylrCYuKjnjwy+E=;
        b=e8hDobIAr726br0hHDWkl6Z5i/9kOe+ZIabSiy17E+k0HpLCj/3O4YHVUuM0lqd4cF
         LWS8V0DAzDa/KDOHF4f+hsg1SpFArjK4enJKHzltSe+yHW45QCDCuRArCqM/cNWK+PLg
         mmULuTOW5E9taxbpIopIyPvPxkzN9gyKM1166DxFwd6oAqrAZdc8gVhkd3xeZZWNC8Tr
         ZsOwoaCjdyehz7TLdGAABk5NnjR6R+HsvL9gxH1096ozliu9AAKtTxhWRkCC/6/3dNKl
         mFOIuA7sXtzoDmF74maiaQPNQpFmfNsGsNa8+di1bbYbEISTSNj243knUm8gP92hydI/
         nBvg==
X-Gm-Message-State: AOAM533dMLFg4pD/EZVTZI9nltIP3U3YNwp43VvYjYTFEA5rMrY0jAPD
        iPHwHEQ3jzcZGpxu0EnVfVVMmAyBF4oiscZvaJCkLKkmEODSkdrwhlBw2vL2bRA17qQSQEePXWR
        /KPg8H2bPDl1a/0H0
X-Received: by 2002:a05:6808:94:: with SMTP id s20mr205790oic.35.1605722465465;
        Wed, 18 Nov 2020 10:01:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwAwIMQmun9R4PB5eJWPhVnCKbfCtl41qdFPIqIvLv731I86ZKn9SW2/1uBGgcCgp+tsOa7fw==
X-Received: by 2002:a05:6808:94:: with SMTP id s20mr205751oic.35.1605722465062;
        Wed, 18 Nov 2020 10:01:05 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c21sm8436225oos.30.2020.11.18.10.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 10:01:04 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3D35E1833E0; Wed, 18 Nov 2020 19:01:01 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     daniel@iogearbox.net, ast@fb.com, andrii@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, brouer@redhat.com,
        haliu@redhat.com, dsahern@gmail.com, jbenc@redhat.com
Subject: Re: [PATCH bpf-next] libbpf: Add libbpf_version() function to get
 library version at runtime
In-Reply-To: <20201118174325.zjomd2gvybof6awa@ast-mbp>
References: <20201118170738.324226-1-toke@redhat.com>
 <20201118174325.zjomd2gvybof6awa@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Nov 2020 19:01:01 +0100
Message-ID: <87zh3e1r4y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Nov 18, 2020 at 06:07:38PM +0100, Toke H=C3=83=C6=92=C3=82=C2=B8i=
land-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote:
>> As a response to patches adding libbpf support to iproute2, an extensive
>> discussion ensued about libbpf version visibility and enforcement in too=
ls
>> using the library[0]. In particular, two problems came to light:
>>=20
>> 1. If a tool is statically linked against libbpf, there is no way for a =
user
>>    to discover which version of libbpf the tool is using, unless the tool
>>    takes particular care to embed the library version at build time and =
print
>>    it.
>>=20
>> 2. If a tool is dynamically linked against libbpf, but doesn't use any
>>    symbols from the latest library version, the library version used at
>>    runtime can be older than the one used at compile time, and the
>>    application has no way to verify the version at runtime.
>>=20
>> To make progress on resolving this, let's add a libbpf_version() functio=
n that
>> will simply return a version string which is embedded into the library at
>> compile time. This makes it possible for applications to unambiguously g=
et the
>> library version at runtime, resolving (2.) above, and as an added bonus =
makes it
>> easy for applications to print the library version, which should help wi=
th (1.).
>>=20
>> [0] https://lore.kernel.org/bpf/20201109070802.3638167-1-haliu@redhat.co=
m/T/#t
>>=20
>> Signed-off-by: Toke H=C3=83=C6=92=C3=82=C2=B8iland-J=C3=83=C6=92=C3=82=
=C2=B8rgensen <toke@redhat.com>
>
> Unless iproute2 adopts scrict libbpf.so.version =3D=3D iproute2.version p=
olicy
> and removes legacy bpf loader no iproute2 driven changes to libbpf will b=
e accepted.
> Just like the kernel doesn't add features for out-of-tree modules
> libbpf doesn't add features for projects where libbpf is optional.

This is not a iproute2-specific feature, though. It came out of the
iproute2 discussion, sure, but it's a generic helper to get the library
version for any application that wants to use it.

In particular, I am planning to use this in the xdp-tools binaries:

$ ./xdpdump --version
xdpdump version 1.0.1 using libbpf version 0.3.0

-Toke

