Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6447561A15E
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiKDTmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKDTmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:42:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FDA2185
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dX/V4h9OXmCrQJ1rvrQG9ZHT0Le/vDQLRwdF1WHr6T0=; b=pDcqmOypXiR/ELu4rwd5OdM+NH
        xJ6+fA2UU1ualKT9tRSHFK3CeP3w1GFcjyz4H3weMPEC21rh+9YCg1YCvzIsP6T1e0VmDuTvR0AdY
        YT84UjmWTPHu71J/KEeF0pPitlLQsfd7M3WvRiKNKpO4fbwlXMhWHYOyDpMTKlpSl5J0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1or2Ze-001Sij-BG; Fri, 04 Nov 2022 20:41:54 +0100
Date:   Fri, 4 Nov 2022 20:41:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next] ethtool: add netlink based get rxfh support
Message-ID: <Y2VrAh4hha0y95Lv@lunn.ch>
References: <20221103211419.2615321-1-sudheer.mogilappagari@intel.com>
 <Y2Q/gmS0v8i6SNi4@lunn.ch>
 <IA1PR11MB62668635AB345ADA118BA9BCE43B9@IA1PR11MB6266.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA1PR11MB62668635AB345ADA118BA9BCE43B9@IA1PR11MB6266.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Got a question wrt rtnl_lock usage. I see lock is acquired for SET
> operations and not for GET operations. Is rtnl_lock needed in this
> case due to slightly different flow than rest of GET ops?

The ioctl path takes the lock, so i don't see why the netlink code
should not take the lock.

       Andrew
