Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6D288605
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfHIW2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:28:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46244 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfHIW2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 18:28:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id w3so9309003pgt.13
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 15:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:subject:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=gIZ08GBL7VZXMJdEFqfSH6EAHBkMDb4JT6CpI49p5Xs=;
        b=LhDL7VmiDJDWpa2CUZG22STCi2+WY9upcZw5RrGWtvM0UVgloYljFAUo7t8MmA6UJ4
         40ZKPbEFsXrHhO7NVgAjN9x2zBbFYwBTpzoDVWk+lyyTr2JUslLMy8QA4NhMXUpet/Cw
         VoRzX7SJ4titLoEk0SO4mC8nTdl12jaPxNaBraYv+HTK7qsuel/Uwa154BjrWfgErCTk
         x6Wp4xIgS1k4PgDKxUD9ZKyVZczsAiGGRwrgr/gj0Z2h6ej8zEQTmsgnS5faOdDKPR47
         Udkn0gmE+mImC+AK8gGy0N9YkTBnF8X5W3Bh8t2DOrCJeyCBwLVGGfRlZPvrUr3CcFp+
         VElA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=gIZ08GBL7VZXMJdEFqfSH6EAHBkMDb4JT6CpI49p5Xs=;
        b=FP7Fk67XV2nFmcyGx7jYNWTqwBUd/0R1Gw3FdIpTbCeHi9HSglT+hF0sTr8GhmELOk
         bXRDkEULAketLZ2R5XI+er4fYAIGnbMEYnnitqjZTx6ORzFIO/7H6B2eGGa95/zuniSw
         8VKZsnIbUu47nx3Q9hqC+sAduIY2re/oI8+3PsniIMpytTdItK9gcmFOxmVPvBsvqnYT
         ct1lm1ozXjEDTEe+UJa5S0VJyDKhUCR+lJbapoUKGWNL+st+gsRF3MteiMiFQj5f7b93
         MCUdt9fhy7lESO7zf+3N7oYZHZO4DUhUjBzUQ1iMRk0NU5+kIhz3bxLqQ/RoON0SsyI5
         TV2A==
X-Gm-Message-State: APjAAAXiZIQ0syZirsbVMkP3GGot4vqkpxn1wnObSDTn2ypNiW6BPqlv
        tj17DxjJu78YQvYsuE3WG1Yjx7qYwpRjmQ==
X-Google-Smtp-Source: APXvYqwxgPXOlhaeu4lcy9y7QVv4Rh8D3bhFtobFNXxxQe8Fr/HjFINAbxa4XOSZwD5m7xCtfSP+XQ==
X-Received: by 2002:a63:c0d:: with SMTP id b13mr19311484pgl.420.1565389679072;
        Fri, 09 Aug 2019 15:27:59 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id l189sm119526758pfl.7.2019.08.09.15.27.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 15:27:58 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
Subject: Re: [PATCH v4 net-next 14/19] ionic: Add Tx and Rx handling
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-15-snelson@pensando.io>
 <c20a9924af9ce298f1997f57b8b51235726583d8.camel@mellanox.com>
Message-ID: <22b81224-8899-0803-6449-36c13e673c62@pensando.io>
Date:   Fri, 9 Aug 2019 15:27:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c20a9924af9ce298f1997f57b8b51235726583d8.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/25/19 4:48 PM, Saeed Mahameed wrote:
> On Mon, 2019-07-22 at 14:40 -0700, Shannon Nelson wrote:
>> Add both the Tx and Rx queue setup and handling.  The related
>> stats display comes later.  Instead of using the generic napi
>> routines used by the slow-path commands, the Tx and Rx paths
>> are simplified and inlined in one file in order to get better
>> compiler optimizations.
>>
>> Signed-off-by: Shannon Nelson<snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/Makefile  |   2 +-
>>   .../net/ethernet/pensando/ionic/ionic_lif.c   | 387 ++++++++
>>   .../net/ethernet/pensando/ionic/ionic_lif.h   |  52 ++
>>   .../net/ethernet/pensando/ionic/ionic_txrx.c  | 879
>> ++++++++++++++++++
>>   .../net/ethernet/pensando/ionic/ionic_txrx.h  |  15 +
>>   5 files changed, 1334 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_txrx.c
>>   create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_txrx.h
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/Makefile
>> b/drivers/net/ethernet/pensando/ionic/Makefile
>> index 9b19bf57a489..0e2dc53f08d4 100644
>> --- a/drivers/net/ethernet/pensando/ionic/Makefile
>> +++ b/drivers/net/ethernet/pensando/ionic/Makefile
>> @@ -4,4 +4,4 @@
>>   obj-$(CONFIG_IONIC) := ionic.o
>>   
>>   ionic-y := ionic_main.o ionic_bus_pci.o ionic_dev.o ionic_ethtool.o
>> \
>> -	   ionic_lif.o ionic_rx_filter.o ionic_debugfs.o
>> +	   ionic_lif.o ionic_rx_filter.o ionic_txrx.o ionic_debugfs.o
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> index 2bd8ce61c4a0..40d3b1cb362a 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> @@ -10,6 +10,7 @@
>>   #include "ionic.h"
>>   #include "ionic_bus.h"
>>   #include "ionic_lif.h"
>> +#include "ionic_txrx.h"
>>   #include "ionic_ethtool.h"
>>   #include "ionic_debugfs.h"
>>   
>> @@ -18,6 +19,13 @@ static int ionic_lif_addr_add(struct lif *lif,
>> const u8 *addr);
>>   static int ionic_lif_addr_del(struct lif *lif, const u8 *addr);
>>   static void ionic_link_status_check(struct lif *lif);
>>   
>> +static int ionic_lif_stop(struct lif *lif);
>> +static int ionic_txrx_alloc(struct lif *lif);
>> +static int ionic_txrx_init(struct lif *lif);
>> +static void ionic_qcq_free(struct lif *lif, struct qcq *qcq);
>> +static int ionic_lif_txqs_init(struct lif *lif);
>> +static int ionic_lif_rxqs_init(struct lif *lif);
>> +static void ionic_lif_qcq_deinit(struct lif *lif, struct qcq *qcq);
>>   static int ionic_set_nic_features(struct lif *lif, netdev_features_t
>> features);
>>   static int ionic_notifyq_clean(struct lif *lif, int budget);
>>   
>> @@ -66,12 +74,96 @@ static void ionic_lif_deferred_enqueue(struct
>> ionic_deferred *def,
>>   	schedule_work(&def->work);
>>   }
> Bottom up or top down ? your current design is very mixed and I had to
> to scroll down and up too often just to understand what a function is
> doing, i strongly suggest to pick an use one approach.
>
> [1]
> https://en.wikipedia.org/wiki/Top-down_and_bottom-up_design#Programming

Hi Saeed,

Sorry it has taken me so long to address the comments you had on this 
patch: I've been contemplating them while working some internal issues.  
Part of my hesitance is also because, while correct, these are 
suggesting some significant rework and juggling of stable code. I've 
been aware of these issues since I inherited the code, and have been 
addressing them over time while trying to keep on top of stability, and 
was planning to continue doing so.  It sounds like I need to evolve the 
driver a little further before the next patchset version.  I think I'll 
have time in the next week to do this, so I'm hoping to have a new 
patchset out in another week or so.

Thanks for the inputs,
sln


