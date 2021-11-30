Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817E1462D0E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 07:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbhK3Gtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 01:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238795AbhK3Gtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 01:49:50 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D75C061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 22:46:31 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso18682806wms.2
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 22:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=LzJx9B5J5YCMo0+jcW4XuMxWHO3fVt1lRlFh2TM0Dlg=;
        b=n3Ve/Lz+xSlrT/M3/fkhpQImIi9oKnNhAAQDzSwpxxbeW59lPwmuWqMRLezjJBJeER
         7CvnX2Wobp3vboWKp4E6Q1wZhekCaO865QBrw+vi4CXj+rSEBxUwYC2BSb7apAUTYRo2
         v2QHhoqAi+TYckTDBD/xcJivpl9RGT6sKSova6txOOhz3QhOBSqvdHDiHql3UP1byR6Z
         FWQKR5OF3AJlJlbeYBV6SPZZMgyCongo2rRW97sl7MCx9Qxu8rFv02hQgqwBbnCkve/y
         p0iNykJvvJ2JSXB0xJiHsCV8gDCAmPaCz/iie8kjj7ptSu652DOCmP1rpc1oiJnVHuxE
         qHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=LzJx9B5J5YCMo0+jcW4XuMxWHO3fVt1lRlFh2TM0Dlg=;
        b=CJJyGajuG+K69xtu8zYbYm2MtndJBLgLoLdvwv27AKfTbqXMAefljUSOqZSU2XmWTO
         oqxrsRnoMWDRz11UMGG4d93pTrVAS+WG3bPM+3c59XFdQbRMKKp5QwK6UJAFOsNAalwp
         R5DvV5yrc9lTGndnWnt3JOotjVnt7xxw5XMEymWoSc4UkEIhNpeRW2m24tQlGc9YaFHS
         5Y+i9MArzke+pr8/DIxTeRKFtUdClGyAX1cS1I5DxJnO0YmN0IEFiQP3uc1HJClZ5bdq
         f7sqAlcQJuyaUtiHc6qJuHSCabLFyR3BR45zCUW9lkKnaq3sb7RWIJcjH3id7z008YE9
         o1Pg==
X-Gm-Message-State: AOAM530SVkqmLfIKvNLGfV2++FWSc7oQ41pgRyy/HOHqL/DoEJPanQI3
        j9erkh5+V7mnB2I5RIal2w7PEQqa5gI=
X-Google-Smtp-Source: ABdhPJzAefBjUQ3MuEcdl5eDxfsc6LNK9HjDgg3QAtFqjbMXauD1oX1dPrdgT5RoCjEF5YR3tf1Gwg==
X-Received: by 2002:a05:600c:4e8d:: with SMTP id f13mr2836514wmq.7.1638254790421;
        Mon, 29 Nov 2021 22:46:30 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:982e:c052:6f5c:d61f? (p200300ea8f1a0f00982ec0526f5cd61f.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:982e:c052:6f5c:d61f])
        by smtp.googlemail.com with ESMTPSA id e24sm11547125wra.78.2021.11.29.22.46.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 22:46:30 -0800 (PST)
Message-ID: <5675a5ef-5aa0-3f05-1c44-a91ce90d5f38@gmail.com>
Date:   Tue, 30 Nov 2021 07:33:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
References: <6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com>
 <20211129150920.4a400828@hermes.local>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] igb: fix deadlock caused by taking RTNL in RPM resume
 path
In-Reply-To: <20211129150920.4a400828@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.11.2021 00:09, Stephen Hemminger wrote:
> On Mon, 29 Nov 2021 22:14:06 +0100
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
>> index dd208930f..8073cce73 100644
>> --- a/drivers/net/ethernet/intel/igb/igb_main.c
>> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
>> @@ -9254,7 +9254,7 @@ static int __maybe_unused igb_suspend(struct device *dev)
>>  	return __igb_shutdown(to_pci_dev(dev), NULL, 0);
>>  }
>>  
>> -static int __maybe_unused igb_resume(struct device *dev)
>> +static int __maybe_unused __igb_resume(struct device *dev, bool rpm)
>>  {
>>  	struct pci_dev *pdev = to_pci_dev(dev);
>>  	struct net_device *netdev = pci_get_drvdata(pdev);
>> @@ -9297,17 +9297,24 @@ static int __maybe_unused igb_resume(struct device *dev)
>>  
>>  	wr32(E1000_WUS, ~0);
>>  
>> -	rtnl_lock();
>> +	if (!rpm)
>> +		rtnl_lock();
>>  	if (!err && netif_running(netdev))
>>  		err = __igb_open(netdev, true);
>>  
>>  	if (!err)
>>  		netif_device_attach(netdev);
>> -	rtnl_unlock();
>> +	if (!rpm)
>> +		rtnl_unlock();
>>  
>>  	return err;
>>  }
>>  
>> +static int __maybe_unused igb_resume(struct device *dev)
>> +{
>> +	return __igb_resume(dev, false);
>> +}
>> +
>>  static int __maybe_unused igb_runtime_idle(struct device *dev)
>>  {
>>  	struct net_device *netdev = dev_get_drvdata(dev);
>> @@ -9326,7 +9333,7 @@ static int __maybe_unused igb_runtime_suspend(struct device *dev)
>>  
>>  static int __maybe_unused igb_runtime_resume(struct device *dev)
>>  {
>> -	return igb_resume(dev);
>> +	return __igb_resume(dev, true);
>>  }
> 
> Rather than conditional locking which is one of the seven deadly sins of SMP,
> why not just have __igb_resume() be the locked version where lock is held by caller?
> 
In this case we'd have to duplicate quite some code from igb_resume().
Even more simple alternative would be to remove RTNL from igb_resume().
Then we'd remove RTNL from RPM and system resume path. Should be ok as well.
I just didn't want to change two paths at once.
