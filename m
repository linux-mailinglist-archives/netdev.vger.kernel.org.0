Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B8D3F1C43
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbhHSPKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 11:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbhHSPKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 11:10:39 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997BBC061575;
        Thu, 19 Aug 2021 08:10:02 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id y34so13668058lfa.8;
        Thu, 19 Aug 2021 08:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5Z1QQroQWVoOLfcgLvsMByWTY84xsaRYlR2gMwC7hxk=;
        b=Wph47GNrBXv6xnwCytTIYfUWyrKDGiYMLx8wDAPgogTj5qllaQVxbDbOxvOkVT8wkh
         aBL1oMDTfuf7Dq/rz1FnOavTRnKppZcR0bX/0ZAZSpyqMnCdaMBmS0vnTJykEz3SvsD9
         b7Azv/+91i/9zESgsuaTghrh+WiYQNdhDZtengbdIql+gxY4hhlSD3hSdsdvCsIiw7gV
         ELvQg14IaG4yg1BU+GVRpQJPJjAqO6WdS3aGdrHLyFEKYDpmKWT+i81TutZmpv8HKelY
         9X/NsfshCPQYUmVqEfj57itsP9knmanK5d8v8+ut7AQj1aW5RP+LVP8GiBJQbU9nc9zn
         vf/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Z1QQroQWVoOLfcgLvsMByWTY84xsaRYlR2gMwC7hxk=;
        b=jXCrrkrV+VbM/HE5ACbeBxHputIq4msXVRpZyUUrGNNpe1SnJwlJqZkaP1ZoqOM4+V
         YQcqlzY1ydUzk7cpUD3bNN3zjmpmkWds31NQIq0iL7KgKblHuEfMepuhfCJFXTif9LuD
         Pp0qY5wIbFHc6Yt5soQ6cAGcdZb9IjxEo64yGheoNZtlAya5NtF4AGz51EtZK5Srd6iy
         L3Fjnpo3Qo39T1F3zEmi16T0mucE0ocK9dlrvw8M7qpELBIB+i1iHMNv0bJ5K2QCIKW1
         sVlQFOb+j9gCBcR+Cobq7r9ZpIccrglINyH12W8qmJTe+BVIW9Gk/ghhLM0pbuJGCGdC
         iWWA==
X-Gm-Message-State: AOAM5313/Xzof8pw+mlkq96sgChIsTgoAQ+ZXnoflCQNfTFhdykHRMxr
        88cdy6wpPqg74Ed5Fr5vUN0=
X-Google-Smtp-Source: ABdhPJwgWP38M/SP0uiucvEGNq6+a0txunVlUgBKtt8n9jnpujqJPWVmJzmYr/N0T2dlE19gdvxsFQ==
X-Received: by 2002:a05:6512:2187:: with SMTP id b7mr11146881lft.185.1629385800800;
        Thu, 19 Aug 2021 08:10:00 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.66.127])
        by smtp.gmail.com with ESMTPSA id w12sm332511lfq.277.2021.08.19.08.10.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 08:10:00 -0700 (PDT)
Subject: Re: [PATCH] Bluetooth: add timeout sanity check to hci_inquiry
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com
References: <20210817103108.1160-1-paskripkin@gmail.com>
 <0038C6D9-DEAF-4CB2-874C-00F6CEFCF26C@holtmann.org>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <c3e1a8ca-2ded-f992-a1c3-d144397a7b2a@gmail.com>
Date:   Thu, 19 Aug 2021 18:09:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0038C6D9-DEAF-4CB2-874C-00F6CEFCF26C@holtmann.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/21 6:05 PM, Marcel Holtmann wrote:
> Hi Pavel,
> 
>> 	}
>> 
> 
> 	/* Restrict maximum inquiry length to 60 seconds */
> 	if (ir.length > 60) {
> 		..
> 	}
> 
>> +	if (ir.length > HCI_INQUIRY_MAX_TIMEOUT) {
>> +		err = -EINVAL;
>> +		goto done;
>> +	}
>> +
> 
> I found this easier to read than adding anything define somewhere else. And since this is a legacy interface that is no longer used by bluetoothd, this should be fine. We will start to deprecate this eventually.
> 
> And I prefer 1 minute max time here. Just to be safe.
> 

I thought, that user-space should be aware of maximum value, that's why 
I decided to add this define :) I didn't know, that this interface is 
legacy.

Will fix in v2, thank you!


With regards,
Pavel Skripkin
