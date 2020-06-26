Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D2520ABC7
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 07:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgFZFW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 01:22:27 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:44616 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgFZFW0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 01:22:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 52E8720512;
        Fri, 26 Jun 2020 07:22:25 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IMGh5DGf3HOV; Fri, 26 Jun 2020 07:22:24 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 305F92006F;
        Fri, 26 Jun 2020 07:22:24 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 26 Jun 2020 07:22:23 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 26 Jun
 2020 07:22:23 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 6BEE13180155;
 Fri, 26 Jun 2020 07:22:23 +0200 (CEST)
Date:   Fri, 26 Jun 2020 07:22:23 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        "Sabrina Dubroca" <sd@queasysnail.net>,
        Tobias Brunner <tobias@strongswan.org>
Subject: Re: [PATCHv2 ipsec] xfrm: policy: match with both mark and mask on
 user interfaces
Message-ID: <20200626052223.GB19286@gauss3.secunet.de>
References: <e1e4d8b9fe775a7811afdbe0509d54286cf017e9.1592815229.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e1e4d8b9fe775a7811afdbe0509d54286cf017e9.1592815229.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 04:40:29PM +0800, Xin Long wrote:
> In commit ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list"),
> it would take 'priority' to make a policy unique, and allow duplicated
> policies with different 'priority' to be added, which is not expected
> by userland, as Tobias reported in strongswan.
> 
> To fix this duplicated policies issue, and also fix the issue in
> commit ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list"),
> when doing add/del/get/update on user interfaces, this patch is to change
> to look up a policy with both mark and mask by doing:
> 
>   mark.v == pol->mark.v && mark.m == pol->mark.m
> 
> and leave the check:
> 
>   (mark & pol->mark.m) == pol->mark.v
> 
> for tx/rx path only.
> 
> As the userland expects an exact mark and mask match to manage policies.
> 
> v1->v2:
>   - make xfrm_policy_mark_match inline and fix the changelog as
>     Tobias suggested.
> 
> Fixes: 295fae568885 ("xfrm: Allow user space manipulation of SPD mark")
> Fixes: ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list")
> Reported-by: Tobias Brunner <tobias@strongswan.org>
> Tested-by: Tobias Brunner <tobias@strongswan.org>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks a lot Xin!
