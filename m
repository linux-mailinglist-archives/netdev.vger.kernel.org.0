Return-Path: <netdev+bounces-3412-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22ED7706EF8
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:03:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9FFE1C21002
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF26424EA0;
	Wed, 17 May 2023 17:03:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0996442F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 17:03:42 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D989E;
	Wed, 17 May 2023 10:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684343021; x=1715879021;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=2y9dc4fvVXmSayb63VV0cFv6otKKoZXMYMxw98nbiUY=;
  b=kRcCOgBggZt0gF/jc+KW4oVF1X8CHd4VGfx3lWlIry/tdwVU8QS/zubG
   xe0NQamEfwys21whCOa/0Qc3+3/TlThDBOoEixu2sjuhLRfisygi2U0Qj
   KATSMUNpuTMJtvFlraIFdbbEN+YtVp4kg9kBxskU0+Nknp9FUWg1tqeTD
   /Dy7tCw4fzxFq9Oey4h2ippE57VfKzI8DvXoK+2HSSLOcAQBYv5Vcx8fs
   YkcV0hdQdmaIzyu/2Jy5/4EWYJdgApN8RCZ2dc30mYa/XcJMpfI7fbOjv
   zxuaFLH2WY0lTYl0/FCWjdBs3ub7IFe0vUri4fykpr9pksi8HI70Cftpr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="351840399"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="351840399"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 10:03:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="813944402"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="813944402"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002.fm.intel.com with ESMTP; 17 May 2023 10:03:31 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1pzKYi-0008V6-2X;
	Wed, 17 May 2023 20:03:28 +0300
Date: Wed, 17 May 2023 20:03:28 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>
Cc: Matti Vaittinen <mazziesaccount@gmail.com>,
	Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
	Daniel Scally <djrscally@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Michael Hennerich <Michael.Hennerich@analog.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Andreas Klinger <ak@it-klinger.de>, Marcin Wojtas <mw@semihalf.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Paul Cercueil <paul@crapouillou.net>, Wolfram Sang <wsa@kernel.org>,
	Akhil R <akhilrajeev@nvidia.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
	netdev@vger.kernel.org, openbmc@lists.ozlabs.org,
	linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH v4 4/7] pinctrl: wpcm450: elax return value check for IRQ
 get
Message-ID: <ZGUI4J27h69ed005@smile.fi.intel.com>
References: <cover.1684220962.git.mazziesaccount@gmail.com>
 <2d89de999a1d142efbd5eb10ff31cca12309e66d.1684220962.git.mazziesaccount@gmail.com>
 <ZGOwCSPH68DJN/NC@probook>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZGOwCSPH68DJN/NC@probook>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 06:32:09PM +0200, Jonathan Neuschäfer wrote:
> On Tue, May 16, 2023 at 10:13:14AM +0300, Matti Vaittinen wrote:

> > The special handling in this driver was added when fixing a problem
> > where returning zero from fwnode_irq_get[_byname]() was treated as
> > succes yielding zero being used as a valid IRQ by the driver.
> > f4a31facfa80 ("pinctrl: wpcm450: Correct the fwnode_irq_get() return value check")
> > The commit message does not mention if choosing not to abort the probe
> > on device-tree mapping failure (as is done on other errors) was chosen
> > because: a) Abort would have broken some existing setup. b) Because skipping
> > an IRQ on failure is "the right thing to do", or c) because it sounded like
> > a way to minimize risk of breaking something.
> > 
> > If the reason is a) - then I'd appreciate receiving some more
> > information and a suggestion how to proceed (if possible). If the reason
> > is b), then it might be best to just skip the IRQ instead of aborting
> > the probe for all errors on IRQ getting. Finally, in case of c), well,
> > by acking this change you will now accept the risk :)

From my side it was c).

> > The first patch of the series changes the fwnode_irq_get() so this depends
> > on the first patch of the series and should not be applied alone.
> 
> Thanks for investigating this!
> 
> It's not a), because there are no existing setups that rely on broken
> IRQs connected to this pinctrl/GPIO controller.
> 
> I suspect b) or c), but I'll let Andy give a more definite answer.


-- 
With Best Regards,
Andy Shevchenko



