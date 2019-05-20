Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2519323C9D
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388994AbfETPzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:55:36 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35746 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388959AbfETPzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:55:36 -0400
Received: by mail-qk1-f193.google.com with SMTP id c15so9142314qkl.2
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 08:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ON2YtlFsVLvgFwFlhXuoenRtE/RSH29xHhK5C/ojunw=;
        b=utundO2y++gRgk5k4lTK2CLs52oXDmBHUxCI/s+Nu8kj9bdFLvWskR3yjl8oz5qx1F
         cKOS1KWYvo4HlBHGl+48XRmQJ2ZuxYIp8fhWYatEr3zPUe1Ye1fQEeArBtGd0mp3ASJq
         AyqfMtt4wT4FdalFh2rcFUq8J3fbNJa+oNIn9M8yHaHLhKLlf8OlbfAl1RiGEMXr4euH
         nJ8mfJ+Ez08ywZwKolHM+EeLySNAYZCXjZ5iMCTqMNMbkWQIiHIoVIz6UVPUkAOJ4/JA
         u5lc3KkDntzkptg9HXw8XcUtrTsCqhzoXUfXT/HlWYDEcY2o+MExxeKm3IMrinMEwvKd
         VGUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ON2YtlFsVLvgFwFlhXuoenRtE/RSH29xHhK5C/ojunw=;
        b=mSowg1cy1rRx7lBTa+LAUm9lXtBX3eW5T/3UwNQvY/Ko50aDArJ1a81WfBeD/CfiuQ
         fWMpcHMyXx4op3MXZRKDH1yprMLhJ4DwCDJqT3H2uVhdvSoeZTNSKybCQ1+sqrq2qkl+
         v/GL8ERxcTYexPLdy2biqm3r5CmfA0isoBrFRnd/DXcenxLoopWrJC8dF73r4CrpVEKp
         dmUo43HZT3iklREWfevErS4qf5eAcO3M7jLDzk6R3LGg2P/u+/W4Yf3pqfZANGDgJfsx
         cbNGkoO9dVFAWR3f7EuGky8+HoB6Y8IJdWBjyuFoVmHcrm5Y7SwcbhbamrclzJP0QrYH
         MNTg==
X-Gm-Message-State: APjAAAXHg5jSp9/c/LZuVMeY54/5pRldY787v8a31m98a8mqncXLgRJT
        JnQmn2K/oq6F5p3GhOaS61UnGA==
X-Google-Smtp-Source: APXvYqwuXOMd4+//M/atmzuW1kiCEgLrrjTc7tt04tFFJAPLBYDT/jk0Azq6dl8c3hHfdReyQqzscA==
X-Received: by 2002:a05:620a:12b9:: with SMTP id x25mr58210847qki.248.1558367735145;
        Mon, 20 May 2019 08:55:35 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id s12sm8704685qkm.38.2019.05.20.08.55.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 08:55:34 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 2/3] flow_offload: restore ability to
 collect separate stats per action
To:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>
References: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
 <b4a13b86-ae18-0801-249a-2831ec08c44c@solarflare.com>
 <49016cd0-c1c3-2bd7-d807-2b2039e12fa3@mojatatu.com>
 <9790c274-445c-d3d6-a9eb-349af4103937@solarflare.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <146f15e6-402f-63ac-5e7d-98e7c6da9ea6@mojatatu.com>
Date:   Mon, 20 May 2019 11:55:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <9790c274-445c-d3d6-a9eb-349af4103937@solarflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-20 11:46 a.m., Edward Cree wrote:

> I can't see anything stats-offload related in net/sched/cls_u32.c (just
>   SW stats dumping in u32_dump()) and it doesn't call
>   tcf_exts_stats_update() either.  Looking through ixgbe code I also
>   don't see any sign there of stats gathering for offloaded u32 rules.

Will look into into (also Cc some of the intel folks). I was sure I
have seen at least the flow stats updating when i last used it
to offload. They may be using a different path.

cheers,
jamal
