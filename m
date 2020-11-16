Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E170B2B52AB
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 21:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733005AbgKPUeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 15:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgKPUea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 15:34:30 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435D1C0613CF;
        Mon, 16 Nov 2020 12:34:29 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id s8so16819812yba.13;
        Mon, 16 Nov 2020 12:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c8o0lWTV5oFYZGA8cq/w+A4j784ox49dpPJ856/9JoM=;
        b=i0uHo1Qo0705jAtRWcfkcq4XzbWhc0j+mLT2XM9K4XHtRrUnu/1geVgadH75aauxaS
         hLSZ2K786RPSLX4dVSe8KOLb5X+9fi7crS1KkuWQeqgCHpXt/vF+HGQh/V9AqPnSo30J
         WRha7bZ9J/MzVi6uhARO3bEV3M3W7W0lW8J+njB+mufdrgVi56PwMu1KhlxjAhBctbtm
         3tOc0BwPD0DqC9KWe4D7seLJm7zHjbU73OUP7atwg3OjpLHGEQR6ZzsQNznup27J6ACr
         1K2RX3ST3kPYc19ohBqm45gJsGw+GONXvoss+Fr4kkerBRd2UyBGLZAoPKIDWXPl67I5
         EJRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c8o0lWTV5oFYZGA8cq/w+A4j784ox49dpPJ856/9JoM=;
        b=g+5/otAy4mSvArGOmoABXBMiM8K2y2uiBRLGnYkz7dijJKX/co88Isn+vLs5+cymQL
         bJHs323TjYhgzKV96ztZIu1eJXAgchCG94E5yWPl2BfI9NaobgWs7VVkOUhH59J2Zzzd
         vNkDbqKBYe/nDEMkT4RL/XK3DKe4N34x+5J4x56/NrQs9XwTauxm1kbJXzKcvAGKcS+/
         90tsxmwXxjExj9X/0Z9mJYcIDPYVDWza9k+Qje7bQPt5IHeBwv+c/b7z7ms1WiVeaupn
         +NzC3WPXtu6/Hltnu6PlYh5WFKQuFv86YNF/sVJjF+mWeqUxSbvSzETmASoXRY2b4Cma
         oEJA==
X-Gm-Message-State: AOAM532JMImXdZhLo21AVsD95YR/Y8Oh3d7wbTLdwHEOPta7ADZ4WLEN
        jm7l1uBjr2v+SQRk4LTV+pPYWTMUgGzqn6UX4o+7oNl//wM=
X-Google-Smtp-Source: ABdhPJx6mICYvNnDIpxk6wLiDam/OieqWJa9sS6iJdU3ImLG8l0AQjgllc+chm4bBXbvrJpHXk+Cc3zGIWbFF/KBntg=
X-Received: by 2002:a25:3d7:: with SMTP id 206mr23184703ybd.27.1605558868531;
 Mon, 16 Nov 2020 12:34:28 -0800 (PST)
MIME-Version: 1.0
References: <20201110011932.3201430-1-andrii@kernel.org> <20201110011932.3201430-4-andrii@kernel.org>
 <B51AA745-00B6-4F2A-A7F0-461E845C8414@fb.com> <SN6PR11MB2751CF60B28D5788B0C15B5AB5E30@SN6PR11MB2751.namprd11.prod.outlook.com>
In-Reply-To: <SN6PR11MB2751CF60B28D5788B0C15B5AB5E30@SN6PR11MB2751.namprd11.prod.outlook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Nov 2020 12:34:17 -0800
Message-ID: <CAEf4BzYSN+XnaA4V3jTLEmoUZO=Yxwp7OAwAY+HOvVEKT5kRFA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/5] kbuild: build kernel module BTFs if BTF
 is enabled and pahole supports it
To:     "Allan, Bruce W" <bruce.w.allan@intel.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Starovoitov, Alexei" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 11:55 AM Allan, Bruce W <bruce.w.allan@intel.com> wrote:
>
> > -----Original Message-----
> > From: Song Liu <songliubraving@fb.com>
> > Sent: Tuesday, November 10, 2020 5:05 PM
> > To: Andrii Nakryiko <andrii@kernel.org>
> > Cc: bpf <bpf@vger.kernel.org>; Networking <netdev@vger.kernel.org>;
> > Starovoitov, Alexei <ast@fb.com>; Daniel Borkmann <daniel@iogearbox.net>;
> > Kernel Team <Kernel-team@fb.com>; open list <linux-
> > kernel@vger.kernel.org>; rafael@kernel.org; jeyu@kernel.org; Arnaldo
> > Carvalho de Melo <acme@redhat.com>; Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org>; Masahiro Yamada
> > <yamada.masahiro@socionext.com>
> > Subject: Re: [PATCH v4 bpf-next 3/5] kbuild: build kernel module BTFs if BTF is
> > enabled and pahole supports it
> >
> >
> >
> > > On Nov 9, 2020, at 5:19 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > [...]
> >
> > > SPLIT BTF
> > > =========
> > >
> > > $ for f in $(find . -name '*.ko'); do size -A -d $f | grep BTF | awk '{print $2}';
> > done | awk '{ s += $1 } END { print s }'
> > > 5194047
> > >
> > > $ for f in $(find . -name '*.ko'); do printf "%s %d\n" $f $(size -A -d $f | grep
> > BTF | awk '{print $2}'); done | sort -nr -k2 | head -n10
> > > ./drivers/gpu/drm/i915/i915.ko 293206
> > > ./drivers/gpu/drm/radeon/radeon.ko 282103
> > > ./fs/xfs/xfs.ko 222150
> > > ./drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko 198503
> > > ./drivers/infiniband/hw/mlx5/mlx5_ib.ko 198356
> > > ./drivers/net/ethernet/broadcom/bnx2x/bnx2x.ko 113444
> > > ./fs/cifs/cifs.ko 109379
> > > ./arch/x86/kvm/kvm.ko 100225
> > > ./drivers/gpu/drm/drm.ko 94827
> > > ./drivers/infiniband/core/ib_core.ko 91188
> > >
> > > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> >
> > Acked-by: Song Liu <songliubraving@fb.com>
>
> This change, commit 5f9ae91f7c0d ("kbuild: Build kernel module BTFs if BTF is enabled and pahole
> supports it") currently in net-next, linux-next, etc. breaks the use-case of compiling only a specific
> kernel module (both in-tree and out-of-tree, e.g. 'make M=drivers/net/ethernet/intel/ice') after
> first doing a 'make modules_prepare'.  Previously, that use-case would result in a warning noting
> "Symbol info of vmlinux is missing. Unresolved symbol check will be entirely skipped" but now it
> errors out after noting "No rule to make target 'vmlinux', needed by '<...>.ko'.  Stop."
>
> Is that intentional?

I wasn't aware of such a use pattern, so definitely not intentional.
But vmlinux is absolutely necessary to generate the module BTF. So I'm
wondering what's the proper fix here? Leave it as is (that error
message is actually surprisingly descriptive, btw)? Force vmlinux
build? Or skip BTF generation for that module?

>
> Thanks,
> Bruce.
