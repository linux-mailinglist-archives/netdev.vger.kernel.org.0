Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F745363BE
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 16:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352648AbiE0OGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 10:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235298AbiE0OGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 10:06:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F9903E5FC
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 07:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653660361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HTjXd21HXxSnzRq7RbR70sFcuqq02BM3bWl4D1bE8yw=;
        b=MDYvte+zO64QHqASTuUXOUHwk9JSmus4B4v9GRw2z68saLzM4r9QVuniVl7SfSuJEtorX/
        TkA17BEDWNOYpzcqPktWcCEZz+ui4RStA3F9hCZaEACyyDrgXawVQ3/0E50Z8Vc6YQXrMK
        /Nxx8GyopnqN9SJeZsbnqeDwuEZek10=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-5RbYwKXxNVijSFzBxnvEiw-1; Fri, 27 May 2022 10:06:00 -0400
X-MC-Unique: 5RbYwKXxNVijSFzBxnvEiw-1
Received: by mail-qt1-f197.google.com with SMTP id c1-20020ac81101000000b002f9219952f0so4492511qtj.15
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 07:06:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HTjXd21HXxSnzRq7RbR70sFcuqq02BM3bWl4D1bE8yw=;
        b=lpINz9VgAVoE1/WLcZ6FuSTrEc9U7hUC7TWh+vT23MA39CEhEwtALBflsFdKrlNVsm
         Twi1/8Tl21dPmOhxQARCANpT83D/GuE7l3cgKDvIzNgL2uOpB+08cbCimTgmZEo88BMN
         xx9rd2UWZmOYZQARKoqHfE/H4DpRDXqwisb5avDPnl8snSqyyp9LzmobcSnMYauwg9vP
         sGkrcg2bwgoBRtRZhETDZ8cRpy70Pf/nJyG3F7Add3PY356rhdQ7op9307bhk4JWHeUy
         DyLehczoUcyMyZJWbmy2XeyBOEC50Ytb3mNbIMpszsMxofSbXt9SYrWaS2zuZLyYPx19
         weog==
X-Gm-Message-State: AOAM530cTvixSraEX4JUVURP/an3Q19fSxzKNl0cwFbBiBwMqGVpHaSE
        2JJ75CbZiIqxQmDYzlOn2szn/JHgc/1k+XLs7zKu5eZA4l4Hwdnd3zYhhQnnT+QV3Y01qeFd5vG
        w/Z5wdWioQ7ddDgkZ
X-Received: by 2002:a05:620a:c54:b0:6a3:226b:49f6 with SMTP id u20-20020a05620a0c5400b006a3226b49f6mr27245570qki.396.1653660359484;
        Fri, 27 May 2022 07:05:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4xiE6OUdrPYcTV++CCP76ZeSSewSWqQxlDviqHPycwHuZrSc4NrmzSsH7Pg5IVgYqnBxRrg==
X-Received: by 2002:a05:620a:c54:b0:6a3:226b:49f6 with SMTP id u20-20020a05620a0c5400b006a3226b49f6mr27245551qki.396.1653660359284;
        Fri, 27 May 2022 07:05:59 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id 17-20020a370711000000b0069fc13ce1f2sm2772056qkh.35.2022.05.27.07.05.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 07:05:58 -0700 (PDT)
Message-ID: <e3f7d861-1f92-f30f-8f9d-35dfc59d1c1a@redhat.com>
Date:   Fri, 27 May 2022 10:05:56 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net] bonding: NS target should accept link local address
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, Li Liang <liali@redhat.com>
References: <20220527064439.1837544-1-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20220527064439.1837544-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/22 02:44, Hangbin Liu wrote:
> When setting bond NS target, we use bond_is_ip6_target_ok() to check
> if the address valid. The link local address was wrongly rejected in
> bond_changelink(), as most time the user just set the ARP/NS target to
> gateway, while the IPv6 gateway is always a link local address when user
> set up interface via SLAAC.
> 
> So remove the link local addr check when setting bond NS target.
> 
> Fixes: 129e3c1bab24 ("bonding: add new option ns_ip6_target")
> Reported-by: Li Liang <liali@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Jonathan Toppins <jtoppins@redhat.com>

