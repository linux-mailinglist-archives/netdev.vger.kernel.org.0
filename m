Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7919A4A72CE
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344802AbiBBOOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:14:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32692 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238344AbiBBOOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:14:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643811279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+y9K91m9QPPmsSsA5/klqliIs/9Sf25p3BHVEid1hDo=;
        b=iQHdzKqxAipmE1WWKVWBPPwmPi+IRe7tpfKTcoPcQoegaRdSWy3m2h/x+qR8VxWNiDiXLG
        57yiefe/tbNFtz9q/q9/1Z0nmH0nwLNoE+EF8iFzCIIqyGo1/nu4PjcIHnL8NwV8m+I22g
        jtmntkjumaNHpp6Al30zWkf0j5zVjmk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-kQaDXAu9PKOYsKYK5xtMLg-1; Wed, 02 Feb 2022 09:14:38 -0500
X-MC-Unique: kQaDXAu9PKOYsKYK5xtMLg-1
Received: by mail-ed1-f71.google.com with SMTP id ed6-20020a056402294600b004090fd8a936so10491171edb.23
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 06:14:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=+y9K91m9QPPmsSsA5/klqliIs/9Sf25p3BHVEid1hDo=;
        b=m5eRKQBq/v2oYFFLxQ9KmVKHmbQCuz7s0f8wC04VpjrlspLETCUwFLXVZgQSjlqbli
         7Aq+ebCdvS8Z8X0li3VEQh7GdUu10ZIEJ1eKaGEbFUj9Arr0oOXH2U9Mp1XYAEOlBpIb
         tJiyGcw8AnRkA03tPEjn+y5/kCzMxDdPQFJKUXFJvBScTWciQzKp+dC0YTQwcMET+Df8
         t33nTUBz6yidpUDRhqKycwDIWnTRwktM7Q8FvmmZGGHH9QgfOEGd8iI52f9Q4uvhEF1r
         omDjt5rEBr7TnhhAt2d6xxwCwHdyGnfT9jDMLIG7+YCsh8EW58s25uu+ORDMq2SmKN8u
         oPWA==
X-Gm-Message-State: AOAM533eH4JN5ShBphthscI3+4c7BtZex/z1V28kdF0A2elyX3STF8sP
        FWxPR1g9DiHF6TK5sqjupD/ubcubLJ41svUNLIdXQGE79aMZDHcmDIM/qkc8/ONhKtKxfGdlmyV
        OLW6SsfI6ny4VfZGP
X-Received: by 2002:a05:6402:2549:: with SMTP id l9mr18123477edb.129.1643811276832;
        Wed, 02 Feb 2022 06:14:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSFI26aBe2IhgXO34LeNPfVoyGqpKQ9C8YoCWumeQ9jX1kghuUM4Rx53FHT+MmU/KN8bf4Ng==
X-Received: by 2002:a05:6402:2549:: with SMTP id l9mr18123458edb.129.1643811276644;
        Wed, 02 Feb 2022 06:14:36 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id az19sm6004307ejc.101.2022.02.02.06.14.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 06:14:35 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <1302c302-1a4b-ff0d-c989-cbe851c92e06@redhat.com>
Date:   Wed, 2 Feb 2022 15:14:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, kuba@kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, hawk@kernel.org,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: Re: [PATCH 1/6] net: page_pool: Add alloc stats and fast path stat
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
 <1643237300-44904-2-git-send-email-jdamato@fastly.com>
In-Reply-To: <1643237300-44904-2-git-send-email-jdamato@fastly.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 26/01/2022 23.48, Joe Damato wrote:
 > @@ -86,6 +100,7 @@ struct page_pool_params {
 >
 >   struct page_pool {
 >   	struct page_pool_params p;
 > +	struct page_pool_stats ps;
 >
 >   	struct delayed_work release_dw;
The placement of page_pool_stats is problematic, due to cache-line 
placement.

It will be sharing a cache-line with page_pool_params, which is 
read-mostly.  As I say on benchmark email, this is likely the 
performance regression you saw.

I *do* know you have changed location (to percpu) in newer patch 
versions, but I think it is important to point out, that we have to be 
very careful about cache-line placements, and which part of 'struct 
page_pool' is accessed by which part of the code RX or 
DMA-TX-completion "return" code.

--Jesper

