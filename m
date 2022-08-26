Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF1F5A31BC
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 00:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344817AbiHZWKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 18:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344648AbiHZWKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 18:10:38 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70A2E0956;
        Fri, 26 Aug 2022 15:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661551837; x=1693087837;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=77bYjHnZqD4KTvogCFUlYz4/Jg9L/LrFTQQWO+oEYk4=;
  b=g0vZlNHVB58Hm5PNsjbHCgwJ9UJaUSv9KWnUnjMQihIMtzhJbcvBdLhg
   px6xWxuobZri3RkHLUU6UqSTxhTJZ9r2SMoPw6y2GrzceC2uZxMNz2Ul6
   UwgVoIusBkoqEmF5FsisuccSt9a7/IR9RmjGZOcJ9lgXKXjZMsVP+li5v
   37FsfyDXjhWmQkBmMuT8PA1eWl3xL2Lynu9W+0w4kXGGw3W1ak9dtMvIa
   P5s04eBVno6Hgw/exGhMAdaaRznFXwqmSgbioW8Kqlu9zw7fDP804epLv
   MA8bpgnS1nFGXs+0y8hZSp2eaIMzzaaILktscam6L7gPxKqEa4YP6eZc7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10451"; a="292182751"
X-IronPort-AV: E=Sophos;i="5.93,266,1654585200"; 
   d="scan'208";a="292182751"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 15:10:37 -0700
X-IronPort-AV: E=Sophos;i="5.93,266,1654585200"; 
   d="scan'208";a="671632442"
Received: from mlahpai-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.18.227])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 15:10:36 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Avi Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: taprio vs. wireless/mac80211
In-Reply-To: <20220824191500.6f4e3fb7@kernel.org>
References: <117aa7ded81af97c7440a9bfdcdf287de095c44f.camel@sipsolutions.net>
 <20220824191500.6f4e3fb7@kernel.org>
Date:   Fri, 26 Aug 2022 15:10:36 -0700
Message-ID: <87k06uk65f.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 24 Aug 2022 23:50:18 +0200 Johannes Berg wrote:
>> Anyone have recommendations what we should do?
>
> Likely lack of sleep or intelligence on my side but I could not grok
> from the email what the stacking is, and what the goal is.
>
> Are you putting taprio inside mac80211, or leaving it at the netdev
> layer but taking the fq/codel out?

My read was that they want to do something with taprio with wireless
devices and were hit by the current limitation that taprio only supports
multiqueue interfaces.

The fq/codel part is that, as far as I know, there's already a fq/codel
implementation inside mac80211.

The stacking seems to be that packets would be scheduled by taprio and
then by the scheduler inside mac80211 (fq/codel based?).


Cheers,
-- 
Vinicius
