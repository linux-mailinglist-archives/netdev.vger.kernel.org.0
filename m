Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89404BA25C
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241371AbiBQOEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:04:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiBQOEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:04:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DC911C20;
        Thu, 17 Feb 2022 06:04:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38ED361D44;
        Thu, 17 Feb 2022 14:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FF8C340E9;
        Thu, 17 Feb 2022 14:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645106644;
        bh=5TQEKUug/zE0vEucMuLhHGprgquDacd/+Ob9lkA8xSg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KlsvN2xCKWDCfdXd5XQdF+jtciTljbVQ9GeaZXiY4YdPHVRzoBltADUSwbgMRU2s6
         O8tDc51XcwC7DcAzpAdGAT4NsdlFGyN/YVZNvameIaiiNCHXej8wemwB7kt1JwO5wR
         NTZTD0IP7xwvXxcrR/qr5LtXwjGFxWJaNZ96b3j9smAnmjSKqAWTmngR1Rd9p2GQMy
         +m9x5wvUasZ3Hd1CKBo3nWjs+t2u1gCVnda4rUXP/kqHZ+3Zt3f8szchiMnnzcXChe
         dkIhAr2A8yBq3NJzyEGHZurvdmZ5wKImgpRiwfx+nkoGlWXjTJsDawIBMjbEbLsKZe
         jfQv3BwzAqDrw==
Date:   Thu, 17 Feb 2022 23:03:57 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
Message-Id: <20220217230357.67d09baa261346a985b029b6@kernel.org>
In-Reply-To: <CAEf4BzYO_B51TPgUnDXUPUsK55RSczwcnhuLz9DMbfO5JCj=Cw@mail.gmail.com>
References: <Yfq+PJljylbwJ3Bf@krava>
        <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
        <YfvvfLlM1FOTgvDm@krava>
        <20220204094619.2784e00c0b7359356458ca57@kernel.org>
        <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com>
        <20220204110704.7c6eaf43ff9c8f5fe9bf3179@kernel.org>
        <CAADnVQJfq_10H0V+u0w0rzyZ9uy7vq=T-3BMDANjEN8A3-prsQ@mail.gmail.com>
        <20220203211954.67c20cd3@gandalf.local.home>
        <CAADnVQKjNJjZDs+ZV7vcusEkKuDq+sWhSD3M5GtvNeZMx3Fcmg@mail.gmail.com>
        <20220204125942.a4bda408f536c2e3248955e1@kernel.org>
        <Yguo4v7c+3A0oW/h@krava>
        <CAEf4BzYO_B51TPgUnDXUPUsK55RSczwcnhuLz9DMbfO5JCj=Cw@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 10:27:19 -0800
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Tue, Feb 15, 2022 at 5:21 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Fri, Feb 04, 2022 at 12:59:42PM +0900, Masami Hiramatsu wrote:
> > > Hi Alexei,
> > >
> > > On Thu, 3 Feb 2022 18:42:22 -0800
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > >
> > > > On Thu, Feb 3, 2022 at 6:19 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > >
> > > > > On Thu, 3 Feb 2022 18:12:11 -0800
> > > > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > > > No, fprobe is NOT kprobe on ftrace, kprobe on ftrace is already implemented
> > > > > > > transparently.
> > > > > >
> > > > > > Not true.
> > > > > > fprobe is nothing but _explicit_ kprobe on ftrace.
> > > > > > There was an implicit optimization for kprobe when ftrace
> > > > > > could be used.
> > > > > > All this new interface is doing is making it explicit.
> > > > > > So a new name is not warranted here.
> > > > > >
> > > > > > > from that viewpoint, fprobe and kprobe interface are similar but different.
> > > > > >
> > > > > > What is the difference?
> > > > > > I don't see it.
> > > > >
> > > > > IIUC, a kprobe on a function (or ftrace, aka fprobe) gives some extra
> > > > > abilities that a normal kprobe does not. Namely, "what is the function
> > > > > parameters?"
> > > > >
> > > > > You can only reliably get the parameters at function entry. Hence, by
> > > > > having a probe that is unique to functions as supposed to the middle of a
> > > > > function, makes sense to me.
> > > > >
> > > > > That is, the API can change. "Give me parameter X". That along with some
> > > > > BTF reading, could figure out how to get parameter X, and record that.
> > > >
> > > > This is more or less a description of kprobe on ftrace :)
> > > > The bpf+kprobe users were relying on that for a long time.
> > > > See PT_REGS_PARM1() macros in bpf_tracing.h
> > > > They're meaningful only with kprobe on ftrace.
> > > > So, no, fprobe is not inventing anything new here.
> > >
> > > Hmm, you may be misleading why PT_REGS_PARAM1() macro works. You can use
> > > it even if CONFIG_FUNCITON_TRACER=n if your kernel is built with
> > > CONFIG_KPROBES=y. It is valid unless you put a probe out of function
> > > entry.
> > >
> > > > No one is using kprobe in the middle of the function.
> > > > It's too difficult to make anything useful out of it,
> > > > so no one bothers.
> > > > When people say "kprobe" 99 out of 100 they mean
> > > > kprobe on ftrace/fentry.
> > >
> > > I see. But the kprobe is kprobe. It is not designed to support multiple
> > > probe points. If I'm forced to say, I can rename the struct fprobe to
> > > struct multi_kprobe, but that doesn't change the essence. You may need
> > > to use both of kprobes and so-called multi_kprobe properly. (Someone
> > > need to do that.)
> >
> > hi,
> > tying to kick things further ;-) I was thinking about bpf side of this
> > and we could use following interface:
> >
> >   enum bpf_attach_type {
> >     ...
> >     BPF_TRACE_KPROBE_MULTI
> >   };
> >
> >   enum bpf_link_type {
> >     ...
> >     BPF_LINK_TYPE_KPROBE_MULTI
> >   };
> >
> >   union bpf_attr {
> >
> >     struct {
> >       ...
> >       struct {
> >         __aligned_u64   syms;
> >         __aligned_u64   addrs;
> >         __aligned_u64   cookies;
> >         __u32           cnt;
> >         __u32           flags;
> >       } kprobe_multi;
> >     } link_create;
> >   }
> >
> > because from bpf user POV it's new link for attaching multiple kprobes
> > and I agree new 'fprobe' type name in here brings more confusion, using
> > kprobe_multi is straightforward
> >
> > thoguhts?
> 
> I think this makes sense. We do need new type of link to store ip ->
> cookie mapping anyways.

This looks good to me too.

> 
> Is there any chance to support this fast multi-attach for uprobe? If
> yes, we might want to reuse the same link for both (so should we name
> it more generically?

There is no interface to do that but also there is no limitation to
expand uprobes. For the kprobes, there are some limitations for the
function entry because it needs to share the space with ftrace. So
I introduced fprobe for easier to use.

> on the other hand BPF program type for uprobe is
> BPF_PROG_TYPE_KPROBE anyway, so keeping it as "kprobe" also would be
> consistent with what we have today).

Hmm, I'm not sure why BPF made such design choice... (Uprobe needs
the target program.)


> But yeah, the main question is whether there is something preventing
> us from supporting multi-attach uprobe as well? It would be really
> great for USDT use case.

Ah, for the USDT, it will be useful. But since now we will have "user-event"
which is faster than uprobes, we may be better to consider to use it.

I'm not so sure how uprobes probes the target process, but maybe it has
to manage some memory pages and task related things. If we can split
those task-related part from struct uprobe software-breakpoint part,
it maybe easy to support multiple probe (one task-related part + multiple
software-breakpoint parts.)

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
