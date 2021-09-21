Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813DE412E18
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 06:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhIUE4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 00:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbhIUE4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 00:56:46 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F66C061574;
        Mon, 20 Sep 2021 21:55:18 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u18so19679360pgf.0;
        Mon, 20 Sep 2021 21:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kyMqG0Lw3xYh7uzBfdbzcQjfQoXy6M6rxbpqtvM5/TQ=;
        b=ZM85ilT342mLJBrCU/VnSgGy0DKPuHlL5rbxnLzdrMzs9eiTCbpUCo/o4trLB+wv2/
         avZK9EmoJf7aUVatOPqZrzLHspKkqOWhSLC1qNkeX1FpTwDuVyTnAnRJIk8Mu/2gRRxx
         VTkBWc1W9CE/q062hPNyMl9KlZakbG/UyEWTO9wB0f0rWtMUHuL0s2YIlQCQi/k+WzFd
         lQbzXRUeRSWfuZ5wxHHX2vJYzJXfb/AZEZuIgMFiLzO037LumT+/+DnX1dnN41GwXCle
         +rH0QvtHzmljehVyq340qLvscTYqK0TOyL4eu92DS5dQNGhf1sDJPGZaA8RvzWRaXDga
         kOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kyMqG0Lw3xYh7uzBfdbzcQjfQoXy6M6rxbpqtvM5/TQ=;
        b=qlUVegbkyxLJf9/oWvrHigmBdktndy1jTllJKnRV6XopF5n5Vnaxf3F5TZ4DH6byr6
         aSsR/xCopXWP9dzxB9by2qaEvhDMhHzlg4XsLCuPAj+Udy8CexVtAf0w++HWTSivDEeK
         O4q6bKXppjEeqapAbUmtbBuE1F/LcM0/iS/yna5G0d7/Ib6tt8AwTAV68XMOWbkEHAtK
         i906DjvJQtxu0LEjGpFS5LvrtacaNVksKzan+7GKsxtJ68ZIc0sE8Zk/Aj7e3YjX5rt7
         rq+AzQs8FMIMRFLVJI/YsJVdFt3uMsbeSM/iPjV1+TXLltvVMLarc0EffpGVYZUDIgw8
         HBTQ==
X-Gm-Message-State: AOAM532GzhTA1EQudsYr9TFHv0FndwX5L6FUFVlphdt3jEV6pC/lQRrl
        o5CDLzslq4bcUWO2HpKvb2Yw0cw5Af5N5Q==
X-Google-Smtp-Source: ABdhPJxs0kZ3Jf1qOzyQVHBrfU2afwti9ssGu/zqpjrtEHoOcSetA2dCojjguuZaw+7hnJYaVAqdMQ==
X-Received: by 2002:a62:d41e:0:b0:447:53ac:9e39 with SMTP id a30-20020a62d41e000000b0044753ac9e39mr13766946pfh.72.1632200118053;
        Mon, 20 Sep 2021 21:55:18 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id q3sm17857093pgf.18.2021.09.20.21.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 21:55:17 -0700 (PDT)
Date:   Tue, 21 Sep 2021 10:25:15 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 00/11] Support kernel module function calls
 from eBPF
Message-ID: <20210921045515.dpn64ok5sd7ezexp@apollo.localdomain>
References: <20210920141526.3940002-1-memxor@gmail.com>
 <CAEf4Bzb1zRX1=VsMtQF9Kee=OGbtcgSrvPT3UhoAz5vsvL=WOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb1zRX1=VsMtQF9Kee=OGbtcgSrvPT3UhoAz5vsvL=WOA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 05:59:22AM IST, Andrii Nakryiko wrote:
> On Mon, Sep 20, 2021 at 7:15 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This set enables kernel module function calls, and also modifies verifier logic
> > to permit invalid kernel function calls as long as they are pruned as part of
> > dead code elimination. This is done to provide better runtime portability for
> > BPF objects, which can conditionally disable parts of code that are pruned later
> > by the verifier (e.g. const volatile vars, kconfig options). libbpf
> > modifications are made along with kernel changes to support module function
> > calls. The set includes gen_loader support for emitting kfunc relocations.
> >
> > It also converts TCP congestion control objects to use the module kfunc support
> > instead of relying on IS_BUILTIN ifdef.
> >
> > Changelog:
> > ----------
> > v3 -> v4
>
> Please use vmtest.sh locally to test everything. That should help to
> avoid breaking our CI ([0]):
>

I'll look into it. There were some problems getting it to run on Arch and
Fedora, so I instead tested in my own VM (GLIBC_2.33 not found).

Surprisingly, everything passed when I ran it before sending. e.g. I still
get this for the two failing tests in CI.

[root@(none) bpf]# ./test_progs -t ksyms_module_libbpf
#66 ksyms_module_libbpf:OK
Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
[root@(none) bpf]# ./test_progs -t module_attach
#81 module_attach:OK
Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

--
Kartikeya
