Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5236481534
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 17:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240869AbhL2QoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 11:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbhL2QoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 11:44:20 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4A3C061574;
        Wed, 29 Dec 2021 08:44:20 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so19963204pjf.3;
        Wed, 29 Dec 2021 08:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u9SlnkqK38gbFa/5lQSVkRrNE/pyi+RpdtYH3JSS99M=;
        b=H9TuCnsiq/c74xXRy4eTZ2x8gALL/l3hL3Vr32hYYTnpdTCQ7HDKph6mfL2EVW25KJ
         nJAlYAdFAMX9n+Umn2FplyKNagbTdaNI3KKNWRIWOYbIlY9A6ZY68S5yaqJeD/qYJmJ8
         t66cTk1dvDBfD/G8L/Nmf2fvRB12wwAGjzvAr0icqZ4Ff/WuZfuVdqFVmMtB5GtsHFZP
         mbLIEMPah/zascpsGeWXuj4UVLe7A71LOM+CLt5BXlogswpbKKBt8w2vEyAFG9Jt4x2o
         +/XI1nfpoTG1AWCerJT9p8w9yM+/G3W/DZDpdiJECFWYsY6wttpCiFteZt8dR3P+Ci+0
         vt0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u9SlnkqK38gbFa/5lQSVkRrNE/pyi+RpdtYH3JSS99M=;
        b=Xy2QS0lQM6V1Qk5fwDZDB6Vd31ovNZ3Gn3LhvKlnr6ejVZKEEQsfScVECIeo7V9LgC
         uXOFV0JRXP2aZTSJmSBk/DThSRXs23h6ol8IkGlpkZehTzth9+NRI5TeJb0i+FWQwckn
         w0Z6wyoFqH+qYoZhLd4zd1Apl0fiCPdLqOGH1QUMoawYlXMpL2yCm/JZxSZ7sOXeTNqv
         WgrCFny/0YI+1m+uNxRkHUBH4WB1BpmVlLrkLN8hJRes9qv5h+FWWDg354rl2U9iBSqf
         tNqARzGpxau18caVt6zVE9Z7T/cL1AzDquJ5cfF8vMRsx/oOcyjpqWaGuA712Og2T4OT
         wXGQ==
X-Gm-Message-State: AOAM530arEsXHjgXix7rkAaqGnysPz2EB1OgDygdx2KcsEix8lCLgxRp
        KmNoHAojY1YQSahS8cQ82Ynq02XU+fQTqJ7ZHVM=
X-Google-Smtp-Source: ABdhPJwPURyGVwWf33T/6i51jvI8jx135wluxLNbRczUNmaGMT6NYDtgjrFxUSgqWfx/xKnnCtj7b3V5pnY3X8m4oHQ=
X-Received: by 2002:a17:902:6502:b0:149:1162:f0b5 with SMTP id
 b2-20020a170902650200b001491162f0b5mr26758521plk.126.1640796259801; Wed, 29
 Dec 2021 08:44:19 -0800 (PST)
MIME-Version: 1.0
References: <20211229085547.206008-1-imagedong@tencent.com>
In-Reply-To: <20211229085547.206008-1-imagedong@tencent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Dec 2021 08:44:08 -0800
Message-ID: <CAADnVQLiqRdE0iqSFM7za2g5UVNDE-ZZmS7+pca176_ePKsZvA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: bpf: hook for inet port bind conflict check
To:     menglong8.dong@gmail.com
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 12:56 AM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> This hook of cgroup is called while TCP/UDP local port bind conflict
> check. This is different from the 'commit aac3fc320d94 ("bpf: Post-hooks
> for sys_bind")', as it is also called in autobind case.
>
> For TCP, this hook is called during sys_bind() and autobind. And it
> is also called during tcp_v4_connect() before hash the sock to ehash,
> during which src ip, src port, dst ip, and dst port is already
> allocated, means that we have a chance to determine whether this
> connect should continue.
>
> This can be useful when we want some applications not to use some
> port (include auto bind port). For autobind, the kernel has the chance
> to choose another port.

The use case is too vague to consider adding a new hook.
Also there are no selftests.
