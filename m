Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539BE269841
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgINVuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgINVuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:50:22 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA09FC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 14:50:22 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z19so675084pfn.8
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 14:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=x1t9sm4/Vphx5aMsiagewItBVaC7vFpv9Pyn0KP3KuM=;
        b=yCvM6T4jrOVWs34bRkGkEys9/F0Y9RbQw0wJ3B/NDWq0+AHjKlApl1VddKkwIlgBP2
         xkardOqAj5rLnTK5/25K0FPtWRbWEBSH9vdhl3ysg/tkqn1CI3GO9vbEWf4K7yROtIgf
         Rx1qrrOsaZBnUqsXB3E2+5JH3o9cGw9OPaFvgkih9asXtC1k+7H/BXRnaaGcH/5+Pzsd
         4mrvv2Q1yLxez2FOgEJRtCvSCxNHu04dTbb9odeEuz0IoEGjPRUqMzI2bAJp9vRUVsQV
         tldQSo3h50cFkUIycawY8D9a8BpF4PAOE3pFuuoa/gnQu+ik9xFZ0+F9qdI0sZFDc9bC
         EHvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=x1t9sm4/Vphx5aMsiagewItBVaC7vFpv9Pyn0KP3KuM=;
        b=ZSBkWMORFSw1HYpzmO2tP3YKq/2gilPAnuoVL0Gwu9diQhNcGtq2HNBZDveDoAFHfe
         74bK5A3LElgrxMpEUzpBvm1sMO0x0s2/mj29XWTLX6Kx45INDyKb/mrcR0lXBTjnluPR
         0JyOf7Ikh9jC7PAkolfh2rAI4Nhg1P1lUssgQX42D4Huq3LzM0MRf3FlSf1zOjKZIMMp
         oLcS6LielxRZ+Gh3r0O47afS7UJKf9inUC5rRNYxixlWqXm1+whrdtVihRrcNRNqOBKi
         cV6EnuqNbFhIN1PKH8gwtdI3Kg6KBSBh24oZZCfvmc+N8jApUdDCFlNN/W1cCWyf8E3z
         rWIA==
X-Gm-Message-State: AOAM533WmXH9UpB3JU5FrQgDR/m+L0W1gxlS8z+njIxq7SYqIO4aGVbP
        kfEMQwMmkoGYMMVYLO5z3KlIXY98GwsH2g==
X-Google-Smtp-Source: ABdhPJzXw7Td0CCtXq1+uawFKpCSEyI76eki4JuRNSyeS5tLi2/fD3/wPRCPYKrqIJ1XNkU4z0OZFQ==
X-Received: by 2002:a63:5515:: with SMTP id j21mr11953827pgb.31.1600120222112;
        Mon, 14 Sep 2020 14:50:22 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id y23sm11149051pfp.65.2020.09.14.14.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 14:50:21 -0700 (PDT)
Subject: Re: [PATCH net-next] ionic: dynamic interrupt moderation
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200913212813.46736-1-snelson@pensando.io>
 <20200914141041.570370fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <275d2c83-d85d-1b60-cd11-8b5760e67ce0@pensando.io>
Date:   Mon, 14 Sep 2020 14:50:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200914141041.570370fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/20 2:10 PM, Jakub Kicinski wrote:
> On Sun, 13 Sep 2020 14:28:13 -0700 Shannon Nelson wrote:
>> Use the dim library to manage dynamic interrupt
>> moderation in ionic.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Let me advertise my people.kernel entry ;)
>
> https://people.kernel.org/finqi53erl
>
> My somewhat short production experience leads me to question the value
> of DIM on real life workloads, but I know customers like to benchmark
> adapters using ping and iperf, so do what you gotta do :(

Yes, I saw your article, and I figured this little patch might catch 
your attention :-).

This at least can do some general automated tweaking for those aren't 
going to do hand tuning for particular workloads.  For others, we still 
have the ability to split the Tx and Rx interrupts and tune them 
separately if desired.

>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> index 895e2113bd6b..f1c8ab439080 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> @@ -42,6 +42,19 @@ static int ionic_start_queues(struct ionic_lif *lif);
>>   static void ionic_stop_queues(struct ionic_lif *lif);
>>   static void ionic_lif_queue_identify(struct ionic_lif *lif);
>>   
>> +static void ionic_dim_work(struct work_struct *work)
>> +{
>> +	struct dim *dim = container_of(work, struct dim, work);
>> +	struct dim_cq_moder cur_moder =
>> +		net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
> Could you move this out of the variable init? Make things hard to read.

Sure.

>
>> +	struct ionic_qcq *qcq = container_of(dim, struct ionic_qcq, dim);
>> +	u32 new_coal;
>> +
>> +	new_coal = ionic_coal_usec_to_hw(qcq->q.lif->ionic, cur_moder.usec);
>> +	qcq->intr.dim_coal_hw = new_coal ? new_coal : 1;
>> +	dim->state = DIM_START_MEASURE;
>> +}
> Interesting, it seem that you don't actually talk to FW to update
> the parameters? DIM causes noticeable increase in scheduler pressure
> with those work entries it posts. I'd be tempted to not use a work
> entry if you don't have to sleep.

net_dim() assumes a valid work_struct in struct dim, and would likely 
get annoyed if it wasn't set up.  I suppose we could teach net_dim() to 
look into the work_struct to verify that .func is non-NULL before 
calling schedule_work(), but that almost feels like cheating.

sln




