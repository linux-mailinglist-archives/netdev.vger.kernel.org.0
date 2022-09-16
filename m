Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC945BB3B6
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 22:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiIPU74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 16:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIPU7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 16:59:55 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327F125C52;
        Fri, 16 Sep 2022 13:59:52 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d8so15444948iof.11;
        Fri, 16 Sep 2022 13:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=RTjHwZzVFFIPsI+xjg1bVcHgu8K60VOSv7DG5lHU+jc=;
        b=VJLRbUX+BAArnP3l2mLbXpMxM26Hh/3Ptv6M2kHFWv8XmNzI0Ll1RcytluI17ij1R/
         mFsD6Kxl0JiubuV/81k5D9pJ52DxbXc6bWnCHvfZhz+vLNjmac37Y6YJ0c+CRFjw2IY+
         efLIINQ8Rz35+13GdyF3kI048UIET+D0fLnGzZGzd/HqYw0VGHIOPeoerQzwMnfDS2GI
         MqBMfmiqXT3hQEwtcHSHVvttvgxFTBshC//qYwKFkr0iLxvvZuniNMEG6W5+dzhhTodO
         OpWGhRbTLBrifQE3GnZh3DRlXcQUhk9A8pCP5Yn8BbhjIYcvO9tIDDj+O5imrJ3cvwO9
         p9Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=RTjHwZzVFFIPsI+xjg1bVcHgu8K60VOSv7DG5lHU+jc=;
        b=jP7jUL8zBCguFNx/11lUtES8i660cRNMtHuqcqVV/yQROyYL6oddengCMb2vtXFolY
         UEYaL+SyNaqVZqvpkqL9tTgKR9JfqO1ebsmsCRqJmiWYhQkemmx1sWz/tb6ROxrqRv22
         6tVTcTp3i2wuHmoJbr/uywolBilgIOYI0xAYBIJ433sVzn1uFLpMESnW9JCE4IBOc8Xp
         Scg4+hEmZGVlxAVv/r65J9qjci4mC055zeEnxtoYtefPgtMajj9+aODvDEkHMFWyt8lw
         LMStrlrNRT4Xny2Ebh41q7MwqRvCq6/kNG/KleEN2MH4bMhDKZ4YbOV6FvQf06tKmYp0
         biqQ==
X-Gm-Message-State: ACrzQf0BhJ7du365AD3n3nrRS9gqhjKkqEcBIocUZgFlBysSpaH8HBYx
        vJwI/UTE8SnWJV/M9X1VD6+uZJUB3+/21D/aYwU=
X-Google-Smtp-Source: AMsMyM7xZVZYYciCNObsvBYXiU1tVmTWTvhv+YFfsT0pRUF1Qaks/NY2smiUCw/hI2fnweKRkqLYh34npPT6SLYXXac=
X-Received: by 2002:a6b:670b:0:b0:6a0:d9db:5ae5 with SMTP id
 b11-20020a6b670b000000b006a0d9db5ae5mr2617836ioc.62.1663361991525; Fri, 16
 Sep 2022 13:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220905193359.969347-1-toke@redhat.com> <5e97c1e8-e7e4-27c4-aee7-ffa5958c6144@iogearbox.net>
In-Reply-To: <5e97c1e8-e7e4-27c4-aee7-ffa5958c6144@iogearbox.net>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 16 Sep 2022 22:59:15 +0200
Message-ID: <CAP01T755oQVY+ySm+SEh+xDgbYURTFa8AdLHsoE1M-aS15npKg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/3] A couple of small refactorings of BPF
 program call sites
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Sept 2022 at 22:58, Daniel Borkmann <daniel@iogearbox.net> wrote=
:
>
> On 9/5/22 9:33 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Stanislav suggested[0] that these small refactorings could be split out=
 from the
> > XDP queueing RFC series and merged separately. The first change is a sm=
all
> > repacking of struct softnet_data, the others change the BPF call sites =
to
> > support full 64-bit values as arguments to bpf_redirect_map() and as th=
e return
> > value of a BPF program, relying on the fact that BPF registers are alwa=
ys 64-bit
> > wide to maintain backwards compatibility.
>
> Looks like might still be issues on s390 [0] around retval checking, e.g.=
:
>
>    [...]
>    #122     pe_preserve_elems:FAIL
>    test_raw_tp_test_run:PASS:parse_cpu_mask_file 0 nsec
>    test_raw_tp_test_run:PASS:skel_open 0 nsec
>    test_raw_tp_test_run:PASS:skel_attach 0 nsec
>    test_raw_tp_test_run:PASS:open /proc/self/comm 0 nsec
>    test_raw_tp_test_run:PASS:task rename 0 nsec
>    test_raw_tp_test_run:PASS:check_count 0 nsec
>    test_raw_tp_test_run:PASS:check_on_cpu 0 nsec
>    test_raw_tp_test_run:PASS:test_run should fail for too small ctx 0 nse=
c
>    test_raw_tp_test_run:PASS:test_run 0 nsec
>    test_raw_tp_test_run:FAIL:check_retval unexpected check_retval: actual=
 0 !=3D expected 26796
>    test_raw_tp_test_run:PASS:test_run_opts 0 nsec
>    test_raw_tp_test_run:PASS:check_on_cpu 0 nsec
>    test_raw_tp_test_run:FAIL:check_retval unexpected check_retval: actual=
 0 !=3D expected 26796
>    test_raw_tp_test_run:PASS:test_run_opts 0 nsec
>    test_raw_tp_test_run:PASS:check_on_cpu 0 nsec
>    test_raw_tp_test_run:FAIL:check_retval unexpected check_retval: actual=
 0 !=3D expected 26796
>    test_raw_tp_test_run:PASS:test_run_opts should fail with ENXIO 0 nsec
>    test_raw_tp_test_run:PASS:test_run_opts_fail 0 nsec
>    test_raw_tp_test_run:PASS:test_run_opts should fail with EINVAL 0 nsec
>    test_raw_tp_test_run:PASS:test_run_opts_fail 0 nsec
>    [...]
>

Thanks, I'll take a look.

> Thanks,
> Daniel
>
>    [0] https://github.com/kernel-patches/bpf/actions/runs/3059535631/jobs=
/4939404438
