Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2548849AE81
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 09:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1452858AbiAYIux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 03:50:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1452397AbiAYIsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:48:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643100504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yd1WKnJi4EmxzcHW+i/qeODwBDDbmaxTB6i9RVfgt68=;
        b=GtM/3CaPrWqoejTVX43k+SHZoj1G53TQ3uml+WKwrM/AXd0Ae882jKheC68IcFpW2rbZj1
        vGf9ZDaQTk/f7X/U92tU/Pq6I2KE2Ih/l/Rxk7QoMny4191k3VWtffQe1lGuob9bo4lLhC
        sPhZFdC7ev1qC4KS/ngXrkjaIIu0yTs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-kySEggafM2yW7x6chEOlrQ-1; Tue, 25 Jan 2022 03:48:23 -0500
X-MC-Unique: kySEggafM2yW7x6chEOlrQ-1
Received: by mail-lf1-f69.google.com with SMTP id h11-20020ac250cb000000b00436e68ebef5so3890990lfm.19
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 00:48:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=Yd1WKnJi4EmxzcHW+i/qeODwBDDbmaxTB6i9RVfgt68=;
        b=Wz87dtKrBhR7mmCxfJOqJ62NMAT5J8ZRJ+eq8Ct++nMOMMxfNUvpxoecyXC2SZia34
         Z4QumVoeyFIgd1VySRMbhvQvvfaSiKGxmm2awAe7KktxrnAJosYvPAAacJv+6K6RznG0
         lbl8bTdMokWpBbw+2tu3MVQAC50NAZu6sKn02dX3yjjcIYxd4vtgHfuLmtY9TKDgFWZ/
         +qnlpva/x58pWGf8Fe0x7888ZcDjuGr+iLALDRgnODqyjK0Gp/wiHPDOzCadEdpfCXCW
         NDZnNcUW7NRM7zP+UwewrjsUwZMoAh/GxcTAZDtn0djWxIJdWxTV4zIMrMCx4/b5DLj3
         MKuw==
X-Gm-Message-State: AOAM533e64wGJsG7JAXQdBH1sNp7YhRiXpwWB5AEUkuosKSXb1CtexiG
        G4u7TeGxwaROkbQtZjJ2waJ6HrhjlkqV+c8m+MLsdUnvf5vhAMuyKmovDhq5TIByYpBgY8Flwc/
        VhaIwlD1RGFu865yo
X-Received: by 2002:a05:6512:39d6:: with SMTP id k22mr2385519lfu.35.1643100501662;
        Tue, 25 Jan 2022 00:48:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxwhNy1HNpMVvfvDUzZxkJK+1ehL/C8lfabAZ+HI1KNAiOuuPTUUmJY8rF7+xKxcYp0DPCgQ==
X-Received: by 2002:a05:6512:39d6:: with SMTP id k22mr2385500lfu.35.1643100501474;
        Tue, 25 Jan 2022 00:48:21 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id w6sm1413865lfa.222.2022.01.25.00.48.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 00:48:20 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <db6e0da3-b78b-f302-fe71-d89d9ea7ad88@redhat.com>
Date:   Tue, 25 Jan 2022 09:48:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: cpsw: Properly initialise struct
 page_pool_params
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
References: <20220124143531.361005-1-toke@redhat.com>
In-Reply-To: <20220124143531.361005-1-toke@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/01/2022 15.35, Toke Høiland-Jørgensen wrote:
> The cpsw driver didn't properly initialise the struct page_pool_params
> before calling page_pool_create(), which leads to crashes after the struct
> has been expanded with new parameters.
> 
> The second Fixes tag below is where the buggy code was introduced, but
> because the code was moved around this patch will only apply on top of the
> commit in the first Fixes tag.
> 
> Fixes: c5013ac1dd0e ("net: ethernet: ti: cpsw: move set of common functions in cpsw_priv")
> Fixes: 9ed4050c0d75 ("net: ethernet: ti: cpsw: add XDP support")
> Reported-by: Colin Foster <colin.foster@in-advantage.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

