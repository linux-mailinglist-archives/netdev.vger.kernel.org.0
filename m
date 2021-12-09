Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA8446DFD3
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbhLIA6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241817AbhLIA5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:57:45 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA088C061746;
        Wed,  8 Dec 2021 16:54:12 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id r2so3857867ilb.10;
        Wed, 08 Dec 2021 16:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=LCcCVooHzvscTtO3fZNQNWs4LX1PgNMEkiJ+TaezqAk=;
        b=n0o8l0lg6bHBZ0eND2jTi8Vwxke6VYM6+gUIxkephnlFc4WhqrNIX53TURLkwqnyH1
         w4i9vMzOvFu8SJVDJwBvdd1baoUZu29bCS5Z6Sv+MWVOl11iNV4mhYg7I22N3O0jcF5t
         M/CoY/twzrnLSfH4tbirp2CeeaioeV1ihqp8ZeacgDVVpNe1Ud3W7K9LI0hUPqPQpbTA
         PwA/Te39MbwNGXNMd4QLhVpEGpgXvN5LWJ5ysnp6C+GrhvCmdCVQ+Jo9yWXH0vOl22kq
         BKDFBvoF7ZsovO+lbPkq9EqSyZIZyLfjZyUztR/9UvJQHXmld5ud/dib3ti427a8KF3u
         U4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=LCcCVooHzvscTtO3fZNQNWs4LX1PgNMEkiJ+TaezqAk=;
        b=yc16lG7d5EGcFYnIJdna7MXX1uT0ZLynsCLp3afaQxQ8LvmA7bUoy+NDD2VqsSlMRl
         TNdOIGBDesu7r3hndG7m1/E7+JAtuPClpQnNsfjDrW8zvAb8C5I5VAQK5TLyVzXvZoR8
         pWDWs0P5cXN4hFuJjkRuXR6FQnwtL5FEWbVSVh9Anu6cJOEaTV6IQF72BVjheApit5ul
         QdEvNqNbVFivzlAe7dXE8eBfItkNoAARpCSJOI/59Gj+64N6AZXcURyRLHWkIpaOM00y
         Uv/huyVZ5CUp/a6qmYP3Ni4MyoY1YWT/ZZa9ANi/d7tcSA+v/dzKSjBOcFZ3DMa9yzZa
         b6xw==
X-Gm-Message-State: AOAM5312II2gZHPt8063Kg9N8T1fP+OS/EJXQcm+gzF8JziQml3BrvZw
        MBnRjmGHqSsYhqYb/IlXLy0=
X-Google-Smtp-Source: ABdhPJwpoxkY7Z2mj90VgxwytJ8Y1o6D0NLHc6XLQJJwJOv4bkZYmsVbP4tHDg0aNrQmXaNUGMzxEg==
X-Received: by 2002:a05:6e02:4c7:: with SMTP id f7mr10956083ils.232.1639011252230;
        Wed, 08 Dec 2021 16:54:12 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id ay13sm3432440iob.37.2021.12.08.16.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 16:54:11 -0800 (PST)
Date:   Wed, 08 Dec 2021 16:54:05 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <61b153ad856bb_9795720857@john.notmuch>
In-Reply-To: <20211202000232.380824-1-toke@redhat.com>
References: <20211202000232.380824-1-toke@redhat.com>
Subject: RE: [PATCH bpf-next 0/8] Add support for transmitting packets using
 XDP in bpf_prog_run()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> This series adds support for transmitting packets using XDP in
> bpf_prog_run(), by enabling the xdp_do_redirect() callback so XDP progr=
ams
> can perform "real" redirects to devices or maps, using an opt-in flag w=
hen
> executing the program.
> =

> The primary use case for this is testing the redirect map types and the=

> ndo_xdp_xmit driver operation without generating external traffic. But =
it
> turns out to also be useful for creating a programmable traffic generat=
or.
> The last patch adds a sample traffic generator to bpf/samples, which
> can transmit up to 11.5 Mpps/core on my test machine.
> =

> To transmit the frames, the new mode instantiates a page_pool structure=
 in
> bpf_prog_run() and initialises the pages with the data passed in by
> userspace. These pages can then be redirected using the normal redirect=
ion
> mechanism, and the existing page_pool code takes care of returning and
> recycling them. The setup is optimised for high performance with a high=

> number of repetitions to support stress testing and the traffic generat=
or
> use case; see patch 6 for details.
> =

> The series is structured as follows: Patches 1-2 adds a few features to=

> page_pool that are needed for the usage in bpf_prog_run(). Similarly,
> patches 3-5 performs a couple of preparatory refactorings of the XDP
> redirect and memory management code. Patch 6 adds the support to
> bpf_prog_run() itself, patch 7 adds a selftest, and patch 8 adds the
> traffic generator example to samples/bpf.

Overall looks pretty good. Couple questions in the series though.

Thanks!
John=
