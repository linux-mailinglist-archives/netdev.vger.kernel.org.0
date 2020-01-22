Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE27145D2A
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 21:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgAVUdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 15:33:21 -0500
Received: from mail-pg1-f169.google.com ([209.85.215.169]:34136 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVUdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 15:33:21 -0500
Received: by mail-pg1-f169.google.com with SMTP id r11so142131pgf.1;
        Wed, 22 Jan 2020 12:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4RP6BcTlBjQVMXjM1GbOC5Sm/jYQcEi+Bbz9d5dA2B0=;
        b=SHddluSyHGBijvAyXP2Hl4SqgWNTFVJat4Eje1NChQ2CFi4qtOgkNm708l8ZIhS7wz
         1mEg6VXWsGVxlJ637VDf1037qp0/lqMa8ArtU132uKr4YWUJiwtpiQdM0VpCkdpdUGtl
         Cmh4dPreds6MkLI8FFjl+dKuHqQzn1k5mFDrWCOTVS3fHl6dORWZwzHJYsyAXvqrJMNu
         Y7lqJv2O5YmZWKuakuybUPb5GIyr7G5yb+e0JZjd1uBAbEiOAcW9cKpir1BID3ZX7MdX
         lq7g4pet5hiSzLNQcxIdbLLGJzihfpW2UgDf+Tva6kLOJVNBEMOFBs2BbD2QT9bny/RZ
         eDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4RP6BcTlBjQVMXjM1GbOC5Sm/jYQcEi+Bbz9d5dA2B0=;
        b=EC1AEQQI6BbR1pZpMEmSh13ifJPl+k1l5aPcVOj7s0g62uR84l+wyjen6IGD/MXaPz
         dAIe2JlPHua/jd8+jdVU0HUTGlN9fxeTThEkgAMHkLhTwZ2jexQrPqb8WyGz5oMgPuus
         gqX6RMChEADfRkK1KJ8pwE75hahcf0tm3S32a5Lb1YhC4yEyhVLsQMiqrBVrB4HREXUo
         MJH+1hxgeF5WG4R1c5R3u3yhj8H0bOUipt3VU1fUfIk+EAYSx6wAtf7PyaieaPcwyEUr
         5yDam+EY75HRR91+A6ySgE3MobydQ2WGZ6KLWHA8uU0s74i3lI4ScD/mg4BEYcgsVaXP
         hZRQ==
X-Gm-Message-State: APjAAAWDBIESDW8H5KjnWrLO8QPRpSlnlPcKeAk7zPU/mhme3S19jaf3
        BneTsf02QjaeGHEPd0wpvQM=
X-Google-Smtp-Source: APXvYqzlV5lkAnjIz1BAKafCf0OTzYSWs59fCfLYXg7BESa+BX/CtvsckclFy7mTfQTBDw4KMt3vFQ==
X-Received: by 2002:aa7:800e:: with SMTP id j14mr4400945pfi.174.1579725200636;
        Wed, 22 Jan 2020 12:33:20 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id fa21sm4353738pjb.17.2020.01.22.12.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 12:33:19 -0800 (PST)
Subject: Re: KASAN: slab-out-of-bounds Read in __nla_put_nohdr
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     syzbot <syzbot+5af9a90dad568aa9f611@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <0000000000006370ef059cabac14@google.com>
 <50239085-ff0f-f797-99af-1a0e58bc5e2e@gmail.com>
 <CAM_iQpXqh1ucVST199c72V22zLPujZy-54p=c5ar=Q9bWNq7OA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7056f971-8fae-ce88-7e9a-7983e4f57bb2@gmail.com>
Date:   Wed, 22 Jan 2020 12:33:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXqh1ucVST199c72V22zLPujZy-54p=c5ar=Q9bWNq7OA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/20 12:27 PM, Cong Wang wrote:
> On Tue, Jan 21, 2020 at 11:55 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> em_nbyte_change() sets
>> em->datalen = sizeof(*nbyte) + nbyte->len;
>>
>> But later tcf_em_validate() overwrites em->datalen with the user provide value (em->datalen = data_len; )
>> which can be bigger than the allocated (kmemdup) space in em_nbyte_change()
>>
>> Should net/sched/em_nbyte.c() provide a dump() handler to avoid this issue ?
> 
> I think for those who implement ->change() we should leave
> ->datalen untouched to respect their choices. I don't see why
> we have to set it twice.
> 
>

Agreed, but we need to audit them to make sure all of them are setting ->datalen

