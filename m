Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A1A585686
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239107AbiG2VfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238561AbiG2VfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:35:19 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E7A13D06;
        Fri, 29 Jul 2022 14:35:17 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id o3so5679453ple.5;
        Fri, 29 Jul 2022 14:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=ctQAX363rsH/p9LbAtTPy5ADXSIz1/NNB/tqxt9WPYo=;
        b=PLCmUXHoS4aoCKypH0k30nKJePk8xyvuhjAAfeHyZ3JqEqA2LWhd9i2i89npRiM+WW
         +QIkJHY4p1cFlC2PGS15EDiqhBavg78AZzMngVcrmS6yKHrjmMxaiIr7paDcrsXgBsLy
         kBELNNRNPAMaDhqLjlEwFSs08UgBdFPuTXOTpbQrPSDuf1sWnzmHpvtqbL354Xv/akJF
         m6xMTr0fxzfACPlQl+tAmxCGO3k0MWmInZ98N/smVKI7rsgKOls/vCbTec5qyauUp40M
         C8U0jPzbpuPbNQb4kBKc1l2hMfefTOuaqcg9VI9QpmDVz+ET643ts70mTDK/UAhyF9Tr
         cKeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=ctQAX363rsH/p9LbAtTPy5ADXSIz1/NNB/tqxt9WPYo=;
        b=RnVc1heCdfuPUcx+EnAT8HF1+Ls+3AdItt3alVm3AwnNEkV7yp0KjiSmYb7KYDmtuw
         7qgVVWsOxHYv/U4P6P2DFwCgKaun8b1ha0Ef508S/+Aje501tnJ8QnXPIxUwQ3Sg3OjO
         9JJgw2yxqiyB6fpKczxKdIXw+Cy6ub7OBkqp1gLUgue+6GMxeUDYirF+mcuwfCWIPyYP
         DkNFV5zFqMGJwYF2Az9vvaGfaKGFFAVN4np1NRDFQVPxMnWNtdMbXytvzXIupthfTAcc
         DmYYZZwx6PgCio4KAkZq16NIRKHYCb8dlM7znHCjKSptndQZyeHtWxceBPFw43ChMtCo
         +FDg==
X-Gm-Message-State: ACgBeo16PMGVML3+pAg4G62n94eTRcAqUGwt5Gn25FNUxFzINABeRFRN
        66h3WOUGetcuR0jvygac8S0=
X-Google-Smtp-Source: AA6agR71AWeFSWOnLN/3lI0IB78F9XVzKM6ySLzT6Zhk4Sv+Tsq3TLoWEgY2372nkuVRFIaWHYld+A==
X-Received: by 2002:a17:902:e552:b0:16c:571d:fc08 with SMTP id n18-20020a170902e55200b0016c571dfc08mr5839177plf.151.1659130517174;
        Fri, 29 Jul 2022 14:35:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q12-20020a170902a3cc00b0016c6a6d8967sm4130333plb.83.2022.07.29.14.35.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:35:15 -0700 (PDT)
Message-ID: <58d1db2e-3479-a5f7-5953-2ad9829ce0bc@gmail.com>
Date:   Fri, 29 Jul 2022 14:35:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH v5 05/14] net: dsa: qca8k: move qca8k bulk
 read/write helper to common code
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
 <20220727113523.19742-6-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220727113523.19742-6-ansuelsmth@gmail.com>
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
> The same ATU function are used by drivers based on qca8k family switch.
> Move the bulk read/write helper to common code to declare these shared
> ATU functions in common code.
> These helper will be dropped when regmap correctly support bulk
> read/write.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
