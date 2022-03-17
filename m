Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE3D4DBCB1
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 02:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243428AbiCQB5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 21:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiCQB5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 21:57:14 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE041CB07;
        Wed, 16 Mar 2022 18:55:57 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n15so3298717plh.2;
        Wed, 16 Mar 2022 18:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cCQk19mph1BSQQbRy0W7Dk+XD4eO5zrAeFybxCC9egg=;
        b=ElzKfEt6I6S0R2iDGmK4BrqQUPMtpKgQv9dW4pWHiC+Z6iVoKSvG9v41s3MdxrIQFH
         GYKHd4YkDW9vMcn1SchFxvkpt11/2N3Bk2yaGyyiqBcVXmybCKi07EfLdg0EcO4ZwV+L
         PrWs6w2WsHWs6tMx4VoZjn3lUy0meelIDWgeGeyiZ+zeCgyJgtnkfGi5VKTbasuRe0b2
         sqF/yKYVHzV4ZiXxDRQRmaczdnhAt2hMREAB2vLqlYnT5Ot4n/0Wq8WhE52QW+BJ17km
         Agra/qRqVPjsqZNb3eAcQCn8MAU/nVb0qRFEh12sxLainNXYC/5kDyfu4KGZOSNxl7r7
         OtZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cCQk19mph1BSQQbRy0W7Dk+XD4eO5zrAeFybxCC9egg=;
        b=79sCXvZASXQ3SXmkIveeFq8BUjSnEzx17/rA9u0ylbf8MdQRZ6TMjgNn8DrNyCjM4b
         OX1f3hm5jbTNqTzYLzJ7Ha3cgtt7WotKe8akQYB4x8rDpoOsL3ZRLpTCNpMBt3aXXRkh
         KTS1329sqwCsxieb/vp6Ba5IJZZLLJtS/q4RIWHYw8kzRHzQR7xKQE14Kardff8vLKpz
         3yEYN9xwnClRR75uBRMY/PdSG1VgWlPloNN/9GE72chirmMuEQwaZo/FDiTJPtQoqhVv
         uoa6jTGpa3J7zR71dt8/t/B/WXKOmuOnFodYwByDqvxCz1+wNkj6zJAZIoE4h1Or74KQ
         etQQ==
X-Gm-Message-State: AOAM532aO7JLKYqMfJM4AT454+LhFna6zivCVAEoPoYPrfPEf0IKI7X0
        awb78QN3boQcaMS42CqmKj4=
X-Google-Smtp-Source: ABdhPJwJbxGdMfcN9CTUn6aA06VML0lU1P1+VXDXZNa1jg6n4ZIW3UQ6K8wO/KYK8YyFBGvmaMEHtQ==
X-Received: by 2002:a17:90b:4c8f:b0:1bc:a64b:805 with SMTP id my15-20020a17090b4c8f00b001bca64b0805mr2711271pjb.156.1647482156931;
        Wed, 16 Mar 2022 18:55:56 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id me5-20020a17090b17c500b001c63699ff60sm8102769pjb.57.2022.03.16.18.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 18:55:56 -0700 (PDT)
Message-ID: <23d2d5a4-9496-a836-735d-31f1b02ce495@gmail.com>
Date:   Wed, 16 Mar 2022 18:55:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] net: bcmgenet: skip invalid partial checksums
Content-Language: en-US
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220317012812.1313196-1-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220317012812.1313196-1-opendmb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/16/2022 6:28 PM, Doug Berger wrote:
> The RXCHK block will return a partial checksum of 0 if it encounters
> a problem while receiving a packet. Since a 1's complement sum can
> only produce this result if no bits are set in the received data
> stream it is fair to treat it as an invalid partial checksum and
> not pass it up the stack.
> 
> Fixes: 810155397890 ("net: bcmgenet: use CHECKSUM_COMPLETE for NETIF_F_RXCSUM")
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
