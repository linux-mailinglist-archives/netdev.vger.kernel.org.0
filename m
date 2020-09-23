Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A5B275EA2
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgIWR2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgIWR2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 13:28:17 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B35C0613CE;
        Wed, 23 Sep 2020 10:28:17 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id c17so361997ybe.0;
        Wed, 23 Sep 2020 10:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VLO53XWOiiwBpciP7MbUcanBoigKiOZBgmr2bd0CjV0=;
        b=XKyVmYA91jrvIc6LrrTiAqH/wA5oTGZop08LyQvfL7/ar6Tp0+NwUacXbTXpmcPCTd
         pIJGnCaZfZx0grSR7fLQJ9CYFCAZVoDHVESOmqZqq3+aAueoCUvYy5Q0B9np60Pdh2GJ
         cCOpjHsuALEeT2/zQiQlpSld0No5r1xUA8ztOIjdA3t86B7Vq5urCmxVU7GkE5CdOBYb
         bDXLFbB51YFU7fCvadmgx0Gy+59zTVlCSE4pN4/L8iv59RxZyns0sj4ukHTSgNZJUAaP
         k+S81m3zopXVx+n3UXLs01i3ETf2asomUCNKcwSPMSBtyBP6Y6FpyIr2I2Jn4TxOBCGn
         JLBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VLO53XWOiiwBpciP7MbUcanBoigKiOZBgmr2bd0CjV0=;
        b=dDQpOnFoCfWc/s15ZcHmHgLNWqWwYaxOC7aEFbwn10qHxEQs7kF8jPkEtoZtt4NDdd
         B/vvQXXjGhlNzG1JEW//REwl1DSjm5gvBukbwtPn1eXKnEg3YXLnP5Op3wCg1KLjlO02
         oU7SU8TDGoaO0V/dLdYqfsevxj3OwFZsNQ2dC3FJpRM8yDSZr2K+vu8P3E8eVUpG8zWU
         YySqmp60+8OH/eRDwvzANJ5Q/rHkQ03PjJXEdyA4sIpGrcd72/aGH3QFHokVZrqIvOfj
         W6BvhoRydNSePh8/TPA17ckUDw8Bz9fGBeFyQNRCiOQanBhS2IFIb+g1Q2SYX3fY5xVY
         26ag==
X-Gm-Message-State: AOAM532Ia3Loyw5VAa0h0dBVO/VG/vzlgqW3+X+bNbZ0pisJU+ZHoMT7
        JQ31c3CFKh6LYiGXtdq0IQOfYcpQKHeSM8mb+L7ExSfgiRkBfw==
X-Google-Smtp-Source: ABdhPJzgeN2/w2TEDyWiT/sS0BxDouXM6tZJ5s13B2edOkXPiDY13S5fIQjIjSFiBYJO33xU9IkpGwWb76JruiVZTgc=
X-Received: by 2002:a25:33c4:: with SMTP id z187mr1483886ybz.27.1600882096705;
 Wed, 23 Sep 2020 10:28:16 -0700 (PDT)
MIME-Version: 1.0
References: <160079991372.8301.10648588027560707258.stgit@toke.dk> <160079992129.8301.9319405264647976548.stgit@toke.dk>
In-Reply-To: <160079992129.8301.9319405264647976548.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Sep 2020 10:28:05 -0700
Message-ID: <CAEf4BzZuMUA2B+Nz+7GfpoW2SGF3tyUpjRsjP2cX3VGH34OHgw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 07/11] libbpf: add support for freplace
 attachment in bpf_link_create
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 11:39 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds support for supplying a target btf ID for the bpf_link_create()
> operation, and adds a new bpf_program__attach_freplace() high-level API f=
or
> attaching freplace functions with a target.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf.c      |   18 +++++++++++++++---
>  tools/lib/bpf/bpf.h      |    3 ++-
>  tools/lib/bpf/libbpf.c   |   44 +++++++++++++++++++++++++++++++++++++++-=
----
>  tools/lib/bpf/libbpf.h   |    3 +++
>  tools/lib/bpf/libbpf.map |    1 +
>  5 files changed, 60 insertions(+), 9 deletions(-)
>

[...]
