Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A8C696EA5
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 21:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbjBNUlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 15:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbjBNUlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 15:41:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605ED2BED2
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 12:40:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFF57618A8
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 20:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF7CC433EF;
        Tue, 14 Feb 2023 20:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676407256;
        bh=4zsZXfwf74bJFssWdqA5/Fmp6j9owfxJ5DruIC0CRlc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cSApAA81gbRcSLpxePoByN+UuTIDasnGq1o0isBWLvf6UINaXYrBwfsHE/k7fv0qa
         ONaaEOf2WxW12DT5Ow8LnmIFdx+hZDbaR6pRDFEb54HgQVYp0K+zMSphQkt082Boic
         DtQJEW6VzQDw+pGm0EmFLtQh6gVnWkyFGYgjMNnLJMtBaLeLRGJABsRZO/vVcrIXDa
         YEeScljqWkSyWt0cxXw0f2CsCv1F4UvJA/bRnpd/Bst1fu3c20O9UdVXBWd8mEnW1I
         X5PtY+YdehN1yDpNLtrY0Y7MWxgqoOoDXB5OeliRmWF4EkUOGy/fHYmAkate9uGeIr
         KYiaQHT5gycKA==
Date:   Tue, 14 Feb 2023 12:40:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mark Bloch <mbloch@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: [net-next 01/15] net/mlx5: Lag, Let user configure multiport
 eswitch
Message-ID: <20230214124055.6e9df4dd@kernel.org>
In-Reply-To: <b4300690-f9a3-5de6-08f8-0b3430db7fd8@nvidia.com>
References: <20230210221821.271571-1-saeed@kernel.org>
        <20230210221821.271571-2-saeed@kernel.org>
        <20230210200329.604e485e@kernel.org>
        <db85436e-67a3-4236-dcb5-590cf3c9eafa@nvidia.com>
        <20230213180246.06ae4acd@kernel.org>
        <b4300690-f9a3-5de6-08f8-0b3430db7fd8@nvidia.com>
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

On Tue, 14 Feb 2023 09:31:10 +0200 Mark Bloch wrote:
> > Oh, the "legacy software where updating the logic isn't possible"
> > sounds concerning. Do we know what those cases are? Can we perhaps
> > constrain them to run on a specific version of HW (say starting with
> > CX8 the param will no longer be there and only the right behavior will
> > be supported upstream)?  
> 
> While I can encourage customers to update their software to deal with
> this new mode it's up to them. As you already know, it's hard to change
> customers infrastructure so quickly. These things take time. They plan
> on running multiple hardware generations on top of the same software.
> I'll keep pushing on making this mode the default one.

I think we should document some time horizon. We can always push it
back but having a concrete plan in place may motive users. Also it's
useful to point at and say "we warned you". 

Doesn't have to be anything very imminent, time flies.
