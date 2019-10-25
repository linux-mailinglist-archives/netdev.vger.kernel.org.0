Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71629E53AF
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388457AbfJYSSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:18:01 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45855 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733008AbfJYSRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:17:43 -0400
Received: by mail-io1-f65.google.com with SMTP id c25so3433391iot.12
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 11:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qi6W+g62TfYHVFcW4cCV1Cshae3UfUiumO8umtygRnc=;
        b=D3cffjGAdEDC3oIc1UeH9cuTMUyNeQlplyFaDe64ymekjOV0RHKm5XFtZOz1uXe1ji
         jwCzTOTibSsTyop4tqSiMj7FIQ/X4KaH4teCGPC5HeZb4r0Xqwfh7HwbsTJXXBFrVilA
         eCIvYVEhzo8BRwfahwSHKr9cqBwimgPK1kttr+PexVrTTaKOjc1ChM7LSL6EJwny/MrO
         9+35rEvYWcGNuXx4Ucwz2D0CWpJAPJi+7C+++R6zJbO0q336heVZwGnDcVmH9xacBsA6
         3hXvtE4tK5dd9A6F37Y+2f4JeR2/GuFA5AAIiuf9MSjIAbxgLeVEp4mOg8kYTXR+WNx1
         dbdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qi6W+g62TfYHVFcW4cCV1Cshae3UfUiumO8umtygRnc=;
        b=gh4UxMPFlMZzYgPe5GuoEMahLTnKxk8p3y6iOa1aXEvh9Ci8R94o4aO4GftqbTQygh
         5WjpqkrL5U/AmW4nYX5y2AaCaTyWYgMOLaWkRqgUKGrJOHjOgcglgAIpyM+lcXuMsYeQ
         5/Oin7TNVSswxfOOIMxLRLUMlUvFM+v4JzclV+UxC6Aqqve7UDvC5udPfdywZciElVgC
         6Zv8KWZcqKEB4mkLmYvJkpfS9Q47p33/xTcbN+/Q2csgtMJvUEkrqqx5tDLZHVPYQwej
         1jBcaBUtLqQM2gA/0bcCUOAjkEB6uIGCz5lddR+kroQTvxyzi3cRTAjmjlUd1VM7iNV6
         YUiQ==
X-Gm-Message-State: APjAAAWCbcqG6lmRTudM0Am6Nw9eIIOih9+AsTUh+EizlAhQ2ysoFMZ6
        fMUrEgtEvIavPHJ/3nvxelAM6w==
X-Google-Smtp-Source: APXvYqwr2UxqM4ZdnLwAwGeEiZgK1Dy64FAXkKzpgQ7U1l5CXk5+CQo5KBYkQD23au1JwCYj9p6O8g==
X-Received: by 2002:a5d:8185:: with SMTP id u5mr4928472ion.147.1572027462756;
        Fri, 25 Oct 2019 11:17:42 -0700 (PDT)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id c65sm440654ilg.26.2019.10.25.11.17.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 11:17:41 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbftv7wuciu.fsf@mellanox.com>
 <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
 <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
 <vbfsgngua3p.fsf@mellanox.com>
 <7488b589-4e34-d94e-e8e1-aa8ab773891e@mojatatu.com>
 <43d4c598-88eb-27b3-a4bd-c777143acf89@mojatatu.com>
 <vbfpniku7pr.fsf@mellanox.com>
 <07a6ceec-3a87-44cb-f92d-6a6d9d9bef81@mojatatu.com>
 <vbfmudou5qp.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <894e7d98-83b0-2eaf-000e-0df379e2d1f4@mojatatu.com>
Date:   Fri, 25 Oct 2019 14:17:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <vbfmudou5qp.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-25 12:53 p.m., Vlad Buslov wrote:
[..]

Sorry, the distractions here are not helping.
When i responded i had started to do below

enum {
         TCA_ACT_UNSPEC,
         TCA_ACT_KIND,
         TCA_ACT_OPTIONS,
         TCA_ACT_INDEX,
         TCA_ACT_STATS,
         TCA_ACT_PAD,
         TCA_ACT_COOKIE,
         TCA_ACT_ROOT_FLAGS,
         __TCA_ACT_MAX
};

Note: "TCA_ACT_ROOT_FLAGS"
I think your other email may have tried to do the same?
So i claimed it was there in that email because grep showed it
but that's because i had added it;->

> For cls API lets take flower as an example: fl_change() parses TCA_FLOWER, and calls
> fl_set_parms()->tcf_exts_validate()->tcf_action_init() with
> TCA_FLOWER_ACT nested attribute. No TCA_ROOT is expected, TCA_FLOWER_ACT
> contains up to TCA_ACT_MAX_PRIO nested TCA_ACT attributes. So where can
> I include it without breaking backward compatibility?
> 
Not a clean solution but avoids the per action TLV attribute:

in user space parse_action() you add TCA_ACT_ROOT_FLAGS
if the user specifies this on the command line.

in the kernel everything just passes NULL for root_flags
when invocation is from tcf_exts_validate() i.e both
tcf_action_init_1() and
tcf_action_init()

In tcf_action_init_1(), if root_flags is NULL
you try to get flags from from tb[TCA_ACT_ROOT_FLAGS]

Apologies in advance for any latency - I will have time tomorrow.

cheers,
jamal
