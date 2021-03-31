Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF4034FD61
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 11:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhCaJoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 05:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbhCaJoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 05:44:04 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5691AC061574;
        Wed, 31 Mar 2021 02:44:04 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso927416pjb.4;
        Wed, 31 Mar 2021 02:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1NaGZElvCoRWL/RIn8TQFlNEAVOA5Cl0KeXtUDOHtaw=;
        b=Yxl51jwe+G2xZh4UwJgg+DJZfGaCdDWxAcwbTRDVEUi4lTQUfrkjix++jmLmndiABA
         ZFaXdVp/22JqBjWgC+/24UIrS0LJkpsP4QWmGWZ8JrIxbVLcN+V16cBLl27PqxZIQ6ts
         EK69F7IHu5/07I2YM9BpsI2ZmVSINBG4KQKX7u9UYYM1LWiOZ99zplpm6ZSAfunsnwa/
         1RimpyU2S05Qca/3mWYJCOtMC2AR+bMcqH/Tje1IF7HiLRnBcUJyGU/dmP0thSURBuhm
         4hSL3pvC3QkvNsc7BVhR7FNHvxm98a8cCq43F7+boR1ZMDUCc/J0FaF/rVfvjAsbSoSn
         c82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1NaGZElvCoRWL/RIn8TQFlNEAVOA5Cl0KeXtUDOHtaw=;
        b=LP8l/pu+YB9wmwQkdWVEMaXI4pU/7ouaYQr+H7w1J7T/LqURjh7f15uIYTgFMxptqD
         882mqH35b+Gi7xWz78CPMRUSX4wxrA3CVQ3SpJkA/kdjx2asHZ+Fh2s0rSOS5HT/QfwX
         Eh///iK11j+N+71ITSD/gD8aDdzQVimxeor03j+XXOKxZs//J7lrTq2kZxl595krnbPe
         r0QZ/VI283ONXoPLgPzWWq6i76sIuURLnnVwwsXLoco9FSu2cMGvqQov3Qsj4ZPCokSc
         U4jZM1Mefo2zFHF8iWeIxzilfUiEZGxwV/o28XAKc3Ov9Bz9i2stsseAJUv/clw+Hz2i
         eH0g==
X-Gm-Message-State: AOAM533y0mqJFp5xEPNbu/ACI3e7ksPklDFm9uZHkLpB2OzgfMebTKrZ
        Raii4De8JmEtGr2qkcAE0Map03FF2TMuMg==
X-Google-Smtp-Source: ABdhPJxzGzP4jeu2pPtaEkQ6GK5CyfLaNvqI0W3TTAjX1IMytZ8sEISjBgHQVfNT+qws6L1cgd+oCw==
X-Received: by 2002:a17:902:ed84:b029:e7:1f2b:1eb4 with SMTP id e4-20020a170902ed84b02900e71f2b1eb4mr2460736plj.74.1617183843799;
        Wed, 31 Mar 2021 02:44:03 -0700 (PDT)
Received: from localhost ([47.9.181.160])
        by smtp.gmail.com with ESMTPSA id j26sm1708923pfn.47.2021.03.31.02.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 02:44:03 -0700 (PDT)
Date:   Wed, 31 Mar 2021 15:14:00 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
Message-ID: <20210331094400.ldznoctli6fljz64@apollo>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-4-memxor@gmail.com>
 <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo>
 <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 02:55:47AM IST, Daniel Borkmann wrote:
> Do we even need the _block variant? I would rather prefer to take the chance
> and make it as simple as possible, and only iff really needed extend with
> other APIs, for example:

The block variant can be dropped, I'll use the TC_BLOCK/TC_DEV alternative which
sets parent_id/ifindex properly.

>
>   bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS});
>
> Internally, this will create the sch_clsact qdisc & cls_bpf filter instance
> iff not present yet, and attach to a default prio 1 handle 1, and _always_ in
> direct-action mode. This is /as simple as it gets/ and we don't need to bother
> users with more complex tc/cls_bpf internals unless desired. For example,
> extended APIs could add prio/parent so that multi-prog can be attached to a
> single cls_bpf instance, but even that could be a second step, imho.
>

I am not opposed to clsact qdisc setup if INGRESS/EGRESS is supplied (not sure
how others feel about it).

We could make direct_action mode default, and similarly choose prio
as 1 by default instead of letting the kernel do it. Then you can just pass in
NULL for bpf_tc_cls_opts and be close to what you're proposing. For protocol we
can choose ETH_P_ALL by default too if the user doesn't set it.

With these modifications, the equivalent would look like
	bpf_tc_cls_attach(prog_fd, TC_DEV(ifindex, INGRESS), NULL, &id);

So as long as the user doesn't care about other details, they can just pass opts
as NULL.

WDYT?

> Thanks,
> Daniel

--
Kartikeya
