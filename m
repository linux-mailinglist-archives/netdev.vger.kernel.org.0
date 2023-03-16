Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2268E6BC85E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjCPILn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjCPILl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:11:41 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45ADDB32AE;
        Thu, 16 Mar 2023 01:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678954294; x=1710490294;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UnhAQcLSLLvahXWQtCKusDvdHbGvBLPZzpcwE/TiQZI=;
  b=TpPiv4Na5+p89vTJwr01OyzR+gB9fR5ggFV+DYRzrwdSjTR0OdQzT4fG
   5+5N9co3/Bw6IQ5TC5J4ld9ZNIKkGr/kdMZkCsHoca8frRvg78Qx/THuL
   2eYewaIk1nhFjdc5jv29UXOTuqDsDAkPA/KxciDep/UivvNFkASmB6gEv
   bhx9Jw6jP9f4MlUEHMOKrqZ8EoTkd0WBdZrz+2PUHntqtzf7F1WSCqON8
   EwyaMm/jyZ1tA/WfN+Vgt9CItGJVWZjqszC4zD2VD5AvrQE7YBq6hVtzy
   wFXIlVtyp9gEB92nZmX1xvnjTCRmT+CY2DWVZTSKIUGEZzV+krGyTJnca
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="337938968"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="337938968"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 01:11:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="673051764"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="673051764"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 01:11:31 -0700
Date:   Thu, 16 Mar 2023 09:11:23 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <ZBLPK0loejiHEoe5@localhost.localdomain>
References: <20230314181824.56881-1-andriy.shevchenko@linux.intel.com>
 <ZBFeUazA9X9mmWiJ@localhost.localdomain>
 <ZBHFOlwoLYn3xz2L@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBHFOlwoLYn3xz2L@smile.fi.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 03:16:42PM +0200, Andy Shevchenko wrote:
> On Wed, Mar 15, 2023 at 06:57:37AM +0100, Michal Swiatkowski wrote:
> > On Tue, Mar 14, 2023 at 08:18:24PM +0200, Andy Shevchenko wrote:
> > > LED core provides a helper to parse default state from firmware node.
> > > Use it instead of custom implementation.
> 
> ...
> 
> > You have to fix implict declaration of the led_init_default_state_get().
> 
> Seems like users have to choose between 'select NEW_LEDS' and
> 'depends on NEW_LEDS' in the Kconfig.
> 
> > I wonder if the code duplication here can be avoided:
> 
> Whether or not this is out of the scope of this patch.
> Feel free to submit one :-)
> 
> ...
>

Reasonable ;)
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

> > Only suggestion, patch looks good.
> 
> Thank you!
> 
> -- 
> With Best Regards,
> Andy Shevchenko
> 
> 
