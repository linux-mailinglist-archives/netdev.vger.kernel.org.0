Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EC8486E10
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 00:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245693AbiAFXwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 18:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245586AbiAFXwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 18:52:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81F6C061245;
        Thu,  6 Jan 2022 15:52:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80FD3B8248C;
        Thu,  6 Jan 2022 23:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B68BC36AE0;
        Thu,  6 Jan 2022 23:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641513129;
        bh=VzdssKBsKk7ql2J3op87GHuQU0+WMaZqZn3eCOALKqY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aphWZ8SsaGIWBqMqJ9z9YkF62sPs4y/85qzCZ8YpNbjjV/KPvgL6HJfCH1DKGow0P
         ipY+zYcJr3if5+gWaaYxenC59nNOpgcmha/2YZKAi0RyuWAwnnlpiotuf1NNblIJI5
         V0VhWSLFOCj2liwNqCaAcPjtxVI/N2G/ZmDsl7fR27/fSCPjxTOcgtDA1Dy3q2QTIW
         m7MkdfC4/hijA0DqbtezkrOKOrj+07FQE40Ka9DIinpW+l2mvNg5FgFZDSRCM03FJQ
         2EdI87ovGmcvprMA8xxoxJ6oqEML7gOv0kZxupA0tW6SRza0KDUTac7ubWO2KjCOo7
         JWyIKXDcvscDQ==
Date:   Fri, 7 Jan 2022 08:52:03 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC 00/13] kprobe/bpf: Add support to attach multiple kprobes
Message-Id: <20220107085203.14f9c06e0537ea6b00779842@kernel.org>
In-Reply-To: <CAADnVQLjjcsckQVqaSB8ODB4FKdVUt-PB9xyJ3FAa2GWGLbHgA@mail.gmail.com>
References: <20220104080943.113249-1-jolsa@kernel.org>
        <20220106002435.d73e4010c93462fbee9ef074@kernel.org>
        <YdaoTuWjEeT33Zzm@krava>
        <20220106225943.87701fcc674202dc3e172289@kernel.org>
        <CAADnVQLjjcsckQVqaSB8ODB4FKdVUt-PB9xyJ3FAa2GWGLbHgA@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jan 2022 09:40:17 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Jan 6, 2022 at 5:59 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > That seems to bind your mind. The program type is just a programing
> > 'model' of the bpf. You can choose the best implementation to provide
> > equal functionality. 'kprobe' in bpf is just a name that you call some
> > instrumentations which can probe kernel code.
> 
> No. We're not going to call it "fprobe" or any other name.
> From bpf user's pov it's going to be "multi attach kprobe",
> because this is how everyone got to know kprobes.
> The 99% usage is at the beginning of the funcs.
> When users say "kprobe" they don't care how kernel attaches it.
> The func entry limitation for "multi attach kprobe" is a no-brainer.

Agreed. I think I might mislead you. From the bpf user pov, it always be
shown as 'multi attached kprobes (but only for the function entry)'
the 'fprobe' is kernel internal API name.

> And we need both "multi attach kprobe" and "multi attach kretprobe"
> at the same time. It's no go to implement one first and the other
> some time later.

You can provide the interface to user space, but the kernel implementation
is optimized step by step. We can start it with using real multiple
kretprobes, and then, switch to 'fprobe' after integrating fgraph
callback. :)

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
