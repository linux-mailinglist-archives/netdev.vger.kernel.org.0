Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75A9681651
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbjA3Q0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236952AbjA3Q0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:26:52 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA6442BDC;
        Mon, 30 Jan 2023 08:26:50 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id kt14so33404211ejc.3;
        Mon, 30 Jan 2023 08:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aeL1yKKafH0YF5Q9OP+rEdMznPKqMD6znWn+lV0SJEE=;
        b=Hd3fnaNoOTxaUp7Hq7bKAOE66/ain081O4hQYqaTrsOR60rRpoZf8zKh05Jxr+4Jae
         wpcBsw49wYdU8cFlbeYJ3DjXNFfwWqc+LpDpUaOQeTsuC/qRdsMKFqfaPMficR//d1QK
         VIIiUTHHh30frPyYu6By4gbLFQQxKM9iYI73zJwXtyx/Ngu1pDIwQdhEDO1mqJouhGgQ
         Gu3sLUWgMoezlBmVxy7zVSwh4BN/0idG6PGJR1pCkRTZx4m6Y9BAOWDIj45f1+Adm5gA
         sSxTB9Uf//WEO8AdELFVpU5nYssq5JCrIBx7b1NMopRpiGgIUSQtej23Qg4d3+1fJog/
         rGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aeL1yKKafH0YF5Q9OP+rEdMznPKqMD6znWn+lV0SJEE=;
        b=CHEVDpjCNah6Sb3uamRsFjCZiIXIyVXnxpX8bjwS23MoP+CFXyne6aXiJBo48CNu+y
         Kz8eQQ+w0b4TJ20GCawVm/uHOdhwmfxoXTiQcI4H/p9gL/fQiFZNUzWuzycJpO/wmQ5Z
         /U/ypZlp07llGJueSbakAkxP83GKDQ2xtqNKoJW1RTZzTHKSAs44vAheYJuSTdOVdl2i
         kqCmJFFIh/WXkkUMDJiaKx2fObCvRGqtNFRzNvXeJ1Bbb+2uSV1bvjRosPcqcVfMbENS
         CK0C0awMe1CzVCrmwtH5+sqo3zd6u7U8AN/ae6Tc/vwF8PTOG/8fMBmV8kIepe9op6vP
         9Z/Q==
X-Gm-Message-State: AFqh2kpkKlMHwkJzPCGhVifL5QhnW9W3ANE535PWHxphFQ+AxRB6zaiC
        c6IFtG/8+HMt1lbV9Kqf2uSDdSt3nysNZl5G/6TLBUCV
X-Google-Smtp-Source: AMrXdXuSbqX5vKm2qlcpbVVGoqd5LbtVnloM1xeupFRm7Uq1v6/dKga5nvw3NPtU0WopYiPJzQ2qNhbkGqnBxbKys4k=
X-Received: by 2002:a17:906:7ac2:b0:86e:429b:6a20 with SMTP id
 k2-20020a1709067ac200b0086e429b6a20mr7769751ejo.247.1675096008450; Mon, 30
 Jan 2023 08:26:48 -0800 (PST)
MIME-Version: 1.0
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
 <20230127135755.79929-3-mathieu.desnoyers@efficios.com> <4defb04e-ddcb-b344-6e9f-35023dee0d2a@linuxfoundation.org>
In-Reply-To: <4defb04e-ddcb-b344-6e9f-35023dee0d2a@linuxfoundation.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 30 Jan 2023 08:26:37 -0800
Message-ID: <CAADnVQ+1hB-1B_-2LrYC3XvMiEyA2yZv9fz51dDrMABG3dsQ_g@mail.gmail.com>
Subject: Re: [PATCH 02/34] selftests: bpf: Fix incorrect kernel headers search path
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 8:12 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> On 1/27/23 06:57, Mathieu Desnoyers wrote:
> > Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
> > building against kernel headers from the build environment in scenarios
> > where kernel headers are installed into a specific output directory
> > (O=...).
> >
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Shuah Khan <shuah@kernel.org>
> > Cc: linux-kselftest@vger.kernel.org
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: <stable@vger.kernel.org>    [5.18+]
> > ---
> >   tools/testing/selftests/bpf/Makefile | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index c22c43bbee19..6998c816afef 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -327,7 +327,7 @@ endif
> >   CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
> >   BPF_CFLAGS = -g -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)               \
> >            -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)                   \
> > -          -I$(abspath $(OUTPUT)/../usr/include)
> > +          $(KHDR_INCLUDES)
> >
> >   CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
> >              -Wno-compare-distinct-pointer-types
>
>
>
> Adding bpf maintainers - bpf patches usually go through bpf tree.
>
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>

Please resubmit as separate patch with [PATCH bpf-next] subj
and cc bpf@vger, so that BPF CI can test it on various architectures
and config combinations.
