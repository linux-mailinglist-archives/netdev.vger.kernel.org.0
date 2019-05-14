Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8171E573
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 01:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfENXIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 19:08:00 -0400
Received: from mail.us.es ([193.147.175.20]:52362 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfENXH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 19:07:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0F68FF27A2
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 01:07:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00143DA707
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 01:07:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E4870DA701; Wed, 15 May 2019 01:07:56 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76B67DA708;
        Wed, 15 May 2019 01:07:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 15 May 2019 01:07:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1C3104265A31;
        Wed, 15 May 2019 01:07:54 +0200 (CEST)
Date:   Wed, 15 May 2019 01:07:53 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, thomas.lendacky@amd.com,
        f.fainelli@gmail.com, ariel.elior@cavium.com,
        michael.chan@broadcom.com, santosh@chelsio.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        julia.lawall@lip6.fr, john.fastabend@gmail.com
Subject: Re: [PATCH net-next,RFC 1/2] net: flow_offload: add flow_block_cb API
Message-ID: <20190514230753.mb7iu4pbswrb4be7@salvia>
References: <20190509163954.13703-1-pablo@netfilter.org>
 <20190509163954.13703-2-pablo@netfilter.org>
 <20190514145719.GE2238@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514145719.GE2238@nanopsycho>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 04:57:19PM +0200, Jiri Pirko wrote:
> Thu, May 09, 2019 at 06:39:50PM CEST, pablo@netfilter.org wrote:
> >This patch renames:
> >
> >* struct tcf_block_cb to flow_block_cb.
> >* struct tc_block_offload to flow_block_offload.
> >
> >And it exposes the flow_block_cb API through net/flow_offload.h. This
> >renames the existing codebase to adapt it to this name.
> >
> >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]
> 
> 	
> >+
> >+void *flow_block_cb_priv(struct flow_block_cb *block_cb)
> >+{
> >+	return block_cb->cb_priv;
> >+}
> >+EXPORT_SYMBOL(flow_block_cb_priv);
> >+
> >+LIST_HEAD(flow_block_cb_list);
> >+EXPORT_SYMBOL(flow_block_cb_list);
> 
> I don't understand, why is this exported?

Will stop exposing this in the next patchset version.

> >+
> >+struct flow_block_cb *flow_block_cb_lookup(u32 block_index, tc_setup_cb_t *cb,
> >+					   void *cb_ident)
> 
> 2 namespaces may have the same block_index, yet it is completely
> unrelated block. The cb_ident

Yes, a struct netns parameter here for flow_block_cb_lookup() is
needed. I will also add a possible_net_t field to store this in the
flow_block_cb object so we can just stay with one single list for all
net namespaces by now.

Thanks.

> >+{	struct flow_block_cb *block_cb;
> >+
> >+	list_for_each_entry(block_cb, &flow_block_cb_list, list)
> >+		if (block_cb->block_index == block_index &&
> >+		    block_cb->cb == cb &&
> >+		    block_cb->cb_ident == cb_ident)
> >+			return block_cb;
> >+	return NULL;
> >+}
> >+EXPORT_SYMBOL(flow_block_cb_lookup);
> 
> [...]
