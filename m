Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B895953E2A4
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiFFIWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 04:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiFFIV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 04:21:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1F42F002
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 01:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654503716; x=1686039716;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/KqMzYmvuWq8pt26Y8kK7hpfyiIyIwbNK7AZOML6HQ8=;
  b=ner+ZHXUKpKg/wgrMoeHTfvqWuHdnuKzJv6W0TbHLomTGDaZicj9vxQX
   fPbU7dXuTMhBDtFwI+rzUfEJ4al5ZRCY6vVy/t/MjoWf/xAPPBXzT6CLA
   Ou59dp2CV5sYom5W2uo9L5ZAcemevC+UoB+BOfHSTZ3/7cLHNd3tWHgIp
   xxzVCsesYYEpxGsW7Izo62xE4a3mLH7hJ6De+J9m8DZ1ZwGW+1J4TUXfb
   UtmqDOjlCMljt5/nGvBgb5bN8GbTdKYKZs2KjVfUGJjxVX4E6SiwgwLYo
   g6sn8M+ODY0uIPn/fXxeMSmC9ZWA9SQCeoD8POolzV+RUk+DPm9U4lyO2
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="276837479"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="276837479"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:21:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="583513814"
Received: from fengjia-mobl2.ccr.corp.intel.com (HELO [10.254.210.182]) ([10.254.210.182])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:21:29 -0700
Message-ID: <f86049b5-1eb1-97e7-654c-d3cde0e62aa7@intel.com>
Date:   Mon, 6 Jun 2022 16:21:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH 5/6] vDPA: answer num of queue pairs = 1 to userspace when
 VIRTIO_NET_F_MQ == 0
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
References: <20220602023845.2596397-1-lingshan.zhu@intel.com>
 <20220602023845.2596397-6-lingshan.zhu@intel.com>
 <CACGkMEtCKT5ib_+gUdryDXfxntTr_JF7fZpeePZ+=BFjY_TG+w@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEtCKT5ib_+gUdryDXfxntTr_JF7fZpeePZ+=BFjY_TG+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/2022 3:38 PM, Jason Wang wrote:
> On Thu, Jun 2, 2022 at 10:48 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>> If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue pair,
>> so when userspace querying queue pair numbers, it should return mq=1
>> than zero
> Spec said:
>
> "max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ is set"
>
> So we are probably fine.
I thinks it is asking how many queue 
pairs(VDPA_ATTR_DEV_NET_CFG_MAX_VQP), so answering 0 may not be correct.

Thanks,
Zhu Lingshan
>
> Thanks
>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/vdpa.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>> index 030d96bdeed2..50a11ece603e 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -818,9 +818,10 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>>          u16 val_u16;
>>
>>          if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
>> -               return 0;
>> +               val_u16 = 1;
>> +       else
>> +               val_u16 = le16_to_cpu((__force __le16)config->max_virtqueue_pairs);
>>
>> -       val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
>>          return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
>>   }
>>
>> --
>> 2.31.1
>>

