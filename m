Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0D25B8634
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiINKWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiINKWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:22:37 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C9B7A778
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 03:22:36 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 29so21522077edv.2
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 03:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=9Z/qBdt55x/4i1WIsv6RzmKdT6DXaH2gqLK/Qy5USlw=;
        b=RUz4yJH3qPswUqI0us/sE0cTUkL5nuzahHhIrhQaLJRkm4MaaTN2k1Q1JypNnc+I2C
         jXMqCT3unfoyTMEGMnLjsVn7sJlsuZmltyzpzSHkLMKHZIfoaoHx5K6ddjb6NBDngaxM
         sRVygO52k9MvmwXtp3Fi7xFgtsgG7aTQvnZJAO6rYSma198RU7WgY26Xbm5dSPZJ0sN8
         I0z/x43MJn3T0CS2eXmQS1AGQLvxDNq3ZwzHyaUiyCqiuu50z2eI18IbeWRkRGs3+H+M
         fLivqahgkglxda95sz50hWE5OceA7ixI+YZv//FY+KXKXHaE7dTF+TGUyV+sWeKgRfa6
         LPLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9Z/qBdt55x/4i1WIsv6RzmKdT6DXaH2gqLK/Qy5USlw=;
        b=SVdW1gwBXqPY3t8Rh/5am2gn/JN7ajRgzhpOuz5OTuBEzHRGAzBdiZ5+UsH+vibd7O
         FKES271NI4cFGEJHLQGKLxjEx6E3Xu1bqLQoYrvbNkQ1LVZiexGVEuMZUnITHyh3Kf5R
         59OWJ10fjA7v18hAmNc7WBRFW0uC2aGRtJ7r8jNcBizAwKfVpzRWtZqCrvbpIkuln290
         bejZWpyAthlkYZwu/+oqTJtEwWVyEcdHrtAD36hC4rknrfwo3s0qomd/IpWrAgOcAZAp
         M3ge/LUInWeft6fQ7txpTzbTpga81KNYvTIp5h0qFtq70G1Dmtr1Qx3JmwUzJLG+PW7w
         uIaw==
X-Gm-Message-State: ACgBeo3+Wld8bqwd58m2wGHF2WKQBED53rqPetlmhbedhC9eh6gYFUhQ
        usEXRYaJ49rFGZ7JeEsCq849ZS4maPw=
X-Google-Smtp-Source: AA6agR484IimW0O4GESkK0IsqFPm2RWhWqcrEZ7Kn9OjK14YGXbkdCtzgtDqsSg3kL4xxx4yrL6KCw==
X-Received: by 2002:a05:6402:22c7:b0:451:403e:68f5 with SMTP id dm7-20020a05640222c700b00451403e68f5mr17538510edb.242.1663150954763;
        Wed, 14 Sep 2022 03:22:34 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id qt13-20020a170906eced00b00730df07629fsm7484263ejb.174.2022.09.14.03.22.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 03:22:34 -0700 (PDT)
Message-ID: <5b094941-1940-d227-62c4-dc67b1978300@gmail.com>
Date:   Wed, 14 Sep 2022 13:22:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net-next 2/4] net/tls: Use cipher sizes structs
Content-Language: en-US
To:     Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20220914090520.4170-1-gal@nvidia.com>
 <20220914090520.4170-3-gal@nvidia.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220914090520.4170-3-gal@nvidia.com>
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
> Use the newly introduced cipher sizes structs instead of the repeated
> switch cases churn.
> 
> Signed-off-by: Gal Pressman <gal@nvidia.com>

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

