Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6F369DCE5
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbjBUJ0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbjBUJ0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:26:44 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD91025BA3
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:26:15 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id eg37so10587798edb.12
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=bixUIsGJDfGo1abl+ruQ/sGhtiLhGVJNIEz/N2FYZqM=;
        b=FfTjz2QLdNwM6RmEUbv6AeF1gjmXl/D1h/tFbesU/P/KQeaTDfKfpSEGBVfJlg0JWK
         zNxBIUwsTWvZmD55wb/7/z+VN4LUrCcNS/d8GASd9LLse1UTC4xod2uM4a7VVczKGlQP
         RAWR2WLe24BTtLvLOzjredw1AwPRmcfpeUPkg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bixUIsGJDfGo1abl+ruQ/sGhtiLhGVJNIEz/N2FYZqM=;
        b=bA9E5Y66IFkK0zroPmGGvnPEbpNuv20IdFNTn7SKJmIUDT+h1n74vEGX/jt3ttAb90
         dPkz1lWlYVo3A2h6U496x+OfqLFSxXYGAGrbbrfyQ2N7ajMDObLgXRstnVaVmNUaP12U
         6svXsTHIX2Gv9COy/0xBsILfW9NY6lmtpF2F8c8IAJUqGUl4HL32zxcOyCjpAFOW+cpV
         c49/BsXy2jkTwkPg1FtElypVGc0k3AOKGpgqD0lVNGtXELy/57qFVLv5s2gHc/QS02iT
         udgqJ/1Z9xHp82DRBZb1/QMD9D2O+RycJXMhxETTqQkaB7ffmbn66LhiJb8gdBPMbda1
         pJpQ==
X-Gm-Message-State: AO0yUKXG5ghQ0qC9R1W/lV6y1AX25b+tnoiXywhgzYS3rHKnKXCNIdMv
        sWPDOg5s8i6kHkzaAW3f3SUsQQ==
X-Google-Smtp-Source: AK7set+XtneOb27Y5l0Rl0ChB5xAEtQc9sVAYL87fl4pX61KxAqVl4/F4ICB84EXPYz5cHqu5VttLQ==
X-Received: by 2002:aa7:d8d9:0:b0:4ac:b2dc:8d55 with SMTP id k25-20020aa7d8d9000000b004acb2dc8d55mr5021988eds.14.1676971573567;
        Tue, 21 Feb 2023 01:26:13 -0800 (PST)
Received: from cloudflare.com (79.184.206.151.ipv4.supernova.orange.pl. [79.184.206.151])
        by smtp.gmail.com with ESMTPSA id d25-20020a50cd59000000b004acd42c8be5sm2912629edj.90.2023.02.21.01.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 01:26:12 -0800 (PST)
References: <20230211201954.256230-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
Subject: Re: [Patch net-next] sock_map: dump socket map id via diag
Date:   Tue, 21 Feb 2023 10:11:12 +0100
In-reply-to: <20230211201954.256230-1-xiyou.wangcong@gmail.com>
Message-ID: <871qmjjrnx.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 11, 2023 at 12:19 PM -08, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> Currently there is no way to know which sockmap a socket has been added
> to from outside, especially for that a socket can be added to multiple
> sockmap's. We could dump this via socket diag, as shown below.
>
> Sample output:
>
>   # ./iproute2/misc/ss -tnaie --sockmap
>   ESTAB  0      344329     127.0.0.1:1234     127.0.0.1:40912 ino:21098 sk:5 cgroup:/user.slice/user-0.slice/session-c1.scope <-> sockmap: 1
>
>   # bpftool map
>   1: sockmap  flags 0x0
>   	key 4B  value 4B  max_entries 2  memlock 4096B
> 	pids echo-sockmap(549)
>   4: array  name pid_iter.rodata  flags 0x480
> 	key 4B  value 4B  max_entries 1  memlock 4096B
> 	btf_id 10  frozen
> 	pids bpftool(624)
>
> In the future, we could dump other sockmap related stats too, hence I
> make it a nested attribute.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Sorry for not replying sooner. This sounds useful. Another use case I
can see here is inspecting process' sockets:

1. get a dup FD with pidfd_getfd()
2. query sock_diag by socket cookie
3. find out which maps socket is in.


I don't know if it makes sense to tie the naming to sockmap. We also
have also map type that can hold socket references -
REUSEPORT_SOCKARRAY.

We might want to add sock_diag support for REUSEPORT_SOCKARRAY in the
future as well. So a map-type-agnostic name for the new inet_diag ext
might be more future proof. Like INET_DIAG_BPF_MAP.


Also, can you please add a simple selftest? They often serve as the only
documentation for the features. Perhaps in
tools/testing/selftests/bpf/prog_tests/sockmap_basic.c.

Thanks,
Jakub
