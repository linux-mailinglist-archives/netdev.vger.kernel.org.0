Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4939148E2E
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 20:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391627AbgAXTEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 14:04:37 -0500
Received: from correo.us.es ([193.147.175.20]:44612 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387918AbgAXTEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 14:04:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2ED7ABAEFC
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 20:04:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21F7FDA720
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 20:04:36 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 14E73DA712; Fri, 24 Jan 2020 20:04:36 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 159ABDA707;
        Fri, 24 Jan 2020 20:04:34 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 24 Jan 2020 20:04:34 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E8D5342EE38E;
        Fri, 24 Jan 2020 20:04:33 +0100 (CET)
Date:   Fri, 24 Jan 2020 20:04:32 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Praveen Chaudhary <praveen5582@gmail.com>
Cc:     fw@strlen.de, davem@davemloft.net, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>
Subject: Re: [PATCH v4] [net]: Fix skb->csum update in
 inet_proto_csum_replace16().
Message-ID: <20200124190432.vxcnnds3ypqa4hzh@salvia>
References: <20200123142929.GV795@breakpoint.cc>
 <1579811608-688-1-git-send-email-pchaudhary@linkedin.com>
 <1579811608-688-2-git-send-email-pchaudhary@linkedin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579811608-688-2-git-send-email-pchaudhary@linkedin.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 12:33:28PM -0800, Praveen Chaudhary wrote:
> skb->csum is updated incorrectly, when manipulation for NF_NAT_MANIP_SRC\DST
> is done on IPV6 packet.
> 
> Fix:
> There is no need to update skb->csum in inet_proto_csum_replace16(), because
> update in two fields a.) IPv6 src/dst address and b.) L4 header checksum
> cancels each other for skb->csum calculation.
> Whereas inet_proto_csum_replace4 function needs to update skb->csum,
> because update in 3 fields a.) IPv4 src/dst address, b.) IPv4 Header checksum
> and c.) L4 header checksum results in same diff as L4 Header checksum for
> skb->csum calculation.

Applied, thanks.
