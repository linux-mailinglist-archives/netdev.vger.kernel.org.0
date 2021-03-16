Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBEA33CD61
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 06:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhCPFgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 01:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbhCPFgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 01:36:01 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52E5C06174A;
        Mon, 15 Mar 2021 22:36:00 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id f145so19191839ybg.11;
        Mon, 15 Mar 2021 22:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GSJnCQsXJkeUd4pN4VifAUM+o/YlzvQYbWhADKAdclM=;
        b=g47XTvhDNL9GKXE67qjFouKJrmwesbRoZBtqqmWIYdK/qk/bdGBJEfl8E4WF2VbCjX
         Pb9NUTaBQlBbtyBFIRNWHSkEZPGAkAs3WqFYBW2jNtkNO1JCASRgAOcPvwyHfanISAVW
         hQdT18lg+pxt/6EKcae5NYCOXVUBO2myKJSOOVFsEAh0noZ9AFh+EbUyAAaUkABKhmmV
         OoSLk+mNwkdwUlZcGta1w6nC7riO6RU+qeSsWvYuoFblvSb2M9Bn7PwEPJtl0KiZJkgB
         53NECzLzQ+YB6oH+Oh4vhhSiomzqy+vAYWPP4P6XqlRJVHRKTkgqQQnYTALrRaeYgBCJ
         eR2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GSJnCQsXJkeUd4pN4VifAUM+o/YlzvQYbWhADKAdclM=;
        b=i6tyfH6NQ8Dmk2OB8ZEmVxIIDkzKSXhQtL2j5Tj5cTyKO0X4HJz+soZSc8wVz0vXG8
         EXSUj06LPQpogT1AkofZ7z1LHR7oZE4vXYIxJPME3APTB2GxiphzOIKdrwPGbV03XHeJ
         OvXx9mRdZORmW8Fo0H+l8P/P81EsU1VhFep10CPvyoIPTxqn/4gbfOLmY4WbLe8149di
         KuV06/s5DiwNz0y6b6RkLeUruC7/5j2PQKUlPXKuFOLxMZk40wZ/gvJ0s7KxSbNBQ1X4
         VWpKauokEykCzNQB50fH9KfZCnHh/Ehq2NmhSBCYzm+3P6O3cwBA5OIh2WzUPQczutkW
         iuOg==
X-Gm-Message-State: AOAM532OSt1Ds6UkiOjBSBuy/qXL82qR41ndlZg74h1MaD6AA67u4NkY
        Knsmzdn+G/DlKGECEO4Y5NA6ClAhgYqa68NsGbA=
X-Google-Smtp-Source: ABdhPJzczL9Y6aaf/VC31yT4Xd0wXMdC8TmjEVO1OGHVn3RqnPLXT8QisEl7bCU7hY48fh/1MY/DC0op3a7/n4IWq1s=
X-Received: by 2002:a25:874c:: with SMTP id e12mr4445615ybn.403.1615872960147;
 Mon, 15 Mar 2021 22:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210311152910.56760-1-maciej.fijalkowski@intel.com> <20210311152910.56760-8-maciej.fijalkowski@intel.com>
In-Reply-To: <20210311152910.56760-8-maciej.fijalkowski@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Mar 2021 22:35:49 -0700
Message-ID: <CAEf4Bza5=ejHkGWUhs3MDQQZZbRvSapApgkWapZ69gzrV1qwag@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 07/17] samples: bpf: do not unload prog within xdpsock
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        ciara.loftus@intel.com, john fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 7:42 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> With the introduction of bpf_link in xsk's libbpf part, there's no
> further need for explicit unload of prog on xdpsock's termination. When
> process dies, the bpf_link's refcount will be decremented and resources
> will be unloaded/freed under the hood in case when there are no more
> active users.

It's still a good style to clean up resources explicitly, if you can...

>
> While at it, don't dump stats on error path.
>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  samples/bpf/xdpsock_user.c | 55 ++++++++++----------------------------
>  1 file changed, 14 insertions(+), 41 deletions(-)
>

[...]
