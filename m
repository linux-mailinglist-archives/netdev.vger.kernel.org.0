Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 908E0CEE56
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 23:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfJGVUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 17:20:25 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:33256 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728702AbfJGVUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 17:20:24 -0400
Received: by mail-pg1-f173.google.com with SMTP id i76so1819785pgc.0;
        Mon, 07 Oct 2019 14:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=sycFjW76TPrYh+EZFOry3N94dzhDeaSje8SkQ8MSXvA=;
        b=fQg6xW+UFVl4P5jrJBH5q5AbD5KcDxnKN1kXTZpWdgzKMqmmuTYG2xLAJDsaA3/w0x
         /zsYlRlbB/HYh6y5zOevSg0qAa7wdD6h5Q8WsM9tTdgt599iFljrwg/54zrfgNiwBVKR
         DTe4JzulD6AZoHnqjJJZqY7uUmWt3N+10ivfsbf74Iuyp+MlAkiRMMULp/7QFMs0eBwu
         GuROimN69l6vkT8EhSYpzSg2rgMFXfcHggNwpe8KwHz7aqmqBt+EFYle/0Sc8UtQRmzT
         Yh5rXs+KMKZo0L+LynbLdKQ7oR8XTdcIlOsIVFNGgRvK/Cp+broBsSgWlF20A7O96EbB
         OB/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sycFjW76TPrYh+EZFOry3N94dzhDeaSje8SkQ8MSXvA=;
        b=RLvL3Cbp+kd0CcYhMdzNj5VtgaxIMuG8tp+WzM3l56ivRkhsT2oAoYlNSafMLfXhJv
         RYg671VdIL/5gUohq84JcS0/65Z/+uvUVYcX2R8vEx8eoUAJWs/AswaWXuBoChdc6I+c
         TbchmTxjUerVGgkEB+4zzSk79esOMpRWlS59I5IVd9mlyol3BCt1AfgajlZ8pQ1bh0cp
         LkPMEh4AV0mUWzr6+tcgUL5GjRxMUcPiv+OmjATdyxUHA7JGNVAgT4oGf2rlp/STgdJz
         0w29/ovYKwLC8dknyglvAz+0/K7Xreaylh7NIxN9hVh+B8jpCM5BpOnNqLP4P015qJ/E
         CcVw==
X-Gm-Message-State: APjAAAUAtIb5d0egA7dmhJDXrqMYSq6GHLFjdcBkmA2aTHxXGEwOSG9M
        OnU59dyAwKObz7KFHZ5X3CQeaTPV
X-Google-Smtp-Source: APXvYqyIN2WyX2O/LtktWbQBDxOmrCtq3FQCtQmqRN0tsPHmd49xQZm2L1P3TBbGfx6R85XTdNkOhw==
X-Received: by 2002:a63:33c4:: with SMTP id z187mr10304868pgz.30.1570483223810;
        Mon, 07 Oct 2019 14:20:23 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id q76sm27325812pfc.86.2019.10.07.14.20.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 14:20:22 -0700 (PDT)
Subject: Re: Potential NULL pointer deference in net: sched
To:     Yizhuo Zhai <yzhai003@ucr.edu>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>,
        Chengyu Song <csong@cs.ucr.edu>
References: <CABvMjLRuGnatUxBEMKpXWGNJnAjNMiCXQ7Ce88ejuuJJnENR+g@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b2997ffb-728a-b4ee-abfa-2c9fe9869d8b@gmail.com>
Date:   Mon, 7 Oct 2019 14:20:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CABvMjLRuGnatUxBEMKpXWGNJnAjNMiCXQ7Ce88ejuuJJnENR+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/7/19 2:08 PM, Yizhuo Zhai wrote:
> Hi All:
> 
> net/sched/sch_mq.c:
> Inside function mq_dump_class(), mq_queue_get() could return NULL,
> however, the return value of dev_queue is not checked  and get used.
> This could potentially be unsafe.
> 
> 

Not really.

mq_dump_class() is called by a layer that made sure the @cl argument
was not complete garbage.

