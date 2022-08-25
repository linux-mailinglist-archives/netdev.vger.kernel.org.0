Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A3B5A1A5D
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243668AbiHYUe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiHYUe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:34:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29071AA4D2
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 13:34:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB1786198D
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 20:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030ECC433C1;
        Thu, 25 Aug 2022 20:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661459666;
        bh=+F5Tka+4QUVu02FX9Sc/n6Hv7FQixpX/jPi937YF7KQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CtPRmAYV2mLrdWlO3AtUu5oF1xXoRoWkawBn/RhdisSIiSwpAIETQf2xDQdyTtes8
         ALWIxKWC27it7UQ7tthbh/gfNTr8vwz5NQOz/ZAY4Qt0D3KK+myb18oPHfmg5J4Csc
         H/Y3BUE8VRF3k3QfP5E5wbgyKDYbEjQSUDWp8OX8s75MSfznP0hy/7dWPBdalTy3oW
         +1tHmEAxMJQGBgiKiMhe4iATQCuwj58Ims8T/lrY0TFVdiHOgN9+zQWUEZdvlYVk9x
         vsqeVRAOAGy5aE01kotwZ4nu3qCRjsXAio2LcZENVvSb+Mf/+Mpc5PtuVCs43fA6uG
         rMs6sQYu43BCw==
Date:   Thu, 25 Aug 2022 13:34:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Gal Pressman <gal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Message-ID: <20220825133425.7bfb34e9@kernel.org>
In-Reply-To: <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
        <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
        <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
        <20220825092957.26171986@kernel.org>
        <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20220825103027.53fed750@kernel.org>
        <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
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

On Thu, 25 Aug 2022 17:51:01 +0000 Keller, Jacob E wrote:
> > Update your FW seems like a reasonable thing to ask customers to do.
> > Are there cables already qualified for the old FW which would switch
> > to No FEC under new rules?  
> 
> Not sure I follow what you're asking here.

IIRC your NICs only work with qualified cables. I was asking if any of
the qualified cables would actually negotiate to No FEC under new rules.
Maybe such cables are very rare and there's no need to be super careful?

> > Can you share how your FW picks the mode exactly?
> 
> I'm not entirely sure how it selects, other than it selects from the
> table of supported modes. It uses some state machine to go through
> options until a suitable link is made, but the details of how exactly
> it does this I'm not quite sure.

State machine? So you're trying different FEC modes or reading module
data and picking one?

Various NICs do either or both, but I believe AUTO means the former.

> The old firmware never picks "No FEC" for some media types, because
> the standard was that those types would always require FEC of some
> kind (R or RS). However in practice the modules can work with no FEC
> anyways, and according to customer reports enabling this has helped
> with linking issues. That's the sum of my understanding thus far.

Well, according to the IEEE standard there sure are cables which don't
need FEC. Maybe your customers had problems linking up because switch
had a different selection algo?

> I would prefer this option of just "auto means also possibly
> disable", but I wasn't sure how other devices worked and we had some
> concerns about the change in behavior. Going with this option would
> significantly simplify things since I could bury the "set the auto
> disable flag if necessary" into a lower level of the code and only
> expose a single ICE_FEC_AUTO instead of ICE_FEC_AUTO_DIS...
> 
> Thus, I'm happy to respin this, as the new behavior when supported by
> firmware if we have some consensus there.

Hard to get consensus if we still don't know what the FW does...
But if there's no new uAPI, just always enabling OFF with AUTO
then I guess I'd have nothing to complain about as I don't know
what other drivers do either.

> I am happy to drop or
> respin the extack changes if you think thats still valuable as well
> in the event we need to extend that API in the future.

Your call. May be useful to do it sooner rather than later, but 
we should find at least one use for the extack as a justification.

> > There must be _some_ standardization here, because we're talking
> > about <5m cables, so we can safely assume it's linking to a ToR
> > switch.  
> 
> I believe so.
