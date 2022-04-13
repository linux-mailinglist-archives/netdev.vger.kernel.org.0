Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC40500230
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 01:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238114AbiDMXDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 19:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiDMXDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 19:03:07 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72278252AB;
        Wed, 13 Apr 2022 16:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649890844; x=1681426844;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OjccN9bs2KpOWb7jep2rWqSlBHp3YKXCzqYUVTW/1Xc=;
  b=kKaOEwEmN5i3MJRMEJjiQMj76R6fD/pWRkQ2wh78rk3yvvfdl7llr5bu
   7cXfVK7o9Jsnhn1apyzP/Z2vAdSxSbcXPfSw0Ge7/yGuPHPYm2bfH3HHZ
   0sQIvm1qGqbxpcZ58mogKa6qi9ekwDYgPY0MO7kGs40VA/YZCrdI+a/iN
   kN7aL8Azlv6eCw7FQLSFs8HNNczeq5ZnvQyd28njGmnjh5Yd0w2RcEvMj
   MfD20ea7uSQuJoQ/xxvggYlHKm2r22qsKVz3PO3uM1S8+14+2y4EouoVH
   kjMDoliM4dzmE3WFGGUG9fOjfveNTFdKu5IoMS2psZFSq6Q9KnErDHiC2
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="250086783"
X-IronPort-AV: E=Sophos;i="5.90,258,1643702400"; 
   d="scan'208";a="250086783"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 16:00:43 -0700
X-IronPort-AV: E=Sophos;i="5.90,258,1643702400"; 
   d="scan'208";a="661117121"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.209.84.69]) ([10.209.84.69])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 16:00:43 -0700
Message-ID: <a3c98699-c9f1-ff96-1c66-5bb93e20b6ff@linux.intel.com>
Date:   Wed, 13 Apr 2022 16:00:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v6 05/13] net: wwan: t7xx: Add control port
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
 <20220407223629.21487-6-ricardo.martinez@linux.intel.com>
 <20ed7cce-6ba0-29fa-2cb0-89b02f31ce6f@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <20ed7cce-6ba0-29fa-2cb0-89b02f31ce6f@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/12/2022 5:04 AM, Ilpo Järvinen wrote:
> On Thu, 7 Apr 2022, Ricardo Martinez wrote:
>
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
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>
>> >From a WWAN framework perspective:
>> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
>>
>> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>> +static int t7xx_prepare_device_rt_data(struct t7xx_sys_info *core, struct device *dev,
>> +				       void *data)
>> +{
>> +	struct feature_query *md_feature = data;
>> +	struct mtk_runtime_feature *rt_feature;
>> +	unsigned int i, rt_data_len = 0;
>> +	struct sk_buff *skb;
>> +
>> +	/* Parse MD runtime data query */
>> +	if (le32_to_cpu(md_feature->head_pattern) != MD_FEATURE_QUERY_ID ||
>> +	    le32_to_cpu(md_feature->tail_pattern) != MD_FEATURE_QUERY_ID) {
>> +		dev_err(dev, "Invalid feature pattern: head 0x%x, tail 0x%x\n",
>> +			le32_to_cpu(md_feature->head_pattern),
>> +			le32_to_cpu(md_feature->tail_pattern));
>> +		return -EINVAL;
>> +	}
>> +
>> +	for (i = 0; i < FEATURE_COUNT; i++) {
>> +		if (FIELD_GET(FEATURE_MSK, md_feature->feature_set[i]) !=
>> +		    MTK_FEATURE_MUST_BE_SUPPORTED)
>> +			rt_data_len += sizeof(*rt_feature);
>> +	}
>> +
>> +	skb = t7xx_ctrl_alloc_skb(rt_data_len);
>> +	if (!skb)
>> +		return -ENOMEM;
>> +
>> +	rt_feature  = skb_put(skb, rt_data_len);
>> +	memset(rt_feature, 0, rt_data_len);
>> +
>> +	/* Fill runtime feature */
>> +	for (i = 0; i < FEATURE_COUNT; i++) {
>> +		u8 md_feature_mask = FIELD_GET(FEATURE_MSK, md_feature->feature_set[i]);
>> +
>> +		if (md_feature_mask == MTK_FEATURE_MUST_BE_SUPPORTED)
>> +			continue;
>> +
>> +		rt_feature->feature_id = i;
>> +		if (md_feature_mask == MTK_FEATURE_DOES_NOT_EXIST)
>> +			rt_feature->support_info = md_feature->feature_set[i];
>> +
>> +		rt_feature++;
>> +	}
>> +
>> +	/* Send HS3 message to device */
>> +	t7xx_port_send_ctl_skb(core->ctl_port, skb, CTL_ID_HS3_MSG, 0);
>> +	return 0;
>> +}
>> +
>> +static int t7xx_parse_host_rt_data(struct t7xx_fsm_ctl *ctl, struct t7xx_sys_info *core,
>> +				   struct device *dev, void *data, int data_length)
>> +{
>> +	enum mtk_feature_support_type ft_spt_st, ft_spt_cfg;
>> +	struct mtk_runtime_feature *rt_feature;
>> +	int i, offset;
>> +
>> +	offset = sizeof(struct feature_query);
>> +	for (i = 0; i < FEATURE_COUNT && offset < data_length; i++) {
>> +		rt_feature = data + offset;
>> +		offset += sizeof(*rt_feature) + le32_to_cpu(rt_feature->data_len);
>> +
>> +		ft_spt_cfg = FIELD_GET(FEATURE_MSK, core->feature_set[i]);
>> +		if (ft_spt_cfg != MTK_FEATURE_MUST_BE_SUPPORTED)
>> +			continue;
> Do MTK_FEATURE_MUST_BE_SUPPORTED appear in the host rt_features
> (unlike in the device rt_features)?
>
Yes, in the first step of the handshake protocol, the host creates its
rt_feature list with the proper support label and sends the list to the device.
t7xx_parse_host_rt_data() is part of the handshake step 2, the host received the
response from the device and now it will verify that the host rt_features
labeled as MTK_FEATURE_MUST_BE_SUPPORTED are also supported in the device rt_features.

