Return-Path: <netdev+bounces-8015-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C21BB7226C7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BEE428105B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CA619522;
	Mon,  5 Jun 2023 13:03:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583966ABC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:03:49 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02639A1;
	Mon,  5 Jun 2023 06:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685970227; x=1717506227;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=/AZAh/+noxskjMMq20T8qv5enTajR+ICz0mHGFuOrKQ=;
  b=mIMzF24guSGdQt/hR272y/At9r2k8SMc3nOzg7BVgn0SqoNbvYVx111A
   37dKl8J38VzT/bd41yKlrdjcg/nKRic6tVeZsoP3kDbJvDFweLIQClc+2
   ptK0gMU/l5CcyTCVuQ2IvsLHSroXmjv91WnVQAqbCzkl09JHCd4HJbyvd
   pNjTTDY1UrOj4rTTXFvbw0wB7mUQ4H6Zgr3bFUwMHHwl1p045jdqa1zoi
   bbr5AeiFSVi66LMSWdfZs578SaIhFm+ibuPMvTSlSR4nRCCKJ6yBaovSB
   4q76AhXmIrHd9dnn1yfiUi5jal2BxqdnJRyNyrsv/A3OEodVxtVQxhTp5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="422186124"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="422186124"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 06:03:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="741715226"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="741715226"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP; 05 Jun 2023 06:03:26 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1q69ro-001NMp-0F;
	Mon, 05 Jun 2023 16:03:24 +0300
Date: Mon, 5 Jun 2023 16:03:23 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: 'Wolfram Sang' <wsa@kernel.org>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com, mika.westerberg@linux.intel.com,
	jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
	hkallweit1@gmail.com, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com,
	'Piotr Raczynski' <piotr.raczynski@intel.com>
Subject: Re: [PATCH net-next v11 2/9] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Message-ID: <ZH3dG5CJ3+W6fGNM@smile.fi.intel.com>
References: <20230605025211.743823-1-jiawenwu@trustnetic.com>
 <20230605025211.743823-3-jiawenwu@trustnetic.com>
 <ZH2IaM86ei2gQkfA@shikoro>
 <00c901d9977e$af0dc910$0d295b30$@trustnetic.com>
 <ZH2UT55SRNwN15t7@shikoro>
 <00eb01d99785$8059beb0$810d3c10$@trustnetic.com>
 <ZH2zb7smT/HbFx9k@shikoro>
 <ZH22jS7KPPBEVS2a@shell.armlinux.org.uk>
 <ZH3bwBZvjyIoFaVv@shikoro>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH3bwBZvjyIoFaVv@shikoro>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 02:57:36PM +0200, 'Wolfram Sang' wrote:
> 
> > Be careful... net-next uses patchwork, and I suspect as this is posted
> > as a series which the subject line states as being destined by the
> > author for the "net-next" tree, the entire series will end up being
> > slurped into the net-next tree.
> 
> Thanks for the pointer. Jiawen Wu, would you kindly send a v12 of the
> series (without the I2C patch)?

I'm wondering if it would be easier just mark it in patchwork as applied
elsewhere (don't remember exact variant, but meaning is the same).

-- 
With Best Regards,
Andy Shevchenko



