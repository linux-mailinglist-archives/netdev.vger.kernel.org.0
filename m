Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DF96F1E07
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 20:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346476AbjD1Sav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 14:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjD1Sau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 14:30:50 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31AADE;
        Fri, 28 Apr 2023 11:30:49 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 5614622812f47-38c35975545so238347b6e.1;
        Fri, 28 Apr 2023 11:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682706649; x=1685298649;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=v0p8vLatMOCOsAkUrgnq0FtbnVi/IKxHmV8XesaoHcg=;
        b=fWhQ4QRIcNCQFe1WTDE8YH6Iq//MpFbWoDdF4B44FKRHSa6OZrfrQer6TcZq/IIPOM
         TKlwtYxx3B0tLDQESpKbLZ/sxQDWaBG1Aj47x+MC/seRqUruV/Ma1P0Idk0qWVYb98Mm
         pTqrpBWmQoBzLnwWKglFXanLyYD8lXgurkE4iEObpDwcmASQT8WvYvwA6Hui76rnji9E
         8t2J2/HGaF9h0GMUB/K80FsqGSLMblV2dZSPNVNB0afx5GUu5pLmWssXvwfVfqYS9LpE
         Bn37YC/8qEObJABgUuidE38ZI9NBKKPyfVsUbxzeMg/FEAzyu3vaiDMb73TPWY2gKfJY
         oMvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682706649; x=1685298649;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v0p8vLatMOCOsAkUrgnq0FtbnVi/IKxHmV8XesaoHcg=;
        b=f3YOWjwHYsbvtyYUAn3E3SWsBgIL8cWb5TACkJWUOFH7fpgXmfiOg8Bciv5oQEUkCv
         F5t10PI5vhfcF8SPrHhrTG7QzrjHbnN3GlvdsBMHLl1IBSv2UaALj6hRaq6THPMxeGHz
         V9iwlPkWyODdlySxH0PGJOqEPAkOOmN3o8VKaxnaGfgslLtHeKS64zTo0YjdWLz+OPeB
         SRUw8bzDqKYjLYgbXhSAyqZ2NQoKhq4jRRcgjl4ef/i2Lz+s0Jjkn7a+HumE2unc6Q+7
         BeajJocp77PSaP1Q6YesTC0NLGUcDqV1thtPENwco8KZodx+3LqX54WSYQI099yt44aC
         ouzw==
X-Gm-Message-State: AC+VfDwxKLMz0LL8mDIo+IScz7IeZV0VrRtUMbXHnQ4wuHN+sTH0iBnL
        MxcxM0cG9b0tTFPtwVywDWo=
X-Google-Smtp-Source: ACHHUZ5NC74ymKfxOsZ63jhLeMRw67J/ZW5MHj5sEVfst/QHh/sZuQqSIiasr7nJ2eyuEShDhSMruA==
X-Received: by 2002:a05:6808:2110:b0:390:9226:2c75 with SMTP id r16-20020a056808211000b0039092262c75mr3029124oiw.55.1682706649029;
        Fri, 28 Apr 2023 11:30:49 -0700 (PDT)
Received: from [192.168.0.162] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id n9-20020acabd09000000b0038c06ae307asm9121022oif.52.2023.04.28.11.30.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 11:30:48 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <79edb0c1-170a-8a09-5247-951d833647cd@lwfinger.net>
Date:   Fri, 28 Apr 2023 13:30:47 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] wifi: rtl8xxxu: fix authentication timeout due to
 incorrect RCR value
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>, wo <luyun_611@163.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
References: <20230427020512.1221062-1-luyun_611@163.com>
 <866570c9-38d8-1006-4721-77e2945170b9@lwfinger.net>
 <53e5cb36.2d9d.187c61b8405.Coremail.luyun_611@163.com>
 <87ttx0s9a3.fsf@kernel.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <87ttx0s9a3.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/23 03:25, Kalle Valo wrote:
> wo  <luyun_611@163.com> writes:
> 
>> In fact, there is another driver rtl8192cu.ko
>> (drivers/net/wireless/realtek/rtlwifi/), that can also match this
>> device.
> 
> It's not good if there are two drivers supporting same hardware. Should
> the support be removed from rtlwifi?

Kalle,

I have just sent a patch removing rtl8192cu.

Larry


