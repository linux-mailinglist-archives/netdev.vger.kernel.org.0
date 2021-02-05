Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1A931183F
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhBFCbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBFCa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:30:58 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF95CC08ED35;
        Fri,  5 Feb 2021 15:19:25 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id y128so8336936ybf.10;
        Fri, 05 Feb 2021 15:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eaySnepDzbdWK06t4HWZqmtay2gND6FqJB5mQU1GyNk=;
        b=A+eCqkjlgp/p4pwaEXRy99LxJWrvSUp2lG8jE+/nw8IYa7DCCx2brl+75YXwf4V1cH
         GFAMb/Z0ZTwIS+jALWtv6JAOtd5wFxWsmhGZ3T+W7bNhACZo/3f0zmTvYZg2tBWnVH5Y
         L7WZA3tzmn8iGAfBpejM7y37UgVhHc2hv110IssNLoILQ/xuOB+TOZjVDHvzldnGBLpN
         Zrd+2FbNsvTUpXhaTNewl9Gofb8jmbx1xN0VgbaQfJ5OChdFnUxlvVukMIW/1iTLXA7L
         eKLfkqiDvvFwKNHX4ehx5i3BN7IZWr9ezLEwSDOiwLvkUWmW3rdQmNxgq9nDlzBCOmOU
         vzdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eaySnepDzbdWK06t4HWZqmtay2gND6FqJB5mQU1GyNk=;
        b=BBNGXepVC50yDuSMYfNidNNJMW5+vAF29Rj4dGTcMsWvP2hK18A4KYXiYpxE5EeJDN
         fYPoUt5AtzfVur2V1wZOgTpf7zM5ZJdsY9qE+45Qgmdw1YDyb1VvRjmOkssnz3gQzHwZ
         Oq7Em4SDxCX8ibSXkUyvZ0boqQ6qDlanq6IPtvJQdakeTR/a0ZZjZ8KdJ1vkK2+H+Pfg
         uBi4rrVWhmDoYc5qY4W856a+ASSsR1w6Yo8OWrwlidPgrcX6VkJvCYg75uSAP+gVU7qT
         Q/pQFBbRxe0UhZfskofdGdjV3iY6W06goHuFXMhSRNAESnshJbdVo4tn9NktzTgoGGvw
         7PUg==
X-Gm-Message-State: AOAM530ugLJ7+4ymPJjStHiNVVtSfRLRnKPGXPxI7Aaz5rrhBMPpY1Vm
        AWgnnXp2mfsES4zAsThrl2v3xi2CJLw+EXy08AfU+hFv0QFnu3Tf
X-Google-Smtp-Source: ABdhPJwt7koiechQx56/EbEreAyk9y0MSngpulAsJbBPdaM7f/1PsGrvmYXWqGApF2lrJzzC7RycR83mu192C39uepk=
X-Received: by 2002:a25:da4d:: with SMTP id n74mr10053150ybf.347.1612567165234;
 Fri, 05 Feb 2021 15:19:25 -0800 (PST)
MIME-Version: 1.0
References: <20210205124020.683286-1-jolsa@kernel.org> <20210205124020.683286-3-jolsa@kernel.org>
In-Reply-To: <20210205124020.683286-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 5 Feb 2021 15:19:14 -0800
Message-ID: <CAEf4BzY6aJ5YfErvbY8AwuDztvgs4xrd5dC8y3vkxTZbiMppMA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] tools/resolve_btfids: Check objects before removing
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 2:59 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> We want this clean to be called from tree's root clean
> and that one is silent if there's nothing to clean.
>
> Adding check for all object to clean and display CLEAN
> messages only if there are objects to remove.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/bpf/resolve_btfids/Makefile | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> index 1d46a247ec95..be09ec4f03ff 100644
> --- a/tools/bpf/resolve_btfids/Makefile
> +++ b/tools/bpf/resolve_btfids/Makefile
> @@ -64,13 +64,20 @@ $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
>         $(call msg,LINK,$@)
>         $(Q)$(CC) $(BINARY_IN) $(LDFLAGS) -o $@ $(BPFOBJ) $(SUBCMDOBJ) $(LIBS)
>
> +clean_objects := $(wildcard $(OUTPUT)/*.o                \
> +                            $(OUTPUT)/.*.o.cmd           \
> +                            $(OUTPUT)/.*.o.d             \
> +                            $(OUTPUT)/libbpf             \
> +                            $(OUTPUT)/libsubcmd          \
> +                            $(OUTPUT)/resolve_btfids)
> +
> +ifneq ($(clean_objects),)
>  clean: fixdep-clean
>         $(call msg,CLEAN,$(BINARY))
> -       $(Q)$(RM) -f $(BINARY); \
> -       $(RM) -rf $(if $(OUTPUT),$(OUTPUT),.)/feature; \
> -       $(RM) -rf $(OUTPUT)/libbpf; \
> -       $(RM) -rf $(OUTPUT)/libsubcmd; \
> -       find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
> +       $(Q)$(RM) -rf $(clean_objects)
> +else
> +clean:
> +endif
>
>  tags:
>         $(call msg,GEN,,tags)
> --
> 2.26.2
>
