Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC82345970
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhCWIPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:15:21 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48946 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhCWIOt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 04:14:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B88DE20185;
        Tue, 23 Mar 2021 09:14:47 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vocO-BLmQQ6D; Tue, 23 Mar 2021 09:14:47 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5178020184;
        Tue, 23 Mar 2021 09:14:47 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 23 Mar 2021 09:14:47 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 23 Mar
 2021 09:14:46 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 72C083180449; Tue, 23 Mar 2021 09:14:46 +0100 (CET)
Date:   Tue, 23 Mar 2021 09:14:46 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <linux-sctp@vger.kernel.org>, <netdev@vger.kernel.org>,
        "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH ipsec] esp: delete NETIF_F_SCTP_CRC bit from features for
 esp offload
Message-ID: <20210323081446.GN62598@gauss3.secunet.de>
References: <5f247a2ef20cae297db4d0a130515d0b7a1b8110.1616139307.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5f247a2ef20cae297db4d0a130515d0b7a1b8110.1616139307.git.lucien.xin@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 03:35:07PM +0800, Xin Long wrote:
> Now in esp4/6_gso_segment(), before calling inner proto .gso_segment,
> NETIF_F_CSUM_MASK bits are deleted, as HW won't be able to do the
> csum for inner proto due to the packet encrypted already.
> 
> So the UDP/TCP packet has to do the checksum on its own .gso_segment.
> But SCTP is using CRC checksum, and for that NETIF_F_SCTP_CRC should
> be deleted to make SCTP do the csum in own .gso_segment as well.
> 
> In Xiumei's testing with SCTP over IPsec/veth, the packets are kept
> dropping due to the wrong CRC checksum.
> 
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Fixes: 7862b4058b9f ("esp: Add gso handlers for esp4 and esp6")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks Xin!
