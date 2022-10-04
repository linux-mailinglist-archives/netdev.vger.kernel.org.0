Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1911B5F3A4E
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiJDADe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJDADd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:03:33 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E07AE43;
        Mon,  3 Oct 2022 17:03:31 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id l22so15259413edj.5;
        Mon, 03 Oct 2022 17:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nKw3PAl2CziDBlSjzgsyHP8+8poJPSVq7n6zdHM4owU=;
        b=eAsxsCEVPXZQk3vcEbdQOxgDfKVJm/cKFQDZ90mvc0BgKunIfC1i66JJNmpWaAIpor
         spEB3DfKArhVd5vM/W92UdyivhwB9YlzLEWpZGM68c5nyciODSS1iEpZpz8vgGdW75Wy
         nbz9rKTr7OaqitxEWPRzKGiP66++Tjfc34hMJ0zVQ/Bmfg3c+deXsqDPS0qeWPg4o7u7
         2+DcDxIs9JHTMTsE71F2xTa78GQmv8ne3BK6adQ+bTYJIcL27rQqPdOtMO35bO68ieSX
         suv6M4D3Avs0CUv2mJVnquMgnShmAN3emHlIgk5hlniB4iwSVpSVMI6MdFIMOK9g25YW
         cXfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nKw3PAl2CziDBlSjzgsyHP8+8poJPSVq7n6zdHM4owU=;
        b=Fi2FOavlhAXqS5UyXi672iYItItQJEHAcV+Ak4mjV5tNkFNWqFD+wviQehqsC2m7+J
         gybgifWyBZ3xASn18uWNk0iveYnD/Ew7AIbrO9rTzLK61i4UwKwKvIHwQvLhc/lmLvgp
         h3Cn5aOMWSZF9LHPxIQbew2W5jbonHu3MoLbZIxzC6IsvwI6y9fSq9Bz0Q7+R2t7AQi8
         GvfiBFuOBz/F9FjYLTbyHUo9TIhBB8GjpUQuT86n7Ghkv5J/qcWlWXMi1r/zc8no+yL+
         CGXW77V76oQduyxhhLaeQgseTm9MCNcBRYJA/zafXfQDwtxmEOzhjn8jdDcXSmB7gkbN
         rVRw==
X-Gm-Message-State: ACrzQf2uD9roI5AfxQFi7xyrWbVU9RIVb6LjXVbYAGNMAzI8pxtyHbYM
        fxL1Cy/dum7lwoTuXtVQwCd2DteCCIGqLKnwG3U=
X-Google-Smtp-Source: AMsMyM5ez28Z3vMHz9qsT95GqacRSDJqi6IFx0C4A9gN5yq0Wc9YmTK4Y2KBwBXmspvDGcTNNB/QYBtS/6o1GO7frYk=
X-Received: by 2002:a05:6402:518e:b0:452:49bc:179f with SMTP id
 q14-20020a056402518e00b0045249bc179fmr21269320edd.224.1664841810223; Mon, 03
 Oct 2022 17:03:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220930110900.75492-1-asavkov@redhat.com> <CAEf4BzZpkgXi9Y6x-_-6mDDW12GvTj0Y_e7cpQMqF3dtiBBhpA@mail.gmail.com>
 <YzqHmHRjxAc4Nndc@samus.usersys.redhat.com>
In-Reply-To: <YzqHmHRjxAc4Nndc@samus.usersys.redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 Oct 2022 17:03:18 -0700
Message-ID: <CAEf4BzZaGvXM7Vquc=SEM3-cD=s_gfX1jadm4TsGxHnsLG4daw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: make libbpf_probe_prog_types
 testcase aware of kernel configuration
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbenc@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 2, 2022 at 11:56 PM Artem Savkov <asavkov@redhat.com> wrote:
>
> On Fri, Sep 30, 2022 at 04:06:41PM -0700, Andrii Nakryiko wrote:
> > On Fri, Sep 30, 2022 at 4:09 AM Artem Savkov <asavkov@redhat.com> wrote:
> > >
> > > At the moment libbpf_probe_prog_types test iterates over all available
> > > BPF_PROG_TYPE regardless of kernel configuration which can exclude some
> > > of those. Unfortunately there is no direct way to tell which types are
> > > available, but we can look at struct bpf_ctx_onvert to tell which ones
> > > are available.
> > >
> > > Signed-off-by: Artem Savkov <asavkov@redhat.com>
> > > ---
> >
> > Many selftests assume correct kernel configuration which is encoded in
> > config and config.<arch> files. So it seems fair to assume that all
> > defined program types are available on kernel-under-test.
>
> Ok. Wasn't sure if this is the assumption being made.
>
> > If someone is running selftests under custom more minimal kernel they
> > can use denylist to ignore specific prog type subtests?
>
> Thanks for the suggestion. Denylist is a bit too broad in this case as
> it means we'll be disabling the whole libbpf_probe_prog_types test while
> only a single type is a problem. Looks like we'll have to live with a
> downstream-only patch in this case.

Allow/deny lists allow to specify subtests as well, so you can have
very granular control. E.g.,

[vmuser@archvm bpf]$ sudo ./test_progs -a 'libbpf_probe_prog_types/*SK*'
Failed to load bpf_testmod.ko into the kernel: -22
WARNING! Selftests relying on bpf_testmod.ko will be skipped.
#96/8    libbpf_probe_prog_types/BPF_PROG_TYPE_CGROUP_SKB:OK
#96/14   libbpf_probe_prog_types/BPF_PROG_TYPE_SK_SKB:OK
#96/16   libbpf_probe_prog_types/BPF_PROG_TYPE_SK_MSG:OK
#96/21   libbpf_probe_prog_types/BPF_PROG_TYPE_SK_REUSEPORT:OK
#96/30   libbpf_probe_prog_types/BPF_PROG_TYPE_SK_LOOKUP:OK
#96      libbpf_probe_prog_types:OK
Summary: 1/5 PASSED, 0 SKIPPED, 0 FAILED


As you can see each program type is a subtest, so you can pick and
choose which ones to run.

>
> --
>  Artem
>
