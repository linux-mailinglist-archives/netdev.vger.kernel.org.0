Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524FC41CD67
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 22:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346729AbhI2U2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 16:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346361AbhI2U2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 16:28:42 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7869BC06161C;
        Wed, 29 Sep 2021 13:27:01 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id k23-20020a17090a591700b001976d2db364so2959996pji.2;
        Wed, 29 Sep 2021 13:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R+UtOR8a4UKHM6XF+8O3IvgN2QLGl1j5MHQuVBbeTvE=;
        b=QK2nxrAvqLb5hwTMpABkw8yBGQmZTbSWescIh3gUuuYykzOO4XXcO+WQnm+RVjvAJZ
         gv/yDbMIq9Yd2IjsxRD7rNRHdnh7TZLO6W0/sIJ3LrmyVPS5eU50yyTUYyRzwWDtYfu+
         emLNRcNMgoVzfpXnk+FuvC+cOUxoUDob63YtrrzyCOKyu2M5EU/hZr7zEHW2qcqhIyFJ
         fk0L+jKbGVMBi1Jctijvj+4b8uRLFP1ptUBdPGafNTCrZ7RNcvowSNim/bgKy/AedT7O
         vFWebXpnXCkQNFaR3S2Tda8gGVyq5VxAqzPD314YUtuMN/7yoWvb+2eEGcu/VkeTUzDv
         J4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R+UtOR8a4UKHM6XF+8O3IvgN2QLGl1j5MHQuVBbeTvE=;
        b=m1mRMepr7cPcKvuxuxZ2Q7tdnCM1eBQF+lwv+WnEQmRz6hj444LMcZdLF4aHcvUOpn
         SVdkm/cf1wvRHLSWEOCMfldTYIkXJJa5C+3G/VpF6r9oUQkFQcOzTCS5ADtKyZnMW1xw
         HtLV+2Z3676CtlkHVPV3N0FCAaeW9RzhXgE0A5+0pX1VBJG0/PxxLjKeRluBzpNRrIDd
         /MvA0aKtWUvUKJEiCI0wjJs50gOZ1eHT2MHOz4DBWd2eglLFYKLVL4vqa38f11AB7kOO
         y1lhmod5AMHrJrX8EhdmeKkG/yRCbWO4xvoWxrejsoU95AGONVZFBlDczqY6f+SLSKwn
         E4Jg==
X-Gm-Message-State: AOAM532j5JFwxTS4aloUuoAAzjYQ8Vd90Q/QAIL+vyjra0oPakRFPFJ4
        88ITVDZhWyE4xBvolDn5V192DzxxVNbpljhd4qc=
X-Google-Smtp-Source: ABdhPJw3Wh68PGnOknL7X8veqQj/gTzRhW4TcSBJ8B8dAF3xHqhDskg+LOaedrGbZEXTmw/bIHLa/z9V6guS/5utdVA=
X-Received: by 2002:a17:902:c407:b0:13d:93aa:8098 with SMTP id
 k7-20020a170902c40700b0013d93aa8098mr574384plk.3.1632947220726; Wed, 29 Sep
 2021 13:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210927145941.1383001-1-memxor@gmail.com> <20210927145941.1383001-12-memxor@gmail.com>
 <ECE882BB-B86B-41CB-AF2A-336DA95A5A4D@fb.com>
In-Reply-To: <ECE882BB-B86B-41CB-AF2A-336DA95A5A4D@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Sep 2021 13:26:49 -0700
Message-ID: <CAADnVQLqYyNhPuM6oFg_vp2ETvad06qS6u9_AiA+2DzVDku8yg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 11/12] bpf: selftests: Fix fd cleanup in get_branch_snapshot
To:     Song Liu <songliubraving@fb.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 4:58 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Sep 27, 2021, at 7:59 AM, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >
> > Cleanup code uses while (cpu++ < cpu_cnt) for closing fds, which means
> > it starts iterating from 1 for closing fds. If the first fd is -1, it
> > skips over it and closes garbage fds (typically zero) in the remaining
> > array. This leads to test failures for future tests when they end up
> > storing fd 0 (as the slot becomes free due to close(0)) in ldimm64's BTF
> > fd, ending up trying to match module BTF id with vmlinux.
> >
> > This was observed as spurious CI failure for the ksym_module_libbpf and
> > module_attach tests. The test ends up closing fd 0 and breaking libbpf's
> > assumption that module BTF fd will always be > 0, which leads to the
> > kernel thinking that we are pointing to a BTF ID in vmlinux BTF.
> >
> > Cc: Song Liu <songliubraving@fb.com>
> > Fixes: 025bd7c753aa (selftests/bpf: Add test for bpf_get_branch_snapshot)
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>
> Thanks for the fix!
>
> Acked-by: Song Liu <songliubraving@fb.com>

Applied this fix to bpf-next.
