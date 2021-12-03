Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852C0467058
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345945AbhLCDBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 22:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242005AbhLCDBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 22:01:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63A5C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:58:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81CB66281C
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 02:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97996C00446;
        Fri,  3 Dec 2021 02:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638500296;
        bh=6xGCtty0xr69UE/JfzcRLENFCltTmG3Uu0JbhsTjEM0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TT6jW1n7ZvkaCv0Z/nSi0IwKqXWS5vWUALa/JUQItedBNmNBnMM1Keuqh83y/Is5B
         X6ka0qrwg5JtfaUD/uZXrTR9Lk/yjz7mp1yFUwwvwihVktSrpJqD2Ira10mOTsgJjJ
         VhvZATVzQTUqQgKMthJ0eJYz9XMNVX/BJwlfdIGJcVQCQ4lK2tGtkXh5JKeifTMnez
         xwNbS0rmr46/bUjpQvNLKyIs+UvjY32WiImPbLs4BJGVHzBIbchl+atb5UDTUnoAtw
         X89pqqVIzVfiifUQsnPOlU3kX+V9b2UaSdh3nT7GgrWMb0b/e6YPUGaYNR7jsINS7n
         Yz7QHOXRIkr1g==
Date:   Thu, 2 Dec 2021 18:58:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, davem@davemloft.net,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCH net-next] bond: pass get_ts_info and SIOC[SG]HWTSTAMP
 ioctl to active device
Message-ID: <20211202185815.27e42ac0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YamHCHzmmQFA6Wxb@Laptop-X1>
References: <20211130070932.1634476-1-liuhangbin@gmail.com>
        <20211130071956.5ad2c795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YacAstl+brTqgAu8@Laptop-X1>
        <20211201071118.749a3ed4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Yag3yI4cNnUK2Yjy@Laptop-X1>
        <20211202065923.7fc5aa8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YamHCHzmmQFA6Wxb@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Dec 2021 10:55:04 +0800 Hangbin Liu wrote:
> On Thu, Dec 02, 2021 at 06:59:23AM -0800, Jakub Kicinski wrote:
> > On Thu, 2 Dec 2021 11:04:40 +0800 Hangbin Liu wrote:  
> > User can point their PTP daemon at any interface. Since bond now
> > supports the uAPI the user will be blissfully unaware that their
> > configuration will break if failover happens.
> > 
> > We can't expect every user and every PTP daemon to magically understand
> > the implicit quirks of the drivers. Quirks which are not even
> > documented.  
> 
> Thanks for the explanation. I understand what you mean now.
> > 
> > What I'm saying is that we should have a new bit in the uAPI that
> > tells us that the user space can deal with unstable PHC idx and reject
> > the request forwarding in bond if that bit is not set. We have a flags
> > field in hwtstamp_config which should fit the bill. Make sense?  
> 
> Yes, this makes sense for me. I check this and try post a patch next week.

SGTM, thanks!
