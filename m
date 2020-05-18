Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F0E1D7DA7
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgERP77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728199AbgERP77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:59:59 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49294C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:59:59 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f6so5044580pgm.1
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=vViKERqJOakH8p/LEYiawGQY0S7vLNAgpEZTrLwRx60=;
        b=GlQ/qV4thuYPpmWSFEMqRsvpgOYmr8Xw2AMRTHLXsU/yToWQqqs+bOSPby5hgvFJzX
         /VH2jV2ieC/ngXNA4IKzkhiuTm7h45oQtLkCyl7wPniY88HyVb1G06jP0NXQD9kK/ZEC
         OtZwykFwRtZVt+IQryJCfjCpj4qb9hqQPBLIcYckxzMe/Bgaag4PiPq94Bj1RB1HyUzu
         UG0pfDIHdo4E2/Lk+OR79ZjHEIJyva/Omsw2+BmpeFgUOqe6+hmIDeZZpq8l9m6AJlnN
         9m/kHX1OVuYVUa0lN8u+/gaD/6oltleA9RFJP/bNzkG1Ac7djsGLL3z4Pb1WrmN6l63S
         03wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vViKERqJOakH8p/LEYiawGQY0S7vLNAgpEZTrLwRx60=;
        b=S+1TQiQdyMn33jY5c7lL55KNlMwh0hAg/JXn23LfEJaDDFn94YP49IRtLjld9TUJ3B
         7LWXbdn/36Al4XRunyD+F6fgjykDrGWnPTBzpEwYi/ozlrWWxSFomhoYJg6yvu6dw0oe
         psVObWMtlxs4tcF+5wb7DTigTDZo0Q2NiXtcsHuBM0v+MZTkGKs4F6L1OGyonnp8my3O
         aqyjn3mHIu7Q9VNlrCnRzCeSbGy62zzuam8Od1rWQ/l+s2WxcyWbTk9U8vT9sUo1/x4e
         ik+sOHCPr9bm3QFqRG0tw0W0ES5zRmZsXKRMS7nad3/FlEUZ0IHTyIyo/uqhESmCOG/g
         dOCQ==
X-Gm-Message-State: AOAM530AujX3iqjjQnRzRUZTMg1aicuTvqbC9e1lT0xaGw+V9j344SjK
        BnOQVjTB9uftlAHDwiaa0/QA+RsA
X-Google-Smtp-Source: ABdhPJyiMLlmVrQsL8iXOMr7WKupx0no+6NAlg1q23EgL5ANDyTpmweb1axBUy2bKpflz+xXq+SolQ==
X-Received: by 2002:a65:51c7:: with SMTP id i7mr15651562pgq.382.1589817598553;
        Mon, 18 May 2020 08:59:58 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id d18sm3265921pfq.136.2020.05.18.08.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 08:59:57 -0700 (PDT)
Subject: Re: [PATCH net] __netif_receive_skb_core: pass skb by reference
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>,
        netdev@vger.kernel.org
References: <20200518090152.GA10405@noodle>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <22579c6e-76e2-51f3-5911-819784cd30cf@gmail.com>
Date:   Mon, 18 May 2020 08:59:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200518090152.GA10405@noodle>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/20 2:01 AM, Boris Sukholitko wrote:
> __netif_receive_skb_core may change the skb pointer passed into it (e.g.
> in rx_handler). The original skb may be freed as a result of this
> operation.
> 
> The callers of __netif_receive_skb_core may further process original skb
> by using pt_prev pointer returned by __netif_receive_skb_core thus
> leading to unpleasant effects.
> 
> The solution is to pass skb by reference into __netif_receive_skb_core.
> 
> Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>

Please provide a Fixes: tag for such a scary patch.

Thanks.

