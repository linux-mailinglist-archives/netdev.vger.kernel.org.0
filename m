Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D896102618
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 15:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfKSONG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 09:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbfKSONG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 09:13:06 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9FBD2084D;
        Tue, 19 Nov 2019 14:13:05 +0000 (UTC)
Date:   Tue, 19 Nov 2019 09:13:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH 1/2] ftrace: Add modify_ftrace_direct()
Message-ID: <20191119091304.2c775b35@gandalf.local.home>
In-Reply-To: <CAADnVQ+OzTikM9EhrfsC7NFsVYhATW1SVHxK64w3xn9qpk81pg@mail.gmail.com>
References: <20191114194636.811109457@goodmis.org>
        <20191114194738.938540273@goodmis.org>
        <20191115215125.mbqv7taqnx376yed@ast-mbp.dhcp.thefacebook.com>
        <20191117171835.35af6c0e@gandalf.local.home>
        <CAADnVQ+OzTikM9EhrfsC7NFsVYhATW1SVHxK64w3xn9qpk81pg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Nov 2019 22:04:28 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> I took your for-next without the extra patch and used it from bpf trampoline.
> It's looking good so far. Passed basic testing. Will add more stress tests.
> 
> Do you mind doing:
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 73eb2e93593f..6ddb203ca550 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -256,16 +256,16 @@ struct ftrace_direct_func
> *ftrace_find_direct_func(unsigned long addr);
>  # define ftrace_direct_func_count 0
>  static inline int register_ftrace_direct(unsigned long ip, unsigned long addr)
>  {
> -       return -ENODEV;
> +       return -ENOTSUPP;
>  }
>  static inline int unregister_ftrace_direct(unsigned long ip, unsigned
> long addr)
>  {
> -       return -ENODEV;
> +       return -ENOTSUPP;
>  }
>  static inline int modify_ftrace_direct(unsigned long ip,
>                                        unsigned long old_addr,
> unsigned long new_addr)
>  {
> -       return -ENODEV;
> +       return -ENOTSUPP;
>  }
> 
> otherwise ENODEV is a valid error when ip is incorrect which is
> indistinguishable from ftrace not compiled in.

Sure I can add this. Want to add a Signed-off-by to it, and I'll just
pull it in directly? I can write up the change log.

-- Steve
