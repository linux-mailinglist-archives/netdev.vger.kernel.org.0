Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D1D6E299F
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjDNRqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDNRqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:46:52 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18AEC4
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:46:51 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id bn8so16891942qtb.2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681494411; x=1684086411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yTErrPIVGpzyv+C+uJD+JGVhz3SqZ0m369LCc+PwUrw=;
        b=rWKyld2urmoKGvkUMtjapSB8hK9EQsUPnDfck84e6Pk3wtYirVnoKymbgiVayMc+km
         8oXYhE7pkmQ7Ni0HqS//3THtrbDXU4oXKdnZ6+M2YyrbZqJxZqAgtWMsm191JWfeTPVi
         90xuYsWOiaqepLHrklM2oU9m0o+NIsIj+tFiq6/hxcUsLDKncfqZyeo/wChuNTSGOdX2
         Hk2xX46HBe1XMLnaMzw5Ngs7fO7RiMWMXsVDQHcRj64QEAAe1LdEID+7k0ZM1jREEDv0
         U9wwySyHJsfZPgoXBJoj+7K/QDGkLE5wZRfiqELd6PqMfKkCjFHIqFjX8hHTPr/WzAxy
         P9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681494411; x=1684086411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yTErrPIVGpzyv+C+uJD+JGVhz3SqZ0m369LCc+PwUrw=;
        b=H8eY/GQeFJ5y5bvJtgmn7CADLbzizbPggNdPMrehzPEj69duRSluZJwnvtfLT9Scho
         ktv2smyv0/XJY0JCWzuOJm0krkJY1yo41+QyDa4SXKUuPa30dEtw6gnSMD4aYf48GMOA
         3uYRHfdtvLYKXqScgfyg/G93Qlaw5vKeBq+0Z9Cw7Q2yWzXGHC8qFLKHzcWc+8+bdfD4
         jdn9bg/Bv5b0z2qh8QVc+y14NCXRhtgNj0VOmeMPSeSWdsVy13S2e4M31IxLkwLayj5Y
         FYCejozrXPTA5kAA9dtit1DX4tPv1vnWcG8sXtvY4SXAwp3eRe147ufMfQX7vSWhlq99
         PvsA==
X-Gm-Message-State: AAQBX9fhzS0XjF/IxMpop93UocZIu/G31Ev3nWVec38muBAPH+a3TOsT
        UCjia+11HPKJ8h0UWNGVZO4=
X-Google-Smtp-Source: AKy350Y38jKTmP/hUnbey2EJdLZPydajmxHhESpzd05zxHrolQZhjoC/C5f+3KBrcyQDBlRNRM/wBQ==
X-Received: by 2002:ac8:5712:0:b0:3e6:938a:2aef with SMTP id 18-20020ac85712000000b003e6938a2aefmr11382657qtw.9.1681494410845;
        Fri, 14 Apr 2023 10:46:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ee19-20020a05620a801300b0074357fa9e15sm1375663qkb.42.2023.04.14.10.46.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 10:46:50 -0700 (PDT)
Message-ID: <4aafc233-9d69-11e3-1dd5-f87ae38d123c@gmail.com>
Date:   Fri, 14 Apr 2023 10:46:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/5] net: skbuff: hide wifi_acked when
 CONFIG_WIRELESS not set
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        johannes@sipsolutions.net
References: <20230414160105.172125-1-kuba@kernel.org>
 <20230414160105.172125-2-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230414160105.172125-2-kuba@kernel.org>
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
> Datacenter kernel builds will very likely not include WIRELESS,
> so let them shave 2 bits off the skb by hiding the wifi fields.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

