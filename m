Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B454493787
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 10:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352877AbiASJmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 04:42:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:32092 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235918AbiASJmv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 04:42:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642585371; x=1674121371;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LxWQZjhb/fNbEShE73X5g5DvnhYQLiQO3Stdcf1bZhA=;
  b=PZlBTFIUoLS1PtpsQP14JHhklMx4Yedi4yLPuigaWjdeYYI7HZ+SBw2I
   u1TuGl2uW0oYWknBTM3AgwQlVaHhYnJFnzKj4vjzBxLnJFQkaLssOZ2gi
   cRDQgBA7fANq0KGW2EFVFHhxN4EQ1bucK4DhhAFh51DdAGepl8+c1YUa8
   eoTB134DoOAFtd+yPhtejGZr597DosZnJv3qXRpvHsJa9RT0Bknf/xKwF
   yewkX/4LBf4eTjyvEeEuCn1J0ceRI55UCG47VqTDbc3i7mR9kIJjpAIVG
   RKS+tteXGKAcpEtm6r6MfXv9HRk3RjkhpsxSXTdbzaUKAotCnf8vxk0C+
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="269418425"
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="269418425"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 01:42:50 -0800
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="532207547"
Received: from atefehad-mobl1.amr.corp.intel.com (HELO ldmartin-desk2) ([10.212.238.132])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 01:42:49 -0800
Date:   Wed, 19 Jan 2022 01:42:49 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Emma Anholt <emma@anholt.net>, David Airlie <airlied@linux.ie>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Mikita Lipski <mikita.lipski@amd.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leo Li <sunpeng.li@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Raju Rangoju <rajur@chelsio.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/3] lib/string_helpers: Add helpers for
 enable[d]/disable[d]
Message-ID: <20220119094249.6g24562y2b4iwtvk@ldmartin-desk2>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <20220119072450.2890107-3-lucas.demarchi@intel.com>
 <CAHp75Vc4bdu1OTi2t-fHeHkmnVgd6LCdeotnGEH_+q4EGk3OmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHp75Vc4bdu1OTi2t-fHeHkmnVgd6LCdeotnGEH_+q4EGk3OmQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 11:20:38AM +0200, Andy Shevchenko wrote:
>On Wednesday, January 19, 2022, Lucas De Marchi <lucas.demarchi@intel.com>
>wrote:
>
>> Follow the yes/no logic and add helpers for enabled/disabled and
>> enable/disable - those are not so common throughout the kernel,
>> but they give a nice way to reuse the strings to log things as
>> enabled/disabled or enable/disable.
>>
>> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
>> ---
>>  drivers/gpu/drm/i915/i915_utils.h | 10 ----------
>>  include/linux/string_helpers.h    |  2 ++
>>  2 files changed, 2 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/i915_utils.h
>> b/drivers/gpu/drm/i915/i915_utils.h
>> index 2a8781cc648b..cbec79bae0d2 100644
>> --- a/drivers/gpu/drm/i915/i915_utils.h
>> +++ b/drivers/gpu/drm/i915/i915_utils.h
>> @@ -419,16 +419,6 @@ static inline const char *onoff(bool v)
>>         return v ? "on" : "off";
>>  }
>>
>> -static inline const char *enabledisable(bool v)
>> -{
>> -       return v ? "enable" : "disable";
>> -}
>> -
>> -static inline const char *enableddisabled(bool v)
>> -{
>> -       return v ? "enabled" : "disabled";
>> -}
>> -
>>  void add_taint_for_CI(struct drm_i915_private *i915, unsigned int taint);
>>  static inline void __add_taint_for_CI(unsigned int taint)
>>  {
>> diff --git a/include/linux/string_helpers.h b/include/linux/string_
>> helpers.h
>> index e980dec05d31..e4b82f364ee1 100644
>> --- a/include/linux/string_helpers.h
>> +++ b/include/linux/string_helpers.h
>> @@ -103,5 +103,7 @@ char *kstrdup_quotable_file(struct file *file, gfp_t
>> gfp);
>>  void kfree_strarray(char **array, size_t n);
>>
>>  static inline const char *yesno(bool v) { return v ? "yes" : "no"; }
>> +static inline const char *enabledisable(bool v) { return v ? "enable" :
>> "disable"; }
>> +static inline const char *enableddisabled(bool v) { return v ? "enabled"
>> : "disabled"; }
>
>
>Looks not readable even if takes 80 characters. Please, keep original style.
>
>
>I believe you wanted to have nice negative statistics from day 1, then you
>may add more patches in the series to cleanup more users.

not really the reason... it was just "this is small enough and
checkpatch doesn't complain" (it checks for 100 chars nowadays). But yes,
I can keep it in 4 lines.

thanks
Lucas De Marchi
