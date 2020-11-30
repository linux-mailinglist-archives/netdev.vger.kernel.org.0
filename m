Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33262C90F6
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbgK3WZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgK3WZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 17:25:36 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FCFC0613D4;
        Mon, 30 Nov 2020 14:24:50 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id v92so12927558ybi.4;
        Mon, 30 Nov 2020 14:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n/7o1gvlCHtRpXxjEuEu8kN/84FyQb3WcQ0KJUmzymM=;
        b=gCDU67Mtfc9Dmokbh/2FD1bCYnKAwh4xlfjdcHl6LLXjDmiDcxtERBNk/o3p1Fg4BL
         OVvGBJ4+aeyQhcoC0ZqnQxIVYBkyLOwY+tbL4bCJO0KcMrkwUfA1hUi9DzWvv07WfQYK
         AgXxmdhBkFHQncP57te/FCslMlQE/AnzSBxCiuto5ZId3emXSTj83tVskruN131Vnggu
         IJnS3SZZt4kQ4bWALwbrforl8AREDHyaFTblGxnsqez2d3X4IreyoIZMoTYlA+8hyE48
         J1PQaRGvA39oJDuRWRD8XEw0X4fuNAZLyQcOB0jLjt3fg7nO2nFA34TvQBfPK4C1EQKy
         bt4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n/7o1gvlCHtRpXxjEuEu8kN/84FyQb3WcQ0KJUmzymM=;
        b=tysJrCY0LUlRQL2jlBoGLufMBKe8SnaSKyBBYaWq3g8f+aQgQmiDjvKhKhCthBgJ/U
         r+3F/SepvuURY7foZNTTerklwz7XYO+Zfp6sOSg9O9mVYUWGLrKwb7ijlKp9Qoj8u2Qk
         SgNaEmy5jJVRLtl/Mt2d8F+bBpWCGkUsdgzkKtuzgfifZj7SIq2WbhJvdc7iM/h76HYg
         8Vue/cTv/hVH6QkzTc8EmLdgDfoX/mFuls+9UshDdEd8CqJ3ZU1k6u3pSOm7dPeZ+bN8
         C4buVrNkXZgXR7mPxGN61vzWbEtWz4FtFStx68m6RQr+wXiu9e3PVidyVJwRbMAm3zHw
         CM7Q==
X-Gm-Message-State: AOAM531kuOsxWbg9zdVbl75i35uJx/2zxDq0nq6lh9Z7ewYvBUvJQBPu
        9rLvTycRxOvHQ7ANX78Wk4mBPzTOqrN8RzAqeqA=
X-Google-Smtp-Source: ABdhPJyj/8AjEkCFwSYujjpwBCxHoYwqMxZtgpOQNMHyw6PKrsA1FbZQN+dNMJN3adGrm+sRbD1yqn2NplTTanPghoc=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr28808201ybe.403.1606775089584;
 Mon, 30 Nov 2020 14:24:49 -0800 (PST)
MIME-Version: 1.0
References: <20201130154143.292882-1-toke@redhat.com>
In-Reply-To: <20201130154143.292882-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Nov 2020 14:24:38 -0800
Message-ID: <CAEf4BzZy0Y1hAwOpY=Azod3bSqUKfGNwycGS7s=-DQvTWd8ThA@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: reset errno after probing kernel features
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 7:42 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> The kernel feature probing results in 'errno' being set if the probing
> fails (as is often the case). This can stick around and leak to the calle=
r,
> which can lead to confusion later. So let's make sure we always reset err=
no
> after calling a probe function.

What specifically is the problem and what sort of confusion we are
talking about here? You are not supposed to check errno, unless the
function returned -1 or other error result.

In some cases, you have to reset errno manually just to avoid
confusion (see how strtol() is used, as an example).

I.e., I don't see the problem here, any printf() technically can set
errno to <0, we don't reset errno after each printf call though,
right?

>
> Fixes: 47b6cb4d0add ("libbpf: Make kernel feature probing lazy")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 28baee7ba1ca..8d05132e1945 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4021,6 +4021,8 @@ static bool kernel_supports(enum kern_feature_id fe=
at_id)
>                         pr_warn("Detection of kernel %s support failed: %=
d\n", feat->desc, ret);
>                         WRITE_ONCE(feat->res, FEAT_MISSING);
>                 }
> +               /* reset errno after probing to prevent leaking it to cal=
ler */
> +               errno =3D 0;
>         }
>
>         return READ_ONCE(feat->res) =3D=3D FEAT_SUPPORTED;
> --
> 2.29.2
>
