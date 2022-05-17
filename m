Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C7B52A5DD
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349797AbiEQPT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349788AbiEQPTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:19:25 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF45F27FCF
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 08:19:22 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id f10so5749047pjs.3
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 08:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NtCVu5kwlt/0GeeCJHb+/bnS0itYTikVVYx8LL9uX0w=;
        b=3RKQV6tsbyrmUfidQNrHgRSDxahUsw5KwHXeTnnuzXwmOO18WyoB6EVhZRXSLdFM4j
         zhKtx7nP76meXVYhp6sQx/QMcfYgtsiaFpTnDO86tdqLDdvxA0bCTrmjvlmZISP5TF74
         M6vIq8BT7levvC+TleV3x9XzZHcvBWx4E8V7E++SXUVQvSk+20pqNJeTU26CVDOe65Lm
         eKfT6swZRtxVqSSk5TDWZTCof+IXc0eiwsclaJWZ7VOyBUUwUZIvNxx6DzGSBUGog4O1
         E93CV0Ocu5nWcuXRgZrxWu8sGpGTGuj0ygKK7NO9RR02tXT8ctEw8u+Sr1h1ovusMGW4
         55Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NtCVu5kwlt/0GeeCJHb+/bnS0itYTikVVYx8LL9uX0w=;
        b=i8Uwu55Qgioc3+S6wBQj1nKaQoh+jFkCdYriZNCusf67vBl/sJsmn1m4arOb6Eizom
         Dv/IFU79zEvlszn8tUHY/1tY+LMpvQ/yKJKW/MVnOT57a8nS5AErPJiyCN0EpzG5N1pW
         a04pLPQF6v9+J6LEN38f4y9LXaodyMGbh5MM1ErxKsgCiB2pEWNl3Vd4x4CEjkH8+VZg
         WeseaqLqgyEF60lci24Gs5fnL3qKGx4h/6sCtuFTblAueSE/8bKWUZXwnNP+X7NmHfKh
         W0VZTfqirr+PLTQK6rUceM4OF9F9MrOLUXiyIrD2/i2Gvi7pBWKzssBAorBCgzQuJGPb
         WgjA==
X-Gm-Message-State: AOAM533Uf/Xk4PFeVvi+eU+22WXM9cTpuvd4HUuqkNMy+OFOEdqeE0ib
        QvtYsEvd2qdRXyuLO/FqPGCjcw==
X-Google-Smtp-Source: ABdhPJwfcOh/4LoIXBpkam4xGXt5zJ1nliaKG8JzVlw5Aie6/aZ/7LkEJQUh+M7FdG8XsHexJ6E/Zg==
X-Received: by 2002:a17:903:248:b0:155:e660:b774 with SMTP id j8-20020a170903024800b00155e660b774mr22794133plh.174.1652800762271;
        Tue, 17 May 2022 08:19:22 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id z11-20020a1709027e8b00b0016144a84c31sm7127822pla.119.2022.05.17.08.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 08:19:21 -0700 (PDT)
Date:   Tue, 17 May 2022 08:19:18 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     longli@linuxonhyperv.com
Cc:     longli@microsoft.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 03/12] net: mana: Handle vport sharing between devices
Message-ID: <20220517081918.655fe626@hermes.local>
In-Reply-To: <1652778276-2986-4-git-send-email-longli@linuxonhyperv.com>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
        <1652778276-2986-4-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 02:04:27 -0700
longli@linuxonhyperv.com wrote:

> diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
> index 51bff91b63ee..26f14fcb6a61 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana.h
> +++ b/drivers/net/ethernet/microsoft/mana/mana.h
> @@ -375,6 +375,7 @@ struct mana_port_context {
>  	unsigned int num_queues;
>  
>  	mana_handle_t port_handle;
> +	atomic_t port_use_count;

Could this be a refcount_t instead?
The refcount_t has protections against under/overflow.
