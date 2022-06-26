Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D23855B280
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 16:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiFZOpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 10:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFZOpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 10:45:45 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B0DDFD4;
        Sun, 26 Jun 2022 07:45:43 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id c13so9706823eds.10;
        Sun, 26 Jun 2022 07:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bIMKDBig1maexVfXVGf3hHvuLRrK8hEhsnsL3tm2gHY=;
        b=oJ5xCy2XbaMLUKI0Zl7eQai0P3WTwCQ4U26EEiEZ1IXGA5mUn+OmpdH2KsN0j6Xbx4
         1FFyJ7nKImJIVoMQBezO9VWz6mlt5PsDknCv1ndyTkyPCXWH9Un29Bt+kvwRjNuAW01B
         IWx1csUkU1Jg3ew9xYxGXLvWFNqJhmnJbp6Ir0IDKY1/wRmy2jUZKbLltvBk7EQGOE4l
         5WIjxJzdFtXjM9sd1hDgIpwuSmlR9U+R4jdHscOc5QoH15I4jDTOdCAVPjHKZzdMBMHn
         jo9q+xHwsNEXlvPohR3ZEJts4XcWnruRcRr4tL9QG02P8FPMqs5036CcCJKWr2qyUQWG
         NJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bIMKDBig1maexVfXVGf3hHvuLRrK8hEhsnsL3tm2gHY=;
        b=FUfqrc3X98KmSxhCS+WR7luGH1LHHEiUnyTS1ccrhr5YIzo+JvhBIrSgYG8dexp2C8
         lg6N/3ePHRWcHHGSK1Z7bQdIgduhVYrLG9vOBQ8l1JQb5RVbpN5tpFrL7KkAROps5AGd
         GJPa8fCyXZDhFPZZUBT7lHYa1Vr9vl2M+oqWaMzfB1t6cgdhXXaqda7uxgHR3IcIgIGm
         cppGVGBLiJCJTLxBVUE0dULl6mr/4luvR6y6BV8a+amvR+vBPBLGYWzj5vhfvtl+EEL+
         iwsArdGHoWZPGxoKg+SB6QgPZcyKM4F7xNw4N9RMzm1NM7nhsHc+7BjFl/c8kS3p5NYH
         9XTg==
X-Gm-Message-State: AJIora8qUwXBhXDidsfugj0Apl9+EJFIbQvtpltn9IiaM8w4YYVLrVTO
        PHkr6TtJc8GEYkHpu5rkgWk=
X-Google-Smtp-Source: AGRyM1tAPMWyeRVEd9C6eKkGB8Rs9tPJ/M2KKoE1rbQMulc466FSETvA/4HuZRN40LPzJS5oUS6N/w==
X-Received: by 2002:a05:6402:428a:b0:42e:8f7e:1638 with SMTP id g10-20020a056402428a00b0042e8f7e1638mr11293288edc.228.1656254742328;
        Sun, 26 Jun 2022 07:45:42 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id d11-20020a1709064c4b00b0070cac22060esm3785328ejw.95.2022.06.26.07.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 07:45:41 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Sun, 26 Jun 2022 16:45:39 +0200
To:     Zixuan Tan <tanzixuangg@gmail.com>
Cc:     terrelln@fb.com, Zixuan Tan <tanzixuan.me@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] perf build: Suppress openssl v3 deprecation warnings in
 libcrypto feature test
Message-ID: <YrhxE4s0hLvbbibp@krava>
References: <20220625153439.513559-1-tanzixuan.me@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220625153439.513559-1-tanzixuan.me@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 25, 2022 at 11:34:38PM +0800, Zixuan Tan wrote:
> With OpenSSL v3 installed, the libcrypto feature check fails as it use the
> deprecated MD5_* API (and is compiled with -Werror). The error message is
> as follows.
> 
> $ make tools/perf
> ```
> Makefile.config:778: No libcrypto.h found, disables jitted code injection,
> please install openssl-devel or libssl-dev
> 
> Auto-detecting system features:
> ...                         dwarf: [ on  ]
> ...            dwarf_getlocations: [ on  ]
> ...                         glibc: [ on  ]
> ...                        libbfd: [ on  ]
> ...                libbfd-buildid: [ on  ]
> ...                        libcap: [ on  ]
> ...                        libelf: [ on  ]
> ...                       libnuma: [ on  ]
> ...        numa_num_possible_cpus: [ on  ]
> ...                       libperl: [ on  ]
> ...                     libpython: [ on  ]
> ...                     libcrypto: [ OFF ]
> ...                     libunwind: [ on  ]
> ...            libdw-dwarf-unwind: [ on  ]
> ...                          zlib: [ on  ]
> ...                          lzma: [ on  ]
> ...                     get_cpuid: [ on  ]
> ...                           bpf: [ on  ]
> ...                        libaio: [ on  ]
> ...                       libzstd: [ on  ]
> ...        disassembler-four-args: [ on  ]
> ```
> 
> This is very confusing because the suggested library (on my Ubuntu 20.04
> it is libssl-dev) is already installed. As the test only checks for the
> presence of libcrypto, this commit suppresses the deprecation warning to
> allow the test to pass.
> 
> Signed-off-by: Zixuan Tan <tanzixuan.me@gmail.com>
> ---
>  tools/build/feature/test-libcrypto.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/build/feature/test-libcrypto.c b/tools/build/feature/test-libcrypto.c
> index a98174e0569c..31afff093d0b 100644
> --- a/tools/build/feature/test-libcrypto.c
> +++ b/tools/build/feature/test-libcrypto.c
> @@ -2,6 +2,12 @@
>  #include <openssl/sha.h>
>  #include <openssl/md5.h>
>  
> +/*
> + * The MD5_* API have been deprecated since OpenSSL 3.0, which causes the
> + * feature test to fail silently. This is a workaround.
> + */

then we use these deprecated MD5 calls in util/genelf.c if libcrypto is detected,
so I wonder how come the rest of the compilation passed for you.. do you have
CONFIG_JITDUMP disabled?

thanks,
jirka

> +#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
> +
>  int main(void)
>  {
>  	MD5_CTX context;
> -- 
> 2.34.1
> 
