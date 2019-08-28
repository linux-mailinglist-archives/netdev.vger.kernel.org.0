Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 105FD9F774
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 02:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfH1AiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 20:38:17 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40972 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfH1AiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 20:38:17 -0400
Received: by mail-pg1-f195.google.com with SMTP id x15so388126pgg.8;
        Tue, 27 Aug 2019 17:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1ba+Tj/p7u7dF9gT2DPoxWMYhBdJGqnWmgBcPXbvr14=;
        b=EuAImDaNHOYpRgdhagSiKgYNhmNmXJdCTP3fLpXHBHQpp343ylLK/oKJ6MdMz3Ejcr
         yfXQ4rN/V5FZDhY9h+mAHTD9VOE4m0HVZ1ZvMaJp29fvUjpTklgybEEi9GWPxb6uP3ub
         eu85+ArD//4dsaUJODceY+yb5i9Wq3OmwSy8N/HAi5EY7Wa+NNik/bTXrdvJ4fL2VYK9
         mI5W8RF95b7kHsYfzW8yfM15Y5neScXt2ZBJxLiVuoGDUO/7DoaaDs3KkadzFZ4Fqg3K
         8k/8hUo+TBpswgl9zP2k4JbxPlKmsSmK0etIR3buToz2k7TZUow2Bc8Oj3iAuT+PsNGP
         NaOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1ba+Tj/p7u7dF9gT2DPoxWMYhBdJGqnWmgBcPXbvr14=;
        b=BDG/CgaBB26KOUCRS1J7aYoAMt2aF/W0UWyn0myAOcEb2N0FQ6+DKXe9qntsKZxelV
         TNsksShXAvdsMYqT5CHG3p3eHvwunf31Q7pzBpKn/uvhYSbv93Pwg04/cYWIB3OYxTkX
         E7yxPnCRKzJs/N3HB7TPZKERb+e7ezOeDV0+FIp29hBjd0e7Pw8qMdyfXxNdDzx17Get
         hhJ5PAr5EZ36zP+bN2pwY49lJZCFB9Vm+bEi58IYJx6qscDzhy8Navh5ARdrlVc3qzzO
         Fs+QLDvOemj9TOPApRBTLMBrllDmgxUjYnJ4qHiqnDZDkyCvh06C38ujUv4vbECM4GoX
         WTtg==
X-Gm-Message-State: APjAAAV4CFuD2d9q0gWw1lIhJVsdUtdEbxTJv8G5V1ugpOku6KwnVVpQ
        W7pjC/5Sa9VauFlI/0ifIyM=
X-Google-Smtp-Source: APXvYqwK1bmDF8lgmWn4bYWNqNrM7VBHCr6ZUjQu4F1qkVwqvCdXVJbrGBgKWYztG7XYLV5L+XaJzw==
X-Received: by 2002:a63:e14d:: with SMTP id h13mr1050987pgk.431.1566952696173;
        Tue, 27 Aug 2019 17:38:16 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:d1e9])
        by smtp.gmail.com with ESMTPSA id a4sm509004pfi.55.2019.08.27.17.38.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 17:38:15 -0700 (PDT)
Date:   Tue, 27 Aug 2019 17:38:14 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20190828003813.fkar6udy5vq4loe5@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190827192144.3b38b25a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827192144.3b38b25a@gandalf.local.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 07:21:44PM -0400, Steven Rostedt wrote:
> 
> At least for CAP_TRACING (if it were to allow read/write access
> to /sys/kernel/tracing), that would be very useful. It would be useful
> to those that basically own their machines, and want to trace their
> applications all the way into the kernel without having to run as full
> root.

+1

The proposal is to have CAP_TRACING to control perf and ftrace.
perf and trace-cmd binaries could be installed with CAP_TRACING and that's
all they need to do full tracing.

I can craft a patch for perf_event_open side and demo CAP_TRACING.
Once that cap bit is ready you can use it on ftrace side?

> Should we allow CAP_TRACING access to /proc/kallsyms? as it is helpful
> to convert perf and trace-cmd's function pointers into names. Once you
> allow tracing of the kernel, hiding /proc/kallsyms is pretty useless.

yep.

