Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA73648175
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 12:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiLILQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 06:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiLILQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 06:16:23 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B115370BB2
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 03:16:17 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id vp12so10705698ejc.8
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 03:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UCXZwMTNvEDe5G0Qbwz7tJyq7h6kPz9o9O2pljskjaw=;
        b=qJCfotCjURrf5Ld2LsmMtOu/dMq9fmpIp5Z5yyqTrmC30ml4junYmYcxKWS4A4X8PG
         s/xFQmtzQK59D3rzGKAvc9tLv1Ekbw3ajDhErDU3VDBclc7rpJgFFa2bbyI6TD0czi0L
         gQcOylv/PSKjqDYio9qcRSq1lG74Tp5aHcztQl3d83yppC8eoU+RzWyp6WQCZ0c1GiIY
         YelKzC3Jot6XspFjcEsnHsxfB+8EqXJyP6cmc2ZnBL2v6hCKpgbr4qxKdQls/I+qMcvb
         5loxy9uyOS6CrJzpVB212rQCgUAZFQYeWlB0t7zh45LCyQ5KFtFu4R6lZ3dtqB9waH6b
         5CfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UCXZwMTNvEDe5G0Qbwz7tJyq7h6kPz9o9O2pljskjaw=;
        b=AWGNWrKL1GXRWQvH69ycFAZBcoDBYRJasqFBsiidieTAJv6vJQNX3i0wvN2yJCva3p
         xCV6OdZODiB02PmzjfOJdZWcp4aHv2LeCdTwGvE6yt+86XQGcDPuZHQOChovW9CbQmGM
         +WHqkqz22rabBPF1rZy+aSElo1VS6R8UJ98hdVqxPVcBBB6P+d51fhbF9LMZQiqwiLgC
         u/yqbtMTUA866lyzGVqiP1omqvOw7J/49P31bhJs8J/Wyg/v+pK1e1HiSp2A3MSETC5F
         nver/P1GDz+kJkizZk38tzMnT5bvw3ws9jv3z9vXhFEOTJKJ3NI7SsZCw4JWTKsL9krH
         fD3w==
X-Gm-Message-State: ANoB5pnKId6Dgu5D97KG6FSs0Fc467TJVzphcm4nAO+4qB2GGHHWD+UF
        +naxz1xf4y17gN7K7Mx0YylOyN1tb4FG6QiMDJ4=
X-Google-Smtp-Source: AA0mqf4A/Stw5dC/bTz2hq8f3VpuGYAbTDySvCJb5xkJw6LRylU8U0FYbPh64sZpOXRcQ9fCCbsNwQ==
X-Received: by 2002:a17:906:a102:b0:7bd:f540:9bfe with SMTP id t2-20020a170906a10200b007bdf5409bfemr4668123ejy.47.1670584576268;
        Fri, 09 Dec 2022 03:16:16 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v22-20020a056402185600b0046b16872e69sm526028edy.2.2022.12.09.03.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 03:16:15 -0800 (PST)
Date:   Fri, 9 Dec 2022 12:16:14 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v4] net: ngbe: Add ngbe mdio bus driver.
Message-ID: <Y5MY/pyGNM7716Wv@nanopsycho>
References: <20221209102124.24652-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209102124.24652-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 09, 2022 at 11:21:24AM CET, mengyuanlou@net-swift.com wrote:
>Add mdio bus register for ngbe.
>The internal phy and external phy need to be handled separately.
>Add phy changed event detection.
>
>Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>

Looks ok to me.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
