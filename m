Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A06D49E08
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 12:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbfFRKE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 06:04:29 -0400
Received: from mail.us.es ([193.147.175.20]:33940 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728867AbfFRKE2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 06:04:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2390612BFF7
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 12:04:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 142B4DA701
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 12:04:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 08B38DA720; Tue, 18 Jun 2019 12:04:26 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0722CDA709;
        Tue, 18 Jun 2019 12:04:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 12:04:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C588E4265A32;
        Tue, 18 Jun 2019 12:04:23 +0200 (CEST)
Date:   Tue, 18 Jun 2019 12:04:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     wenxu@ucloud.cn, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_paylaod: add base type
 NFT_PAYLOAD_LL_HEADER_NO_TAG
Message-ID: <20190618100423.tirukx3ro2fl4khs@salvia>
References: <1560151280-28908-1-git-send-email-wenxu@ucloud.cn>
 <20190610094433.3wjmpfiph7iwguan@breakpoint.cc>
 <20190617223004.tnqz2bl7qp63fcfy@salvia>
 <20190617224232.55hldt4bw2qcmnll@breakpoint.cc>
 <20190618093508.3c5jjmmmuz3m26uj@salvia>
 <20190618094613.ztbwcclgsq54vkop@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618094613.ztbwcclgsq54vkop@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 11:46:13AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > Could you describe this problem a bit more? Small example rule plus
> > scenario.
> 
> It was what wenxu reported originally:
> 
> nft add rule bridge filter forward ip protocol counter ..
> 
> The rule only matches if the ip packet is contained in an ethernet frame
> without vlan tag -- and thats neither expected nor desirable.
> 
> This rule works when using 'meta protocol ip' as dependency instead
> of ether type ip (what we do now), because VLAN stripping will fix/alter
> skb->protocol to the inner type when the VLAN tag gets removes.
> 
> It will still fail in case there are several VLAN tags, so we might
> need another meta expression that can figure out the l3 protocol type.

How would that new meta expression would look like?
