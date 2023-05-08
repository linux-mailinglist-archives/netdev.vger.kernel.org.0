Return-Path: <netdev+bounces-914-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D4EB6FB5C9
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:16:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93F95281065
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 17:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F605665;
	Mon,  8 May 2023 17:16:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8ED2100
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 17:16:15 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3529B4ED6;
	Mon,  8 May 2023 10:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683566173; x=1715102173;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I5UZMcyj02FL6cYHxfdgEYHGfkFiYXZYS6u755QZG64=;
  b=XSVndJYn6TrxF3y/ZyWS4oMRITbVDRwe1RRFP8GXPNZaIzazdvA+yX4l
   SfnYTKh7UmKsB7zfnKSYplyrvWEBiKgVRHV3tbOUueDncXFME4cBTqyB3
   wzE85tcajvef5IiBKqUuWjw8EKVbZ/axJ9e4VAartwOAh4jVFnuRVYFx2
   HW/Vvd8lzVzb0db6WbHHUvhOVtax5jLBS16HmIxkmrDaiUtbztGBZfMfs
   VmXb2qtNycjrqhFdS2saLwcyomMsU46MHu2B4+D6Xwltho2ofmK68lDkZ
   2MwXU8Z+/B2yK9UljgIwXDBkUpOZ3OhoGkpu8U1HXonq6SclYSsxYXBT+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="412965487"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="412965487"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 10:16:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="676126150"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="676126150"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.12.75]) ([10.213.12.75])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 10:16:09 -0700
Message-ID: <bb49bbd6-1ff2-8dba-11d1-6b6ab2ccd986@intel.com>
Date: Mon, 8 May 2023 19:16:06 +0200
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
To: Rodrigo Vivi <rodrigo.vivi@kernel.org>,
 "David S . Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
 Eric Dumazet <edumazet@google.com>, dri-devel@lists.freedesktop.org,
 Daniel Vetter <daniel@ffwll.ch>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Jakub Kicinski <kuba@kernel.org>, David Airlie <airlied@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>
References: <20230224-track_gt-v8-0-4b6517e61be6@intel.com>
 <55aa19b3-58d4-02ae-efd1-c3f3d0f21ce6@intel.com>
 <ZFVhx2PBdcwpNNl0@rdvivi-mobl4>
From: Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <ZFVhx2PBdcwpNNl0@rdvivi-mobl4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05.05.2023 22:06, Rodrigo Vivi wrote:
> On Thu, May 04, 2023 at 06:27:53PM +0200, Andrzej Hajda wrote:
>> Hi maintainers of net and i915,
>>
>> On 25.04.2023 00:05, Andrzej Hajda wrote:
>>> This is revived patchset improving ref_tracker library and converting
>>> i915 internal tracker to ref_tracker.
>>> The old thread ended without consensus about small kernel allocations,
>>> which are performed under spinlock.
>>> I have tried to solve the problem by splitting the calls, but it results
>>> in complicated API, so I went back to original solution.
>>> If there are better solutions I am glad to discuss them.
>>> Meanwhile I send original patchset with addressed remaining comments.
>>>
>>> To: Jani Nikula <jani.nikula@linux.intel.com>
>>> To: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>>> To: Rodrigo Vivi <rodrigo.vivi@intel.com>
>>> To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
>>> To: David Airlie <airlied@gmail.com>
>>> To: Daniel Vetter <daniel@ffwll.ch>
>>> To: Eric Dumazet <edumazet@google.com>
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: intel-gfx@lists.freedesktop.org
>>> Cc: dri-devel@lists.freedesktop.org
>>> Cc: Chris Wilson <chris@chris-wilson.co.uk>
>>> Cc: netdev@vger.kernel.org
>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>> Cc: Dmitry Vyukov <dvyukov@google.com>
>>> Cc: "David S. Miller" <davem@davemloft.net>
>>> Cc: Andi Shyti <andi.shyti@linux.intel.com>
>>> Cc: Das, Nirmoy <nirmoy.das@linux.intel.com>
>>> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
>>>
>>> ---
>>> Changes in v8:
>>> - addressed comments from Eric, Zhou and CI, thanks,
>>> - added ref_tracker_dir_init name argument to all callers in one patch
>>> - moved intel_wakeref_tracker_show to *.c
>>> - s/intel_wakeref_tracker_show/intel_ref_tracker_show/
>>> - removed 'default n' from Kconfig
>>> - changed strlcpy to strscpy,
>>> - removed assignement from if condition,
>>> - removed long lines from patch description
>>> - added tags
>>> - Link to v7: https://lore.kernel.org/r/20230224-track_gt-v7-0-11f08358c1ec@intel.com
>>>
>>> Changes in v7:
>>> - removed 8th patch (hold wakeref), as it was already merged
>>> - added tags (thx Andi)
>>> - Link to v6: https://lore.kernel.org/r/20230224-track_gt-v6-0-0dc8601fd02f@intel.com
>>>
>>> Changes in v6:
>>> - rebased to solve minor conflict and allow CI testing
>>> - Link to v5: https://lore.kernel.org/r/20230224-track_gt-v5-0-77be86f2c872@intel.com
>>>
>>> Changes in v5 (thx Andi for review):
>>> - use *_locked convention instead of __*,
>>> - improved commit messages,
>>> - re-worked i915 patches, squashed separation and conversion patches,
>>> - added tags,
>>> - Link to v4: https://lore.kernel.org/r/20230224-track_gt-v4-0-464e8ab4c9ab@intel.com
>>>
>>> Changes in v4:
>>> - split "Separate wakeref tracking" to smaller parts
>>> - fixed typos,
>>> - Link to v1-v3: https://patchwork.freedesktop.org/series/100327/
>>>
>>> ---
>>> Andrzej Hajda (7):
>>>         lib/ref_tracker: add unlocked leak print helper
>>>         lib/ref_tracker: improve printing stats
>>>         lib/ref_tracker: add printing to memory buffer
>>>         lib/ref_tracker: remove warnings in case of allocation failure
>>>         drm/i915: Correct type of wakeref variable
>>>         drm/i915: Replace custom intel runtime_pm tracker with ref_tracker library
>>>         drm/i915: Track gt pm wakerefs
>>
>> Finally all patches are reviewed.
>> Question to network and i915 maintainers, how to merge this patchset:
>> 1. Patches 1-4 belongs rather to network domain (especially patch 2).
>> 2. Patches 5-7 are for i915.
> 
> Well, probably the easiest way to avoid conflicts would be to send
> this right now through the net repo.
> 
> And hold patches 5-7 after drm-intel-next can backmerge them.
> 
> At this point I believe we would be looking at 6.5-rc2
> backmerge to drm-intel-next in likely 11 weeks from now.
> 
> Do we have any urgency on them? Looking to all the changes in
> i915 I believe we will get many conflicts if we let all these
> i915 patches go through net tree as well.


Eric, Dave, Jakub, could you take patches 1-4?

Regards
Andrzej


> 
>>
>> What would be the best way to do it?
>>
>> Regards
>> Andrzej
>>
>>
>>
>>>
>>>    drivers/gpu/drm/i915/Kconfig.debug                 |  18 ++
>>>    drivers/gpu/drm/i915/display/intel_display_power.c |   2 +-
>>>    drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   7 +-
>>>    .../drm/i915/gem/selftests/i915_gem_coherency.c    |  10 +-
>>>    drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c |  14 +-
>>>    drivers/gpu/drm/i915/gt/intel_breadcrumbs.c        |  13 +-
>>>    drivers/gpu/drm/i915/gt/intel_breadcrumbs_types.h  |   3 +-
>>>    drivers/gpu/drm/i915/gt/intel_context.h            |   4 +-
>>>    drivers/gpu/drm/i915/gt/intel_context_types.h      |   2 +
>>>    drivers/gpu/drm/i915/gt/intel_engine_pm.c          |   7 +-
>>>    drivers/gpu/drm/i915/gt/intel_engine_types.h       |   2 +
>>>    .../gpu/drm/i915/gt/intel_execlists_submission.c   |   2 +-
>>>    drivers/gpu/drm/i915/gt/intel_gt_pm.c              |  12 +-
>>>    drivers/gpu/drm/i915/gt/intel_gt_pm.h              |  38 +++-
>>>    drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c      |   4 +-
>>>    drivers/gpu/drm/i915/gt/selftest_engine_cs.c       |  20 +-
>>>    drivers/gpu/drm/i915/gt/selftest_gt_pm.c           |   5 +-
>>>    drivers/gpu/drm/i915/gt/selftest_reset.c           |  10 +-
>>>    drivers/gpu/drm/i915/gt/selftest_rps.c             |  17 +-
>>>    drivers/gpu/drm/i915/gt/selftest_slpc.c            |   5 +-
>>>    drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  12 +-
>>>    drivers/gpu/drm/i915/i915_driver.c                 |   2 +-
>>>    drivers/gpu/drm/i915/i915_pmu.c                    |  16 +-
>>>    drivers/gpu/drm/i915/intel_runtime_pm.c            | 221 ++-------------------
>>>    drivers/gpu/drm/i915/intel_runtime_pm.h            |  11 +-
>>>    drivers/gpu/drm/i915/intel_wakeref.c               |  35 +++-
>>>    drivers/gpu/drm/i915/intel_wakeref.h               |  73 ++++++-
>>>    include/linux/ref_tracker.h                        |  25 ++-
>>>    lib/ref_tracker.c                                  | 179 ++++++++++++++---
>>>    lib/test_ref_tracker.c                             |   2 +-
>>>    net/core/dev.c                                     |   2 +-
>>>    net/core/net_namespace.c                           |   4 +-
>>>    32 files changed, 445 insertions(+), 332 deletions(-)
>>> ---
>>> base-commit: 4d0066a1c0763d50b6fb017e27d12b081ce21b57
>>> change-id: 20230224-track_gt-1b3da8bdacd7
>>>
>>> Best regards,
>>


