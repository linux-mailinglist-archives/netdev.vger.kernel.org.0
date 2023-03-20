Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2CF6C1A27
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 16:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbjCTPsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 11:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjCTPrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 11:47:45 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BBB16316;
        Mon, 20 Mar 2023 08:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679326759; x=1710862759;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AckTwTsRgSS0tF1Fo3oVzXYwW3h6OGeppI3JzCspk7c=;
  b=CjI0dOJDTTgnYUDJc5wn/TGen7Hze9kHKAvoM+H0U+onAUYnkyWMESm4
   V6Thdw1JSYNviGJKoRG6IrEQSn1hpnFjnhKQUC+jI06BbuU23/Be6BJNV
   TkkMSd54tU7Jt79++Xm92YGw1dxAJUPrvMuS5Zgxwjn+IJeBAlee0COnW
   vruE8NKDX0hoTmcNHGIq+EN4X56AH0nWO75ABQbNHXZ7CMDG1SOZ1l3ql
   S/jWtw1Vncb/5J1KbZ/cYdXZSAiwfTI2P9u475B1TzbyzCARlcm/AtbS4
   J/hBVR1Ja0oPCWoSSURGw+VwPyFLpzC1x5yy+Lw0y/kuE6ArQRTdmDe42
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="337413220"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="337413220"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 08:39:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="681118839"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="681118839"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.6.65]) ([10.213.6.65])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 08:39:03 -0700
Message-ID: <81ae464f-ade8-fb3c-6bfa-11de19c21845@intel.com>
Date:   Mon, 20 Mar 2023 16:39:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [Intel-gfx] [PATCH v4 02/10] lib/ref_tracker:
 __ref_tracker_dir_print improve printing
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
 <20230224-track_gt-v4-2-464e8ab4c9ab@intel.com>
 <ZBeWnKmLiGOOMOiG@ashyti-mobl2.lan>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <ZBeWnKmLiGOOMOiG@ashyti-mobl2.lan>
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

On 20.03.2023 00:11, Andi Shyti wrote:
> Hi Andrzej,
> 
> looks good, few comments below,
> 
> On Mon, Mar 06, 2023 at 05:31:58PM +0100, Andrzej Hajda wrote:
>> To improve readability of ref_tracker printing following changes
>> have been performed:
>> - reports are printed per stack_handle - log is more compact,
>> - added display name for ref_tracker_dir,
>> - stack trace is printed indented, in the same printk call,
>> - total number of references is printed every time,
>> - print info about dropped references.
> 
> nit: I think you can do better with the log :)
> 
>> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
>> ---
>>   include/linux/ref_tracker.h | 15 ++++++--
>>   lib/ref_tracker.c           | 90 +++++++++++++++++++++++++++++++++++++++------
>>   2 files changed, 91 insertions(+), 14 deletions(-)
>>
>> diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
>> index 3e9e9df2a41f5f..a2cf1f6309adb2 100644
>> --- a/include/linux/ref_tracker.h
>> +++ b/include/linux/ref_tracker.h
>> @@ -17,12 +17,19 @@ struct ref_tracker_dir {
>>   	bool			dead;
>>   	struct list_head	list; /* List of active trackers */
>>   	struct list_head	quarantine; /* List of dead trackers */
>> +	char			name[32];
>>   #endif
>>   };
>>   
>>   #ifdef CONFIG_REF_TRACKER
>> -static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
>> -					unsigned int quarantine_count)
>> +
>> +// Temporary allow two and three arguments, until consumers are converted
> 
> I thought only Linus was allowed to use '//' :)
> 
>> +#define ref_tracker_dir_init(_d, _q, args...) _ref_tracker_dir_init(_d, _q, ##args, #_d)
>> +#define _ref_tracker_dir_init(_d, _q, _n, ...) __ref_tracker_dir_init(_d, _q, _n)
> 
> [...]
> 
>> +void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
>> +			   unsigned int display_limit)
>> +{
>> +	struct ref_tracker_dir_stats *stats;
>> +	unsigned int i = 0, skipped;
>> +	depot_stack_handle_t stack;
>> +	char *sbuf;
>> +
>> +	lockdep_assert_held(&dir->lock);
>> +
>> +	if (list_empty(&dir->list))
>> +		return;
>> +
>> +	stats = ref_tracker_get_stats(dir, display_limit);
>> +	if (IS_ERR(stats)) {
>> +		pr_err("%s@%pK: couldn't get stats, error %pe\n",
>> +		       dir->name, dir, stats);
>> +		return;
>>   	}
>> +
>> +	sbuf = kmalloc(STACK_BUF_SIZE, GFP_NOWAIT | __GFP_NOWARN);
>> +
>> +	for (i = 0, skipped = stats->total; i < stats->count; ++i) {
>> +		stack = stats->stacks[i].stack_handle;
>> +		if (sbuf && !stack_depot_snprint(stack, sbuf, STACK_BUF_SIZE, 4))
>> +			sbuf[0] = 0;
>> +		pr_err("%s@%pK has %d/%d users at\n%s\n", dir->name, dir,
>> +		       stats->stacks[i].count, stats->total, sbuf);
> 
> what if sbuf is NULL?

Then "(NULL)" will be printed, I suspect it will occur only on very rare 
occasions.

> 
>> +		skipped -= stats->stacks[i].count;
>> +	}
>> +
>> +	if (skipped)
> 
> is skipped used to double check whether stats->count is equal to
> all the stacks[].conunts? What are the cases when skipped is > 0?

There is display_limit parameter, so the function prints up to 
display_limit reports, and brief summary on remaining ones - the skipped 
ones.

Regards
Andrzej


> 
> Andi
> 
>> +		pr_err("%s@%pK skipped reports about %d/%d users.\n",
>> +		       dir->name, dir, skipped, stats->total);
>> +
>> +	kfree(sbuf);
>> +
>> +	kfree(stats);
>>   }
>>   EXPORT_SYMBOL(__ref_tracker_dir_print);
>>   
>>
>> -- 
>> 2.34.1

