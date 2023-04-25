Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83026EE8C3
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 22:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbjDYUBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 16:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235264AbjDYUBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 16:01:25 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EE68A5F;
        Tue, 25 Apr 2023 13:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682452882; x=1713988882;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=S9HTOBEJkSIz8FjeW33+XABgFARQXXVWDKz7IsLj3Wc=;
  b=dscwBrD87kUfNzu4eJ8DAgxrF5Ez5d+xJNSdjwxsVQQbv4QyetvM5aXI
   KYiiU89dTXBtJSzr10KdRhkLaWGT6l4CRHx7IL7l8RaUaptwbRHdcSKNy
   w7R+HDv8ugP/IrM89a7SYucfDblKAjNJqMUPp//4Sf5LjG2OkvUt12UMo
   MCyXiAolJ1OAeHySDwrrKyP9xFXcM09DK+jKFXe8p4v5pw2RzJoBperYf
   S2BKGuabwGGEAT2fD3OSjhC+7XE2PuJgTDNm1OQk6bEWdaH/QR6ZiOnFF
   opbwpzbsfENVB7FyFl2JvuDwtUDLwqoZ1aTrbBt2duUgnd0R8dlXfz2R4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="345644817"
X-IronPort-AV: E=Sophos;i="5.99,226,1677571200"; 
   d="scan'208";a="345644817"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 13:01:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="868009718"
X-IronPort-AV: E=Sophos;i="5.99,226,1677571200"; 
   d="scan'208";a="868009718"
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO intel.com) ([10.252.59.107])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 13:01:17 -0700
Date:   Tue, 25 Apr 2023 22:01:15 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andi Shyti <andi.shyti@linux.intel.com>
Subject: Re: [PATCH v8 0/7] drm/i915: use ref_tracker library for tracking
 wakerefs
Message-ID: <ZEgxi3+eaG5Xf6bl@ashyti-mobl2.lan>
References: <20230224-track_gt-v8-0-4b6517e61be6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-track_gt-v8-0-4b6517e61be6@intel.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Andrzej Hajda (7):
>       lib/ref_tracker: add unlocked leak print helper
>       lib/ref_tracker: improve printing stats
>       lib/ref_tracker: add printing to memory buffer
>       lib/ref_tracker: remove warnings in case of allocation failure
>       drm/i915: Correct type of wakeref variable
>       drm/i915: Replace custom intel runtime_pm tracker with ref_tracker library
>       drm/i915: Track gt pm wakerefs

where are we going to get this series merged? Should we merge it
in our intel repository? In the netdev repository? or do we split
it (which will cause some dependency delay)?

Andi
