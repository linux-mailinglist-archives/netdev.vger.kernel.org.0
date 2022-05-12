Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F77524978
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 11:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352300AbiELJxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 05:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352294AbiELJxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 05:53:35 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E71B43EF5;
        Thu, 12 May 2022 02:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652349197; x=1683885197;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BeG6RZutTK0vUCQ8P65D/jslwJAi+xtToKFLn6ZnKqI=;
  b=BX9x903tUDrZoxgmt1bqPl/+nAww4cxkjsVSpF4DRa6l8GDhH9TM9+hL
   z4yxZRjrKiI5bGGXecDQMo3e8WdTYho2ZFBjXnxCl+u6/8hZqvKpdBP+1
   B7mVGUAdZ6tgdt8+QRCY0FFxny6iqRp/bsgbtxJxTP2AZA+hbcwpyIdId
   O/yDX/qnSaKaDIGoonamIUr+afCrvwbAhhN0zJVsCIB4gCFscuiJKbUdN
   2S9GFv5//7O9xM853UOzgCCafMgD29Nk/3VPxpVNCAexWyZPkIX3pW7xV
   gxCNxAa4QPw51mB61ZDhpJf/j6wDbM7URrmZLcMhTJRgJs8mrV50q/u9E
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="250478993"
X-IronPort-AV: E=Sophos;i="5.91,219,1647327600"; 
   d="scan'208";a="250478993"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 02:53:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,219,1647327600"; 
   d="scan'208";a="636785572"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 02:53:10 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1np5VK-00F9jS-8m;
        Thu, 12 May 2022 12:53:06 +0300
Date:   Thu, 12 May 2022 12:53:05 +0300
From:   "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
To:     Maninder Singh <maninder1.s@samsung.com>
Cc:     Kees Cook <keescook@chromium.org>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "avimalin@gmail.com" <avimalin@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vaneet Narang <v.narang@samsung.com>,
        Onkarnath <onkarnath.1@samsung.com>
Subject: Re: [PATCH 1/2] kallsyms: add kallsyms_show_value definition in all
 cases
Message-ID: <YnzZASsT2Cy7COax@smile.fi.intel.com>
References: <202205111525.92B1C597@keescook>
 <20220511080657.3996053-1-maninder1.s@samsung.com>
 <CGME20220511080722epcas5p459493d02ff662a7c75590e44a11e34a6@epcms5p3>
 <20220512034650epcms5p3c0b90af240d837491fff020497f389e5@epcms5p3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512034650epcms5p3c0b90af240d837491fff020497f389e5@epcms5p3>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 09:16:50AM +0530, Maninder Singh wrote:
> > On Wed, May 11, 2022 at 01:36:56PM +0530, Maninder Singh wrote:

...

> > This is printing raw kernel addresses with no hashing, as far as I can
> > tell. That's not okay at all.
> 
> yes same was suggested by Petr also, because earlier we were printing base address also as raw address.
> 
> https://lkml.org/lkml/2022/2/28/847
> 
> but then modified approach to print base address as hash when we are going to show offset of module address,
> but when we print complete address then we thought of keeping it same as it was:
> 
> original:
>  [12.487424] ps 0xffff800000eb008c
> with patch:
>  [9.624152] ps 0xffff800001bd008c [crash]
> 
> But if its has to be hashed, will fix that also.

In such case it should be a separate change since it will be the one that
changes behaviour.

-- 
With Best Regards,
Andy Shevchenko


