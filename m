Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0960A5A32D5
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 02:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbiH0AAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 20:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiH0AAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 20:00:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2087921E34;
        Fri, 26 Aug 2022 17:00:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADEEB61C11;
        Sat, 27 Aug 2022 00:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ADAC433C1;
        Sat, 27 Aug 2022 00:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661558407;
        bh=wD91XKnsSION4QMtASBE/ZLFLHF8lfvCcUZC1JU0mQI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CT+bRRC9DlT/Sj0fIpyhBWozvPtyiR8VgCSFsy3Ozq4FezUWd8+jcPLSzYCseLEDc
         4XFHhPhgcI/s+Jbqv4aWnS6isZ7DWXJ+EE6dgkBn4jEav/ctmpQUSdnhKZpKom8utF
         u8RnMUr7wK91oT23wh9eKo/b81D49Z5aICAPuH6as2d8EGq9HWqcV4Hg9HkOO6zRsM
         t2xJXJ89IKvVpH1wkebcSZ+UzDqOzfLRFqTbFf422P6+5BuyFnjRarjhu4qifWk0eD
         PfmVivOFhgWRY+5CwyVe7aCe0T8egMkExYox60sDb8bMxIRWW7QKrarMvNUgYtnF/B
         cazthxTym8z6A==
Date:   Fri, 26 Aug 2022 17:00:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Avi Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: taprio vs. wireless/mac80211
Message-ID: <20220826170005.79392041@kernel.org>
In-Reply-To: <87k06uk65f.fsf@intel.com>
References: <117aa7ded81af97c7440a9bfdcdf287de095c44f.camel@sipsolutions.net>
        <20220824191500.6f4e3fb7@kernel.org>
        <87k06uk65f.fsf@intel.com>
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

On Fri, 26 Aug 2022 15:10:36 -0700 Vinicius Costa Gomes wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> 
> > On Wed, 24 Aug 2022 23:50:18 +0200 Johannes Berg wrote:  
> >> Anyone have recommendations what we should do?  
> >
> > Likely lack of sleep or intelligence on my side but I could not grok
> > from the email what the stacking is, and what the goal is.
> >
> > Are you putting taprio inside mac80211, or leaving it at the netdev
> > layer but taking the fq/codel out?  
> 
> My read was that they want to do something with taprio with wireless
> devices and were hit by the current limitation that taprio only supports
> multiqueue interfaces.
> 
> The fq/codel part is that, as far as I know, there's already a fq/codel
> implementation inside mac80211.
> 
> The stacking seems to be that packets would be scheduled by taprio and
> then by the scheduler inside mac80211 (fq/codel based?).

Doesn't adding another layer of non-time-aware queuing after taprio
completely defeat its purpose?  Perhaps I'm revealing my lack of
understanding too much..

