Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C3F6788A2
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjAWUsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjAWUsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:48:01 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74453251F
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 12:47:59 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id v6so33838278ejg.6
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 12:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=gojuXeiAJOSy3/DtsptehDxMc4WEvKVnWFIlQO9sDIA=;
        b=Jvbd6YHgdYjzrPnXJDJm3mCYYF6D8ySZTo1N5G11v0eAHGRy6SVBosoQhj7JwFUh3g
         eicY/zujM1+GNufw8Sp1aNH/USui06SS7unFDTqbTgcy74Ciuf++VuaQ4V0PZcvDkSyv
         opy9bz0s/F5eHRVmLe2wCI6zgjKPx4ZqHUPfA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gojuXeiAJOSy3/DtsptehDxMc4WEvKVnWFIlQO9sDIA=;
        b=Dmw14xWhUxkqnS2DVbzvJxAnjcbaoduz7jXwy9rraV7tXc4PBFF2Z1P8EoB/7JoQXf
         Zkhkr3WjGO56FcoRKRYOrJGccDXXNPvHyc0DJsOROUKk3VaMK0Xtc2StRq/aa+UVd/jq
         UlWfeb2GTYXhvJf0jkqR5b81Mf8Sx6XrYxz8qBuKXxATkdq5q1K84ULsuIvdZO1ofAe6
         bbeM0eATsqrAmzafRr7G4wg4f4HJ/QEWDp6tr0hUZUz4sVA1DPcldP9DlyX/YWyj6v0V
         jFe4D50R1VOYJACTHhBFORU6CJTNUwl6meesYmnkdr1G8MRq/MFTiY/MCMcgJulWgccl
         hFtQ==
X-Gm-Message-State: AFqh2krWQS+gZv855Q12zSBnkkS2O7Zc73GjYds+SVHxlI9xRusmMrZI
        kDt32C/dUBbFYpskR5eUiRxyrg==
X-Google-Smtp-Source: AMrXdXuUhT6YpTwL5XRzeyScmly38+amMVg3l0LQR1ZRnS4Rn2MqWkt7NgyMKqyMaHt3bl7Xtm3gtg==
X-Received: by 2002:a17:906:7f0c:b0:877:77f5:a8e2 with SMTP id d12-20020a1709067f0c00b0087777f5a8e2mr16424827ejr.63.1674506878499;
        Mon, 23 Jan 2023 12:47:58 -0800 (PST)
Received: from cloudflare.com (79.191.179.97.ipv4.supernova.orange.pl. [79.191.179.97])
        by smtp.gmail.com with ESMTPSA id e11-20020a056402148b00b0048ebe118a46sm171996edv.77.2023.01.23.12.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 12:47:58 -0800 (PST)
References: <20221221-sockopt-port-range-v4-1-d7d2f2561238@cloudflare.com>
 <20230123175526.59356-1-kuniyu@amazon.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, eparis@parisplace.org,
        kernel-team@cloudflare.com, kuba@kernel.org, marek@cloudflare.com,
        ncardwell@google.com, netdev@vger.kernel.org, pabeni@redhat.com,
        paul@paul-moore.com, selinux@vger.kernel.org,
        stephen.smalley.work@gmail.com
Subject: Re: [PATCH net-next v4 1/2] inet: Add IP_LOCAL_PORT_RANGE socket
 option
Date:   Mon, 23 Jan 2023 21:46:45 +0100
In-reply-to: <20230123175526.59356-1-kuniyu@amazon.com>
Message-ID: <87zga9vuyr.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 09:55 AM -08, Kuniyuki Iwashima wrote:

[...]

>
> Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
>
> In case you might forgot this comment, but the patch looks good to me.
> https://lore.kernel.org/netdev/20230111005923.47037-1-kuniyu@amazon.com/

Sorry, it has slipped my mind. I'll apply it in v5.

Thank you for reviewing.
