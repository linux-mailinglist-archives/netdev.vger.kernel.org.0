Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F005B59586B
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbiHPKeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbiHPKdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:33:44 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CC6DE87;
        Tue, 16 Aug 2022 01:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660639569; x=1692175569;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Bsu56Gzf+TtQ+H67xUX2fUZWh0JRIEI4iTCwIle76sE=;
  b=Byk0utprSfXI0aaNx5QXDmu6bwV9Ds8RQrSG0LX1RvwshKTGInRZ2rCq
   DZYEHKYVGH4XWKVblwLuzapDrUaXF26OpmYIZnNFkUljoK176LWmbzBiV
   656lCmbskVBGKddsFnTcbERGs42eF+HeAMSGnpR+aiUD75NHZeTsiPgKx
   XDCTuPzLFIrl6ly3Nk91oU8EifW1dJo9atyWq3TPiWiBb5kbcB0ZdaOOa
   ngTuveWkEShQFlFxbS71ZN8e9ZtF+AuwsS7HYbFSAaNHHdVdmUtEAcGjJ
   VPIbq4d3w4qQ9Zj3s+vCLVGdgnx6DKOPevXwap5WC7wv4Lyj9aRDEI+Zl
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="279125369"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="279125369"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 01:46:09 -0700
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="667018922"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.29.22]) ([10.255.29.22])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 01:46:06 -0700
Message-ID: <e678154f-3a51-0f0a-423d-db39ac98be5d@intel.com>
Date:   Tue, 16 Aug 2022 16:46:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH V5 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com, jasowang@redhat.com
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
 <20220812104500.163625-5-lingshan.zhu@intel.com>
 <e99e6d81-d7d5-e1ff-08e0-c22581c1329a@oracle.com>
 <f2864c96-cddd-129e-7dd8-a3743fe7e0d0@intel.com>
 <20220816044007-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220816044007-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/2022 4:41 PM, Michael S. Tsirkin wrote:
> On Tue, Aug 16, 2022 at 04:29:04PM +0800, Zhu, Lingshan wrote:
>>
>> On 8/16/2022 3:41 PM, Si-Wei Liu wrote:
>>
>>      Hi Michael,
>>
>>      I just noticed this patch got pulled to linux-next prematurely without
>>      getting consensus on code review, am not sure why. Hope it was just an
>>      oversight.
>>
>>      Unfortunately this introduced functionality regression to at least two
>>      cases so far as I see:
>>
>>      1. (bogus) VDPA_ATTR_DEV_NEGOTIATED_FEATURES are inadvertently exposed and
>>      displayed in "vdpa dev config show" before feature negotiation is done.
>>      Noted the corresponding features name shown in vdpa tool is called
>>      "negotiated_features" rather than "driver_features". I see in no way the
>>      intended change of the patch should break this user level expectation
>>      regardless of any spec requirement. Do you agree on this point?
>>
>> I will post a patch for iptour2, doing:
>> 1) if iprout2 does not get driver_features from the kernel, then don't show
>> negotiated features in the command output
>> 2) process and decoding the device features.
>>
>>
>>      2. There was also another implicit assumption that is broken by this patch.
>>      There could be a vdpa tool query of config via vdpa_dev_net_config_fill()->
>>      vdpa_get_config_unlocked() that races with the first vdpa_set_features()
>>      call from VMM e.g. QEMU. Since the S_FEATURES_OK blocking condition is
>>      removed, if the vdpa tool query occurs earlier than the first
>>      set_driver_features() call from VMM, the following code will treat the
>>      guest as legacy and then trigger an erroneous vdpa_set_features_unlocked
>>      (... , 0) call to the vdpa driver:
>>
>>       374         /*
>>       375          * Config accesses aren't supposed to trigger before features
>>      are set.
>>       376          * If it does happen we assume a legacy guest.
>>       377          */
>>       378         if (!vdev->features_valid)
>>       379                 vdpa_set_features_unlocked(vdev, 0);
>>       380         ops->get_config(vdev, offset, buf, len);
>>
>>      Depending on vendor driver's implementation, L380 may either return invalid
>>      config data (or invalid endianness if on BE) or only config fields that are
>>      valid in legacy layout. What's more severe is that, vdpa tool query in
>>      theory shouldn't affect feature negotiation at all by making confusing
>>      calls to the device, but now it is possible with the patch. Fixing this
>>      would require more delicate work on the other paths involving the cf_lock
>>      reader/write semaphore.
>>
>>      Not sure what you plan to do next, post the fixes for both issues and get
>>      the community review? Or simply revert the patch in question? Let us know.
>>
>> The spec says:
>> The device MUST allow reading of any device-specific configuration field before
>> FEATURES_OK is set by
>> the driver. This includes fields which are conditional on feature bits, as long
>> as those feature bits are offered
>> by the device.
>>
>> so whether FEATURES_OK should not block reading the device config space.
>> vdpa_get_config_unlocked() will read the features, I don't know why it has a
>> comment:
>>          /*
>>           * Config accesses aren't supposed to trigger before features are set.
>>           * If it does happen we assume a legacy guest.
>>           */
>>
>> This conflicts with the spec.
> Yea well. On the other hand the spec also calls for features to be
> used to detect legacy versus modern driver.
> This part of the spec needs work generally.
so from what I see, there are no race conditions, if features 
negotiation not done,
just assume the driver features are all zero, then return the device 
config space contents.
It can do this even without this comment.

Please help correct me if I misunderstand these

Thanks
Zhu Lingshan
>
>
>> vdpa_get_config_unlocked() checks vdev->features_valid, if not valid, it will
>> set the drivers_features 0, I think this intends to prevent reading random
>> driver_features. This function does not hold any locks, and didn't change
>> anything.
>>
>> So what is the race?
>>
>> Thanks
>>
>>
>>
>>      Thanks,
>>      -Siwei
>>
>>
>>      On 8/12/2022 3:44 AM, Zhu Lingshan wrote:
>>
>>          Users may want to query the config space of a vDPA device,
>>          to choose a appropriate one for a certain guest. This means the
>>          users need to read the config space before FEATURES_OK, and
>>          the existence of config space contents does not depend on
>>          FEATURES_OK.
>>
>>          The spec says:
>>          The device MUST allow reading of any device-specific configuration
>>          field before FEATURES_OK is set by the driver. This includes
>>          fields which are conditional on feature bits, as long as those
>>          feature bits are offered by the device.
>>
>>          Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>          ---
>>            drivers/vdpa/vdpa.c | 8 --------
>>            1 file changed, 8 deletions(-)
>>
>>          diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>>          index 6eb3d972d802..bf312d9c59ab 100644
>>          --- a/drivers/vdpa/vdpa.c
>>          +++ b/drivers/vdpa/vdpa.c
>>          @@ -855,17 +855,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev,
>>          struct sk_buff *msg, u32 portid,
>>            {
>>                u32 device_id;
>>                void *hdr;
>>          -    u8 status;
>>                int err;
>>                  down_read(&vdev->cf_lock);
>>          -    status = vdev->config->get_status(vdev);
>>          -    if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>          -        NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>>          completed");
>>          -        err = -EAGAIN;
>>          -        goto out;
>>          -    }
>>          -
>>                hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
>>                          VDPA_CMD_DEV_CONFIG_GET);
>>                if (!hdr) {
>>
>>
>>
>>

