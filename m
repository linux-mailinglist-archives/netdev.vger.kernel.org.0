Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84674D2B90
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiCIJOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiCIJOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:14:37 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E15B3F339
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 01:13:36 -0800 (PST)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9CA453F60B
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 09:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646817214;
        bh=DWve8mUzjjNi/DaGPnOk7W3TtiB3wUxX/ugKfBnsP20=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=gPQuIz9S15FrfE4hSaPrPJ7ItBAJ2RWh5SR6aH79lK4NBe5WsLG9yJTDzltEa76B6
         +pT2NImiu8nv6da4yL3rWaQRz0BAAx541W1YJ0afdbnGraBIEulxs94FKyRBDlXMN3
         VZG9XgzXTJ+zg67yANpDvP2ivjQQ68rX+nV+9S1C9mcE4IkggPN8LGkR58tTd7NGSl
         FKNOOglFSheu20xek9NIUGTBcFoZnp/iDgmuwEAvssJqoRAXMYeKUmCnfcu9ku4Dkf
         bH7cNdcgy/oBWNM9SjL4msOJKBl/AByoNmIOrmoIhTUP5cQdC/Ui6dXUSBmT5HItn5
         USEqszgErdZ0A==
Received: by mail-ed1-f69.google.com with SMTP id cm27-20020a0564020c9b00b004137effc24bso945529edb.10
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 01:13:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DWve8mUzjjNi/DaGPnOk7W3TtiB3wUxX/ugKfBnsP20=;
        b=nzvI5ek2LZrwVPhBrV9M/d+mIuHJCfuAQln/hEmkiO/kVgpwqljh+4yboc8y51Yp7g
         7sG32j2+J++2Cp4LbNphJ5ZB0IGvJdJxiXb77xWyn636WGsAA+Dhr1MQdxDxfS71/v6f
         oe4uKoISdFzDrSCenDBLA/pFaOrj/fH07MVBRfkpH1GDhxQnwtSCK1tV8eLp8TKRofzd
         t6stYHNfHTthm0FYo5mCA5XGdRecpB+zdM+024mLZHWeZQYvagz6KuRF76MeK0eKtfWu
         CVqj6gV3J87SoPfRFGnsP17zdMw8KWGy1BcTMzA4/fMyl62v7w19TBzBvb57dEs4+gjF
         r+tw==
X-Gm-Message-State: AOAM533hCgZbVTyK3OVslhhw0QpZngcKDmL7KUv8gxtFaXD8GAZXTWeY
        /+BA3KY0GBNVjyYieGY/0ISNdaRpKjwCFkD0QnEekonHf9Zpzjl5CWLN/wBi8Z/ld2HQpXuYlWp
        T3bhGQOUriBTM+EfL/YOfnGhpL+QnE3orkA==
X-Received: by 2002:a17:907:7849:b0:6d5:87bd:5602 with SMTP id lb9-20020a170907784900b006d587bd5602mr16471508ejc.349.1646817214166;
        Wed, 09 Mar 2022 01:13:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyaayiRmg6jlQ9OnyXmW7jxsQHTWWXcd8Bg4GTp0MUrRybx25RZqMcDfYHZw8faWNI/n5LJoA==
X-Received: by 2002:a17:907:7849:b0:6d5:87bd:5602 with SMTP id lb9-20020a170907784900b006d587bd5602mr16471490ejc.349.1646817213950;
        Wed, 09 Mar 2022 01:13:33 -0800 (PST)
Received: from [192.168.68.108] (p5087f509.dip0.t-ipconnect.de. [80.135.245.9])
        by smtp.gmail.com with ESMTPSA id k3-20020a05640212c300b0041605b2d9c1sm513258edx.58.2022.03.09.01.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 01:13:33 -0800 (PST)
Message-ID: <8e6684df-7b6e-ccb5-b123-2dc8337442bd@canonical.com>
Date:   Wed, 9 Mar 2022 10:13:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: netdevsim: fix byte order on ipsec debugfs file
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20220308135106.890270-1-kleber.souza@canonical.com>
 <20220308215851.397817bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Kleber Souza <kleber.souza@canonical.com>
In-Reply-To: <20220308215851.397817bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.03.22 06:58, Jakub Kicinski wrote:
> On Tue,  8 Mar 2022 14:51:06 +0100 Kleber Sacilotto de Souza wrote:
>> When adding a new xfrm state, the data provided via struct xfrm_state
>> is stored in network byte order. This needs to be taken into
>> consideration when exporting the SAs data to userspace via debugfs,
>> otherwise the content will depend on the system endianness. Fix this by
>> converting all multi-byte fields from network to host order.
>>
>> Also fix the selftest script which was expecting the data as exported by
>> a little-endian system, which was inverted.
>>
>> Fixes: 7699353da875 ("netdevsim: add ipsec offload testing")
>> Fixes: 2766a11161cc ("selftests: rtnetlink: add ipsec offload API test")
>> Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>
> 
> Then the struct members need to have the correct types,
> as is this patch adds sparse warnings (build with C=1).

Hi Jakub,

Thank you for the review. I'll fix it and send a v2 shortly.

Kleber
