Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB5B2EA652
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 09:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbhAEIKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 03:10:38 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:39354 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbhAEIKh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 03:10:37 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E241420270;
        Tue,  5 Jan 2021 09:09:49 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cubGezpZR9Cm; Tue,  5 Jan 2021 09:09:42 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7474D2006F;
        Tue,  5 Jan 2021 09:09:26 +0100 (CET)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 5 Jan 2021 09:09:26 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Tue, 5 Jan 2021
 09:09:25 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id CD8CB3180C94; Tue,  5 Jan 2021 09:09:24 +0100 (CET)
Date:   Tue, 5 Jan 2021 09:09:24 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        <syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [Patch net] af_key: relax availability checks for skb size
 calculation
Message-ID: <20210105080924.GH3576117@gauss3.secunet.de>
References: <20201227005021.907852-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201227005021.907852-1-xiyou.wangcong@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 26, 2020 at 04:50:20PM -0800, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> xfrm_probe_algs() probes kernel crypto modules and changes the
> availability of struct xfrm_algo_desc. But there is a small window
> where ealg->available and aalg->available get changed between
> count_ah_combs()/count_esp_combs() and dump_ah_combs()/dump_esp_combs(),
> in this case we may allocate a smaller skb but later put a larger
> amount of data and trigger the panic in skb_put().
> 
> Fix this by relaxing the checks when counting the size, that is,
> skipping the test of ->available. We may waste some memory for a few
> of sizeof(struct sadb_comb), but it is still much better than a panic.
> 
> Reported-by: syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

Patch applied, thanks!
