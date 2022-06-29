Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A841656059A
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiF2QRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbiF2QRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:17:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C284E2FFCB;
        Wed, 29 Jun 2022 09:17:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E48161C01;
        Wed, 29 Jun 2022 16:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB67C34114;
        Wed, 29 Jun 2022 16:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656519428;
        bh=yt0I8+VCsf7APINpnOL7Z2qrIyVeWcQxhwKAfN72C3Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SPo0IhDMe2tF5jCWTLb28d5R/kU2kb654fjfzSlfHgsRozlFu88D4k5xTBIYp1Owp
         /UP/PkBpia6sMuOLjRLN5411EPpzaEItOAm7brbTsb4NRi/a2CW5Ff5F9AkxgUlfP1
         o//B6lWq+hKNgH8/b5RL1wQI+y9+6KAUC565hx4jPSUj8r1mcogasTI5iD5Of658Sz
         cS4EyM3dUCG0rvD+JPuCt+Omt+Ay08DXx6mgDNeOYZyS7z63ECvp/5oyRzAe/3jWzH
         Q9tlyUSMUZXBrJ82IFTzEaxsx4krcnVFRhPEu5vh1qKwrIku17u7wrv/Pw1iNNZBz4
         GG8q/IvNudlMA==
Date:   Wed, 29 Jun 2022 09:17:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: Re: [PATCH bpf] xsk: mark napi_id on sendmsg()
Message-ID: <20220629091707.20d66524@kernel.org>
In-Reply-To: <20220629091629.1c241c21@kernel.org>
References: <20220629105752.933839-1-maciej.fijalkowski@intel.com>
        <CAJ+HfNj0FU=DBNdwD3HODbevcP-btoaeCCGCfn2Y5eP2WoEXHA@mail.gmail.com>
        <YrxLTiOIpD44JM7R@boxer>
        <20220629091629.1c241c21@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 09:16:29 -0700 Jakub Kicinski wrote:
> > Would it make sense to introduce napi_id to xsk_buff_pool then?
> > xp_set_rxq_info() could be setting it. We are sure that napi_id is the
> > same for whole pool (each xdp_buff_xsk's rxq info).  
> 
> Would it be possible to move the marking to when the queue is getting
> bound instead of the recv/send paths? 

I mean when socket is getting bound.
