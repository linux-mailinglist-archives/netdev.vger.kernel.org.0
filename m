Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E4D47A614
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 09:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbhLTIgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 03:36:05 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:51296 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234688AbhLTIgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 03:36:05 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 29FF3205A9;
        Mon, 20 Dec 2021 09:36:04 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id C3Oc8kThAX3Y; Mon, 20 Dec 2021 09:36:03 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B21BA20504;
        Mon, 20 Dec 2021 09:36:03 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id A328380004A;
        Mon, 20 Dec 2021 09:36:03 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 20 Dec 2021 09:36:03 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 20 Dec
 2021 09:36:03 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5264A3182F8D; Mon, 20 Dec 2021 09:36:01 +0100 (CET)
Date:   Mon, 20 Dec 2021 09:36:01 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     Eyal Birger <eyal.birger@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 ipsec-next 2/2] xfrm: state and policy should fail if
 XFRMA_IF_ID 0
Message-ID: <20211220083601.GO427717@gauss3.secunet.de>
References: <0bfebd4e5f317cbf301750d5dd5cc706d4385d7f.1639064087.git.antony.antony@secunet.com>
 <750d7eeedf4767485fa616a245e1f1cf0881cbfe.1639304726.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <750d7eeedf4767485fa616a245e1f1cf0881cbfe.1639304726.git.antony.antony@secunet.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 12, 2021 at 11:35:00AM +0100, Antony Antony wrote:
> xfrm ineterface does not allow xfrm if_id = 0
> fail to create or update xfrm state and policy.
> 
> With this commit:
>  ip xfrm policy add src 192.0.2.1 dst 192.0.2.2 dir out if_id 0
>  RTNETLINK answers: Invalid argument
> 
>  ip xfrm state add src 192.0.2.1 dst 192.0.2.2 proto esp spi 1 \
>             reqid 1 mode tunnel aead 'rfc4106(gcm(aes))' \
>             0x1111111111111111111111111111111111111111 96 if_id 0
>  RTNETLINK answers: Invalid argument
> 
> v1->v2 change:
>  - add Fixes: tag
> 
> Fixes: 9f8550e4bd9d ("xfrm: fix disable_xfrm sysctl when used on xfrm interfaces")
> Signed-off-by: Antony Antony <antony.antony@secunet.com>

Also applied to the ipsec tree, thanks a lot!
