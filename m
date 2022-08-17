Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2908596986
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 08:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiHQGXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 02:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbiHQGXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 02:23:50 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F2FE01D;
        Tue, 16 Aug 2022 23:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660717428; x=1692253428;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yVbG+n0uGEK9+bGx/SxNj01c0Z0Jil+zP8BYLGKVpck=;
  b=lnWq++7t1A4acphsViqa3uY4qtum5bvGC8GCkEsqlYpMWpyUq1+5VIzp
   NENAU/D4qT3+aooKlY++LPcieKq6LW1xyWSG90hfmQ5m6V+OnIJbewr4e
   8r9UjCo958XOHqDqA7JE7GGEC47LquFzUnIN8w+kLjWzEPPbasldSrcZB
   l5/N2kX36yL42wToZ9IEll3dYzW0TmjQ9uKKIacldpORCfbvGJZS7PlMt
   kVmyZea3CFHL+4YhcSjUd5jAPhBR96iLGKH+0hm7yAi6vXANvZJyVY3uF
   Op4znhaMLmz1ZQF9sZcZa1acXvGKd+cRPEIeRAqjxFGJEugNmDy3RkQz0
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="292411360"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="292411360"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 23:23:47 -0700
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="667465777"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.30.246]) ([10.255.30.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 23:23:44 -0700
Message-ID: <b489413e-e933-e9b6-a719-45090a4e922c@intel.com>
Date:   Wed, 17 Aug 2022 14:23:42 +0800
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
 <2cbec85b-58f6-626f-df4a-cb1bb418fec1@oracle.com>
 <a488a17a-b716-52aa-cc31-2e51f8f972d2@intel.com>
 <20220817021324-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220817021324-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/2022 2:14 PM, Michael S. Tsirkin wrote:
> On Wed, Aug 17, 2022 at 10:11:36AM +0800, Zhu, Lingshan wrote:
>>
>> On 8/17/2022 6:48 AM, Si-Wei Liu wrote:
>>
>>
>>
>>      On 8/16/2022 1:29 AM, Zhu, Lingshan wrote:
>>
>>
>>
>>          On 8/16/2022 3:41 PM, Si-Wei Liu wrote:
>>
>>              Hi Michael,
>>
>>              I just noticed this patch got pulled to linux-next prematurely
>>              without getting consensus on code review, am not sure why. Hope it
>>              was just an oversight.
>>
>>              Unfortunately this introduced functionality regression to at least
>>              two cases so far as I see:
>>
>>              1. (bogus) VDPA_ATTR_DEV_NEGOTIATED_FEATURES are inadvertently
>>              exposed and displayed in "vdpa dev config show" before feature
>>              negotiation is done. Noted the corresponding features name shown in
>>              vdpa tool is called "negotiated_features" rather than
>>              "driver_features". I see in no way the intended change of the patch
>>              should break this user level expectation regardless of any spec
>>              requirement. Do you agree on this point?
>>
>>          I will post a patch for iptour2, doing:
>>          1) if iprout2 does not get driver_features from the kernel, then don't
>>          show negotiated features in the command output
>>
>>      This won't work as the vdpa userspace tool won't know *when* features are
>>      negotiated. There's no guarantee in the kernel to assume 0 will be returned
>>      from vendor driver during negotiation. On the other hand, with the supposed
>>      change, userspace can't tell if there's really none of features negotiated,
>>      or the feature negotiation is over. Before the change the userspace either
>>      gets all the attributes when feature negotiation is over, or it gets
>>      nothing when it's ongoing, so there was a distinction.This expectation of
>>      what "negotiated_features" represents is established from day one, I see no
>>      reason the intended kernel change to show other attributes should break
>>      userspace behavior and user's expectation.
>>
>> User space can only read valid *driver_features* after the features negotiation
>> is done, *device_features* does not require the negotiation.
>>
>> If you want to prevent random values read from driver_features, here I propose
>> a fix: only read driver_features when the negotiation is done, this means to
>> check (status & VIRTIO_CONFIG_S_FEATURES_OK) before reading the
>> driver_features.
>> Sounds good?
>>
>> @MST, if this is OK, I can include this change in my next version patch series.
>>
>> Thanks,
>> Zhu Lingshan
> Sorry I don't get it. Is there going to be a new version? Do you want me
> to revert this one and then apply a new one? It's ok if yes.
Not a new version, it is a new patch, though I still didn't get the race 
condition, but I believe it
is reasonable to block reading the *driver_features* before FEATURES_OK.

So, I added code to check whether _FEATURES_OK is set:

  861         /* only read driver features after the feature negotiation 
is done */
  862         status = vdev->config->get_status(vdev);
  863         if (status & VIRTIO_CONFIG_S_FEATURES_OK) {
  864                 features_driver = 
vdev->config->get_driver_features(vdev);
  865                 if (nla_put_u64_64bit(msg, 
VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
  866                                       VDPA_ATTR_PAD))
  867                 return -EMSGSIZE;
  868         }

If this solution looks good, I will add this patch in my V2 series.

Thanks
Zhu Lingshan

>
>
>>          2) process and decoding the device features.
>>
>>
>>              2. There was also another implicit assumption that is broken by
>>              this patch. There could be a vdpa tool query of config via
>>              vdpa_dev_net_config_fill()->vdpa_get_config_unlocked() that races
>>              with the first vdpa_set_features() call from VMM e.g. QEMU. Since
>>              the S_FEATURES_OK blocking condition is removed, if the vdpa tool
>>              query occurs earlier than the first set_driver_features() call from
>>              VMM, the following code will treat the guest as legacy and then
>>              trigger an erroneous vdpa_set_features_unlocked(... , 0) call to
>>              the vdpa driver:
>>
>>               374         /*
>>               375          * Config accesses aren't supposed to trigger before
>>              features are set.
>>               376          * If it does happen we assume a legacy guest.
>>               377          */
>>               378         if (!vdev->features_valid)
>>               379                 vdpa_set_features_unlocked(vdev, 0);
>>               380         ops->get_config(vdev, offset, buf, len);
>>
>>              Depending on vendor driver's implementation, L380 may either return
>>              invalid config data (or invalid endianness if on BE) or only config
>>              fields that are valid in legacy layout. What's more severe is that,
>>              vdpa tool query in theory shouldn't affect feature negotiation at
>>              all by making confusing calls to the device, but now it is possible
>>              with the patch. Fixing this would require more delicate work on the
>>              other paths involving the cf_lock reader/write semaphore.
>>
>>              Not sure what you plan to do next, post the fixes for both issues
>>              and get the community review? Or simply revert the patch in
>>              question? Let us know.
>>
>>          The spec says:
>>          The device MUST allow reading of any device-specific configuration
>>          field before FEATURES_OK is set by
>>          the driver. This includes fields which are conditional on feature bits,
>>          as long as those feature bits are offered
>>          by the device.
>>
>>          so whether FEATURES_OK should not block reading the device config
>>          space. vdpa_get_config_unlocked() will read the features, I don't know
>>          why it has a comment:
>>                  /*
>>                   * Config accesses aren't supposed to trigger before features
>>          are set.
>>                   * If it does happen we assume a legacy guest.
>>                   */
>>
>>          This conflicts with the spec.
>>
>>          vdpa_get_config_unlocked() checks vdev->features_valid, if not valid,
>>          it will set the drivers_features 0, I think this intends to prevent
>>          reading random driver_features. This function does not hold any locks,
>>          and didn't change anything.
>>
>>          So what is the race?
>>     
>>      You'll see the race if you keep 'vdpa dev config show ...' running in a
>>      tight loop while launching a VM with the vDPA device under query.
>>
>>      -Siwei
>>
>>
>>
>>         
>>          Thanks
>>
>>         
>>
>>              Thanks,
>>              -Siwei
>>
>>
>>              On 8/12/2022 3:44 AM, Zhu Lingshan wrote:
>>
>>                  Users may want to query the config space of a vDPA device,
>>                  to choose a appropriate one for a certain guest. This means the
>>                  users need to read the config space before FEATURES_OK, and
>>                  the existence of config space contents does not depend on
>>                  FEATURES_OK.
>>
>>                  The spec says:
>>                  The device MUST allow reading of any device-specific
>>                  configuration
>>                  field before FEATURES_OK is set by the driver. This includes
>>                  fields which are conditional on feature bits, as long as those
>>                  feature bits are offered by the device.
>>
>>                  Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>                  ---
>>                    drivers/vdpa/vdpa.c | 8 --------
>>                    1 file changed, 8 deletions(-)
>>
>>                  diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>>                  index 6eb3d972d802..bf312d9c59ab 100644
>>                  --- a/drivers/vdpa/vdpa.c
>>                  +++ b/drivers/vdpa/vdpa.c
>>                  @@ -855,17 +855,9 @@ vdpa_dev_config_fill(struct vdpa_device
>>                  *vdev, struct sk_buff *msg, u32 portid,
>>                    {
>>                        u32 device_id;
>>                        void *hdr;
>>                  -    u8 status;
>>                        int err;
>>                          down_read(&vdev->cf_lock);
>>                  -    status = vdev->config->get_status(vdev);
>>                  -    if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>                  -        NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>>                  completed");
>>                  -        err = -EAGAIN;
>>                  -        goto out;
>>                  -    }
>>                  -
>>                        hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family,
>>                  flags,
>>                                  VDPA_CMD_DEV_CONFIG_GET);
>>                        if (!hdr) {
>>
>>
>>
>>
>>
>>
>>
>>

