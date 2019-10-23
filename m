Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 225F5E1200
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 08:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387829AbfJWGTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 02:19:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:54220 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbfJWGTR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 02:19:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 23:19:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,219,1569308400"; 
   d="scan'208";a="191731422"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.238.129.48]) ([10.238.129.48])
  by orsmga008.jf.intel.com with ESMTP; 22 Oct 2019 23:19:13 -0700
Subject: Re: [RFC 2/2] vhost: IFC VF vdpa layer
To:     Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@linux.intel.com>, mst@redhat.com,
        alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
References: <20191016013050.3918-1-lingshan.zhu@intel.com>
 <20191016013050.3918-3-lingshan.zhu@intel.com>
 <9495331d-3c65-6f49-dcd9-bfdb17054cf0@redhat.com>
 <f65358e9-6728-8260-74f7-176d7511e989@intel.com>
 <1cae60b6-938d-e2df-2dca-fbf545f06853@redhat.com>
 <ddf412c6-69e2-b3ca-d0c8-75de1db78ed9@linux.intel.com>
 <b2adaab0-bbc3-b7f0-77da-e1e3cab93b76@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <6588d9f4-f357-ec78-16a4-ccaf0e3768e7@intel.com>
Date:   Wed, 23 Oct 2019 14:19:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <b2adaab0-bbc3-b7f0-77da-e1e3cab93b76@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/22/2019 9:05 PM, Jason Wang wrote:
>
> On 2019/10/22 下午2:53, Zhu Lingshan wrote:
>>
>> On 10/21/2019 6:19 PM, Jason Wang wrote:
>>>
>>> On 2019/10/21 下午5:53, Zhu, Lingshan wrote:
>>>>
>>>> On 10/16/2019 6:19 PM, Jason Wang wrote:
>>>>>
>>>>> On 2019/10/16 上午9:30, Zhu Lingshan wrote:
>>>>>> This commit introduced IFC VF operations for vdpa, which complys to
>>>>>> vhost_mdev interfaces, handles IFC VF initialization,
>>>>>> configuration and removal.
>>>>>>
>>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>> ---
>
>
> [...]
>
>
>>>
>>>
>>>>
>>>>>
>>>>>
>>>>>> +}
>>>>>> +
>>>>>> +static int ifcvf_mdev_set_features(struct mdev_device *mdev, u64 
>>>>>> features)
>>>>>> +{
>>>>>> +    struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
>>>>>> +    struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
>>>>>> +
>>>>>> +    vf->req_features = features;
>>>>>> +
>>>>>> +    return 0;
>>>>>> +}
>>>>>> +
>>>>>> +static u64 ifcvf_mdev_get_vq_state(struct mdev_device *mdev, u16 
>>>>>> qid)
>>>>>> +{
>>>>>> +    struct ifcvf_adapter *adapter = mdev_get_drvdata(mdev);
>>>>>> +    struct ifcvf_hw *vf = IFC_PRIVATE_TO_VF(adapter);
>>>>>> +
>>>>>> +    return vf->vring[qid].last_avail_idx;
>>>>>
>>>>>
>>>>> Does this really work? I'd expect it should be fetched from hw 
>>>>> since it's an internal state.
>>>> for now, it's working, we intend to support LM in next version 
>>>> drivers.
>>>
>>>
>>> I'm not sure I understand here, I don't see any synchronization 
>>> between the hardware and last_avail_idx, so last_avail_idx should 
>>> not change.
>>>
>>> Btw, what did "LM" mean :) ?
>>
>> I can add bar IO operations here, LM = live migration, sorry for the 
>> abbreviation.
>
>
> Just make sure I understand here, I believe you mean reading 
> last_avail_idx through IO bar here?
>
> Thanks

Hi Jason,

Yes, I mean last_avail_idx. is that correct?

THanks

>
>
