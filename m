Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086533E84A4
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 22:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhHJUvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 16:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbhHJUvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 16:51:46 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BC6C0613D3;
        Tue, 10 Aug 2021 13:51:23 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id h13so28064542wrp.1;
        Tue, 10 Aug 2021 13:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k8wUwKYAfeW8YpGTen7YfNvaWVkOnVK/bRd/ObpiUiQ=;
        b=S2nGkOCyGCF5A8BY6FTzqXIWuY4wJY7OjEBJPV4+6SGCA5n1cCHm+GxqBWqjtSZoTz
         Y4qshtLVA6ORWN0Pgy/xQ2WD2qF0LjCGOWOsTB3yUB8q6RPu6NDue99uOTURu5y89fUE
         85/F7J3EvZ6On9Nup4cjRxJT6iWn00r8XUmzjjs+YXZJTvpKtGnkYveW29mRohr6XKr4
         AkqV8rD9IXruvfWfL9uw5wwlERV8N9xsjVbdBfovET7tVkOUo5DuN2y7syMuwvDeDzJb
         r8q+la7t/C1rP87TdYizpCTVnoD9lXMdfS7SfVhA6Bq/e5Dm+FexTL8SrST/n3JAl/wA
         D/rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k8wUwKYAfeW8YpGTen7YfNvaWVkOnVK/bRd/ObpiUiQ=;
        b=ZVtnB70Adr+NftlRibmDH1CwnBC/LzlGaEETlU8x58ehc/3hMKuzwyWNDQSPl4aVCT
         /Eq2U24gz+f5eF0KmcY49NoCBZzLkCsAhZkt+z4NPmWJ3Ngo8L/9hZ9HKjKZ+H+0wX9B
         18Tgo4G63UECTIRaaNRzaHxO0YdyjEE9ZEqf8IvX/fULHKO0UJjbk0Im1hR6b5b+cqTr
         GlGQWPalK6DVMtTEBH/YfHSEqKdyeFl44hYaCaUN0fFF6xOy+tLZ/lYAUd205Z1ax41d
         ea4jwt6euLR3T5PNzeYw1EEXb7yDJ8EM+VMOQmFXL3ZnbqhdRJvdxYNGFv5O78sWzCcn
         +/lw==
X-Gm-Message-State: AOAM533E4KIZBUyBShbulJ755CPPVtCsVgWFW6GkknXXPQeYE6sTD+4E
        sUj7/GG8ixegbc1s+n0W4WM=
X-Google-Smtp-Source: ABdhPJyEBZ2W/QfgGeBitrT8qujpLdVh+ywSfDx9DYtajG7Yhe966Oyx8YhtROwGhlo969hieEaKZg==
X-Received: by 2002:a5d:6052:: with SMTP id j18mr7822639wrt.348.1628628682520;
        Tue, 10 Aug 2021 13:51:22 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:889d:7dc7:8f5e:7029? (p200300ea8f10c200889d7dc78f5e7029.dip0.t-ipconnect.de. [2003:ea:8f10:c200:889d:7dc7:8f5e:7029])
        by smtp.googlemail.com with ESMTPSA id h12sm2399320wmm.29.2021.08.10.13.51.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 13:51:22 -0700 (PDT)
To:     Pavel Machek <pavel@ucw.cz>
Cc:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Michael Walle <michael@walle.cc>, andrew@lunn.ch,
        anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, jacek.anaszewski@gmail.com, kuba@kernel.org,
        kurt@linutronix.de, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vinicius.gomes@intel.com, vitaly.lifshits@intel.com
References: <YP9n+VKcRDIvypes@lunn.ch>
 <20210727081528.9816-1-michael@walle.cc> <20210727165605.5c8ddb68@thinkpad>
 <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
 <20210727172828.1529c764@thinkpad>
 <8edcc387025a6212d58fe01865725734@walle.cc>
 <20210727183213.73f34141@thinkpad>
 <25d3e798-09f5-56b5-5764-c60435109dd2@gmail.com> <20210810172927.GB3302@amd>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <25800302-9c02-ffb2-2887-f0cb23ad1893@gmail.com>
Date:   Tue, 10 Aug 2021 22:46:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810172927.GB3302@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.08.2021 19:29, Pavel Machek wrote:
> Hi!
> 
>>> Yes, this still persists. But we really do not want to start
>>> introducing namespaces to the LED subsystem.
>>
>> Did we come to any conclusion?
>>
>> My preliminary r8169 implementation now creates the following LED names:
>>
>> lrwxrwxrwx 1 root root 0 Jul 26 22:50 r8169-led0-0300 ->
>>> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/r8169-led0-0300
> 
> So "r8159-0300:green:activity" would be closer to the naming we want,

The LED ports in the network chip are multi-function. You can select activity
or link or both. Supposedly renaming the device on function switch is not an
attractive option. Any proposal on how to handle this?

Also the NIC has no clue about the color of the LEDs in the RJ45 port.
Realtek network chips driven by r8169 can be found on basically every
consumer mainboard. Determining LED color would need hundreds of DMI
match entries and would be a maintenance nightmare.
So color would need to be empty?

> but lets not do that, we really want this to be similar to what others
> are doing, and that probably means "ethphy3:green:activity" AFAICT.
> 
A challenge here would be unique numbering if there are multiple
network interfaces with LED support (especially if the interfaces
use different drivers). So the numbering service would have to be
in LED subsystem core or network subsystem core.

> Best regards,
> 								Pavel
> 
