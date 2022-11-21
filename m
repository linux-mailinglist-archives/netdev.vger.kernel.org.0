Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0415632DC0
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiKUUSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiKUUSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:18:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18807BE86A;
        Mon, 21 Nov 2022 12:18:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 60A8ECE18E3;
        Mon, 21 Nov 2022 20:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C7EC433D6;
        Mon, 21 Nov 2022 20:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669061884;
        bh=IhNl1vJm3VXqLz/ACfcWWRbRVPnFw5gG6KxRJkVvCnA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lxUWsUEPCrFrZwmJ6lNTMZOQFI44VAboWP7tjFx/pVRPWovDYI4i5cPpy/6KUJGNg
         OI4+n/0mmTC1k7r98QA+zMbNSZuulwXCQPpP0tN/NedQjlCcjv3qNodgraUNJzkb1k
         b0greRQNwn4uhMPxVMJlD0x71Iu05YKJlsVK817AEVr2WdWdEkLyJtkhyArjGEMA3u
         kltB4rJmyfEj/C1p6c5lo0k1O/Aqf2K9nANgcCSqLIAlImpdUMzmK0cg5Bn8ZBF7U0
         JXT+ZYBP65Dk4te31iG353KqFaUQnVVnxcr8NrDyADFAshMSeMn/6WT/K3fUauGbXz
         AysDyZtShvHdA==
Date:   Mon, 21 Nov 2022 12:18:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] kobject: make kobject_get_ownership() take a
 constant kobject *
Message-ID: <20221121121803.31962489@kernel.org>
In-Reply-To: <20221121094649.1556002-1-gregkh@linuxfoundation.org>
References: <20221121094649.1556002-1-gregkh@linuxfoundation.org>
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

On Mon, 21 Nov 2022 10:46:45 +0100 Greg Kroah-Hartman wrote:
> The call, kobject_get_ownership(), does not modify the kobject passed
> into it, so make it const.  This propagates down into the kobj_type
> function callbacks so make the kobject passed into them also const,
> ensuring that nothing in the kobject is being changed here.
> 
> This helps make it more obvious what calls and callbacks do, and do not,
> modify structures passed to them.

Acked-by: Jakub Kicinski <kuba@kernel.org>
