Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160251C7827
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgEFRkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFRkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 13:40:25 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63D7C061A0F;
        Wed,  6 May 2020 10:40:24 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id f83so2908678qke.13;
        Wed, 06 May 2020 10:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vh69jvYL8rP/gJYqShJHYtuquy/MVM6OccSOU1yzpfM=;
        b=B4QPqqQweo58nFL0vxi+WUePpvQPYG/TSlGtZ9Sd1HRjfcIFh2HQAognvkdVWUXTVm
         oEs/W/9IhBjBLVAtPpdJTfWMjXN9xO9Iz1xkbSuX5HlGQX8ogtTRWHSvwIkkMUmFeF8m
         Z0SIS/LbHzCZqrOFKLOqlvKkNt1EIVzJnoVVcLfDWJRWYbNbVx6repcOw/HL+TRB9/BQ
         bdcupK1paVsDz86ZrzSHP5NoNlrzbGgilTJFC7RmzbqN/LJxU0mjiEXhhyTtRf2YvNU+
         j+WPA2sOIrCWJ5e5AVRztyqvypsHVPzSLQPwCRIKs8x3Gi0IpLjSzmjLguNY97NqJGdy
         W2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vh69jvYL8rP/gJYqShJHYtuquy/MVM6OccSOU1yzpfM=;
        b=SMiK1eh08kEMFLP+UxYDfR/6U1JQ++nWSQftSv+aZbp7AwUT3n2np7pP66d2XkqTqi
         XXTF0dgFEQw/ZYA88XE2dVuNE1UnbtXX5DHTnjthQy5TAG3gxJKnLD0jtUM9Flzxjzmi
         DenDMuSBjOybMcg/itjXFsmZ5ZlIjS74EkAFPNFMYq2fKIU4RXhVFC2zU+WhqkjeG4Qb
         aupJH5U5A9dPEDOgKJZX4Z6AOd84Su1cbWsrteApYm3ytHcsg/wdq1pqeP9xXwmOcDXu
         ndBnUlPNiDKcoNJhW/xVya4G4d1/EKTtue5XOc/6voq9AIhRqqtndOutm6Y9OywxcHJD
         7lEA==
X-Gm-Message-State: AGi0PubZugQgC+PXXc0jNbLoonCTVDoyZ4Jo8OshoF31xaah3E3ttLLq
        qwxWJGI+44jypF09bHhQ1+JqDvoB/ohRzH8mQxw=
X-Google-Smtp-Source: APiQypLz+1zXhNr/M18qHjj5wR/+BYu7IcrllyHeCrwswONCS9cDgP8oWpTqJD+s5/0qSHdDC/0lIT1qbcS1jeoRQTw=
X-Received: by 2002:ae9:e713:: with SMTP id m19mr10162813qka.39.1588786822693;
 Wed, 06 May 2020 10:40:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062604.2048804-1-yhs@fb.com>
In-Reply-To: <20200504062604.2048804-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 May 2020 10:40:11 -0700
Message-ID: <CAEf4BzZyuiei1SxU0snvZLuKJZpOLvDrqJEidVy=BFY9wcZJZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 15/20] bpf: support variable length array in
 tracing programs
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 3, 2020 at 11:27 PM Yonghong Song <yhs@fb.com> wrote:
>
> In /proc/net/ipv6_route, we have
>   struct fib6_info {
>     struct fib6_table *fib6_table;
>     ...
>     struct fib6_nh fib6_nh[0];
>   }
>   struct fib6_nh {
>     struct fib_nh_common nh_common;
>     struct rt6_info **rt6i_pcpu;
>     struct rt6_exception_bucket *rt6i_exception_bucket;
>   };
>   struct fib_nh_common {
>     ...
>     u8 nhc_gw_family;
>     ...
>   }
>
> The access:
>   struct fib6_nh *fib6_nh = &rt->fib6_nh;
>   ... fib6_nh->nh_common.nhc_gw_family ...
>
> This patch ensures such an access is handled properly.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/btf.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>

[...]
