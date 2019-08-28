Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2719F8B8
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 05:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfH1D1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 23:27:03 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44416 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfH1D1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 23:27:03 -0400
Received: by mail-pg1-f193.google.com with SMTP id i18so590390pgl.11
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 20:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=dp3fvaSUqn4zfaaVSdQwvyJ3m7aUeS30xK2FKHVLrNo=;
        b=CBwKwnePPRBb6MdTDbLBrThdakBJ6ggsidIWKNLpxl/ihkKutq4Ow1F2Rw/1Rf9nz7
         IWDu4T4O1Gbo5bMe9nHt+2XWlbiQZYUvfKUWRd0VlPI1JY5z0eiWmq8mzEKv9Y5XcIKE
         H8IFViViXeVa7WMypLwzmmnTnh5pp1ot34eaGvFKV7l2IkmZNC5qcS5o+VoU2Gi1oPfu
         CbrQ0Hm3FJlbps0kTTc+ygEmos0QPcJXW4tbnEue294Un0GAviUCTDRPGP3xYI5QcH2X
         hemKwPhBiK2XhkSkMr92Wd2z5O+5t956EZ0AqkGxALhFOYbKm/vYAe46cGpxDwbHgIlI
         8F7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dp3fvaSUqn4zfaaVSdQwvyJ3m7aUeS30xK2FKHVLrNo=;
        b=I6j+kgsfg0K8g8v8Phy2ziG7O3OFrE5CriOSfxYkBeGqqAkmDGgWkY6zJgihdXGeyl
         g/wU518Z9SP8fIliSSUsZS7b6+6JTP3Ry2QCC9MI7+iSbZ4ZxAKGXN1HPqb6txjDIQRp
         zHhHrBrkojnpLY5BuLSCXI+loKxY8jpVQnII96GOlRhxlGxb6uCIlrmXCOG5rRVDaYoU
         8qhBQvRxsjrOg9jBqNTs8kE44VipCogkP/ZO6AHXrCmDnnemzl+PBOpQxwS84b4cVNVw
         36BeunkHkQ9ZVGHb3HIxN1XcWE5jtNwMLsXlFNWyWibNym5r03CnEc1jTzWMJb6U7Oqx
         5ehQ==
X-Gm-Message-State: APjAAAXJ3088qirNZH9vP5IVT2KH2aQNZegOxrEhomyeenH2S/9G43lk
        birkt2XClXvSUXYAjnUicCrP7aT+h9s=
X-Google-Smtp-Source: APXvYqw/Vn46mishmlTtdPcm14rxpJCv5gO0UWJKgff//y9qNrz0CQB9UHfcpAo2z6LKtMyo2VsmAQ==
X-Received: by 2002:a63:ec03:: with SMTP id j3mr1605797pgh.325.1566962822221;
        Tue, 27 Aug 2019 20:27:02 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id w2sm605466pjr.27.2019.08.27.20.27.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 20:27:01 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 02/18] ionic: Add hardware init and device
 commands
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190826213339.56909-1-snelson@pensando.io>
 <20190826213339.56909-3-snelson@pensando.io>
 <20190826212404.77348857@cakuba.netronome.com>
 <a2ed5049-14c6-749c-9a9b-f826d9a88cb0@pensando.io>
 <20190827201646.2befe6c3@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <93a16cf5-b8a2-8915-4190-b81607058eb2@pensando.io>
Date:   Tue, 27 Aug 2019 20:26:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827201646.2befe6c3@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/27/19 8:16 PM, Jakub Kicinski wrote:
> On Tue, 27 Aug 2019 14:22:55 -0700, Shannon Nelson wrote:
>>>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>>>> index e24ef6971cd5..1ca1e33cca04 100644
>>>> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>>>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>>>> @@ -11,8 +11,28 @@
>>>>    static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
>>>>    			     struct netlink_ext_ack *extack)
>>>>    {
>>>> +	struct ionic *ionic = devlink_priv(dl);
>>>> +	struct ionic_dev *idev = &ionic->idev;
>>>> +	char buf[16];
>>>> +
>>>>    	devlink_info_driver_name_put(req, IONIC_DRV_NAME);
>>>>    
>>>> +	devlink_info_version_running_put(req,
>>>> +					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
>>>> +					 idev->dev_info.fw_version);
>>> Are you sure this is not the FW that controls the data path?
>> There is only one FW rev to report, and this covers mgmt and data.
> Can you add a key for that? Cause this one clearly says management..

Perhaps something like this?

/* Overall FW version */
#define DEVLINK_INFO_VERSION_GENERIC_FW    "fw"


>> Since I don't have any board info available at this point, shall I use
>> my own "asic.id" and "asic.rev" strings, or in this patch shall I add
>> something like this to devlink.h and use them here:
>>
>> /* Part number, identifier of asic design */
>> #define DEVLINK_INFO_VERSION_GENERIC_ASIC_ID    "asic.id"
>> /* Revision of asic design */
>> #define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV    "asic.rev"
> Yes, please add these to the generic items and document appropriately.

Sure.  Is there any place besides 
Documentation/networking/devlink-info-versions.rst?

sln


