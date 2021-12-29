Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9472348119A
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 11:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239705AbhL2KTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 05:19:50 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:51264 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235468AbhL2KTt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 05:19:49 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B32612061E;
        Wed, 29 Dec 2021 11:19:48 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aAGoN1k4GuDg; Wed, 29 Dec 2021 11:19:48 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3E5712060F;
        Wed, 29 Dec 2021 11:19:48 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 2E48780004A;
        Wed, 29 Dec 2021 11:19:48 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 29 Dec 2021 11:19:48 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 29 Dec
 2021 11:19:47 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5BEF73182F8D; Wed, 29 Dec 2021 11:19:45 +0100 (CET)
Date:   Wed, 29 Dec 2021 11:19:45 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     Thomas Egerer <thomas.egerer@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next v3] xfrm: rate limit SA mapping change message
 to user space
Message-ID: <20211229101945.GQ3272477@gauss3.secunet.de>
References: <YafsUMtO+zj/2xcC@moon.secunet.de>
 <af6150a0d0ae51bdbbf34c81ca0d0d74b17fa16f.1640178517.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <af6150a0d0ae51bdbbf34c81ca0d0d74b17fa16f.1640178517.git.antony.antony@secunet.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 02:11:18PM +0100, Antony Antony wrote:
> Kernel generates mapping change message, XFRM_MSG_MAPPING,
> when a source port chage is detected on a input state with UDP
> encapsulation set.  Kernel generates a message for each IPsec packet
> with new source port.  For a high speed flow per packet mapping change
> message can be excessive, and can overload the user space listener.
> 
> Introduce rate limiting for XFRM_MSG_MAPPING message to the user space.
> 
> The rate limiting is configurable via netlink, when adding a new SA or
> updating it. Use the new attribute XFRMA_MTIMER_THRESH in seconds.
> 
> v1->v2 change:
> 	update xfrm_sa_len()
> 
> v2->v3 changes:
> 	use u32 insted unsigned long to reduce size of struct xfrm_state
> 	fix xfrm_ompat size Reported-by: kernel test robot <lkp@intel.com>
> 	accept XFRM_MSG_MAPPING only when XFRMA_ENCAP is present
> 
> Co-developed-by: Thomas Egerer <thomas.egerer@secunet.com>
> Signed-off-by: Thomas Egerer <thomas.egerer@secunet.com>
> Signed-off-by: Antony Antony <antony.antony@secunet.com>

Applied, thanks a lot!
