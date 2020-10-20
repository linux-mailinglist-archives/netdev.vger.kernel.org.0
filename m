Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C612941FA
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408976AbgJTSOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408970AbgJTSOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 14:14:20 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED11C0613CE;
        Tue, 20 Oct 2020 11:14:20 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id j17so3600275ilr.2;
        Tue, 20 Oct 2020 11:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QefG8nC0M6FiwaH3/vs+QotCepEbPANzojpXiJ1xDFo=;
        b=FqsWlhN7LF3qFL+mecj3HRfGxX0uRW9Q7aHPmd7qXqTokAR/ym0FNgkIhVg8zvzuoY
         Im25UiRfAglcWu0vw/KMTJpsMJwuYjTSgEnOehQMDOaB6rdndb5LSL/oBLL8RN0l7EJN
         MUWpGV+1eF81Ta6hovYhLBVnS0/6HmDVmZXWrC+BYvJFQzWIRRUyddctZwTHtW4/QSU4
         pQa6eqaxSn5Nv70zDTAowc0joERubWmHXOtWF0MBxn6FoIpOvFjiTeV02I0BC8Pz2Tni
         loz94jCZs9gPNlyU5T9pWMIFD1yrMw1MWcUPGyzHCDYfQKul5dIqlntshNz4wzzPjNDE
         13Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QefG8nC0M6FiwaH3/vs+QotCepEbPANzojpXiJ1xDFo=;
        b=twFsr/oHfRTXn5dYLPbNYJf6giW/KASHvaktbQKe7SACa2zX2ZZ3XuSV8pGDT9vqNw
         Duc+299UBuQAOjDEwAxi1IwPFtE3rsRLlb744I+904BKhwrynj7+nPETreaGD+qYjE+N
         iWCyIgQKkSCCf9JwY1BtQ8O4ibjbaG55ZYFW6nidkkUImeFQ9E9dbk/wk711Al/m/x27
         04g9ODGpQ1CZe0xc+S0dL9z6DdTRk7qPpuPB3KFWhjsKA0VobsZkBR6QM9HR1QQlFdE1
         jLDDHIlgUug4JrYQ4YAqiQNPsDGQi/D1x7T6X5aevRNCd8CNF0tnsgGakG0egxxD0Kfc
         b2bA==
X-Gm-Message-State: AOAM532d8IiwS7EzPScCTCulKPzxrvZb86QsQPRxnKkobkplUadu+9rl
        CtCBq9xYV25iIZ0Oz04QWghBY1IkW7I=
X-Google-Smtp-Source: ABdhPJwg8VvAeemicOy4wZeTBG87FWE8uBNikNvL8fe/DU9/HSGiUVJkJUwrs799Hgmdzk7gWJ+Jeg==
X-Received: by 2002:a92:d248:: with SMTP id v8mr2915798ilg.297.1603217659751;
        Tue, 20 Oct 2020 11:14:19 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:2cd9:64d4:cacf:1e54])
        by smtp.googlemail.com with ESMTPSA id x13sm2415884iob.8.2020.10.20.11.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 11:14:19 -0700 (PDT)
Subject: Re: [PATCH bpf v2 1/3] bpf_redirect_neigh: Support supplying the
 nexthop as a helper parameter
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
 <160319106221.15822.2629789706666194966.stgit@toke.dk>
 <20201020093405.59079473@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87zh4g22ro.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e8c261bf-2d43-ca4b-945d-353ada65c20a@gmail.com>
Date:   Tue, 20 Oct 2020 12:14:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <87zh4g22ro.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/20 12:03 PM, Toke Høiland-Jørgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> 
>> On Tue, 20 Oct 2020 12:51:02 +0200 Toke Høiland-Jørgensen wrote:
>>> +struct bpf_nh_params {
>>> +	u8 nh_family;
>>> +	union {
>>> +		__u32 ipv4_nh;
>>> +		struct in6_addr ipv6_nh;
>>> +	};
>>> +};
>>
>> Folks, not directly related to this set, but there's a SRv6 patch going
>> around which adds ifindex, otherwise nh can't be link local.
>>
>> I wonder if we want to consider this use case from the start (or the
>> close approximation of start in this case ;)).
> 
> The ifindex is there, it's just in the function call signature instead
> of the struct... Or did you mean something different?
> 

ifindex as the first argument qualifies the device for the address.
