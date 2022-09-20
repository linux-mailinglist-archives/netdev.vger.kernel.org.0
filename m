Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804AC5BEDF4
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 21:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiITTlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 15:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiITTlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 15:41:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAA4501B0;
        Tue, 20 Sep 2022 12:41:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69F66B82CA4;
        Tue, 20 Sep 2022 19:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D6DC433D6;
        Tue, 20 Sep 2022 19:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663702910;
        bh=2IRKjLcjE85iUZpYctlQlYqRSRVbXGHAuv3E3ZjSaUI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VHafld0cxlOe8SCBUQ/TNA0wE9aAHKjyh6c/Ih9QLDgi3D5Naf2p5qGjabdzS7lyQ
         oITFhdFfNh1VQUXxIoa1iSebpCIxiwxbVtsoJycvckGBLuyJTFNXKdDaQB4ppwXLdm
         OfqeC+tXn69tUZhaut11zlP9P3dz0WhzlUhak1j0KUnflAa+cDqulKRfiEI6rfBZNe
         SH+bUOsszq2yiWtV7DL8lbYW3LgwHx2x+zkLxxWImFG2PAXI6ftnzu/VMPdNHjS6/C
         7AfTm2oZzuGoqh29pJ3dsLGjQvVP3Ae24y0/MxOty/mAbUJW+a57aZ3lhehfAV0YSO
         9jl/83xpihivA==
Date:   Tue, 20 Sep 2022 12:41:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li Zhong <floridsleeves@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, edumazet@google.com, davem@davemloft.net
Subject: Re: [PATCH v1] net/ethtool/tunnels: check the return value of
 nla_nest_start()
Message-ID: <20220920124148.58e8aab5@kernel.org>
In-Reply-To: <CAMEuxRq3YDsCVBrdP78HnPeL7UcFiLWwKt6mEB2D+EVeSWG+pw@mail.gmail.com>
References: <20220917022602.3843619-1-floridsleeves@gmail.com>
        <20220920113744.64b16924@kernel.org>
        <CAMEuxRq3YDsCVBrdP78HnPeL7UcFiLWwKt6mEB2D+EVeSWG+pw@mail.gmail.com>
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

On Tue, 20 Sep 2022 12:31:29 -0700 Li Zhong wrote:
> On Tue, Sep 20, 2022 at 11:37 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 16 Sep 2022 19:26:02 -0700 Li Zhong wrote:  
> > >                       goto err_cancel_table;
> > >
> > >               entry = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY);
> > > +             if (!entry)
> > > +                     return -EMSGSIZE;  
> >
> > not even correct, and completely harmless  
> 
> Thanks for your reply. Maybe a more suitable way of error handling is 'goto
> err_cancel_table;'?

Yes, but you _most_ provide the detailed analysis of the impact 
in the commit message for the patches to be considered for merging.
