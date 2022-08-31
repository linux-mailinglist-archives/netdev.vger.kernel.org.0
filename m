Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6615A8478
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 19:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiHaRg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 13:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiHaRg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 13:36:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9A9A7A8C
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 10:36:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7875B82012
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 17:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D85C433C1;
        Wed, 31 Aug 2022 17:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661967385;
        bh=FrgFPh2mtHP6lk0aqaXsjmV+IL/Joe78oCvoyQHUv4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u7vdni7RO/m6xJYU6HhD/SSOnptpW+qkGZ/JmnQBbxOmegUaez1YUjYHDPt2D4df+
         lcmiqeZKytj5PXF3UcZw8pahV26yLfWxe9CzhrQevmwd9+bObbvUAhmfMWaC+PFVhg
         owIOXvKu8N6whlHHRr0kujYjrWiixez0g74x0Oftx9eCL++ucKXieQEQ8ihdnLSvAF
         LuAiNr0vVFBDQx02GI7n1vVUBk65+9s2arzO9WhWHpUI0Bz7PG09nPFQCuHNsCAqoP
         oCmwB50Lj0PHFYm332zf6bniKdn/9yawJAFm8ZFt3JVKH33gTmRnXARlw8bVc4n+Hs
         OizRyKoqmOV5A==
Date:   Wed, 31 Aug 2022 10:36:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Message-ID: <20220831103624.4ce0207b@kernel.org>
In-Reply-To: <923e103e-b770-163b-f8b6-ff57305f8811@nvidia.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
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
        <20220830144451.64fb8ea8@kernel.org>
        <923e103e-b770-163b-f8b6-ff57305f8811@nvidia.com>
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

On Wed, 31 Aug 2022 14:01:10 +0300 Gal Pressman wrote:
> When autoneg is disabled (and auto fec enabled), the firmware chooses
> one of the supported modes according to the spec. 

Would you be able to provide the pointer in the spec / section which
defines the behavior?  It may be helpful to add that to the kdoc for 
ETHTOOL_FEC_AUTO_BIT.
