Return-Path: <netdev+bounces-3401-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF2F9706E7D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:48:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3E1C1C20AB9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A431EA65;
	Wed, 17 May 2023 16:47:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A356111B5
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:47:57 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CDE59DC;
	Wed, 17 May 2023 09:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684342076; x=1715878076;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3aGbiMN0V+5yc6Amt+Y7GgCQxqWtHVXzMieUoBpl1Y0=;
  b=NwujApARbS7z1+LSFfGoME6jThv38EVEpbFbdRsSmpRq/iKKAQs2HeIZ
   jJlEWubv7r4iGiwuTLAoRvQDvWLxJqRj7o/J9WXzngQy4EoBJsBFjI9fP
   rjdNxavDWXW5CtSU2AU4CXvE46E1VGSbPUVKcaIhu2AllfO55IQEvDp/c
   klRU9gK1V50fBPsHNXAkzXK9LcKuGS9MjHnNCNR+7Wku7Z6T6iqyuvMCF
   kWe+DgG5JMjPI14pnwIsQ3G4My6eP10PKejM0RsYy3mD463l6zeQWwYre
   5r1AdcPFAxjCiiWSiu3Qu9/g1ujYOThj1fqnHQWKXQuQni50baQfZV707
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="351834340"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="351834340"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 09:47:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="948338934"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="948338934"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP; 17 May 2023 09:47:38 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1pzKJL-0008UB-36;
	Wed, 17 May 2023 19:47:35 +0300
Date: Wed, 17 May 2023 19:47:35 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
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
	Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Paul Cercueil <paul@crapouillou.net>, Wolfram Sang <wsa@kernel.org>,
	Akhil R <akhilrajeev@nvidia.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
	netdev@vger.kernel.org, openbmc@lists.ozlabs.org,
	linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH v4 2/7] iio: mb1232: relax return value check for IRQ get
Message-ID: <ZGUFJ5LRCzW2V0a1@smile.fi.intel.com>
References: <cover.1684220962.git.mazziesaccount@gmail.com>
 <429804dac3b1ea55dd233d1e2fdf94240e2f2b93.1684220962.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <429804dac3b1ea55dd233d1e2fdf94240e2f2b93.1684220962.git.mazziesaccount@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 10:12:41AM +0300, Matti Vaittinen wrote:
> fwnode_irq_get() was changed to not return 0 anymore.
> 
> Drop check for return value 0.

...

> -	if (data->irqnr <= 0) {
> +	if (data->irqnr < 0) {
>  		/* usage of interrupt is optional */
>  		data->irqnr = -1;
>  	} else {


After this change I'm not sure we need this branch at all, I mean that -errn is
equal to -1 in the code (but needs to be checked for silly checks like == -1).

Hence

Entire excerpt can be replaced with

	if (data->irqnr > 0) {

-- 
With Best Regards,
Andy Shevchenko



