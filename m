Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C488872299
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389633AbfGWWuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:50:32 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35423 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732011AbfGWWuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:50:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id u14so19877027pfn.2
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 15:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=jYCPJPk4kEic5iLopZo2Hca42Z4Lex2bkms43h6raNA=;
        b=YckOWXKV6YD4LvfechjEbrmNGduYnR9YIZW5Z2ZeTTO0fE50Bc3BlicPcFLQDj5NIc
         eR58zO6c887v+w9WeiZu1sUOePhNXvDBdTtKFvLWVLrWJD8eLGZo3cW/7AUWtyCGwrwm
         zgOevCUa61kdBkz86cTB2U68ni/0jW+SirRmYOKEYo6fkQyYVRZeMXb7IE0jGsA2aBa+
         GRftH2ZwXKvbYxj0SH/NOiShpXNT075mi56c7cjrbzGTIPeS7QmjAYuEipK8bqA18NV9
         PJg9EaUtP7kx4dwx4eWVOBbdDxr4BssBrtn91OlYiQ48UU84vgOenNkXcPFQ3Timn50n
         kobw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jYCPJPk4kEic5iLopZo2Hca42Z4Lex2bkms43h6raNA=;
        b=es06QXY5uD6ZMcLMd4Nqh1OOQt5AujSeejeAVDqPf1LmmOjVFHVBictKkxMJG8DE2j
         kXQP13yLNSYVckxCUfh1txDTTmhIkZ0ET6l5xCMTjuWfGbRotci+AJDAjkslN01/tKqY
         R89TugtcekY6sqYEAjGCu5ynYjEyc76zAvIpPpygAo7GmPQwffZFt8NvRz8vcpJGgxen
         FyXAjTfCBdDuZXfKZBCR3wJY9Qxsh3XEJJhDOksbRGSx84KnBxdHzO/IG2QTKchwYRWL
         9UUrxSh/e+cRhEEGwVYUREuPxnuOTeGRfH03HetPabkvO1n5EQbi+8DRi3bF+cEqnoVV
         ztTg==
X-Gm-Message-State: APjAAAWjsA9wbi11hC0xfkT3M7ytL+C7Z1vssQ5CzS2tyG3Dlz4sOz4B
        ol6kix/oVZZ41171bKmllEKub50fKhINAw==
X-Google-Smtp-Source: APXvYqxRjQ5lVq24ZTgwfCqqM04HwoRTOn2SBYjqaJkpgOa9cYc/lLvb9Rk+JyDnlmlqdISE/DK5IA==
X-Received: by 2002:a63:1749:: with SMTP id 9mr25881528pgx.0.1563922231145;
        Tue, 23 Jul 2019 15:50:31 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id g66sm44561837pfb.44.2019.07.23.15.50.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 15:50:30 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 05/19] ionic: Add interrupts and doorbells
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-6-snelson@pensando.io>
 <20190723.142448.414859031558093111.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <3ca116c9-b19b-2e48-ded9-83f949a0ccd8@pensando.io>
Date:   Tue, 23 Jul 2019 15:50:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723.142448.414859031558093111.davem@davemloft.net>
Content-Type: text/plain; charset=iso-8859-7; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 2:24 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Mon, 22 Jul 2019 14:40:09 -0700
>
>> The ionic interrupt model is based on interrupt control blocks
>> accessed through the PCI BAR.  Doorbell registers are used by
>> the driver to signal to the NIC that requests are waiting on
>> the message queues.  Interrupts are used by the NIC to signal
>> to the driver that answers are waiting on the completion queues.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> After applying this patch we get a warning:
>
> drivers/net/ethernet/pensando/ionic/ionic_lif.c:33:13: warning: ¡ionic_intr_free¢ defined but not used [-Wunused-function]
>   static void ionic_intr_free(struct lif *lif, int index)
>               ^~~~~~~~~~~~~~~
> drivers/net/ethernet/pensando/ionic/ionic_lif.c:15:12: warning: ¡ionic_intr_alloc¢ defined but not used [-Wunused-function]
>   static int ionic_intr_alloc(struct lif *lif, struct intr *intr)
>              ^~~~~~~~~~~~~~~~

Yes, and they get used in the next patch.  This is so I can keep similar 
bits of functionality together in one patch and to keep the next patch a 
little smaller.

> Also:
>
>> +	lif->dbid_inuse = kzalloc(BITS_TO_LONGS(lif->dbid_count) * sizeof(long),
>> +				  GFP_KERNEL);
> You can use bitmap_alloc() and friends from linux/bitmap.h for this kind of stuff.

Sure.
sln

