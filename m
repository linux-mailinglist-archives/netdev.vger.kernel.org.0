Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4234031DDD5
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 18:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbhBQRB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 12:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234332AbhBQRBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 12:01:43 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0500CC0613D6
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 09:01:03 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id q186so11693154oig.12
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 09:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=acLjNYJ2FLHuaTuKCTyp2dOS5vNX6ll7e+m+WEgy3a0=;
        b=tQ/LM6+54H2yMGAbKn9YVIKLAzvYFvsg+p8Ex/fRDi2tFOfu5iD9bq2t2W8WaiqIRU
         TqYxyDYZWTkKhidiSrqiDwqmEqVlpTmbSJY9dfWTqFBJNdW0hTWWuXkdTR0firtIw9Be
         aAHj7agt1nW/4529bnOp11nZIXvzgCM1vW445Uk8/jWOWnKXux/2IQrSRLnN+xcL7ix/
         WKuXthvXIXlIepi5k//ejGxsTuzmOcjpbbCRBxl3Wqfgvc8LGriazkWoy88Aw9pvXrvD
         MCpAl3+pmB35JLKrc8hMyp1ewAOH9xdTvnN4EAubSWOcBOoGRmlwWJld/WUC9i/jazAS
         2GNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=acLjNYJ2FLHuaTuKCTyp2dOS5vNX6ll7e+m+WEgy3a0=;
        b=VK4hjsiMBVVTNRM63Ok1A7YxA3K97O/rlA4yFhtiDge/MgmOKYTUUxt5bbjY7NS5Yq
         yUZp0lOKXmWYYtNgyV60vovHeMVyB2Pz4x7l/b6td8+jupo+p7WEo5yNF51I0wXxFVjU
         UcERI4uF+XNoWasqNsjfUmVl3sgAcN1uk0xv3IwWJLh0yywXugP01CWMmn6GQ/f52/9z
         aK7IS1G8VMjWp0nRZMPuuRcNwD2uDX3DKxc3FvsefpYL3oVFR5i1jjy1Lj9Iz5yWCaAq
         BmCmqg05bJGqE9+Aa+9BGxCQjeLM9uhbeJkKGWeoo33s/4pISh7bPg8AtyK6QXI0LTlL
         LyGQ==
X-Gm-Message-State: AOAM531WB2OBvZ6H54AZhCm93x4hRFRx6wT1Jzt/4BY164gPNJ1jw6+V
        SBQSJS0k7AhD9GIvvgomt7VsNKtYsYk=
X-Google-Smtp-Source: ABdhPJzMM5xD+9OBeIho3+CxKSgzPpLJcl3fXccdo0704VrzBuH8joFNjufISxz4EWSwFXVzByLvAw==
X-Received: by 2002:a54:438f:: with SMTP id u15mr2243540oiv.60.1613581262531;
        Wed, 17 Feb 2021 09:01:02 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id b9sm501287otl.14.2021.02.17.09.01.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 09:01:01 -0800 (PST)
Subject: Re: [PATCH v4 net-next 07/21] nvme-tcp: Add DDP data-path
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>, smalin@marvell.com,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        benishay@nvidia.com, Or Gerlitz <ogerlitz@nvidia.com>,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210211211044.32701-1-borisp@mellanox.com>
 <20210211211044.32701-8-borisp@mellanox.com>
 <cfd61c5a-c5fd-e0d9-fb60-be93f1c98735@gmail.com>
 <CAJ3xEMgZg9dFyc8cnbuPPAFT3jd2k27TdLOz-vtVmxy9k9zHcg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f9c45756-b823-7cab-213c-761866230c96@gmail.com>
Date:   Wed, 17 Feb 2021 10:00:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAJ3xEMgZg9dFyc8cnbuPPAFT3jd2k27TdLOz-vtVmxy9k9zHcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/21 7:01 AM, Or Gerlitz wrote:
>>> @@ -1136,6 +1265,10 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
>>>       else
>>>               flags |= MSG_EOR;
>>>
>>> +     if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) &&
>>> +         blk_rq_nr_phys_segments(rq) && rq_data_dir(rq) == READ)
>>> +             nvme_tcp_setup_ddp(queue, pdu->cmd.common.command_id, rq);
>>> +
>>
>> For consistency, shouldn't this be wrapped in the CONFIG_TCP_DDP check too?
> 
> We tried to avoid the wrapping in some places where it was
> possible to do without adding confusion, this one is a good
> example IMOH.
> 
> 

The above (and other locations like it) can easily be put into a helper
that has logic when the CONFIG is enabled and compiles out when not.
Consistency makes for simpler, cleaner code for optional features.
