Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257676ED424
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 20:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjDXSMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 14:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbjDXSMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 14:12:52 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6742C49FF
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 11:12:51 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-63b46186c03so5905714b3a.3
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 11:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682359971; x=1684951971;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wImhHChUvJwJ9CiztvvezaN8tSdGbdcu0B/Q/Tp1Qp4=;
        b=gwQfl/KVghrYcs3EnpMtTeISdROpEAm6u19f2feJL/+iaFHC3swkWz+j9r8QM/G5kO
         260osNvsJzvSzzoQSGdLOw6r+S9qgKHl9gEnDE8XshIOvV303a0a0fi1m9jQsV7dZY1V
         7c3UdttzrS4Kg9gpayIuzyGW/hOevH4fMw6lBoaqH6sZUcnmX6tWZRqp6y5H+9fTlYwF
         DnuUVlSJZxWRwDVJUYZVAnGXey0C5+5t2b9KwV3S8Un6JMESvtGwW7V/t9ZjDS7Qsi91
         wjRQS6G97LZ9PKYtYekvoJ07BVL8LPsu4bfrG26wDqctJ7w3itOBEu/bYXIQnWIUemtR
         81Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682359971; x=1684951971;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wImhHChUvJwJ9CiztvvezaN8tSdGbdcu0B/Q/Tp1Qp4=;
        b=b6TzcXbNA2/7YxCJrErwkdS+IHsISmTN0BBpL33Vaex/7HauVNkZzObd9KbWV9g812
         DwVSiqrr6AD1I2fVURpEDV20IiCd4iIVoBO6uTtg9Pu7L/BN49ld0xd1ulv+fDzAdPjE
         WT4KZ0JgmLuq0WBtg7C0BNUhU2mJ9EzVZmbyXSsxcZDkpXRrqzrCpm5ikU1CY+Ar8pQi
         +edsbcMvN/0vfOZfaj5EadGMJF7NKLjOL3sOX4FDAcPrAZUcw2avZMC2yvBXiu4L6tiH
         6hQyRTuT/K7qpK5EmcAcWogT/cFtPvgCMu/S/hyBCidSejLheWWBoOdBJG9hoaDpVD2B
         oGxw==
X-Gm-Message-State: AAQBX9f+qDB6Z2FBeDkedk11US9LfCULvWwhuj9eS2kExgxp3wZEOd3S
        rA+kTydRrL9a4gHDu8rvI7c=
X-Google-Smtp-Source: AKy350ZcKPvW6dg2pQucMYLp0e4M3DuHUXcBP5Wg5RdHjuRCKDnENuT9ALrIOcaiBFqYekwDrTX1Lw==
X-Received: by 2002:a05:6a21:1519:b0:f0:e69:748c with SMTP id nq25-20020a056a21151900b000f00e69748cmr17623445pzb.58.1682359970737;
        Mon, 24 Apr 2023 11:12:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t6-20020aa79386000000b0063b6bc2be16sm7965620pfe.141.2023.04.24.11.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 11:12:49 -0700 (PDT)
Message-ID: <a40cd27c-175d-a7d6-eb34-2c610d58a6ad@gmail.com>
Date:   Mon, 24 Apr 2023 11:12:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 1/1] net: phy: Fix reading LED reg property
Content-Language: en-US
To:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20230424141648.317944-1-alexander.stein@ew.tq-group.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230424141648.317944-1-alexander.stein@ew.tq-group.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/24/23 07:16, Alexander Stein wrote:
> 'reg' is always encoded in 32 bits, thus it has to be read using the
> function with the corresponding bit width.
> 
> Fixes: 01e5b728e9e4 ("net: phy: Add a binding for PHY LEDs")
> Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

