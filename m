Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263926293CA
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbiKOJE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiKOJE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:04:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E78110C4;
        Tue, 15 Nov 2022 01:04:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0541DB81707;
        Tue, 15 Nov 2022 09:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E74C433C1;
        Tue, 15 Nov 2022 09:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668503093;
        bh=l+6lv6fSCW8Nf1v8EJEoRri4jO0Md/OxDKQaEU4bFBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WgPXICecysl5i7ERxIDs1FQ3gc0/tm54Etck+yVsN8qxOrtalpWUlXA1N95tkxYrH
         0oQlr4Qb8K3ZsRlr6AwAy4qJOljw0CLYPaQZQmsQNggMwFfjf6IF20RwNvRt5VG0i6
         G1p4uJYHM0KEFFhn6dzn3+LOqSx18L5IBHz7j4r+4Og21dlL5g98VPoIWYgIFW7MaZ
         ThYFdeEqccDYhZ9daCiMotBtV83D665Iiev8Vi8gMgfJlFKabpSZFvVARUZqsNdlXO
         Ih/H+GAlUaKXJ6NKwAeqpit8QReyOYQZNeQtCrYfVOZbgx9IHBnaY4Oa4ejLdXCYzU
         S6bdNJDnsZh9g==
Date:   Tue, 15 Nov 2022 11:04:49 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liron Himi <lironh@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [EXT] Re: [PATCH net-next 1/9] octeon_ep: wait for firmware ready
Message-ID: <Y3NWMZwngTs/1Tn4@unreal>
References: <20221107072524.9485-1-vburru@marvell.com>
 <20221107072524.9485-2-vburru@marvell.com>
 <Y2i/bdCAgQa95du8@unreal>
 <BYAPR18MB24237D62CF4947B889D84BDCCC059@BYAPR18MB2423.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR18MB24237D62CF4947B889D84BDCCC059@BYAPR18MB2423.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 08:47:42PM +0000, Veerasenareddy Burru wrote:
> 
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Monday, November 7, 2022 12:19 AM
> > To: Veerasenareddy Burru <vburru@marvell.com>
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Liron Himi
> > <lironh@marvell.com>; Abhijit Ayarekar <aayarekar@marvell.com>; Sathesh
> > B Edara <sedara@marvell.com>; Satananda Burla <sburla@marvell.com>;
> > linux-doc@vger.kernel.org; David S. Miller <davem@davemloft.net>; Eric
> > Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> > Paolo Abeni <pabeni@redhat.com>
> > Subject: [EXT] Re: [PATCH net-next 1/9] octeon_ep: wait for firmware ready
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > On Sun, Nov 06, 2022 at 11:25:15PM -0800, Veerasenareddy Burru wrote:
> > > Make driver initialize the device only after firmware is ready
> > >  - add async device setup routine.
> > >  - poll firmware status register.
> > >  - once firmware is ready, call async device setup routine.
> > 
> > Please don't do it. It is extremely hard to do it right. The proposed code that
> > has combination of atomics used as a locks together with absence of proper
> > locking from PCI and driver cores supports my claim.
> > 
> > Thanks
> Leon
>           What is the alternate approach you suggest here ?  Are you suggesting usage of deferred probe ? the driver initialization cannot proceed till firmware ready is set by firmware.

This is what I initially thought.

Thanks

> Thanks
