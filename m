Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9C62B8430
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgKRSwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:52:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:30616 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbgKRSwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 13:52:30 -0500
IronPort-SDR: 6b4KRnFSdaUpK3D09IbfK5//d0PocXBiYRi6xsCLpJa8M7MEifzfeDZEVrn3FqqkfzXTHGtP/K
 mBpeqfvHquJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="150436231"
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="150436231"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 10:52:28 -0800
IronPort-SDR: kkSH3ue2ERDJaf5Vhbl/D6NNY3SUSkb31Yu0tlM4r6ojDJ/d/VJ6YR7fBtILZaNlQiJkiETJnl
 KY0BQ8mtglpQ==
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="534443787"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.69.244]) ([10.212.69.244])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 10:52:25 -0800
Subject: Re: [net-next v2 PATCH] devlink: move request_firmware out of driver
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>, Jakub Kicinksi <kuba@kernel.org>
References: <20201113224559.3910864-1-jacob.e.keller@intel.com>
 <9eb7ce31-c9a6-5775-cb3f-9f1f2e7f98a7@pensando.io>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <0371781e-f411-e78e-be6d-971e8989d6ba@intel.com>
Date:   Wed, 18 Nov 2020 10:52:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <9eb7ce31-c9a6-5775-cb3f-9f1f2e7f98a7@pensando.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/13/2020 3:48 PM, Shannon Nelson wrote:
> On 11/13/20 2:45 PM, Jacob Keller wrote:
>> -int ionic_firmware_update(struct ionic_lif *lif, const char *fw_name,
>> +int ionic_firmware_update(struct ionic_lif *lif, const struct firmware *fw,
>>   			  struct netlink_ext_ack *extack)
>>   {
>>   	struct ionic_dev *idev = &lif->ionic->idev;
>> @@ -99,24 +99,15 @@ int ionic_firmware_update(struct ionic_lif *lif, const char *fw_name,
>>   	struct ionic *ionic = lif->ionic;
>>   	union ionic_dev_cmd_comp comp;
>>   	u32 buf_sz, copy_sz, offset;
>> -	const struct firmware *fw;
>>   	struct devlink *dl;
>>   	int next_interval;
>>   	int err = 0;
>>   	u8 fw_slot;
>>   
>> -	netdev_info(netdev, "Installing firmware %s\n", fw_name);
>> -
> 
> I prefer keeping the chatty little bits like this for debug purposes, 
> but if you're going to remove it, then you should remove the matching 
> netdev_info "Firmware update completed" message a few lines before the 
> release_firmware().
> 
> Aside from that, for the ionic bits:
> Acked-by: Shannon Nelson <snelson@pensando.io>
> 
> Thanks,
> sln
> 

So the only reason I removed this is because the function no longer has
access to the fw_name string. I'll change it to just remove the %s
format string.
