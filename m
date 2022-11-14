Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0D06276F7
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbiKNIBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236088AbiKNIBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:01:36 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E3CC48;
        Mon, 14 Nov 2022 00:01:33 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id y16so16582219wrt.12;
        Mon, 14 Nov 2022 00:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eANwCkb3Vp19xhtdhoIJYYHLk76oMsoOORUWfegYSaU=;
        b=FSPmjVA8A1plQhs8YuWo2yJXT4Rsg4nblJ72HfeTSst9Nf+zjXd0Fb5EWaP574sRti
         aUockDfFs3TgRtjbDAjOCQMnjRXT6/JmVnFd/EytBJ6WSSGE182OmFWQG+Du21vomG54
         U2AiFoHNSGcMO7f6m0saQHtI2kgE5irJEezPrVSxAEZEeDnmRtE9N6iJ7Vaoa1H3Fi94
         mGorkoyRTTcPgJFfE80b2WEcWjHV0HEjXRZMeuUh3Kzjph3NGcxeKAAZbQb87XnFE6at
         LoMSKaUPd0rPobyyDldM8Rah34dkVMMTgnGilhmVjm7H3BQOiJ/Ne/PD4ftwuiCh5y/p
         g7oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eANwCkb3Vp19xhtdhoIJYYHLk76oMsoOORUWfegYSaU=;
        b=f8BA9d4XEHHjCN/xZXMT1qJEcKnlfCbK5LNuLVxORLrgzZYppFQpONCKViD3TBZ16k
         BjTQSrRv2K4B/oNX1hBXrTc9tUhyGqhiB+UI8FpbG/UT2Z4v0WpW8v1fiFkzPBRye0DR
         /bQmEKd0CJa91pWAADviExjDuIb8tY73D4Q1KDm+Zz7WogRPskhxSaRa2zTbMHJSzT5z
         HufHgcO6hgLMW4i1wnc/KQQ0lXsnf9buKh1Iv5TqjRPQdQTOnXTfiuFZbRooA7wepjOT
         T2anXPXyOqw8Lf3SSgWAN2iy3ob/bSU4Y+Up9J/ymdxqwtP7lpXKtlUJOLKevOZf3/fa
         rtuA==
X-Gm-Message-State: ANoB5pnRnVKjugUq71u1wp1RF9MPN20gCSBdUoWWW8sZqQt+gLhdu9Ns
        fP6dmt2m+/emB+k/fn2rBSo=
X-Google-Smtp-Source: AA0mqf5PDMVUfikPG9pcFnonlJzOth4c+4Xk7cEOExUnK/u0nVqWpPav2IDrz4doZn1ieyGnApgvZQ==
X-Received: by 2002:adf:de04:0:b0:236:88a2:f072 with SMTP id b4-20020adfde04000000b0023688a2f072mr6692837wrm.516.1668412891629;
        Mon, 14 Nov 2022 00:01:31 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-8b88-53b7-c55c-8535.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:8b88:53b7:c55c:8535])
        by smtp.gmail.com with ESMTPSA id r15-20020a05600c35cf00b003a84375d0d1sm19128269wmq.44.2022.11.14.00.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 00:01:31 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 14 Nov 2022 09:01:29 +0100
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the modules tree
Message-ID: <Y3H12Xyt8ALo+HAU@krava>
References: <20221114111350.38e44eec@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114111350.38e44eec@canb.auug.org.au>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 11:13:50AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the modules tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> kernel/trace/ftrace.c: In function 'ftrace_lookup_symbols':
> kernel/trace/ftrace.c:8316:52: error: passing argument 1 of 'module_kallsyms_on_each_symbol' from incompatible pointer type [-Werror=incompatible-pointer-types]
>  8316 |         found_all = module_kallsyms_on_each_symbol(kallsyms_callback, &args);
>       |                                                    ^~~~~~~~~~~~~~~~~
>       |                                                    |
>       |                                                    int (*)(void *, const char *, long unsigned int)
> In file included from include/linux/device/driver.h:21,
>                  from include/linux/device.h:32,
>                  from include/linux/node.h:18,
>                  from include/linux/cpu.h:17,
>                  from include/linux/stop_machine.h:5,
>                  from kernel/trace/ftrace.c:17:
> include/linux/module.h:882:48: note: expected 'const char *' but argument is of type 'int (*)(void *, const char *, long unsigned int)'
>   882 | int module_kallsyms_on_each_symbol(const char *modname,
>       |                                    ~~~~~~~~~~~~^~~~~~~
> kernel/trace/ftrace.c:8316:71: error: passing argument 2 of 'module_kallsyms_on_each_symbol' from incompatible pointer type [-Werror=incompatible-pointer-types]
>  8316 |         found_all = module_kallsyms_on_each_symbol(kallsyms_callback, &args);
>       |                                                                       ^~~~~
>       |                                                                       |
>       |                                                                       struct kallsyms_data *
> include/linux/module.h:883:42: note: expected 'int (*)(void *, const char *, long unsigned int)' but argument is of type 'struct kallsyms_data *'
>   883 |                                    int (*fn)(void *, const char *, unsigned long),
>       |                                    ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> kernel/trace/ftrace.c:8316:21: error: too few arguments to function 'module_kallsyms_on_each_symbol'
>  8316 |         found_all = module_kallsyms_on_each_symbol(kallsyms_callback, &args);
>       |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/module.h:882:5: note: declared here
>   882 | int module_kallsyms_on_each_symbol(const char *modname,
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Caused by commit
> 
>   90de88426f3c ("livepatch: Improve the search performance of module_kallsyms_on_each_symbol()")
> 
> from the modules tree interatcing with commit
> 
>   3640bf8584f4 ("ftrace: Add support to resolve module symbols in ftrace_lookup_symbols")
> 
> from the next-next tree.
> 
> I have no idea how to easily fix this up, so I have used the modules
> tree from next-20221111 for today in the hope someone will send me a fix.

hi,
there's no quick fix.. I sent follow up email to the original
change and cc-ed you

thanks,
jirka
