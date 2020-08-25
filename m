Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41402523EC
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 00:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgHYW6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 18:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgHYW6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 18:58:46 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5532C061755;
        Tue, 25 Aug 2020 15:58:45 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h19so119130ljg.13;
        Tue, 25 Aug 2020 15:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l2cjR9MV5pvSVMmhgeG5m9fnexeorxlv3qcsSxNAMZk=;
        b=V1MBc6qdGt7oY3UHpUOGg0cphBBi5DbG49KVxb/GOzAHDlBWtk/o/Z3sE/lqZ34B90
         a5wnoMLYtA162jVdYZpxt2VuN3uREzfBEA85OC5HTHsOibxEc+JdY5BPi5RQrQQ9SVCs
         rgvz9O+pPxEtN6irGEDbehZZdxD2UyrAexsoipw5UxG7+YTi+9oDP6tZHlTICuN82hP0
         Z4X4f7MdN96S+o1CLndICowGZNhNfnp4XBIKRHOlCMaNxrZYOb0sfjPe3Wfn2J1xDENt
         FMsBIygvbD6cLcaI6iAnGn5ddNDphkfPMrMyPYJmQ+/5iy5XuIGXzEHIetVdQ2bKgrIq
         Dkig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l2cjR9MV5pvSVMmhgeG5m9fnexeorxlv3qcsSxNAMZk=;
        b=FP+Bbqu9ukvG03Nd62ynplKN5/QRmc3urkNfF0eCCpCF28YBVdPWxD2sPT8e/1alEm
         ZiBye5H7GduoAFI06hNiBMjiiJTxMx4jBIHIhqhg6RfPBup5m2Cjf6iI4f/Ife963hVi
         FZj3JVkkPRO1ogCwYg/Ldlc/qM66KGUIMr7FJamQrU+Uq72GVuVX5UpOaybm4r4P27Mn
         c2q8bHyDeZzMl+R6by1DcOs+zdl56LIMI8TnuxB1OF+NQ12WGgnFKR7pXQqrurPonRWC
         +xNycI9BLa+6EU4vOKFMEutI7eWIvUBVhYzBewKbhcKKpBE7oiUADURFUWlXfn/1uudH
         3EzQ==
X-Gm-Message-State: AOAM533+beGLO4XmdBE/X9ZROj0WQMugAarJb8xtVMjKOT6Zl/kcCyFk
        ojBFVIPTB99awlAjfTvSHWTKe8RG+aKVYyJmPH0=
X-Google-Smtp-Source: ABdhPJwsTb+S1GD0wz7dH7SfF7esDGRQMAbokMXNVHrncRSV1HbkEIrkBs21HtypJ1x1F1pvXTBX+tVO8y1OlARF1Uc=
X-Received: by 2002:a2e:8e28:: with SMTP id r8mr5410177ljk.290.1598396324173;
 Tue, 25 Aug 2020 15:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200825192124.710397-1-jolsa@kernel.org> <20200825192124.710397-11-jolsa@kernel.org>
In-Reply-To: <20200825192124.710397-11-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 Aug 2020 15:58:32 -0700
Message-ID: <CAADnVQKtE9p22J2stAc6WuGOxkoPdzcAf5DstK6J76-x1thjZA@mail.gmail.com>
Subject: Re: [PATCH v12 bpf-next 10/14] bpf: Add d_path helper
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 12:23 PM Jiri Olsa <jolsa@kernel.org> wrote:
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3655,7 +3668,8 @@ union bpf_attr {
>         FN(get_task_stack),             \
>         FN(load_hdr_opt),               \
>         FN(store_hdr_opt),              \
> -       FN(reserve_hdr_opt),
> +       FN(reserve_hdr_opt),            \
> +       FN(d_path),
>         /* */

This is not correct. Please keep "\" at the end.
I've missed it while applying Martin's patch.
I've manually rebased this set due to conflict with KP's changes,
fixed the above issue and applied.
