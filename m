Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5F251365F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348127AbiD1OKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240550AbiD1OJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:09:56 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A8E27CDD;
        Thu, 28 Apr 2022 07:06:41 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id z19so5640490edx.9;
        Thu, 28 Apr 2022 07:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QJZCrq2E0rQnS/46bb0lykjV+BZFhQWSf3jC5XNL6+g=;
        b=VG+XGeXwtrnao2belQIyDCpE53M+TwDLG20Z28noaE9BVO82F0ddshJZXxkTLWVum8
         UYkJLSUkmoK4IrzEOw+SOSZ4otS6LysxF3nZlcwmAldFEA3e3GvZtwE3Gt2cRMM0bpjb
         oBxXg38LRbYVwbCPAAXGtnh8uz9y2NJ/c471sBW6UBCQ0fmqVC/UYqiQclAFoSWe3Nin
         8mOZNTKMqB4r3rRd3+QM5+GHIIEjJUlefvO8CA/DNF+CaKHnjjNNjE8fYLj4N+Ul1gwL
         +qF5EOnp6Gx6L07d87O6MSNBxEmv7pl6ei+OsMOCo47eoL+0ryvZd5eXqCFWWTTs9LF4
         incg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QJZCrq2E0rQnS/46bb0lykjV+BZFhQWSf3jC5XNL6+g=;
        b=jNKAqjlcB3NsFyjUq50ElN4BkPODUl3wTVMMqiOMb0GLY8bBaXzDNnQhRn9uoIgGYl
         iI9AxZEnoQGfYtFj9lXgGvrG7w5cswY1dJS9wN1DUu6EmWf2dczpwYiXggFufPftWRTA
         Q4xPeHpQhUH0kyifPjTq0MGQw28TOwOTLlAbS0JmzE/3DAd50Cs7p4oxSuJ55sEq1Yh+
         xxOt6ekAzO/shh52RPNzKhREMXhdV8wvNQP/Kp5X/krle1VLKmnkdXfVlmsoLs4Z5aI5
         R+1YxFDHOfwCVE8D6CYfUz0GKL58NGu0ayK8ECVNYBBUSAhu4gc9b7w/Xkf2OnDp9vpI
         nH1A==
X-Gm-Message-State: AOAM5326WsQIfEbTX6McCD247E09PInlroHfzqZpwCgs3qL6Sjz6xEFH
        /B/hWpPtTnD4qHN88xGejAk=
X-Google-Smtp-Source: ABdhPJxTCl1+kKIl67NUFmKgRu5wamXoHx5lN8bjrDkSjVSzRa95wx4v0+F1jUFAHdsDFJfH4vzhjQ==
X-Received: by 2002:a05:6402:35d6:b0:425:f2c5:ba0d with SMTP id z22-20020a05640235d600b00425f2c5ba0dmr19355166edc.369.1651154799729;
        Thu, 28 Apr 2022 07:06:39 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id h7-20020a1709060f4700b006e8d0746969sm2158ejj.222.2022.04.28.07.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:06:38 -0700 (PDT)
Date:   Thu, 28 Apr 2022 16:06:35 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCHv3 bpf-next 1/5] kallsyms: Fully export
 kallsyms_on_each_symbol function
Message-ID: <Ymqfa6rooEIm4c/f@krava>
References: <20220427210345.455611-1-jolsa@kernel.org>
 <20220427210345.455611-2-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427210345.455611-2-jolsa@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 11:03:41PM +0200, Jiri Olsa wrote:
> Fully exporting kallsyms_on_each_symbol function, so it can be used
> in following changes.
> 
> Rather than adding another ifdef option let's export the function
> completely (when CONFIG_KALLSYMS option is defined).
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/kallsyms.h | 5 +++++
>  kernel/kallsyms.c        | 2 --
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> index ce1bd2fbf23e..d423f3cffa6d 100644
> --- a/include/linux/kallsyms.h
> +++ b/include/linux/kallsyms.h
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

got this one wrong, it needs one more change
I'll send new version

jirka


---
diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index ce1bd2fbf23e..89f063651192 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -65,11 +65,11 @@ static inline void *dereference_symbol_descriptor(void *ptr)
 	return ptr;
 }
 
+#ifdef CONFIG_KALLSYMS
 int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 				      unsigned long),
 			    void *data);
 
-#ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
 
@@ -163,6 +163,11 @@ static inline bool kallsyms_show_value(const struct cred *cred)
 	return false;
 }
 
+static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *, unsigned long),
+					  void *data)
+{
+	return -EOPNOTSUPP;
+}
 #endif /*CONFIG_KALLSYMS*/
 
 static inline void print_ip_sym(const char *loglvl, unsigned long ip)
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 79f2eb617a62..fdfd308bebc4 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -228,7 +228,6 @@ unsigned long kallsyms_lookup_name(const char *name)
 	return module_kallsyms_lookup_name(name);
 }
 
-#ifdef CONFIG_LIVEPATCH
 /*
  * Iterate over all symbols in vmlinux.  For symbols from modules use
  * module_kallsyms_on_each_symbol instead.
@@ -251,7 +250,6 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 	}
 	return 0;
 }
-#endif /* CONFIG_LIVEPATCH */
 
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
