Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCA80179CC6
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 01:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388484AbgCEAYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 19:24:05 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39108 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388407AbgCEAYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 19:24:05 -0500
Received: by mail-pl1-f193.google.com with SMTP id j20so1413036pll.6
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 16:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=jM+dxWT2By9fogMP6Nyu2wPsp7hyky7qMkBcc2E+Y7M=;
        b=3PflFeor4xeV0DKPa32OkIWGUeuE0LNf75Bx4a6OgMPQychT/+1d8LcjDR/dAQehjU
         JCVO4RZvLabxXlGYf02W3bTUfgd0yDJyhMySkVLpco/TdCicTsPG2ab4OabkIjUbdQo0
         IVK1UfBlFvv/iDmAC6s1ucIHnsp2y2LBarBCedmPhUC9072F0/Xi/ONIpj0Dy3m1FZMW
         5HHZxkDm7VWQ5/jcIgcS/C9XV62Zii7+QsB+QA31TkN7GI5MrFytKg+kLOLpg5mGiTRS
         pQd8TNtGSDmPnyi1XQINVGmp+A6XDgUGGEQTALMjvqtVHQosFm3g+oRkvFYuGCCNme7U
         6QBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jM+dxWT2By9fogMP6Nyu2wPsp7hyky7qMkBcc2E+Y7M=;
        b=N11t054dCLA/YUsFgY6e3uzXsDmQKS6YD8msoin1ZaKUSUHRTe1i40A3qCNa3Ks/A8
         s3cA3cD3Dz6hiUE0SuWOF0ImDGxBlMRaGYSqW0sdvJn08+gjyQJlX8BbAlokQHJkJh5y
         t9eGucI0GTi/Gy3kdYB4dd57zWd0VaF1hgbOpH+n4xh9V128ALw63OyO2kU4ez1CwrKf
         wXj3GJEWJJ5q22K/VdROePnDN4CD1cBiAV3hzV5Pw/6u3T/6CmlGNsNF2Ok6LAkAm0Wp
         2F7dFwDp3XZxVoQ41UCHXh+wIKJ15I9tM9mKOgW0n/tz3lDXl3pyj7/rpY5vgtfsnQHG
         KHBA==
X-Gm-Message-State: ANhLgQ2XlgrqA5MQUMhQddpnBo+pQLh3kRZcOPFCuxA478MAJmakOta0
        FE48Si9aAWNy4Ood2q5YxLbkxqHIHsY=
X-Google-Smtp-Source: ADFU+vt00Uwz0FV5rnxbJt2NP8KluYY/iq0C+9EMJplEmXoY0K7ZR45BbAfkafa9sqKuRWQAZAlj3A==
X-Received: by 2002:a17:90a:246a:: with SMTP id h97mr5515182pje.9.1583367843593;
        Wed, 04 Mar 2020 16:24:03 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id x18sm18014349pfo.148.2020.03.04.16.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 16:24:03 -0800 (PST)
Subject: Re: [PATCH v2 net-next 5/8] ionic: support ethtool rxhash disable
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20200304042013.51970-1-snelson@pensando.io>
 <20200304042013.51970-6-snelson@pensando.io>
 <20200304115902.011ff647@kicinski-fedora-PC1C0HJN>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <39446ac7-9ce1-1c81-427b-a9821145fd1d@pensando.io>
Date:   Wed, 4 Mar 2020 16:24:01 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200304115902.011ff647@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/20 11:59 AM, Jakub Kicinski wrote:
> On Tue,  3 Mar 2020 20:20:10 -0800 Shannon Nelson wrote:
>> We can disable rxhashing by setting rss_types to 0.  The user
>> can toggle this with "ethtool -K <ethX> rxhash off|on",
>> which calls into the .ndo_set_features callback with the
>> NETIF_F_RXHASH feature bit set or cleared.  This patch adds
>> a check for that bit and updates the FW if necessary.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic_lif.c | 11 +++++++++--
>>   1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> index d1567e477b1f..4b953f9e9084 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> @@ -1094,6 +1094,7 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
>>   	u64 vlan_flags = IONIC_ETH_HW_VLAN_TX_TAG |
>>   			 IONIC_ETH_HW_VLAN_RX_STRIP |
>>   			 IONIC_ETH_HW_VLAN_RX_FILTER;
>> +	u64 old_hw_features;
>>   	int err;
>>   
>>   	ctx.cmd.lif_setattr.features = ionic_netdev_features_to_nic(features);
>> @@ -1101,9 +1102,13 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
>>   	if (err)
>>   		return err;
>>   
>> +	old_hw_features = lif->hw_features;
>>   	lif->hw_features = le64_to_cpu(ctx.cmd.lif_setattr.features &
>>   				       ctx.comp.lif_setattr.features);
>>   
>> +	if ((old_hw_features ^ lif->hw_features) & IONIC_ETH_HW_RX_HASH)
>> +		ionic_lif_rss_config(lif, lif->rss_types, NULL, NULL);
> Is this change coming from the HW or from ethtool? AFAIK hw_features
> are what's supported, features is what's enabled..

This is looking at the feature bits coming in from ndo_set_features - if 
the RX_HASH bit has been turned off in the incoming features bitmask, 
then I need to disable the hw hashing.

I believe the confusion is between lif->hw_features, describing what is 
currently enabled in the hw, versus the netdev->hw_features, that is 
what we've told the the stack we have available.

sln

