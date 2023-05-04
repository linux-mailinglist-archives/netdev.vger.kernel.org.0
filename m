Return-Path: <netdev+bounces-310-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 319996F6FEB
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:28:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4228E1C211B1
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 16:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60EDAA950;
	Thu,  4 May 2023 16:28:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B438FC1E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 16:28:03 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA121984;
	Thu,  4 May 2023 09:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683217679; x=1714753679;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1sTADYOJrst5j4wwARlRyTxp7aO5yP5bD/ZgZvBSTsI=;
  b=AqwFbVVjmntqR5DaRQDJKLpom/N424p4fABa/ZSNDRV7Qkd1EAq8m5WS
   RCO3ugWsXLaoNfOWa5fkAvuwuxCGw0Dx2nwT1nRuXuvo5okSkKLwflstC
   5q3EgjNmX5h0kJlZo45kpZLkS1nslBPZlNQ5gw0Ior2E6aiouE7wqjrze
   /nnf5g1f+E2oWn/ShgjM7r0j17gljzpcS4VsHPzyUrURdKY/ROmCOFW40
   vVgH0Zr08aCfzFGgjmyrg9foQiyxy5xjlCS9d8TUkGAZjiyMWJ7OuPzIu
   Pf7ohjsazufJBxCHVS2xwfYtWz8eh1Cf5EIsD6P4GCRm1Q0oxF8IUlcrk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="346457925"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="346457925"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 09:27:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="1027019412"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="1027019412"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.22.139]) ([10.213.22.139])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 09:27:55 -0700
Message-ID: <55aa19b3-58d4-02ae-efd1-c3f3d0f21ce6@intel.com>
Date: Thu, 4 May 2023 18:27:53 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [Intel-gfx] [PATCH v8 0/7] drm/i915: use ref_tracker library for
 tracking wakerefs
Content-Language: en-US
To: Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
 David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
 Eric Dumazet <edumazet@google.com>, "David S . Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Chris Wilson <chris@chris-wilson.co.uk>, Jakub Kicinski <kuba@kernel.org>,
 Dmitry Vyukov <dvyukov@google.com>
References: <20230224-track_gt-v8-0-4b6517e61be6@intel.com>
From: Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20230224-track_gt-v8-0-4b6517e61be6@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi maintainers of net and i915,

On 25.04.2023 00:05, Andrzej Hajda wrote:
> This is revived patchset improving ref_tracker library and converting
> i915 internal tracker to ref_tracker.
> The old thread ended without consensus about small kernel allocations,
> which are performed under spinlock.
> I have tried to solve the problem by splitting the calls, but it results
> in complicated API, so I went back to original solution.
> If there are better solutions I am glad to discuss them.
> Meanwhile I send original patchset with addressed remaining comments.
> 
> To: Jani Nikula <jani.nikula@linux.intel.com>
> To: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> To: Rodrigo Vivi <rodrigo.vivi@intel.com>
> To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> To: David Airlie <airlied@gmail.com>
> To: Daniel Vetter <daniel@ffwll.ch>
> To: Eric Dumazet <edumazet@google.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: intel-gfx@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: netdev@vger.kernel.org
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: Das, Nirmoy <nirmoy.das@linux.intel.com>
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
> 
> ---
> Changes in v8:
> - addressed comments from Eric, Zhou and CI, thanks,
> - added ref_tracker_dir_init name argument to all callers in one patch
> - moved intel_wakeref_tracker_show to *.c
> - s/intel_wakeref_tracker_show/intel_ref_tracker_show/
> - removed 'default n' from Kconfig
> - changed strlcpy to strscpy,
> - removed assignement from if condition,
> - removed long lines from patch description
> - added tags
> - Link to v7: https://lore.kernel.org/r/20230224-track_gt-v7-0-11f08358c1ec@intel.com
> 
> Changes in v7:
> - removed 8th patch (hold wakeref), as it was already merged
> - added tags (thx Andi)
> - Link to v6: https://lore.kernel.org/r/20230224-track_gt-v6-0-0dc8601fd02f@intel.com
> 
> Changes in v6:
> - rebased to solve minor conflict and allow CI testing
> - Link to v5: https://lore.kernel.org/r/20230224-track_gt-v5-0-77be86f2c872@intel.com
> 
> Changes in v5 (thx Andi for review):
> - use *_locked convention instead of __*,
> - improved commit messages,
> - re-worked i915 patches, squashed separation and conversion patches,
> - added tags,
> - Link to v4: https://lore.kernel.org/r/20230224-track_gt-v4-0-464e8ab4c9ab@intel.com
> 
> Changes in v4:
> - split "Separate wakeref tracking" to smaller parts
> - fixed typos,
> - Link to v1-v3: https://patchwork.freedesktop.org/series/100327/
> 
> ---
> Andrzej Hajda (7):
>        lib/ref_tracker: add unlocked leak print helper
>        lib/ref_tracker: improve printing stats
>        lib/ref_tracker: add printing to memory buffer
>        lib/ref_tracker: remove warnings in case of allocation failure
>        drm/i915: Correct type of wakeref variable
>        drm/i915: Replace custom intel runtime_pm tracker with ref_tracker library
>        drm/i915: Track gt pm wakerefs

Finally all patches are reviewed.
Question to network and i915 maintainers, how to merge this patchset:
1. Patches 1-4 belongs rather to network domain (especially patch 2).
2. Patches 5-7 are for i915.

What would be the best way to do it?

Regards
Andrzej



> 
>   drivers/gpu/drm/i915/Kconfig.debug                 |  18 ++
>   drivers/gpu/drm/i915/display/intel_display_power.c |   2 +-
>   drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   7 +-
>   .../drm/i915/gem/selftests/i915_gem_coherency.c    |  10 +-
>   drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c |  14 +-
>   drivers/gpu/drm/i915/gt/intel_breadcrumbs.c        |  13 +-
>   drivers/gpu/drm/i915/gt/intel_breadcrumbs_types.h  |   3 +-
>   drivers/gpu/drm/i915/gt/intel_context.h            |   4 +-
>   drivers/gpu/drm/i915/gt/intel_context_types.h      |   2 +
>   drivers/gpu/drm/i915/gt/intel_engine_pm.c          |   7 +-
>   drivers/gpu/drm/i915/gt/intel_engine_types.h       |   2 +
>   .../gpu/drm/i915/gt/intel_execlists_submission.c   |   2 +-
>   drivers/gpu/drm/i915/gt/intel_gt_pm.c              |  12 +-
>   drivers/gpu/drm/i915/gt/intel_gt_pm.h              |  38 +++-
>   drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c      |   4 +-
>   drivers/gpu/drm/i915/gt/selftest_engine_cs.c       |  20 +-
>   drivers/gpu/drm/i915/gt/selftest_gt_pm.c           |   5 +-
>   drivers/gpu/drm/i915/gt/selftest_reset.c           |  10 +-
>   drivers/gpu/drm/i915/gt/selftest_rps.c             |  17 +-
>   drivers/gpu/drm/i915/gt/selftest_slpc.c            |   5 +-
>   drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  12 +-
>   drivers/gpu/drm/i915/i915_driver.c                 |   2 +-
>   drivers/gpu/drm/i915/i915_pmu.c                    |  16 +-
>   drivers/gpu/drm/i915/intel_runtime_pm.c            | 221 ++-------------------
>   drivers/gpu/drm/i915/intel_runtime_pm.h            |  11 +-
>   drivers/gpu/drm/i915/intel_wakeref.c               |  35 +++-
>   drivers/gpu/drm/i915/intel_wakeref.h               |  73 ++++++-
>   include/linux/ref_tracker.h                        |  25 ++-
>   lib/ref_tracker.c                                  | 179 ++++++++++++++---
>   lib/test_ref_tracker.c                             |   2 +-
>   net/core/dev.c                                     |   2 +-
>   net/core/net_namespace.c                           |   4 +-
>   32 files changed, 445 insertions(+), 332 deletions(-)
> ---
> base-commit: 4d0066a1c0763d50b6fb017e27d12b081ce21b57
> change-id: 20230224-track_gt-1b3da8bdacd7
> 
> Best regards,


