Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7429E644476
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbiLFNVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbiLFNV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:21:29 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6211000
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 05:21:26 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id gh17so6116900ejb.6
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 05:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4A1/sDedsEMhpagiaSYGQZ4/VZF9EUw1mfdyYLwspKc=;
        b=tMrnWhIwGP2Gl0gqajcIBQAKu/fg+d/y+m834Den0uq6uTqk882e3GGanbCPQz9l53
         Wggili/p7rOQ1tdOE/ypHaUqzeJtfY5OT1/PjU5AP5cmIXD1/DF5vTQ6J08NqhdQcI8E
         /434huhN80gdnAoCbFzDp7Vy3YUJ76rnZue5bIeuOAk2ckE7hxqraYVeGep93lAKDHUA
         0AjfJvFc8PhO0EJwqR4FN1/UW/xDyYVm60JulEag5a+3rB7LrX4+am7V4Rb43wSqR8Hm
         avLlOMLpNMJ679jODgRoB3yjQjBo4gZjmNQvuSaPVmHiKFDcAEA2ROg6PA/c3ZCmmA4k
         i8ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4A1/sDedsEMhpagiaSYGQZ4/VZF9EUw1mfdyYLwspKc=;
        b=Mn5kJV5JneOgbgWV1uRC+Iw0KFHuD9NDuMG4H9GpGrxadfuPL2oJPKqpHY3HhLLPZ6
         XjHWX7OTylQtRR9yeKfNLs2axlD5mbErJ//Mx6Zb4ELcWbygqaNEoDA5ir1bFzBZqtCi
         7WO0SpHk6uj8uj1b17R/STLokNwZP5nYR7c10zr4/RzNB4N6HHeH0iPiXVHWcYDhGH09
         /hjQp4ew8GzzPfbuv9HNI7Mxbe8Aiov4h0AvzNofMjJsXK3E2Z0iD4HISuInLJFIiBA5
         9IezdqXltcIYuBGvKMvwYftcD9GT6Q7vmbd/PpbRER4S0R5Ci6jRXxO9IjIHYOznEwJA
         EvqA==
X-Gm-Message-State: ANoB5pk4basxzxKTjAurfKjZx+Vv8hzj880Fwy/bpmqSDRxVhJ98c/SW
        9WjCf73+zsfD23n80rZwSNW5yg==
X-Google-Smtp-Source: AA0mqf6NthG9z1ImHJdswLixYqxWNP9T87diFnLhKiaSRGZswGtMAb061dUvXpe8zghf6GqecOlNww==
X-Received: by 2002:a17:906:ee2:b0:78d:3f96:b7aa with SMTP id x2-20020a1709060ee200b0078d3f96b7aamr58012848eji.74.1670332885277;
        Tue, 06 Dec 2022 05:21:25 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y20-20020a50eb94000000b004589da5e5cesm973328edr.41.2022.12.06.05.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 05:21:24 -0800 (PST)
Date:   Tue, 6 Dec 2022 14:21:23 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     zhang.songyi@zte.com.cn
Cc:     leon@kernel.org, saeedm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kliteyn@nvidia.com, shunh@nvidia.com, rongweil@nvidia.com,
        valex@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: remove redundant ret variable
Message-ID: <Y49B08qoVY5WT0s3@nanopsycho>
References: <202212051424013653827@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212051424013653827@zte.com.cn>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Dec 05, 2022 at 07:24:01AM CET, zhang.songyi@zte.com.cn wrote:
>From: zhang songyi <zhang.songyi@zte.com.cn>
>
>Return value from mlx5dr_send_postsend_action() directly instead of taking
>this in another redundant variable.
>
>Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
