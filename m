Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EEA49C7C1
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240133AbiAZKn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:43:59 -0500
Received: from mga18.intel.com ([134.134.136.126]:8052 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232745AbiAZKnw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 05:43:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643193832; x=1674729832;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Vtg1dgMFp7p9GgxTmw0mrktziInoebLsnCNjJeItTWc=;
  b=iIdSmBlgfe6azUNDmzVOK3xp8rEb15h6JBAwVSfR4fxuSdZU9T0NXNqE
   An5UpTaqMRTz15Ls8Q7kQXzvlaVJB5/dFIKrgZ1/ldLj1XsAVuAVZVS47
   xkjcUaJGTbOSrBdYAgh23Sppu3svjph/TsU2VQDZsjZVqnmslNLJLmHp4
   WVL1pxeCjm3Ql2RZV1n8LwzB+TUOEH71gA5YltAgBLmH6m8fD8UQH3WWN
   Jp9YId36ELAdrJydcrgx1PRIhBfwcnU0Vgb0sz1CWlVS69f2Z40TBT4Hn
   GSPrP+UCzS6rwUItRg/+/ryksE0KS6fY/Jcri3DdeIBQBhZ4AmHrrPaHt
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="230098001"
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="230098001"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 02:43:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="624796941"
Received: from richardt-mobl1.amr.corp.intel.com (HELO ldmartin-desk2) ([10.212.143.219])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 02:43:48 -0800
Date:   Wed, 26 Jan 2022 02:43:45 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Emma Anholt <emma@anholt.net>, David Airlie <airlied@linux.ie>,
        nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        amd-gfx@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leo Li <sunpeng.li@amd.com>, intel-gfx@lists.freedesktop.org,
        Raju Rangoju <rajur@chelsio.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-gfx] [PATCH v2 09/11] drm: Convert open-coded yes/no
 strings to yesno()
Message-ID: <20220126104345.r6libof7z7tqjqxi@ldmartin-desk2>
X-Patchwork-Hint: comment
References: <20220126093951.1470898-1-lucas.demarchi@intel.com>
 <20220126093951.1470898-10-lucas.demarchi@intel.com>
 <CAHp75Vd+TmShx==d_JHZUu0Q-9X7CmZEOFdKnSrcRKs81Gxn3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHp75Vd+TmShx==d_JHZUu0Q-9X7CmZEOFdKnSrcRKs81Gxn3g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 12:12:50PM +0200, Andy Shevchenko wrote:
>On Wed, Jan 26, 2022 at 11:39 AM Lucas De Marchi
><lucas.demarchi@intel.com> wrote:
>>
>> linux/string_helpers.h provides a helper to return "yes"/"no" strings.
>> Replace the open coded versions with str_yes_no(). The places were

oops, I replaced yesno() here but forgot to do so in the title

>> identified with the following semantic patch:
>>
>>         @@
>>         expression b;
>>         @@
>>
>>         - b ? "yes" : "no"
>>         + str_yes_no(b)
>>
>> Then the includes were added, so we include-what-we-use, and parenthesis
>> adjusted in drivers/gpu/drm/v3d/v3d_debugfs.c. After the conversion we
>> still see the same binary sizes:
>>
>>    text    data     bss     dec     hex filename
>>   51149    3295     212   54656    d580 virtio/virtio-gpu.ko.old
>>   51149    3295     212   54656    d580 virtio/virtio-gpu.ko
>> 1441491   60340     800 1502631  16eda7 radeon/radeon.ko.old
>> 1441491   60340     800 1502631  16eda7 radeon/radeon.ko
>> 6125369  328538   34000 6487907  62ff63 amd/amdgpu/amdgpu.ko.old
>> 6125369  328538   34000 6487907  62ff63 amd/amdgpu/amdgpu.ko
>>  411986   10490    6176  428652   68a6c drm.ko.old
>>  411986   10490    6176  428652   68a6c drm.ko
>>   98129    1636     264  100029   186bd dp/drm_dp_helper.ko.old
>>   98129    1636     264  100029   186bd dp/drm_dp_helper.ko
>> 1973432  109640    2352 2085424  1fd230 nouveau/nouveau.ko.old
>> 1973432  109640    2352 2085424  1fd230 nouveau/nouveau.ko
>
>This probably won't change for modules, but if you compile in the
>linker may try to optimize it. Would be nice to see the old-new for
>`make allyesconfig` or equivalent.

just like it would already do, no? I can try and see what happens, but
my feeling is that we won't have any change.

>
>...
>
>>         seq_printf(m, "\tDP branch device present: %s\n",
>> -                  branch_device ? "yes" : "no");
>> +                  str_yes_no(branch_device));
>
>Can it be now on one line? Same Q for all similar cases in the entire series.

I saw that question in the previous version. I think those are very
subjective is they all go a little bit over 80 chars. Some maintainers
may prefer one way or the other.

Here we are reducing just 3 chars so I assumed that is the preferred
style here.  Also keeping it as is helps with the mass conversion since
it's easily repeatable if another iteration is needed.

thanks
Lucas De Marchi
