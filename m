Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08F44EDE67
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239656AbiCaQJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiCaQJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:09:18 -0400
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC7A1F0CB9;
        Thu, 31 Mar 2022 09:07:30 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 6DF133D4E12;
        Thu, 31 Mar 2022 12:07:29 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id JRYGslxfhPRR; Thu, 31 Mar 2022 12:07:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 18AAA3D4E11;
        Thu, 31 Mar 2022 12:07:29 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 18AAA3D4E11
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1648742849;
        bh=jx6gZg83afo7MOp42wOlJpwj/Jm9YIc4UWICwF/Z2j0=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=MxoPp8bKKDLmzIwiElUJrkDBFIkC/Tr0HvvD/oqo2jBdk4bEwG8EXtSenwTDFjJnn
         SOPpEU3sM57D0c1BOOeqkYki945UhL/vwX6bo8ovSg2g9M6HHA+yzOBFktuPqXiA0Q
         ahD2cyihm7uLzv9aQrAgu+MGPgF/lJ3UcxlVgAcVYSh9sRRVVQwvvI55Yspx+kxZUx
         C8oWwwpyDltHmDupteLWI4LIkO7VCDtHeL7X0goq1o9D39Hx1DM5Fhu+ovdF/EUtih
         hYhofjbzJ6Bi6Lmwl2d4BAhA/EOJz28Z9Mu/OufavmNCTE3rcLZ+2yEX/Ro0AUZmSS
         7CP/ZgMXQ1J6w==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NP21fSpX9mGH; Thu, 31 Mar 2022 12:07:29 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 0588F3D4AEE;
        Thu, 31 Mar 2022 12:07:29 -0400 (EDT)
Date:   Thu, 31 Mar 2022 12:07:28 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <michal.lkml@markovi.net>,
        ndesaulniers <ndesaulniers@google.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Message-ID: <602770698.200731.1648742848915.JavaMail.zimbra@efficios.com>
In-Reply-To: <20220331081337.07ddf251@gandalf.local.home>
References: <20220330201755.29319-1-mathieu.desnoyers@efficios.com> <20220330162152.17b1b660@gandalf.local.home> <CAK7LNATm5FjZsXL6aKUMhXwQAqTuO9+LmAk3LGjpAib7NZBDmg@mail.gmail.com> <20220331081337.07ddf251@gandalf.local.home>
Subject: Re: [PATCH] tracing: do not export user_events uapi
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4203 (ZimbraWebClient - FF98 (Linux)/8.8.15_GA_4232)
Thread-Topic: tracing: do not export user_events uapi
Thread-Index: soUfjk+gMtJ4HZ3jFxLYOaG8qofUxg==
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Mar 31, 2022, at 8:13 AM, rostedt rostedt@goodmis.org wrote:

> On Thu, 31 Mar 2022 16:29:30 +0900
> Masahiro Yamada <masahiroy@kernel.org> wrote:
> 
>> Well, the intended usage of no-export-headers is to
>> cater to the UAPI supported by only some architectures.
>> We have kvm(_para).h here because not all architectures
>> support kvm.
>> 
>> If you do not want to export the UAPI,
>> you should not put it in include/uapi/.
>> 
>> After the API is finalized, you can move it to
>> include/uapi.
> 
> So a little bit of background. I and a few others thought it was done, and
> pushed it to Linus. Then when it made it into his tree (and mentioned on
> LWN) it got a wider audience that had concerns. After they brought up those
> concerns, we agreed that this needs a bit more work. I was hoping not to do
> a full revert and simply marked the change for broken so that it can be
> worked on upstream with the wider audience. Linus appears to be fine with
> this approach, as he helped me with my "mark for BROKEN" patch.
> 
> Mathieu's concern is that this header file could be used in older distros
> with newer kernels that have it implemented and added this to keep out of
> those older distros.
> 
> The options to make Mathieu sleep better at night are:
> 
> 1) this patch
> 
> 2) move this file out of uapi.

I would be fine with this approach as well. This is simple enough:

git mv include/uapi/linux/user_events.h include/linux/

and:

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 8b3d241a31c2..823d7b09dcba 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -18,7 +18,7 @@
 #include <linux/tracefs.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
-#include <uapi/linux/user_events.h>
+#include <linux/user_events.h>
 #include "trace.h"
 #include "trace_dynevent.h"

Including <linux/user_events.h> will continue to work even when the header is
moved to uapi in the future.

Thanks,

Mathieu


> 
> 3) revert the entire thing.
> 
> I really do not want to do #3 but I am willing to do 1 or 2.
> 
> -- Steve

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
