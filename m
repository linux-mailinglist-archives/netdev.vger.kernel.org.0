Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62FF6AEEE
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 20:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388480AbfGPSnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 14:43:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58096 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728121AbfGPSnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 14:43:07 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6GIfd2P074022
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 14:43:06 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tsj86d57v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 14:43:06 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Tue, 16 Jul 2019 19:43:04 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e12.ny.us.ibm.com (146.89.104.199) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 16 Jul 2019 19:42:54 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6GIgsHl52756968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 18:42:54 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF32DB205F;
        Tue, 16 Jul 2019 18:42:53 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9394AB2065;
        Tue, 16 Jul 2019 18:42:53 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.225.134])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jul 2019 18:42:53 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id A30AF16C8F09; Tue, 16 Jul 2019 11:42:53 -0700 (PDT)
Date:   Tue, 16 Jul 2019 11:42:53 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, linux-kernel@vger.kernel.org,
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
        Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        peterz@infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 7/9] x86/pci: Pass lockdep condition to pcm_mmcfg_list
 iterator (v1)
Reply-To: paulmck@linux.ibm.com
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-8-joel@joelfernandes.org>
 <20190715200235.GG46935@google.com>
 <20190716040303.GA73383@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716040303.GA73383@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19071618-0060-0000-0000-0000035F2730
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011440; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01233109; UDB=6.00649719; IPR=6.01014420;
 MB=3.00027748; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-16 18:43:02
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071618-0061-0000-0000-00004A2A24B5
Message-Id: <20190716184253.GI14271@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160229
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 12:03:03AM -0400, Joel Fernandes wrote:
> On Mon, Jul 15, 2019 at 03:02:35PM -0500, Bjorn Helgaas wrote:
> > On Mon, Jul 15, 2019 at 10:37:03AM -0400, Joel Fernandes (Google) wrote:
> > > The pcm_mmcfg_list is traversed with list_for_each_entry_rcu without a
> > > reader-lock held, because the pci_mmcfg_lock is already held. Make this
> > > known to the list macro so that it fixes new lockdep warnings that
> > > trigger due to lockdep checks added to list_for_each_entry_rcu().
> > > 
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > 
> > Ingo takes care of most patches to this file, but FWIW,
> > 
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> Thanks.
> 
> > I would personally prefer if you capitalized the subject to match the
> > "x86/PCI:" convention that's used fairly consistently in
> > arch/x86/pci/.
> > 
> > Also, I didn't apply this to be sure, but it looks like this might
> > make a line or two wider than 80 columns, which I would rewrap if I
> > were applying this.
> 
> Updated below is the patch with the nits corrected:

I am OK with this going either way, but it does depend on an earlier
patch.

							Thanx, Paul

> ---8<-----------------------
> 
> >From 73fab09d7e33ca2110c24215f8ed428c12625dbe Mon Sep 17 00:00:00 2001
> From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
> Date: Sat, 1 Jun 2019 15:05:49 -0400
> Subject: [PATCH] x86/PCI: Pass lockdep condition to pcm_mmcfg_list iterator
>  (v1)
> 
> The pcm_mmcfg_list is traversed with list_for_each_entry_rcu without a
> reader-lock held, because the pci_mmcfg_lock is already held. Make this
> known to the list macro so that it fixes new lockdep warnings that
> trigger due to lockdep checks added to list_for_each_entry_rcu().
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  arch/x86/pci/mmconfig-shared.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
> index 7389db538c30..9e3250ec5a37 100644
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
> @@ -54,7 +55,8 @@ static void list_add_sorted(struct pci_mmcfg_region *new)
>  	struct pci_mmcfg_region *cfg;
>  
>  	/* keep list sorted by segment and starting bus number */
> -	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list) {
> +	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list,
> +				pci_mmcfg_lock_held()) {
>  		if (cfg->segment > new->segment ||
>  		    (cfg->segment == new->segment &&
>  		     cfg->start_bus >= new->start_bus)) {
> @@ -118,7 +120,8 @@ struct pci_mmcfg_region *pci_mmconfig_lookup(int segment, int bus)
>  {
>  	struct pci_mmcfg_region *cfg;
>  
> -	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list)
> +	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list
> +				pci_mmcfg_lock_held())
>  		if (cfg->segment == segment &&
>  		    cfg->start_bus <= bus && bus <= cfg->end_bus)
>  			return cfg;
> -- 
> 2.22.0.510.g264f2c817a-goog
> 

