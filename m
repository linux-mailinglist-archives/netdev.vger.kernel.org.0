Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22ADC6EACF6
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbjDUOap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbjDUOao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:30:44 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4684E12CB4;
        Fri, 21 Apr 2023 07:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682087441; x=1713623441;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=H8Remee2zEmqfUSIzqd+utYJFsZGQbKHCN0Q/yHbfqI=;
  b=gjlKxAbwmxIeZu8bBTkdwwLLjuFKr/jrrnCUAdQVrYJQnLFXSfsLV9kC
   QJej/b8johGBjnBiiWiJvDVlb5pG0eLcP+tI1mBPem8+50F2HdUDcQejT
   PHwL5+Zma0PS3KUHQHIuIk+fChSJtfZ/GLuG3Iz2/Y2Mn/WaIM7hXo661
   W3u7P+OvOtNPet161yyKKCtQMIwnsDSY8jJPFjmeGJAgrHhr3WAUPnYow
   s1VZBGrzUaP4PMqf7bxMSMCRa2MJgrsZVe8LpMULOlsE/Ow5twhcT4Fcc
   swnkvVjqxo1lPwJNuAMFTYzz0IrK3AhGvRl//EoMcXtiM567YuciXjBCa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="411273232"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="411273232"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 07:30:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="836184884"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="836184884"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.8.140]) ([10.213.8.140])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 07:30:36 -0700
Message-ID: <a10480c6-162b-a886-28f6-e95930d4664b@intel.com>
Date:   Fri, 21 Apr 2023 16:30:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH v7 2/7] lib/ref_tracker: improve printing stats
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andi Shyti <andi.shyti@linux.intel.com>
References: <20230224-track_gt-v7-0-11f08358c1ec@intel.com>
 <20230224-track_gt-v7-2-11f08358c1ec@intel.com>
 <CANn89iLUDXz9VAtCQ6Gr2Jkxogdu_5g0tN9iCkAB0JD_B_05Gw@mail.gmail.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <CANn89iLUDXz9VAtCQ6Gr2Jkxogdu_5g0tN9iCkAB0JD_B_05Gw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.04.2023 16:21, Eric Dumazet wrote:
> On Fri, Apr 21, 2023 at 1:35 PM Andrzej Hajda <andrzej.hajda@intel.com> wrote:
>> In case the library is tracking busy subsystem, simply
>> printing stack for every active reference will spam log
>> with long, hard to read, redundant stack traces. To improve
>> readabilty following changes have been made:
>> - reports are printed per stack_handle - log is more compact,
>> - added display name for ref_tracker_dir - it will differentiate
>>    multiple subsystems,
>> - stack trace is printed indented, in the same printk call,
>> - info about dropped references is printed as well.
>>
>> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
>> Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
>> ---
>>   include/linux/ref_tracker.h | 15 ++++++--
>>   lib/ref_tracker.c           | 90 +++++++++++++++++++++++++++++++++++++++------
>>   2 files changed, 91 insertions(+), 14 deletions(-)
>>
>> diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
>> index 87a92f2bec1b88..fc9ef9952f01fd 100644
>> --- a/include/linux/ref_tracker.h
>> +++ b/include/linux/ref_tracker.h
>> @@ -17,12 +17,19 @@ struct ref_tracker_dir {
>>          bool                    dead;
>>          struct list_head        list; /* List of active trackers */
>>          struct list_head        quarantine; /* List of dead trackers */
>> +       char                    name[32];
>>   #endif
>>   };
>>
>>   #ifdef CONFIG_REF_TRACKER
>> -static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
>> -                                       unsigned int quarantine_count)
>> +
>> +/* Temporary allow two and three arguments, until consumers are converted */
>> +#define ref_tracker_dir_init(_d, _q, args...) _ref_tracker_dir_init(_d, _q, ##args, #_d)
>> +#define _ref_tracker_dir_init(_d, _q, _n, ...) __ref_tracker_dir_init(_d, _q, _n)
>> +
> We only have four callers of ref_tracker_dir_init() .
>
> Why not simply add a name on them, and avoid this magic ?

If this can be done in one patch, that's great.

Regards
Andrzej

