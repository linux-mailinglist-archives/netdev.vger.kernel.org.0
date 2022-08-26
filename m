Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97655A1E6A
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244631AbiHZBz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244025AbiHZBzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:55:22 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50563AA4E1;
        Thu, 25 Aug 2022 18:55:21 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id d15so156469ilf.0;
        Thu, 25 Aug 2022 18:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=USnukc/188Y9AouXvyJSCZFszKTYIwRy8hfHnkd63Zg=;
        b=jOBJjSn3uhe6R65ntwBq62rWm+g9yTDC+1ZL9gc/4gDeF18XrVNfQKqoHultqxnnQg
         /1dKMm2Ig2nrGr7oOY1KqXjnqjyATY4gUnZw1unhVyHf2jcpKk00zlmhCVCdpLz5uSQA
         tI4tZ2Bnx6stX4Wm7UoU7fMg862SH3b5SexcJvKl7vFtzhWiN8iL02zYyGwW+wI9Mdeu
         JXPrRk89eVO6K9WL7+OQK2FKXJ6z9P+pITKYxYSUzos9RlCy/J7sdR7DHCFwZiNTbXpV
         41lI3vOyWLmV+C+G6Y+cJtQNVubXlMUeBChPoDqIyrZKi4XoPY0MVIQ/NE9aakL7TaRZ
         U3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=USnukc/188Y9AouXvyJSCZFszKTYIwRy8hfHnkd63Zg=;
        b=nnTpOskY+N5XRMK7A4VFEXQMjTP5fLSIUN1xT7bV5NVgJS0SeX+3e8qD1yjSVDML5c
         P/aBBCbrIc2VWDGPntOLDCpn5jLf0FEqes1DhZsXz3Tu3CuYOv/t2mGrpa4ZyumRZiO2
         /CjwHoiZlJqMEsZAQDA0Ml65JdE7NylaLlYpTCrVMYq3Ys1LqSkN/IKo7O+U55HXyV8d
         1N9eBQfsMRxwrLSFBsHpMqLqaNfBGTdS0+SYvBfgqWhi/bzutgxdvhHEVSqDUmsSLy0v
         LGGT+LlULeAXSLmjeL+YY1kch2dLFdGZvzBFjCsUYoT8sw2nWxzV0NwHJklZXEdcnjPv
         Y7dw==
X-Gm-Message-State: ACgBeo0N0KjA75kJkS2aUkpKr3L98oagsP3fWUGYV+xVKuD9WKbHuM89
        D21CRX6eDhFrVF8GdHxcbA5bU7LYc8feZCBXwho=
X-Google-Smtp-Source: AA6agR4O43QbdMCxUFs7+d+4YEhgKIelTI8EfSehAma0P2GR9BHOjomPJCD6G8iaf039fJ1mpL6DAvBvnBsOJGBjU6k=
X-Received: by 2002:a05:6e02:661:b0:2e2:be22:67f0 with SMTP id
 l1-20020a056e02066100b002e2be2267f0mr3130745ilt.91.1661478920738; Thu, 25 Aug
 2022 18:55:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com> <20220824134055.1328882-3-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-3-benjamin.tissoires@redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 26 Aug 2022 03:54:45 +0200
Message-ID: <CAP01T76tie9dpjacCLxCcAjtra12GxfmeO9f_mYnUU6pO4otzQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 02/23] bpf/verifier: do not clear meta in check_mem_size
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
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

On Wed, 24 Aug 2022 at 15:41, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> The purpose of this clear is to prevent meta->raw_mode to be evaluated
> at true, but this also prevents to forward any other data to the other
> callees.
>
> Only switch back raw_mode to false so we don't entirely clear meta.
>
> Acked-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> no changes in v9
>
> no changes in v8
>
> no changes in v7
>
> new in v6
> ---
>  kernel/bpf/verifier.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index d694f43ab911..13190487fb12 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5287,7 +5287,7 @@ static int check_mem_size_reg(struct bpf_verifier_env *env,
>                  * initialize all the memory that the helper could
>                  * just partially fill up.
>                  */
> -               meta = NULL;
> +               meta->raw_mode = false;

But this is adding a side effect, the caller's meta->raw_mode becomes
false, which the caller may not expect...

>
>         if (reg->smin_value < 0) {
>                 verbose(env, "R%d min value is negative, either use unsigned or 'var &= const'\n",
> --
> 2.36.1
>
