Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48251538BC5
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 09:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244433AbiEaHFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 03:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243395AbiEaHFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 03:05:18 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F4B972A6
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 00:05:16 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gh17so24753467ejc.6
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 00:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hRZ8GmPw8Oh8naI4uiBFlQrwFuTX1K06ajeeelNp5EQ=;
        b=MJ8JQzpeIs0/aOAWV4xYIqy1ZsnzNOisV3vaelismKLI1QI92d3wMN/AcDBz2op02y
         Fm9siWOgu6u1Iy0WwY/eoetEO1zcig1dHo9J/m0fJ5KqXt2MjxjQ7Wz3cG+/vynKlazd
         dU2Sszw5BK9EJ3HptY6T619jQAEP84O6u9I5BJbmTWzhQXppHrN2gPxqgWzQ7g2DZG4i
         7FaJ2voVxO8O5X2OeOLmHRnonXj5TaHuME3+1bQmfHsaybBmTH0+bR8visRz9GwHFP7s
         yKRB+tBIXJKtlRCeZ3eVz9hNh9HIeEvHSFQ0jDhJjDoh8phnJEkfkHqrR/JGqQaQaKOg
         5dzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hRZ8GmPw8Oh8naI4uiBFlQrwFuTX1K06ajeeelNp5EQ=;
        b=SAiCdDoDBcci7RXWJwHFAU87j8HfLhYHKHVk3yFIQ/KZ8ebLuzWVO7DwVpEJbBgpeN
         qKC+uQ1Rp6VeavrVP9ikYUoE+QqHrxTJfc+o/KO1hVrZJcMmuc4kRPIRpsgyN2zDJEbe
         P1MicC5IpqO5vRs7DZW3MQYPnAiGZel7LHqZDo+D8oTLHISX6PSZQCvsgN/TPCJpxUTB
         Oo2/h0yC7b2oW9wJxGRzBjUj4IsxB7ASjunb9BwBbSdkQ7fLsEqbgF0XM9MVso/ESMSd
         pH567085GRWEfjOmJbx4/wfngKM3CjnBbiyVrDtO52MTXBeOAeAMfRj5nZAYmKhPAKpa
         oSlQ==
X-Gm-Message-State: AOAM530M2akUPMvhbN2cwellLSOL0kD29V8IA34THOm3S+dEW3foZziB
        Aug2rp7bcT0upEI1qIzNKOK9Nw==
X-Google-Smtp-Source: ABdhPJwqDCtiIovD8qenHwywyHxm3XXZuAEeGprrtVyleQ847yJIMX4H4O2I0uiUFKVVqbUay2j+HQ==
X-Received: by 2002:a17:906:9750:b0:6ff:11ed:7137 with SMTP id o16-20020a170906975000b006ff11ed7137mr24844909ejy.331.1653980714936;
        Tue, 31 May 2022 00:05:14 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i10-20020a170906090a00b007025015cf3asm291002ejd.153.2022.05.31.00.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 00:05:13 -0700 (PDT)
Date:   Tue, 31 May 2022 09:05:12 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, jiri@nvidia.com,
        petrm@nvidia.com, andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YpW+KGj17Rj6oO0F@nanopsycho>
References: <20220429153845.5d833979@kernel.org>
 <YmzW12YL15hAFZRV@nanopsycho>
 <20220502073933.5699595c@kernel.org>
 <YotW74GJWt0glDnE@nanopsycho>
 <20220523105640.36d1e4b3@kernel.org>
 <Yox/TkxkTUtd0RMM@nanopsycho>
 <YozsUWj8TQPi7OkM@nanopsycho>
 <2d7c3432-591f-54e7-d62c-abc93663b149@gmail.com>
 <YpM75y3rf4nUhYsy@nanopsycho>
 <5c740b60-78eb-d0df-369c-d8411e24a054@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c740b60-78eb-d0df-369c-d8411e24a054@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 31, 2022 at 04:11:16AM CEST, dsahern@gmail.com wrote:
>On 5/29/22 3:24 AM, Jiri Pirko wrote:
>> Sat, May 28, 2022 at 05:58:56PM CEST, dsahern@gmail.com wrote:
>>> On 5/24/22 8:31 AM, Jiri Pirko wrote:
>>>>
>>>> $ devlink lc info pci/0000:01:00.0 lc 8
>>>> pci/0000:01:00.0:
>>>
>>> ...
>>>
>>>>
>>>> $ devlink lc flash pci/0000:01:00.0 lc 8 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
>>>
>>>
>>> A lot of your proposed syntax for devlink commands has 'lc' twice. If
>>> 'lc' is the subcommand, then you are managing a linecard making 'lc'
>>> before the '8' redundant. How about 'slot 8' or something along those lines?
>> 
>> Well, there is 1:1 match between cmd line options and output, as always.
>> 
>> Object name is one thing, the option name is different. It is quite
>> common to name them both the same. I'm not sure I understand why it
>> would be an issue.
>> 
>
>example? To me it says something is off in your model when you want to
>use the same keyword twice in a command line.

man devlink-trap
man devlink-sb
