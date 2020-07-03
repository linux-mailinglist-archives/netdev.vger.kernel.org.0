Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD10213B85
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 16:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgGCOKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 10:10:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28524 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726035AbgGCOKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 10:10:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593785417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ebRijBQATYSDEWCLKpsWiFDOCYjmt1IWcFHzoBixqE=;
        b=PwnEfosBLio2RBufcCp3J435duoXtVNQ4qZztufStRWSFAn+P8ZRWrBQHFr8MhLVAl29TI
        UuHUzhx5djwAxwH25CahW2wMTYvBNi/xhgzmWBIua4DNCTki66FN92rDSUeO7EkJNzCpwS
        j/c+VOUKpL18sO8+7oAzNJhl6CTucA8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-eAvyyTRcOs-FPATbToD2mw-1; Fri, 03 Jul 2020 10:10:13 -0400
X-MC-Unique: eAvyyTRcOs-FPATbToD2mw-1
Received: by mail-wm1-f69.google.com with SMTP id e15so35003630wme.8
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 07:10:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/ebRijBQATYSDEWCLKpsWiFDOCYjmt1IWcFHzoBixqE=;
        b=jHkDTeFUlHxTCTg8UJ6Fd/aol4V7nsO27Q4nYj5lWHUzPsYhWuY+jvPzoSdn8toBjW
         g2wiLxdNESqI8UhOMt4WJu9xspyRpAGdsyCYsLfI4GG3sDIml1vs/WzZMWV3GNMYe2aj
         iVnMePSYErDHYZExOqZQMwbQvBg4gbap0UgWePgMXl29uHlbLVrpbQtvarq5NrFsJazK
         T2x0sxWX47Gio7c4evlCOYMX6XIC+dky58U4wbX9L2T8f+rKoKkn/t9gV6vBO08OdL5e
         h40G1EEDGOP3q3Lkogd7t72k80G2w1d/8S7WxWPGaVlQ3SQYf++R6xPHpCeJMZesFpea
         g44w==
X-Gm-Message-State: AOAM533URdaR6rZNYBujJOwzhIN4p30f7Y1zETaXsy3BEKUd9s6+LosF
        94lGd9rXZwRCJSu2fNTnAUU62ocN7t96AtDj7Ih1AJcnZgRThtMbd+8UeocWWVtqe0qc9sq+l/f
        M+1nToy0L+0KTQal0
X-Received: by 2002:a5d:6987:: with SMTP id g7mr36631629wru.79.1593785411823;
        Fri, 03 Jul 2020 07:10:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHX6Bp00bVK6KVzpUCW97N/dOtpfkG/01UM49qTtOjIlbCNVkIjoyz9PaR1xMKn2ZgfcDwug==
X-Received: by 2002:a5d:6987:: with SMTP id g7mr36631597wru.79.1593785411546;
        Fri, 03 Jul 2020 07:10:11 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id e8sm14420110wrp.26.2020.07.03.07.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 07:10:10 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: expose firmware config files through modinfo
To:     Matthias Brugger <matthias.bgg@gmail.com>,
        Matthias Brugger <mbrugger@suse.com>, matthias.bgg@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Double Lo <double.lo@cypress.com>,
        Frank Kao <frank.kao@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Saravanan Shanmugham <saravanan.shanmugham@cypress.com>,
        brcm80211-dev-list@cypress.com, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Soeren Moch <smoch@web.de>
References: <20200701153123.25602-1-matthias.bgg@kernel.org>
 <338e3cff-dfa0-c588-cf53-a160d75af2ee@redhat.com>
 <1013c7e6-f1fb-af0c-fe59-4d6cd612f959@suse.com>
 <35066b13-9fe2-211d-2ba8-5eb903b46bf7@redhat.com>
 <ba8c2bfa-3f50-512e-e28c-a47896e5c242@gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <bb56e702-3d4c-a089-0499-de79cb6db879@redhat.com>
Date:   Fri, 3 Jul 2020 16:10:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <ba8c2bfa-3f50-512e-e28c-a47896e5c242@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 7/3/20 4:01 PM, Matthias Brugger wrote:
> 
> 
> On 02/07/2020 20:00, Hans de Goede wrote:
>> Hi,
>>
>> On 7/1/20 5:46 PM, Matthias Brugger wrote:
>>> Hi Hans,
>>>
>>> On 01/07/2020 17:38, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 7/1/20 5:31 PM, matthias.bgg@kernel.org wrote:
>>>>> From: Matthias Brugger <mbrugger@suse.com>
>>>>>
>>>>> Apart from a firmware binary the chip needs a config file used by the
>>>>> FW. Add the config files to modinfo so that they can be read by
>>>>> userspace.
>>>>
>>>> The configfile firmware filename is dynamically generated, just adding the list
>>>> of all currently shipped ones is not really helpful and this is going to get
>>>> out of sync with what we actually have in linux-firmware.
>>>
>>> I'm aware of this, and I agree.
>>>
>>>>
>>>> I must honestly say that I'm not a fan of this, I guess you are trying to
>>>> get some tool which builds a minimal image, such as an initrd generator
>>>> to add these files to the image ?
>>>>
>>>
>>> Yes exactly.
>>>
>>>> I do not immediately have a better idea, but IMHO the solution
>>>> this patch proposes is not a good one, so nack from me for this change.
>>>>
>>>
>>> Another path we could go is add a wildcard string instead, for example:
>>> MODULE_FIRMWARE("brcm/brcmfmac43455-sdio.*.txt");
>>
>> I was thinking about the same lines, but I'm afraid some user-space
>> utils may blow up if we introduce this, which is why I did not suggest
>> it in my previous email.
>>
>>> AFAIK there is no driver in the kernel that does this. I checked with our dracut
>>> developer and right now dracut can't cope with that.
>>
>> Can't cope as in tries to add "/lib/firmware/brcm/brcmfmac43455-sdio.*.txt"
>> and then skips it (as it does for other missing firmware files); or can't
>> cope as in blows-up and aborts without leaving a valid initrd behind.
>>
>> If is the former, that is fine, if it is the latter that is a problem.
>>
>>> But he will try to
>>> implement that in the future.
>>>
>>> So my idea was to maintain that list for now and switch to the wildcard approach
>>> once we have dracut support that.
>>
>> So lets assume that the wildcard approach is ok and any initrd tools looking at
>> the MODULE_FIRMWARE metadata either accidentally do what we want; or fail
>> gracefully.  Then if we temporarily add the long MODULE_FIRMWARE list now, those
>> which fail gracefully will start doing the right thing (except they add too
>> much firmware), and later on we cannot remove all the non wildcard
>> MODULE_FIRMWARE list entries because that will cause a regression.
>>
>> Because of this I'm not a fan of temporarily fixing this like this. Using wifi
>> inside the initrd is very much a cornercase anyways, so I think users can
>> use a workaround by dropping an /etc/dracut.conf.d file adding the necessary
>> config file for now.
>>
>> As for the long run, I was thinking that even with regular firmware files
>> we are adding too much firmware to host-specific initrds since we add all
>> the firmwares listed with MODULE_FIRMWARE, and typically only a few are
>> actually necessary.
>>
>> We could modify the firmware_loader code under drivers/base/firmware_loader
>> to keep a list of all files loaded since boot; and export that somewhere
>> under /sys, then dracut could use that list in host-only mode and we get
>> a smaller initrd. One challenge with this approach though is firmware files
>> which are necessary for a new kernel, but not used by the running kernel ...
>> I'm afraid I do not have a good answer to that.
>>
> 
> That would work for creating a new minimal initrd from a working image. But it
> would not help in bootstrapping an image. My understanding is that for
> bootstrapping an image we will need to support wildcards in MODULE_FIRMWARE()
> strings.

Yes, I agree.

Regards,

Hans

