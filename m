Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27B45E6318
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbiIVNDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiIVNDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:03:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909091ADAB
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 06:03:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A6F76118A
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:03:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C75DC433D6;
        Thu, 22 Sep 2022 13:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663851827;
        bh=D63BxjWM8pb7QyIzYZLkrM1YkKp5VD5GwD7tuA6Ot6w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iXuTldpMP/+4ZRcOp1gQc5fmV3466UnRkLiPV9WwyBSl4b6F4nv25K1JJCeMOx+sr
         suOk+nUCOGPfpBqhi72sd29RIi4OUBahbNSCIf/90zrr4XboejROSlJf+/zH7+2ehk
         3QCW/aYr5vRU4MFj0r+vqVu2fSGv2ANFBnD1OSRqDeLlbfj2LUkhuboGPrX3KGbSvV
         zHu4Y9L3EjQfc/4+RAi8+vSoEe1nJ+opimNR9irzfPxn5CchFUSKXTFMBuQPtxFXmF
         Xz96+DKFhEipXxBqYbgi54/3LAbtoZKbkKxSP3+Xf01g3C4SZhusbH69dGoy91hQqu
         AF9BrjyJpiWNA==
Date:   Thu, 22 Sep 2022 06:03:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set}link
Message-ID: <20220922060346.280b3af8@kernel.org>
In-Reply-To: <20220922110951.GA21605@debian.home>
References: <20220921030721.280528-1-liuhangbin@gmail.com>
        <20220921060123.1236276d@kernel.org>
        <20220921161409.GA11793@debian.home>
        <20220921155640.1f3dce59@kernel.org>
        <20220922110951.GA21605@debian.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 13:09:51 +0200 Guillaume Nault wrote:
> That's why I complained when RTM_NEWNSID tried to implement its own
> notification mechanism:
> https://lore.kernel.org/netdev/20191003161940.GA31862@linux.home/
> 
> I mean, let's just use the built-in mechanism, rather than reinventing
> a new one every time the need comes up.

See, when you say "let's just use the built-in mechanism" you worry 
me again. Let's be clear that no new API should require the use of
ECHO for normal operation, like finding out what the handle of an
allocated object is.
