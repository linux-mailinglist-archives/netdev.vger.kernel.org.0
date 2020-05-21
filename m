Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2CF1DD9F7
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 00:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbgEUWKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 18:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728701AbgEUWKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 18:10:50 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70688C061A0E;
        Thu, 21 May 2020 15:10:50 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id n11so3428006qkn.8;
        Thu, 21 May 2020 15:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cY8bWJYAziC6DykutTES7fh6tr7JoLymaKn0aTQJgAA=;
        b=oZBWHO6MlDik/xfnpMWKRcWYwij9zTcWmbH9JuSmErAy7WB07e1TiF4dmrbYGrUrqE
         qfRPZudJxSJMEBbPTN71bDZdMWPCrJkbvu8G7XGoSbB0Kx34lsholiAsXcWwqN10JtAU
         iOCFxhlFjbpIHLaFaQJOBJAm68LmJFbPxQgZuVSKrSYMQSv1COiw2SUduvBiHjvsxcll
         SIQaO4hysm74vwz4ag6lDgfbljYQ6gTEO0Fln/KDw5G3EyoU4W7ba+OEbrCIfHydiwYn
         pXBLSiowmepxk4ogSoo4Ab+GKnE6jOcIyJP+L+T59F2DnNwEODLueAcdNSCaAW5tjuuP
         lBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cY8bWJYAziC6DykutTES7fh6tr7JoLymaKn0aTQJgAA=;
        b=Iqwnql0sBCYQt1OKGCkBTzWU9dAPGEizA1ZYNv8/EOhJKWrYc3s8FETsQmO+1m2doJ
         ajvFEHK/IMMuNPL8j+Fyn4OkhKQDQpSdSVMSg8GdyR/o/6uZVjNizbkIbgvyNyYfaZ20
         EeaBSEbO3zK13Y6hShEQ9LqrRRLaXxDlRwlkfdXwtB//o77OKHyUJy908AbESx2dHK1d
         8gbCtIyzKBqWe0Bx2UvPeyaom2ACT4TpYB5kJOguFS5xc32L9HIc4wWQWWo5gavq5Lbl
         21hGx+dA+EqbEVNsBHieTYwXDwPyonVSbmO5ZsXkMyK5bwCpj7+DrIj3OEun5+OADQ2v
         mr7Q==
X-Gm-Message-State: AOAM533Sx79UpA27RUtHfZKZs/fLVMcdIHdsAT0D6fA52IcY5DL+/t4P
        BEVKaJrBgR9e1OQI4kEGoyquZU7vIXH3BxmYH4g=
X-Google-Smtp-Source: ABdhPJzIXkJVvDhLwFX1ARUU8mtpCzq9VTmjBd6JQhlCMg9ID1AyioP6mhJJ2XBj6nVE6eoFrNsRgaLgO0TsCsULEdY=
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr13093079qka.449.1590099049726;
 Thu, 21 May 2020 15:10:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200521152301.2587579-1-hch@lst.de> <20200521152301.2587579-13-hch@lst.de>
In-Reply-To: <20200521152301.2587579-13-hch@lst.de>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 May 2020 15:10:38 -0700
Message-ID: <CAEf4BzbDvJzbygB9T2_4YtCx8J+ESp9rhpB=BCQVDa0QBHrV0A@mail.gmail.com>
Subject: Re: [PATCH 12/23] bpf: handle the compat string in
 bpf_trace_copy_string better
To:     Christoph Hellwig <hch@lst.de>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-mm@kvack.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 8:24 AM Christoph Hellwig <hch@lst.de> wrote:
>
> User the proper helper for kernel or userspace addresses based on
> TASK_SIZE instead of the dangerous strncpy_from_unsafe function.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/trace/bpf_trace.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>

[...]
