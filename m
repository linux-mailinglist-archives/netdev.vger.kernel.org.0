Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432C1216321
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 02:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgGGAr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 20:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgGGAr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 20:47:26 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15456C061755;
        Mon,  6 Jul 2020 17:47:26 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id t11so16050171qvk.1;
        Mon, 06 Jul 2020 17:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iy0HgdQ348NpPzykcvtlhryUYSQsQL30g+XmywH2PEU=;
        b=G3MT8hUCLanDGJO81Ois4CWuGc77WPwG+df2qFEhSRef5NWCd8vVo8Id2FLbG1SR4i
         yy6pJxC9+SzqGzEUyuBr9BLJjAJob7eS8uYyyRK1JtfS1cprPzDnxUybNkU7e+qFcXaQ
         GV0uhTA9xhcgIoczPdpAm8JmSJzwInlQHwD6T0tTNLQ5Fd46Vc3d+Z+7DxS7KzUC7MI1
         5iPZOox2fkx+lM3jlG1kxggY4cVcqyfxZNefZXcKPLm5ocD3o2RxntPUZggDw37gvTId
         rs2UVXtsS0TsPfdf4636zC06eWv5heEbR3l6xXgoptJ/nlmTjM7joXQd9IqEiIsSdtxS
         1C3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iy0HgdQ348NpPzykcvtlhryUYSQsQL30g+XmywH2PEU=;
        b=XW2V7YTjfDjoH845Fd5E0dxeEg7vsjeQ8EuweoevqHb7W8e5E0XtbT9vlices53rzJ
         u2Z8BMdnVG/zsJ+X6mG2ryzwbZJW1r42vQxCja1Dr8YvYEhhWLs+I5HCISF0RAWsHjh+
         OIiO+dgHNQhfxisEFJxRjjjTTPABkJTzKUW0CNl/dVtV0bjxd8d14Suc8D5ClMF5SC3M
         VyRijVW5tw+rAV34wKNAnMyUmucZdd6o86iUBkLq3K8Z5THl0T1mbTIv+1WCpjRFvJgS
         VII0AR0yoM1HDDAwo6NPMCreUu/th/hR8n8mux+mBzikpQpT2Gdeu8GAD+2Xfp+oLR10
         TPuA==
X-Gm-Message-State: AOAM532M7Gs7WTmp1v2SksZusY9lcOIHf3j1Y2OoPciiBle1GHBDX5tO
        uttQTS231VL/14B+KRCkXUC5Bwco13Cccvtb9YQ=
X-Google-Smtp-Source: ABdhPJyw6xrauL64DQppEPKlZZQd+389CRzLq6ojWtTYcr7JKHHfCn70268dRzhsgKpHmKGnhZ3L4XP4JrsEA/KRwDI=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr46966407qvb.228.1594082845385;
 Mon, 06 Jul 2020 17:47:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200703095111.3268961-1-jolsa@kernel.org> <20200703095111.3268961-7-jolsa@kernel.org>
In-Reply-To: <20200703095111.3268961-7-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jul 2020 17:47:13 -0700
Message-ID: <CAEf4BzZjSty=xzw3pEDE0R4pmYSD0SMQzQB6PDyihH5D=kFUow@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 6/9] bpf: Use BTF_ID to resolve
 bpf_ctx_convert struct
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 2:52 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> This way the ID is resolved during compile time,
> and we can remove the runtime name search.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/btf.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>

[...]
