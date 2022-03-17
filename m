Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10ED24DCD18
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbiCQSBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiCQSBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:01:11 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6471208C20;
        Thu, 17 Mar 2022 10:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647539995; x=1679075995;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mrEoFatINvPQoB5zn9lLrgr2v+iqz1+qM+CwhwiS228=;
  b=jEXp0qhvOql3l3QwEGzmrXKvXEwVHeR/Pv2AImmVnYtCSLjkKTfRXNdg
   qlBsTnPs0xcWo0yuzFy9yyksJVXRYOAOycWDCvpfI/qFrau/KHtf58AOU
   r6ceOpz7v9iCe5QjgJwWyWzZSXpmqOD3itnVe1nqjQ5bvRcxDTxENhWbG
   nJt1jwGA9p5nsqCYXm2k39mARfd93ipR9KuVe/yYl3X3HtJkKBppH7dsg
   LoYzUtoVFw3zO8TTFyKgKs/sHp1l4rt3qLHgNKViBilrbD0cM+1LPVyx3
   v1TlcHLq3/pDc0kPdRDzDbconPhW//XCx63vzdcMNqmABfQ7EmRuhp4SW
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="236883755"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="236883755"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 10:59:54 -0700
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="581386489"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.192.243]) ([10.212.192.243])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 10:59:53 -0700
Message-ID: <4131e7b3-94f1-40f1-3d4f-df44cda0e5da@linux.intel.com>
Date:   Thu, 17 Mar 2022 10:59:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v5 05/13] net: wwan: t7xx: Add control port
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
 <20220223223326.28021-6-ricardo.martinez@linux.intel.com>
 <CAHNKnsTUSfieWKuw5WOFPidezoVWDKkLqQV6xnDs560QAGXiCQ@mail.gmail.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsTUSfieWKuw5WOFPidezoVWDKkLqQV6xnDs560QAGXiCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Sergey,

On 3/6/2022 6:55 PM, Sergey Ryazanov wrote:
> On Thu, Feb 24, 2022 at 1:35 AM Ricardo Martinez
> <ricardo.martinez@linux.intel.com> wrote:
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> Control Port implements driver control messages such as modem-host
>> handshaking, controls port enumeration, and handles exception messages.
>>
>> The handshaking process between the driver and the modem happens during
>> the init sequence. The process involves the exchange of a list of
>> supported runtime features to make sure that modem and host are ready
>> to provide proper feature lists including port enumeration. Further
>> features can be enabled and controlled in this handshaking process.
>>
...
>> +static void t7xx_core_hk_handler(struct t7xx_modem *md, struct t7xx_fsm_ctl *ctl,
>> +                                enum t7xx_fsm_event_state event_id,
>> +                                enum t7xx_fsm_event_state err_detect)
>> +{
>> +       struct t7xx_sys_info *core_info = &md->core_md;
>> +       struct device *dev = &md->t7xx_dev->pdev->dev;
>> +       struct t7xx_fsm_event *event, *event_next;
>> +       unsigned long flags;
>> +       void *event_data;
>> +       int ret;
>> +
>> +       t7xx_prepare_host_rt_data_query(core_info);
>> +
>> +       while (!kthread_should_stop()) {
>> +               bool event_received = false;
>> +
>> +               spin_lock_irqsave(&ctl->event_lock, flags);
>> +               list_for_each_entry_safe(event, event_next, &ctl->event_queue, entry) {
>> +                       if (event->event_id == err_detect) {
>> +                               list_del(&event->entry);
>> +                               spin_unlock_irqrestore(&ctl->event_lock, flags);
>> +                               dev_err(dev, "Core handshake error event received\n");
>> +                               goto err_free_event;
>> +                       } else if (event->event_id == event_id) {
>> +                               list_del(&event->entry);
>> +                               event_received = true;
>> +                               break;
>> +                       }
>> +               }
>> +               spin_unlock_irqrestore(&ctl->event_lock, flags);
>> +
>> +               if (event_received)
>> +                       break;
>> +
>> +               wait_event_interruptible(ctl->event_wq, !list_empty(&ctl->event_queue) ||
>> +                                        kthread_should_stop());
>> +               if (kthread_should_stop())
>> +                       goto err_free_event;
>> +       }
>> +
>> +       if (ctl->exp_flg)
>> +               goto err_free_event;
>> +
>> +       event_data = (void *)event + sizeof(*event);
> In the V2, the event structure has a data field. But then it was
> dropped and now the attached data offset is manually calculated. Why
> did you do this, why event->data is not suitable here?

It was removed along with other zero length arrays, although it was 
declared as an empty array.

The next iteration will use C99 flexible arrays where required, instead 
of calculating the data offset manually.

...
