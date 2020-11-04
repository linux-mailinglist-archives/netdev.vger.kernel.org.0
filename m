Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E783C2A6111
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 11:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgKDKCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 05:02:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728522AbgKDKCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 05:02:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604484133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cWSDEz+pocGgc9hLdmtEOkQnVJuh949rPPfTOBgDI2I=;
        b=jK1mcxBiZi9UScPptcbX/jjK7ogRIbMVdBOzcadh9QI27tq16BiWQYr+v7Dxok3HurguWY
        H7zX9BTaH8KiOQIimEmSS44bovPwIiRcydBPMXFSdsrKk9X+U4amdeC39uoAV/0OAa/Sp1
        L+L8MfHTYU/tZFo7qhXXxRdQCjN6f0o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-QTg0I3EUMnmoBkxjsxgz7g-1; Wed, 04 Nov 2020 05:02:12 -0500
X-MC-Unique: QTg0I3EUMnmoBkxjsxgz7g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACF08804746;
        Wed,  4 Nov 2020 10:02:09 +0000 (UTC)
Received: from localhost (unknown [10.40.194.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BE26510589AF;
        Wed,  4 Nov 2020 10:01:59 +0000 (UTC)
Date:   Wed, 4 Nov 2020 11:01:57 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>, David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201104110157.52f661eb@redhat.com>
In-Reply-To: <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
        <20201029151146.3810859-1-haliu@redhat.com>
        <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
        <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
        <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
        <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
        <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
        <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
        <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
        <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
        <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 19:11:45 -0800, Alexei Starovoitov wrote:
> When we release new version of libbpf it goes through rigorous testing.
> bpftool gets a lot of test coverage as well.
> iproute2 with shared libbpf will get nothing. It's the same random roll of dice.

"Random roll of dice" would be true only if libbpf did incredibly bad
job in keeping backward compatibility. In my experience it is not the
case. Sure, a bug in retaining the compatibility may occasionally
appear; after all, any software tends to contain bugs in various
places. You are right that such bug may not be caught by your testing.

I also believe that if there is a bug in backward compatibility
reported by someone, it will be fixed (if possible). So this is really
just a matter of testing, not a fundamental problem of ABI
compatibility.

Let the distros worry about the testing. Upstream may test (and
even recommend!) certain combinations of iproute2 + libbpf, such as the
latest of both at the time of testing. If distros want to use a
different combination, they can and should do their own testing. If
their testing reveals a bug in backward compatibility and a patch to
fix it is accepted, everything will work smoothly for the distro users.

Non-distro users (or small distros) may just rely on the upstream
tested combination of iproute2 + libbpf.

> Few years from now the situation could be different and shared libbpf would
> be the most appropriate choice. But that day is not today.

Interestingly, the major compatibility problems we had were with llvm
updates. After llvm update while keeping the same kernel version, llvm
started to emit code that the verifier did not accept. Meaning a bpf
program that was previously accepted by the kernel was rejected after
recompilation. This was solved by adding a translation code to libbpf
(which nicely demonstrates that indeed libbpf cares about backward
compatibility).

Now, with dynamically linked libbpf, a single package update was able
to solve the problem for everything on the system, including users' own
programs. All that was needed was making the llvm package force update
the libbpf package (which rpm can do easily with its Conflicts
dependency).

So, at least for us, there was so far no disadvantage (and no problem)
with dynamic linking and a quite substantial advantage.

 Jiri

