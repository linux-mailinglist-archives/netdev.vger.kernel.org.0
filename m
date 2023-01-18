Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6DC6720ED
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjARPQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbjARPP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:15:57 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9596937B47;
        Wed, 18 Jan 2023 07:11:34 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id q10-20020a1cf30a000000b003db0edfdb74so1365362wmq.1;
        Wed, 18 Jan 2023 07:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hr87MGTJq8u+Ua6FRs2K3EZ+5I9LJ/lJvLM/9Z6W26c=;
        b=j254BJ6QRqipO4iTY9+H2li6wfIse1SV91FB2Khs8Q81y2Xl0EisADXtc5OC0vC9lg
         aOxoh6ppGHuSRBhp/6mzexL/Zh4+tUQ5B+jKEbflLIO+sUlNdLjtdJlEOhaXuSrJapIM
         uP3nW81+eIddLAH13WClcVmUHMxf4YLUsHqxzzlGk7C7r5zcf+06WBX9YCX2l1J3FeOc
         LjDpsf1qug7OoihKcyX2cioXgOwx2G/4eoR/i8JkJRjYFdzo9ndLy2pWsmOP+yOT31As
         g8kmSAVg6g0P/EZYsHEcmgMcpy1sEWddSf5VM70tR0bIWCUIWPt+Xfg1f2okv83U7xqK
         xMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hr87MGTJq8u+Ua6FRs2K3EZ+5I9LJ/lJvLM/9Z6W26c=;
        b=O+ut5qwlrVkQcOVv+QhY2T5HUamS7DHHivR4PGI7jt5ZrAAWpuQ43sQOnrBF/2cDt5
         UnWZVX9K8i4mZsJ44rXZ5eGEx5YSW010xmyXEGLbtJstjhIbcHifSpHmj/tzPbG3tesG
         tveWyqY7wB7O9vJ1/EAv6IWZQs3TSoxKLyzlHlSafRu5USMxYw+fzEV0d/XzVDh2M33k
         nMIzGoEU0hi5f6Js0WWyHQ70Brb76ksDLCou6uwc8szoFLXtuN1R2iVDDjemS95UFSYQ
         NwVpepeBhWlwH1EwVxaXmy95HLetuMwPKtIBAo8QHCpYa1pu4wtzZY5Va9MxZ6N72GDR
         oPYQ==
X-Gm-Message-State: AFqh2kqg+DptsAU90guJev/mLPYNlMQQTBciQarE3RdRB7BaBJ0NHW81
        wxQiN/Bd7EV20GmBh99OU0TjmdoAvEqWmA==
X-Google-Smtp-Source: AMrXdXtJKLeOjHVScXSkppz7oZtxD2NOefE/FO6/f9hI9n8XM4LwxcLiBp1Ux4pbstgNpRWEqT3+tw==
X-Received: by 2002:a05:600c:4f86:b0:3db:15b1:fb28 with SMTP id n6-20020a05600c4f8600b003db15b1fb28mr2289859wmq.19.1674054692951;
        Wed, 18 Jan 2023 07:11:32 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id i18-20020a05600c355200b003d9df9e59c4sm2640809wmq.37.2023.01.18.07.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:11:32 -0800 (PST)
Date:   Wed, 18 Jan 2023 18:11:24 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Daniel Machon <daniel.machon@microchip.com>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, horatiu.vultur@microchip.com,
        Julia.Lawall@inria.fr, vladimir.oltean@nxp.com,
        maxime.chevallier@bootlin.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/6] net: dcb: add new rewrite table
Message-ID: <Y8gMHLLymftuSki4@kadam>
References: <20230116144853.2446315-1-daniel.machon@microchip.com>
 <20230116144853.2446315-4-daniel.machon@microchip.com>
 <87lem0w1k3.fsf@nvidia.com>
 <Y8gLRF7/0sttKkPx@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8gLRF7/0sttKkPx@kadam>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 06:07:48PM +0300, Dan Carpenter wrote:
> In Smatch, I thought it would be easy but it turned out I need to add
> a hack around to change the second nla_nest_start_noflag() from unknown
> to valid pointer.

The second nla_nest_start_noflag() *return*, I meant.

> +nla_nest_start_noflag 0-u64max 4096-ptr_max

regards,
dan carpenter


