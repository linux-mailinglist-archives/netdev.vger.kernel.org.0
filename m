Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FE63E8348
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 20:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhHJSyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 14:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhHJSys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 14:54:48 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF4BC0613C1;
        Tue, 10 Aug 2021 11:54:25 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id r72so277115iod.6;
        Tue, 10 Aug 2021 11:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=VD0aZrnuCOe2NBtCZgekxjz8LxFzgKjYPfV0fPq6o94=;
        b=gZLGwRBZSvHIk4e7F9G/AKqPTLBn/3+CgCLfuxQkgBpsrD38iUgZ2k+76lNjm/NhDF
         4xHVftLzO5zWCUX4eyvE6PUKL6YJJG77MoOqypeINCHtUYJHSpkluD5sWnxVGZCHFpZK
         UmYWrkWeulyaocXTV1QVUZ9WZfjdODn6YSoJ9EsZgZlSMJ+exmd0IdSs0SNfxI6I7vGs
         5qZgB/Yz3c3ZwHa2cCIJEEzyuFLzmLEDb5+slWiw5ntxE3ehDkw7YhdmJRGywa44m+F5
         FYBjarz+4rgyTm/aAOs0lzyHU0PK0m5bZfYlbNY3wGGYNBPV5ixq3mzBJl1ef7+pb5NV
         xKKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=VD0aZrnuCOe2NBtCZgekxjz8LxFzgKjYPfV0fPq6o94=;
        b=A8nnjXPg2lyThKEv/zBP3E4f8EAt2E4ICSrHoB8NRLgaiTx8k3PJDKrLZ05xCa8zwt
         /YS2kosyJR3qpfMHIZToN52ttw7e9dTN04R2Qu6DVc5arKUW0fT3/SvNcpDhMHZqO7GU
         b1k2/YLi45v8EqueIFwEIM+NLBuEYV9zuqZYZEKtuNUE8F0drO9Ned5xinYKq6v0/jqt
         4b44oVjuAXqAIkwrHZRisjkYB2mZm/wc8nv3Egagg9x1lQd0IXk+fkoUs/tkmaBzI7NT
         4H8AcrY6ianrsBaI/yz7Oue+Vg3WfbqE9HbP5IfcQMVcjYAfW/ut1o67xJCROw5iO2FJ
         lw1Q==
X-Gm-Message-State: AOAM532FIWf88tkDhVN1WeIls+/F7Vov6+/ZH7+RZ1kwqOs2mDz86ZYM
        k5tCyQPcFh/LaEmcorC6tl0=
X-Google-Smtp-Source: ABdhPJw03Q62oYxzkuLNuVPqy40evbAYGeqE0xFOXf6jYfhi9Fs3GS0D4hH5ig/Zhzbpl/4LMv5fhw==
X-Received: by 2002:a05:6638:358b:: with SMTP id v11mr16180462jal.128.1628621665411;
        Tue, 10 Aug 2021 11:54:25 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id c5sm2979748ioz.25.2021.08.10.11.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 11:54:24 -0700 (PDT)
Date:   Tue, 10 Aug 2021 11:54:17 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jiang Wang <jiang.wang@bytedance.com>, netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Message-ID: <6112cb598ecc1_1c2c8208d4@john-XPS-13-9370.notmuch>
In-Reply-To: <20210809194742.1489985-1-jiang.wang@bytedance.com>
References: <20210809194742.1489985-1-jiang.wang@bytedance.com>
Subject: RE: [PATCH bpf-next v6 0/5] sockmap: add sockmap support for unix
 stream socket
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiang Wang wrote:
> This patch series add support for unix stream type
> for sockmap. Sockmap already supports TCP, UDP,
> unix dgram types. The unix stream support is similar
> to unix dgram.
> 
> Also add selftests for unix stream type in sockmap tests.
> 
> 
> Jiang Wang (5):
>   af_unix: add read_sock for stream socket types
>   af_unix: add unix_stream_proto for sockmap
>   selftest/bpf: add tests for sockmap with unix stream type.
>   selftest/bpf: change udp to inet in some function names
>   selftest/bpf: add new tests in sockmap for unix stream to tcp.

For the series.

Acked-by: John Fastabend <john.fastabend@gmail.com>
