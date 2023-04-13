Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874DE6E0410
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 04:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjDMCYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 22:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDMCYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 22:24:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2392D43
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 19:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B887863919
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89856C433EF;
        Thu, 13 Apr 2023 02:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681352676;
        bh=6y4rjV1Zy8gYgCldDco9axyg7nVERe53kB5JNbiAsEg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dwArQt8QqPNybMbhnhpQCHX5UemciAiYoQ8gT4QWQvTHrjruYo8Axee2738mLBaLf
         wWq2q6aPG0lL6yjO/CyWifLKDdpsCARjsH6f6uvHi2/SWvf+oMqd2Yfh0xE37WTmSY
         1rBkCR2sJhWdDzJ6K/Qa1rfIcvYTn7lX9lsVZORzBzE3wME7HyPj4NReaNLOoWN9rR
         pbP8QSzDkpcZJxeFoVrZ2TEaki9ES9KDOoaWZSbXWayGuc2lz8fY1dotl5A77439Uf
         M+dGwa+RIFd61iSxx6WR3/nwvGf5UfJxu0rD7MZ8sxR2wuBPVsvTmeIBeBSDumtGe7
         PgiXJcGlW2JNw==
Date:   Wed, 12 Apr 2023 19:24:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        <willemb@google.com>, <decot@google.com>, <netdev@vger.kernel.org>,
        <jesse.brandeburg@intel.com>, <edumazet@google.com>,
        <intel-wired-lan@lists.osuosl.org>, <anthony.l.nguyen@intel.com>,
        <pabeni@redhat.com>, <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 00/15] Introduce Intel
 IDPF driver
Message-ID: <20230412192434.53d55c20@kernel.org>
In-Reply-To: <d2585839-fcec-4a68-cc7a-d147ce7deb04@intel.com>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
        <ZDb3rBo8iOlTzKRd@sashalap>
        <643703892094_69bfb294a3@willemb.c.googlers.com.notmuch>
        <d2585839-fcec-4a68-cc7a-d147ce7deb04@intel.com>
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

On Wed, 12 Apr 2023 19:03:22 -0500 Samudrala, Sridhar wrote:
> On 4/12/2023 2:16 PM, Willem de Bruijn wrote:
> > Sasha Levin wrote:  
> >> On Mon, Apr 10, 2023 at 06:13:39PM -0700, Pavan Kumar Linga wrote:  
> >> How will this work when the OASIS driver is ready down the road?
> >>
> >> We'll end up with two "idpf" drivers, where one will work with hardware
> >> that is not fully spec compliant using this Intel driver, and everything
> >> else will use the OASIS driver?
> >>
> >> Does Intel plan to remove this driver when the OASIS one lands?
> >>
> >> At the very least, having two "idpf" drivers will be very confusing.  
> > 
> > One approach is that when the OASIS v1 spec is published, this driver
> > is updated to match that and moved out of the intel directory.  
> 
> Yes. We don't want to have 2 idpf drivers in the upstream kernel.
> It will be an Intel vendor driver until it becomes a standard.
> Hope it will be OK to move the driver out of the intel directory when 
> that happens.

As I said previously in [0] until there is a compatible, widely
available implementation from a second vendor - this is an Intel
driver and nothing more. It's not moving anywhere.

I think that's a reasonable position which should allow Intel to ship
your code and me to remain professional.

[0] https://lore.kernel.org/all/20230403163025.5f40a87c@kernel.org/
