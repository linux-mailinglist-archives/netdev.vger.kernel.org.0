Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EA9514E5E
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiD2OzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378001AbiD2OzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:55:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FA9BCB64;
        Fri, 29 Apr 2022 07:51:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D814B835DA;
        Fri, 29 Apr 2022 14:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6BEC385AE;
        Fri, 29 Apr 2022 14:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651243910;
        bh=/tNeGJEj2+kvvWmI7bIPga1iSNKdlkHhuzWIc/IXbYk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q7Q5RptGMzsNElyqlpYDaSCaDwL0KcJ5y2ubm+yymVUpgX7tfI5RTmRpnvTCln0rU
         FADGqmEhLV/H3SkFfD3j6AjFDT/KKFLz6Od3y6ksZtzqLeFjxfZaxcyanPvAQvoq66
         T4+AiZUL/aYcRp8wxH6y28kTtQMbakTqR/zrmj47SHKSzZTKi1NF9W2It69RZSSrpL
         l6GM90sCQv1NYtODWzl6bAwf2YunBBwPU+RBNq1HR9A8HISvji4lzGFbkCukwPmP0e
         XDepgWsvAsZrBr4nC9KyEDYceptO90Z7GfoAHvCqt1KSSWdDH+B4FpeYY+ggNfTa/S
         /aotCLbTCiI/A==
Date:   Fri, 29 Apr 2022 23:51:45 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCHv4 bpf-next 1/5] kallsyms: Fully export
 kallsyms_on_each_symbol function
Message-Id: <20220429235145.f2feede9555d587c32fca328@kernel.org>
In-Reply-To: <20220428201207.954552-2-jolsa@kernel.org>
References: <20220428201207.954552-1-jolsa@kernel.org>
        <20220428201207.954552-2-jolsa@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 22:12:03 +0200
Jiri Olsa <jolsa@kernel.org> wrote:

> Fully exporting kallsyms_on_each_symbol function, so it can be used
> in following changes.
> 
> Rather than adding another ifdef option let's export the function
> completely (when CONFIG_KALLSYMS option is defined).
> 

This looks good to me.

Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>

Thanks!

> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/kallsyms.h | 7 ++++++-
>  kernel/kallsyms.c        | 2 --
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> index ce1bd2fbf23e..89f063651192 100644
> --- a/include/linux/kallsyms.h
> +++ b/include/linux/kallsyms.h
> @@ -65,11 +65,11 @@ static inline void *dereference_symbol_descriptor(void *ptr)
>  	return ptr;
>  }
>  
> +#ifdef CONFIG_KALLSYMS
>  int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
>  				      unsigned long),
>  			    void *data);
>  
> -#ifdef CONFIG_KALLSYMS
>  /* Lookup the address for a symbol. Returns 0 if not found. */
>  unsigned long kallsyms_lookup_name(const char *name);
>  
> @@ -163,6 +163,11 @@ static inline bool kallsyms_show_value(const struct cred *cred)
>  	return false;
>  }
>  
> +static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *, unsigned long),
> +					  void *data)
> +{
> +	return -EOPNOTSUPP;
> +}
>  #endif /*CONFIG_KALLSYMS*/
>  
>  static inline void print_ip_sym(const char *loglvl, unsigned long ip)
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 79f2eb617a62..fdfd308bebc4 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -228,7 +228,6 @@ unsigned long kallsyms_lookup_name(const char *name)
>  	return module_kallsyms_lookup_name(name);
>  }
>  
> -#ifdef CONFIG_LIVEPATCH
>  /*
>   * Iterate over all symbols in vmlinux.  For symbols from modules use
>   * module_kallsyms_on_each_symbol instead.
> @@ -251,7 +250,6 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
>  	}
>  	return 0;
>  }
> -#endif /* CONFIG_LIVEPATCH */
>  
>  static unsigned long get_symbol_pos(unsigned long addr,
>  				    unsigned long *symbolsize,
> -- 
> 2.35.1
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
