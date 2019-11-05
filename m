Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8DEF0497
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 18:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390614AbfKER7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 12:59:11 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38523 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389356AbfKER7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 12:59:10 -0500
Received: by mail-pf1-f193.google.com with SMTP id c13so16120575pfp.5;
        Tue, 05 Nov 2019 09:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Zh8BqzKcHu4iycvFl+0Q9G2gU0hTqTDiqPfROxKjNUc=;
        b=cPuQWlLf0D+msHuC+LXMAGEwLjzyestgxxzyEizwUYsgE1h0VtZXAbjhBVeDzhLT3n
         MlEpTbBCTNN0pjWtP03+KLtph0dt8ySEbqRj0eXKGtDl8TlUsD0Tsjte/AmtxI1C2VbD
         3/A9Xi6DDGpR7ccJaTy6VDSUIrrTBYsCVQSAo8H41sFVI6oNb6iBRzFEFQesvx09bJGq
         Dpn1M4igRJH913oZYaEQDLBLJNIJynHTX6daHAVt6zNFDk6Vq67xyvgBSQe4lbx37ghE
         yBuCpynzSqOPgLUpGGxDfEC9hn6gH390gy3FwEDvdcZJUY94wiyrpCFhrJXXO/6jPMTT
         4BzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Zh8BqzKcHu4iycvFl+0Q9G2gU0hTqTDiqPfROxKjNUc=;
        b=GH9Pr5w/YjywA7QxoUf5x8IK3sai8DZl5Ws/h0szxJQAHMmfApa5Rn0Avwgm8bNPkn
         J0PeVJFSCTwuDgizK8AqE70CAOzyjxNvoJHHG1Tn8Pxu0UeyPVxMxFV525lUG764DvFv
         6THFV7+3S3Kj4EbpDHVblg1kbDP/5ZGAjRcPt/HvSX8ea/OWZ5PedICw1exH8/OtXVml
         uxeewX9XzrUAy8hJzJ2jcINd7YcXSPcvSl5K8IcQvjhMnV+snhAbHdcqHrA7hRo9O3Hf
         0E7OilwrTIzjsyMl4mMHwLEjSdPOe/fREqShBJvgPJ+E4FXWHP9LvVEjLKBn92DGM4Ga
         YTng==
X-Gm-Message-State: APjAAAV9mOrjFWHx0k6ukFmE6Cf0O0RAEJ2eY2NXTMNed6ZIhFnNS0TC
        FAASsEa8hNebQ3iiAK2+TJk=
X-Google-Smtp-Source: APXvYqwTPnk+nOy3MD/RDOJYpXAPDD1i8QxGTTSd1VvEIbiJXJvlo7ZS4X7Ww7SYv2hvJt9l5Ex9Bg==
X-Received: by 2002:a17:90a:3281:: with SMTP id l1mr350261pjb.43.1572976749115;
        Tue, 05 Nov 2019 09:59:09 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:47d0])
        by smtp.gmail.com with ESMTPSA id q20sm7523789pff.134.2019.11.05.09.59.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 09:59:08 -0800 (PST)
Date:   Tue, 5 Nov 2019 09:59:07 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, peterz@infradead.org, x86@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH bpf-next 0/7] Introduce BPF trampoline
Message-ID: <20191105175905.fenzkyottcnsw6kx@ast-mbp.dhcp.thefacebook.com>
References: <20191102220025.2475981-1-ast@kernel.org>
 <20191105143154.umojkotnvcx4yeuq@ast-mbp.dhcp.thefacebook.com>
 <20191105104024.4e99a630@grimm.local.home>
 <20191105154709.utmzm6qvtlux4hww@ast-mbp.dhcp.thefacebook.com>
 <20191105110028.7775192f@grimm.local.home>
 <20191105162801.sffoqe2yedrrplnn@ast-mbp.dhcp.thefacebook.com>
 <20191105122629.29aecc69@grimm.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105122629.29aecc69@grimm.local.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 12:26:29PM -0500, Steven Rostedt wrote:
> 
> I'm guessing it will use kprobes (or optimized probes). I haven't had a
> chance to look at your patches.

People complained that kprobe and especially kretprobe is too slow and too
unpredictable (not guarantees that prog will be executed and k*probe won't be
missed). For bpf to attach to fentry/fexit none of k*probe stuff is needed.

> I still think using the register_ftrace_direct() will be cleaner (as it
> is built on top of code that's been in the kernel for a decade).
> Perhaps we can make it work even without the full ftrace code.

Yes and I still agree that long term using register_ftrace_direct() is cleaner.
What I strongly disagree is that bpf developers need to wait for it to land.
Especially when there is no direct dependency. It's nice to have both bpf
trampoline and ftrace to be functional at the same time tracing the same kernel
function. But for the time being running one or another is an acceptable
limitation. Especially since the path to making it clean is already defined and
agreed.

