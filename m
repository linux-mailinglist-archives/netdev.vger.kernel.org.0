Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7702539569
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 21:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbfFGTSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 15:18:25 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37625 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbfFGTSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 15:18:25 -0400
Received: by mail-pl1-f194.google.com with SMTP id bh12so1182952plb.4
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 12:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=psYF5CIYR3GFEVEu7NN9HQ3b/xP3Mff69F82ubVxEa8=;
        b=Yx3t/ms4XSW3zRH36bJUhYfbRQJ8eiglmbsKak1QIDbCFxe2orFlxcsDuAEYbJsegn
         zLXbqcEB21mDmrEx02IIAPh1ZmW7akjpSGpxMjLubNNOMZD93UCHQ88eJp6d5jxdl1rI
         iBN4zM/k/2ds1wkvGRE/ohSgZgN2cNfmyFQ4sepjzEktzML2FX5ZtelOSHfgnEllmbnW
         Pp7s54VSNyBX45VnRXLff/nfSq/1HM1rE77Aa6kTjvAtFsIRTT1MI47vPp/mYtPe8OSG
         Rudj3IYQAxC4AmGkGr/Y+P8cUtNDYmQ801sMAcD4rEXKzB/3XP3Amu+yl8khiyRXme4h
         Z/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=psYF5CIYR3GFEVEu7NN9HQ3b/xP3Mff69F82ubVxEa8=;
        b=PA8SG8GaLWlL0ajnwBC+GuyuBT6hJ3bnscvaHPMj6f/QiDIjSgSJQH0IYNZAeCZnbt
         9C3iYO7K6IdGbsLVZH9YUUM1b03NJdQkKodlHNerhZXmziuEruRXxOYeDsmvMkzIzBvZ
         LiwQzBl/9E62kPxlwEj+9vNqJKTECtBtm9yEngLIbWIyaB14h2qYyZYifXJmhgH9+3HY
         j7bk44zLysW4B9facXN4VpDnBEPyn1moO0JKrTm5oFZ9aq7LKe83B1a+9srb++mdRRUh
         O8g8uiQV1CzctwUlatGkRxO1wpllDCGI/6q3MbXej1CXo+6sQf4GPysLoLhsb6NxM5vZ
         BKhg==
X-Gm-Message-State: APjAAAU7RwMpFv2bNczORxjpVWRZle944+5J9Dpuhu2vbMrlyHkAgUDy
        NuEUIqnEGhWzDf1sPkbiqOFwY6Nv
X-Google-Smtp-Source: APXvYqwh1Ybz4QnkfadOiuSbCzshCXGknYQh7P/BloDKexBu/Kk8fkUDXnH3iIIjivadXCQVcZVipQ==
X-Received: by 2002:a17:902:a5c5:: with SMTP id t5mr58737715plq.288.1559935104008;
        Fri, 07 Jun 2019 12:18:24 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id 26sm2870760pfi.147.2019.06.07.12.18.22
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 12:18:22 -0700 (PDT)
Subject: Re: [PATCH] sis900: re-enable high throughput
To:     Sergej Benilov <sergej.benilov@googlemail.com>, venza@brownhat.org,
        netdev@vger.kernel.org
References: <20190607172628.31471-1-sergej.benilov@googlemail.com>
 <CAC9-QvCyZm10wrVd=6Z-9H-Y9mkb_e_4mkhs6KxGUEozy6BsVQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6dc5ff4b-24a4-7631-c598-2500b1a27ff4@gmail.com>
Date:   Fri, 7 Jun 2019 12:18:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAC9-QvCyZm10wrVd=6Z-9H-Y9mkb_e_4mkhs6KxGUEozy6BsVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/19 10:31 AM, Sergej Benilov wrote:
> On Fri, 7 Jun 2019 at 19:26, Sergej Benilov
> <sergej.benilov@googlemail.com> wrote:
>>
>> Since commit 605ad7f184b60cfaacbc038aa6c55ee68dee3c89 "tcp: refine TSO autosizing",
>> the TSQ limit is computed as the smaller of
>> sysctl_tcp_limit_output_bytes and max(2 * skb->truesize, sk->sk_pacing_rate >> 10).
>> For some connections this approach sets a low limit, reducing throughput dramatically.
>>
>> Add a call to skb_orphan() to sis900_start_xmit()
>> to speed up packets delivery from the kernel to the driver.
>>
>> Test:
>> netperf -H remote -l -2000000 -- -s 1000000
>>
>> before patch:
>>
>> MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to remote () port 0 AF_INET : demo
>> Recv   Send    Send
>> Socket Socket  Message  Elapsed
>> Size   Size    Size     Time     Throughput
>> bytes  bytes   bytes    secs.    10^6bits/sec
>>
>>  87380 327680 327680    341.79      0.05
>>
>> after patch:
>>
>> MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to remote () port 0 AF_INET : demo
>> Recv   Send    Send
>> Socket Socket  Message  Elapsed
>> Size   Size    Size     Time     Throughput
>> bytes  bytes   bytes    secs.    10^6bits/sec
>>
>>  87380 327680 327680    1.29       12.54
>>
>> Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>
>> ---
>>  drivers/net/ethernet/sis/sis900.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
>> index fd812d2e..ca17b50c 100644
>> --- a/drivers/net/ethernet/sis/sis900.c
>> +++ b/drivers/net/ethernet/sis/sis900.c
>> @@ -1604,6 +1604,7 @@ sis900_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
>>         unsigned int  index_cur_tx, index_dirty_tx;
>>         unsigned int  count_dirty_tx;
>>
>> +       skb_orphan(skb);
>>         spin_lock_irqsave(&sis_priv->lock, flags);
>>
>>         /* Calculate the next Tx descriptor entry. */
>> --
>> 2.17.1
>>
> 
> Thanks to Eric Dumazet for suggesting this patch

Note that this suggests the driver is not performing TX completion fast enough.

Looking at the driver, I do not see anything requesting interrupt mitigation,
so this might also be caused by a race in the driver (some skbs being not TX completed until
another unrelated xmit is requested)


