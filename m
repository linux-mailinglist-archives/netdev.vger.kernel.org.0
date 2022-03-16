Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B234DB524
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357323AbiCPPrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352264AbiCPPrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:47:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5374E6D386
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:46:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E605061714
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 15:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BBAC340EC;
        Wed, 16 Mar 2022 15:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647445568;
        bh=HctEDQkZ0pL5bpoCyG4iIZ50b1SOm+vQIqttChd2+sc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Jxf7aXiLqsR5T9jfVNxAQOIj9CluH8YHUzLgONAp58tU0HBZ1K8s+TaerpZc6rc8o
         ATcWfC9u0vxr/NiPNvcDIJH4WTBrMp4xKmuP2SaLhu+L/1Tl4vNHTKaHf21rWDio/E
         OsblrMi/kHJJLfYW3WzqjyNwGZzN6P+86V7Ljh3Zd/MLKZwyJ+h0AYy03aKMYUP/QK
         TC0ObedScSw0M30My7jrWYo2413i4/zPDH+TM+CDZ/bUOsTIlIZso/GR1kZvRuWDxS
         X9+gsLiDiMMAIJT3pjnZFdueIeT2+SBBao87vo4X3YfT6NwhdP50SLa4I5b6cwCgGW
         n9H90feu1KHbQ==
Message-ID: <00b3dad7-91a9-3c4b-604b-a6de3f54dc1e@kernel.org>
Date:   Wed, 16 Mar 2022 09:46:06 -0600
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
 <DM8PR12MB54007D9DEE61331CE6F1118FAB109@DM8PR12MB5400.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <DM8PR12MB54007D9DEE61331CE6F1118FAB109@DM8PR12MB5400.namprd12.prod.outlook.com>
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

On 3/15/22 5:35 AM, Eli Cohen wrote:
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
> 
> I guess I could define a macro here if all the flags would start with "VIRTIO_F_ =" but unfortunately,
> the first two flags don't follow this pattern.
> I could send kernel patches to replace VIRTIO_RING_F_INDIRECT_DESC and
> VIRTIO_RING_F_EVENT_IDX to VIRTIO_F_RING_INDIRECT_DESC and VIRTIO_F_RING_EVENT_IDX
> and then fix the format here.
> 
> If you meant something else, please be more specific.

It can still work with the existing naming - it's the redundant use of
VIRTIO_TRANSPORT_F_START as an offset that is hidden by the macro
allowing the feature to string conversion to be easier to read.
