Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC89C269C6
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbfEVSXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:23:34 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37965 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728674AbfEVSXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:23:34 -0400
Received: by mail-qk1-f194.google.com with SMTP id a64so2125472qkg.5
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cL9nxfKmXYpiJ8E4og0dMNug50BeN4Kg0KP1sXz6uTs=;
        b=sdCcKrG+QwoOFNZUXIQM2AkD1irIvBhipBRKMtDhdIGk4v/NPSUXKSfKWN6yw5RWGr
         DzGQGbT4wAnHmlMCBmCz7HWUthqe67kqKHiJY2h801awXYRr5MEh3nXkSaqc/8qYLnVa
         xqZg4oD66v+EeiPaVCbqVUElbyQRxSLN5sFoH4zwJ1LSo17uhA9Uw0l6Z1gNYRSfAH4v
         2OZSg9nkg+iMrq1PvYWfm9K6ibAUdLxYG44rRfaSH+rF8O9zztdR7H48G3NPQo1E3R2i
         twgqJZuHy6GuaQL9Jzp5fR/XLBUhWARx3iN31Fn+CVz+BSPkqUZhcdHXOFdF2UMRynsV
         UR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cL9nxfKmXYpiJ8E4og0dMNug50BeN4Kg0KP1sXz6uTs=;
        b=bzYO16uKdGsC7xRGKuk4HofA4t3h5ot4+wL53ivLwZ/8SL2ENx8FqiW13zh6Kiv9HK
         9brG7cutdQj1KFmXLVBamfR+pwx+RG/A4e76Oh2SUZ4X4j0yu/LlPtAsO5Jx1IS0BDnY
         2ogsT2XM4XZLzxqfiqhvLyu66cw9Om4B/VyXa4yZlr8g6KTjOjxaqaVx1P4Jiv94W/wE
         yRhGA7MgjWpuZtCQDLTXWk+qpiw6BU9U+XsLfK56vubY51dA17W96ilS6xrWPgDFTygQ
         PCmCVrkZ214mWQMRXEEbj0CREh5lDPQX7m/gMaNIdFbjVuiias6yZ54oq79Ux8w2e5Re
         I2PQ==
X-Gm-Message-State: APjAAAUTlqFGjIqjSyTS24f9SkObl6BLhAjwTRL/mFDXX2OMDQwBarb4
        E9YxYvwKG2c7o327k+2azX8qqg==
X-Google-Smtp-Source: APXvYqziqPI5B69ueL7CPvfEMUytLSmUMZ9Y9ZOReVPqXFPH0VXvh3AVo0onFB+EomaIK1SzrnYmow==
X-Received: by 2002:a05:620a:1384:: with SMTP id k4mr17809362qki.69.1558549413738;
        Wed, 22 May 2019 11:23:33 -0700 (PDT)
Received: from [10.0.0.169] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id s17sm14502827qke.60.2019.05.22.11.23.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 11:23:32 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
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
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <dd7efdc7-6a3b-389c-5037-125e4243223a@mojatatu.com>
Date:   Wed, 22 May 2019 14:23:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <vbfa7fee5vm.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-22 1:49 p.m., Vlad Buslov wrote:
> 
> On Wed 22 May 2019 at 20:24, Jamal Hadi Salim <jhs@mojatatu.com> wrote:

>> Ok, thanks for chasing this. A test case i had in mind is to
>> maybe have 3 actions. Add the drop in the middle for one
>> and at the begging for another and see if they are visible
>> with the patch.
>> If you dont have time I can test maybe AM tommorow.
> 
> Works with my patch:
> 

Ok, thanks Vlad.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
