Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD1C18D721
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 19:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgCTSfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 14:35:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727178AbgCTSfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 14:35:09 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD64320739;
        Fri, 20 Mar 2020 18:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584729308;
        bh=ySAj4bmpuBVHJ1GMPLpIdVHIf+brmJDxVjGagal1xuc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0bDgyUNC5y2ZU21NKBLt/DHsBsM8ZzFv9G3U+mGwTWkTrF3jHj3lO1hvPUkF+zxGk
         qxg+nYcrZ7d19+DeTow01TPz180IBwS8ovy0QM/HJvuiKniE73tbG1ZbiDcTdfWF5f
         R/gkHzLCi4i/Ehah9fxeK/f89uQAdQnmlXKRYFrc=
Date:   Fri, 20 Mar 2020 11:35:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200320113505.62595593@kicinski-fedora-PC1C0HJN>
In-Reply-To: <87imiy6gc5.fsf@toke.dk>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
        <158462359315.164779.13931660750493121404.stgit@toke.dk>
        <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
        <875zez76ph.fsf@toke.dk>
        <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
        <87imiy6gc5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Mar 2020 19:17:46 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
>=20
> >> > If we do please run this thru checkpatch, set .strict_start_type,   =
=20
> >>=20
> >> Will do.
> >>  =20
> >> > and make the expected fd unsigned. A negative expected fd makes no
> >> > sense.   =20
> >>=20
> >> A negative expected_fd corresponds to setting the UPDATE_IF_NOEXIST
> >> flag. I guess you could argue that since we have that flag, setting a
> >> negative expected_fd is not strictly needed. However, I thought it was
> >> weird to have a "this is what I expect" API that did not support
> >> expressing "I expect no program to be attached". =20
> >
> > I see it now, not entirely unreasonable.
> >
> > Why did you choose to use the FD rather than passing prog id directly?
> > Is the application unlikely to have program ID? =20
>=20
> For consistency with other APIs. Seems the pattern is generally that
> userspace supplies program FDs, and the kernel returns IDs, no?

This API just predates the IDs. "From kernel" API was added when=20
IDs already existed.

I'd think for cmpxchg it may be easier if user space provides ID
directly, since it's what it get returned.
