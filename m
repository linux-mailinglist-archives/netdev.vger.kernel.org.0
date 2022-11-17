Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A8B62D460
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 08:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbiKQHtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 02:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiKQHtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 02:49:16 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CAB52895;
        Wed, 16 Nov 2022 23:49:15 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id m22so2965364eji.10;
        Wed, 16 Nov 2022 23:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Xk1oEmkTU9H7VPwZGQRzWhMrFXqC/l98G+URF+zUWzQ=;
        b=p3bqfivjdCBVThsXjPyPdiWmaaJ3KVtlPvlz5ibGTO97w+eHWVfn3ztrpX8+02RK7r
         /n5JnlCLCI05orLqcPnBRJK4R+bPsH9DYMeal9vY8O/vOzLc4mmwCZsA4wliTfZTD/1k
         PEe15RfyOHC4LfhRlJjzmgGqh361hWndQ7IlH7s8FKh4uPggrazp48fXqGNPgix4TK4o
         BDKKQojgrChhZSy7opOWSyzmfD7tDHYpsxqrcg8YAGkZUNJjKsmbIVZ0YHQOXERzAL1O
         BoAEt7xZmV9I6scFQJ2TzP/tB/Ldx1CfxDktxIjwHv4zP90v4Hi+bevI+uQoZIZDbgWC
         NPug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xk1oEmkTU9H7VPwZGQRzWhMrFXqC/l98G+URF+zUWzQ=;
        b=61S9ssEEf9YePCY61t2bBrnZcF/OI4bGZNkMCjRvcPbJ8GQU9ftBdC/h/TQb/9z4wA
         jAmZOrxd5M7waBrgNarrB6Jg+scLDRkdgKPuV5D/45DFj2aoI9UhikyHDnwXhxJJg1kr
         5OAg8ZUeb9zhWKqsnSpMN+iHELCBZNTYemtyzkP5Uw0OH2nvwE0ZGtkPg3b6je1ocjl2
         gnHnKLWDQNg2FhArlO+qejDok80LXD/xGDs6W3/R86Emm/OaGX1AHpS4TJoVXruQGwyO
         4oYjUDfYF74Jaa1AVXChYwkwK33ICr/OBfGtQotypYW21BGnfkyvAmKtxL/f7N9p2oBe
         85tQ==
X-Gm-Message-State: ANoB5pmXl7VTAXUs39f11w5UuwY9KiCGkdmPb9BLG79071YtqePq832B
        PTfX0WmSMbqC+T9GqAQjA8n9AFNDNTo=
X-Google-Smtp-Source: AA0mqf6j48PnIuhUBdYjPPrRHGMG9asjsCw4Bqww/C899ryKZXZBQZkhjhSprEaQLgVNwgiNzYA7ag==
X-Received: by 2002:a17:906:a157:b0:7a5:7e25:5b11 with SMTP id bu23-20020a170906a15700b007a57e255b11mr1120322ejb.254.1668671353636;
        Wed, 16 Nov 2022 23:49:13 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id bk14-20020a170906b0ce00b007ad69e9d34dsm19988ejb.54.2022.11.16.23.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 23:49:13 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 17 Nov 2022 08:49:10 +0100
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>
Cc:     bpf@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        Mykola Lysenko <mykolal@fb.com>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf 1/2] selftests/bpf: Explicitly pass RESOLVE_BTFIDS to
 sub-make
Message-ID: <Y3XndllQ6kmFbztg@krava>
References: <20221115182051.582962-1-bjorn@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221115182051.582962-1-bjorn@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 07:20:50PM +0100, Björn Töpel wrote:
> From: Björn Töpel <bjorn@rivosinc.com>
> 
> When cross-compiling selftests/bpf, the resolve_btfids binary end up
> in a different directory, than the regular resolve_btfids
> builds. Populate RESOLVE_BTFIDS for sub-make, so it can find the
> binary.
> 
> Signed-off-by: Björn Töpel <bjorn@rivosinc.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

> ---
>  tools/testing/selftests/bpf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index e6cf21fad69f..8f8ede30e94e 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -200,7 +200,7 @@ $(OUTPUT)/sign-file: ../../../../scripts/sign-file.c
>  $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_testmod/*.[ch])
>  	$(call msg,MOD,,$@)
>  	$(Q)$(RM) bpf_testmod/bpf_testmod.ko # force re-compilation
> -	$(Q)$(MAKE) $(submake_extras) -C bpf_testmod
> +	$(Q)$(MAKE) $(submake_extras) RESOLVE_BTFIDS=$(RESOLVE_BTFIDS) -C bpf_testmod
>  	$(Q)cp bpf_testmod/bpf_testmod.ko $@
>  
>  DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool
> 
> base-commit: 47df8a2f78bc34ff170d147d05b121f84e252b85
> -- 
> 2.37.2
> 
