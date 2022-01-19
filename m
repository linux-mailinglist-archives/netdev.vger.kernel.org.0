Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21FC4941FF
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 21:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244868AbiASUoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 15:44:07 -0500
Received: from mga14.intel.com ([192.55.52.115]:26609 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357328AbiASUoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 15:44:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642625040; x=1674161040;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZnpQmdGf3petXh8fwqqd+ss75xCdI43Bzq3MlCXD9oc=;
  b=XdRQO/U+I/0kVdm3l1H4OAKhWqCu/h82dtNf/SUXrmspL5BMOhNekXtL
   s0g7kRh7sfP40ix27fMismSJGKSbZ19Fh2Dd9neBC0QcCdI43uh4ELcqo
   AsgfQNvQ6ALZUswFJfbfPNjOWQJ2xle6M5Gc1nJ1aAbhYjDqs3ACYo46A
   A6bkW1x/Db/Sy1C6v3V/0ctsSYYBtWea0f6pGh36OT30NdU2thn74/dPl
   +1HqAExbkGR8EBKOIM3BNLckpC4Dc7EBOmNMPV6boTUhiiy0fNHh85fNM
   GADXqU6nTEgA8n25XKFY6KdYGvFVTEJTQ+k5Y3mgX3/HF7EeNciiP4XCp
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="245386545"
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="245386545"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 12:43:57 -0800
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="518333103"
Received: from atefehad-mobl1.amr.corp.intel.com (HELO ldmartin-desk2) ([10.212.238.132])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 12:43:56 -0800
Date:   Wed, 19 Jan 2022 12:43:56 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Emma Anholt <emma@anholt.net>, David Airlie <airlied@linux.ie>,
        nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Mikita Lipski <mikita.lipski@amd.com>,
        amd-gfx@lists.freedesktop.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Petr Mladek <pmladek@suse.com>, Leo Li <sunpeng.li@amd.com>,
        intel-gfx@lists.freedesktop.org, Raju Rangoju <rajur@chelsio.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [Intel-gfx] [PATCH 1/3] lib/string_helpers: Consolidate yesno()
 implementation
Message-ID: <20220119204356.vizlstcs6wi6kn4b@ldmartin-desk2>
X-Patchwork-Hint: comment
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <20220119072450.2890107-2-lucas.demarchi@intel.com>
 <YefXg03hXtrdUj6y@paasikivi.fi.intel.com>
 <20220119100635.6c45372b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220119100635.6c45372b@gandalf.local.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 10:06:35AM -0500, Steven Rostedt wrote:
>On Wed, 19 Jan 2022 11:18:59 +0200
>Sakari Ailus <sakari.ailus@linux.intel.com> wrote:
>
>> On Tue, Jan 18, 2022 at 11:24:48PM -0800, Lucas De Marchi wrote:
>> > @@ -1354,8 +1345,7 @@ static bool tomoyo_print_condition(struct tomoyo_io_buffer *head,
>> >  	case 3:
>> >  		if (cond->grant_log != TOMOYO_GRANTLOG_AUTO)
>> >  			tomoyo_io_printf(head, " grant_log=%s",
>> > -					 tomoyo_yesno(cond->grant_log ==
>> > -						      TOMOYO_GRANTLOG_YES));
>> > +					 yesno(cond->grant_log == TOMOYO_GRANTLOG_YES));
>>
>> This would be better split on two lines.
>
>Really? Yuck!
>
>I thought the "max line size" guideline was going to grow to a 100, but I
>still see it as 80. But anyway...

Checking that: docs still say 80, but checkpatch was changed to warn
only on 100. Commit bdc48fa11e46 ("checkpatch/coding-style: deprecate
80-column warning") is clear why the discrepancy.

Lucas De Marchi

>
>	cond->grant_log ==
>	TOMOYO_GRANTLOG_YES
>
>is not readable at all. Not compared to
>
>	cond->grant_log == TOMOYO_GRANTLOG_YES
>
>I say keep it one line!
>
>Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
>
>-- Steve
>
>>
>> Then,
>>
>> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
