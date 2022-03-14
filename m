Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA5E4D88AB
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241966AbiCNQBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242845AbiCNQBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:01:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304A545056
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:00:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCB7BB80DBF
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 16:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB987C340E9;
        Mon, 14 Mar 2022 16:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647273606;
        bh=pFa2HUfTQAdkXnUndbg2wOTtQ7zxf9NOqSOQZvdNKTc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=LT6CBGGXMNiStxRV3WZz95FalmaSjcdaao7daHWkpRWtL+nDgZ0dl0yJJDa8dYZ1e
         aUei1rkIPHKpVGrnTtUSxvVr6m0qiKFj5es60Gb78Lu1JIa6PVMQJcklkl39P6CevX
         NGlcMnROk4X+BCXki7KHhaQ4FPrV7r6UePpl5nfvm1rm0JdeCw4HV+PW1tl/ReJzUX
         CekNexWph+EIgGP/yXme7zAQoi0QYDbN0Yx+r08wEi86IHFvZjvwA3eHU4ZWQEfOKA
         WwSF9RqUxsDJGwQv5m+My0a2NaVfmrp9uInbCCbtgGfKhDTT1IpkQnZhQ2OYrOzrTS
         leCjM5/fsZNmA==
Message-ID: <e32671f6-287e-69aa-6146-d5ddac239313@kernel.org>
Date:   Mon, 14 Mar 2022 10:00:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v7 2/4] vdpa: Allow for printing negotiated features of a
 device
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@nvidia.com>
References: <20220313171219.305089-1-elic@nvidia.com>
 <20220313171219.305089-3-elic@nvidia.com>
 <22fe6d6c-d665-e4ee-9e16-04010b184a98@kernel.org>
 <DM8PR12MB540062ECB8F8FD32B99A421EAB0F9@DM8PR12MB5400.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <DM8PR12MB540062ECB8F8FD32B99A421EAB0F9@DM8PR12MB5400.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/22 9:34 AM, Eli Cohen wrote:
>> @@ -403,9 +403,9 @@ static const char *parse_class(int num)
>>  }
>>
>>  static const char * const net_feature_strs[64] = {
>> -       [VIRTIO_NET_F_CSUM] = "CSUM",
>> -       [VIRTIO_NET_F_GUEST_CSUM] = "GUEST_CSUM",
>> -       [VIRTIO_NET_F_CTRL_GUEST_OFFLOADS] = "CTRL_GUEST_OFFLOADS",
>> +       [VIRTIO_NET_F_CSUM]                     = "CSUM",
>> +       [VIRTIO_NET_F_GUEST_CSUM]               = "GUEST_CSUM",
>> +       [VIRTIO_NET_F_CTRL_GUEST_OFFLOADS]      = "CTRL_GUEST_OFFLOADS",
>> ...
>>
>>
>>> +};
>>> +
>>> +#define VIRTIO_F_IN_ORDER 35
>>> +#define VIRTIO_F_NOTIFICATION_DATA 38
>>> +#define VDPA_EXT_FEATURES_SZ (VIRTIO_TRANSPORT_F_END - \
>>> +			      VIRTIO_TRANSPORT_F_START + 1)
>>> +
>>> +static const char * const ext_feature_strs[VDPA_EXT_FEATURES_SZ] = {
>>> +	[VIRTIO_RING_F_INDIRECT_DESC - VIRTIO_TRANSPORT_F_START] = "RING_INDIRECT_DESC",
>>> +	[VIRTIO_RING_F_EVENT_IDX - VIRTIO_TRANSPORT_F_START] = "RING_EVENT_IDX",
>>> +	[VIRTIO_F_VERSION_1 - VIRTIO_TRANSPORT_F_START] = "VERSION_1",
>>> +	[VIRTIO_F_ACCESS_PLATFORM - VIRTIO_TRANSPORT_F_START] = "ACCESS_PLATFORM",
>>> +	[VIRTIO_F_RING_PACKED - VIRTIO_TRANSPORT_F_START] = "RING_PACKED",
>>> +	[VIRTIO_F_IN_ORDER - VIRTIO_TRANSPORT_F_START] = "IN_ORDER",
>>> +	[VIRTIO_F_ORDER_PLATFORM - VIRTIO_TRANSPORT_F_START] = "ORDER_PLATFORM",
>>> +	[VIRTIO_F_SR_IOV - VIRTIO_TRANSPORT_F_START] = "SR_IOV",
>>> +	[VIRTIO_F_NOTIFICATION_DATA - VIRTIO_TRANSPORT_F_START] = "NOTIFICATION_DATA",
>>
>> and the entries here should be a macro to handle the
>> VIRTIO_TRANSPORT_F_START  offset with column aligned strings.
>>
> Do you mean define a new macro for each line above?
> I could align them nicely without new macros while being confined to column 88.
> 

VIRTIO_TRANSPORT_F_START is redundant on each line; a macro can be used
to hide that and simplifies each line.
