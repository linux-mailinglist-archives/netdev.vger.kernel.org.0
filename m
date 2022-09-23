Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9555E71E5
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 04:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbiIWC2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 22:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbiIWC2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 22:28:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3B5118DD6
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 19:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB4C4B828D0
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 02:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590D1C433D6;
        Fri, 23 Sep 2022 02:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663900085;
        bh=8EPXvxHioGDWdhx1aOXARgQ7xbOoHEpDJc8XP5akxvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KPoqSEmWJipigdnIlnXBIVurTb5HEXZa0pHXll5U04R1FCk1CbjPw2/utqTPcFTGD
         5Z/gD/xK4j/3CWsiZwBxKPe59VoSVppcGRRda9u22bVgC4qk5XcrV0d10Ga9lo7Y/q
         Lbzbc5Pcn3y0HIXq5rXH5BLZMuxk335WGfsgX65nW7NwubJ9JrNZ+/Fws44agqXuJm
         FXR5FBW5fkQsvyg4ZdhlHkcFCqfJYu+hKlRPSXFpFla//dVq8IGn3XpGFYl+87pc4u
         AUBDxsZ2q421MunHPx8+ue/Lk2Uk0vP/ZvMBvdsmrnavRy4OQZ8K+5daT7L/xh/bN5
         9L1Hv+WbxJ5EA==
Date:   Thu, 22 Sep 2022 19:28:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li Zhong <floridsleeves@gmail.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        davem@davemloft.net
Subject: Re: [PATCH net-next v3] ethtool: tunnels: check the return value of
 nla_nest_start()
Message-ID: <20220922192804.09efa56f@kernel.org>
In-Reply-To: <20220921181716.1629541-1-floridsleeves@gmail.com>
References: <20220921181716.1629541-1-floridsleeves@gmail.com>
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

On Wed, 21 Sep 2022 11:17:16 -0700 Li Zhong wrote:
> It will cause null pointer dereference when entry is used
> in nla_nest_end().

No it will not, there is no way for the flow to get to nla_nest_end()
if the skb is full :/

I will fix the commit message myself and apply but I'd like you to not
send more "error checking" patches to networking unless you're sure
that there is indeed a bug.
