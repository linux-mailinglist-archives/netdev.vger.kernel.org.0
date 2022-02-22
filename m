Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57B44C014C
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbiBVSad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234221AbiBVSad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:30:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D696CEDF0A
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:30:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B074B81B8A
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 18:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7828CC340E8;
        Tue, 22 Feb 2022 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645554603;
        bh=A7cQLGeEaPkkPs6wJz8WjcenbYNRYpitkXqKLj7JY34=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=spcl52Vm8taHqY8KGKmB0m4sBfSolK8ivkCmHlQxzpILwXuDL1JLT7fszIPzgEIRa
         8VO0Ihu7Z5wBkBZDshR+PwCkfwEYwtBoxfAjLH8DW/k8i6suVdC55dzTDwM4sfvdQF
         844VmfjkKohlmFqr8phdU+ZY+/1XVsMPVjoZVrRn4ME+DfMs9w2iv0QwE3O/iawvvd
         6D5aLtPIRZgZvAlcs5IOAYElsKimZAUo2b2CFFJ5cRPNFZb9GbbRWIqtnBenOVzl0B
         z6eZa/bW5ETgXLmPahao1z2tTbB6RlEB7dXyeYCH4mI0+QeEYNAhxHHmwUsKGOT2Cv
         gMSv698MPucCg==
Date:   Tue, 22 Feb 2022 10:30:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Casper Andersson <casper@casan.se>
Cc:     Steen Hegelund <Steen.Hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Lars Povlsen" <lars.povlsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: sparx5: Support offloading of bridge port
 flooding flags
Message-ID: <20220222103002.17cc1fb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220219145648.mucghw6kx5tkac7d@soft-dev3-1.localhost>
References: <20220217144534.sqntzdjltzvxslqo@wse-c0155>
        <20220217201830.51419e5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220218090127.vutf5qomnobcof4z@wse-c0155>
        <20220218202636.5f944493@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220219145648.mucghw6kx5tkac7d@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Feb 2022 15:56:48 +0100 Horatiu Vultur wrote:
> The 02/18/2022 20:26, Jakub Kicinski wrote:
> > > I apologize. This seems to be Protonmail's doing. When I look at the
> > > web interface for Protonmail I can see that you are the only recipient
> > > it says PGP encrypted for. This is probably because Protonmail will
> > > automatically encrypt when both ends use Protonmail. Though I do not see
> > > this indication on your reply. I tried switching to PGP/Inline instead
> > > of PGP/MIME for this message. I hope this works.  Otherwise, I can
> > > resubmit this patch using another email address. I did not find a way
> > > to disable the automatic encryption. Or if you have any other
> > > suggestions to get around this.  
> > 
> > If I'm the only one who didn't get the plain text version - it's not
> > a big deal.  
> 
> I also have problems seeing Casper's patch.

Looks like Dave marked the patch as Changes Requested in patchwork.
Casper, could you repost after all?

> The only comment that I have to the patch, it would be nice to implement
> also the SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS callback. But I presume
> that can be added later on.

Perhaps making it a two patch series and also addressing Horatiu's
request?
