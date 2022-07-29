Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77A5585696
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239394AbiG2Vk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239328AbiG2VkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:40:23 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE9917A86;
        Fri, 29 Jul 2022 14:40:22 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id f65so4929107pgc.12;
        Fri, 29 Jul 2022 14:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=vlA58bxC1AaisPQbaqWyCf1NUWhlZZvll0BcgQ47j/g=;
        b=GZC/zVEtAyvBd6idTM5yLb4hsR+lTlVC2hm5phsgfPtLGDlW+WTsmWuuF/JuqpZtEp
         gIOT5is98EzAPNTxvG7OWSJJv082JTUHCJtwDXpjryuOSJnTXK/29JlA6QfHsEfXJme7
         nvNcslcs0uzw35BhPdkrlpDAsYcyrRqvWalZNlB8yjPhPrgMckenustUsjSr8onXVdQC
         lm5LyqfHIH9zNlR9jQu3o8ZwZRkjE9bTIGJdjXq8fcW7wSk3DreWA3oNIRXuS8ulCgPU
         kEPfeBrdTmQ8kKQfk1OueBRDmuWpg1l+5vd+GIWEUQp9YCwMFiRo7cHMA85glGjt31Ph
         H0Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=vlA58bxC1AaisPQbaqWyCf1NUWhlZZvll0BcgQ47j/g=;
        b=GuMPHp2HQTQp/qLAhjQZxKL9ITBYQrZjLT2lNpBARSGySlAizvF/siwxF2xOmKOW/I
         Z3MeQsz/MPDK6OXmHjhB7vNvHIyPtQE2nQ/M7VbgzxL5O7tlowrz15Dh8U51P0ZGVYvL
         jmWswP2fLNsyaYteCaF64QrYYzKRHiwyD7VnJoHtKOiyYWaXgNrfUA/vLnKaFKZrhdx/
         5Ll6/XhebCvAsig4ez2mrNY3XPsUGt/h0M/Y4qIoqEUw+pEY1OPuIxW2VMWvESufSSgR
         QDihq5KzksJjbpIPU3dAVfflrxxmL/hCZBvgjpam/IvdmiVHsDQIzMfeEHp5wx71sa/+
         AIKQ==
X-Gm-Message-State: AJIora/vzjq636Ay0yGXwPiYxZGEEXrTOATxlnDPDlI795D1Sh6fDsVo
        vkc5K4/UxVjgv6mFVVifs3Y=
X-Google-Smtp-Source: AGRyM1vK5rSuKX7+bKgzsce/ianR1zZl7MeRzFCxZLZGqcjDEYw2LOGCuyT8z4hAdJMcz00zcwCx5A==
X-Received: by 2002:a63:c158:0:b0:41a:6685:59de with SMTP id p24-20020a63c158000000b0041a668559demr4549446pgi.95.1659130821474;
        Fri, 29 Jul 2022 14:40:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m24-20020a170902bb9800b0016c68b56be7sm4037099pls.158.2022.07.29.14.40.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:40:20 -0700 (PDT)
Message-ID: <e9b5eae5-1bb5-0071-4f47-b6d57288506e@gmail.com>
Date:   Fri, 29 Jul 2022 14:40:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH v5 10/14] net: dsa: qca8k: move port FDB/MDB
 function to common code
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-11-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220727113523.19742-11-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/22 04:35, Christian Marangi wrote:
> The same port FDB/MDB function are used by drivers based on qca8k family
> switch. Move them to common code to make them accessible also by other
> drivers.
> Also drop bulk read/write functions and make them static
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
