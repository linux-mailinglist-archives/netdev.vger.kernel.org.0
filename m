Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4604D28CF
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 07:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiCIGP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 01:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiCIGP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 01:15:28 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A72159E8F
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 22:14:30 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id r7so1933565lfc.4
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 22:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=h4AlH+3r/gzg5eX46nstzBZnKDJn8S0D2QNOkvCeT5E=;
        b=RxGccc0tqALdhPUlf46vKxglJyQBIk59Z4YoNZLKWzS4TO+ZIu5E9Nh+x93Jo9yElg
         ZtzD48+2GBUd+4Is4EXWzkk9z83J69G1e1oHaClmkfYc8mCTVe32/2v5cXdMFotMJ8EG
         /0oA94GBYWL9BVmL69dLCZNHp1gOixKRgGjn9j6+HiyWSeR7jPg3gpMYTVI0iJJppZvs
         TcDhJWnx/lEx88zMGeljPtKTin/U5YhIQVwwE4iFLSnHz8R87vNbzWgUwTxKGr3DTMwu
         O8zbT5WCG1AchM+WJaQMlWRxX8XUf0vqxzOP9uOvqimCoo9mzYq+FvhbgRqAwymA3ah+
         oILA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=h4AlH+3r/gzg5eX46nstzBZnKDJn8S0D2QNOkvCeT5E=;
        b=ptX8TdHxDZHN2xWSJDCRZXD6uVz9NavFes7N+9WjkLyQqoPIlj/OxSrAkiatVAK95e
         1Wt81AjdVdMM2F9WU7O9ysC9DOZgmAKiW/X4W5bMmfYE0TN/dWIOcnWXDkXAIwSvXU1f
         B8MV5kE9CeOcB2bR15QXoXE0A+O23+ndX5sUVugxFagN0z1CfTnyjhsEerYCSoNrBrhU
         vvAxJDyF9sbJnBeAZrwxXpjZaF2grfNkxngR4BcGu+PRle8Vm1v4w3p6yxPfs+8bbkoS
         3/MzneAaRlw6DqM43Ht9dieztLtiWYK1X7mYBRrmusrJlncJdfye8XqRzAGe5EJwmSy8
         f6xg==
X-Gm-Message-State: AOAM531QyBibCUvlxI2hhgUr3qdzMcDXJivNRaAXaEJTxgogbrfqo+4D
        agoaF+OiLT9fzTJKDzGOmH5XJYEu4uM=
X-Google-Smtp-Source: ABdhPJzUO9keSbo03Tz/Jme8ck8MTOfY67O5LEj3brCaviTPHQz9o61EkjJB+rfH9thZM/Kb++S8XA==
X-Received: by 2002:a05:6512:38a9:b0:443:3b0a:9cec with SMTP id o9-20020a05651238a900b004433b0a9cecmr13682835lft.12.1646806468211;
        Tue, 08 Mar 2022 22:14:28 -0800 (PST)
Received: from wbg (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id u16-20020a196a10000000b0044662feaa4esm208247lfu.53.2022.03.08.22.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 22:14:27 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next 1/2] bridge: support for controlling flooding of broadcast per port
In-Reply-To: <70f81f09-0b18-43c2-206d-c31c518dab4d@blackwall.org>
References: <20220308132915.2610480-1-troglobit@gmail.com> <20220308132915.2610480-2-troglobit@gmail.com> <70f81f09-0b18-43c2-206d-c31c518dab4d@blackwall.org>
Date:   Wed, 09 Mar 2022 07:14:26 +0100
Message-ID: <878rtjabzx.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 18:11, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 08/03/2022 15:29, Joachim Wiberg wrote:
>> Add per-port support for controlling flooding of broadcast traffic.
>> Similar to unicast and multcast flooding that already exist.
> Nice, thanks for adding this. Please also update ip/iplink_bridge_slave.c and the
> respective docs with the bcast flag, it already supports the other two.

Aha, there are knobs and levers over there too!  OK, will do :-)

 /J
 
