Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E736185EB9
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 18:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgCORX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 13:23:58 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:45761 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728628AbgCORX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 13:23:57 -0400
Received: by mail-qv1-f68.google.com with SMTP id h20so3595722qvr.12;
        Sun, 15 Mar 2020 10:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZHiQ/FbU3EdxXuqVxa5G2UB3JyQ0NaBOT17ObRpJXD0=;
        b=pUiKBfaIwyeOAXGDP0+mpHpCwhrIA6jU6+lpo/JkovuqgMPgvdOZOaNoYOcLgTRICe
         FqPyH+LGL4bnSMwlwJ5s+fPVAJk46d3DB2t9hTa84R5DJQ7zFnpRbjvOzS1F9PXHH36u
         DHshudx7MQKMf2ycEPJMluDcvGF/oJ/XJD5veKve3pnhU1AZhARUDYvmwP5x3dlEPN8g
         E7FwS58HNbxdfNyIVGpwz3Jllq6z2dTjwsC6A8X/8mW3CJIPdaoE60BPNl0v87t7VNMk
         fw1VPJno8tHti1dToI/binHShA2Ci6u0wvwZejXa9gdKDRov/Kfn8t8qMpIGdeTGTQPa
         wgpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZHiQ/FbU3EdxXuqVxa5G2UB3JyQ0NaBOT17ObRpJXD0=;
        b=cg7Q6HIhdL0EunPteajHhIonH51/CCMmD4vyKWwYXZZekTH54L0KKZsh2z+GnEstFr
         BpU3A5pG+A/wUL65sjCmppHcna4TQLH8FScr1eTH2V/RuNwiramEO8QsBIv6wqV3tNuc
         d+/cYOw2XqACU6WUUJ1YP3bXGLq7rSlwz0c5NyDPZ5gyag0TMF8pxciHJltK48dLQF9h
         xqEUwsIZTqVhuyJSSETHpsEEx82xH5/zIeQE/hH1kwtcub6wvQEUSc+Q2K7wL8g3xvnU
         iNH3VIWJmHPnUrpDTzLISCF5fYdTFjWURk7mFuUrVGYpUnB7LmG8+jApZqS0eV1xMjX3
         v1UQ==
X-Gm-Message-State: ANhLgQ0cYA1CZUQxAWyyHdztgdIO5z7ia4Ex9Vn57GcQ2qc4VjZBR+5h
        IhMnzMabga9m9uIP9JzcA1mdZXXwpX+KpP2QuV0=
X-Google-Smtp-Source: ADFU+vs1kQbaXoe0ESnJiLH5ThUoe0xTraHFpqQXe0B02jW0yITeO6oA12uj43GPA1ZDCtASi1JM8nvHaDEyWxvtW48=
X-Received: by 2002:a0c:ecc3:: with SMTP id o3mr22113047qvq.163.1584293036467;
 Sun, 15 Mar 2020 10:23:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200315083252.22274-1-ethercflow@gmail.com>
In-Reply-To: <20200315083252.22274-1-ethercflow@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 15 Mar 2020 10:23:45 -0700
Message-ID: <CAEf4BzbOKM+o-BmwZDkixF6y3bY57ch3x8J1os1+GGUTKbC1uA@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix ___bpf_kretprobe_args1(x) macro definition.
To:     Wenbo Zhang <ethercflow@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 15, 2020 at 1:33 AM Wenbo Zhang <ethercflow@gmail.com> wrote:
>
> Use PT_REGS_RC instead of PT_REGS_RET to get ret currectly.
>
> Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
> ---

Thanks!

Fixes: df8ff35311c8 ("libbpf: Merge selftests' bpf_trace_helpers.h
into libbpf's bpf_tracing.h")
Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf_tracing.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
> index b0c9ae5c73b5..f3f3c3fb98cb 100644
> --- a/tools/lib/bpf/bpf_tracing.h
> +++ b/tools/lib/bpf/bpf_tracing.h
> @@ -390,7 +390,7 @@ ____##name(struct pt_regs *ctx, ##args)
>
>  #define ___bpf_kretprobe_args0() ctx
>  #define ___bpf_kretprobe_args1(x) \
> -       ___bpf_kretprobe_args0(), (void *)PT_REGS_RET(ctx)
> +       ___bpf_kretprobe_args0(), (void *)PT_REGS_RC(ctx)
>  #define ___bpf_kretprobe_args(args...) \
>         ___bpf_apply(___bpf_kretprobe_args, ___bpf_narg(args))(args)
>
> --
> 2.17.1
>
