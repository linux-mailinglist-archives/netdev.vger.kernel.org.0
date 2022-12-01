Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E5F63EA29
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 08:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiLAHMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 02:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiLAHMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 02:12:15 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B11756558;
        Wed, 30 Nov 2022 23:12:14 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 136F32052D;
        Thu,  1 Dec 2022 08:12:11 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cDh5eURpbMep; Thu,  1 Dec 2022 08:12:10 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 85AD9204E5;
        Thu,  1 Dec 2022 08:12:10 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 7D52E80004A;
        Thu,  1 Dec 2022 08:12:10 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Dec 2022 08:12:10 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 1 Dec
 2022 08:12:09 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 7134D31829C4; Thu,  1 Dec 2022 08:12:09 +0100 (CET)
Date:   Thu, 1 Dec 2022 08:12:09 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>
CC:     Eyal Birger <eyal.birger@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <herbert@gondor.apana.org.au>, <andrii@kernel.org>,
        <daniel@iogearbox.net>, <nicolas.dichtel@6wind.com>,
        <razor@blackwall.org>, <mykolal@fb.com>, <ast@kernel.org>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>, <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH ipsec-next 2/3] xfrm: interface: Add unstable helpers for
 setting/getting XFRM metadata from TC-BPF
Message-ID: <20221201071209.GR424616@gauss3.secunet.de>
References: <20221128160501.769892-1-eyal.birger@gmail.com>
 <20221128160501.769892-3-eyal.birger@gmail.com>
 <c8a2d940-ff85-c952-74d0-25ad2c33c1af@linux.dev>
 <20221129095001.GV704954@gauss3.secunet.de>
 <20221129081510.56b1025e@kernel.org>
 <953fb82c-0871-748e-e0f0-6ecca6ec80ee@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <953fb82c-0871-748e-e0f0-6ecca6ec80ee@linux.dev>
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

On Wed, Nov 30, 2022 at 11:10:13AM -0800, Martin KaFai Lau wrote:
> On 11/29/22 8:15 AM, Jakub Kicinski wrote:
> > On Tue, 29 Nov 2022 10:50:01 +0100 Steffen Klassert wrote:
> > > > Please tag for bpf-next
> > > 
> > > This is a change to xfrm ipsec, so it should go
> > > through the ipsec-next tree, unless there is
> > > a good reason for handling that different.
> 
> The set is mostly depending on the bpf features.  Patch 2 is mostly
> depending on bpf and patch 3 is also a bpf selftest.  I assume the set
> should have been developed based on the bpf-next tree instead.  It is also
> good to have the test run in bpf CI sooner than later to bar on-going bpf
> changes that may break it. It is the reason I think bpf-next makes more
> sense.

As said, if there is a good reason, I'm ok with routing it
through bpf-next. Looks like there is a good readon, so
go with bpf-next.
