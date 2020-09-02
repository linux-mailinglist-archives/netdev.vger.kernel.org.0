Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B556F25A6EF
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 09:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgIBHkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 03:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgIBHkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 03:40:07 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AB2C061244;
        Wed,  2 Sep 2020 00:40:07 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t4so4174585iln.1;
        Wed, 02 Sep 2020 00:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=enevFwEATp2oYRs6BoPav4G3bpHin52el8vvfhkaxs4=;
        b=NzWtwIrJUw88o8JdPCuclgKm5GhPbOUG7tJV2ZbkQoM5/IhphsG8MLTTWVfZEU6cu/
         PBQnfIrE6mWAELal20uoxrwyUg3ARnqrn9cDVnmF7mN3DHChKMXSLX1IehHt92zPK0pw
         v3cBdtz4lOzzjbYE5i+EU3H6fxav5IgnSdun89sCDw2IhXWwX1nI7AMfRzyX/ueVhuMa
         ftwtsKuCK8VGSRlFE4W/dHUBp/1bBZZ2VaRzkKqocz2/RhuzltTnKHfrESyOap8OzJH5
         svzwj/ep9e530USwSgaLHDRs7WNE7D+iPIU3VavxF7wkl85fjSNRNwZZBNqcQsjDzQEb
         B+pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=enevFwEATp2oYRs6BoPav4G3bpHin52el8vvfhkaxs4=;
        b=fjJBMy9Tkn23D/3jcREwp2FhoXt95HHHcOqzxNK7rBMY2oZljj+c7lPP3Mzgmu7cnv
         +eIcR2yCVW3ABCM4GGHBAMN5bXzZsN3Hu9m8zJZLze5f/HcyLOQKuxG2Lc83sMhn1aq4
         qlKjWRS7wDH6qSrki+OxDYiUJ5c5iPI0uIeNeH6pHvUbqpbl9nCb+V6FTKgsScg5ssN9
         0/N9FyDVxTmU1ASpDlO1PskDvW0Oz2YsCIB6chAVkLhJcIH+B6AHtOxhHM0CAowQG2ri
         nILe2V38PglB9aYQ1QghmdC35SEhjkiHOoBEYKYSkYYjDwSQeoLBkDu5xybwkZttRivd
         /pxA==
X-Gm-Message-State: AOAM531BNEVtWXZNHwjwEeXtRoBaEE3G9KdKuB5gGdurIdOpedVdKZqF
        gssG9nVsyRsf2hEASyV5nL3s+2FSAYQDqZh3MZo=
X-Google-Smtp-Source: ABdhPJyUvf+FKfSu5+5WRaB3nwtOD3MDeU/1ENRdjIHRrQ9Q67nkwjncBTT14tS1PMvEqwOmGqt/wV+G1694IJhNaMA=
X-Received: by 2002:a92:5806:: with SMTP id m6mr2736398ilb.169.1599032406780;
 Wed, 02 Sep 2020 00:40:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200831000304.1696435-1-Tony.Ambardar@gmail.com> <5e77a6d0-3841-0de6-fd6d-6e6763f575bf@iogearbox.net>
In-Reply-To: <5e77a6d0-3841-0de6-fd6d-6e6763f575bf@iogearbox.net>
From:   Tony Ambardar <tony.ambardar@gmail.com>
Date:   Wed, 2 Sep 2020 00:39:57 -0700
Message-ID: <CAPGftE9HxJG+3Lajk7x_+fTzjChNdu20R21H46dJVFq65pscDg@mail.gmail.com>
Subject: Re: [PATCH bpf v1] libbpf: fix build failure from uninitialized
 variable warning
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Aug 2020 at 07:59, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 8/31/20 2:03 AM, Tony Ambardar wrote:
> > While compiling libbpf, some GCC versions (at least 8.4.0) have difficulty
> > determining control flow and a emit warning for potentially uninitialized
> > usage of 'map', which results in a build error if using "-Werror":
> >
> > In file included from libbpf.c:56:
> > libbpf.c: In function '__bpf_object__open':
> > libbpf_internal.h:59:2: warning: 'map' may be used uninitialized in this function [-Wmaybe-uninitialized]
> >    libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
> >    ^~~~~~~~~~~~
> > libbpf.c:5032:18: note: 'map' was declared here
> >    struct bpf_map *map, *targ_map;
> >                    ^~~
> >
> > The warning/error is false based on code inspection, so silence it with a
> > NULL initialization.
> >
> > Fixes: 646f02ffdd49 ("libbpf: Add BTF-defined map-in-map support")
> > Ref: 063e68813391 ("libbpf: Fix false uninitialized variable warning")
> >
> > Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
>
> Applied, thanks!

Thanks, Daniel. I forgot to ask/confirm whether this will get applied
to the 5.8.x stable branch, since it was first encountered there.
