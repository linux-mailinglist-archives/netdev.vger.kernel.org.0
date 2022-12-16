Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E649964EA27
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 12:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiLPLUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 06:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiLPLTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 06:19:54 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBBD566E6
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 03:19:52 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso3857340wme.5
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 03:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yTqI/CbUV6jX5wui5JlBloMcUYv0mbcJiOcRypXtbrA=;
        b=PCIQzT4VelcoRW6FLNL6ix0D1MEvir/ty9yEjUivHY/4Aq2UqohEsun4e4TVjc4aI+
         HQ1JVqKmffKvBJE8+NpYDcJTKQbaZspIS7Kip5cBDTFcdnJnpi6q4UTaY9WW2dm9YLlU
         N7NQ6qIHu0FoDmfQwAK2spJGEJyyw9HpWDgzdSxfaK7jiPGiJll+lovvCoBHgSgj/VLO
         s2sGvdQyWLPUYzSeBYj45LBZ7jsLIvnQr2bGi8mNRadiIY0gW6OUAzfQMFcdaG62XKYh
         a2Rky7gWgQQXSI664j75HPyc9qkIYPIHS8PovfyKile0OWlNfdqbuyUgxtXGeWOuMWz8
         FrJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yTqI/CbUV6jX5wui5JlBloMcUYv0mbcJiOcRypXtbrA=;
        b=e7Ql5l/vLVB2vx/Zo4OeuUFLYgI9p8sUZBPgW5TmJOE8CDzhCBIClW24zu2KVH+TbA
         WGDqZ6nHfb2+cwc/PDwIhYgL1EfL4qwdjF3YqqDaw8wmPdj/azDTxReDcZ+M6rLZtRpR
         5xl7YR33dOeUkbBbJlJyZLUOGUDCNYvkjZlBRbXKCEdMYucQmC25MBcKG+PBUKt5Bnzu
         yBL2OdFDN5BPeIQ8FuvmlTw66yJBlfAtVKB641q+G/eX/q5xIer3eiV76vsAV1QADAmk
         4k0/++77xY5gSS2fojqJuy/6QYpbN0j1n32j5wFjzm4qv3lmbJlHSJnCBzCYR0Ca3pUC
         E/WA==
X-Gm-Message-State: ANoB5pnqn7aXh4tfk5nZaOGJOs7vNOuWjL6mvODpferMq5HH30HDkQfU
        Zeuq7UrSgHbtmejGkiH4Ay+2ug==
X-Google-Smtp-Source: AA0mqf6Mf9CTSxZ3ImnQysNj0CvMXjr990uEVF3HpCsC9SxxmPGmrBCVq5wr7QtdHX28vgEdaWa5Kg==
X-Received: by 2002:a1c:f315:0:b0:3cf:a5df:8bb0 with SMTP id q21-20020a1cf315000000b003cfa5df8bb0mr25853743wmq.37.1671189590508;
        Fri, 16 Dec 2022 03:19:50 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id y18-20020a5d4ad2000000b002365cd93d05sm2032160wrs.102.2022.12.16.03.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 03:19:49 -0800 (PST)
Date:   Fri, 16 Dec 2022 12:19:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: Fix documentation for
 unregister_netdevice_notifier_net
Message-ID: <Y5xUVF4tL5sM2iBx@nanopsycho>
References: <20221216094838.683379-1-linmq006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216094838.683379-1-linmq006@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 16, 2022 at 10:48:35AM CET, linmq006@gmail.com wrote:
>unregister_netdevice_notifier_net() is used for unregister a notifier
>registered by register_netdevice_notifier_net(). Also s/into/from/.
>
>Fixes: a30c7b429f2d ("net: introduce per-netns netdevice notifiers")

Hmm, I believe that comment fixes should not contain the fixes tag not
to confuse anyone (bot) as this is not fixing a bug. This is net-next
tree material, please mark it as such in the patch subject line:
[PATCH net-next v2] ...

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
