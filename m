Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6842E12CA57
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 19:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfL2S1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 13:27:42 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43931 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfL2S1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 13:27:42 -0500
Received: by mail-qk1-f196.google.com with SMTP id t129so24949469qke.10
        for <netdev@vger.kernel.org>; Sun, 29 Dec 2019 10:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fDYXZ0VQV9GRmyxFVste1F8uuEThz/v7xEooekXhh6U=;
        b=PZ7E1q9OAusQa2mTnGqAl+3ByaDNnMcsSVJuCUdUp4HgMplkTr81GMHx48NxuoQwvi
         Txl/Xq9c2ycOiS/lZ2/lY7Xq8hHqncMiiLxAr+aI4bGXyVNUklN03gmM7ZivIqpylukK
         E+aFOxKu5R6hFNu5SUZ8i9WmGOS2sG8J8lEmxZgGiHEPRAtPsQ74F5pk2iNqF9A0mRJw
         SSnT6IJoql2yONa99C+b3y0Mlv9N38TBG+h0xn5pQHjA6A8r4T54FH6SymML4Vd2oIKs
         z989ndyaUtKbM8aKa2E9Yn7TPyLuvoi40mtvoQyrTe39KdGRMALHFVOu5hJgp2y2cPHR
         YORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fDYXZ0VQV9GRmyxFVste1F8uuEThz/v7xEooekXhh6U=;
        b=C8WkVsx1uSGW+baS8FAKBtYacOc2I8xQB6JgQkDIsujgILY9dOsV5NHPcvPHGWng2k
         4VXVlWnXlaEF2ySMuIIvWCfB+WvRbXMVeESP1/M/Xm52UH3BXJohGd+sOcXShDTT9P/Y
         ukshxn54WRz4A1Pf377dHVmTNMELHPpwK6wxsHOTzr53XeMag0bk9sFIdEC1wBI5ZbAA
         jKIBN9yu7MDZvXfjv7qSIQL04UBUTQW9iMCm+W293gYRqb9dLlUkICtUi5KoLJe41UKp
         CGISwnMX9MUD6c2sut+2rQ4Jpq9kMljaeWE5UwOFPWIH4sdQpa9IWuUEAjURtIEChX3e
         1PQg==
X-Gm-Message-State: APjAAAUf0Z0DMa+DyjOAcX5Ry8p09sJm84RbO2sjOkixJK4kTS3LCHvZ
        9XeaEu1HSNN1gxEh3CmgzftHOg==
X-Google-Smtp-Source: APXvYqyuvlW6zO2v2sYYYH8nA+FoPyZko4TL1XVm5pZ1YYeHFMPNbNqe34lueG9hwdHvyRPjetnE7g==
X-Received: by 2002:a05:620a:1102:: with SMTP id o2mr50354326qkk.278.1577644061540;
        Sun, 29 Dec 2019 10:27:41 -0800 (PST)
Received: from [192.168.43.235] ([204.48.95.253])
        by smtp.googlemail.com with ESMTPSA id i90sm12904808qtd.49.2019.12.29.10.27.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Dec 2019 10:27:40 -0800 (PST)
Subject: Re: [PATCH net] net/sched: add delete_empty() to filters and use it
 in cls_flower
To:     Vlad Buslov <vladbu@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
References: <3f0b159cd943476d4beb8106b5a1405d050ec392.1577546059.git.dcaratti@redhat.com>
 <vbfd0c7gh1d.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <58ddffbd-240e-8b2b-7162-1d9a8f7d6973@mojatatu.com>
Date:   Sun, 29 Dec 2019 13:27:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <vbfd0c7gh1d.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-29 12:47 p.m., Vlad Buslov wrote:
> 
> On Sat 28 Dec 2019 at 17:36, Davide Caratti <dcaratti@redhat.com> wrote:
>> Revert "net/sched: cls_u32: fix refcount leak in the error path of
>> u32_change()", and fix the u32 refcount leak in a more generic way that
>> preserves the semantic of rule dumping.
>> On tc filters that don't support lockless insertion/removal, there is no
>> need to guard against concurrent insertion when a removal is in progress.
>> Therefore, for most of them we can avoid a full walk() when deleting, and
>> just decrease the refcount, like it was done on older Linux kernels.
>> This fixes situations where walk() was wrongly detecting a non-empty
>> filter, like it happened with cls_u32 in the error path of change(), thus
>> leading to failures in the following tdc selftests:
>>
>>   6aa7: (filter, u32) Add/Replace u32 with source match and invalid indev
>>   6658: (filter, u32) Add/Replace u32 with custom hash table and invalid handle
>>   74c2: (filter, u32) Add/Replace u32 filter with invalid hash table id
>>
>> On cls_flower, and on (future) lockless filters, this check is necessary:
>> move all the check_empty() logic in a callback so that each filter
>> can have its own implementation. For cls_flower, it's sufficient to check
>> if no IDRs have been allocated.
>>
>> This reverts commit 275c44aa194b7159d1191817b20e076f55f0e620.
>>
>> Changes since v1:
>>   - document the need for delete_empty() when TCF_PROTO_OPS_DOIT_UNLOCKED
>>     is used, thanks to Vlad Buslov
>>   - implement delete_empty() without doing fl_walk(), thanks to Vlad Buslov
>>   - squash revert and new fix in a single patch, to be nice with bisect
>>     tests that run tdc on u32 filter, thanks to Dave Miller
>>
>> Fixes: 275c44aa194b ("net/sched: cls_u32: fix refcount leak in the error path of u32_change()")
>> Fixes: 6676d5e416ee ("net: sched: set dedicated tcf_walker flag when tp is empty")
>> Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
>> Suggested-by: Vlad Buslov <vladbu@mellanox.com>
>> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
>> ---
> 
> Thanks again, Davide!
> 
> Reviewed-by: Vlad Buslov <vladbu@mellanox.com>

Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

