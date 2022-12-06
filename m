Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6AC64402A
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbiLFJtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbiLFJtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:49:02 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1B91409F
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:48:19 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id vv4so4871831ejc.2
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 01:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJbkY3To2LLLUtKc4rbbIsu/bj+9NBwHzePi2TE3CV0=;
        b=PHEgk6dXN4FB1/mmb6cc+7F0dXKFWI9yPdpaZ4VGgTv8Oh/NSPN6KCFN6a/YNE6CyI
         Gq/mVZGhvHQbTRdfbIkd2Gyu/tPKjwc/9t9PwQ8GvO/aAgvOZgRfJY3GmGkX/Mrpfi+C
         2sBmQ6XCeQpL2QJ+lUG3FnWP3Z37yX3rakPi83G7uy77Kn62Fw6MUOkSOnMp31ShjbqQ
         qDhXG1QcZzrvjPhvOSzZwxrYJEp7btuZbNDQ6du4M/PNvWLdqqT3Xdzq31qGNHskeZXi
         yrsmaLXSiAHL7rdHjvQaNBMPkxPDQLaxfUZuLgiFDm/npQHNlqGmZw8Q6FvTg8rKCjed
         mxcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZJbkY3To2LLLUtKc4rbbIsu/bj+9NBwHzePi2TE3CV0=;
        b=5n5lu0xrAgbzZc0A5k7MIZNzWXHWx26mj5p9CdbU4lIhfdw68sQoVJNfnXVzSMLr7R
         XWcMz1xnfhqvR7muAV8aWXL/DNHotYxA40qoVML9RPhrYiKuI5feHD0B8VTcFXiA8gs0
         gJ6nu/tf04CuaHoK8NL4DMi5CvrOBvHsdkrjRwqb4WoXEdb2/D2wbtm814gyIvgQnsHc
         NfC43wIhN+9qMjkO0GlXACsBT8slWWgvr+jVqGNrWGP7IRjF7mzYTB8Vguge95X7jbuZ
         l9WNtjcPiCe5kU5vaQk0uinZ6gD1RFhWbUOgiLGH3AX75m0pPccb4yj+NTrvx5Bo8z74
         TcQg==
X-Gm-Message-State: ANoB5pnB4A9X3zp9hoQ8QiXwmiQ5gRT/nF4MAsfAezlmWWBPbVKNStiv
        VW8bIAUNket+zK09094EDVTYUPDl/pEX1vOGCGx7Kg==
X-Google-Smtp-Source: AA0mqf6bgj4nGIAAQbr9yP4W4HtXsnRwEo2haLA+8KoNdWhc9g2ZE1AxFynN/UDz6OZkNyBEOTkSDA==
X-Received: by 2002:a17:906:2ec7:b0:79b:413b:d64 with SMTP id s7-20020a1709062ec700b0079b413b0d64mr54887808eji.538.1670320097973;
        Tue, 06 Dec 2022 01:48:17 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n19-20020a05640205d300b0046bf4935323sm790200edx.30.2022.12.06.01.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 01:48:17 -0800 (PST)
Date:   Tue, 6 Dec 2022 10:48:16 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] bonding: get correct NA dest address
Message-ID: <Y48P4FhAukDWxXs9@nanopsycho>
References: <20221206032055.7517-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206032055.7517-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 04:20:55AM CET, liuhangbin@gmail.com wrote:
>In commit 4d633d1b468b ("bonding: fix ICMPv6 header handling when receiving
>IPv6 messages"), there is a copy/paste issue for NA daddr. I found that
>in my testing and fixed it in my local branch. But I forgot to re-format
>the patch and sent the wrong mail.
>
>Fix it by reading the correct dest address.
>
>Fixes: 4d633d1b468b ("bonding: fix ICMPv6 header handling when receiving IPv6 messages")
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
