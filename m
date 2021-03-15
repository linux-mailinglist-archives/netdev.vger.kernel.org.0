Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A4A33AEA0
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 10:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCOJYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 05:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhCOJYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 05:24:22 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B63C061574
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 02:24:21 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id p7so53592503eju.6
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 02:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UDrvpL3Clc7HH5Rd2kY9nbHs/9D7B75ztyk400CQFNU=;
        b=t+t6m1MVq0U2ew9743tWpLI1BSdUDJNGfntFQrczl6hBy4Mwdv6esYa+N377FUHmOj
         DDxgA/whe2RjlDHYyN/TuuIObrZNoR9MeTWMhdcgmXvLnQvXsMXxEID09v9/aNGjeU5e
         W79ZoFKJtKCN30F4LSmUCIr0f/eWQIBG51Bw53ViuD678X4qbBxS+/KokqodgBiKSslr
         vBk4BUxMOIDom8P/1QY5yqP1LLoeOSb5hla1ntWHANEEFJ2bToVcFCTxCFN8BpIXvvNR
         W7u8Ogd9+iPk5jqn4omAtypPlzipscecGANAbOGpFsFt4gH+MSXxmrlC2v9CbaMTjY80
         vj/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UDrvpL3Clc7HH5Rd2kY9nbHs/9D7B75ztyk400CQFNU=;
        b=ORibsDhhDoUA8qk7rEXUR90dnO0gesEcFs680J2CgMHkhHNKOfn/qPTvrGwyqKQKw4
         dsDAe35r60bM/aYojTvcRuHOUK/SZfQ5OHxOa91Mgv4fQHxyL5jnM3LUYbLMHR2YS8Yu
         Hc96l3KKMnHU4Cjzv//n/8Y9nQtR5fn9j+ZuaVU9fToqq6u26n8V+HePIoq3e3QGFUaP
         /oYK7VUWgWDJrH/MqyBwkatXazYOtxeRDdgmkQ/OoZmX54KkDaKClZovsLZNhvqlmuQf
         0Vumw6SbCdRr2A81HHpHRGeJCLCRJsbD9eK8z+O+3+jt0024FORNZGBQlg+6YGmxkpjO
         cIvw==
X-Gm-Message-State: AOAM530SzZ3NcukWwGu9crJobOwGR89HI1HN9ieJLK4LTxjGA/cL2N5s
        U+CaObkFJ2GE5tIOlV5M5pHFaSwT+EPu+HpS
X-Google-Smtp-Source: ABdhPJx/6Q0IBjRNygpcd54E5muTxxpkMWkch05Ktvl/mCb29O8q4VJ+3Xn+29RXsTNKskXgE9NJmQ==
X-Received: by 2002:a17:906:d9d1:: with SMTP id qk17mr22283463ejb.52.1615800260406;
        Mon, 15 Mar 2021 02:24:20 -0700 (PDT)
Received: from [192.168.1.8] ([194.35.119.239])
        by smtp.gmail.com with ESMTPSA id mc2sm6754929ejb.115.2021.03.15.02.24.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 02:24:19 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 08/11] bpftool: add `gen object` command to
 perform BPF static linking
To:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     kernel-team@fb.com
References: <20210313193537.1548766-1-andrii@kernel.org>
 <20210313193537.1548766-9-andrii@kernel.org>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <af200ca7-5946-9df6-71ec-98042aecfa27@isovalent.com>
Date:   Mon, 15 Mar 2021 09:24:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210313193537.1548766-9-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-03-13 11:35 UTC-0800 ~ Andrii Nakryiko <andrii@kernel.org>
> Add `bpftool gen object <output-file> <input_file>...` command to statically
> link multiple BPF ELF object files into a single output BPF ELF object file.
> 
> Similarly to existing '*.o' convention, bpftool is establishing a '*.bpfo'
> convention for statically-linked BPF object files. Both .o and .bpfo suffixes
> will be stripped out during BPF skeleton generation to infer BPF object name.
> 
> This patch also updates bash completions and man page. Man page gets a short
> section on `gen object` command, but also updates the skeleton example to show
> off workflow for BPF application with two .bpf.c files, compiled individually
> with Clang, then resulting object files are linked together with `gen object`,
> and then final object file is used to generate usable BPF skeleton. This
> should help new users understand realistic workflow w.r.t. compiling
> mutli-file BPF application.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  .../bpf/bpftool/Documentation/bpftool-gen.rst | 65 +++++++++++++++----
>  tools/bpf/bpftool/bash-completion/bpftool     |  2 +-
>  tools/bpf/bpftool/gen.c                       | 49 +++++++++++++-
>  3 files changed, 99 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> index 84cf0639696f..4cdce187c393 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> @@ -14,16 +14,37 @@ SYNOPSIS
>  
>  	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] }
>  
> -	*COMMAND* := { **skeleton** | **help** }
> +	*COMMAND* := { **object** | **skeleton** | **help** }
>  
>  GEN COMMANDS
>  =============
>  
> +|	**bpftool** **gen object** *OUTPUT_FILE* *INPUT_FILE* [*INPUT_FILE*...]
>  |	**bpftool** **gen skeleton** *FILE*
>  |	**bpftool** **gen help**
>  
>  DESCRIPTION
>  ===========
> +	**bpftool gen object** *OUTPUT_FILE* *INPUT_FILE* [*INPUT_FILE*...]
> +		  Statically link (combine) together one or more *INPUT_FILE*'s
> +		  into a single resulting *OUTPUT_FILE*. All the files involed

Typo: "involed"

> +		  are BPF ELF object files.
> +
> +		  The rules of BPF static linking are mostly the same as for
> +		  user-space object files, but in addition to combining data
> +		  and instruction sections, .BTF and .BTF.ext (if present in
> +		  any of the input files) data are combined together. .BTF
> +		  data is deduplicated, so all the common types across
> +		  *INPUT_FILE*'s will only be represented once in the resulting
> +		  BTF information.
> +
> +		  BPF static linking allows to partition BPF source code into
> +		  individually compiled files that are then linked into
> +		  a single resulting BPF object file, which can be used to
> +		  generated BPF skeleton (with **gen skeleton** command) or
> +		  passed directly into **libbpf** (using **bpf_object__open()**
> +		  family of APIs).
> +
>  	**bpftool gen skeleton** *FILE*
>  		  Generate BPF skeleton C header file for a given *FILE*.
>  

> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index fdffbc64c65c..7ca23c58f2c0 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -981,7 +981,7 @@ _bpftool()
>              ;;
>          gen)
>              case $command in
> -                skeleton)
> +                object|skeleton)
>                      _filedir
>                      ;;
>                  *)

Suggesting the "object" keyword for completing "bpftool gen [tab]"
is missing. It is just a few lines below:

------
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index fdffbc64c65c..223438e86932 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -981,12 +981,12 @@ _bpftool()
             ;;
         gen)
             case $command in
-                skeleton)
+                object|skeleton)
                     _filedir
                     ;;
                 *)
                     [[ $prev == $object ]] && \
-                        COMPREPLY=( $( compgen -W 'skeleton help' -- "$cur" ) )
+                        COMPREPLY=( $( compgen -W 'object skeleton help' -- "$cur" ) )
                     ;;
             esac
             ;;
------

Looks good otherwise. Thanks for the documentation, it's great to
have the example in the man page.

Pending the two nits above are fixed:
Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Quentin
