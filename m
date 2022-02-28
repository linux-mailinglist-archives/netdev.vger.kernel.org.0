Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C5A4C63BB
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 08:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbiB1HVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 02:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiB1HVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 02:21:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7AEE66233
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646032841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eTZk0xJfGc6EE8AUO1z41QeuwbwSdLdUIQ5jmZmpGOI=;
        b=hLhe20JPsMaymFui/2DTbUbhSyE8ss7qnHE7zxlHqzSD5FxIjxX4JaoRuMf8G/1Txu93uz
        BQ7KbaTGclmoMc0qOJeT7KpmCi762cC2vQnKum06Mk/tnd7iz6yPIraWcUE1KDW/74W+Lt
        z6ij8YZpbtUKos9qi3+WCu7l1tFO9UI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-HC2-8OWGOwWYxq7HelEfRw-1; Mon, 28 Feb 2022 02:20:40 -0500
X-MC-Unique: HC2-8OWGOwWYxq7HelEfRw-1
Received: by mail-ej1-f69.google.com with SMTP id hq34-20020a1709073f2200b006d677c94909so1598609ejc.8
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:20:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=eTZk0xJfGc6EE8AUO1z41QeuwbwSdLdUIQ5jmZmpGOI=;
        b=bp+RNod2C/0kD+COnegMImA0EuIyv0//uG20URJf4QLcruNdLzxOJyQRQ92XWppxmx
         PtDxVnnqcx0cAzhQhb1RArOsZFEPWYbrWF+FL7nxgKzeBKtnsNk0/jO7VTXUKcx2bSO+
         x1zzoqH89W6tsZ5SuvmQXWfrZIBpu1+B4R8mFCYwdiZeUFHDA7l2kaJrfVbYUjAgRySZ
         O++aUA2c+yxXz9Va7PXPVoos4UMuagXNs08cpWuxY0kT5fZ5hiDq1DZy2UktbVflSJEk
         4wcodp+k89PMgBgSxMApLsFwGa0QLKkQrtRpDxugMk/E27V/bAMZpB5mMXdP9njmfZ84
         aFcg==
X-Gm-Message-State: AOAM531iTGnk5xiQPUTq2rXUayWtl6FbnkiZ731Js91FHrzxgG5Y50Vv
        ZRgbK4m4slJE/RGt0Xs+MzG+YmbTLvKWFNkm5phcv/ZM68Bh/YV9rCBDPGvuGYz5HipeB90ck+Q
        z1iu8c+ngJIaF1gFC
X-Received: by 2002:a17:906:a24b:b0:6ce:70da:12bb with SMTP id bi11-20020a170906a24b00b006ce70da12bbmr13712951ejb.667.1646032839246;
        Sun, 27 Feb 2022 23:20:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwBGcjbj0VuKB3nlrg9EmYfmmVh7goYSRyXe39Z/F8KlII3pGzEz2MCo4YA5Ppg07mX9cMhQQ==
X-Received: by 2002:a17:906:a24b:b0:6ce:70da:12bb with SMTP id bi11-20020a170906a24b00b006ce70da12bbmr13712945ejb.667.1646032839096;
        Sun, 27 Feb 2022 23:20:39 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id n13-20020a1709062bcd00b006cf71d46a1csm4045643ejg.136.2022.02.27.23.20.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Feb 2022 23:20:38 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <9b688d6a-851f-0e14-bdc8-8581a3dd31b5@redhat.com>
Date:   Mon, 28 Feb 2022 08:20:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com
Subject: Re: [net-next v7 2/4] page_pool: Add recycle stats
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        kuba@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        hawk@kernel.org, saeed@kernel.org, ttoukan.linux@gmail.com
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
 <1645810914-35485-3-git-send-email-jdamato@fastly.com>
In-Reply-To: <1645810914-35485-3-git-send-email-jdamato@fastly.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25/02/2022 18.41, Joe Damato wrote:
> Add per-cpu stats tracking page pool recycling events:
> 	- cached: recycling placed page in the page pool cache
> 	- cache_full: page pool cache was full
> 	- ring: page placed into the ptr ring
> 	- ring_full: page released from page pool because the ptr ring was full
> 	- released_refcnt: page released (and not recycled) because refcnt > 1
> 
> Signed-off-by: Joe Damato <jdamato@fastly.com>
> ---
>   include/net/page_pool.h | 16 ++++++++++++++++
>   net/core/page_pool.c    | 28 +++++++++++++++++++++++++++-
>   2 files changed, 43 insertions(+), 1 deletion(-)

LGTM - thanks for working on this

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

