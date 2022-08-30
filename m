Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0C35A6F66
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 23:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbiH3Vp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 17:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbiH3VpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 17:45:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E694A1BF
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 14:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1336FB81E1E
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 21:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E326C433D6;
        Tue, 30 Aug 2022 21:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661895892;
        bh=TlCu5H0Q3mFWJMJGwAo8vmUKF47doBTo0SZgHdP5hHs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S558ScDQQFvT+C8bPnSEdwQetw9ELVd/83Bt6QInSIR6ndElmLiOsIxGIJdQmYrBz
         t8zM/bX7jKbhStIDF6gxZPBiHmySjiQy91EgYs8XzreO5bES8COs95KDZENcQsluF9
         S8SytwPgQkfsUdk6UNxHVAhvF92H7BLN6eUnye9jvkb3ahbgoNZ/XlC3RxXczqKJtS
         0TpWicKjC2kmuWWTJn2ZxjKZLMBN6HquVzVvDoHCu9QfGuMX0CFdB10o5u7eRTiuFg
         CObeOdBUxN3UeegabfL/TjAXkNThzIo0GzkzbAumQp6nasiRKfJa3SqVfosS3W74Yb
         HnAB4MFAAmOOA==
Date:   Tue, 30 Aug 2022 14:44:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Gal Pressman <gal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Message-ID: <20220830144451.64fb8ea8@kernel.org>
In-Reply-To: <26384052-86fa-dc29-51d8-f154a0a71561@intel.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
        <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
        <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
        <20220825092957.26171986@kernel.org>
        <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20220825103027.53fed750@kernel.org>
        <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20220825133425.7bfb34e9@kernel.org>
        <bcdfe60a-0eb7-b1cf-15c8-5be7740716a1@intel.com>
        <20220825180107.38915c09@kernel.org>
        <9d962e38-1aa9-d0ed-261e-eb77c82b186b@intel.com>
        <20220826165711.015e7827@kernel.org>
        <b1c03626-1df1-e4e5-815e-f35c6346cbed@nvidia.com>
        <SA2PR11MB51005070A0E456D7DD169A1FD6769@SA2PR11MB5100.namprd11.prod.outlook.com>
        <b20f0964-42b7-53af-fe24-540d6cd011de@nvidia.com>
        <3f72e038-016d-8b1c-a215-243199bac033@intel.com>
        <26384052-86fa-dc29-51d8-f154a0a71561@intel.com>
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

On Tue, 30 Aug 2022 13:09:20 -0700 Jacob Keller wrote:
> I'm trying to figure out what my next steps are here.
> 
> Jakub, from earlier discussion it sounded like you are ok with accepting
> patch to include "No FEC" into our auto override behavior, with no uAPI
> changes. Is that still ok given the recent dicussion regarding going
> beyond the spec?

Yes, I reserve the right to change my mind :) but AFAIU it doesn't make
things worse, so fine by me.

> I'm also happy to rename the flag in ice so that its not misnamed and
> clearly indicates its behavior.

Which flag? A new ethtool priv flag?

> Gal seems against extending uAPI to indicate or support "ignore spec".
> To be properly correct that would mean changing ice to stop setting the
> AUTO_FEC flag. As explained above, I believe this will lead to breakage
> in situations where we used to link and function properly.

Stop setting the AUTO_FEC flag or start using a new standard compliant
AUTO flag?

Gal, within the spec do you iterate over modes or pick one mode somehow
(the spec gives a set, AFAICT)?

> I have no way to verify whether other vendors actually follow this or
> not, as it essentially requires checking with modules that wouldn't link
> otherwise and likely requires a lot of trial and error.

Getting some input from Broadcom or Netronome would be useful, yes :(
