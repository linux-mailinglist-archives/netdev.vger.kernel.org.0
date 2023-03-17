Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2296BEF38
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjCQRIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjCQRI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:08:27 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473672D149;
        Fri, 17 Mar 2023 10:08:07 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id n2so6365719qtp.0;
        Fri, 17 Mar 2023 10:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679072886;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x80sbSKMt5vVTyqAkFiYptPHgjVK9gjedydk+JKK7Cw=;
        b=qGhBhsHYmo5hLeOAcIRDvpE0/B+Dk3x6lraONvQhbi6vnyvEDD8FLxbgDm1jS3oq1t
         Yy09boMmWEfyMkoGqYsQyFGaeLXHiovgUqOpLiltBDeJS1Ui8SGLR5KDaJKJcXsEUQkK
         Js5luyVJZv7BBxxJx8FCyW78IF7N6HCbStuEw1Lp9QkLMBMF3XSOnfPH2StwY5+C3O86
         Ro2uUPOZSg4Ib/ZVcjtAMRkMOuFngcaoOOTD+nJwdX+9XJJenEg1btsAt2ZPnAM1QnHn
         IKsHZ+KBhHrycgHDgZKfnNWrip6tvq0YZ7996GZ2DHgyR2goRvEU4uR4bLdavweF7M8/
         4Uvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679072886;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x80sbSKMt5vVTyqAkFiYptPHgjVK9gjedydk+JKK7Cw=;
        b=xj3DyV4K5Sp1i4tkvvGQePrUN2tYVfu558VdN6dYAWbxWehlnpP+YiSSS8Hbtg5WbT
         WJy8TEpJdk8urRyxv0AKauCmybwoFX95jytJ6RCZXsScwKig124QiG7mCh+cuB22xrif
         UGiIqpTnF7CO1JojLAzYX/KfT9YJCGt4kzxRL/ePeG1VBFIEflhYA1xHu+0gHdiFAs02
         yID1zTpH5zAVqPtxyXH9yxMFPpsl/JFZnRnYdMPbuYXCEHO2qDyN2n/bDMNCsmFqGVAa
         Y3t7UEFEOXrkuyBRDYVZC09gu6yoKSmWQ1jRxkvd0fpT5xshPq2lizm9TT75AjROCthr
         ZIBQ==
X-Gm-Message-State: AO0yUKXkxAowGsCTCx6FBSG8QeVFcQbRINXQs6Uks5dxmMRl0GUPEsQF
        jZS9bAoTUTXwVStolYhTmxQ=
X-Google-Smtp-Source: AK7set8Kch/XBMhCQIRjwrMbjlK+Kmh5CgYzRql10bjM2a2MXQqilnp3GjzXa3k+CcePiNWReQYizg==
X-Received: by 2002:ac8:5e0c:0:b0:3c0:6cf:3226 with SMTP id h12-20020ac85e0c000000b003c006cf3226mr14911235qtx.8.1679072886094;
        Fri, 17 Mar 2023 10:08:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 20-20020a370314000000b00745a55db5a3sm2037259qkd.24.2023.03.17.10.08.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 10:08:05 -0700 (PDT)
Message-ID: <afaf8f5f-f827-5b86-9424-7096c87bc463@gmail.com>
Date:   Fri, 17 Mar 2023 10:07:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v4 4/4] net: dsa: mv88e6xxx: mask apparently
 non-existing phys during probing
Content-Language: en-US
To:     Klaus Kudielka <klaus.kudielka@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
 <20230315163846.3114-5-klaus.kudielka@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315163846.3114-5-klaus.kudielka@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 3/15/23 09:38, Klaus Kudielka wrote:
> To avoid excessive mdio bus transactions during probing, mask all phy
> addresses that do not exist (there is a 1:1 mapping between switch port
> number and phy address).
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

