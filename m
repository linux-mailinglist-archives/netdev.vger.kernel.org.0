Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E967869C47
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732930AbfGOUCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731540AbfGOUCh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 16:02:37 -0400
Received: from localhost (unknown [69.71.4.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A8A620659;
        Mon, 15 Jul 2019 20:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563220956;
        bh=YctKhCkISL0QPipV+bux3pgwhg/+Wfr5uFkoRtTAvW4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zpmgc+90naNM5ZNKifvDCcoZ3spBOmMeL6aUQCdQN6DChBG1dtV+fiAmUZdgdt7Nv
         WepQllK+1iqQA9GayKjQYU7a8D6suBSxT0G6Ps5JjrhQxY6MeINoIye7/tO5Ql8yWg
         wSYw4E9KxCddQ4CbrfQgZiLypFMsonffeLgLmMiw=
Date:   Mon, 15 Jul 2019 15:02:35 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 7/9] x86/pci: Pass lockdep condition to pcm_mmcfg_list
 iterator (v1)
Message-ID: <20190715200235.GG46935@google.com>
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-8-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715143705.117908-8-joel@joelfernandes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 10:37:03AM -0400, Joel Fernandes (Google) wrote:
> The pcm_mmcfg_list is traversed with list_for_each_entry_rcu without a
> reader-lock held, because the pci_mmcfg_lock is already held. Make this
> known to the list macro so that it fixes new lockdep warnings that
> trigger due to lockdep checks added to list_for_each_entry_rcu().
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Ingo takes care of most patches to this file, but FWIW,

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I would personally prefer if you capitalized the subject to match the
"x86/PCI:" convention that's used fairly consistently in
arch/x86/pci/.

Also, I didn't apply this to be sure, but it looks like this might
make a line or two wider than 80 columns, which I would rewrap if I
were applying this.

> ---
>  arch/x86/pci/mmconfig-shared.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
> index 7389db538c30..6fa42e9c4e6f 100644
> --- a/arch/x86/pci/mmconfig-shared.c
> +++ b/arch/x86/pci/mmconfig-shared.c
> @@ -29,6 +29,7 @@
>  static bool pci_mmcfg_running_state;
>  static bool pci_mmcfg_arch_init_failed;
>  static DEFINE_MUTEX(pci_mmcfg_lock);
> +#define pci_mmcfg_lock_held() lock_is_held(&(pci_mmcfg_lock).dep_map)
>  
>  LIST_HEAD(pci_mmcfg_list);
>  
> @@ -54,7 +55,7 @@ static void list_add_sorted(struct pci_mmcfg_region *new)
>  	struct pci_mmcfg_region *cfg;
>  
>  	/* keep list sorted by segment and starting bus number */
> -	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list) {
> +	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list, pci_mmcfg_lock_held()) {
>  		if (cfg->segment > new->segment ||
>  		    (cfg->segment == new->segment &&
>  		     cfg->start_bus >= new->start_bus)) {
> @@ -118,7 +119,7 @@ struct pci_mmcfg_region *pci_mmconfig_lookup(int segment, int bus)
>  {
>  	struct pci_mmcfg_region *cfg;
>  
> -	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list)
> +	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list, pci_mmcfg_lock_held())
>  		if (cfg->segment == segment &&
>  		    cfg->start_bus <= bus && bus <= cfg->end_bus)
>  			return cfg;
> -- 
> 2.22.0.510.g264f2c817a-goog
> 
