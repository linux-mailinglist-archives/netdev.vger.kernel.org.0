Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6A1213CFB
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 17:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgGCPuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 11:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgGCPui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 11:50:38 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EBEC08C5DF
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 08:50:37 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id l6so10950584pjq.1
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 08:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HE29F07Osusj5HNcfEPahMCK2eK+sh7WURl9R1YcKaA=;
        b=ZntdsKx0q/X5BPxShRDTPN11hCcSNaNHSwjYuk5fD2zlng44030b5MdJoootVDfoMt
         /zMEuSjPxSOlCICh/mSeuMSVGxvISSp17ScJcCfOsSQLQHmwf6J7V/nxPWaHl2Iyx6Fs
         qSddYBQyaFDD0x35D51sBJSuAMeRDMUD/R088=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HE29F07Osusj5HNcfEPahMCK2eK+sh7WURl9R1YcKaA=;
        b=azFcbMoUW5nuCp6Du2AnPzhwT8yjpLSbQAzuEZxOn0YFmtWGlql7oxBRofjk1y4rCx
         hP8dn/Gp2gsFgdCzUlkAEdQduyrtIHNCrNnt278kXANboh/R2fDgiIdysJtqZoYdC/Ky
         ZyJBiyXtRI0ehWX5T98Q0Ye2JN31ogIBTozJkgmT+/2wTJA6YnPprfe5jfm8hc4eTruS
         GIzdcQnTt+DpitX09lpkpypUejmlxnPPvTmXn+xRwz9Hv1uBo3VqewoHGXrDnhoI+nz6
         sCsrosjTs8qhL8zBXdfhcZzImn1o8jqKlellQcombuo8rTIrjsGu4G9y6FvjpPsxZk6L
         PflA==
X-Gm-Message-State: AOAM530SchA8T+3ct9lMh3Ei0F15u5xULoRqIdVq373+R7HaOlNL/U3L
        h4hxFFxLUJk6vAAWz4NkEGrc5Q==
X-Google-Smtp-Source: ABdhPJy2fp+PA9eTVGG0CLDemDjBxvxEKp4qXDHoN/nIW/lHbFv8vp/wBCvpcPnAWwfB3Q7cMslcYQ==
X-Received: by 2002:a17:902:7:: with SMTP id 7mr28627375pla.209.1593791437392;
        Fri, 03 Jul 2020 08:50:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d9sm11879987pgg.74.2020.07.03.08.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 08:50:36 -0700 (PDT)
Date:   Fri, 3 Jul 2020 08:50:35 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Dominik Czarnota <dominik.czarnota@trailofbits.com>,
        stable <stable@vger.kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] kprobes: Do not expose probe addresses to
 non-CAP_SYSLOG
Message-ID: <202007030848.265EA58@keescook>
References: <20200702232638.2946421-1-keescook@chromium.org>
 <20200702232638.2946421-5-keescook@chromium.org>
 <CAHk-=wiZi-v8Xgu_B3wV0B4RQYngKyPeONdiXNgrHJFU5jbe1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiZi-v8Xgu_B3wV0B4RQYngKyPeONdiXNgrHJFU5jbe1w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 06:00:17PM -0700, Linus Torvalds wrote:
> If somebody is interested in looking into things like that, it might
> be a good idea to have kernel threads with that counter incremented by
> default.

With 67 kthreads on a booted system, this patch does not immediately
blow up... And it likely needs some beautification. (Note that
current_cred_*() calls current_cred() under the hood, so AFAICT, only
current_cred() needs coverage.)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 18639c069263..a624847cb0ce 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -295,7 +295,10 @@ static inline void put_cred(const struct cred *_cred)
  * since nobody else can modify it.
  */
 #define current_cred() \
-	rcu_dereference_protected(current->cred, 1)
+({							\
+	WARN_ON_ONCE(current->warn_on_current_cred);	\
+	rcu_dereference_protected(current->cred, 1);	\
+})
 
 /**
  * current_real_cred - Access the current task's objective credentials
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b62e6aaf28f0..21ab1b81aa40 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -652,6 +652,7 @@ struct task_struct {
 	/* Per task flags (PF_*), defined further below: */
 	unsigned int			flags;
 	unsigned int			ptrace;
+	unsigned int			warn_on_current_cred;
 
 #ifdef CONFIG_SMP
 	struct llist_node		wake_entry;
diff --git a/kernel/fork.c b/kernel/fork.c
index 142b23645d82..2e181b9bfd3f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2527,8 +2527,12 @@ pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 		.stack		= (unsigned long)fn,
 		.stack_size	= (unsigned long)arg,
 	};
+	pid_t pid;
 
-	return _do_fork(&args);
+	pid = _do_fork(&args);
+	if (pid == 0)
+		current->warn_on_current_cred = 1;
+	return pid;
 }
 
 #ifdef __ARCH_WANT_SYS_FORK


-- 
Kees Cook
