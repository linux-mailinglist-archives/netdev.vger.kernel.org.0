Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8033C4C546F
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 08:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiBZHhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 02:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiBZHha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 02:37:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1931C2F42;
        Fri, 25 Feb 2022 23:36:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7894B80E98;
        Sat, 26 Feb 2022 07:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5DFC36AE7;
        Sat, 26 Feb 2022 07:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645861014;
        bh=g94fQTRsmkDzxnFwqKlncZPJPFMXOEaR80ZqGPrByjc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BKrZ5Fqviw0iFMpM01VIUcmpW/MVTbwhsLlgMmtftkUChjkXIEWjnQlwMbyMkhFZf
         r4xKaVjKczryTxS1NXpDQoyc6cEsRL+t1jxb95eo2u5pxJM7vQsVBE3dHevpmdkagi
         SPdvNom8xPg11LoqK1ZAit9yZimTuPAFJ5ND2Guwvg911wK9KvhvcTGwodYFY86p+x
         VBbEXnfZlOpM4B9fvoTgN2N9MXD8UAFc7R8JPtmrk7ksz/Ot+PqI6ayK3U/xpesDFP
         iQBe6B5+qinDC9cxes0OFinXC6m1tiNLknx9Hn5U5riXoSLYyJnjaPmIKhGsdLV/i7
         Q+rBY7myb5DBA==
Received: by mail-yb1-f178.google.com with SMTP id e140so10173613ybh.9;
        Fri, 25 Feb 2022 23:36:54 -0800 (PST)
X-Gm-Message-State: AOAM530vVQ7l0ppoHtI7WPh1G7lyaUvFpNA9x8wdgxZ9Xo4VwqrIyq9l
        hCGppAdj4mZq0PP4nPaHZiRtfQXhAR34f+ZCM9M=
X-Google-Smtp-Source: ABdhPJzAmXByR1myE0ItnK4PftEWDzsmIRtPeFSBUgNcKmDiy1PgZacAOHLh9+8uyvSI9uptig1XbM65jBZTTq7tuPM=
X-Received: by 2002:a25:c89:0:b0:61d:a1e8:fd14 with SMTP id
 131-20020a250c89000000b0061da1e8fd14mr10531412ybm.322.1645861013601; Fri, 25
 Feb 2022 23:36:53 -0800 (PST)
MIME-Version: 1.0
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
 <YhdsgokMMSEQ0Yc8@kroah.com> <CAO-hwJJcepWJaU9Ytuwe_TiuZUGTq_ivKknX8x8Ws=zBFUp0SQ@mail.gmail.com>
 <YhjbzxxgxtSxFLe/@kroah.com> <CAO-hwJJpJf-GHzU7-9bhMz7OydNPCucTtrm=-GeOf-Ee5-aKrw@mail.gmail.com>
 <YhkEqpF6QSYeoMQn@kroah.com>
In-Reply-To: <YhkEqpF6QSYeoMQn@kroah.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 25 Feb 2022 23:36:42 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4F6pMNYwstQOy68pyU2xrtd8c3k8q2GrNKY9fj46TMdg@mail.gmail.com>
Message-ID: <CAPhsuW4F6pMNYwstQOy68pyU2xrtd8c3k8q2GrNKY9fj46TMdg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 0/6] Introduce eBPF support for HID devices
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
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
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 8:32 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
[...]
>
> One comment about the patch series.  You might want to break the patches
> up a bit smaller, having the example code in a separate commit from the
> "add this feature" commit, as it was hard to pick out what was kernel
> changes, and what was test changes from it.  That way I can complain
> about the example code and tests without having to worry about the
> kernel patches.

Echo on this part.  Please organize kernel changes, libbpf changes,
maybe also bpftool changes, selftests, and samples into separate patches.
This would help folks without HID experience understand the design.

Thanks,
Song
