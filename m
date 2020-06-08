Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859081F2199
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 23:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgFHVrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 17:47:43 -0400
Received: from correo.us.es ([193.147.175.20]:44786 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbgFHVrn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 17:47:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E1C54F236A
        for <netdev@vger.kernel.org>; Mon,  8 Jun 2020 23:47:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D19E1DA791
        for <netdev@vger.kernel.org>; Mon,  8 Jun 2020 23:47:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C370DDA798; Mon,  8 Jun 2020 23:47:41 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7DC32DA72F;
        Mon,  8 Jun 2020 23:47:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jun 2020 23:47:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4D2D3426CCB9;
        Mon,  8 Jun 2020 23:47:39 +0200 (CEST)
Date:   Mon, 8 Jun 2020 23:47:39 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, paulb@mellanox.com, ozsh@mellanox.com,
        vladbu@mellanox.com, jiri@resnulli.us, kuba@kernel.org,
        saeedm@mellanox.com, michael.chan@broadcom.com
Subject: Re: [PATCH 8/8 net] net: remove indirect block netdev event
 registration
Message-ID: <20200608214739.GA12131@salvia>
References: <20200513164140.7956-1-pablo@netfilter.org>
 <20200513164140.7956-9-pablo@netfilter.org>
 <59884f4f-df03-98ac-0524-3e58c904f201@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <59884f4f-df03-98ac-0524-3e58c904f201@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 08, 2020 at 02:07:57PM -0700, Jacob Keller wrote:
> 
> 
> On 5/13/2020 9:41 AM, Pablo Neira Ayuso wrote:
> > Drivers do not register to netdev events to set up indirect blocks
> > anymore. Remove __flow_indr_block_cb_register() and
> > __flow_indr_block_cb_unregister().
> > 
> > The frontends set up the callbacks through flow_indr_dev_setup_block()
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This commit failed to remove the prototypes from the header file:
> include/net/flow_offload.h

Thanks for reporting.

I'm attaching a sketch, I will submit this formally later.

--+HP7ph2BbKc20aGI
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 69e13c8b6b3a..f2c8311a0433 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -542,28 +542,4 @@ int flow_indr_dev_setup_offload(struct net_device *dev,
 				struct flow_block_offload *bo,
 				void (*cleanup)(struct flow_block_cb *block_cb));
 
-typedef void flow_indr_block_cmd_t(struct net_device *dev,
-				   flow_indr_block_bind_cb_t *cb, void *cb_priv,
-				   enum flow_block_command command);
-
-int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
-				  flow_indr_block_bind_cb_t *cb,
-				  void *cb_ident);
-
-void __flow_indr_block_cb_unregister(struct net_device *dev,
-				     flow_indr_block_bind_cb_t *cb,
-				     void *cb_ident);
-
-int flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
-				flow_indr_block_bind_cb_t *cb, void *cb_ident);
-
-void flow_indr_block_cb_unregister(struct net_device *dev,
-				   flow_indr_block_bind_cb_t *cb,
-				   void *cb_ident);
-
-void flow_indr_block_call(struct net_device *dev,
-			  struct flow_block_offload *bo,
-			  enum flow_block_command command,
-			  enum tc_setup_type type);
-
 #endif /* _NET_FLOW_OFFLOAD_H */

--+HP7ph2BbKc20aGI--
