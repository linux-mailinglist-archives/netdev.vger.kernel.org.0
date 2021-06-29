Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2E23B729F
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 14:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhF2Mz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 08:55:59 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:44244 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbhF2Mzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 08:55:54 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 9CCAF800056;
        Tue, 29 Jun 2021 14:53:26 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 29 Jun 2021 14:53:26 +0200
Received: from moon.secunet.de (172.18.26.121) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 29 Jun
 2021 14:53:25 +0200
Date:   Tue, 29 Jun 2021 14:53:16 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     David Ahern <dsahern@gmail.com>
CC:     <antony.antony@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        Christian Perle <christian.perle@secunet.com>
Subject: Re: [PATCH net-next] ipv6: Add sysctl for RA default route table
 number
Message-ID: <20210629125316.GA18078@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <cover.1619775297.git.antony.antony@secunet.com>
 <32de887afdc7d6851e7c53d27a21f1389bb0bd0f.1624604535.git.antony.antony@secunet.com>
 <95b096f7-8ece-46be-cedb-5ee4fc011477@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <95b096f7-8ece-46be-cedb-5ee4fc011477@gmail.com>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Fri, Jun 25, 2021 at 22:47:41 -0600, David Ahern wrote:
> On 6/25/21 1:04 AM, Antony Antony wrote:
> > From: Christian Perle <christian.perle@secunet.com>
> > 
> > Default routes learned from router advertisements(RA) are always placed
> > in main routing table. For policy based routing setups one may
> > want a different table for default routes. This commit adds a sysctl
> > to make table number for RA default routes configurable.
> > 
> > examples:
> > sysctl net.ipv6.route.defrtr_table
> > sysctl -w net.ipv6.route.defrtr_table=42
> > ip -6 route show table 42
> 
> How are the routing tables managed? If the netdevs are connected to a
> VRF this just works.

The main routing table has no default route. Our scripts add routing rules 
based on interfaces. These rules use the specific routing table where the RA 
(when using SLAAC) installs the default route. The rest just works.

I noticed an improvement the patch I sent.
I will sent a rebased v2 after the net-next tree is open.
I guess the net-next is closed now?

-               .proc_handler   =       proc_dointvec,
+               .proc_handler   =       proc_douintvec,

-antony
