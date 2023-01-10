Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3761566466E
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 17:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbjAJQo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 11:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbjAJQou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 11:44:50 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FFC85C89
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 08:44:49 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id p24so13759791plw.11
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 08:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hc4xj3v4oN6rRoehMBEkRi+Gnjk8IsFTjdzhSx6LDMk=;
        b=Gcny72r2OfO53NSAZ9hAP7EHffiqZ9qA8A8GpZI0v/dTLC8//Fus/TaToOymUY8jak
         8MlRqYwUTgjRmcBL9V/J+mwLD8hVnHEmTnSzz6E9FDc5lM23twkZCMRkQdUVa/k2VXD/
         qv4wngdBcA/Jc5HakhmxHJVYb/nwZbAxk7UjV6hN+pG5xEeUfb9bOTCD9AfjFQfV9NpR
         L/iZh2SKnl1dRwuUeQyctJ6IYuLQL22HBG5OkKJqbdqqHkmqRciFvSf0/iWkqZ9S8u6q
         SNmTEVoeelIZ6ZB+H2f/rMVQzEBDAPgzItNrgVd1NQyRLV7JRVFrZwxntl5XsPNFeBVJ
         7XsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hc4xj3v4oN6rRoehMBEkRi+Gnjk8IsFTjdzhSx6LDMk=;
        b=PiquknrHH867fpsvtmAbgh1qNjQbBi1WHjgA9FCoA/W3/uW8+mQDsIv6mvXqlkgiKs
         1ruRxGZNcTx13gyevfppmvnbixP2QyHu5y0NNoUPoimcdk1Eo39Elu6ue663sZYRboN1
         hSX8BFhqku9q9FC0cSCAruMJZ641RvNIDwR8qzpExFeR5Hccz4vfMvLLRWBiRRGYwLCv
         EUvIaC66uxIVlr31AKPBg3dYBbGtoC/uS5MIo1uSJi0sp3nD+tfqG7/uEBSs/VCX/8S2
         fDu7TqkqiOVSyQrpvBr1mM5aZfWAdR1oZZDjfDPuK+Tcvrm9150Ph+lXl4GAQoT60dTu
         lJUw==
X-Gm-Message-State: AFqh2kpgOlQ/f8BSMS4qJtnK+5hgjunXX1H6z6lc4EMWK/+7ariL6UEW
        j2eqQvtM0VTg8hCTJS/9X5GGwQ==
X-Google-Smtp-Source: AMrXdXuPyQUg1YmDaZUKSWo64KBqWtCxJ0PX/jq+TTl0b7lnqOKDsxiFkOn6umhReWIJcuPyiG4nWw==
X-Received: by 2002:a17:903:130b:b0:193:1a2a:d054 with SMTP id iy11-20020a170903130b00b001931a2ad054mr13366868plb.30.1673369088750;
        Tue, 10 Jan 2023 08:44:48 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id y2-20020a17090322c200b0017f73dc1549sm8306518plg.263.2023.01.10.08.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 08:44:48 -0800 (PST)
Date:   Tue, 10 Jan 2023 17:44:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tom Rix <trix@redhat.com>
Cc:     shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        ndagan@amazon.com, saeedb@amazon.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com, khalasa@piap.pl,
        wsa+renesas@sang-engineering.com, yuancan@huawei.com,
        tglx@linutronix.de, 42.hyeyoo@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] net: ena: initialize dim_sample
Message-ID: <Y72V/Z3M8C7Un/QV@nanopsycho>
References: <20230108143843.2987732-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230108143843.2987732-1-trix@redhat.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jan 08, 2023 at 03:38:43PM CET, trix@redhat.com wrote:
>clang static analysis reports this problem
>drivers/net/ethernet/amazon/ena/ena_netdev.c:1821:2: warning: Passed-by-value struct
>  argument contains uninitialized data (e.g., field: 'comp_ctr') [core.CallAndMessage]
>        net_dim(&ena_napi->dim, dim_sample);
>        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
>net_dim can call dim_calc_stats() which uses the comp_ctr element,
>so it must be initialized.
>
>Fixes: 282faf61a053 ("net: ena: switch to dim algorithm for rx adaptive interrupt moderation")
>Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
