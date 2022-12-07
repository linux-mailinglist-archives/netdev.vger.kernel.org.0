Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBE1645BFB
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiLGOFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiLGOFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:05:31 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC315FB95
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:04:20 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id n20so14351652ejh.0
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 06:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yLEQ1iziXxnm8tB1YfDZj59/p6SSPcwuVFJkFGvSq1g=;
        b=dzpKqLY84Dr7Ud955bgc9eOFeA7FKkqyevWEX9bPYQYNfiQPXWBeFs7jmaIfYkncte
         ap72TfM03WBZ22MFWrf9U6C2OFZWIKTZ5Z98jMrmvHyA336Cpu5KyLOs9zu3liPYJAhJ
         +bwye+1znCiXHtxai+tl0/agLChGg3DrkXlTYx+OdiVtz1eI/JUtyQDD9VFYinsEOMR0
         Ch7gGXu/BjX69v9MzRRg7Sv7CtHNWS9Fn/XjGmJfLXZAHO6nSGDjfuyaX5xw0FPb1p7L
         XSS1zUb8Ab/fv6aNXj9nR60g2HjlvzXMvMbmd9+TYqrt+Pk0poQVjYmjnXBUsasAetpO
         ArHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yLEQ1iziXxnm8tB1YfDZj59/p6SSPcwuVFJkFGvSq1g=;
        b=u2nBUwnYOqVSihXCjzxydaJC8UdSzaoKBPC6gGRJg6ew/wLiT6vLHSixtNMO0JqCbP
         A7siukQbHu3nmD7A5OkzQbsC7N4LV/k5gGIBt84W/pmxlR/JEbfh2dlVUeZc3F8mb0r5
         +xya/jbPz5/p4HilHGI/Sf/kb3ujeXsRZbz67tEE+2EQDm/j/maUg4V2Rl+pnMBcjGv1
         Oo4xOSY/GDauJq7slvR3amqAO0nw/6enTvlZuha+mBAt5mwIDe4uaqtzl8vLIrhhbyh5
         TexEFkcIocu030hmZO5xhP7kuC12wx+I8w1JI0k9bnxUWrHMIpP/nwIVOnecITNM78MG
         q+hw==
X-Gm-Message-State: ANoB5pmit3qjrvRdh5h7Cz3rsAk4a4DLtFezQvPd15PKQkn65mtM2PBl
        W2hrrruhnIRz1MIPkcxWxxy+YA==
X-Google-Smtp-Source: AA0mqf6u3BZDsigCe1eE4YZ5zUn3KvdPVP/j/ewkyVT3pq/rT1ZFfyAPgBDFioYpogO/OwrHjvQROg==
X-Received: by 2002:a17:906:50a:b0:7c0:b995:8f8b with SMTP id j10-20020a170906050a00b007c0b9958f8bmr21986259eja.55.1670421855380;
        Wed, 07 Dec 2022 06:04:15 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r10-20020a17090609ca00b007ad94422cf6sm8448157eje.198.2022.12.07.06.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:04:14 -0800 (PST)
Date:   Wed, 7 Dec 2022 15:04:13 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     ehakim@nvidia.com
Cc:     linux-kernel@vger.kernel.org, raeds@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, sd@queasysnail.net,
        atenart@kernel.org
Subject: Re: [PATCH net] macsec: add missing attribute validation for offload
Message-ID: <Y5CdXd9KkKDq+uIo@nanopsycho>
References: <20221207101618.989-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207101618.989-1-ehakim@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 07, 2022 at 11:16:18AM CET, ehakim@nvidia.com wrote:
>From: Emeel Hakim <ehakim@nvidia.com>
>
>Add missing attribute validation for IFLA_MACSEC_OFFLOAD
>to the netlink policy.
>
>Fixes: 791bb3fcafce ("net: macsec: add support for specifying offload upon link creation")
>Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
