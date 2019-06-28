Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0585A53E
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfF1TiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:38:10 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36715 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfF1TiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:38:10 -0400
Received: by mail-qk1-f193.google.com with SMTP id g18so5886452qkl.3;
        Fri, 28 Jun 2019 12:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1eNUCxB2pBYag9zn9nPOS4NRyztlAgm8J0XR/5AdRtY=;
        b=rcgtjHpvlX+fqK1TQjnHWaB/w4lX3s7Qp8zBbqL7YvaqhULHurn4mMX8lk8axCByRS
         7aC+qVYUXFl1DlWzAFud65AuUKv7W4yJuQebG6r1rCQF4Lj6T5gofVwXhvPeojs+XVcg
         0TV7eYFWRPyb22x7xi5MGGSjm0xlUtKFsdWIT3iRVcDKcnUozJKfKtvn7Y5msyNd1ZIO
         Oe46xl3/s442E6GtIZn/fXFMbe4Z+P4ibsb8AE1jAwj9bqmS0+3tUvRkIt9UUu5sgSwE
         AJmtWXeYujWJkvmnvwTcOVUMhGbrtMk9JMXlaqVqNpl15t9E3xk38URNyxvgJ3QGTX1X
         3VVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1eNUCxB2pBYag9zn9nPOS4NRyztlAgm8J0XR/5AdRtY=;
        b=sDxWbwkd8Sk0sP9mbzii2HmnHHtgPTrC3BiZRAnYEZqKHMkrmaZQK/i1qbjbwnujE1
         4/F96dGtjsip1qypGZ3hRku2yShuPnc2sCKicfG78bK/v0DzwV8nTEnoU66cQSf6txhS
         9xxoOtC1gr+n3JfRagM7kil5xHTpz8/Yg+khWa+7d5Mx3Z477Z9aWnUIe0oW9BHiI+Kk
         O/VdRnDKQYrAGbZ+4zSLGLqAHbVpBFKmp+27IIPceXklkWxkRNwqnfzM9ja/VKMU5yxz
         U+pmgkgZyvchyBxwOsoyXNeTZqFxPIekeLW5R9Dzt6JnFdF9mkSG4QI5g/rCaF/gwkNQ
         lQoA==
X-Gm-Message-State: APjAAAV8WAqzB1hsGInd9iJvPVgOvnyatMDWAYqrPnP/vSH0PeibRt9h
        ftactZjR5Ra/XaQgnEUEXHGG7nP+PXb085K/Bwk=
X-Google-Smtp-Source: APXvYqyHxghVwpqNZMoIWKbMb4paCVdIbUrKE6k6qHJ5k58k3xwZG/zctpeOXtANiVd5LCQgCI1Cie61kOiSx/gVZbQ=
X-Received: by 2002:a37:5cc3:: with SMTP id q186mr10098866qkb.74.1561750689107;
 Fri, 28 Jun 2019 12:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190628055303.1249758-1-andriin@fb.com> <20190628055303.1249758-3-andriin@fb.com>
In-Reply-To: <20190628055303.1249758-3-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 28 Jun 2019 12:37:57 -0700
Message-ID: <CAPhsuW6YEayR9_UdrS=TQzc2o4j5F_Kew0zm9QVMP1YBYCoRWw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/9] libbpf: introduce concept of bpf_link
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 10:53 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> bpf_link is and abstraction of an association of a BPF program and one
> of many possible BPF attachment points (hooks). This allows to have
> uniform interface for detaching BPF programs regardless of the nature of
> link and how it was created. Details of creation and setting up of
> a specific bpf_link is handled by corresponding attachment methods
> (bpf_program__attach_xxx) added in subsequent commits. Once successfully
> created, bpf_link has to be eventually destroyed with
> bpf_link__destroy(), at which point BPF program is disassociated from
> a hook and all the relevant resources are freed.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
