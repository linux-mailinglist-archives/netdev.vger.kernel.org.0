Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032666925E8
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbjBJS7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbjBJS73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:59:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D5A7BFC3;
        Fri, 10 Feb 2023 10:59:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4329061E61;
        Fri, 10 Feb 2023 18:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C98BC433EF;
        Fri, 10 Feb 2023 18:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676055566;
        bh=gOSstwPFMMk9fE/cCHUBfXPLjlf9Zm0PlxvyC6moXGE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NzL5YoIT0umDhh2Q4Y3baEE6LQ+hx/4u67nRz7im6vJtZDP1fcjl+lGqEkXhDeAEA
         BQYMg9iA7zEVgRjwJJFZgcyLTdbo9Xh50nKeXvLsAwCjBHl6EQgbrhdk3BVNw4Taht
         oVdAc9eQDLqfMIhwuzMRdrwDIFPT3dq4A8MEnLTj5p0fstRJlUdJc+FNZ+os973o4T
         UG4DUyoso7vRHEYK4yJtyIinQ63IiX5zIiplwpwyWsJAOkvFfa/4ktUWOhF3lTjuzr
         6Qj3HcZBkAWjCiXc7X95IHijLOWo4g8E3hin9J8GCJ7+sMhW2oPIlV/ENrwzO67+0A
         RwOE3WS6z/dAQ==
Date:   Fri, 10 Feb 2023 10:59:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning
 requests
Message-ID: <20230210105925.26c54e15@kernel.org>
In-Reply-To: <20230210111843.0817d0d3@xps-13>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
        <20230203201923.6de5c692@kernel.org>
        <20230210111843.0817d0d3@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Feb 2023 11:18:43 +0100 Miquel Raynal wrote:
> > > +	/* Monitors are not allowed to perform scans */
> > > +	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)    
> > 
> > extack ?  
> 
> Thanks for pointing at it, I just did know about it. I did convert
> most of the printk's into extack strings. Shall I keep both or is fine
> to just keep the extack thing?
> 
> For now I've dropped the printk's, please tell me if this is wrong.

That's right - just the extack, we don't want duplicated prints.
