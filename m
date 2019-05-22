Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D86F269CB
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfEVS0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:26:06 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44964 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbfEVS0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:26:06 -0400
Received: by mail-qt1-f196.google.com with SMTP id f24so3555444qtk.11
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DDJUFfoFLnIRTudsf85FTGbTIwCzRi532DBihiX6dpQ=;
        b=SmGEd+8s6RFId2tw9mN9nFKX/voOZJ95JV+aYT610H2GsXojzC00gc1xbEL4zbNK96
         YJYrjab2+73hQpR8UONaQIjDOACCQVsrmOllZAzThNYAixo8Ym/cNssRN5cItNSV+FHr
         3LvWn9iUJeauzx1qdxjINHMuOT0sY9Qy4snGvfOhNf2j+Opu75JHJNPqn5REKWnZ2aQY
         76NuhvtpurFuuGurzbf6ZsmOzwuWb0OGKCS2jhZCYPCKMeSY9l/kIs3WlfMZ3T57D7+5
         QO88lxyZBtkpqguHXxaggORQDbvqDo3D2hYqYxew0ppC54NF213bK4Ql3Uab5j0+pTYF
         nvPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DDJUFfoFLnIRTudsf85FTGbTIwCzRi532DBihiX6dpQ=;
        b=qEoW9FicSs+wlMAP60e0qcBPuo+TfM2cmFQosT/G4jJYaGNDyhV8uj3CYZIi61l+XI
         grS51OZc8Y/BRDilvqvkc3+/xqa1OFbctdP7mlfN3bkbY7ixU3sE1oyHWKKPupr0qkpH
         /YuBABTKfgFZo+e7ccbubK9l8+9XS7TWJ3VLn62DGMbF8b9GMceiHnXeuHXQXXKfUlhX
         wCOwPAPUgmpoisr61A/2wML0uZO0nOUdyZTg/KtqMAbwxg2gF40XcmpZlkNcCSD4w1wc
         xmtSC11dAvnTxvkdOuWFwOfp8jptLvXPVJmjWCy29c1cIncAr/70ctQvVIwMZXJHLIBg
         OLpA==
X-Gm-Message-State: APjAAAXW2NQZzWsRHj5ph2f7onGlaH/ksV9EBCnLkrKQIGYr8OwdSWS9
        GfeZScr7RKeS/W8GIJWhhOTizw==
X-Google-Smtp-Source: APXvYqxFshMsQFTeA8dXU0nvpxZuukeXwlZl/uYns+d7/5lmZz1ZQJJC8fybh565EbFrgbxXjRPYFg==
X-Received: by 2002:a0c:9826:: with SMTP id c35mr60125099qvd.240.1558549565398;
        Wed, 22 May 2019 11:26:05 -0700 (PDT)
Received: from [10.0.0.169] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id s17sm14506444qke.60.2019.05.22.11.26.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 11:26:04 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Lucas Bates <lucasb@mojatatu.com>
References: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
 <f4fdc1f1-bee2-8456-8daa-fbf65aabe0d4@solarflare.com>
 <cacfe0ec-4a98-b16b-ef30-647b9e50759d@mojatatu.com>
 <f27a6a44-5016-1d17-580c-08682d29a767@solarflare.com>
 <3db2e5bf-4142-de4b-7085-f86a592e2e09@mojatatu.com>
 <17cf3488-6f17-cb59-42a3-6b73f7a0091e@solarflare.com>
 <b4b5e1e7-ebef-5d20-67b6-a3324e886942@mojatatu.com>
 <d70ed72f-69db-dfd0-3c0d-42728dbf45c7@solarflare.com>
 <e0603687-272d-6d41-1c3a-9ea14aa8cfad@mojatatu.com>
 <b1a0d4b5-7262-a5a0-182d-54778f9d176a@mojatatu.com>
 <vbfef4slz5k.fsf@mellanox.com> <vbfblzuedcq.fsf@mellanox.com>
 <b147865f-5224-b66b-2824-8c1c8986900f@mojatatu.com>
 <vbfa7fee5vm.fsf@mellanox.com>
 <dd7efdc7-6a3b-389c-5037-125e4243223a@mojatatu.com>
Message-ID: <f4a64274-c110-8e1e-9fb7-9e48de1cc73b@mojatatu.com>
Date:   Wed, 22 May 2019 14:26:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <dd7efdc7-6a3b-389c-5037-125e4243223a@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-22 2:23 p.m., Jamal Hadi Salim wrote:
> On 2019-05-22 1:49 p.m., Vlad Buslov wrote:
>>
>> On Wed 22 May 2019 at 20:24, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> 
>>> Ok, thanks for chasing this. A test case i had in mind is to
>>> maybe have 3 actions. Add the drop in the middle for one
>>> and at the begging for another and see if they are visible
>>> with the patch.
>>> If you dont have time I can test maybe AM tommorow.
>>
>> Works with my patch:
>>
> 
> Ok, thanks Vlad.
> 
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> 
> cheers,
> jamal


Actually this is net/stable material.
Can you resubmit to net and add my ACK?

cheers,
jamal
