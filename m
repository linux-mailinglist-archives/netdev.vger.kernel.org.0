Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C989651DEC
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 10:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbiLTJrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 04:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiLTJrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 04:47:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E08FF3
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 01:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671529545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5NoS+Bqz9ATFzWnlIG9oJwXTJiAoyqlPjgi89DKPgSU=;
        b=EdpTymmSDnK1FN4mLAFYmrF1ia8l7EcTIP08cKC39azO7KXCqeeYXGkXqBqQ1rkT9OMZz4
        kS7fV5crOD/wG5njK4bwzsT5S9njxRisyoujosGfVY0ZK8fYPLvgKNVUb1UXDD8QZLfRW0
        sW3iDiW7hI6fz0q14sdbtawHuqOW5tQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-651-W7XchaZzODq9O0soGHeDsQ-1; Tue, 20 Dec 2022 04:45:32 -0500
X-MC-Unique: W7XchaZzODq9O0soGHeDsQ-1
Received: by mail-qv1-f72.google.com with SMTP id m4-20020ad44484000000b004c78122b496so6878845qvt.7
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 01:45:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5NoS+Bqz9ATFzWnlIG9oJwXTJiAoyqlPjgi89DKPgSU=;
        b=EDAKjXGex1By5yMpUhdpubI9S9wmN2xXRT/P3Ck+emZ/DMkOyzg3Q7VpDCa1bTo9qk
         /AU92LiQjql120YhwUpeJEuNClOehlV4KVbzc58IGipA7a9OF+Bf++myM72STYLGCIol
         NtRnLT9EsQxuAQJnVKRBKveGZhqikDziDFdE0m4ivUoUe6fvZzFKofdQwqy94KtoJAz5
         Ot/XVt+CfC/1mDWcoAz8UogthBz5UN82Lme27axwA3uXNEq9BJxRp4nIfxcQ9LloIP4o
         dEr4r1bmCYE+6rHKeuAeQCKfcL+F55DM/NY1XlWFC4elzR3L6ycHAFzaY830Wva4Xd6b
         4L0A==
X-Gm-Message-State: AFqh2krKjaEqByoo8BQDib4aR6786EkGj8kVv8XzhBsQDUfkeN6MeluS
        ZVP3+w7/5d2DAiejIbS5NYUiiULRcDwkJHDfODN/vDTyCg8lSNPT0GZxWfH3jpi4s36dX18bX45
        Qm3d/hAAjiyLjKnKW
X-Received: by 2002:ac8:4752:0:b0:3a5:6961:e1c5 with SMTP id k18-20020ac84752000000b003a56961e1c5mr2603571qtp.48.1671529531667;
        Tue, 20 Dec 2022 01:45:31 -0800 (PST)
X-Google-Smtp-Source: AMrXdXta/lY2p7viJf764arQSIM+mAkP5mp0z/MMrwsYN8PvneFOw07z0yJIqG58rVh6SkI8fJdTIg==
X-Received: by 2002:ac8:4752:0:b0:3a5:6961:e1c5 with SMTP id k18-20020ac84752000000b003a56961e1c5mr2603558qtp.48.1671529531425;
        Tue, 20 Dec 2022 01:45:31 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id 124-20020a370582000000b006fae7e6204bsm8403328qkf.108.2022.12.20.01.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 01:45:30 -0800 (PST)
Message-ID: <ddac533a2c4db7efd4214a5a4f7f9f5797bf2a51.camel@redhat.com>
Subject: Re: [PATCH] net: alx: Switch to DEFINE_SIMPLE_DEV_PM_OPS() and
 pm_sleep_ptr()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Christoph Heiss <christoph@c8h4.io>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 20 Dec 2022 10:45:27 +0100
In-Reply-To: <20221217104024.1954875-1-christoph@c8h4.io>
References: <20221217104024.1954875-1-christoph@c8h4.io>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, 2022-12-17 at 11:40 +0100, Christoph Heiss wrote:
> Using these macros allows to remove an #ifdef-guard on CONFIG_PM_SLEEP.
> No functional changes.
> 
> Signed-off-by: Christoph Heiss <christoph@c8h4.io>

# Form letter - net-next is closed

We have already submitted the networking pull request to Linus
for v6.2 and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after Jan 2nd.

RFC patches sent for review only are obviously welcome at any time.

