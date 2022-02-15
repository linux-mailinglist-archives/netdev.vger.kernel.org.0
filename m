Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3FD4B6D48
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 14:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbiBONVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 08:21:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236342AbiBONVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 08:21:54 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B0E79207;
        Tue, 15 Feb 2022 05:21:42 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id qk11so23803022ejb.2;
        Tue, 15 Feb 2022 05:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WKmMxWqdYPFXSZT7mnWL7ZTECm1AlZU5riBIqMRpPLk=;
        b=khEWBHLG3bxk0ep72t8J9tQ2ji5KIGpBcbVhBbLYmgNbfXHxlp+yHg8p37+HRH+ynr
         g8Xm+W+L7Kb0NZqj1YUKEEa5lcKU8V06aEzdxIFp+V+E/1VBA8fno2UGwFRsIfFWYkCp
         qYXYn9xKBaSr8nZenVlqt+Ftw1QKhYIwDFL7Khw0MqOyUyLHgIftbcE03R5oHV0sW+NW
         btD5lS1JBdO6jiLeLKeu3Pk2yzDY8g/0YK9KGX/GloFYUslghiNB9Pyghat6RRPOrTNU
         TDyJjum3ihO2PandmEGOO0ZnebMbRelbYjTxGxw0cdaI8k3HFKTm7Q4TkAadqeS3elZT
         NJaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WKmMxWqdYPFXSZT7mnWL7ZTECm1AlZU5riBIqMRpPLk=;
        b=5k0VIELsNVESSgprLh/S1s7kDr7Bk3I9sceL06kCV+2whOayk75PNDpaoRSuB7f0qT
         o90F+N8MtHSM3Hr010PBVovkzxSvRx5nwwcayLjTRUtX3NB+wDoJ0kHd32KWt7Ci5fCG
         Gstycne6zK1UP3d1yTrTGXixGOopE1NC9miROMl7uZECXgx0umGawb4y5ZMZBcJPybDn
         C4Ve9WJ39HhfwVI397TL621Tk4LzU4Q9+WUjn3KyIn1b/ZisU50AMKDmAbdI5uo/zC8k
         T0kRdARVe74B9AVv4SK6W000NHzGXX3OmCncBiqAT1ts2XzFKmWgGl1fOEOJppiblAdK
         4cPg==
X-Gm-Message-State: AOAM532zu+COW0rYZr0DLB/hU+eqKb+MaAzJTvWV76LDx7Cq3uwSTiBX
        U4UpJBerAQAYkbRa+emGfps=
X-Google-Smtp-Source: ABdhPJxl5M2BirM/42uwxouKJhl0w1w/Nqs69MkCi0ECifwJu5pg6fOelPmdCj6CgindrHzNEn4r4g==
X-Received: by 2002:a17:906:99c6:: with SMTP id s6mr2491054ejn.747.1644931300538;
        Tue, 15 Feb 2022 05:21:40 -0800 (PST)
Received: from krava ([83.240.63.12])
        by smtp.gmail.com with ESMTPSA id er13sm2444178edb.21.2022.02.15.05.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 05:21:39 -0800 (PST)
Date:   Tue, 15 Feb 2022 14:21:38 +0100
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
Message-ID: <Yguo4v7c+3A0oW/h@krava>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204125942.a4bda408f536c2e3248955e1@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 04, 2022 at 12:59:42PM +0900, Masami Hiramatsu wrote:
> Hi Alexei,
> 
> On Thu, 3 Feb 2022 18:42:22 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > On Thu, Feb 3, 2022 at 6:19 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > On Thu, 3 Feb 2022 18:12:11 -0800
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > >
> > > > > No, fprobe is NOT kprobe on ftrace, kprobe on ftrace is already implemented
> > > > > transparently.
> > > >
> > > > Not true.
> > > > fprobe is nothing but _explicit_ kprobe on ftrace.
> > > > There was an implicit optimization for kprobe when ftrace
> > > > could be used.
> > > > All this new interface is doing is making it explicit.
> > > > So a new name is not warranted here.
> > > >
> > > > > from that viewpoint, fprobe and kprobe interface are similar but different.
> > > >
> > > > What is the difference?
> > > > I don't see it.
> > >
> > > IIUC, a kprobe on a function (or ftrace, aka fprobe) gives some extra
> > > abilities that a normal kprobe does not. Namely, "what is the function
> > > parameters?"
> > >
> > > You can only reliably get the parameters at function entry. Hence, by
> > > having a probe that is unique to functions as supposed to the middle of a
> > > function, makes sense to me.
> > >
> > > That is, the API can change. "Give me parameter X". That along with some
> > > BTF reading, could figure out how to get parameter X, and record that.
> > 
> > This is more or less a description of kprobe on ftrace :)
> > The bpf+kprobe users were relying on that for a long time.
> > See PT_REGS_PARM1() macros in bpf_tracing.h
> > They're meaningful only with kprobe on ftrace.
> > So, no, fprobe is not inventing anything new here.
> 
> Hmm, you may be misleading why PT_REGS_PARAM1() macro works. You can use
> it even if CONFIG_FUNCITON_TRACER=n if your kernel is built with
> CONFIG_KPROBES=y. It is valid unless you put a probe out of function
> entry.
> 
> > No one is using kprobe in the middle of the function.
> > It's too difficult to make anything useful out of it,
> > so no one bothers.
> > When people say "kprobe" 99 out of 100 they mean
> > kprobe on ftrace/fentry.
> 
> I see. But the kprobe is kprobe. It is not designed to support multiple
> probe points. If I'm forced to say, I can rename the struct fprobe to
> struct multi_kprobe, but that doesn't change the essence. You may need
> to use both of kprobes and so-called multi_kprobe properly. (Someone
> need to do that.)

hi,
tying to kick things further ;-) I was thinking about bpf side of this
and we could use following interface:

  enum bpf_attach_type {
    ...
    BPF_TRACE_KPROBE_MULTI
  };

  enum bpf_link_type {
    ...
    BPF_LINK_TYPE_KPROBE_MULTI
  };

  union bpf_attr {

    struct {
      ...
      struct {
        __aligned_u64   syms;
        __aligned_u64   addrs;
        __aligned_u64   cookies;
        __u32           cnt;
        __u32           flags;
      } kprobe_multi;
    } link_create;
  }

because from bpf user POV it's new link for attaching multiple kprobes
and I agree new 'fprobe' type name in here brings more confusion, using
kprobe_multi is straightforward

thoguhts?

thanks,
jirka
