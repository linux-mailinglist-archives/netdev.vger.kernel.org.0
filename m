Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EE91C244D
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 11:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgEBJTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 05:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgEBJTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 05:19:21 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0674EC061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 02:19:20 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k18so7193755ion.0
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 02:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B3nnnQAf8Ty/XcylsZpczGWC+Yx77mQlkEfBvrolNLE=;
        b=h+v1zreSTJnWKgVi6nAoaCXQ+0lLxRmTKnXgGUVVNoZ6pQ/9p1qsIBNc5wApuDs41d
         rDsGMqtjovYOBFk2tFmTBV+W5CFEt104qcntisZj1/ALUGmMzk4uzOQ70q7ID0drZ0mv
         dMiA/HFR+YBlXH92OS4nEMHIh0x0J6bkVjaGqAHPf69byhx0Rn3AkwiCcuMkHt+6s/Fa
         YBw63zewPUcyQsSoL1bTvx7dluKENbqjLXLDbjkUNgrUrI0A3WkUab8yRafPZ0NopZ45
         6jPMelNBZE1p+GM2/sSclh+BiubujAC1chVINxubGgU8Q5z4+9AfR3i9eHNtv2jJhhrP
         pfwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B3nnnQAf8Ty/XcylsZpczGWC+Yx77mQlkEfBvrolNLE=;
        b=I2ztJxjLbqhk7cXY/WpJJNIsvp/Q8546AJ2aSQXSvlBXei75KucpP8G8kZwwLxMVRa
         BI5CjqslkBCEkd4gy5AxOnqLL4j9Tduf/5vbLwqf77j2S50QcqenlmbW7ygh3U9yFAdK
         zqlKszWNOu8U+SjTcBymghGNfKfWweTMuQvlNoLkPWlhJy65MEMVmflxY4MrhrM04ojL
         hUQFkYUCjTz0dqjxkVEooIM/ilXNwMTL35diQCfBMyVSsNUWGNPyIXc9sdzjiUqv5M13
         KPig+mH2g4RF/W+xOoJn0ljG5KSJx89+0BtEsGm9tqBkM7DedasBliA5E5HULIriwCi0
         EmHQ==
X-Gm-Message-State: AGi0PuZvtikfO3h/vZhyacKf3yhYPrWMpHNaSI5+Xb7z41SHDcUU0EQr
        loOFb2PPZaWyfbCLNhTTe2M52VPvfZTQ/g==
X-Google-Smtp-Source: APiQypIngqpg8m7/vXIv76ba95cTMGW2PSunko0cCFkHTRxYWJwa+urlFCgocnHsuN3bWoKfysSnTQ==
X-Received: by 2002:a6b:a14:: with SMTP id z20mr7385379ioi.182.1588411160208;
        Sat, 02 May 2020 02:19:20 -0700 (PDT)
Received: from [10.0.0.125] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id r16sm2233019ilb.32.2020.05.02.02.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2020 02:19:19 -0700 (PDT)
Subject: Re: [Patch net v2] net_sched: fix tcm_parent in tc filter dump
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>
References: <20200501035349.31244-1-xiyou.wangcong@gmail.com>
 <7b3e8f90-0e1e-ff59-2378-c6e59c9c1d9e@mojatatu.com>
Message-ID: <a18c1d1a-20a1-7346-4835-6163acb4339b@mojatatu.com>
Date:   Sat, 2 May 2020 05:19:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <7b3e8f90-0e1e-ff59-2378-c6e59c9c1d9e@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-02 4:48 a.m., Jamal Hadi Salim wrote:
> On 2020-04-30 11:53 p.m., Cong Wang wrote:

[..]
>> Steps to reproduce this:
>>   ip li set dev dummy0 up
>>   tc qd add dev dummy0 ingress
>>   tc filter add dev dummy0 parent ffff: protocol arp basic action pass
>>   tc filter show dev dummy0 root
>>
>> Before this patch:
>>   filter protocol arp pref 49152 basic
>>   filter protocol arp pref 49152 basic handle 0x1
>>     action order 1: gact action pass
>>      random type none pass val 0
>>      index 1 ref 1 bind 1
>>
>> After this patch:
>>   filter parent ffff: protocol arp pref 49152 basic
>>   filter parent ffff: protocol arp pref 49152 basic handle 0x1
>>       action order 1: gact action pass
>>        random type none pass val 0
>>      index 1 ref 1 bind 1
> 
> Note:
> tc filter show dev dummy0 root
> should not show that filter. OTOH,
> tc filter show dev dummy0 parent ffff:
> should.
> 
> root and ffff: are distinct/unique installation hooks.
> 

Suprised no one raised this earlier - since it is so
fundamental (we should add a tdc test for it). I went back
to the oldest kernel i have from early 2018 and it was broken..

Cong, your patch is good for the case where we
want to show _all_ filters regardless of where they
were installed but only if no parent is specified. i.e if i did this:
tc filter show dev dummy0
then i am asking to see all the filters for that device.
I am actually not sure if "tc filter show dev dummy0"
ever worked that way - but it makes sense since
no dump-filtering is specified.


To illustrate, I did this:
tc filter add dev dummy0 root protocol arp prio 49151 basic action pass

And now the output looks like:
-------
#  tc filter show dev dummy0 ingressfilter protocol arp pref 49151 basic 
chain 0
filter protocol arp pref 49151 basic chain 0 handle 0x2
	action order 1: gact action pass
	 random type none pass val 0
	 index 2 ref 1 bind 1

filter protocol arp pref 49151 basic chain 0 handle 0x1
	action order 1: gact action pass
	 random type none pass val 0
	 index 1 ref 1 bind 1

#  tc filter show dev dummy0 root
filter protocol arp pref 49151 basic chain 0
filter protocol arp pref 49151 basic chain 0 handle 0x2
	action order 1: gact action pass
	 random type none pass val 0
	 index 2 ref 1 bind 1

filter protocol arp pref 49151 basic chain 0 handle 0x1
	action order 1: gact action pass
	 random type none pass val 0
	 index 1 ref 1 bind 1
------



If, OTOH, i specified the parent
then only that parents filters should be displayed..

cheers,
jamal
