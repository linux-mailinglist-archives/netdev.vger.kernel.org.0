Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EDE55D500
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343875AbiF1HHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 03:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343870AbiF1HGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 03:06:48 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA8E60DA
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 00:06:46 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id q6so23684612eji.13
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 00:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6v63Di1vZL+ZIKrUzYH79iK4RHj+x0z/lnmYN2sHosE=;
        b=bGrrAtsm23nQy7f4Gsya34S1vn3HXpRZkiPRfGgDpuzqOBQpUEvKkHSSpQhUM/mMkb
         kx/EGumeacRTdaVYEC0XSr4jOIpk5AOJ00RylgWTBFZP3aE3UEgpPQnHGWhYdLe+l+Nv
         a7jbTil3SsDrSjrwqdZ+IPuCKV95cibDBqFVHuzXyBMPZGSImXoCYbQ3+tGgNYWvNJAW
         uedLHVlOrFn02fg5BNH/xUsdT7KpHzJd5ftkS8wLxXzGjla9RchxCEBv6PYsR8iV4xsR
         mLgfRlpe3aL5gKZRc1hPgtym78ACTGk5h9NnmSYLRUd7D7WgDPrA76OJyAopmcpPoJIW
         /BwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6v63Di1vZL+ZIKrUzYH79iK4RHj+x0z/lnmYN2sHosE=;
        b=qE0+IbabYqlzdZYa5oVErqgs3EfQSmPIZgiOHlJda8P6MhbenhrNXdJhEjld1DdQ93
         McRI7c5uyImB5CvObp1zdGE8jVkKusHz1cCaVZsQuw53Ih9HZjO3VYHHaN2JT0zNJS8W
         pKp8Jrzxl7e+Vq5adlCZWe20jEmyvK7BlSLiSmWkZqAo1zThq6hP4BF32VA7Xh2c6CtN
         emRbyYFHx5N2ah2OjSPEx8S7vvOVfxfYkSoMjtnv2TcmcD+yTsD7bwy8iu0cKz1tyoA8
         wN4UJT28HHcMkHuPQiZknuyMYYEtugG+1c+ov9WZ0Pvyh+UY4n4M77HOymAjjqv1/vUN
         mH2A==
X-Gm-Message-State: AJIora+jpM76PCTcHnNO6z0DxCU6Q7Vq2b+TbDnZhdy3WKm8wfVq3sGN
        rB5SR2s+cQiigMmv0QqXLcn9eA==
X-Google-Smtp-Source: AGRyM1t8DW7M5/JpgnskduM3+hvwZaNIDRXrehWFJkigZmd61np6j2UNvItI1f8i731y0aMw2jmDFw==
X-Received: by 2002:a17:906:99c5:b0:6fe:b069:4ab6 with SMTP id s5-20020a17090699c500b006feb0694ab6mr16705560ejn.436.1656400005362;
        Tue, 28 Jun 2022 00:06:45 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id p27-20020a1709060ddb00b00722e559ee66sm5902478eji.62.2022.06.28.00.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 00:06:44 -0700 (PDT)
Date:   Tue, 28 Jun 2022 09:06:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shannon Nelson <snelson@pensando.io>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, petrm@nvidia.com, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com
Subject: Re: [patch net-next 00/11] mlxsw: Implement dev info and dev flash
 for line cards
Message-ID: <Yrqogz8U+BxtFWiu@nanopsycho>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <Yqmiv2+C1AXa6BY3@shredder>
 <YqoZkqwBPoX5lGrR@nanopsycho>
 <fbaca11c-c706-b993-fa0d-ec7a1ba34203@pensando.io>
 <Yrltpz0wXW35xmgd@nanopsycho>
 <ccd0e04c-5241-16da-929f-18059caee428@pensando.io>
 <20220627115209.35b699d9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627115209.35b699d9@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jun 27, 2022 at 08:52:09PM CEST, kuba@kernel.org wrote:
>On Mon, 27 Jun 2022 11:38:50 -0700 Shannon Nelson wrote:
>> >> Can you encode the base device's PCI info into the auxiliary device's id  
>> > 
>> > Would look odd to he PCI BDF in auxdev addsess, wouldn't it?  
>> 
>> Sure, it looks a little odd to see something like mycore.app.1281, but 
>> it does afford the auxiliary driver, and any other observer, a way to 
>> figure out which device it is representing.  This also works nicely when 
>> trying to associate an auxiliary driver instance for a VF with the 
>> matching VF PCI driver instance.
>
>I'd personally not mind divorcing devlink from bus devices a little
>more. On one hand we have cases like this where there's naturally no

How exactly do you envision to do this? There is a good reason to have
the handle based on bus/name, as it is constant and predictable.


>bus device, on the other we have multi-link PCI devices which want to
>straddle NUMA nodes but otherwise are just a logical unit.
