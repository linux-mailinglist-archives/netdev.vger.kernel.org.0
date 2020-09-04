Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8053D25CED5
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 02:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgIDAo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 20:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgIDAo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 20:44:28 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F9AC061244;
        Thu,  3 Sep 2020 17:44:27 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id r13so5982960ljm.0;
        Thu, 03 Sep 2020 17:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7BNByuK92WXGBAUcJkVmd0zva9gBrONI14HqKJZkXpA=;
        b=HgoYhjSRK8RPFOOdTg/xJAEEmnA9ibxrAnHA6z+nrC7OZPjh7VxibmqR3Yn9N6ZwjX
         kQRmI5xEVPle5xXSQdZiNWVght8dwAfRUt0FBkihe1Fd6vodYX5vhGqpNYXuAjtxOlXg
         Nq7aztFkfuxr4jQc/luPscleQKKIvqfDPh56x3nRR7/P5VFbYzo7xkw5pLBQCL/q4Vtp
         fqW08Ah4WaDjAYKrWc02gJuhNyVTrjwbE6ibnwOxFe+uw8598yjCFj7leZMjQXgFCo9J
         uutRkdxL0WZ5TpxCNdcC4oK3+Y0LtCeyLNO2z4azaEeS6zPl1GYms3GCy2xKJz/BsXwg
         Y25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7BNByuK92WXGBAUcJkVmd0zva9gBrONI14HqKJZkXpA=;
        b=i2vBpdoLySvur9wwcppkGafP7JoQbO9O0B1sfC980dascFh/y19dyek2iu73c8FlWY
         LwxILMil0Q9dqpK1s/k0Uv48tujpBQM9ylMmtKi4W17SV1as93CrDcRx7O36Yf731dqV
         K80QZpJQkwc+949EEEa63fQDupaJZpFPcpVXWyE1Qj+WGjtCeW1HFAtFvxjHU0QStQ+4
         /hloVGG8R7zG2jiTDrVtTFXtETfum1eKaksficcCI+PXva2NPRjm2IJpr3GDAlMFY+6z
         qSY5Pyi8MF3Ygx1rAUnrcvW5Mp+2me39VDu6zdG0X0fb0b5y/ePC2OgWqEhSWEBg0e1J
         yJXQ==
X-Gm-Message-State: AOAM5323++KywSFHFzqjl0c64WAwICNDcRUr7SlEt7uVdwkO30cy8q0M
        eBbZ8P90gMeyX4eeQmy1M19qR0t302WO1k1zNTA=
X-Google-Smtp-Source: ABdhPJxywhI+DPqJrS/cgDc2IILDCRtlS3lUtind4I3u/04vXXVKMKI4lX58SHXcnJ74WmmdUs9bTeWzTrwoc9Q5JeI=
X-Received: by 2002:a2e:4e09:: with SMTP id c9mr2651636ljb.283.1599180266009;
 Thu, 03 Sep 2020 17:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200902235340.2001300-1-yhs@fb.com>
In-Reply-To: <20200902235340.2001300-1-yhs@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 3 Sep 2020 17:44:14 -0700
Message-ID: <CAADnVQLnPzk2KvkfnmbgnXb2YwPd2jC3mZ5OkOiNaHys-nfo2g@mail.gmail.com>
Subject: Re: [PATCH bpf 0/2] bpf: do not use bucket_lock for hashmap iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 2, 2020 at 4:54 PM Yonghong Song <yhs@fb.com> wrote:
>
> Currently, the bpf hashmap iterator takes a bucket_lock, a spin_lock,
> before visiting each element in the bucket. This will cause a deadlock
> if a map update/delete operates on an element with the same
> bucket id of the visited map.
>
> To avoid the deadlock, let us just use rcu_read_lock instead of
> bucket_lock. This may result in visiting stale elements, missing some elements,
> or repeating some elements, if concurrent map delete/update happens for the
> same map. I think using rcu_read_lock is a reasonable compromise.
> For users caring stale/missing/repeating element issues, bpf map batch
> access syscall interface can be used.
>
> Note that another approach is during bpf_iter link stage, we check
> whether the iter program might be able to do update/delete to the visited
> map. If it is, reject the link_create. Verifier needs to record whether
> an update/delete operation happens for each map for this approach.
> I just feel this checking is too specialized, hence still prefer
> rcu_read_lock approach.
>
> Patch #1 has the kernel implementation and Patch #2 added a selftest
> which can trigger deadlock without Patch #1.

Applied. Thanks
