Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E28E6E0772
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 09:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjDMHPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 03:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjDMHPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 03:15:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C17083F0
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 00:15:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32A8363BCB
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 07:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E2DC433EF;
        Thu, 13 Apr 2023 07:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681370134;
        bh=62nqpbftTHPVHp6Tb1GAyNozDF2hZC9FLijQL9QkXRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LEMpdxxEtuX4S4qK8HNpc1f1ydmWmIipnDOFQ5JwZP1gJfL6MinxO0wOX6VEhYMOS
         JSjGPY454pEtXKRpktbvfgSdXI9aoWf+zyBkulOVHI1pqj2cm2aROy6hp/72XvxBOo
         loA/4yrVc8czwJhWi/0aGRVMyvAru2ko+gxWu9vq3B/CMJa3tZ/vwPZS5n8K60C9Ij
         AlsRYwIMlh8zaDkoUTMmuwOXLgQr+PrQ9lZYaxvm8GGnBV5W3ftgA8y6ZoYuQKIyjh
         ZqWo7GiC8AmQtI7ZTCZo/eD3Tj9cXlrcdqoHYu+5x0NGltzcs2ItCG9RlSOIWAWWid
         EpopElnPGB16A==
Date:   Thu, 13 Apr 2023 10:15:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        willemb@google.com, decot@google.com, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        pabeni@redhat.com, davem@davemloft.net
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 00/15] Introduce Intel IDPF
 driver
Message-ID: <20230413071529.GE182481@unreal>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
 <ZDb3rBo8iOlTzKRd@sashalap>
 <643703892094_69bfb294a3@willemb.c.googlers.com.notmuch>
 <d2585839-fcec-4a68-cc7a-d147ce7deb04@intel.com>
 <20230412192434.53d55c20@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412192434.53d55c20@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 07:24:34PM -0700, Jakub Kicinski wrote:
> On Wed, 12 Apr 2023 19:03:22 -0500 Samudrala, Sridhar wrote:
> > On 4/12/2023 2:16 PM, Willem de Bruijn wrote:
> > > Sasha Levin wrote:  
> > >> On Mon, Apr 10, 2023 at 06:13:39PM -0700, Pavan Kumar Linga wrote:  
> > >> How will this work when the OASIS driver is ready down the road?
> > >>
> > >> We'll end up with two "idpf" drivers, where one will work with hardware
> > >> that is not fully spec compliant using this Intel driver, and everything
> > >> else will use the OASIS driver?
> > >>
> > >> Does Intel plan to remove this driver when the OASIS one lands?
> > >>
> > >> At the very least, having two "idpf" drivers will be very confusing.  
> > > 
> > > One approach is that when the OASIS v1 spec is published, this driver
> > > is updated to match that and moved out of the intel directory.  
> > 
> > Yes. We don't want to have 2 idpf drivers in the upstream kernel.
> > It will be an Intel vendor driver until it becomes a standard.
> > Hope it will be OK to move the driver out of the intel directory when 
> > that happens.
> 
> As I said previously in [0] until there is a compatible, widely
> available implementation from a second vendor - this is an Intel
> driver and nothing more. It's not moving anywhere.

Even if second implementation arrives, it is unlikely that this
idpf driver will be moved. Mainly because of different level of
review between vendor driver vs. standard one, and expected pushback
to any incompatible changes in existing driver as it is already deployed.

Thanks

> 
> I think that's a reasonable position which should allow Intel to ship
> your code and me to remain professional.
> 
> [0] https://lore.kernel.org/all/20230403163025.5f40a87c@kernel.org/
