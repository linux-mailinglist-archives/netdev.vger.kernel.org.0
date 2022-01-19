Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A43F493713
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 10:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352980AbiASJTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 04:19:15 -0500
Received: from mga12.intel.com ([192.55.52.136]:61815 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352693AbiASJTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 04:19:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642583951; x=1674119951;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Zf7maaT407OcqJiMSYXoEAzMcLY861f8NYGTlKtPnGA=;
  b=YkalItov6WCXDDbUVKKK5aiMjxJxH7VjKeBum4WvbO6/eIILTB8TVBJw
   jRCxXXVexNuFXe7vS7MNJ6i/X4Yr+VXupmXNUNrECWFoZIzkBepGSqWw4
   yra6STdVm4jTib3jLzsdVfV7+Lrqx9pj3CQ8cR5EmMeagU4MlmkKoHH85
   5cqCu828qtI5h+4xugHrJy1z8tTYl4NE8N1FgJNRRB2GpXvaucEd6IDMH
   xoEjc5zSBaX34fbfXHRQmOWwjcQ/gvsOwidLRd5fdoDcVqTwyPqi1fw9Z
   FnwI4Ke+m92A92TKLrLxpYChlXf3f9lyFUIz6G/FF/LoqsfAt2B3teJxK
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="225001669"
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="225001669"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 01:19:11 -0800
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="622447667"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 01:19:01 -0800
Received: from paasikivi.fi.intel.com (localhost [127.0.0.1])
        by paasikivi.fi.intel.com (Postfix) with SMTP id CEBE0203C8;
        Wed, 19 Jan 2022 11:18:59 +0200 (EET)
Date:   Wed, 19 Jan 2022 11:18:59 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>, Eryk Brol <eryk.brol@amd.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [PATCH 1/3] lib/string_helpers: Consolidate yesno()
 implementation
Message-ID: <YefXg03hXtrdUj6y@paasikivi.fi.intel.com>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <20220119072450.2890107-2-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119072450.2890107-2-lucas.demarchi@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lucas,

On Tue, Jan 18, 2022 at 11:24:48PM -0800, Lucas De Marchi wrote:
> @@ -1354,8 +1345,7 @@ static bool tomoyo_print_condition(struct tomoyo_io_buffer *head,
>  	case 3:
>  		if (cond->grant_log != TOMOYO_GRANTLOG_AUTO)
>  			tomoyo_io_printf(head, " grant_log=%s",
> -					 tomoyo_yesno(cond->grant_log ==
> -						      TOMOYO_GRANTLOG_YES));
> +					 yesno(cond->grant_log == TOMOYO_GRANTLOG_YES));

This would be better split on two lines.

Then,

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
