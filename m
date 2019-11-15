Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1C2FE839
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 23:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfKOWoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 17:44:07 -0500
Received: from correo.us.es ([193.147.175.20]:50020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbfKOWoH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 17:44:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A1136FB46B
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 23:44:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91CFDA7BEA
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 23:44:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8E4CFDA4CA; Fri, 15 Nov 2019 23:44:03 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6489DDA4CA;
        Fri, 15 Nov 2019 23:44:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Nov 2019 23:44:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 209CF426CCBA;
        Fri, 15 Nov 2019 23:44:01 +0100 (CET)
Date:   Fri, 15 Nov 2019 23:44:02 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     y2038@lists.linaro.org, Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Ander Juaristi <a@juaristi.eus>,
        wenxu <wenxu@ucloud.cn>, Thomas Gleixner <tglx@linutronix.de>,
        Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH 09/16] netfilter: nft_meta: use 64-bit time arithmetic
Message-ID: <20191115224402.twm2lbbd66236t42@salvia>
References: <20191108213257.3097633-1-arnd@arndb.de>
 <20191108213257.3097633-10-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108213257.3097633-10-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 10:32:47PM +0100, Arnd Bergmann wrote:
> On 32-bit architectures, get_seconds() returns an unsigned 32-bit
> time value, which also matches the type used in the nft_meta
> code. This will not overflow in year 2038 as a time_t would, but
> it still suffers from the overflow problem later on in year 2106.
> 
> Change this instance to use the time64_t type consistently
> and avoid the deprecated get_seconds().
> 
> The nft_meta_weekday() calculation potentially gets a little slower
> on 32-bit architectures, but now it has the same behavior as on
> 64-bit architectures and does not overflow.

Applied, thanks Arnd.
