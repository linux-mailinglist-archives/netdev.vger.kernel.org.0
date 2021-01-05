Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8832EA64F
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 09:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbhAEIJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 03:09:21 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:39282 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbhAEIJV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 03:09:21 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 18E012006F;
        Tue,  5 Jan 2021 09:08:40 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Gnebp-OWwcxf; Tue,  5 Jan 2021 09:08:29 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4257A201D3;
        Tue,  5 Jan 2021 09:08:11 +0100 (CET)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Tue, 5 Jan 2021 09:08:05 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Tue, 5 Jan 2021
 09:08:05 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id A79DB3180C94;
 Tue,  5 Jan 2021 09:08:04 +0100 (CET)
Date:   Tue, 5 Jan 2021 09:08:04 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <lorenzo@google.com>, <benedictwong@google.com>,
        <netdev@vger.kernel.org>, <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH ipsec] xfrm: fix disable_xfrm sysctl when used on xfrm
 interfaces
Message-ID: <20210105080804.GG3576117@gauss3.secunet.de>
References: <20201223150046.3910206-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201223150046.3910206-1-eyal.birger@gmail.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 05:00:46PM +0200, Eyal Birger wrote:
> The disable_xfrm flag signals that xfrm should not be performed during
> routing towards a device before reaching device xmit.
> 
> For xfrm interfaces this is usually desired as they perform the outbound
> policy lookup as part of their xmit using their if_id.
> 
> Before this change enabling this flag on xfrm interfaces prevented them
> from xmitting as xfrm_lookup_with_ifid() would not perform a policy lookup
> in case the original dst had the DST_NOXFRM flag.
> 
> This optimization is incorrect when the lookup is done by the xfrm
> interface xmit logic.
> 
> Fix by performing policy lookup when invoked by xfrmi as if_id != 0.
> 
> Similarly it's unlikely for the 'no policy exists on net' check to yield
> any performance benefits when invoked from xfrmi.
> 
> Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

Applied, thanks a lot Eyal!
