Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE12B54C431
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 11:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbiFOJEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 05:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347194AbiFOJEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 05:04:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA803B3E8
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 02:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655283872; x=1686819872;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K8YX8OdRj+8OR4poJWfcY99qX1iy0FcXQYXuuP4U29k=;
  b=I5zswpaDv5uiMD9K87x/qq4vLEEbcM8SZG2wp+7rAX80rMrml+biJk9D
   CmbUdSNmdTCv1L0LXa1cK7GLyUtw9NLO8ZIHIoUkyKuj8hpuazchF9vm1
   Me0+M95GbCzB/3ZbjIJ7KUmeLrhWSfJA5zZblhcXYWrxlfP59Js+SRjw1
   HLyHOej16Rbzno5J/PlNTOwnCu7d/f5VuVEQe5l0HJY6Gr4VQ3/Xd8kBT
   680qMqhg+N7LhJ+rKnSn5UYEbvy+EkJKSLffpEL7TCqvarw60yo8iw59d
   KVKijUQpC8jCdswlAwdoYKff0U7yhw/rYOK/pCuTgY4mZYznpRXY26t3f
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="259351024"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="259351024"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 02:04:31 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="652544013"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 02:04:27 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o1Ouj-000dFq-Ob;
        Wed, 15 Jun 2022 12:02:13 +0300
Date:   Wed, 15 Jun 2022 12:02:13 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Moises Veleta <moises.veleta@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        ricardo.martinez@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS port
Message-ID: <YqmgFcwVSucDGgZ6@smile.fi.intel.com>
References: <20220614205756.6792-1-moises.veleta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614205756.6792-1-moises.veleta@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 01:57:56PM -0700, Moises Veleta wrote:
> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
> communicate with AP and Modem processors respectively. So far only
> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
> port which requires such channel.

This doesn't explain the sAP -> AP renaming in a several cases.
If that renaming is needed, it perhaps requires a separate patch or
at least a good paragraph to explain why.

-- 
With Best Regards,
Andy Shevchenko


