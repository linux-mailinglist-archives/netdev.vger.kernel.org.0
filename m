Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6189A10602
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 10:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfEAIOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 04:14:45 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:45802 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfEAIOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 04:14:45 -0400
Received: by mail-yw1-f66.google.com with SMTP id r139so7821195ywe.12
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 01:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MmY19Z1QVEc3yW3mekSsham5SrWXgj5jq6qjwyvS1O8=;
        b=KjocuGTflWsf4c3Wp6N3CndW5yRamNFECeIHqqxxGk98i+G4ne8zwvpYp2pHoaQQo2
         563cIGo39Dnf7SScSPM6O5XrOU0ltBBVErldG7zxk12bRNc9QgYWfrxHz2M3jOkGyDJl
         ifJ4r7A9EO6VTIMry8oeLnxDcHQ8UIdSJUqjaPQ2GcyYKguzROVN2iUDXGKQiqT1v9n2
         euuVQd9kgwVzV/ulQAcMyRwoH/NyG6lcnyXtYAQ3Q0HtXLQnubSoEbNduCz0sHGUfuoE
         lzIjEjNpsh+qR6kGeHncfgOzMLp37q265pdUsODliehwd2QMYG2dArLS65ANtgjFOlqi
         GtiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MmY19Z1QVEc3yW3mekSsham5SrWXgj5jq6qjwyvS1O8=;
        b=Kh6RMO7MeBCbRKyI9abVNRWzyF7P7Yxnyfs6hFoJy7DOLNy8fGb3cmBYGoFNBTn02s
         41R7wvT5ql9HXhhXFY7E8L4Zbb0G9dm99Dm8wuPi29XlQnlsugapdC2V/SlAA0i9FmnW
         m3NE2HrBQtZPjgNbJRmF9Aw/ewUOsX+HFF6JdVp4YiZEoTUQo2pYMObnPMgUXhtY4Vbo
         6+cXfIqZ3wKHMfmthaXMcElL57ETnkM99JSSzegJQx043+9BUJEBtLvak63crqcBP438
         gQyjkUv/LWoIDPIw7fFGPyN/HHxaf19KaZa58fYYNP4OucLFiZeHVcorV6oVdfipaVeY
         vx1g==
X-Gm-Message-State: APjAAAXFcX7fb081P836MfpUZE4xf/EL0GTXAbyCM4pCarqH6qavq0UA
        G21xO3JiIbySyu5jVOvWaV4lnlw9
X-Google-Smtp-Source: APXvYqya6VAL9fNseG8YBC0Q17tvGWgSbHVP7tbGkA9z4v6ls0qqA3KJ9VJJspNMhZ8rQDOz2oZFQg==
X-Received: by 2002:a81:4b94:: with SMTP id y142mr48670461ywa.69.1556698484466;
        Wed, 01 May 2019 01:14:44 -0700 (PDT)
Received: from [172.20.0.54] (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id 205sm4125097ywl.13.2019.05.01.01.14.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 01:14:42 -0700 (PDT)
Subject: Re: [PATCH 0/5] Beginnings of skb_frag -> bio_vec conversion
To:     Matthew Wilcox <willy@infradead.org>, davem@davemloft.net
Cc:     hch@lst.de, netdev@vger.kernel.org
References: <20190501041757.8647-1-willy@infradead.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <639880c6-5703-857c-8a70-82fbb5a90238@gmail.com>
Date:   Wed, 1 May 2019 04:14:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190501041757.8647-1-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/30/19 9:17 PM, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> It turns out there's a lot of accessors for the skb_frag, which would
> make this conversion really easy if some drivers didn't bypass them.
> This is what I've done so far; my laptop's not really beefy enough to
> cope with changing skbuff.h too often ;-)
> 
> This would be a great time to tell me I'm going about this all wrong.
> I already found one problem in this patch set; some of the drivers should
> have been converted to skb_frag_dma_map() instead of fixing the arguments
> to dma_map_page().  But anyway, I need sleep.
> 

I guess the missing part here is the "why" all this is done ?

32 bit hosts will have bigger skb_shared_info and this impacts sk_rcvbuf and sk_sndbuf limits.

17 * 4 are 68 extra bytes per skb.
