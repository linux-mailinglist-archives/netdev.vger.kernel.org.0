Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01934AC973
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 20:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbiBGTZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 14:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237153AbiBGTXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 14:23:10 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081C3C0401DA;
        Mon,  7 Feb 2022 11:23:10 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id c188so18197652iof.6;
        Mon, 07 Feb 2022 11:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6NM7Ake9kho34MN1EmrmT8NV0K8P6BDSXILnmG4EDnQ=;
        b=GYijXH/rJC/AMLJ2OxzqYk27/RyiwNDq7vFloLi30hoIdxnu5QM4P8/5mXFinUuUsT
         Vdt/Tyu/YZMW6fkkgZ+iTVLjUnQt0ciXRuauMCez2/Qr+1/yZzv1Zr7A3L/t3JBov4og
         fs9lzwAp4fzqacsYNCwUMOV18fQ1UWb2Mu2RwnIk+Fga31BKNOA3t8o4wRA8FEvBnZ3U
         F9PBcZmKqZNPjwa+j2ilMbjBN4zLqRlUfMDors0RvfVECB97zzcGLo99oSOXq8SVjYco
         REcR0MLUN6zxP7ju/F3F0RFRHZdkIfgy6CkdPO1FAUOEiZ+YSOCrWgbhIaqGdAgJgj+e
         LoUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6NM7Ake9kho34MN1EmrmT8NV0K8P6BDSXILnmG4EDnQ=;
        b=gq9aLgG+UkBwjRJhzcD6Q+q49rQFpy12Lm7I40dcR68O7UJZ55iHcDpvb0/Ztqunfd
         ocuuZVag6otODa0fBPNB1qBRdFqf29U+9BvtKhzEkqNnJtoLP4IRd5glt/fHDcyCfFr0
         JDyvZ0NDoz/VG6WtzxIUc7si78EAT+ZZumdmsCLFfryZZQuIsJ1zeAocpmyIU69qocAY
         60NARNETg0xm17aaqv394GiT/lqLr7paN92+eyEZFg0FKK2OJK705cShx+fLjRe8FnMC
         qbmo1/Cv/A8Osxjn/aJ5c7rA7FHKwVxcowzfwwnBIDbD5Ecod6ra+5P8UmVpkt2GboQD
         2ZeQ==
X-Gm-Message-State: AOAM533A4RTupN5WutKgx53BcMQd4flApdnVmDlmZaga7s7KyuBSkQWp
        M3isn2p7XqPCGdM41PN+uBH7NLv/T0K7Bko9rnE=
X-Google-Smtp-Source: ABdhPJwWdbsMxXEp32Ec06c+K/9QK9+hktthjg6LlBSVY2Qfp+qViF5rI8She+cfTeqM4l6cM1IzJvoV/6C0IZeCc3M=
X-Received: by 2002:a05:6638:304d:: with SMTP id u13mr571045jak.103.1644261789459;
 Mon, 07 Feb 2022 11:23:09 -0800 (PST)
MIME-Version: 1.0
References: <20220204225817.3918648-1-usama.anjum@collabora.com>
In-Reply-To: <20220204225817.3918648-1-usama.anjum@collabora.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Feb 2022 11:22:58 -0800
Message-ID: <CAEf4Bzbf38F39XHJnCKy19m97JZJnhN0+Sr-TAVzZnSKuqzL4w@mail.gmail.com>
Subject: Re: [PATCH] selftests: Fix build when $(O) points to a relative path
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, kernel@collabora.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 2:59 PM Muhammad Usama Anjum
<usama.anjum@collabora.com> wrote:
>
> Build of bpf and tc-testing selftests fails when the relative path of
> the build directory is specified.
>
> make -C tools/testing/selftests O=build0
> make[1]: Entering directory '/linux_mainline/tools/testing/selftests/bpf'
> ../../../scripts/Makefile.include:4: *** O=build0 does not exist.  Stop.
> make[1]: Entering directory '/linux_mainline/tools/testing/selftests/tc-testing'
> ../../../scripts/Makefile.include:4: *** O=build0 does not exist.  Stop.
>
> The fix is same as mentioned in commit 150a27328b68 ("bpf, preload: Fix
> build when $(O) points to a relative path").
>

I don't think it actually helps building BPF selftest. Even with this
patch applied, all the feature detection doesn't work, and I get
reallocarray redefinition failure when bpftool is being built as part
of selftest.

> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>  tools/testing/selftests/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 4eda7c7c15694..aa0faf132c35a 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -178,6 +178,7 @@ all: khdr
>                 BUILD_TARGET=$$BUILD/$$TARGET;                  \
>                 mkdir $$BUILD_TARGET  -p;                       \
>                 $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET       \
> +                               O=$(abs_objtree)                \
>                                 $(if $(FORCE_TARGETS),|| exit); \
>                 ret=$$((ret * $$?));                            \
>         done; exit $$ret;
> @@ -185,7 +186,8 @@ all: khdr
>  run_tests: all
>         @for TARGET in $(TARGETS); do \
>                 BUILD_TARGET=$$BUILD/$$TARGET;  \
> -               $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests;\
> +               $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests \
> +                               O=$(abs_objtree);                   \
>         done;
>
>  hotplug:
> --
> 2.30.2
>
