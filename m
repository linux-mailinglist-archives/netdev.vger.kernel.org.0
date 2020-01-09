Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D807135338
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 07:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgAIGee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 01:34:34 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43825 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgAIGed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 01:34:33 -0500
Received: by mail-pg1-f195.google.com with SMTP id k197so2710342pga.10;
        Wed, 08 Jan 2020 22:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GVy9ZX82il8rnt/XZi7GqePMgkXxk/SfAJn85xxuOAE=;
        b=hVfmYyVSUH+swuOCcSl/QwGOF3XBYxFJgOcEUSnX6dBehMctXwDNV1ipFUztPlvM39
         Ua0XY5Iim0iQILvberAfBybLwfxqZbVvInkFqkac5gpx34OqDFIDmLrhBuGAq9Vpv9Zx
         nXaZY9FgDqeynp6qG1HujxkfoHF1jJljjl/p1eNYBwwfVLV7dOLBRRIrjcwZSuW0lw4B
         IxVRSxWXZscrrBYi0Gprp6Mz+rujVlsPewXocBVIcoMn1fWz3iaKTLwx3o5sOY/ZUdfT
         tNa2hXM2tHjIJZG194fOg5MJInEYrAuVE5IR7auauDXLZEIcWGFKVIDyhikN9BoWrAyN
         VLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GVy9ZX82il8rnt/XZi7GqePMgkXxk/SfAJn85xxuOAE=;
        b=fR3OO0pm2yyqxYfjmCZDfGE9jqV5ME4wZuBHXYDb8e1t0jW+i4cfh1e7dT3bg+3GYC
         rTcxKyjy0fc4QTmngxnMSg7Q/xMhPX5Gt94kzPsgNDzIvsZfRQ0OP9mXt7Hm3e/NlqIN
         KcXM0SV78Ev3pmTy+J4UBGfr2stpFPxqDR9YnLQYcyBAEzbXJaA0eZurzj7faTsaBZ2/
         V++pWioE1qdIuZkN08fWB0iAwXYarigbELVc79SWiYEyKeT9Tx83+F200ph7klA62Bzs
         WKTniIuOdjGkT40JGgCrOV7z3arsekBopopKQsvs6Wj0tbnM+t1PxzA7N9XU51q7KjsJ
         5KtA==
X-Gm-Message-State: APjAAAUbgVtfLFVtwcoOlKs+O6sB/UDxM1+N8OE8maxLoEU9xcP77BQM
        3mY9ihR0RnCiGob5Oh/qxpo=
X-Google-Smtp-Source: APXvYqyPY1+o3Blinv0w494jM8LgBmPD1Ig1zdZcmisKIQ3btHKjKIITRAOJScwn87K9YijFPBRWgw==
X-Received: by 2002:a63:d157:: with SMTP id c23mr9538973pgj.242.1578551672952;
        Wed, 08 Jan 2020 22:34:32 -0800 (PST)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id m3sm5936316pfh.116.2020.01.08.22.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 22:34:32 -0800 (PST)
Subject: Re: [bpf PATCH 2/2] bpf: xdp, remove no longer required
 rcu_read_{un}lock()
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>, bjorn.topel@gmail.com,
        bpf@vger.kernel.org, toke@redhat.com
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
References: <157851907534.21459.1166135254069483675.stgit@john-Precision-5820-Tower>
 <157851930654.21459.7236323146782270917.stgit@john-Precision-5820-Tower>
 <a4bb8f06-f960-cdda-f73a-8b87744445af@gmail.com>
Message-ID: <0c5f827f-1b39-c850-f450-171c1a6e92b9@gmail.com>
Date:   Thu, 9 Jan 2020 15:34:10 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a4bb8f06-f960-cdda-f73a-8b87744445af@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/01/09 15:01, Toshiaki Makita wrote:
> On 2020/01/09 6:35, John Fastabend wrote:
>> Now that we depend on rcu_call() and synchronize_rcu() to also wait
>> for preempt_disabled region to complete the rcu read critical section
>> in __dev_map_flush() is no longer relevant.
>>
>> These originally ensured the map reference was safe while a map was
>> also being free'd. But flush by new rules can only be called from
>> preempt-disabled NAPI context. The synchronize_rcu from the map free
>> path and the rcu_call from the delete path will ensure the reference
>> here is safe. So lets remove the rcu_read_lock and rcu_read_unlock
>> pair to avoid any confusion around how this is being protected.
>>
>> If the rcu_read_lock was required it would mean errors in the above
>> logic and the original patch would also be wrong.
>>
>> Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
>> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
>> ---
>>   kernel/bpf/devmap.c |    2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> index f0bf525..0129d4a 100644
>> --- a/kernel/bpf/devmap.c
>> +++ b/kernel/bpf/devmap.c
>> @@ -378,10 +378,8 @@ void __dev_map_flush(void)
>>       struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
>>       struct xdp_bulk_queue *bq, *tmp;
>> -    rcu_read_lock();
>>       list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
>>           bq_xmit_all(bq, XDP_XMIT_FLUSH);
>> -    rcu_read_unlock();
> 
> I introduced this lock because some drivers have assumption that
> .ndo_xdp_xmit() is called under RCU. (commit 86723c864063)
> 
> Maybe devmap deletion logic does not need this anymore, but is it
> OK to drivers?

More references for the driver problem:
- Lockdep splat in virtio_net: https://lists.openwall.net/netdev/2019/04/24/282
- Discussion for fix: https://lists.openwall.net/netdev/2019/04/25/234

Toshiaki Makita
