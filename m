Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC1810B388
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 17:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfK0QiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 11:38:16 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42966 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfK0QiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 11:38:15 -0500
Received: by mail-lf1-f66.google.com with SMTP id y19so17671826lfl.9;
        Wed, 27 Nov 2019 08:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mz5GsjADrq7Mi9UKNleUHgz2CZ0Cj+d/AWSAC35bBaw=;
        b=bRcse+IEa7g41DiJ8lHlq/Z+vc/rEdEbITXdyMp9wweC569mcF/X9rcVG2vmcis9Wl
         A3QnqU+xasXexABpcI7+oORuo49B3r5xnLyIwavR8equOCjuD4c/8a1WryvsUPfuo/0B
         m1WDto1Coab04BOMl2DYcoOtE8M/TQ2omHApKvqkhdYHv4GsQLWenFYZEPFK53NiYdD/
         EbRsZen+n6igXAhfmZboMQA1XI8r5JpJYGQoJ//cw3UX5GibDo0+8a8DMQnqI3o78IQS
         NWDcBSGrCNIlHT9yt6esOee3lLgoQ04VYivFoOTnO9THtQGi9kZL5LrIreSJFFr50/sC
         grVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mz5GsjADrq7Mi9UKNleUHgz2CZ0Cj+d/AWSAC35bBaw=;
        b=ZHtwXEbuYIdgeu2Sjpip20jr5FlcUfuMPUgwJEM19kFDJhM6SY+YUl5Qz4NGe+tClB
         rWFVai43rc9mLdYfELGLC98/nRuM2QPXtfQGhNcouV62d3rvBIc+uGOCitKyW9vgPBcp
         +aXIZWdqKNrQiXcA6eTBHTUibqK5fA0dzPQltgX61I4ZLbJVLnXBi6SrUj6chRRC5Lf+
         dI+mzi7r6gyEXfUnuZj3F95lv9yxZE8rB0UUggMAHPS427MrQlNhpwSkA8msDtxNJ6mF
         yw/eFTSEy9RB+J1kJrQDzeVVvGKq3ISFR6MrqBoHDCTwt9UdjxzQM/AR/YaGKlirmxkG
         fCxA==
X-Gm-Message-State: APjAAAUF/ajAbuFOQMoTxxJwPnmuu6hJcSfhWZ6Bm+Ey930qVy2yWJow
        94seSga3rAjcwu9wUurnyvYgjSlMzwTXi5lB0/w=
X-Google-Smtp-Source: APXvYqyzJn19CU7rqof7Ha5Mfl9XN6DfVKHW0sniqzUOkb2wGXL9G5TOXXuxtMhT3d7EFYT8QuvjIaDVObdIGd36ero=
X-Received: by 2002:a19:c384:: with SMTP id t126mr29744829lff.100.1574872693377;
 Wed, 27 Nov 2019 08:38:13 -0800 (PST)
MIME-Version: 1.0
References: <20191127094837.4045-1-jolsa@kernel.org>
In-Reply-To: <20191127094837.4045-1-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 Nov 2019 08:37:59 -0800
Message-ID: <CAADnVQLp2VTi9JhtfkLOR9Y1ipNFObOGH9DQe5zbKxz77juhqA@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf/bpftool: Allow to link libbpf dynamically
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 1:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> adding support to link bpftool with libbpf dynamically,
> and config change for perf.
>
> It's now possible to use:
>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1
>
> which will detect libbpf devel package with needed version,
> and if found, link it with bpftool.
>
> It's possible to use arbitrary installed libbpf:
>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/libbpf/
>
> I based this change on top of Arnaldo's perf/core, because
> it contains libbpf feature detection code as dependency.
> It's now also synced with latest bpf-next, so Toke's change
> applies correctly.

I don't like it.
Especially Toke's patch to expose netlink as public and stable libbpf api.
bpftools needs to stay tightly coupled with libbpf (and statically
linked for that reason).
Otherwise libbpf will grow a ton of public api that would have to be stable
and will quickly become a burden.
