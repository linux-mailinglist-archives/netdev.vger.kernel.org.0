Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD03D53F85D
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 10:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238319AbiFGIlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 04:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238331AbiFGIk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 04:40:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D10D3183
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 01:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654591254; x=1686127254;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+NC0OVLSKbpttSNzxuizzpeRf6a0bNrSUmZ9CvaImZg=;
  b=T2+eSH2uVzhxiT2l897l+/CViBou+n4uzpmz1Uaxs8vYYiH+XbD7PEhH
   on4t6OKvoXrTQuYvM5ZRpqyqDb1l6tR40FXaa9Y6JcQ2saMsbi1LrtmmI
   Asy/Zr+W0WGrPU3+3Bm4i3m5SlQqYJgmI8NoFSIyLejja/zfibym3wXC0
   Xv0/JOYS7lImdREbl1XZeGStEp42V95mP2dZFyHka6UwTCDlWy0ZaU7CL
   E+UcHl3raxeDI3LKTdDlkUNA7CayfS2FhjcBvwIAgV9LlvkysXNX9lMe8
   XVGoxN+MQ4vVZ5EwQ/QHX4NDsfkOuEGkhzwSYMI0I2oFEMtL8IelGAOH7
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="340372121"
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="340372121"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 01:40:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="636026895"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.208.112]) ([10.254.208.112])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 01:40:33 -0700
Message-ID: <3a90bdf3-a3aa-9ceb-1338-9db1f7de631e@intel.com>
Date:   Tue, 7 Jun 2022 16:40:31 +0800
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
 <f86049b5-1eb1-97e7-654c-d3cde0e62aa7@intel.com>
 <CACGkMEuXjUMUTNAQUHr=_n1BiQkz0FD5+t52636uTuM36h-0Kw@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEuXjUMUTNAQUHr=_n1BiQkz0FD5+t52636uTuM36h-0Kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2022 2:14 PM, Jason Wang wrote:
> On Mon, Jun 6, 2022 at 4:22 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>>
>>
>> On 6/2/2022 3:38 PM, Jason Wang wrote:
>>> On Thu, Jun 2, 2022 at 10:48 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>>> If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue pair,
>>>> so when userspace querying queue pair numbers, it should return mq=1
>>>> than zero
>>> Spec said:
>>>
>>> "max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ is set"
>>>
>>> So we are probably fine.
>> I thinks it is asking how many queue
>> pairs(VDPA_ATTR_DEV_NET_CFG_MAX_VQP), so answering 0 may not be correct.
>>
>> Thanks,
>> Zhu Lingshan
> Please add the result of the userspace vdpa tool before and after this
> patch in the changlog in next version.
sure!
>
> Thanks
>
>>> Thanks
>>>
>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> ---
>>>>    drivers/vdpa/vdpa.c | 5 +++--
>>>>    1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>>>> index 030d96bdeed2..50a11ece603e 100644
>>>> --- a/drivers/vdpa/vdpa.c
>>>> +++ b/drivers/vdpa/vdpa.c
>>>> @@ -818,9 +818,10 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>>>>           u16 val_u16;
>>>>
>>>>           if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
>>>> -               return 0;
>>>> +               val_u16 = 1;
>>>> +       else
>>>> +               val_u16 = le16_to_cpu((__force __le16)config->max_virtqueue_pairs);
>>>>
>>>> -       val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
>>>>           return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
>>>>    }
>>>>
>>>> --
>>>> 2.31.1
>>>>

