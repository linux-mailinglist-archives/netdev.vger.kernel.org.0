Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2D56E29A1
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjDNRrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjDNRrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:47:49 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04977189
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:47:49 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id a23so14961751qtj.8
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681494468; x=1684086468;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tVWa+8gSjij5hpmcx5JBEi42DbAftpZsFuON8tIxC5E=;
        b=FBEJaZlNiTz/IRaDrT4jxfWdKjJ8FkmSvrUegmkV1Dl9qjDrJbWeJpteFqGQVgWEq0
         vn0sNAm71amVBBK9u/ldcn0oKI75PG3nqTGO3fdDnxFFgU4DyMpKebDwBtFIbv0bovH0
         a80q5MlUdqDJmo+f4TDCbqq/WnDGW3757npnF1Hp1qqtJK/MmmGY+TlxRWwefRACk7z0
         BsYjI0V6Hob2yuceeWcZDI10aotJBNn18xj0YcyC4PAaiMutuzs+Fec6coD9ajna2KEN
         ULNaiIvgUk5qIXTNvUDqHqnH29jurhDVIscMpQqoj4KiXqi9moX7MTIvPfS8ipWsOvXA
         CQMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681494468; x=1684086468;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tVWa+8gSjij5hpmcx5JBEi42DbAftpZsFuON8tIxC5E=;
        b=lMPgADT/8qS7+eUJSh0KD/eG1EqkIg8ZdvC7UuXzUAZYCZtEEPubgXA1kzhzicXIz+
         R3F1XiCNhRn0xWrCC/XFworMpZ8GT4JbQDZOSsqt1UeDaNB52ZKKBKnwQRpP7o/F6qf2
         8GDJX9ARxJg2H6BKdrem/Y/BYw+GWzllvXXuwTtwx5opjDu8dtTnDDOc56OaCgXm5T22
         VQEupbkerA3iK07rnKqeqhlw3V801QOxvtfDK7T8QW1Lhwx1MkS5FalJB44SbStPExv/
         WeBfS1hWuZcpsiRNEQtPC+LN5/s5hNUZQwdT0Dr6CzlS0g+SBZkcOLvvfhswXl3MZHEJ
         agWw==
X-Gm-Message-State: AAQBX9coQPZ1Hpk3xdh1fKci+VVJJUoHl3ePPZEXqZCPDSjbisSZn/7T
        95Vizosddo8j7gAxKtlKvfQ=
X-Google-Smtp-Source: AKy350aZDEmtmLugvbttKrDHgIuMY8hGNraPb0R7Q+1iZzpEnpSztT8CJwhFwvC7XJ5IyjzrjB99zA==
X-Received: by 2002:ac8:58d0:0:b0:3e3:90b9:2b16 with SMTP id u16-20020ac858d0000000b003e390b92b16mr11494214qta.2.1681494468070;
        Fri, 14 Apr 2023 10:47:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d6-20020ac80606000000b003b635a5d56csm1374808qth.30.2023.04.14.10.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 10:47:47 -0700 (PDT)
Message-ID: <6577dce5-b32a-3e1e-25dd-2c5412db2f03@gmail.com>
Date:   Fri, 14 Apr 2023 10:47:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/5] net: skbuff: hide csum_not_inet when
 CONFIG_IP_SCTP not set
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
References: <20230414160105.172125-1-kuba@kernel.org>
 <20230414160105.172125-3-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230414160105.172125-3-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/23 09:01, Jakub Kicinski wrote:
> SCTP is not universally deployed, allow hiding its bit
> from the skb.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

