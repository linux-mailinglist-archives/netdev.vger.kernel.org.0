Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8606148518A
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 12:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbiAELBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 06:01:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233824AbiAELBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 06:01:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641380473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ScZ3TE2gykrBivhMJscKvNWMm7uyLHSZ0sf5/ExeoAE=;
        b=K1vSxM7CTy2JnbO9/Tie8UQ11IIfgRfjL/ykXwLSz7mg2aOtwSffoIpuCN3MZ+z6Xu6dUv
        Qt93agtQw9ePHh09COOXckPKlQoZfYbCosrJI9ZuSPHlWu66wboAkovxKZYyp/+F9bIgo3
        U0beq/Nd+8EfT9nJvgLdfd+zi5LbRtM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-r5yYkDxzOVeNfCmV-Lv9mg-1; Wed, 05 Jan 2022 06:01:12 -0500
X-MC-Unique: r5yYkDxzOVeNfCmV-Lv9mg-1
Received: by mail-ed1-f69.google.com with SMTP id o20-20020a056402439400b003f83cf1e472so27703329edc.18
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 03:01:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=ScZ3TE2gykrBivhMJscKvNWMm7uyLHSZ0sf5/ExeoAE=;
        b=6zVAwMe+FzkquGjozIi2pxm/n3sc5r6zV7HORUEhIWi/wcI0ptRSkO82WBp1a7PNGJ
         DkKekrr3c4nAOuOnSZl/5Zem1UegBXwNIiFWm4oDo3zwMIflHIa66EYhOZkQtMXtHXb1
         0zKHOgLihOL3zlA0g9ReABKOLyBTtkmJ1AVEdN2OObmpXSqDvy8a6epbHTZGqVATSfgi
         V2/Q7IO0OsOwGOHqdQL2sAn7vWPWwKWqWUtCSrCQcfvp3sZusRhFaNojnahx1u+FzpLi
         5ZFa0U805fDx9i21dyeyA38QpUMsyfUFjNvHdWKZifjFPt1r4zwvgb9xebulnz3ZKb6q
         en9A==
X-Gm-Message-State: AOAM5329b9Pzopd1vk6bi/U5lpTOWo28kINTg/kSKYefa7DqdUKTavN5
        VhO99zuSRXjg4nNGzCgv6IcXVQSixfPjaYn30Mz/HNRM6TJf58wZf6uJMUSvmp4yBwlk3GzUs2e
        2buUGIrl0dRmS1LP+
X-Received: by 2002:a17:907:1b06:: with SMTP id mp6mr43715317ejc.275.1641380471079;
        Wed, 05 Jan 2022 03:01:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6ti3JnAwtJDgWqUho+M7ktQBaED4/dYRYvEOYqIqBSSlZOYphaEbnd7QHgTZZfCVoKl88sg==
X-Received: by 2002:a17:907:1b06:: with SMTP id mp6mr43715304ejc.275.1641380470929;
        Wed, 05 Jan 2022 03:01:10 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id k16sm12187959ejk.172.2022.01.05.03.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 03:01:10 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <88cd6117-29ce-54a7-5df6-5c1dc9adbe23@redhat.com>
Date:   Wed, 5 Jan 2022 12:01:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 2/7] page_pool: Add callback to init pages
 when they are allocated
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
References: <20220103150812.87914-1-toke@redhat.com>
 <20220103150812.87914-3-toke@redhat.com>
In-Reply-To: <20220103150812.87914-3-toke@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/01/2022 16.08, Toke Høiland-Jørgensen wrote:
> Add a new callback function to page_pool that, if set, will be called every
> time a new page is allocated. This will be used from bpf_test_run() to
> initialise the page data with the data provided by userspace when running
> XDP programs with redirect turned on.
> 
> Acked-by: John Fastabend<john.fastabend@gmail.com>
> Signed-off-by: Toke Høiland-Jørgensen<toke@redhat.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

