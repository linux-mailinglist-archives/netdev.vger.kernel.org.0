Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AE7531497
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237195AbiEWOdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 10:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237181AbiEWOdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 10:33:04 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F50E33361;
        Mon, 23 May 2022 07:33:03 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 25AC3201CF;
        Mon, 23 May 2022 16:33:01 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Oeroqqsihyg4; Mon, 23 May 2022 16:33:00 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A013D200AC;
        Mon, 23 May 2022 16:33:00 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 97E3880004A;
        Mon, 23 May 2022 16:33:00 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 23 May 2022 16:32:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 23 May
 2022 16:33:00 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E9B5A3182B34; Mon, 23 May 2022 16:32:59 +0200 (CEST)
Date:   Mon, 23 May 2022 16:32:59 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: REGRESSION (?) (Re: [PATCH] net: af_key: add check for
 pfkey_broadcast in function pfkey_process)
Message-ID: <20220523143259.GX680067@gauss3.secunet.de>
References: <20220517094231.414168-1-jiasheng@iscas.ac.cn>
 <20220523022438.ofhehjievu2alj3h@lion.mk-sys.cz>
 <20220523083349.zzgdmoq2bzstxla6@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220523083349.zzgdmoq2bzstxla6@lion.mk-sys.cz>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 10:33:49AM +0200, Michal Kubecek wrote:
> On Mon, May 23, 2022 at 04:24:38AM +0200, Michal Kubecek wrote:
> > After upgrading from 5.18-rc7 to 5.18 final, my racoon daemon refuses to
> > start because it cannot find some algorithms (it says "aes"). I have not
> > finished the debugging completely but this patch, mainline commit
> > 4dc2a5a8f675 ("net: af_key: add check for pfkey_broadcast in function
> > pfkey_process"), seems to be the most promising candidate.
> 
> Tested now, reverting commit 4dc2a5a8f675 ("net: af_key: add check for
> pfkey_broadcast in function pfkey_process") seems to fix the issue,
> after rebuilding the af_key module with this commit reverted and
> reloading it, racoon daemon starts and works and /proc/crypto shows
> algrorithms it did not without the revert.
> 
> We might get away with changing the test to
> 
> 	if (err && err != -ESRCH)
> 		return err;
> 
> but I'm not sure if bailing up on failed notification broadcast is
> really what we want. Also, most other calling sites of pfkey_broadcast()
> do not check the return value either so if we want to add the check, it
> should probably be done more consistently. So for now, a revert is IMHO
> more appropriate.

Yes, let's just revert it. Maybe we should only accept serious security
bugfixes for the pfkey interface and leave everyting else as it is. Noone
really cares for the pfkey code anymore for more than 10 years. People
should switch to the netlink interface.
