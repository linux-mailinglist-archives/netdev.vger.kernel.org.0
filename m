Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33511B915B
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 17:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgDZP7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 11:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725778AbgDZP7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 11:59:23 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41351C061A0F;
        Sun, 26 Apr 2020 08:59:23 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z1so5850757pfn.3;
        Sun, 26 Apr 2020 08:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HY2QrtJfuakBtI8nw469bt0EcF9+HMSKIhzeXGmvBlw=;
        b=sweOJTWxrz83LkXXuALfDxaULebLf1C0TM3FdGpeTvkmoOyHQCpJL/Dn9LkJf6FodI
         2mzW2LUoyk97FGavQ9RazBjKYqdZ/SyYpSdOfm8vT5sRQPRiwbGZS+zM7LtPHhXzsBDa
         BVIvVRvAkizMDVvYGCHp0zFv4BUxOh2aAI6GmUrrKXN9SQPLiW9pu3k1pQZcuIsYqHQY
         8J0mZx5tJbMPSAlr02pDuFcQfsR9m4UsyW1/OF/YNA1ZhtMG3z2cO/yOp5xkq/GNrnbU
         00d8a8cgDlQn0sbcD3lg+DI+f3bgehw0OT22T01H9ivUzz0ntxhwuJyR99OmoGQRbAqG
         U1Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HY2QrtJfuakBtI8nw469bt0EcF9+HMSKIhzeXGmvBlw=;
        b=Clkr9yjqhqM6bMxhj9JQihQMkqc2USL0Im/JLcT+BExGX6hFct17zS3FD5pC8UYYG1
         kDwzGFgq+Bx/ElPwMqCQRR6JajrzIIfAjcefaWdRasdVYu9a627ITnP1utUHHygF6sdr
         e4v7FdNJt17I9HK72iqf7dH/iMOE5b/k2is2ctG1pzYFEMChmbeByS6Nelqdo/dWilcH
         fF5pto9GeVNzAsyU2ffMhtYjKZTmncw2CSX2cD7EQDqpkiSkjFOXLXHsMYqtw/aXOf8E
         fn6wRNXmW7ZkaYVSE2QOkRXaZPG6YERlKxRyYZ2x+mqjCPUXNic9t2E01lqZ8Om6DbSz
         c+Jg==
X-Gm-Message-State: AGi0Pua5wImLJLeFhB/D+6aIZJXrTI9IqH5UsFqw2dGj6OjlBBBca9QD
        e9O3bwtcccQ8Q+ZTMsZdmqkOBB4N
X-Google-Smtp-Source: APiQypL7SrA0mhjVzqqIP7RVtWqCQ2eI/RnnIiTMd2RKx3tYjpPvoA9XrGnRW1Q23l9Q6whBXQcJZQ==
X-Received: by 2002:a65:6882:: with SMTP id e2mr4296711pgt.170.1587916762813;
        Sun, 26 Apr 2020 08:59:22 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:9db4])
        by smtp.gmail.com with ESMTPSA id s13sm10069023pfm.62.2020.04.26.08.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 08:59:22 -0700 (PDT)
Date:   Sun, 26 Apr 2020 08:59:20 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next] bpf: fix missing bpf_base_func_proto in
 cgroup_base_func_proto for CGROUP_NET=n
Message-ID: <20200426155920.g7gfzt5w6crxmvev@ast-mbp>
References: <20200424235941.58382-1-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424235941.58382-1-sdf@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 04:59:41PM -0700, Stanislav Fomichev wrote:
> linux-next build bot reported compile issue [1] with one of its
> configs. It looks like when we have CONFIG_NET=n and
> CONFIG_BPF{,_SYSCALL}=y, we are missing the bpf_base_func_proto
> definition (from net/core/filter.c) in cgroup_base_func_proto.
> 
> I'm reshuffling the code a bit to make it work. The common helpers
> are moved into kernel/bpf/helpers.c and the bpf_base_func_proto is
> exported from there.
> Also, bpf_get_raw_cpu_id goes into kernel/bpf/core.c akin to existing
> bpf_user_rnd_u32.
> 
> [1] https://lore.kernel.org/linux-next/CAKH8qBsBvKHswiX1nx40LgO+BGeTmb1NX8tiTttt_0uu6T3dCA@mail.gmail.com/T/#mff8b0c083314c68c2e2ef0211cb11bc20dc13c72
> 
> Fixes: 76800cfc27c6 ("bpf: Enable more helpers for BPF_PROG_TYPE_CGROUP_{DEVICE,SYSCTL,SOCKOPT}")
> Cc: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied, Thanks
