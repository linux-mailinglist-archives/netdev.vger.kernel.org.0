Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088D753E220
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiFFITI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 04:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbiFFITF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 04:19:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400716B67B
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 01:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654503544; x=1686039544;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=krEV5UO21BxbfNc/SmNJO4rXokG8UWITxwU3wuXLcW8=;
  b=H1AytD0+gOPI/wi6qcR/ReBpg7sb8vOLFV80vw3Ls5ahW5WPjVtOPXy8
   ym4x1Z7aWNMRxWx1F2svgqXMN3unQzdtiWJ1OkBh+TBVc14A2Qu5qmvIc
   KxsZOY+VBXfndInyC7OO/br7yWG6DsK5zA2OazTrtSBy+QVYv8Rpvwtsk
   TNsFKd26ACtp3psJwtQLdc8yj+bbBUnVoWavqxLWswKS0zXMD9qWRT5u7
   N3z0oZdrbARPV/n9LJogYleZRMmBt2TXmtf1aGMSkeMAvzevXQiLCHoak
   rAP5oE9fR6E+igC+Fo1L8fryL4jAqkEnGS50yPf3KkRsqEtwQy9lXXr7B
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="258879299"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="258879299"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:19:03 -0700
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="583512923"
Received: from fengjia-mobl2.ccr.corp.intel.com (HELO [10.254.210.182]) ([10.254.210.182])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:19:00 -0700
Message-ID: <f4eba581-31e8-58ac-8996-1729befaf5c6@intel.com>
Date:   Mon, 6 Jun 2022 16:18:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH 2/6] vDPA/ifcvf: support userspace to query features and
 MQ of a management device
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
References: <20220602023845.2596397-1-lingshan.zhu@intel.com>
 <20220602023845.2596397-3-lingshan.zhu@intel.com>
 <CACGkMEt4u2R9y8f3S0rAhrEmOi-N=1NCfLxLTR+U6ddcu9iYWg@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEt4u2R9y8f3S0rAhrEmOi-N=1NCfLxLTR+U6ddcu9iYWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/2022 3:21 PM, Jason Wang wrote:
> On Thu, Jun 2, 2022 at 10:48 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>> Adapting to current netlink interfaces, this commit allows userspace
>> to query feature bits and MQ capability of a management device.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_base.c | 12 ++++++++++++
>>   drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
>>   drivers/vdpa/ifcvf/ifcvf_main.c |  3 +++
>>   3 files changed, 16 insertions(+)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
>> index 6bccc8291c26..7be703b5d1f4 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
>> @@ -341,6 +341,18 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
>>          return 0;
>>   }
>>
>> +u16 ifcvf_get_max_vq_pairs(struct ifcvf_hw *hw)
>> +{
>> +       struct virtio_net_config __iomem *config;
>> +       u16 val, mq;
>> +
>> +       config  = (struct virtio_net_config __iomem *)hw->dev_cfg;
> Any reason we need the cast here? (cast from void * seems not necessary).
This cast is unnecessary.
>
>> +       val = vp_ioread16((__le16 __iomem *)&config->max_virtqueue_pairs);
> I don't see any __le16 cast for the callers of vp_ioread16, anything
> make max_virtqueue_pairs different here?
I think we still need it here since hw->dev_cfg and its contents are __iomem

THanks
>
> Thanks
>
>> +       mq = le16_to_cpu((__force __le16)val);
>> +
>> +       return mq;
>> +}
>> +
>>   static int ifcvf_hw_enable(struct ifcvf_hw *hw)
>>   {
>>          struct virtio_pci_common_cfg __iomem *cfg;
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
>> index f5563f665cc6..d54a1bed212e 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>> @@ -130,6 +130,7 @@ u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
>>   int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features);
>>   u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
>>   int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
>> +u16 ifcvf_get_max_vq_pairs(struct ifcvf_hw *hw);
>>   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
>>   int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
>>   u32 ifcvf_get_config_size(struct ifcvf_hw *hw);
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index 4366320fb68d..0c3af30b297e 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -786,6 +786,9 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>>          vf->hw_features = ifcvf_get_hw_features(vf);
>>          vf->config_size = ifcvf_get_config_size(vf);
>>
>> +       ifcvf_mgmt_dev->mdev.max_supported_vqs = ifcvf_get_max_vq_pairs(vf);
> Btw, I think current IFCVF doesn't support the provisioning of a
> $max_qps that is smaller than what hardware did.
>
> Then I wonder if we need a min_supported_vqs attribute or doing
> mediation in the ifcvf parent.
>
> Thanks
>
>> +       ifcvf_mgmt_dev->mdev.supported_features = vf->hw_features;
>> +
>>          adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
>>          ret = _vdpa_register_device(&adapter->vdpa, vf->nr_vring);
>>          if (ret) {
>> --
>> 2.31.1
>>

