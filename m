Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746A82B8435
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgKRSz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgKRSz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 13:55:29 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8181C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 10:55:27 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id i8so1981578pfk.10
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 10:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=2rWHxwjMfp8Hxzi/MLGKN8KYlEQO725SpWmmpYh5b68=;
        b=VlnqDToaaMoXc3XwlquVYwIjifC5+CGSyQvviLjWoj5ClMtuRfxIYLeLqf3qxAqwjC
         PAEJbtFSCP1wbk2mygoutpM+bVNQtavldHn2IL61g/CVDPLJ4YICaoOyA7cD9Z+S2Z4J
         tWncTP7JOsOS16Jdfqqs/B1HXPYjhZ19+M3pd6tPZMUQKAeolNY0QiW0Kq+FP3Gg+9U1
         S9hHySm/kMdxO1y6B7U67Zrfl2V8rD2DxEQKrOsajS6+yjHD0tzjRdXfz8iQby/WzAdB
         UpdpXLparBvJXVIdDzSuHbQ5mZ4JI1w8TNPVx2eU/SmuuCnEt8ALjyKyHWpNRLE0qOQM
         qEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2rWHxwjMfp8Hxzi/MLGKN8KYlEQO725SpWmmpYh5b68=;
        b=Nn4833gslWPizmuLQKdIVlXIliZPNvNkfpbEghDYnr206rDUL+TyMl14og9Tq0zAbq
         MURPhgQwpwMCL7m5PIDdvEo7uN+582SV0oKEwer88b04ZvaI8EXBT2OhOhrM8xvbkQYp
         aNNTmQ/BEpJL3+XRVkCCXK+KDM3ggxcrh6biSnPUbdZHAwoKBFB5FgdQ9OP01izk7TRI
         vWThEPzC2GBXvArDjfQSMuHVqHbu1wAlCDJnXQrya0aCzVzln8XY3WpKGNjcyk8X0MYQ
         4QcJ9hU5x/DDuK+gzy5hi2ASq9vZfu/02OSoge8YTu7D+/KGakPGPQ8hh5pAbXCuEEYA
         0kGQ==
X-Gm-Message-State: AOAM531KCAGQc0I+4rH6yZ2xtyCZ+x7fpl6BfVkp8CsXWDywvINHXZOJ
        cigoucTaa5neQF2+/O2RWNZd9NExTGMxUA==
X-Google-Smtp-Source: ABdhPJzvPMOv/aY3o9dUe/eYRaX9XmUkpA+WycGIOPAschHSmxqEtkjCyiUgLQRWCJgAg2fAqBB3BA==
X-Received: by 2002:a63:e146:: with SMTP id h6mr9775451pgk.0.1605725727413;
        Wed, 18 Nov 2020 10:55:27 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id p15sm3253351pjv.44.2020.11.18.10.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 10:55:26 -0800 (PST)
Subject: Re: [net-next v2 PATCH] devlink: move request_firmware out of driver
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>, Jakub Kicinksi <kuba@kernel.org>
References: <20201113224559.3910864-1-jacob.e.keller@intel.com>
 <9eb7ce31-c9a6-5775-cb3f-9f1f2e7f98a7@pensando.io>
 <0371781e-f411-e78e-be6d-971e8989d6ba@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <4109cfe1-abb1-9f67-d93b-fee062a5bfbb@pensando.io>
Date:   Wed, 18 Nov 2020 10:55:25 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <0371781e-f411-e78e-be6d-971e8989d6ba@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/20 10:52 AM, Jacob Keller wrote:
> On 11/13/2020 3:48 PM, Shannon Nelson wrote:
>> On 11/13/20 2:45 PM, Jacob Keller wrote:
>>> -int ionic_firmware_update(struct ionic_lif *lif, const char *fw_name,
>>> +int ionic_firmware_update(struct ionic_lif *lif, const struct firmware *fw,
>>>    			  struct netlink_ext_ack *extack)
>>>    {
>>>    	struct ionic_dev *idev = &lif->ionic->idev;
>>> @@ -99,24 +99,15 @@ int ionic_firmware_update(struct ionic_lif *lif, const char *fw_name,
>>>    	struct ionic *ionic = lif->ionic;
>>>    	union ionic_dev_cmd_comp comp;
>>>    	u32 buf_sz, copy_sz, offset;
>>> -	const struct firmware *fw;
>>>    	struct devlink *dl;
>>>    	int next_interval;
>>>    	int err = 0;
>>>    	u8 fw_slot;
>>>    
>>> -	netdev_info(netdev, "Installing firmware %s\n", fw_name);
>>> -
>> I prefer keeping the chatty little bits like this for debug purposes,
>> but if you're going to remove it, then you should remove the matching
>> netdev_info "Firmware update completed" message a few lines before the
>> release_firmware().
>>
>> Aside from that, for the ionic bits:
>> Acked-by: Shannon Nelson <snelson@pensando.io>
>>
>> Thanks,
>> sln
>>
> So the only reason I removed this is because the function no longer has
> access to the fw_name string. I'll change it to just remove the %s
> format string.

Thanks,
sln

