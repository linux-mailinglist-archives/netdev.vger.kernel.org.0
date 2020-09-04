Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C6525D1AC
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 08:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgIDGtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 02:49:50 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:53992 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgIDGtt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 02:49:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 25299201CC;
        Fri,  4 Sep 2020 08:49:46 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id h99ty75Wve79; Fri,  4 Sep 2020 08:49:45 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B8295200AC;
        Fri,  4 Sep 2020 08:49:45 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 4 Sep 2020 08:49:45 +0200
Received: from moon.secunet.de (172.18.26.122) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 4 Sep 2020
 08:49:45 +0200
Date:   Fri, 4 Sep 2020 08:49:38 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
CC:     Antony Antony <antony@phenome.org>,
        Antony Antony <antony.antony@secunet.com>
Subject: [PATCH v3 1/4] xfrm: clone XFRMA_SET_MARK in xfrm_do_migrate
Message-ID: <20200904064938.GA21496@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20200820181158.GA19658@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200820181158.GA19658@moon.secunet.de>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XFRMA_SET_MARK and XFRMA_SET_MARK_MASK was not cloned from the old
to the new. Migrate these two attributes during XFRMA_MSG_MIGRATE

Fixes: 9b42c1f179a6 ("xfrm: Extend the output_mark to support input direction and masking.")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 net/xfrm/xfrm_state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 69520ad3d83b..3a000f289dcd 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1510,6 +1510,7 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	}
 
 	memcpy(&x->mark, &orig->mark, sizeof(x->mark));
+	memcpy(&x->props.smark, &orig->props.smark, sizeof(x->props.smark));
 
 	if (xfrm_init_state(x) < 0)
 		goto error;
-- 
2.20.1

