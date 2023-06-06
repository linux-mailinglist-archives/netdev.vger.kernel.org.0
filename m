Return-Path: <netdev+bounces-8271-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3150723751
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:12:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F50F2814BB
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 06:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23373D76;
	Tue,  6 Jun 2023 06:12:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EC82119
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:12:00 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF75B100;
	Mon,  5 Jun 2023 23:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686031919; x=1717567919;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tPf1ULSmRXozNF6yiEjZqf/EHNf60rj4pld8Wlm3LKo=;
  b=cuINT2FcbhOIUb7GQ28Myz4542Exd0nS40KNNI49T7TCEqCZfHoQcE8T
   7fyFpqVfGP9pxLRW+Sh9Zmwl197X8U5UUlPLP4rZJujelMFUvGaOOJkjg
   whV2eaJkSYi7DUn5REIfQH9yX6/Dy9pS2UfCzj/cxFxja+h5Qc9PxzN/h
   dsia0kJqBIyDQoouGQqz3Ow4F+JosND117+cIbdbJnPnKdqOmWlqi7zZB
   w9ROwTY2f5vsnIpUoLHEhMFkvABMl+inId3ea+POJv/qfBKby/M3DVRHk
   cYLJmSJ/iJeFdNHdfo6RNCRiLO+no8M4EISmMSbIPyi1Rjw9WvQwr00Hv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="384882747"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="384882747"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 23:11:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="686399007"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="686399007"
Received: from kchmiele-mobl.ger.corp.intel.com (HELO [10.213.21.8]) ([10.213.21.8])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 23:11:55 -0700
Message-ID: <af008d38-3492-3df4-1c1e-95c1bf3102d2@intel.com>
Date: Tue, 6 Jun 2023 08:11:53 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.2
Subject: Re: [PATCH v9 0/4] drm/i915: use ref_tracker library for tracking
 wakerefs
To: Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, "David S. Miller"
 <davem@davemloft.net>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, Chris Wilson <chris@chris-wilson.co.uk>,
 netdev@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
 Andi Shyti <andi.shyti@linux.intel.com>
References: <20230224-track_gt-v9-0-5b47a33f55d1@intel.com>
 <20230605153353.029a57ce@kernel.org>
Content-Language: en-US
From: Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20230605153353.029a57ce@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 06.06.2023 00:33, Jakub Kicinski wrote:
> On Fri, 02 Jun 2023 12:21:32 +0200 Andrzej Hajda wrote:
>> This is reviewed series of ref_tracker patches, ready to merge
>> via network tree, rebased on net-next/main.
>> i915 patches will be merged later via intel-gfx tree.
> FWIW I'll try to merge these on top of the -rc4 tag so
> with a bit of luck you should be able to cross merge cleanly
> into another -next tree.

Thanks.

Regards
Andrzej

