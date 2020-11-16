Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715DB2B4021
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgKPJqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:46:01 -0500
Received: from correo.us.es ([193.147.175.20]:45426 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbgKPJqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 04:46:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3263D508CF6
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 10:45:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C637ECC1C
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 10:45:14 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0D010321C57; Mon, 16 Nov 2020 10:33:15 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 244DB3984A9;
        Mon, 16 Nov 2020 10:26:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Nov 2020 10:26:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EDD0A42EF4E0;
        Mon, 16 Nov 2020 10:26:48 +0100 (CET)
Date:   Mon, 16 Nov 2020 10:26:48 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Jose M . Guisado Gomez" <guigom@riseup.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] netfilter: nf_reject: bridge: fix build errors
 due to code movement
Message-ID: <20201116092648.GA405@salvia>
References: <20201116034203.7264-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201116034203.7264-1-rdunlap@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for catching up this.

On Sun, Nov 15, 2020 at 07:42:03PM -0800, Randy Dunlap wrote:
> Fix build errors in net/bridge/netfilter/nft_reject_bridge.ko
> by selecting NF_REJECT_IPV4, which provides the missing symbols.
> 
> ERROR: modpost: "nf_reject_skb_v4_tcp_reset" [net/bridge/netfilter/nft_reject_bridge.ko] undefined!
> ERROR: modpost: "nf_reject_skb_v4_unreach" [net/bridge/netfilter/nft_reject_bridge.ko] undefined!
> 
> Fixes: fa538f7cf05a ("netfilter: nf_reject: add reject skbuff creation helpers")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: kernel test robot <lkp@intel.com>
> Cc: Jose M. Guisado Gomez <guigom@riseup.net>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: netfilter-devel@vger.kernel.org
> Cc: coreteam@netfilter.org
> Cc: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/bridge/netfilter/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20201113.orig/net/bridge/netfilter/Kconfig
> +++ linux-next-20201113/net/bridge/netfilter/Kconfig
> @@ -18,6 +18,7 @@ config NFT_BRIDGE_META
>  config NFT_BRIDGE_REJECT
>  	tristate "Netfilter nf_tables bridge reject support"
>  	depends on NFT_REJECT
> +	depends on NF_REJECT_IPV4

I can update the patch here before applying to add:

        depends on NF_REJECT_IPV6

as well. It seems both dependencies (IPv4 and IPv6) are missing.

Thanks.

>  	help
>  	  Add support to reject packets.
>  
