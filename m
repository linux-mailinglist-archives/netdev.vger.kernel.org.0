Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0B5534BA0
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235643AbiEZIV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238490AbiEZIVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:21:24 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16F64B86D;
        Thu, 26 May 2022 01:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653553282; x=1685089282;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BqVs7J907I6LTrc6ve0PJwuw+PZZEbKVHaVhU84OcIw=;
  b=OEBDCs3mxSlrobsUJuM6TMvvpUZSTskcvDgkTY7EU7G2l3K3QJHhPYhn
   jt6oAHPrIK0iWVloHoaxW3RTuVEsWVPZiaArUZZRmL8ZYYi5gH1fcgE+J
   75gA3z6h34GDo0skqbUvfKLT357CggOjxfHO7vzS1j+jK6+IvQMCSVGxq
   nSIN+8LEDe0s+LKemQSOuQE3tkJWuaCj76rN41e6scks2XpCOR1jHPC4G
   fvj1dWGYJsYYc+m6F1f169uwoa3qfRzhGg7ftVLnpU/QH2UbmsIvQlnHC
   Yqp5S6Trh1Hl6mboahZXRXMhoXwxSz0nm6hIb/qfWRzhk6dEizIRlc5HV
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="254580227"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="254580227"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 01:21:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="664828782"
Received: from linux.intel.com ([10.54.29.200])
  by FMSMGA003.fm.intel.com with ESMTP; 26 May 2022 01:21:22 -0700
Received: from linux.intel.com (ssid-ilbpg3-teeminta.png.intel.com [10.88.227.74])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id E722E5807C9;
        Thu, 26 May 2022 01:21:18 -0700 (PDT)
Date:   Thu, 26 May 2022 16:18:39 +0800
From:   Tan Tee Min <tee.min.tan@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Sit Michael Wei Hong <michael.wei.hong.sit@intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: Re: [PATCH net-next 1/1] net: phy: dp83867: retrigger SGMII AN when
 link change
Message-ID: <20220526081839.GA26465@linux.intel.com>
References: <20220526013714.4119839-1-tee.min.tan@linux.intel.com>
 <20220525215629.69af5bf5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525215629.69af5bf5@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 09:56:29PM -0700, Jakub Kicinski wrote:
> On Thu, 26 May 2022 09:37:14 +0800 Tan Tee Min wrote:
> > As suggested by TI, implemented a SW solution here to retrigger SGMII
> > Auto-Neg whenever there is a link change.
> 
> Thanks, sounds like this bug has always been in the driver so we should
> add:
> 
> Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
> 
> Is that right? Getting a workaround like this into stable eventually
> seems like a good idea so Fixes tag will help.

Thanks for the quick response.

Yes, you are right.
Let me add the Fixes tag and Cc <stable@vger.kernel.org> in v2 patch.

Thanks,
Tee Min

