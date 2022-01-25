Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCF449BFBA
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbiAYXtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiAYXtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:49:06 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACBBC06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 15:49:06 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id y23so15996821oia.13
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 15:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CDSGmewza6xbssONxc31gNjZpVHf/37UGKoPIlYrUF0=;
        b=CugF+ITjpXVAVDPyWckhkze+YFSHGNdgEWRUMXeWNrL2Z7+mgFRnUzDs7yc5Lm0y28
         qXZ8zur3GpW/ozvSFr/KBU5UDnuix4uEheJ2SqPt2LpR4qOZvY+4ThTp3MsCq5G7bd7w
         PTW3AMlJYhIucxFyWSeginmhkUXw2vARgFPkr7suU33161g12YRJsBeDyDUytg4BVz4x
         ONXZBgFWbDFaHf2w/wwJ85hpHarpmUwkOz2QrEyfdMvrznla72pwXK2Q9hUhXdUz4Hwk
         p5LizyQnAmcgsVJWoFkNicSs1bRKoCT18spvJv+C9/FYSoUif9t6FG3m71JNa+4gsKjg
         xrNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CDSGmewza6xbssONxc31gNjZpVHf/37UGKoPIlYrUF0=;
        b=YWhnmQiq89Xtn9x/qVBpI5W6+al0hPSAI4Bj2eQKcAjDgzkH7tsIA5IfFAD7axjdwm
         e/KpZdT6qV2FiEIoBI2/2F0EoCSSPueFnjqmBwdmANirukBPAIMJ4Wc9PsrPO3WMQlMu
         jTT4s83gH4lJHXFusSGfI4jPate1aKHhiVo3gHhdW0DnS3Zg+BkpC8vWdfVFpL66FQ/A
         GRecljBYUoaLs1eWvjeaHbDEvgsFg48YUiE2q5kmsIaqnfFutOfM2tCzvAVwVEDlxILA
         bXBvz5uc/SFTcDX+BJK6g6OBjM5BAgramwfBLKx/HG9treIvsd30X8UsUg+x4f1+7hbf
         luiw==
X-Gm-Message-State: AOAM532X70g5GJvE5PXqaLXCHrjQSHOhJt2F9Tm8UHFtH29MhJh+HFxd
        3YvGRFwRTNtdvL/DAG8gPu79hI14pGQ=
X-Google-Smtp-Source: ABdhPJyfj1d82dzjgNikB4jfHazY4cOqEcNb9SLOnvAAvvwzwgQCSaIqqTt+ZtA68OQEjH0H651dzQ==
X-Received: by 2002:a05:6808:1a11:: with SMTP id bk17mr2085963oib.307.1643154545674;
        Tue, 25 Jan 2022 15:49:05 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:1502:2fac:6dee:881? ([2601:282:800:dc80:1502:2fac:6dee:881])
        by smtp.googlemail.com with ESMTPSA id j19sm4209919ots.21.2022.01.25.15.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 15:49:05 -0800 (PST)
Message-ID: <621185c7-be06-12a8-fe75-f544b392fb06@gmail.com>
Date:   Tue, 25 Jan 2022 16:49:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] net: Adjust sk_gso_max_size once when set
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <20220125024511.27480-1-dsahern@kernel.org>
 <CANn89i+b0phX3zfX7rwCHLzEYR6Y9JGXxRYa92M8PE9kbtg8Mg@mail.gmail.com>
 <6a53c204-9bc1-7fe9-07bc-6f3b7a006bce@gmail.com>
 <CANn89i+Nn7ce8=r07b00Acq9acmX9Lm6rTOx6L59REqaV2v68g@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CANn89i+Nn7ce8=r07b00Acq9acmX9Lm6rTOx6L59REqaV2v68g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/22 10:20 AM, Eric Dumazet wrote:
>> The git history does not explain why MAX_TCP_HEADER is used to lower
>> sk_gso_max_size. Do you recall the history on it?
> 
> Simply that max IP datagram size is 64K
> 
> And TCP is sizing its payload size there (eg in  tcp_tso_autosize()),
> when skb only contains payload.
> 
> Headers are added later in various xmit layers.
> 
> MAX_TCP_HEADER is chosen to avoid re-allocs of skb->head in typical workload.

From what I can tell skb->head is allocated based on MAX_TCP_HEADER, and
payload is added as frags for TSO.

I was just curious because I noticed a few MTUs (I only looked multiples
of 100 from 1500 to 9000) can get an extra segment in a TSO packet and
stay under the 64kB limit if that offset had better information of the
actual header size needed (if any beyond network + tcp).
