Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910586C1FBC
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjCTSdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjCTScs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:32:48 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770E12E0C0;
        Mon, 20 Mar 2023 11:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679336717; x=1710872717;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KAqlx1YFiowkUDpvtxglFZCWP+Bcoz7vB9tjbuTJQK4=;
  b=a5K1zDGzm8gIxe+sztmDwmUnKgXhLVcxWYgccgxhBNZ4dUzOW01PVDty
   URW1QYXV/Q90+vz7sT8QPLP3GRHuDEFwYbQ0fb5gp7HRfrS9t+otVpoYA
   L1Klrg3v/GapRdMnp5l5b657WZJ2cuDEMCtt2iPKn1IeXT4UJNr1qibcH
   /IeNvidIXSWF65oaKvA/FJBVpDZeczKNku7raAR4HNSjFTNdik66quOUM
   QTwt8nyIeI47rAnpyUO3HE2qjaaWHo4UrkrtAIGoHnDb+GQPB03zb4y5a
   Yq8NHFhK/S7/R0QXXxzgF25YNMRLH590l9Lwh1gx8nSoPcXatS4kWA/mY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="341101256"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="341101256"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 11:24:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="674507500"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="674507500"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.6.65]) ([10.213.6.65])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 11:24:53 -0700
Message-ID: <9b1efced-605e-1088-946f-06a4c1a27260@intel.com>
Date:   Mon, 20 Mar 2023 19:24:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [Intel-gfx] [PATCH v4 03/10] lib/ref_tracker: add printing to
 memory buffer
Content-Language: en-US
To:     Andi Shyti <andi.shyti@linux.intel.com>
Cc:     Chris Wilson <chris.p.wilson@intel.com>, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Dumazet <edumazet@google.com>,
        dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Airlie <airlied@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
References: <20230224-track_gt-v4-0-464e8ab4c9ab@intel.com>
 <20230224-track_gt-v4-3-464e8ab4c9ab@intel.com>
 <ZBeYNaTUmvAxrzoU@ashyti-mobl2.lan>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <ZBeYNaTUmvAxrzoU@ashyti-mobl2.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.03.2023 00:18, Andi Shyti wrote:
> Hi Andrzej,
> 
> This looks also good, just few questions.
> 
> On Mon, Mar 06, 2023 at 05:31:59PM +0100, Andrzej Hajda wrote:
>> In case one wants to show stats via debugfs.
> 
> shall I say it? I'll say it... you can do better with the log
> here. It's not a typo fix :)
> 
>> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
> 
> [...]
> 
>> +void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
>> +			   unsigned int display_limit)
>> +{
>> +	struct ostream os = {};
>> +
>> +	__ref_tracker_dir_pr_ostream(dir, display_limit, &os);
>> +}
>>   EXPORT_SYMBOL(__ref_tracker_dir_print);
>>   
>>   void ref_tracker_dir_print(struct ref_tracker_dir *dir,
>> @@ -114,6 +141,19 @@ void ref_tracker_dir_print(struct ref_tracker_dir *dir,
>>   }
>>   EXPORT_SYMBOL(ref_tracker_dir_print);
>>   
>> +int ref_tracker_dir_snprint(struct ref_tracker_dir *dir, char *buf, size_t size)
> 
> nit: snprintf is normally referred to its variable parameter
> counterpart... I would choose a different name... how about
> ref_tracker_dir_fetch_print()?


Hmm, original ref_tracker_dir_print prints the stats to dmesg,
ref_tracker_dir_snprint prints to memory buffer, like:
- stack_depot_print and stack_depot_snprint,
- stack_trace_print and stack_trace_snprint.


> 
>> +{
>> +	struct ostream os = { .buf = buf, .size = size };
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&dir->lock, flags);
>> +	__ref_tracker_dir_pr_ostream(dir, 16, &os);
>> +	spin_unlock_irqrestore(&dir->lock, flags);
> 
> What are you trying to protect with this spinlock? what if
> the caller has already locked here? do we need a _locked()
> version?

spinlock is to serialize access to dir,
at the moment _locked version is not necessary, but it can be easily 
added if needed.

Regards
Andrzej


> 
> Thanks,
> Andi
> 
>> +	return os.used;
>> +}
>> +EXPORT_SYMBOL(ref_tracker_dir_snprint);
>> +
>>   void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
>>   {
>>   	struct ref_tracker *tracker, *n;
>>
>> -- 
>> 2.34.1

