Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6503965E0CE
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 00:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjADXWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 18:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbjADXUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 18:20:51 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C05441027;
        Wed,  4 Jan 2023 15:15:30 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id vm8so79390109ejc.2;
        Wed, 04 Jan 2023 15:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vToLtaZaVvMdjpzc6gL0t5F3Xg4ZUGXK+MZIDI2xwgk=;
        b=RsxlmxyIFVC8cOvjLTG8nNJ2VnZfT5M0nXXPepOwE6u1+5wH0mwoKCbHnpTGBFN1db
         56AxL6zWdZL71duqKqzN/7GTySqna1bd2vnR8RlVpTUwwN8Bj8/1iuNKMtk9HOVdZPbo
         ipKGaz6U2cZ/m64ZIIiOr9oTC54298X+dGmDUPOR+P/u1faIcjW7xLtbUr6JOB3ViMZU
         JNR8yQQCGOJMXyiIimgdpp8l9S6HdYjSH8FZapIPYV+5r9sr6V2f45k/z053XCbiew6+
         XDfzU9M0IgmccZ0ZAqgwD3JHtV73LESwr/astrhqAYgkwKy22k5FBy7PNVtZwaT2tJ+w
         K0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vToLtaZaVvMdjpzc6gL0t5F3Xg4ZUGXK+MZIDI2xwgk=;
        b=bCVMvpKCh4Pc6jAh7JbEk3ko11B3fG86MYD8ovbdU/KhwDmT7Xf0Hql0NpzTcH1if6
         9eCvJJ8Yd9LDCm+qq7qo4OwtFB8UMSUNLdZhuW2WZs3eNaEEIEtO0Muo9PEt7zvUhDeC
         A3xcoLXSczMHsp2mY6VYfg7YRpyhww0DHqjhR6B65tOrRwKemOiB0MeIqkdAAiE2oOL5
         yw6ISLRmOiuUtDIu+9hggQouMeuMVNC5BltCGkRzc9Cm3eTuyTo1pfJFMqd/QY4eHmzj
         9zeFYlyz2pjoBM+mGi4/GDeChIiID5PdW8Lj+jTsbx1e1rbEyX/k2yBDp84hQp1PbVXH
         lUUQ==
X-Gm-Message-State: AFqh2krqhEpUDuN9FlJTOSNJ/biaasd3f6bLr3AEKJUcy8gDWZ4H0Dp9
        ArYniZWHkN/kxsUWiH3Ky+45LrXq18CUd3gQitU=
X-Google-Smtp-Source: AMrXdXvTQPYFjPLRn1PDp21PV10/E718BQB5X8eTLsx2y04fiQzygso2kLXtkXA3KrMHUAr8pL00w5GzWTwFVANzAAk=
X-Received: by 2002:a17:906:388:b0:7c1:1f2b:945f with SMTP id
 b8-20020a170906038800b007c11f2b945fmr2731969eja.302.1672874129023; Wed, 04
 Jan 2023 15:15:29 -0800 (PST)
MIME-Version: 1.0
References: <20230104121744.2820-1-magnus.karlsson@gmail.com> <20230104121744.2820-12-magnus.karlsson@gmail.com>
In-Reply-To: <20230104121744.2820-12-magnus.karlsson@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 4 Jan 2023 15:15:17 -0800
Message-ID: <CAEf4BzYawc4dgjMsUQYKPEECm=qtytktGzzSnrECz56FSVgcRg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 11/15] selftests/xsk: get rid of built-in XDP program
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com,
        jonathan.lemon@gmail.com
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

On Wed, Jan 4, 2023 at 4:19 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Get rid of the built-in XDP program that was part of the old libbpf
> code in xsk.c and replace it with an eBPF program build using the
> framework by all the other bpf selftests. This will form the base for
> adding more programs in later commits.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/Makefile          |  2 +-
>  .../selftests/bpf/progs/xsk_xdp_progs.c       | 19 ++++
>  tools/testing/selftests/bpf/xsk.c             | 88 ++++---------------
>  tools/testing/selftests/bpf/xsk.h             |  6 +-
>  tools/testing/selftests/bpf/xskxceiver.c      | 72 ++++++++-------
>  tools/testing/selftests/bpf/xskxceiver.h      |  7 +-
>  6 files changed, 88 insertions(+), 106 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 205e8c3c346a..a0193a8f9da6 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -240,7 +240,7 @@ $(OUTPUT)/flow_dissector_load: $(TESTING_HELPERS)
>  $(OUTPUT)/test_maps: $(TESTING_HELPERS)
>  $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
>  $(OUTPUT)/xsk.o: $(BPFOBJ)

shouldn't $(OUTPUT)/xsk_xdp_progs.skel.h be added as a dependency
here, at .o file?

> -$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o
> +$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o $(OUTPUT)/xsk_xdp_progs.skel.h

and not here. Is that why we have this clang compilation failure?

>
>  BPFTOOL ?= $(DEFAULT_BPFTOOL)
>  $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \

[...]
