Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279D13BB6B8
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 07:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhGEFUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 01:20:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229773AbhGEFUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 01:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625462292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Budpf1Mgf5nAGlE4gIILC+M5chaMjcLyULIkUSMyGOQ=;
        b=BkUNYsWed1wzX3E+sIHOI6+8qZGh3WdYgCwAHrIRWl85MYt/VIAkfJjUgbxJvmz2RGNqn1
        PMB7WkmHmnbbvzCS1suI5uFj87vGGBl6eDjaLuqOx9BeXft/Z9x/QoekzrnnolQwmOHlEP
        r5mKK9YD8APpbA+Ryq7SbtmGfTttbTI=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-DKGuxth5PYaFyxBbrNw32g-1; Mon, 05 Jul 2021 01:18:11 -0400
X-MC-Unique: DKGuxth5PYaFyxBbrNw32g-1
Received: by mail-ua1-f71.google.com with SMTP id b4-20020ab008440000b029028070c7b794so5921316uaf.5
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 22:18:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Budpf1Mgf5nAGlE4gIILC+M5chaMjcLyULIkUSMyGOQ=;
        b=JYMEBCYXFo1N/iYyd9omfvI8OqqH8/3372B75Tbc3TV7v5v+lFPSQt8c85wYTz1+SW
         HV92LWgNN3ZJ9whOepZfAcCs9Uaja9zow9uUEYRWEXAfx52iu3nXUV6CBBhpBbp+QJfN
         fblFXqgDMoLMlrpRJe5PWkhfoqYnklsEhdqbsLffIvvC7M4u5i/SK4MoTCCpnf0SwmJo
         XToXK4yDLR+g/eaaUzViJ0v1bmGoBT2ynJEIXOq2u9JOUXADg3v4q1F/T0XnIPTgCNh6
         5PqrNdJILuG/Oiw4yxXkREji1k/ZQ3dsUOBh980Mn5/bxlQEuQ/U/CcGWakqoMgdXrkz
         9M4g==
X-Gm-Message-State: AOAM531TL3IkV2X1V3cm8Mw9Lil7lF+QKv5IpSAT2Kx4AB5/rNCoCSD5
        UBloNxaIYjXGs/B9W02O8jYGkdtTxvJZ+yRz0jRnXE2qRltW3JDow8mRMOr0wGra1mKD2IYafsU
        sWeiLbB8lV2bai4V9
X-Received: by 2002:a17:902:650d:b029:129:6334:8c4a with SMTP id b13-20020a170902650db029012963348c4amr9272373plk.20.1625461883503;
        Sun, 04 Jul 2021 22:11:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJCFGroygE7vEijZr/eaDJsT7meM9aLfG/XFfEYs3JYtEA2L8QESskXuh0Yg60Cy5TejmAqA==
X-Received: by 2002:a17:902:650d:b029:129:6334:8c4a with SMTP id b13-20020a170902650db029012963348c4amr9272365plk.20.1625461883324;
        Sun, 04 Jul 2021 22:11:23 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r10sm12442127pga.48.2021.07.04.22.11.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jul 2021 22:11:22 -0700 (PDT)
Subject: Re: [RFC PATCH] vhost-vdpa: mark vhost device invalid to reflect vdpa
 device unregistration
From:   Jason Wang <jasowang@redhat.com>
To:     gautam.dawar@xilinx.com
Cc:     martinh@xilinx.com, hanand@xilinx.com, gdawar@xilinx.com,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210704205205.6132-1-gdawar@xilinx.com>
 <3d02b8f5-0a6b-e8d1-533d-8503da3fcc4e@redhat.com>
Message-ID: <d392646d-c871-8203-ae67-f21db0388380@redhat.com>
Date:   Mon, 5 Jul 2021 13:11:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3d02b8f5-0a6b-e8d1-533d-8503da3fcc4e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/5 上午11:48, Jason Wang 写道:
>
> 在 2021/7/5 上午4:52, gautam.dawar@xilinx.com 写道:
>>       vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> @@ -1091,11 +1122,13 @@ static void vhost_vdpa_remove(struct 
>> vdpa_device *vdpa)
>>           opened = atomic_cmpxchg(&v->opened, 0, 1);
>>           if (!opened)
>>               break;
>> -        wait_for_completion_timeout(&v->completion,
>> -                        msecs_to_jiffies(1000));
>> -        dev_warn_once(&v->dev,
>> -                  "%s waiting for/dev/%s to be closed\n",
>> -                  __func__, dev_name(&v->dev));
>> +        if (!wait_for_completion_timeout(&v->completion,
>> +                        msecs_to_jiffies(1000))) {
>> +            dev_warn(&v->dev,
>> +                 "%s/dev/%s in use, continue..\n",
>> +                 __func__, dev_name(&v->dev));
>> +            break;
>> +        }
>>       } while (1);
>>         put_device(&v->dev);
>> +    v->dev_invalid = true;
>
>
> Besides the mapping handling mentioned by Michael. I think this can 
> lead use-after-free. put_device may release the memory.
>
> Another fundamental issue, vDPA is the parent of vhost-vDPA device. 
> I'm not sure the device core can allow the parent to go away first.


Or this probably means you need couple the fd loosely with the 
vhost-vDPA device.

Thanks


>
> Thanks
>
>

