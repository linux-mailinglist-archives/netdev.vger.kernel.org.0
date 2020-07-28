Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5102313E7
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgG1U3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728932AbgG1U3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:29:15 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222FCC061794;
        Tue, 28 Jul 2020 13:29:15 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id c12so6908236qtn.9;
        Tue, 28 Jul 2020 13:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fh9i97yvbhZY5dXaEOPSNowNwBJypz2dNo5M4ydiiIQ=;
        b=XpXBwciJOKxKwb7WUqTEnM2XrWdlwNOa6j8aoGUwXL68eYYH7OqPKm1ip4ViatwHWY
         Ytz5sdeXPslfptWqYQgCjZ7HOp4zP63likJq+7RmBIB6Y0+12IA7x+NOPJG2uRWiEyrb
         87vdiYqsvQIOhDC1C2s0Quk7TRBT1V/fsOGAcvSBw/f95copqXwiVsJJy6nDRu7HW6A8
         rDep8h8rJBT5251BMWWXYTHvbZJNLOnh4pv79M7KCGU82thaik5uQug3x+3Izy8tO8mQ
         1M5UbdNvlk6jRLOQUeLKgNkhwmhm9GB3APzCjTDX+kyFZMV0yfYE5S5aphJ5kHoJGBRy
         td3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fh9i97yvbhZY5dXaEOPSNowNwBJypz2dNo5M4ydiiIQ=;
        b=TTl7kNxe5hS+ErrjWRBD0Qwd8PEbKf9ae6ZGg2B8xgNpYFUlvdvFD5/LFKwjzcZ/NW
         XBx+z+ewwRkVlROt+Y6x7/MSoQgiE/8T8QOIX8PqwZnkZi/Xez0Un5LMG3i1oefWqlV0
         zMbf71rQI/h+6YryzTftTe/DyDB6RzRoqrCqVH04IRig9DiEUv1z3WcelGO7eHEtYaYr
         jT4Fmb3+K3NcIKIh+qMQCQEldKn55mThz8R9oTOOd7jGxIEJVlObBMLsvE37U+N7oGJf
         6rjDuntpgTFqRxmbtwvyjNiD0n4aqwHAOYBbSCarCAA+/Gd8Br0Qqkqw5bK/4tKX3qw1
         FQkg==
X-Gm-Message-State: AOAM5311/vQQhwP+tDlwfWM4x1a411xWePPK0NhvPsE6vQ8QaryjlGiL
        hCHFw8/DGDdIw+9JR6elgKyWM9LsfTYtDEe2CuRuYNFJ
X-Google-Smtp-Source: ABdhPJytpgD57n59a2Ogtl/38CdJov2I8hVv3BbfEEpvz98GbWNmcoyW1umm0IlLmkqnjBd8GEBizUGMDSIlwBaLOZI=
X-Received: by 2002:ac8:777a:: with SMTP id h26mr28239437qtu.141.1595968154362;
 Tue, 28 Jul 2020 13:29:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200722211223.1055107-1-jolsa@kernel.org> <20200722211223.1055107-4-jolsa@kernel.org>
In-Reply-To: <20200722211223.1055107-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 13:29:03 -0700
Message-ID: <CAEf4BzZi8OgDKmLSZs6qujZNcCXXngc4uo=vDxap=HHCkC2oxg@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 03/13] bpf: Move btf_resolve_size into __btf_resolve_size
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 2:13 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Moving btf_resolve_size into __btf_resolve_size and
> keeping btf_resolve_size public with just first 3
> arguments, because the rest of the arguments are not
> used by outside callers.
>
> Following changes are adding more arguments, which
> are not useful to outside callers. They will be added
> to the __btf_resolve_size function.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/btf.h         |  3 +--
>  kernel/bpf/bpf_struct_ops.c |  6 ++----
>  kernel/bpf/btf.c            | 21 ++++++++++++++-------
>  3 files changed, 17 insertions(+), 13 deletions(-)
>

[...]
