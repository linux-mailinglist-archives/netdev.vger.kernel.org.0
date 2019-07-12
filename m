Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4F9665E7
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 06:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfGLEty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 00:49:54 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35495 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbfGLEty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 00:49:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id u14so3760458pfn.2
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 21:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sZaWxx8XHNIJMce0La5YzhGUKfsnDTNKcipBsPeCHZ0=;
        b=yOt7w/DexKthec8S9bla5Nx+r59GqFfAOL7iCfVyMvvo12JVGSvX3T81WoloMImi33
         kqYLvYFnbIzGBh0eyfsd9A0LnYst3mMT6/NJY4r3NhPNnt7TTUTpl2mOkUwjTOfy2DNL
         VOBKxv4cXPqq2gZ1bBRS4yYBmuTei0KY5yRss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sZaWxx8XHNIJMce0La5YzhGUKfsnDTNKcipBsPeCHZ0=;
        b=Y/M+xc14LnJ/Fq7rDNaTA35QJlPxt9KJFbNcz5Cq+UcJvwG5ZfeVxdKzMrNK7pnsRM
         +nbRcaKwb0ylaTbGQ3Ifeh/cukWqkDg87XI4K0ZovVmBpS/3KY2cw7dGx7yzl5r8/J8a
         wN/nLd2aNzQh+6YBKJYOg+F+mgMMsEiVfbYBFflQr1foM5bxa9mxAu6L787fJshIN29o
         W0W+wZ7lQkDAbVpHZaGu7ap87qULo3n9NxjTFGN2wsoTf/eXTkCpwVnjMFN9O0WKXOfM
         ip18n3zrPoxgDKbuZFFiSSPDlvwNKCa4ON/U56BleMMWWOG/Q6Z4E4N9vqIuYI769zUp
         blow==
X-Gm-Message-State: APjAAAVCStAv3OziCTfHu5/hVytjvA5ZFrV7kq1EL+NyD+f/3ffqMXXk
        yWSY9IL6yJKiw/AJoE8oHOY=
X-Google-Smtp-Source: APXvYqyKxfcbGoEQQr7C4E09kxjnHkhwtlg8G7zy1O2IKxrdHeSAKsj8iztsw+e5BFthlE80M3kf8A==
X-Received: by 2002:a63:c008:: with SMTP id h8mr4417616pgg.427.1562906993264;
        Thu, 11 Jul 2019 21:49:53 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id d14sm9667480pfo.154.2019.07.11.21.49.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 21:49:52 -0700 (PDT)
Date:   Fri, 12 Jul 2019 00:49:51 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org, oleg@redhat.com,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v1 1/6] rcu: Add support for consolidated-RCU reader
 checking
Message-ID: <20190712044951.GA92297@google.com>
References: <20190711234401.220336-1-joel@joelfernandes.org>
 <20190711234401.220336-2-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711234401.220336-2-joel@joelfernandes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 07:43:56PM -0400, Joel Fernandes (Google) wrote:
> This patch adds support for checking RCU reader sections in list
> traversal macros. Optionally, if the list macro is called under SRCU or
> other lock/mutex protection, then appropriate lockdep expressions can be
> passed to make the checks pass.
> 
> Existing list_for_each_entry_rcu() invocations don't need to pass the
> optional fourth argument (cond) unless they are under some non-RCU
> protection and needs to make lockdep check pass.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  include/linux/rculist.h  | 29 ++++++++++++++++++++++++-----
>  include/linux/rcupdate.h |  7 +++++++
>  kernel/rcu/Kconfig.debug | 11 +++++++++++
>  kernel/rcu/update.c      | 26 ++++++++++++++++++++++++++
>  4 files changed, 68 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index e91ec9ddcd30..78c15ec6b2c9 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -40,6 +40,23 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
>   */
>  #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
>  
> +/*
> + * Check during list traversal that we are within an RCU reader
> + */
> +
> +#define SIXTH_ARG(a1, a2, a3, a4, a5, a6, ...) a6
> +#define COUNT_VARGS(...) SIXTH_ARG(dummy, ## __VA_ARGS__, 4, 3, 2, 1, 0)

Fyi, I made a cosmetic change by deleting the above 2 unused macros.

- Joel

