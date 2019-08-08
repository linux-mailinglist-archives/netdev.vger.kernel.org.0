Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50005860CC
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 13:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389745AbfHHLYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 07:24:08 -0400
Received: from correo.us.es ([193.147.175.20]:43966 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727824AbfHHLYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 07:24:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 66325B632D
        for <netdev@vger.kernel.org>; Thu,  8 Aug 2019 13:24:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5716CAD9C
        for <netdev@vger.kernel.org>; Thu,  8 Aug 2019 13:24:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4B4EDA58B; Thu,  8 Aug 2019 13:24:05 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4591D1150B9;
        Thu,  8 Aug 2019 13:24:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 08 Aug 2019 13:24:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AAE734265A2F;
        Thu,  8 Aug 2019 13:24:02 +0200 (CEST)
Date:   Thu, 8 Aug 2019 13:23:55 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Net Dev <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        kadlec@blackhole.kfki.hu
Subject: Re: [PATCH net-next v1 1/8] netfilter: inlined four headers files
 into another one.
Message-ID: <20190808112355.w3ax3twuf6b7pwc7@salvia>
References: <20190722201615.GE23346@azazel.net>
 <20190807141705.4864-1-jeremy@azazel.net>
 <20190807141705.4864-2-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807141705.4864-2-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeremy,

Thanks for working on this.

Cc'ing Jozsef.

On Wed, Aug 07, 2019 at 03:16:58PM +0100, Jeremy Sowden wrote:
[...]
> +/* Called from uadd only, protected by the set spinlock.
> + * The kadt functions don't use the comment extensions in any way.
> + */
> +static inline void
> +ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
> +		    const struct ip_set_ext *ext)

Not related to this patch, but I think the number of inline functions
could be reduced a bit by exporting symbols? Specifically for
functions that are called from the netlink control plane, ie. _uadd()
functions. I think forcing the compiler to inline this is not useful.
This could be done in a follow up patchset.

Thanks.
