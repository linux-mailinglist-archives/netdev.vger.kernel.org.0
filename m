Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF4A64EB16
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 13:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiLPMA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 07:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiLPL76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 06:59:58 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BA240467
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 03:59:56 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id i9so3318841edj.4
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 03:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NH7fiIsgPSbpTpDsFPEq9xLsyqZQIClLTnSfs6kV5ig=;
        b=hoKQF4FF/j9HDuyCMt36xSWIdfxiHaHlp1XyuJxnGU3qcg7MpjVNW/x+yXtYpr9NmJ
         0Jyumcqq3f1xJykltRO2HRWeCQcYG3htl1d/ONlN6PYwpzr4qWw7upDrW8cu+ozGx9Qf
         MsgbhoSmRPd2Kbapqv8oaiL+rehS7Xlv3Ty9GDOF9Gp2gN6+FgRua0TlGDpoHPSpYhgc
         qGlH00CyX/Brgd3F5rxZruN9QORtS8C1G5SY4Dx4ugusBipHlCPyoA/qpHxn1u3rye5s
         iQ/DWJUADuitTIDrYQmg3hBV/rIVECyIJrw7jeGBwojDW51JzBeqabZqpK4aEFL0UJ09
         s7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NH7fiIsgPSbpTpDsFPEq9xLsyqZQIClLTnSfs6kV5ig=;
        b=wPC5e2W60v11TEWtH6Wu7tKUkXRvC3m9xVV82Q5PM9z+vFEAbbQWqpeZAJ7KsMF2It
         d2Jdb5QcCY0Sn59uwBPMrq+R9IAUXQCdtsy7j+OS5PkGtkvn2fBEBPW6AUWMPPWXbW+2
         spIdDb0MBiv2Sm/WVhHfXZXLS8WHiERkfF4op5Fdz29hBMCsH0lsHeRvjQ5xtwHa5eDE
         GjINAwAH09i3PRdHJ3qqyDDxJzWnUnvDobeEyi30tZqF76Qj+/OWtK7NXADkHPbkDnLk
         uzEahcRhdpED1qTwtzKoz4xdcuICCirMoOyfMJoLbLtvLY4Kif+c4rchLha37zJ0HvqX
         hKkg==
X-Gm-Message-State: ANoB5pncAg6/NlboFszSFxGn3AssiQ3tFyv/y8sJLGBo+MmgYiTyCB0J
        X6G4ZWrkRN71/5drsdrPZLlV1A==
X-Google-Smtp-Source: AA0mqf6bxGwNVtW1Iu+gT6Z9G6gB1Yf59JBHIEbVhcIHQbr1+nRAyFkJIsCSXHfV4E7xjxfx11ptwg==
X-Received: by 2002:a50:ec8d:0:b0:46c:a3c1:2057 with SMTP id e13-20020a50ec8d000000b0046ca3c12057mr26670772edr.29.1671191995271;
        Fri, 16 Dec 2022 03:59:55 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id et8-20020a170907294800b007ae10525550sm766785ejc.47.2022.12.16.03.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 03:59:54 -0800 (PST)
Message-ID: <52104d9a-461a-fddc-3494-5d2244673820@blackwall.org>
Date:   Fri, 16 Dec 2022 13:59:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH iproute2-next 2/6] bridge: mdb: Split source parsing to a
 separate function
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@nvidia.com
References: <20221215175230.1907938-1-idosch@nvidia.com>
 <20221215175230.1907938-3-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221215175230.1907938-3-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/12/2022 19:52, Ido Schimmel wrote:
> Currently, the only attribute inside the 'MDBA_SET_ENTRY_ATTRS' nest is
> 'MDBE_ATTR_SOURCE', but subsequent patches are going to add more
> attributes to the nest.
> 
> Prepare for the addition of these attributes by splitting the parsing of
> individual attributes inside the nest to separate functions.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  bridge/mdb.c | 34 ++++++++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 10 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
