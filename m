Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B1E5B8638
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiINKXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiINKWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:22:53 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE9A7A748
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 03:22:51 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z97so21497473ede.8
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 03:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=FCB2dfjU6D6lrTtB/dxGzbs+pWzkXuVQzXm48PCV+D8=;
        b=ksM98+6N9jstQ0+VojxDUD+IXQl8XBxRW6JjUlLgVH4nt2YdoOaDoXXke817bxONwU
         JvLL0At5FosVvbMq5B9yWrafD9keuxt07VLCUkSXzbJJk3negUUoDFUtotGUYpa07fSR
         ymmp9/nhAYQbfGE15BBQslll2JokJ85ezuzDH6OC/CPldK8YqnbofvpvRiRDtGqxFFGF
         lGtM1Muu5YszhO3VpaVirrFTrxpBGSXRBT9uPuQYhuwsXkGl8BnFr3cf1G3fvinRYrS6
         XomYJsuRqKlRhknh9CIUPzirnK4M+iTffm3SSr4ebRllsczNhrwLhVGkGvaK6WC49hb2
         ji/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=FCB2dfjU6D6lrTtB/dxGzbs+pWzkXuVQzXm48PCV+D8=;
        b=OWZT9EgI60xzyWKTe3lBADNONgPje0ecHX6cipXi4JrqEbQyV13XLZr1BKLEmn5uoq
         3iSGF/w+LvjAP90E1u/1qoUsQx3IkAYP0UGgGeOnY+c+tZ4BQA0Yhun/TdvJtzwaSWe5
         GRggrUK9KRfuz273zU6SSjkIe1EfLCH2bfnq5RxU+22xbx/l4NTxisxQerS0x32ri3yR
         eHnTxBWBKx6XTHg0nmK+SWZh2w8KYXcqXZmNQtBB1tpgEHEeP7HO9mkHaF+xJ1+xVe+E
         xdc3nIxLzuChEDcKFJ0gyXvF2LvjlyAF4Ovk5xypHmbDZl6Kx74pnMIMefytIJeIXpr/
         J5eg==
X-Gm-Message-State: ACgBeo0Do1NP0nAvbQS/+3jVWiu6uTUiFa1Yew/OyuP4eie+4H5OdDsa
        FZ4CArHN/4icP7PB5HC7Kfs=
X-Google-Smtp-Source: AA6agR5O2sVkEbImAdKX8Ns6+aIic1loiTNgTkRLQ9VYu0dReb1fPVQl+l3yb/ju6V3+9kssg9oskw==
X-Received: by 2002:a05:6402:2711:b0:451:327a:365f with SMTP id y17-20020a056402271100b00451327a365fmr18229150edd.315.1663150970520;
        Wed, 14 Sep 2022 03:22:50 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id ed10-20020a056402294a00b0045184540cecsm6937837edb.36.2022.09.14.03.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 03:22:50 -0700 (PDT)
Message-ID: <d3c78b6d-cb8d-bb0c-56ca-910d0e6cd148@gmail.com>
Date:   Wed, 14 Sep 2022 13:22:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net-next 3/4] net/tls: Support 256 bit keys with TX device
 offload
Content-Language: en-US
To:     Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20220914090520.4170-1-gal@nvidia.com>
 <20220914090520.4170-4-gal@nvidia.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220914090520.4170-4-gal@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/2022 12:05 PM, Gal Pressman wrote:
> Add the missing clause for 256 bit keys in tls_set_device_offload(), and
> the needed adjustments in tls_device_fallback.c.
> 
> Signed-off-by: Gal Pressman <gal@nvidia.com>

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

