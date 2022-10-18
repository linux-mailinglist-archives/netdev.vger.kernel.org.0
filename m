Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3815602613
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 09:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiJRHqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 03:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiJRHqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 03:46:19 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4D72B262
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 00:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666079177; x=1697615177;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lGkolx90sLWYwrP3QN7eeTkDS/oTj+6iQIlVle9OszA=;
  b=Gorxy9+9gjdRrUGl1b2X+2AzZYHIQGBlCnsGVQ7lOCy/a4rNq5B2pbTv
   nSIcsEtQ5Oj5cq6FoAcVGOWd+qe+/7DicFbFwSJxeO+ILsXoZlF89G9Hv
   UeF44+zYTC81JLNPaEffgCszgt+avCkHXEcjvDg/7FSdSvHyoxJbyLM3d
   iLzIPpKbbTEg1aCVXFDk/H3g5gq1XPD31iMhDVSVi1wqaym4biVWM7W9t
   Y12307CBCb1Q+NBdec7rIdbXLQGSVMqCfVQbWObxeVhcbQfq0h4DWWMdP
   VcWHDkznL4CvgG1bfBBs1J/gfWI0GvAqRMzoaRGgJ0p63zEoDa5A2lX7k
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="304766908"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="304766908"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 00:46:15 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="661792690"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="661792690"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.201.229]) ([10.249.201.229])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 00:46:13 -0700
Message-ID: <aca0930e-4599-d3a6-fb5c-74f7223f07a9@intel.com>
Date:   Tue, 18 Oct 2022 15:46:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.3
Subject: Re: [PATCH] iproute2/vdpa: Add support for reading device features
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, stephen@networkplumber.org, dsahern@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        hang.yuan@intel.com
References: <20221014094152.5570-1-lingshan.zhu@intel.com>
 <CACGkMEu_pKJukgKuPbTksfemRrfFCb9qbu0iVDKx0O8HL-8q1w@mail.gmail.com>
 <CACGkMEsCbpCBtABW4qhpZhQ4Dg=tt4ZTiL=_WpUXehcPT+e4qQ@mail.gmail.com>
 <954aa373-11a9-5cad-0ed7-4b97688720ba@intel.com>
 <CACGkMEt=dOwSHB+gJ1wJjwR51wWZgVG561wcWWZqp-Upt5kYGA@mail.gmail.com>
 <91af1513-f3c7-9d25-ed0c-0639c7395f6a@intel.com>
 <CACGkMEtRd3pmN-rYj1LMsckTkNaqHFH7xkdccBK1Z9xzRo9KZw@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEtRd3pmN-rYj1LMsckTkNaqHFH7xkdccBK1Z9xzRo9KZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLACK autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/18/2022 3:30 PM, Jason Wang wrote:
> On Tue, Oct 18, 2022 at 3:28 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>>
>>
>> On 10/18/2022 2:44 PM, Jason Wang wrote:
>>> On Tue, Oct 18, 2022 at 10:20 AM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>>>>
>>>> On 10/17/2022 3:13 PM, Jason Wang wrote:
>>>>> On Mon, Oct 17, 2022 at 3:13 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>> On Fri, Oct 14, 2022 at 5:50 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>>>>>> This commit implements support for reading vdpa device
>>>>>>> features in iproute2.
>>>>>>>
>>>>>>> Example:
>>>>>>> $ vdpa dev config show vdpa0
>>>>>>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 4 mtu 1500
>>>>>>>      negotiated_features MRG_RXBUF CTRL_VQ MQ VERSION_1 ACCESS_PLATFORM
>>>>>>>      dev_features MTU MAC MRG_RXBUF CTRL_VQ MQ ANY_LAYOUT VERSION_1 ACCESS_PLATFORM
>>>>>>>
>>>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>> Note that Si Wei proposed to unify the two new attributes:
>>>>> https://patchew.org/linux/1665422823-18364-1-git-send-email-si-wei.liu@oracle.com/
>>>> I think we have discussed this before, there should be two netlink
>>>> attributes to report management device features and vDPA device features,
>>>> they are different type of devices, this unification introduces
>>>> unnecessary couplings
>>> I suggest going through the above patch, both attributes are for the
>>> vDPA device only.
>> It seems not vDPA device only, from above patch, we see it re-uses
>> VDPA_ATTR_DEV_FEATURES for reporting vDPA device features
> Yes, anything wrong with this? The device features could be
> provisioned via netlink.
I think the best netlink practice is to let every attr has its own
and unique purpose, to prevent potential bugs. I think we have discussed 
this before that re-using
an attr does not save any resource.

And iprout2 has already updated the uapi header.

Thanks
>
> Thanks
>
>> Thanks
>>> Thanks
>>>
>>>> Thanks
>>>>> Thanks
>>>>>
>>>>>>> ---
>>>>>>>     vdpa/vdpa.c | 15 +++++++++++++--
>>>>>>>     1 file changed, 13 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
>>>>>>> index b73e40b4..89844e92 100644
>>>>>>> --- a/vdpa/vdpa.c
>>>>>>> +++ b/vdpa/vdpa.c
>>>>>>> @@ -87,6 +87,8 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
>>>>>>>            [VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
>>>>>>>            [VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
>>>>>>>            [VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
>>>>>>> +       [VDPA_ATTR_DEV_FEATURES] = MNL_TYPE_U64,
>>>>>>> +       [VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
>>>>>>>     };
>>>>>>>
>>>>>>>     static int attr_cb(const struct nlattr *attr, void *data)
>>>>>>> @@ -482,7 +484,7 @@ static const char * const *dev_to_feature_str[] = {
>>>>>>>
>>>>>>>     #define NUM_FEATURE_BITS 64
>>>>>>>
>>>>>>> -static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
>>>>>>> +static void print_features(struct vdpa *vdpa, uint64_t features, bool devf,
>>>>>>>                               uint16_t dev_id)
>>>>>>>     {
>>>>>>>            const char * const *feature_strs = NULL;
>>>>>>> @@ -492,7 +494,7 @@ static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
>>>>>>>            if (dev_id < ARRAY_SIZE(dev_to_feature_str))
>>>>>>>                    feature_strs = dev_to_feature_str[dev_id];
>>>>>>>
>>>>>>> -       if (mgmtdevf)
>>>>>>> +       if (devf)
>>>>>>>                    pr_out_array_start(vdpa, "dev_features");
>>>>>>>            else
>>>>>>>                    pr_out_array_start(vdpa, "negotiated_features");
>>>>>>> @@ -771,6 +773,15 @@ static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
>>>>>>>                    val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
>>>>>>>                    print_features(vdpa, val_u64, false, dev_id);
>>>>>>>            }
>>>>>>> +       if (tb[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES]) {
>>>>>>> +               uint16_t dev_id = 0;
>>>>>>> +
>>>>>>> +               if (tb[VDPA_ATTR_DEV_ID])
>>>>>>> +                       dev_id = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
>>>>>>> +
>>>>>>> +               val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES]);
>>>>>>> +               print_features(vdpa, val_u64, true, dev_id);
>>>>>>> +       }
>>>>>>>     }
>>>>>>>
>>>>>>>     static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
>>>>>>> --
>>>>>>> 2.31.1
>>>>>>>

