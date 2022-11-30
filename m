Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E2363D0DE
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 09:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbiK3IjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 03:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiK3IjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 03:39:17 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC04715A1F;
        Wed, 30 Nov 2022 00:39:15 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 371EA204FD;
        Wed, 30 Nov 2022 09:39:14 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 74eIn4A--EFs; Wed, 30 Nov 2022 09:39:13 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id AA2CF204B4;
        Wed, 30 Nov 2022 09:39:13 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 9A95D80004A;
        Wed, 30 Nov 2022 09:39:13 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 30 Nov 2022 09:39:13 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 30 Nov
 2022 09:39:13 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id CEDF63182AAD; Wed, 30 Nov 2022 09:39:12 +0100 (CET)
Date:   Wed, 30 Nov 2022 09:39:12 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Martin KaFai Lau <martin.lau@linux.dev>,
        Eyal Birger <eyal.birger@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <herbert@gondor.apana.org.au>, <andrii@kernel.org>,
        <daniel@iogearbox.net>, <nicolas.dichtel@6wind.com>,
        <razor@blackwall.org>, <mykolal@fb.com>, <ast@kernel.org>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>, <shuah@kernel.org>
Subject: Re: [PATCH ipsec-next 2/3] xfrm: interface: Add unstable helpers for
 setting/getting XFRM metadata from TC-BPF
Message-ID: <20221130083912.GQ424616@gauss3.secunet.de>
References: <20221128160501.769892-1-eyal.birger@gmail.com>
 <20221128160501.769892-3-eyal.birger@gmail.com>
 <c8a2d940-ff85-c952-74d0-25ad2c33c1af@linux.dev>
 <20221129095001.GV704954@gauss3.secunet.de>
 <20221129081510.56b1025e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221129081510.56b1025e@kernel.org>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 08:15:10AM -0800, Jakub Kicinski wrote:
> On Tue, 29 Nov 2022 10:50:01 +0100 Steffen Klassert wrote:
> > > Please tag for bpf-next  
> > 
> > This is a change to xfrm ipsec, so it should go
> > through the ipsec-next tree, unless there is
> > a good reason for handling that different.
> 
> Yeah, this is borderline. Do the patches apply cleanly to Linus's tree?
> If so maybe they can be posted as a PR and both trees can pull them in,
> avoiding any unnecessary back and forth...

Now, after the last PR was merged, the ipsec-next tree is empty,
and we are close to the end of this development cycle. So I don't
expect conflicts if that patchset goes in before the merge window.
If the bpf-next tree wants to take the v2 version, just let me
know. Otherwise I consider taking it into ipsec-next.
