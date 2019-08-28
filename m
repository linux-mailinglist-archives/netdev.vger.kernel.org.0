Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D6C9F767
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 02:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfH1Aex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 20:34:53 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34652 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfH1Aex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 20:34:53 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so403403pgc.1;
        Tue, 27 Aug 2019 17:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NUmryPEAXWHJLAOvmfBA94jcpS7C9kyK0OpAiU2mZMc=;
        b=rd+9nMrWNiXmtYC1U0hcFOZzDPFxwuKPK/g4MvmWgK6QJzkVi2W4SbwjEKRMXQeYVr
         abZC3U3/7yCZFqdsSNf/AxrQuG4ety7GJizzW2AcOHMMqZsQfwXLXMSyw0RrvgdHIz0e
         C+PyCgvp7Brd9r3Fg6+BZS8kFiIzOEoqEK7cXxQj8icqg+KZrLNaBmzCs5Fl6jg0zj0B
         PggePThdgP/GyBJh2PpFE8negEU2A7vRt0lU76pEJ9eiuIhdyyegRnj8+BR+GlaX1Rks
         2fQQMiy5qslYsP7ituUi+w+IxCy2zK0g3ROEmKHCKnwOc6dmMOAXUgfirx8KTkVJDW01
         kzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NUmryPEAXWHJLAOvmfBA94jcpS7C9kyK0OpAiU2mZMc=;
        b=IildEtl0cMcbPHk30Jl5JpMEZdSTEkKYf95uVN2F0sSQ2K2SUYvTYUwtSHN9CrfAEH
         +j9h8LgNZOd53WQRuA8evEvOzCU4XX4bWiZQX831En9vd/fhLF7BNxMqxkKk2sZWx4vl
         k0MVyI8KhGU8mGIim5a6Gm9uV2+V2B7lUuS5OZz5WStaaZi+d9vk1sWC6pvRns+W8ErM
         AmDnn32ZxR9N8sOPqYVnNYohOMGA2KlJ7ebMSn+eeMQBV+HZybzSU+8CqvgABk+NpErM
         P/75bnXOJfj/j6empS1QRzYNYVrZjjB5W48FZ4QcUpDgR3w5iQaQJv7c/F0yt1FANaMv
         Pniw==
X-Gm-Message-State: APjAAAUAqrehULIj5wPtbvycM/K8OvAuvpvCxDyejW4KbbZcZVrAQB8E
        IjPsxrPFuGiSxR1EkIM+h0k=
X-Google-Smtp-Source: APXvYqzab5A9LI4QBxiWyHws3ABu2tbXQCxsq7Gy1cTSBav1IHIHizum5EiW881VRDJICDZ3urZBzw==
X-Received: by 2002:a63:7e1d:: with SMTP id z29mr1078731pgc.346.1566952491798;
        Tue, 27 Aug 2019 17:34:51 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:d1e9])
        by smtp.gmail.com with ESMTPSA id c13sm513259pfi.17.2019.08.27.17.34.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 17:34:51 -0700 (PDT)
Date:   Tue, 27 Aug 2019 17:34:49 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 04:01:08PM -0700, Andy Lutomirski wrote:
> [adding some security and tracing folks to cc]
> 
> On Tue, Aug 27, 2019 at 1:52 PM Alexei Starovoitov <ast@kernel.org> wrote:
> >
> > Introduce CAP_BPF that allows loading all types of BPF programs,
> > create most map types, load BTF, iterate programs and maps.
> > CAP_BPF alone is not enough to attach or run programs.
> >
> > Networking:
> >
> > CAP_BPF and CAP_NET_ADMIN are necessary to:
> > - attach to cgroup-bpf hooks like INET_INGRESS, INET_SOCK_CREATE, INET4_CONNECT
> > - run networking bpf programs (like xdp, skb, flow_dissector)
> >
> > Tracing:
> >
> > CAP_BPF and perf_paranoid_tracepoint_raw() (which is kernel.perf_event_paranoid == -1)
> > are necessary to:
> > - attach bpf program to raw tracepoint
> > - use bpf_trace_printk() in all program types (not only tracing programs)
> > - create bpf stackmap
> >
> > To attach bpf to perf_events perf_event_open() needs to succeed as usual.
> >
> > CAP_BPF controls BPF side.
> > CAP_NET_ADMIN controls intersection where BPF calls into networking.
> > perf_paranoid_tracepoint_raw controls intersection where BPF calls into tracing.
> >
> > In the future CAP_TRACING could be introduced to control
> > creation of kprobe/uprobe and attaching bpf to perf_events.
> > In such case bpf_probe_read() thin wrapper would be controlled by CAP_BPF.
> > Whereas probe_read() would be controlled by CAP_TRACING.
> > CAP_TRACING would also control generic kprobe+probe_read.
> > CAP_BPF and CAP_TRACING would be necessary for tracing bpf programs
> > that want to use bpf_probe_read.
> 
> First, some high-level review:
> 
> Can you write up some clear documentation aimed at administrators that
> says what CAP_BPF does?  For example, is it expected that CAP_BPF by
> itself permits reading all kernel memory?

hmm. the answer is in the sentence you quoted right above.

> Can you give at least one fully described use case where CAP_BPF
> solves a real-world problem that is not solved by existing mechanisms?

bpftrace binary would be installed with CAP_BPF and CAP_TRACING.
bcc tools would be installed with CAP_BPF and CAP_TRACING.
perf binary would be installed with CAP_TRACING only.
XDP networking daemon would be installed with CAP_BPF and CAP_NET_ADMIN.
None of them would need full root.

> Changing the capability that some existing operation requires could
> break existing programs.  The old capability may need to be accepted
> as well.

As far as I can see there is no ABI breakage. Please point out
which line of the patch may break it.

> I'm inclined to suggest that CAP_TRACING be figured out or rejected
> before something like this gets applied.

that's fair.

> 
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> > I would prefer to introduce CAP_TRACING soon, since it
> > will make tracing and networking permission model symmetrical.
> >
> 
> Here's my proposal for CAP_TRACING, documentation-style:
> 
> --- begin ---
> 
> CAP_TRACING enables a task to use various kernel features to trace
> running user programs and the kernel itself.  CAP_TRACING also enables
> a task to bypass some speculation attack countermeasures.  A task in
> the init user namespace with CAP_TRACING will be able to tell exactly
> what kernel code is executed and when, and will be able to read kernel
> registers and kernel memory.  It will, similarly, be able to read the
> state of other user tasks.
> 
> Specifically, CAP_TRACING allows the following operations.  It may
> allow more operations in the future:
> 
>  - Full use of perf_event_open(), similarly to the effect of
> kernel.perf_event_paranoid == -1.

+1

>  - Loading and attaching tracing BPF programs, including use of BPF
> raw tracepoints.

-1

>  - Use of BPF stack maps.

-1

>  - Use of bpf_probe_read() and bpf_trace_printk().

-1

>  - Use of unsafe pointer-to-integer conversions in BPF.

-1

>  - Bypassing of BPF's speculation attack hardening measures and
> constant blinding.  (Note: other mechanisms might also allow this.)

-1
All of the above are allowed by CAP_BPF.
They are not allowed by CAP_TRACING.

> CAP_TRACING does not override normal permissions on sysfs or debugfs.
> This means that, unless a new interface for programming kprobes and
> such is added, it does not directly allow use of kprobes.

kprobes can be created via perf_event_open already.
So above statement contradicts your first statement.

> If CAP_TRACING, by itself, enables a task to crash or otherwise
> corrupt the kernel or other tasks, this will be considered a kernel
> bug.

+1

> CAP_TRACING in a non-init user namespace may, in the future, allow
> tracing of other tasks in that user namespace or its descendants.  It
> will not enable kernel tracing or tracing of tasks outside the user
> namespace in question.

I would avoid describing user ns for now.
There is enough confusion without it.

> --- end ---
> 
> Does this sound good?  The idea here is that CAP_TRACING should be
> very useful even without CAP_BPF, which allows CAP_BPF to be less
> powerful.

As proposed CAP_BPF does not allow tracing or networking on its own.
CAP_BPF only controls BPF side.

For example:
BPF_CALL_3(bpf_probe_read, void *, dst, u32, size, const void *, unsafe_ptr)
{
        int ret;

        ret = probe_kernel_read(dst, unsafe_ptr, size);
        if (unlikely(ret < 0))
                memset(dst, 0, size);

        return ret;
}

All of BPF (including prototype of bpf_probe_read) is controlled by CAP_BPF.
But the kernel primitives its using (probe_kernel_read) is controlled by CAP_TRACING.
Hence a task needs _both_ CAP_BPF and CAP_TRACING to attach and run bpf program
that uses bpf_probe_read.

Similar with all other kernel code that BPF helpers may call directly or indirectly.
If there is a way for bpf program to call into piece of code controlled by CAP_TRACING
such helper would need CAP_BPF and CAP_TRACING.
If bpf helper calls into something that may mangle networking packet
such helper would need both CAP_BPF and CAP_NET_ADMIN to execute.

> > @@ -2080,7 +2083,10 @@ static int bpf_prog_test_run(const union bpf_attr *attr,
> >         struct bpf_prog *prog;
> >         int ret = -ENOTSUPP;
> >
> > -       if (!capable(CAP_SYS_ADMIN))
> > +       if (!capable(CAP_NET_ADMIN) || !capable(CAP_BPF))
> > +               /* test_run callback is available for networking progs only.
> > +                * Add cap_bpf_tracing() above when tracing progs become runable.
> > +                */
> 
> I think test_run should probably be CAP_SYS_ADMIN forever.  test_run
> is the only way that one can run a bpf program and call helper
> functions via the program if one doesn't have permission to attach the
> program.  

Since CAP_BPF + CAP_NET_ADMIN allow attach. It means that a task
with these two permissions will have programs running anyway.
(traffic will flow through netdev, socket events will happen, etc)
Hence no reason to disallow running program via test_run.

