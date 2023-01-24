Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEEF679950
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 14:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbjAXNeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 08:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234130AbjAXNeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 08:34:07 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C628D3594
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 05:34:05 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id cm4so249330edb.9
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 05:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+R92fQrpcdOxA7n8+Wz6CRyggOb716hAqimEPplr2M=;
        b=wjmdH+Js/pyt67ToH4gglRTsx7PRg3bQ+k7S4YmLlM7GBIDtJJFkZb91Zhlw34LtvD
         bH2YD2DA6Hx//F1bT2PZUEZk16UDnKz/GDufYvMiVQsih9jQs6A3zyK+CJLlcotehxQQ
         sXj4nNkLYMqf2rjEHhsx2sD3BD8Qnc7Jv1awE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q+R92fQrpcdOxA7n8+Wz6CRyggOb716hAqimEPplr2M=;
        b=L0UCbozcJPLxJFFSUnJxtAz0lrU/hNfVyxQR2XNvTSKXR0uNF9GL0fHQjcl7/c6x7o
         WmgXtT+O9SOM1bzgLHTgZna3Ieu7tH4pz9kxqSbiSRn9KucSJdgAqF/BYX73qM+P3XD8
         3vgtspmsBdooMAoxRIZHq8xjE46OmIUOEeNHCqvMGohHnk7V2ns3pVr9emqfUt22rHRE
         sFsca7zxEWfOQnsWGktiePFS9M3dLp6vsYPHRHWM4vzPd4w7vDGiXK2Jm66K7HCZMUqE
         7N1EmmmuQfhbk2srYYQnLPPezOv/Ye5TQvOExhgVXqQ1qPNSKE2iPJA8udAI9tQ1MHbB
         Z2rg==
X-Gm-Message-State: AFqh2kqZzW/jvDZNFCLW/QSVoQUoNsg3aPBEwiTv4R/N5f3JhT5HGgjy
        2kzOiAyXkaeYAj+hB6MxGcJSLuTRuu+xyot1
X-Google-Smtp-Source: AMrXdXsdS/bhr7JQkKp3wXtxrtV3ghb1VYV47FKbContXQHG5E6JgdMdva4GJ44Ei9qStxyZMbImuw==
X-Received: by 2002:a05:6402:27cf:b0:49a:23ce:2ab4 with SMTP id c15-20020a05640227cf00b0049a23ce2ab4mr35735860ede.42.1674567244288;
        Tue, 24 Jan 2023 05:34:04 -0800 (PST)
Received: from cloudflare.com (79.184.123.123.ipv4.supernova.orange.pl. [79.184.123.123])
        by smtp.gmail.com with ESMTPSA id v25-20020aa7d659000000b0049ac6f53e6asm1049657edr.80.2023.01.24.05.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 05:34:03 -0800 (PST)
References: <20221221-sockopt-port-range-v5-0-9fb2c00ad293@cloudflare.com>
 <20221221-sockopt-port-range-v5-1-9fb2c00ad293@cloudflare.com>
 <Y8/NrXosvah67bUg@unreal> <87fsc0w1hp.fsf@cloudflare.com>
 <Y8/XYBtzMzKyIZjo@unreal>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Neal Cardwell <ncardwell@google.com>, selinux@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@cloudflare.com,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH net-next v5 1/2] inet: Add IP_LOCAL_PORT_RANGE socket
 option
Date:   Tue, 24 Jan 2023 14:32:38 +0100
In-reply-to: <Y8/XYBtzMzKyIZjo@unreal>
Message-ID: <878rhsvyyd.fsf@cloudflare.com>
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

On Tue, Jan 24, 2023 at 03:04 PM +02, Leon Romanovsky wrote:
> On Tue, Jan 24, 2023 at 01:33:07PM +0100, Jakub Sitnicki wrote:

[...]

>> I'm happy to adjust the changelog in whichever way that will make
>> everyone content. However, ATM we don't have one, it seems.
>
> We have, just some of us don't care. It doesn't mean they prefer to see
> changelog before ---.

OK. Thanks for clarifying. Will sent v6 with changelog moved.
