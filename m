Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE5A16AE85
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbgBXSRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:17:04 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34574 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBXSRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 13:17:04 -0500
Received: by mail-pl1-f195.google.com with SMTP id j7so4382636plt.1;
        Mon, 24 Feb 2020 10:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fpxGh78lri+FF2jGJPwT3ROkxj1dx52IpBbpwJRlISM=;
        b=hxUsAPPGZfuohNO9aKjobjWrDuyWd9hhWCIqdJ6bukofPpfOrnRfiY6tljv+cPE1bc
         MXUDGwhLCe/ZSEU2vUKlauVgol4jfkhwxeUZRN78R4zHAoM0OdqJadlLPwbn56bOtp8L
         ahZDiVMf+2sO4s6QkjK6NrXx+34AdtUvqdMeEDit0IJeP+N/H1G0kC4rPeH1kqTqaImn
         wgHXw3hzRWf3fFHU5BrdZJV9Qtbw6bOhirujA8XTMIJrSGuCe1aOsQsPsWl8srQzDX5K
         pUx9Ag6X35ChLEl9A+vqLmBz9hYBkQV8HNMfXCXa0mqDapY1QeFfci0KS1lAQVwrhEcD
         rhSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fpxGh78lri+FF2jGJPwT3ROkxj1dx52IpBbpwJRlISM=;
        b=giCLQMpln8v5/FcJr1UYV8sDm6SibazjOXHxecEF1FTg4Y7eaYa3YWNPCVL/WN5ifm
         KaerdLr7zhtppBSYpf1YbvGGi6ocXIBZHbI6t4cWtNgm/kQasKlt51Fj8aNBkwlcNnvH
         soRjaN/9jNRhqTNIWfGrheAxWLOyAeTjdd4CjufXI28ab7jaM0h88nv0RcBZ+AWyw0B9
         3xJxKaPfNQctB4gTnxfW+h7alW+lPWVWrc0LpXPLwH+Lzmxz95DMT2ygaX8gKDhSuPku
         DMIbLYq0DeiDOxy6Gj8HBDfFw5Hv+WroDRc8KzyfGya5oJ3coGSIdNx/L6n4PSFMrX/k
         376Q==
X-Gm-Message-State: APjAAAVJ/dI/6mo1xJZRDBWpmXZ3VHSWud1QBEIH5KDwF0W4awfiZPjd
        WGVjlywBeen+NglPCBT6pao=
X-Google-Smtp-Source: APXvYqysaQpDCQSEdFlZ2E82ILbvhKOsJAvGz4FeCn4Y1Tpz3wfedxfkwQeYuwsAfOUSRGimH/rP6Q==
X-Received: by 2002:a17:902:7797:: with SMTP id o23mr47821945pll.298.1582568223676;
        Mon, 24 Feb 2020 10:17:03 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::6:2457])
        by smtp.gmail.com with ESMTPSA id g24sm13545782pfk.92.2020.02.24.10.17.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:17:02 -0800 (PST)
Date:   Mon, 24 Feb 2020 10:16:59 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [patch V3 05/22] bpf/trace: Remove EXPORT from trace_call_bpf()
Message-ID: <20200224181657.ndgtotm3abigaqs5@ast-mbp>
References: <20200224140131.461979697@linutronix.de>
 <20200224145642.953923067@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224145642.953923067@linutronix.de>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 03:01:36PM +0100, Thomas Gleixner wrote:
> All callers are built in. No point to export this.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> V3: New patch 
> ---
>  kernel/trace/bpf_trace.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -119,7 +119,6 @@ unsigned int trace_call_bpf(struct trace
>  
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(trace_call_bpf);

Thanks for catching this.
Looking at my old commit 2541517c32be ("tracing, perf: Implement BPF programs attached to kprobes")
where I added this line I cannot figure out why I did so five years ago.
I'm guessing some earlier versions of the patches were calling it from
tracepoint macro and since tracepoints can be in modules I exported it.
Definitely shouldn't be an export symbol.
