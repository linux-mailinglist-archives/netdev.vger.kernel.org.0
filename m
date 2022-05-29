Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD5B53706E
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 11:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiE2JZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 05:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiE2JZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 05:25:00 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651F345ADC
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 02:24:58 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id p5-20020a1c2905000000b003970dd5404dso4956766wmp.0
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 02:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K+ZvBpEHdePLqM1fgQoN1xdPWy8TNt24dkxWtnLqU00=;
        b=b+Q4DHsznIqGnW16F/P9khDR7ULS5iXgCk4dzODEd61SeHJBDR9oatCkrCJ5rGwkLu
         2hKl+N9wjqYnd1eU/HuPMe3B3XDginoLgNIbUAutuWUFDR2Byt6Q+svINRtnIBleNg8k
         k9buLA0KtNnvD9nshGCdAO1j01pmg8LCjEpBCWt/vvI4bXBt5xmCsEalQKX0P+VghgxD
         P6/6+aAJGdiajXWmqRlw4udROzG33uVFQE2SebJ3Tyr1PDA6fNqJdi8C+Eep4o51qrgS
         0W1t/cm9kWdHFn8Pokakto1Y5gEIzqZJeZeqlYruJcBY06XuGm58n8h1GBscziiUReGo
         eThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K+ZvBpEHdePLqM1fgQoN1xdPWy8TNt24dkxWtnLqU00=;
        b=gYiFE3PkiRBMd3mbkwEx4Pu6AICZ+S8tDahQmRz+zOsWzkLbHdcH9J083kSAjYTDo7
         5F+mYl1HppjvOBI3HPV5WDxZ2kwtpHJrTRDKlH372ZYxpFijGXZgjuKRm5ljAVJ0AxtI
         P4fEJDTYryGtkbO0CyaN8oodbhWYIuSIsSx3QvFYr9fGuaCabO0hFnt1J9Qhh0K3O7kU
         V+ryYOfRWjJ96MTL7HwJWjX9zK1ayduQtUUOzkP3/q8Vc5utxVnWzpxngsezQM95vuf4
         efU5CY9k+pnSgmQCben6+RGebOiU9X2bfO2BOSKVsufKR+r730JL9zZgEjnO0tr7CMKo
         XLgA==
X-Gm-Message-State: AOAM531ohnIoPEvPKegfeOEcKlrl5qxJvWjUq2ui5s8cJKhl07ry78vm
        3MrZNCdQT/HJI3JYNs7rRbg++A==
X-Google-Smtp-Source: ABdhPJzhpzVyWcRrcOrl5PqSXrPfrF7kvm0It4Yv1VyMDWelgGAEboUsLDidJ0teeVbXyif4ITGsTQ==
X-Received: by 2002:a7b:ca59:0:b0:397:8c63:4bd2 with SMTP id m25-20020a7bca59000000b003978c634bd2mr9791979wml.76.1653816296879;
        Sun, 29 May 2022 02:24:56 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc84e000000b0039771fbffcasm6900283wml.21.2022.05.29.02.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 May 2022 02:24:56 -0700 (PDT)
Date:   Sun, 29 May 2022 11:24:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, jiri@nvidia.com,
        petrm@nvidia.com, andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YpM75y3rf4nUhYsy@nanopsycho>
References: <20220429114535.64794e94@kernel.org>
 <Ymw8jBoK3Vx8A/uq@nanopsycho>
 <20220429153845.5d833979@kernel.org>
 <YmzW12YL15hAFZRV@nanopsycho>
 <20220502073933.5699595c@kernel.org>
 <YotW74GJWt0glDnE@nanopsycho>
 <20220523105640.36d1e4b3@kernel.org>
 <Yox/TkxkTUtd0RMM@nanopsycho>
 <YozsUWj8TQPi7OkM@nanopsycho>
 <2d7c3432-591f-54e7-d62c-abc93663b149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d7c3432-591f-54e7-d62c-abc93663b149@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, May 28, 2022 at 05:58:56PM CEST, dsahern@gmail.com wrote:
>On 5/24/22 8:31 AM, Jiri Pirko wrote:
>> 
>> $ devlink lc info pci/0000:01:00.0 lc 8
>> pci/0000:01:00.0:
>
>...
>
>> 
>> $ devlink lc flash pci/0000:01:00.0 lc 8 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
>
>
>A lot of your proposed syntax for devlink commands has 'lc' twice. If
>'lc' is the subcommand, then you are managing a linecard making 'lc'
>before the '8' redundant. How about 'slot 8' or something along those lines?

Well, there is 1:1 match between cmd line options and output, as always.

Object name is one thing, the option name is different. It is quite
common to name them both the same. I'm not sure I understand why it
would be an issue.

