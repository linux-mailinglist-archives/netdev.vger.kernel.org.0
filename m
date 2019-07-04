Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 370C45F884
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfGDMse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:48:34 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34750 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfGDMse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 08:48:34 -0400
Received: by mail-lj1-f193.google.com with SMTP id p17so6084561ljg.1;
        Thu, 04 Jul 2019 05:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NGIpyvEtEXEdDEsWs3lSyzCAiq7xG0Rb+r1M3Ty+FsY=;
        b=pDpFgsi+MRZvsLbFOTZirUCzaMgToeUcdKHFWL3XJYy8ALaLEYw+QKonY3vgjjPEpU
         kotOLWqILgWdgwngvGZC+zSdI5k8unTWHjCgVDhLACdiMe6T30sVobNtoIresjTbRLnU
         iyhq5JhhwyTw86gmG7N3kzz6XGwVHVkrKNWFhlxizIvxP7Uvu/638Qgz+IR1V/eMCoWY
         uJnHxwZAuy1ysmCo4ZmMDtva3YmCjLPjOh72aPrWm1+bnzgB1fZesQmgiZaK9F57CkuX
         MpFB+zBauMqdY7PhUTAC2d/mmWg0SDw+qY22XpkZFNY12CBTPUxo0ULJ6x/tYhjc1noT
         Dy7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=NGIpyvEtEXEdDEsWs3lSyzCAiq7xG0Rb+r1M3Ty+FsY=;
        b=NcNb+Z0W4hTrtbVHw3p7iZXnHMYczRSyGoQ5BBYCRFd1gTwABu/V6CfAHtMF28XSoa
         oCuhRj5meKCY9Eocak0THjPIqRIBaO4D99atbro1mWfdA0AguqWvJnkNVO/0+1lKCLfv
         fhxjYBIz5ky/VVOQt4dL1JdeI2Qt+pJB1hyILj96YwB0sTRhQ3nzTbfhH1AhqR91Cz4t
         j7lYgFnH53R/GLkaZxy4kw83wzrRIdU2c+RwbRjQ17JgTv1znClHjV8mfFa1vhMKUy/n
         jmKpShhEtML8L9DsX3inf7JFYktwX1PWbTOHk/u3DKLuNhT7RxDDrFPeFFvjGnu9pKih
         c/eg==
X-Gm-Message-State: APjAAAVl5DfLbx/cd/FyPuBXX7M8M5vG12IuebnXqdtvsEATbuSlw66X
        luCIr6cnGadmcmXvGGCmpcM=
X-Google-Smtp-Source: APXvYqwjHC1uKAdinYH43yQIrLge10HErloqumUI+ywI0nseKWZP7Ywk5EoVemKvNYgjVhjXCjYNfQ==
X-Received: by 2002:a2e:9950:: with SMTP id r16mr25211593ljj.173.1562244512214;
        Thu, 04 Jul 2019 05:48:32 -0700 (PDT)
Received: from rric.localdomain (83-233-147-164.cust.bredband2.com. [83.233.147.164])
        by smtp.gmail.com with ESMTPSA id 89sm1126324ljs.48.2019.07.04.05.48.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Jul 2019 05:48:31 -0700 (PDT)
Date:   Thu, 4 Jul 2019 14:48:27 +0200
From:   Robert Richter <rric@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Frank Ch. Eigler" <fche@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jessica Yu <jeyu@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, jikos@kernel.org,
        mbenes@suse.cz, Petr Mladek <pmladek@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        paulmck <paulmck@linux.ibm.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        oprofile-list@lists.sf.net, netdev <netdev@vger.kernel.org>,
        bpf@vger.kernel.org
Subject: Re: [PATCH 2/3] module: Fix up module_notifier return values.
Message-ID: <20190704124827.hsuse5g3x5bgdgb3@rric.localdomain>
References: <20190624091843.859714294@infradead.org>
 <20190624092109.805742823@infradead.org>
 <320564860.243.1561384864186.JavaMail.zimbra@efficios.com>
 <20190624205810.GD26422@redhat.com>
 <20190625074214.GR3436@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625074214.GR3436@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.06.19 09:42:14, Peter Zijlstra wrote:
> On Mon, Jun 24, 2019 at 04:58:10PM -0400, Frank Ch. Eigler wrote:

> > From peterz's comments, the patches, it's not obvious to me how one is
> > to choose between 0 (NOTIFY_DONE) and 1 (NOTIFY_OK) in the case of a
> > routine success.
> 
> I'm not sure either; what I think I choice was:
> 
>  - if I want to completely ignore the callback, use DONE (per the
>    "Don't care" comment).
> 
>  - if we finished the notifier without error, use OK or
>    notifier_from_errno(0).
> 
> But yes, its a bit of a shit interface.

It looks like it was rarely used in earlier kernels as some sort of
error detection for the notifier calls, e.g.:

1da177e4c3f41524e886b7f1b8a0c1fc7321cac2:kernel/profile.c-int profile_handoff_task(struct task_struct * task)
1da177e4c3f41524e886b7f1b8a0c1fc7321cac2:kernel/profile.c-{
1da177e4c3f41524e886b7f1b8a0c1fc7321cac2:kernel/profile.c-      int ret;
1da177e4c3f41524e886b7f1b8a0c1fc7321cac2:kernel/profile.c-      read_lock(&handoff_lock);
1da177e4c3f41524e886b7f1b8a0c1fc7321cac2:kernel/profile.c-      ret = notifier_call_chain(&task_free_notifier, 0, task);
1da177e4c3f41524e886b7f1b8a0c1fc7321cac2:kernel/profile.c-      read_unlock(&handoff_lock);
1da177e4c3f41524e886b7f1b8a0c1fc7321cac2:kernel/profile.c:      return (ret == NOTIFY_OK) ? 1 : 0;
1da177e4c3f41524e886b7f1b8a0c1fc7321cac2:kernel/profile.c-}

So NOTIFY_OK was used to state there is no error, while NOTIFY_DONE
says the notifier was executed and there might have been errors. The
caller may distinguish the results then.

-Robert
