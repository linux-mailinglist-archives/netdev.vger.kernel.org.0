Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADCF1FD594
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 21:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgFQTxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 15:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFQTx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 15:53:29 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98502C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 12:53:29 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id h95so1574481pje.4
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 12:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=+T19TF6qdVtcAmoMLbzXEDeWCXlmfqRQYtUaWg7UPLY=;
        b=pTnynhrEhGleopsDXOoBiDEfYnmzxkAffLBdP8rOFNE5E/OHB8E59JIhbco6Hjn0Uc
         nU4QFV/1eGOWHv1b35g4SPW4j1v78y6mN/tUY/b/wAviqgKu0myP/nn0kDleEy8NOIER
         UIrybTDDLapNYD1HiDmEwiiLvzRDlvrkblgJqJ8CW2qRnQ4owGklueByWzLoOcUaWJoF
         ZWI+cQU07eVza0HP3+GakSIs9gMR3GM9DRacNBJ8ekqaefXfotdZbGren9Z56MP1PfFZ
         8qMOYTCRg+LTxE33wa3KkmVoH7LOOMEEUTnLvjHMUvFwOKWI+COL8WrBOw2tIaSM4rvk
         AkJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+T19TF6qdVtcAmoMLbzXEDeWCXlmfqRQYtUaWg7UPLY=;
        b=OpLUeU0qz4HSnZCQpoOGkabkao/wPWpYS7Y8jlGswg6EksQ+URPURm/kllgk7RveFh
         Ml0ZYLouvVLOleaDFgHlqzAS+Y3AcfQXtIJ0eZ1LJbe6pL5sBtxm+CcKZZsqvidVD3Nq
         PmLkAb8oFRTIV9nbkAO0MngZUH2FXMzmc+eszcCCR9FA1tAIiKnS/fJsQBhCCi95nhQZ
         WEiaUhuFLZ0hGEZS7lI7HtF8dbhMr5WGflRS/t+5zEShODH5sgHfP7YSeYgi1spaVBD3
         qujTUfa6f18nVlMWn7NkuwF3B44aCNyt/q8lfLfUvKxNJ8dQR4T8naHACfVLyd3Xbuo1
         W2PA==
X-Gm-Message-State: AOAM5328+Q2EerjwUubh/6TWDI/p3KqKTR77/I7ASiPeaVf43Set6eO9
        HxSewae/EKJj3ZRFohwV4kIdTA==
X-Google-Smtp-Source: ABdhPJzKGaaHTCTFdbMaw9s0ON+MfRHFlnMW2YUq6xTrqkmmYlwbngatLYNyeVq9OS9m3yYVXhv14w==
X-Received: by 2002:a17:902:768b:: with SMTP id m11mr646185pll.136.1592423609088;
        Wed, 17 Jun 2020 12:53:29 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id c9sm645262pfr.72.2020.06.17.12.53.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 12:53:28 -0700 (PDT)
Subject: Re: [PATCH net] ionic: no link check while resetting queues
To:     jtoppins@redhat.com, netdev@vger.kernel.org, davem@davemloft.net
References: <20200616011459.30966-1-snelson@pensando.io>
 <8fadc381-aa45-8710-fad7-c3cfdb01b802@redhat.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <0d73be4b-6935-f8c4-765e-709e416edda2@pensando.io>
Date:   Wed, 17 Jun 2020 12:53:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8fadc381-aa45-8710-fad7-c3cfdb01b802@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/20 12:41 PM, Jonathan Toppins wrote:
> On 6/15/20 9:14 PM, Shannon Nelson wrote:
>> If the driver is busy resetting queues after a change in
>> MTU or queue parameters, don't bother checking the link,
>> wait until the next watchdog cycle.
>>
>> Fixes: 987c0871e8ae ("ionic: check for linkup in watchdog")
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> index 9d8c969f21cb..bfadc4934702 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> @@ -96,7 +96,8 @@ static void ionic_link_status_check(struct ionic_lif *lif)
>>   	u16 link_status;
>>   	bool link_up;
>>   
>> -	if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state))
>> +	if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state) ||
>> +	    test_bit(IONIC_LIF_F_QUEUE_RESET, lif->state))
>>   		return;
>>   
>>   	link_status = le16_to_cpu(lif->info->status.link_status);
>>
> Would a firmware reset bit being asserted also cause an issue here
> (IONIC_LIF_F_FW_RESET)? Meaning do we need to test for this bit as well?
>

No, we actually want the link_status_check during the FW_RESET so that 
we can detect when the FW has come back up and Linked.  During that time 
we just don't want user processes poking at us, which is why the 
netif_device_detach()/netif_device_attach() are used there.

sln

