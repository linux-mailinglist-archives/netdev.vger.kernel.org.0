Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B9B5F2E4D
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiJCJmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJCJmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:42:18 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4446E13D30
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:36:57 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n35-20020a05600c502300b003b4924c6868so6801242wmr.1
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 02:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=aQJndaG6DPfbP06I/qvyeeVURu4TalD1jxBNk4UvYpc=;
        b=KBZWqY4DZ9BGd/jECxy88fQ6ADsHFdgfNUX6E7tJlX0yd86w8ifrwL+fIzm+CQUu7R
         PARWOp+Oaw3QTOoH/L+PRkr4WX6QqpW3t6jVFWU4NZOeZbXrrpoFtsVLkNLbMJGhdknH
         YqLUDlPZu7UtMdpnC8g1HwXcHsWJTZnXAp5tDhhFzlK0p0V2b2EuEyVSVAPmzCzCVOED
         DE75FEuvWbaA2qlsT1e+PxaWO6x54rMxSfsQMuN3rEYWYJ5CuDpDRAe5INeed3/xmQ3B
         ZH0AUA7I1EbARsz64tzDv6sz3l60jra5yVLJbG0f7Ar1wVCBipv8illJ5wD6v1NYEbMm
         iEUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=aQJndaG6DPfbP06I/qvyeeVURu4TalD1jxBNk4UvYpc=;
        b=uJglcxyHa+GNYObnN7DhLwKjRSfgOaNakDHPKHDD+Zo+zWj7Pi2b3EAl7x7MEY7HSL
         rqzIT4yHFHVCOZFue8VZ+UwErNOkH6T0vTm42IX6to37u0HeZJWiToJq8Elj5H2PNY5d
         imGYRfW9QkfM5r2bjjiSvSTAnHWieA4zV+ePsjTZtjSFxZH/Hx1qGK/FkdimRn4T5cZC
         WhJIkIdse3vVvBqKRmAERJ/dXyLV3JlTFjH6VCvZfAqdq+oCOb9VkD2xP3Hxgi0zmyHc
         7iwYTGiWKtVJZ+74tyfIpvEOhfr47TiAZGjkN5KVn0/pgIOfxqYGMxyP3CskZsDovZMS
         vnsA==
X-Gm-Message-State: ACrzQf0zcoQdD5inIJUJ0kXOWuHJ8XqbbNZvADfPvV1S85B7xgu35QbC
        DIiAShOhNzbzP5MuANBnSXcKt0MGZRayQQ==
X-Google-Smtp-Source: AMsMyM6kpXSYPlP3HTNtV0iDiDxHX7gifIKNHHVXBuoD8SBqeI5RheXhTpx4LcRttf255j6Bw58asw==
X-Received: by 2002:a05:600c:3c82:b0:3b5:60a6:c80f with SMTP id bg2-20020a05600c3c8200b003b560a6c80fmr6470538wmb.199.1664789801111;
        Mon, 03 Oct 2022 02:36:41 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:14ee:4d35:8c33:e753? ([2a01:e0a:b41:c160:14ee:4d35:8c33:e753])
        by smtp.gmail.com with ESMTPSA id e3-20020a5d5943000000b0022dd3aab6bfsm8435671wri.57.2022.10.03.02.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 02:36:40 -0700 (PDT)
Message-ID: <02b6b55e-d9a3-fbed-c053-e87730f7f270@6wind.com>
Date:   Mon, 3 Oct 2022 11:36:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH iproute2-next 1/2] ip: xfrm: support "external"
 (`collect_md`) mode in xfrm interfaces
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        steffen.klassert@secunet.com, razor@blackwall.org
References: <20221003091212.4017603-1-eyal.birger@gmail.com>
 <20221003091212.4017603-2-eyal.birger@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20221003091212.4017603-2-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 03/10/2022 à 11:12, Eyal Birger a écrit :
> Support for collect metadata mode was introduced in kernel commit
> abc340b38ba2 ("xfrm: interface: support collect metadata mode")
> 
> This commit adds support for creating xfrm interfaces in this
> mode.
> 
> Example use:
> 
> ip link add ipsec1 type xfrm external
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
