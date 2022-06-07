Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D745453F667
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 08:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiFGGlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 02:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiFGGlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 02:41:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73DDABE70
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 23:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654584082; x=1686120082;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mPNylM0b97dKCYSkb3R2KQTV9TIEZZKBlqOt6QgB9ak=;
  b=WKRorV1SZV60gjAuePNr9ePy/6Oe4brkQFh9FBSeRLV6unozIDaJTHac
   CJZRnJR96obEjwKW/4h8zuH2VtxQoG4uxaI55NPeNAHZ4DmQv+trigQCw
   XoNAeJcbWJb2wnrRxBaxV7z2nWTVmrbalYZD7cG0SlkmeuzI16CRvM/rG
   vGLB8sOaU76iAM4EcUTNuaUCYZlsXNNLaaFziXSliHmTKxxUvTaKu2K3U
   f3JxpttFM2/hwkMayGRrVThOMuN7wCg1gk25bgLcVrQg85xyALjTURK8V
   Zu/iLOx3vliMqZ8m8/Et/bDhbJk/8FHJrqJebNtO4adtpdDcgg37G1SFP
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="302070749"
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="302070749"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 23:41:22 -0700
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="635975578"
Received: from jiayuwu-mobl.ccr.corp.intel.com (HELO [10.254.208.112]) ([10.254.208.112])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 23:41:21 -0700
Message-ID: <627678bf-e79a-a745-7b10-3e70d88fe71d@intel.com>
Date:   Tue, 7 Jun 2022 14:41:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH 6/6] vDPA: fix 'cast to restricted le16' warnings in
 vdpa_dev_net_config_fill()
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
References: <20220602023845.2596397-1-lingshan.zhu@intel.com>
 <20220602023845.2596397-7-lingshan.zhu@intel.com>
 <CACGkMEtS6W8wXdrXbQuniZ-ox1WsCAc1UQHJGD=J4PViviQYpA@mail.gmail.com>
 <054679a9-16ed-6cf6-ba8d-037aedc29357@intel.com>
 <CACGkMEvGidNuYJ6Lww7CgAAx8Es7UvoDNfwDB_pJY7b0W3U6cQ@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEvGidNuYJ6Lww7CgAAx8Es7UvoDNfwDB_pJY7b0W3U6cQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2022 2:15 PM, Jason Wang wrote:
> On Mon, Jun 6, 2022 at 4:22 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>>
>>
>> On 6/2/2022 3:40 PM, Jason Wang wrote:
>>> On Thu, Jun 2, 2022 at 10:48 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>>> This commit fixes spars warnings: cast to restricted __le16
>>>> in function vdpa_dev_net_config_fill()
>>>>
>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> ---
>>>>    drivers/vdpa/vdpa.c | 4 ++--
>>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>>>> index 50a11ece603e..2719ce9962fc 100644
>>>> --- a/drivers/vdpa/vdpa.c
>>>> +++ b/drivers/vdpa/vdpa.c
>>>> @@ -837,11 +837,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>>>                       config.mac))
>>>>                   return -EMSGSIZE;
>>>>
>>>> -       val_u16 = le16_to_cpu(config.status);
>>>> +       val_u16 = le16_to_cpu((__force __le16)config.status);
>>> Can we use virtio accessors like virtio16_to_cpu()?
>> I will work out a vdpa16_to_cpu()
> I meant __virtio16_to_cpu(true, xxx) actually here.
sure, this can work!
>
> Thanks
>
>> Thanks,
>> Zhu Lingshan
>>> Thanks
>>>
>>>>           if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>>>>                   return -EMSGSIZE;
>>>>
>>>> -       val_u16 = le16_to_cpu(config.mtu);
>>>> +       val_u16 = le16_to_cpu((__force __le16)config.mtu);
>>>>           if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>>                   return -EMSGSIZE;
>>>>
>>>> --
>>>> 2.31.1
>>>>

