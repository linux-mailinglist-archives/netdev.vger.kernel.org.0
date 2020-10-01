Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A530327F95D
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 08:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbgJAGO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 02:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgJAGO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 02:14:58 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EDDC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 23:14:57 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ce10so207762ejc.5
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 23:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UdcOfTHfLZEJpEE43SX+CQqD/Ib5FqNIxPdAwFhjQmI=;
        b=FLyuEgHn/clr4bHC9eNqP7kRORJlh+Pt3DZ+XC9QZi3T1sMqmvqeG3ecu1Hejckp8a
         MYzcJ7oofYKoG4/Q5bi545m9lrSiyeOVazTf9x+dIMUJOrb07ZiHws6dVkGgzxAwEKVj
         HGmXtsp8mjIgZWl/9+3ugE2yKzviGelHVgAR98BBoiDoLyH8M9aL1b3VNuzLmzuN3NEv
         i5agcSU5e+nNkZ+OSjrUS8YDhhCbZp907ISmEwBZvXTjCAhBrsIvZsI2Kb7ovZ+RPK8l
         50H0kfWhBso8MuUCxYHGzXBnRLJDzays8SIlVI3OW4aTvr7rTR0hjoqqlb7yTgCvFiLv
         puKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UdcOfTHfLZEJpEE43SX+CQqD/Ib5FqNIxPdAwFhjQmI=;
        b=qzXv7x+SaJoqWQjhjpF49ahVaYDGlD6y9pbiqz21mDPo++FTtM7tBnL9gySgaMX29b
         IMS5j2yvNwomuZ4qQ0KxyJg7tyqeaVAzWOu2caA0YgRCon4EfZF8VzvpX+HSHG/p/ZCZ
         B8qGfx/WqcaJYu+goRa4QzxpaEo0c6kA0tnvS187wLIsY+RH6RE/sdbobXCvjhbFpXE+
         Nt+VWPkAIHEKuw0ONlX/3pQo0zZG621L6aFRzTYLsfNnVTlIOIcP8ZgsJwDxZwJeNeHT
         1zDzEHnYwyYujSoDlxzlkyKUQB2vooU27In4v8dXsZNhb3gEGd9fsgPcElxDHg0PHpKI
         m7DQ==
X-Gm-Message-State: AOAM533aoGY5HVDjrx32M7qiuWjYttjjjAwg4QpPA6292cakAmnlYWAs
        hsgE8uWefYwaQfK0wrxN0HQw3zvYxks=
X-Google-Smtp-Source: ABdhPJw50ktXqEk8XfkouKged5LLaqwJJt97GlNIXq7kDANxc09XVlc9i1mZhjqFZLJxJ550/Hwmfg==
X-Received: by 2002:a17:906:7e4e:: with SMTP id z14mr6370559ejr.477.1601532895302;
        Wed, 30 Sep 2020 23:14:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:758b:d2db:8faf:4c9e? (p200300ea8f006a00758bd2db8faf4c9e.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:758b:d2db:8faf:4c9e])
        by smtp.googlemail.com with ESMTPSA id r20sm1747243edw.51.2020.09.30.23.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 23:14:54 -0700 (PDT)
Subject: Re: RTL8402 stops working after hibernate/resume
To:     Petr Tesarik <ptesarik@suse.cz>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
 <20200903104122.1e90e03c@ezekiel.suse.cz>
 <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
 <20200924211444.3ba3874b@ezekiel.suse.cz>
 <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
 <20200925093037.0fac65b7@ezekiel.suse.cz>
 <20200925105455.50d4d1cc@ezekiel.suse.cz>
 <aa997635-a5b5-75e3-8a30-a77acb2adf35@gmail.com>
 <20200925115241.3709caf6@ezekiel.suse.cz>
 <20200925145608.66a89e73@ezekiel.suse.cz>
 <30969885-9611-06d8-d50a-577897fcab29@gmail.com>
 <20200929210737.7f4a6da7@ezekiel.suse.cz>
 <217ae37d-f2b0-1805-5696-11644b058819@redhat.com>
 <5f2d3d48-9d1d-e9fe-49bc-d1feeb8a92eb@gmail.com>
 <1c2d888a-5702-cca9-195c-23c3d0d936b9@redhat.com>
 <8a82a023-e361-79db-7127-769e4f6e0d1b@gmail.com>
 <20200930184124.68a86b1d@ezekiel.suse.cz>
 <20200930193231.205ee7bd@ezekiel.suse.cz>
 <20200930200027.3b512633@ezekiel.suse.cz>
 <2e91f3b7-b675-e117-2200-e97b089e9996@gmail.com>
 <20200930234407.0ce0b6d9@ezekiel.suse.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <ddd3794e-c5e3-29a5-475c-2ab8b2d2425e@gmail.com>
Date:   Thu, 1 Oct 2020 08:14:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200930234407.0ce0b6d9@ezekiel.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.2020 23:44, Petr Tesarik wrote:
> On Wed, 30 Sep 2020 22:11:02 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> On 30.09.2020 20:00, Petr Tesarik wrote:
>> [...]
>>> WoL still does not work on my laptop, but this might be an unrelated
>>> issue, and I can even imagine the BIOS is buggy in this regard.
>>>   
>> A simple further check you could do:
>> After sending the WoL packet (that doesn't wake the system) you wake
>> the system by e.g. a keystroke. Then check in /proc/interrupts for
>> a PCIe PME interrupt. If there's a PME interrupt, then the network
>> chip successfully detected the WoL packet, and it seems we have to
>> blame the BIOS.
> 
> Well, the switch does not sense carrier on the corresponding port while
> the laptop is suspended, so I'm pretty sure nothing gets delivered over
> that link. No, I suspect the ACPI suspend method turns off the RTL8208
> PHY chip, maybe as a side effect...
> 
Did you configure WoL explicitly, e.g. with ethtool -s <if> wol g ?

> But I don't need working WoL on this system - look, this is cheap old
> stuff that the previous owner considered electronic waste. I even
> suspect this was because wired network never worked well after resume.
> With your fix, this piece can still serve some purpose.
> 
Great, I will submit the fixes today.

> Thank you!
> 
> Petr T
> 
Heiner
