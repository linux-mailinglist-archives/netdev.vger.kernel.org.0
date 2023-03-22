Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689DD6C53A5
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjCVSXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjCVSXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:23:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D329B16AD5
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:23:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7254BB81D9A
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 18:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37EFC433EF;
        Wed, 22 Mar 2023 18:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679509431;
        bh=EtlL46TSomobU3yIcyG/ijMsyu/5fCstggC5jDN9o4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tN39wHVeoReDdqbvPun+067+kpuNb86uJxEZTSfTfG+v4hZ8D6aTKaKljQTowoJwR
         ZGekvPPqfgtla4Zs07bgqRFwrLNiPkFJuKWzTNCOJ3GUTgD0euxcZCcHQuKQJLJWyp
         raBfdUQuEBGtvoUnSCqlNPb48olRP9pZPNO/avqpRLbDXcgQF55rYqbMBhN9DkGrsL
         O0ixGZOdk0LylHqCf7jJzxZ2tvNcj6b3eS6vXrJ6RTJyKhVGlj+IBEt5iTOr3nsljS
         qp4fU/GFU4VrVa9+pshVzrf5QBzzWgKEtdqrOQGrgg6UtUV/UWJXMRnklPOv1NDSys
         kFknVMUp+lNow==
Date:   Wed, 22 Mar 2023 11:23:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, Tianhao Zhao <tizhao@redhat.com>,
        Jonathan Cooper <jonathan.s.cooper@amd.com>
Subject: Re: [PATCH net] sfc: ef10: don't overwrite offload features at NIC
 reset
Message-ID: <20230322112349.0e834126@kernel.org>
In-Reply-To: <CACT4oucW_A1PyQYszxxvnuG8uhkdzdeUjJpoyTwn-+vQBPJgsQ@mail.gmail.com>
References: <20230308113254.18866-1-ihuguet@redhat.com>
        <ddf82062-8755-1980-aba7-927742fed230@gmail.com>
        <CACT4oucW_A1PyQYszxxvnuG8uhkdzdeUjJpoyTwn-+vQBPJgsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 07:47:42 +0100 =C3=8D=C3=B1igo Huguet wrote:
> > Could you clarify what checks were removed?  All I can see is the
> >  'NETIF_F_TSO6 requires NETIF_F_IPV6_CSUM' check, and Siena already
> >  supported NETIF_F_IPV6_CSUM (it's only Falcon that didn't).
> > Or are you also referring to some items moving from efx.c to the
> >  definition of EF10_OFFLOAD_FEATURES?  That's fine and matches more
> >  closely to what we do for ef100, but again the commit message could
> >  explain this better.
> > In any case this should really be two separate patches, with the
> >  cleanup part going to net-next.
> > That said, the above is all nit-picky, and the fix looks good, so:
> > Acked-by: Edward Cree <ecree.xilinx@gmail.com>
>=20
> Hi. Kindly asking about the state of this patch, it is acked since 2
> weeks ago and it appears in patchwork as "changes requested". Is there
> something else I need to do? Thanks!

The commit message needs to be beefed up to answer all questions Ed had.
