Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCCF602112
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 04:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiJRCUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 22:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiJRCUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 22:20:35 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5770B7D785
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 19:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666059632; x=1697595632;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=esXeMU/E4aXKsHrzwi5nRMQKXGBhCfo8K8QM7xzZT7w=;
  b=gxJ9Zam31aX7xXtwClMtIO5obZHF8rqarKnHlAubvKTN3FtcJsaOwmLY
   9HHbI77mTxYuJY/EiveEDFHK97iqAiVSmV1k+ibFDtizXD82K7cN6Z27H
   sqpmcIdqybCTGqOn3DHVbVyP392QIo4DW9jwU/2gyFVIXbj9oxUahB6ox
   IoacV3hx2obwftB+SxCNL4tDYx0L1DmQSbiIE34r90UdNebFOVY5Vf8Tf
   gAEn0wRWLf7JAbAlUTPSiqBndOk+SwRS7m5dzsB7S7QaoCeeIcQ9+xZzN
   Vn1AVYB3RhZXai71lHUSnQr0bEBU/ySPqFE+p0MDQ6hL49VwV0YvhOP6G
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="304714650"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="304714650"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 19:20:29 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="579599926"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="579599926"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.201.229]) ([10.249.201.229])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 19:20:26 -0700
Message-ID: <954aa373-11a9-5cad-0ed7-4b97688720ba@intel.com>
Date:   Tue, 18 Oct 2022 10:20:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.3
Subject: Re: [PATCH] iproute2/vdpa: Add support for reading device features
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, stephen@networkplumber.org, dsahern@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        hang.yuan@intel.com
References: <20221014094152.5570-1-lingshan.zhu@intel.com>
 <CACGkMEu_pKJukgKuPbTksfemRrfFCb9qbu0iVDKx0O8HL-8q1w@mail.gmail.com>
 <CACGkMEsCbpCBtABW4qhpZhQ4Dg=tt4ZTiL=_WpUXehcPT+e4qQ@mail.gmail.com>
Content-Language: en-US
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEsCbpCBtABW4qhpZhQ4Dg=tt4ZTiL=_WpUXehcPT+e4qQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/17/2022 3:13 PM, Jason Wang wrote:
> On Mon, Oct 17, 2022 at 3:13 PM Jason Wang <jasowang@redhat.com> wrote:
>> On Fri, Oct 14, 2022 at 5:50 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>> This commit implements support for reading vdpa device
>>> features in iproute2.
>>>
>>> Example:
>>> $ vdpa dev config show vdpa0
>>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 4 mtu 1500
>>>    negotiated_features MRG_RXBUF CTRL_VQ MQ VERSION_1 ACCESS_PLATFORM
>>>    dev_features MTU MAC MRG_RXBUF CTRL_VQ MQ ANY_LAYOUT VERSION_1 ACCESS_PLATFORM
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> Note that Si Wei proposed to unify the two new attributes:
> https://patchew.org/linux/1665422823-18364-1-git-send-email-si-wei.liu@oracle.com/
I think we have discussed this before, there should be two netlink 
attributes to report management device features and vDPA device features,
they are different type of devices, this unification introduces 
unnecessary couplings

Thanks
>
> Thanks
>
>>
>>> ---
>>>   vdpa/vdpa.c | 15 +++++++++++++--
>>>   1 file changed, 13 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
>>> index b73e40b4..89844e92 100644
>>> --- a/vdpa/vdpa.c
>>> +++ b/vdpa/vdpa.c
>>> @@ -87,6 +87,8 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
>>>          [VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
>>>          [VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
>>>          [VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
>>> +       [VDPA_ATTR_DEV_FEATURES] = MNL_TYPE_U64,
>>> +       [VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
>>>   };
>>>
>>>   static int attr_cb(const struct nlattr *attr, void *data)
>>> @@ -482,7 +484,7 @@ static const char * const *dev_to_feature_str[] = {
>>>
>>>   #define NUM_FEATURE_BITS 64
>>>
>>> -static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
>>> +static void print_features(struct vdpa *vdpa, uint64_t features, bool devf,
>>>                             uint16_t dev_id)
>>>   {
>>>          const char * const *feature_strs = NULL;
>>> @@ -492,7 +494,7 @@ static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
>>>          if (dev_id < ARRAY_SIZE(dev_to_feature_str))
>>>                  feature_strs = dev_to_feature_str[dev_id];
>>>
>>> -       if (mgmtdevf)
>>> +       if (devf)
>>>                  pr_out_array_start(vdpa, "dev_features");
>>>          else
>>>                  pr_out_array_start(vdpa, "negotiated_features");
>>> @@ -771,6 +773,15 @@ static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
>>>                  val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
>>>                  print_features(vdpa, val_u64, false, dev_id);
>>>          }
>>> +       if (tb[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES]) {
>>> +               uint16_t dev_id = 0;
>>> +
>>> +               if (tb[VDPA_ATTR_DEV_ID])
>>> +                       dev_id = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
>>> +
>>> +               val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES]);
>>> +               print_features(vdpa, val_u64, true, dev_id);
>>> +       }
>>>   }
>>>
>>>   static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
>>> --
>>> 2.31.1
>>>

