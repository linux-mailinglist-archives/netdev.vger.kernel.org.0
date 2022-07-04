Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB63565CB9
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 19:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbiGDRSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 13:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbiGDRR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 13:17:58 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461CB120BD
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 10:17:56 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9A50B5C00B2;
        Mon,  4 Jul 2022 13:17:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 04 Jul 2022 13:17:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1656955074; x=
        1657041474; bh=Dg+SE6V77FnOoUivR2AGYvk6gRYLfawEFeKRY/bNZf4=; b=c
        fNh0E5Y/GRPKkmtFDMlEirGDYhjZVd2dBKTCaSuFa9qLn5pSCuRKdUGWYfx5wCvd
        GKvM2O/fODt9rKbupG7QaT/DF83UimGcWuxu8yZIAxcR0mxs/sBiKOZRv27qlpCt
        i5rM1NdM+F8JfJ+xbYGfX7wIy+XlIGN669u7ipVkdnZ5Li+Fx5Nii+qDNAfbUmBb
        2iO6n1Esz0LjB0+O9jT92cLqJMtr133JNb1E9caQbguCpA++XEsuCpXcFkmpkc81
        MV1QUKyEmBDlRRfWV6J4qFq7j+jbkzxHkm51JzDCFg65SPaSHbgasdb5tEmrMek6
        jP0I/TQcwVTtfqktdLmjg==
X-ME-Sender: <xms:wiDDYqRjA1SvMKoKR_CPlEi409MCKGdBjX9aGlP_686idVN7dKA5Jg>
    <xme:wiDDYvzgHCxUEYUhzS8L4C4f4Rk8UM37ii4h6gowjbphjzIuuIwpkOPlqN7fQp9Zf
    E2MdC4G2II3b1Q>
X-ME-Received: <xmr:wiDDYn2LHqKsw5_KdxelMSXaRyuLqROWC7gGUUo8pyhROzxsJziZdcVZENBt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudehledgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepkfgu
    ohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrf
    grthhtvghrnhepudeiiedvveekuedvgfehieehueevjefgleeggeejgeekgfdvuedtueek
    jeekffetnecuffhomhgrihhnpehsphhinhhitghsrdhnvghtnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdr
    ohhrgh
X-ME-Proxy: <xmx:wiDDYmAec7rej_Vmw71HmzMgRLs3Z8vAiTmTPg_c_SyFPMedLh0FtQ>
    <xmx:wiDDYjjzEU3qqpeFmf7JAEFWHnCr5QAwAD2yasDfsKHqmzEnaSRcIQ>
    <xmx:wiDDYip7rzlORHtezYfa6JriJERZ-pkvfDc3d-CT_YF6nd_byewkLA>
    <xmx:wiDDYmsvQ8GJqkPJfLCmHWVxVd1bjEt6lj5vGhhVzAkoaAbkTLpwIg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Jul 2022 13:17:53 -0400 (EDT)
Date:   Mon, 4 Jul 2022 20:17:51 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Petr Machata <petrm@nvidia.com>, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: Report: iproute2 build broken?
Message-ID: <YsMgv2plWTuWcd4X@shredder>
References: <CAM0EoMkWjOYRuJx3ebY-cQr5odJekwCtxeM5_Cmu1G4vxZ5dpw@mail.gmail.com>
 <YsMWpgwY/9GzcMC8@shredder>
 <CAM0EoM=Gycw88wC+tSOXFjEu3jKkqgLU8mNZfe48Zg0JXbtPiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM0EoM=Gycw88wC+tSOXFjEu3jKkqgLU8mNZfe48Zg0JXbtPiQ@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 12:59:45PM -0400, Jamal Hadi Salim wrote:
> Thanks Ido. That fixed it.
> General question: do we need a "stable" iproute2?

Maybe a new point release is enough (e.g., 5.18.1)?

I see that's what Stephen did the last time something similar happened:

$ git log v4.14.0^..v4.14.1

commit 212b52299e90a369373b9e38924b9492df695559
Author: Stephen Hemminger <stephen@networkplumber.org>
Date:   Mon Nov 13 10:09:57 2017 -0800

    v4.14.1

commit b867d46dafee4ac81acecd2d398c392eb43b50bb
Author: Stephen Hemminger <stephen@networkplumber.org>
Date:   Mon Nov 13 10:08:39 2017 -0800

    utils: remove duplicate include of ctype.h
    
    Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

commit aba736dc251ee7aa7c2035e18bffc37b18f05222
Author: Leon Romanovsky <leonro@mellanox.com>
Date:   Mon Nov 13 12:21:19 2017 +0200

    ip: Fix compilation break on old systems
    
    As was reported [1], the iproute2 fails to compile on old systems,
    in Cong's case, it was Fedora 19, in our case it was RedHat 7.2, which
    failed with the following errors during compilation:
    
    ipxfrm.c: In function ‘xfrm_selector_print’:
    ipxfrm.c:479:7: error: ‘IPPROTO_MH’ undeclared (first use in this
    function)
      case IPPROTO_MH:
           ^
    ipxfrm.c:479:7: note: each undeclared identifier is reported only once
    for each function it appears in
    ipxfrm.c: In function ‘xfrm_selector_upspec_parse’:
    ipxfrm.c:1345:8: error: ‘IPPROTO_MH’ undeclared (first use in this
    function)
       case IPPROTO_MH:
            ^                                                                                                                                                            make[1]: *** [ipxfrm.o] Error 1
    
    The reason to it is the order of headers files. The IPPROTO_MH field is
    set in kernel's UAPI header file (in6.h), but only in case
    __UAPI_DEF_IPPROTO_V6 is set before. That define comes from other kernel's
    header file (libc-compat.h) and is set in case there are no previous
    libc relevant declarations.
    
    In ip code, the include of <netdb.h> causes to indirect inclusion of
    <netinet/in.h> and it sets __UAPI_DEF_IPPROTO_V6 to be zero and prevents from
    IPPROTO_MH declaration.
    
    This patch takes the simplest possible approach to fix the compilation
    error by checking if IPPROTO_MH was defined before and in case it
    wasn't, it defines it to be the same as in the kernel.
    
    [1] https://www.spinics.net/lists/netdev/msg463980.html
    
    Cc: Cong Wang <xiyou.wangcong@gmail.com>
    Cc: Riad Abo Raed <riada@mellanox.com>
    Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

commit 7d14d00795c334a288f1733bfdabdf363a7f962c
Author: Stephen Hemminger <stephen@networkplumber.org>
Date:   Sun Nov 12 16:29:43 2017 -0800

    v4.14.0
