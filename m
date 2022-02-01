Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F274A66B0
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242673AbiBAU5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242678AbiBAU5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:57:47 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9BEC06173D
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 12:57:46 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id j5-20020a05600c1c0500b0034d2e956aadso2484284wms.4
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 12:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yZgI3rGwPdtf6bIo1mbV0jrhw/QwLBrtVEZ+lPWYMcw=;
        b=w+ilhFwsQxlZXMo+yL+IWPKpo1DVf8YbTO1/qXgGV4eBB1k1XAY6SwlD+ODGhakvPn
         HmqJvM+niYTIub1uhfzc1cQG3xpjW0JOaXdApDK3mJy4rXVoIHv+8/rfm3g6+EXVTCEn
         /5Feb8BtBigsIdw7H3jo/tiN+wtdHJBKQjZqINvd6BZgnC8KWz0BH7wWjY2KmkpVpfoU
         rsmxggM4Uf3qR0T/CKtOAlL19C3fAz7EBiK49xFNjNNKvgUovEbGb46ZnE584jr43Ecw
         vnn2smCQ8OgEntXhedlyJuzTERcCZQCxcww2YrHKPJ6YAhWiG3XvlqUEspPROPXO3wPq
         PrsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yZgI3rGwPdtf6bIo1mbV0jrhw/QwLBrtVEZ+lPWYMcw=;
        b=IvePteEziaBKu+rXh1DoFEQwXEXBtn/4H7FGNdn0+zepU9nz6ouRZqQpXl5YgWiC4p
         844Ev7yOj9dXwmmbqHmp0QCVh3NyD7JU6hn5IbjFkBOF2LWOQqLVfXUymzgsS56idAw5
         EK14v+Cixtr339kWXv+5wpjU62CGzd5VBDreQmQUE2TJ7XbBsZoY11aY4fBveejVxeM7
         S8YNL543ic6xhhO2nN1e8OW76Op/w98SM4CAv98QIohaGwv8f9guk2wnXFpLpFRocKTs
         0xJ1OjLLPnycEYFpBtYFetGGB2q3XJ03FqAq8VSYN9SU6WKUur+WUxYYays0NnpUwZ1l
         +tpA==
X-Gm-Message-State: AOAM531utxPdB642bZRb4NLoftox8jW4UrzoX15TYMTPG5nyTOIT9uX+
        P3994dga4cD7KGHsxPL2UsqFCA==
X-Google-Smtp-Source: ABdhPJy/SDLvPgW9J3b4jenTPGlLpLs0oVZJJ4TrSSECY6ygmJWF0e5NTuuNjkQkTmRja1lqiyRb8g==
X-Received: by 2002:a05:600c:4ed3:: with SMTP id g19mr3410359wmq.186.1643749064991;
        Tue, 01 Feb 2022 12:57:44 -0800 (PST)
Received: from [192.168.1.8] ([149.86.72.139])
        by smtp.gmail.com with ESMTPSA id q13sm15870065wrd.78.2022.02.01.12.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 12:57:44 -0800 (PST)
Message-ID: <d1b23ebb-21ac-558b-36a8-918b0c6cf909@isovalent.com>
Date:   Tue, 1 Feb 2022 20:57:43 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v5 5/9] bpftool: Implement btfgen()
Content-Language: en-GB
To:     =?UTF-8?Q?Mauricio_V=c3=a1squez?= <mauricio@kinvolk.io>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
References: <20220128223312.1253169-1-mauricio@kinvolk.io>
 <20220128223312.1253169-6-mauricio@kinvolk.io>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220128223312.1253169-6-mauricio@kinvolk.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-01-28 17:33 UTC-0500 ~ Mauricio Vásquez <mauricio@kinvolk.io>
> btfgen() receives the path of a source and destination BTF files and a
> list of BPF objects. This function records the relocations for all
> objects and then generates the BTF file by calling btfgen_get_btf()
> (implemented in the following commits).
> 
> btfgen_record_obj() loads the BTF and BTF.ext sections of the BPF
> objects and loops through all CO-RE relocations. It uses
> bpf_core_calc_relo_insn() from libbpf and passes the target spec to
> btfgen_record_reloc() that saves the types involved in such relocation.
> 
> Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/bpf/bpftool/Makefile |   8 +-
>  tools/bpf/bpftool/gen.c    | 221 ++++++++++++++++++++++++++++++++++++-
>  2 files changed, 223 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index 83369f55df61..97d447135536 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -34,10 +34,10 @@ LIBBPF_BOOTSTRAP_INCLUDE := $(LIBBPF_BOOTSTRAP_DESTDIR)/include
>  LIBBPF_BOOTSTRAP_HDRS_DIR := $(LIBBPF_BOOTSTRAP_INCLUDE)/bpf
>  LIBBPF_BOOTSTRAP := $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
>  
> -# We need to copy hashmap.h and nlattr.h which is not otherwise exported by
> -# libbpf, but still required by bpftool.
> -LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nlattr.h)
> -LIBBPF_BOOTSTRAP_INTERNAL_HDRS := $(addprefix $(LIBBPF_BOOTSTRAP_HDRS_DIR)/,hashmap.h)
> +# We need to copy hashmap.h, nlattr.h, relo_core.h and libbpf_internal.h
> +# which are not otherwise exported by libbpf, but still required by bpftool.
> +LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nlattr.h relo_core.h libbpf_internal.h)
> +LIBBPF_BOOTSTRAP_INTERNAL_HDRS := $(addprefix $(LIBBPF_BOOTSTRAP_HDRS_DIR)/,hashmap.h relo_core.h libbpf_internal.h)

Do you directly call functions from relo_core.h, or is it only required
to compile libbpf_internal.h? (Asking because I'm wondering if there
would be a way to have one fewer header copied).
