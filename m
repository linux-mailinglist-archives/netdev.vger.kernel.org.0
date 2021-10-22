Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCEF4379F9
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 17:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhJVPhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 11:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbhJVPhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 11:37:06 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEFEC061764;
        Fri, 22 Oct 2021 08:34:48 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id j6so4452995ila.1;
        Fri, 22 Oct 2021 08:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=n5H9Bf9ZcCtG40Soap2ANs+z3ZAK6GVAhwLSpZUSWec=;
        b=BZDTYMK4Rxq99wt3oQTT9VDAGhX7uLuCcVFpuvTqcHIm54ZyTbTkt98x2ysZJnNCDB
         vx3fbAlM7fxQ+KW79p7FlW2mkY0KN9WdUckx2+xm4rbrRMWdmDti8gULQgpTP9kH1wv7
         5Ht1JHuiBWjUcHA1jmlpkeb8kghz5jzPyesJxfDVy7nKcMHamdg5ia46frs7zTY+C8cS
         2qss4ScebggBeZFbwKPG64LOG2XhgOFfuomRyAZZtiOEkt7Z2PttGd8OCIQOzTOcpp2q
         eCQneacDrQ6Lb7CfgGxXtIZcDLgGKDw8xK9krX7t4gl1eruVcIyYMAmAvlSgNqpKlySm
         0cFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=n5H9Bf9ZcCtG40Soap2ANs+z3ZAK6GVAhwLSpZUSWec=;
        b=B3zMiAbZMg16y4ptk2wR5wLANi3vim352eblTrfB/VmQwCxX3M33D7tz1n0zelmlwM
         DKKc6yuFW+AGVSMXOa76WwheymoyFLzEZ69epzDuAQa8Wz6em0KBLxWxWYJKmeJwXFXq
         C91bIQgpWxPGIB7EfXRl1Res7DfPaSZZ9vlqG+npp3/lvQ1UWUrD8cKkpQIsVvKmgHc5
         DqvoHKFt5IwlajI7Xw9o6JXfPXZiLpCoa5yUUKQ3r2XPy8NW+2rz2inbA9pZ/oAwuc7B
         aJH9DBnoEGfZ9yuN87jFLAulq6JDEFh18WUfOUWTd9tqTmDYbDHDUVqQT7ZYdcn6K41F
         bjdg==
X-Gm-Message-State: AOAM532hiRjZhAnbpyFTERt3lZ+r0LEkT5P5kl252BGLZ8wNsRn4C999
        9geUkZk49Xkd2orfcdkD3d8=
X-Google-Smtp-Source: ABdhPJxYUhGJB+jUFDS/oaJSwUrqOLFdIMm6eNh2dKxmBCkq8HfxtUW1Ye/rjByuUAtzFN8bDwN9Mg==
X-Received: by 2002:a92:de47:: with SMTP id e7mr468500ilr.282.1634916888379;
        Fri, 22 Oct 2021 08:34:48 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id c4sm4392167ioo.48.2021.10.22.08.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 08:34:48 -0700 (PDT)
Date:   Fri, 22 Oct 2021 08:34:40 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <6172da1091904_82a7f20833@john-XPS-13-9370.notmuch>
In-Reply-To: <20211008203306.37525-1-xiyou.wangcong@gmail.com>
References: <20211008203306.37525-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf v4 0/4] sock_map: fix ->poll() and update selftests
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This patchset fixes ->poll() for sockets in sockmap and updates
> selftests accordingly with select(). Please check each patch
> for more details.
> 
> Fixes: c50524ec4e3a ("Merge branch 'sockmap: add sockmap support for unix datagram socket'")
> Fixes: 89d69c5d0fbc ("Merge branch 'sockmap: introduce BPF_SK_SKB_VERDICT and support UDP'")
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> 
> ---
> v4: add a comment in udp_poll()
> 
> v3: drop sk_psock_get_checked()
>     reuse tcp_bpf_sock_is_readable()
> 
> v2: rename and reuse ->stream_memory_read()
>     fix a compile error in sk_psock_get_checked()
> 
> Cong Wang (3):
>   net: rename ->stream_memory_read to ->sock_is_readable
>   skmsg: extract and reuse sk_msg_is_readable()
>   net: implement ->sock_is_readable() for UDP and AF_UNIX
> 
> Yucong Sun (1):
>   selftests/bpf: use recv_timeout() instead of retries
> 
>  include/linux/skmsg.h                         |  1 +
>  include/net/sock.h                            |  8 +-
>  include/net/tls.h                             |  2 +-
>  net/core/skmsg.c                              | 14 ++++
>  net/ipv4/tcp.c                                |  5 +-
>  net/ipv4/tcp_bpf.c                            | 15 +---
>  net/ipv4/udp.c                                |  3 +
>  net/ipv4/udp_bpf.c                            |  1 +
>  net/tls/tls_main.c                            |  4 +-
>  net/tls/tls_sw.c                              |  2 +-
>  net/unix/af_unix.c                            |  4 +
>  net/unix/unix_bpf.c                           |  2 +
>  .../selftests/bpf/prog_tests/sockmap_listen.c | 75 +++++--------------
>  13 files changed, 58 insertions(+), 78 deletions(-)
> 
> -- 
> 2.30.2
> 

For the series. Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
