Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F234C54D3
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 10:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiBZJUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 04:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiBZJUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 04:20:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5636D26372A
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 01:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645867168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BQWC4qnEcozjetIUZAtQHzyvu0e2sFoHBrXr/242A4Q=;
        b=Tebt/Jlh42UlaL03nqVeC5sy13NQG9FBNsir2Kn+HVmZjvBOB6SvvoBBpwlK13uUbNqWnp
        oUJKZiLn/Uhr/79gKp6SyTJ9gepkOiJtfOHSRii+GaVwaGgLJfjsYyNlU83cD0BZmdX5LL
        gMP74JPDy0sz40uXDglm1kZ/hQumzwU=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-t3jhumK5P2mf3C_ntFalOQ-1; Sat, 26 Feb 2022 04:19:26 -0500
X-MC-Unique: t3jhumK5P2mf3C_ntFalOQ-1
Received: by mail-pg1-f199.google.com with SMTP id o30-20020a634e5e000000b00373598b71d4so4100591pgl.21
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 01:19:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BQWC4qnEcozjetIUZAtQHzyvu0e2sFoHBrXr/242A4Q=;
        b=tTwuoJgnBVvekxN6KV0Tm6NvBo/i54dC/Fd7yve0J98km4dF4w7KRENGe59QW1Z/CO
         KraWowJh8A1pjeJb+IUvaBQQtPez/QapxeAP8QLADxPf8W9qulnqrDuRhUEIvEtc/RCw
         W3Nuy8BHQtOn4IkgIjDYPGtgSF5NHOHQ5iPxAgal/3/NDqNEBLWuKW5BpvXM9AmdgFpc
         frFlmzany+yC4fyLMY7bUGQ5KvydHd/A/Ao/1GCMI1TJri3DdrAk3JdPn7/P4IvQQjkv
         UTSZJk5VcBXE4iie8w20B8lG/J20FM6V2DpJ3cl/7STvOg0NZNneMNAmFRMC7gRE8AfZ
         k+xQ==
X-Gm-Message-State: AOAM533kJqsJMepJbJfZhIPY5X8/1iIk/xEspkljDcAobht93SFg48iz
        DGll498LRy3nWmvuLjz29drHiaPfDqFytpA9ltxmJaumXdUwchxla1CRWTOd9r7tN8A6EP+dRGr
        dC+VtgEZtWIAlKvWbk53w2NVilrm3hew8
X-Received: by 2002:a65:5bc3:0:b0:378:4f82:d73d with SMTP id o3-20020a655bc3000000b003784f82d73dmr4114569pgr.191.1645867165739;
        Sat, 26 Feb 2022 01:19:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdmbKJWHucKh9BWGgfnXQpcu4fvoXKQiGkxgHr4yoN9zm+Warf9dy1Ixf50NWclTqjqytmZTgZRWPfxr9pk+s=
X-Received: by 2002:a65:5bc3:0:b0:378:4f82:d73d with SMTP id
 o3-20020a655bc3000000b003784f82d73dmr4114546pgr.191.1645867165532; Sat, 26
 Feb 2022 01:19:25 -0800 (PST)
MIME-Version: 1.0
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
 <YhdsgokMMSEQ0Yc8@kroah.com> <CAO-hwJJcepWJaU9Ytuwe_TiuZUGTq_ivKknX8x8Ws=zBFUp0SQ@mail.gmail.com>
 <YhjbzxxgxtSxFLe/@kroah.com> <CAO-hwJJpJf-GHzU7-9bhMz7OydNPCucTtrm=-GeOf-Ee5-aKrw@mail.gmail.com>
 <YhkEqpF6QSYeoMQn@kroah.com> <CAPhsuW4F6pMNYwstQOy68pyU2xrtd8c3k8q2GrNKY9fj46TMdg@mail.gmail.com>
In-Reply-To: <CAPhsuW4F6pMNYwstQOy68pyU2xrtd8c3k8q2GrNKY9fj46TMdg@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Sat, 26 Feb 2022 10:19:14 +0100
Message-ID: <CAO-hwJL7qfAihq=8dwrh=0xLnKKxmCS42KE0eJECKfREEuEkhg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 0/6] Introduce eBPF support for HID devices
To:     Song Liu <song@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Peter Hutterer <peter.hutterer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 26, 2022 at 8:37 AM Song Liu <song@kernel.org> wrote:
>
> On Fri, Feb 25, 2022 at 8:32 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> [...]
> >
> > One comment about the patch series.  You might want to break the patches
> > up a bit smaller, having the example code in a separate commit from the
> > "add this feature" commit, as it was hard to pick out what was kernel
> > changes, and what was test changes from it.  That way I can complain
> > about the example code and tests without having to worry about the
> > kernel patches.
>
> Echo on this part.  Please organize kernel changes, libbpf changes,
> maybe also bpftool changes, selftests, and samples into separate patches.
> This would help folks without HID experience understand the design.
>

Sure. And thanks for the initial review.

I'll send out a splitted v2 early next week then.

Cheers,
Benjamin

