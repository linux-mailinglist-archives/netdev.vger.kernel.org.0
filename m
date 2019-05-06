Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C43E0150FB
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 18:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfEFQOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 12:14:45 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44864 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbfEFQOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 12:14:44 -0400
Received: by mail-pf1-f195.google.com with SMTP id y13so7016796pfm.11
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 09:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z3pUfqa7gd7ssg4ALokCu3zp8vqsQw6UnB3He64S+ro=;
        b=txS+4YeGY/H0S3mICXO5X0wIehkEzXdpri2XdKbPxIONUrrYDOQ/b5DcvhMMPHEY0r
         KOfyyC3IEmPR2NHWqwych9DXW5MN64WHhTW2lyi1HzI6KRwVPWjbVxDG4Xn06HuG/K/K
         6wa6cnUwNwfMqS98pUQElA4gw+kVzawQYbw5Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z3pUfqa7gd7ssg4ALokCu3zp8vqsQw6UnB3He64S+ro=;
        b=gnmtbFBffH0lT8VAzfnx5DtxqaQAvws/hSfv1+ClwVQ9xfnnJni8LIPrfn8+A05ln4
         GYk+5Sy3xOeMr7hHB/g8maz4ypDFMTghPAAc98fky698AcDlMg6MQlYIhpJ+Zz02gLLX
         V+xbk5/NUhRPczQuWagQDnt0i3Nef9/Ker/O7/oT0QpbIyQ8rdJ4eTeSGviT4k5s83Dq
         6/WSK7hjaqlsnnW1dLAD/xWfJn9UmMiCihaHWbJwfCwR0RB37PtThgdLnnwKOGPhog1p
         ZTBEOfOky4Mh7yslndrXJ0BNsUjicj7yePSNwLD2VyL6WksYjRLJkVJO4G5rS5JJ4mhJ
         ll+Q==
X-Gm-Message-State: APjAAAVeVngjpjYmuG/3V9s8W1MugyfU8E+HDU+CyhtZaflCfAbhejzs
        KvqDHw+XglNJ7swoEPe4OrREbw==
X-Google-Smtp-Source: APXvYqzDM4UBpLP79cwiwJXWz9mzogsUcq++jnwygx905NSVdBAvAy2weNCMHUIvOQCc2MgQKU+Bow==
X-Received: by 2002:a63:6b49:: with SMTP id g70mr33374565pgc.340.1557159283609;
        Mon, 06 May 2019 09:14:43 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id h127sm14371516pgc.31.2019.05.06.09.14.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 09:14:41 -0700 (PDT)
Date:   Mon, 6 May 2019 12:14:29 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Michal Gregorczyk <michalgr@live.com>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Mohammad Husain <russoue@gmail.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        duyuchao <yuchao.du@unisoc.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] bpf: Add support for reading user pointers
Message-ID: <20190506161429.GB234965@google.com>
References: <20190502204958.7868-1-joel@joelfernandes.org>
 <20190506234751.65c92139dccbfa025bdfe300@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506234751.65c92139dccbfa025bdfe300@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 11:47:51PM +0900, Masami Hiramatsu wrote:
> Hi Joel,
> 
> On Thu,  2 May 2019 16:49:58 -0400
> "Joel Fernandes (Google)" <joel@joelfernandes.org> wrote:
> 
> > The eBPF based opensnoop tool fails to read the file path string passed
> > to the do_sys_open function. This is because it is a pointer to
> > userspace address and causes an -EFAULT when read with
> > probe_kernel_read. This is not an issue when running the tool on x86 but
> > is an issue on arm64. This patch adds a new bpf function call based
> > which calls the recently proposed probe_user_read function [1].
> > Using this function call from opensnoop fixes the issue on arm64.
> > 
> > [1] https://lore.kernel.org/patchwork/patch/1051588/
> 
> Anyway, this series is still out-of-tree. We have to push this or similar
> update into kernel at first. I can resend v7 on the latest -tip tree including
> this patch if you update the description.

Sounds good. I also have to split it up and add a deprecation for the old
API. I will get this done today and then you can include them in your series,
thanks! Once I send them, could you CC bpf maintainers on the patches too in
the future? thanks.

 - Joel

