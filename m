Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A911465810
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 21:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353436AbhLAVCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 16:02:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53475 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235116AbhLAVBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 16:01:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638392260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ev55CeShxZMLjyR6AWvoqEYxO3dGwDYuTnrnWeS0i0Q=;
        b=AUxBP6piZbOSJudxktLrA4t8r1TKVzARoyMQ13BhqQbz4xUIgiMkLQIJir8y68xSKO6hdz
        OleSpQ3PnRZlcsG8vhmma6tKA5eEu1Bo75CEpafmoaELF6NMPttzBWJN5NlYQj9rOCVYRW
        LcCpHuc74CLxmbO6o8e54B2WTSIdPqY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-129-ieeMdKytMB2PE8BG8G9Ugw-1; Wed, 01 Dec 2021 15:57:39 -0500
X-MC-Unique: ieeMdKytMB2PE8BG8G9Ugw-1
Received: by mail-ed1-f69.google.com with SMTP id a3-20020a05640213c300b003e7d12bb925so21560264edx.9
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 12:57:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Ev55CeShxZMLjyR6AWvoqEYxO3dGwDYuTnrnWeS0i0Q=;
        b=nfenrkeIZeivtCaROaRZBeDvwb/CP1FwWxmrjaoflmZ+UsAGbZ2C4DFlktXoDbTR0J
         TZiSEFU/AMe+Mv96tnVxfiKJCzh2jwzkvFXDlzMeyXd//c7nRhPMMp2NtHsmoxWOXZWE
         sKxdNkUcIZ8GmOGJ5bw9rNeW9z0JrchlW7u0WtupRDv4qLoywHu4/RYdCjdq1RgmbCEW
         JhCPMIpIhtaJV1bR7/Hg0TDXYscWZXsSHx19RIga0kYPyNNqZnaqeLHPwpcIQ+F4KNxj
         YWpNS2wNDMixw3EmeAXM33ZiBl/iDq4JD0mLafxIM1X84xCVrycrXJLyGVBDxCSMFjCd
         z2ag==
X-Gm-Message-State: AOAM533vxRc68i8iOoG5feipVt+Fs8Gpl7wOGcEUyhcOYhWCiGVv0+YD
        wKFG9aLWzSHRn336w9cDax7zi92rt2OpLaonKHXQ/nVq5vAc688126pIN2bIbMhmUuSS2SAD/2Y
        oKyIXG4laRTlUneeu
X-Received: by 2002:a05:6402:42:: with SMTP id f2mr12124022edu.204.1638392257495;
        Wed, 01 Dec 2021 12:57:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzkFuY5Qu3gtYYCKqYKX5TiqOlyr4sCu/nky4225/b+rKH02PDkf84hbcaZAhuYG3e9lQc8EA==
X-Received: by 2002:a05:6402:42:: with SMTP id f2mr12123906edu.204.1638392256495;
        Wed, 01 Dec 2021 12:57:36 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id sc7sm505038ejc.50.2021.12.01.12.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 12:57:35 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1F8071802A0; Wed,  1 Dec 2021 21:57:35 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next] samples: bpf: fix conflicting types in
 fds_example
In-Reply-To: <20211201164931.47357-1-alexandr.lobakin@intel.com>
References: <20211201164931.47357-1-alexandr.lobakin@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 01 Dec 2021 21:57:35 +0100
Message-ID: <87sfvc59hc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin <alexandr.lobakin@intel.com> writes:

> Fix the following samples/bpf build error appeared after the
> introduction of bpf_map_create() in libbpf:
>
>   CC  samples/bpf/fds_example.o
> samples/bpf/fds_example.c:49:12: error: static declaration of 'bpf_map_cr=
eate' follows non-static declaration
> static int bpf_map_create(void)
>            ^
> samples/bpf/libbpf/include/bpf/bpf.h:55:16: note: previous declaration is=
 here
> LIBBPF_API int bpf_map_create(enum bpf_map_type map_type,
>                ^
> samples/bpf/fds_example.c:82:23: error: too few arguments to function cal=
l, expected 6, have 0
>                 fd =3D bpf_map_create();
>                      ~~~~~~~~~~~~~~ ^
> samples/bpf/libbpf/include/bpf/bpf.h:55:16: note: 'bpf_map_create' declar=
ed here
> LIBBPF_API int bpf_map_create(enum bpf_map_type map_type,
>                ^
> 2 errors generated.
>
> fds_example by accident has a static function with the same name.
> It's not worth it to separate a single call into its own function,
> so just embed it.
>
> Fixes: 992c4225419a ("libbpf: Unify low-level map creation APIs w/ new bp=
f_map_create()")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

I just ran into this today as well - thanks for the fix!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

