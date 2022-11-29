Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A0463BD45
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiK2JuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiK2JuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:50:07 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBCA2A97B;
        Tue, 29 Nov 2022 01:50:05 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 18E7220199;
        Tue, 29 Nov 2022 10:50:03 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HVnSnlaNbPSm; Tue, 29 Nov 2022 10:50:02 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 916CF20489;
        Tue, 29 Nov 2022 10:50:02 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 8A3AA80004A;
        Tue, 29 Nov 2022 10:50:02 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 29 Nov 2022 10:50:02 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 29 Nov
 2022 10:50:02 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B63D03182F22; Tue, 29 Nov 2022 10:50:01 +0100 (CET)
Date:   Tue, 29 Nov 2022 10:50:01 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>
CC:     Eyal Birger <eyal.birger@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <herbert@gondor.apana.org.au>,
        <andrii@kernel.org>, <daniel@iogearbox.net>,
        <nicolas.dichtel@6wind.com>, <razor@blackwall.org>,
        <mykolal@fb.com>, <ast@kernel.org>, <song@kernel.org>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <sdf@google.com>, <haoluo@google.com>, <jolsa@kernel.org>,
        <shuah@kernel.org>
Subject: Re: [PATCH ipsec-next 2/3] xfrm: interface: Add unstable helpers for
 setting/getting XFRM metadata from TC-BPF
Message-ID: <20221129095001.GV704954@gauss3.secunet.de>
References: <20221128160501.769892-1-eyal.birger@gmail.com>
 <20221128160501.769892-3-eyal.birger@gmail.com>
 <c8a2d940-ff85-c952-74d0-25ad2c33c1af@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c8a2d940-ff85-c952-74d0-25ad2c33c1af@linux.dev>
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

On Mon, Nov 28, 2022 at 05:58:23PM -0800, Martin KaFai Lau wrote:
> On 11/28/22 8:05 AM, Eyal Birger wrote:
> > This change adds xfrm metadata helpers using the unstable kfunc call
> > interface for the TC-BPF hooks. This allows steering traffic towards
> > different IPsec connections based on logic implemented in bpf programs.
> > 
> > This object is built based on the availabilty of BTF debug info.
> > 
> > The metadata percpu dsts used on TX take ownership of the original skb
> > dsts so that they may be used as part of the xfrm transmittion logic -
> > e.g.  for MTU calculations.
> 
> A few quick comments and questions:
> 
> > 
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> > ---
> >   include/net/dst_metadata.h     |  1 +
> >   include/net/xfrm.h             | 20 ++++++++
> >   net/core/dst.c                 |  4 ++
> >   net/xfrm/Makefile              |  6 +++
> >   net/xfrm/xfrm_interface_bpf.c  | 92 ++++++++++++++++++++++++++++++++++
> 
> Please tag for bpf-next

This is a change to xfrm ipsec, so it should go
through the ipsec-next tree, unless there is
a good reason for handling that different.
