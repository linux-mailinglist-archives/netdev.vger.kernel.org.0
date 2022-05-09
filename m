Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294C651F639
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 09:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbiEIH5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbiEIHsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:48:20 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC951868F6;
        Mon,  9 May 2022 00:44:27 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id w24so7473665edx.3;
        Mon, 09 May 2022 00:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wD4wrpiIMTLE9Vqz+Ed9vgX0VrJbTWHSjZ+io20J3fo=;
        b=h4gJikTU3Cz8vJBBSlLRki+np3eKR0zza5prIh81iPY82uz9IQ1WwVf4Ttfoj/EfHW
         /sKUaFlIAXGEY2G4ECavw+dI+egGB/GY1UCy+VzvYxX4Ge+YO4LnRatT0KU57boOWXIF
         qz8oTLtidikzGNd2A8AIHIe1t3Rw3ywQGP8DkK0Iu4Lye9N80V+o6d0E0TQUSmKuppvq
         rcDwRa5zNXzMGmCSzVk9wLxRKGJjNZ1fQDfhgVPB6D6hGfIIIAAbLK7n5Zwq2qmldcaK
         WB2w+44qxh9ZHqA+tBhKcErgy+wQFa+CddKHfjqEfB3NpOQJkECSnrHWITLr4yDk9vho
         Rx+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wD4wrpiIMTLE9Vqz+Ed9vgX0VrJbTWHSjZ+io20J3fo=;
        b=H/ZY4Mrz1TgOJE1fi23EcNPxDXs46LEi+xWvmmCfuXIwW6exR0d8Y61NRoGSRS3k90
         JHK3A6NAVSk6XvKEFh4wKog/Hble+S4AdnBp3W7UJ56g4jQsZcRe+hdNzRweyQvqfyfJ
         o+NwcgosH2EJPpXWZ0/DDMXRq34gOGHuoclBv+cwJ35IQKXT973YErqVRqp5tXAsQa5H
         STuRva/wH8MwDaJPuQjVKuCg3PKF/mZFxlt7EDpBUd5EHuqGqIGKo58NTp4FTU2D+rYV
         SO9TEzQEyikQTXsMAs+qiJI5im8oIOYtHTvcDDIOvB4e9BXyHhVDrLxSKInroAtpYVNs
         XD7Q==
X-Gm-Message-State: AOAM530Nij55NryIHIrFpUzzvhAdbzYIxjzJH+PlgYyh/eIeoveZnTnn
        7dRxYEFc5AsVYWj69GGgHZg=
X-Google-Smtp-Source: ABdhPJyV1V8PsnexpLQx6EIdUakk5hqvyL5bQJKgX/ebMB+dvxkgLCe5ZbC6JAhoIEWjVE6VAsC5Sg==
X-Received: by 2002:a05:6402:1297:b0:428:3848:a89d with SMTP id w23-20020a056402129700b004283848a89dmr16198006edv.94.1652082227109;
        Mon, 09 May 2022 00:43:47 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id dk20-20020a0564021d9400b0042617ba63c0sm5906742edb.74.2022.05.09.00.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 00:43:46 -0700 (PDT)
Date:   Mon, 9 May 2022 09:43:44 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCHv5 bpf-next 1/5] kallsyms: Fully export
 kallsyms_on_each_symbol function
Message-ID: <YnjGMAPFg+sIjrjk@krava>
References: <20220507125711.2022238-1-jolsa@kernel.org>
 <20220507125711.2022238-2-jolsa@kernel.org>
 <20220509060104.GB16939@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220509060104.GB16939@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 08:01:04AM +0200, Christoph Hellwig wrote:
> I'm not sure how I'm supposed to review just a patch 1 out of 5
> without the rest.

sorry, I did not think the rest was needed, full patchset is in here:
  https://lore.kernel.org/bpf/20220507125711.2022238-1-jolsa@kernel.org/

I'll cc you on full patchset in next version

> 
> What I can ѕay without the rest is that the subject line is wrong
> as nothing is exported, and that you are adding an overly long line.

right, how about the change below?

thanks,
jirka


---
Subject: [PATCH] kallsyms: Make kallsyms_on_each_symbol generally available

Making kallsyms_on_each_symbol generally available, so it can be
used outside CONFIG_LIVEPATCH option in following changes.

Rather than adding another ifdef option let's make the function
generally available (when CONFIG_KALLSYMS option is defined).

Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/kallsyms.h | 7 ++++++-
 kernel/kallsyms.c        | 2 --
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index ce1bd2fbf23e..ad39636e0c3f 100644
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
 
+static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
+					  unsigned long), void *data)
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
-- 
2.35.3

