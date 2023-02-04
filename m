Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D9168A822
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 05:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbjBDET1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 23:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjBDET0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 23:19:26 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D021C651;
        Fri,  3 Feb 2023 20:19:24 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id h9so7182944plf.9;
        Fri, 03 Feb 2023 20:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8uE1zGV4oE8NP4bFEdcyTsVfeRPl+LQz40mwiE0LafY=;
        b=lxDIDCZIq9tmu9rweUPBRFcMVXMDfDmiyt0j6yIdj3ut0e165I9sRo0tGsdC2ATWFN
         vbgvctKcCmFzngWuNJNkB5al7g9AXoWJYxcXInHBp2e4RcLz2TWf8WPGHpGzZ6iuI9qi
         7PCG1fPF+TNJPOdnz2vGxQvZ8SGa5qFJZ4qqonsxWn3gyR9ESBrFCrWEKXk38EKCIx0H
         pmftWy7Pqn/e2kf7LtxPA84OceazAyWpQdVTJ/Ye6WPGFDuM0cU50kX3VL7vCX5/jS0y
         1YNVm0mGlUMP2XSSv7D3MvQYlwbW1R8FYEdce8ErBu4T3Z1ptKyP9So/G68MIqv99a3X
         2+8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8uE1zGV4oE8NP4bFEdcyTsVfeRPl+LQz40mwiE0LafY=;
        b=5mxOvU3x/CzoUAQhMSZfGacGJcWYr3TvZJnmS8F9WwiAhhqaTr3aNSh5aZP/OfXLXv
         C0lUspCLwtWwt1QZWq+WGGQ0uiiqyjWQJDEnbn0Xt00B0OlKqaCS4z/PBuew24iL9TgQ
         AVilpaisL3osWUkkAfUbyxLdiacBEy4cF4EZIMNdKSeu/ygWuqVGdsTK/GYtvDH6hs5s
         hD3G0wPLAbsJzTqinzohHUZaOVMYqnFn/lPf0OD9mYNGmlK/FuWyR8tW6xKeuTgVlvGC
         fAllrLm/eOHuhZmgaODztEN3IB9JMHpbQHEW8VwKekB4BrQq6HJ28GBKb2SxehUgEGND
         QIIg==
X-Gm-Message-State: AO0yUKV/EdPIhudXdcQtIhGoMvzEXLmzyKOWSMqBdqCx3uFj6LB3Zz8i
        StRrIGlyDDY/mWb/pwvmuoo=
X-Google-Smtp-Source: AK7set9ZRmNQ5f49/zgDdoiei1DXcxnDEXR/thqnm0XdkOJqaDGiXPZK6Las3NUG1gshz3dtTH8NHA==
X-Received: by 2002:a17:902:cec1:b0:196:88e0:ea1a with SMTP id d1-20020a170902cec100b0019688e0ea1amr15117597plg.47.1675484363962;
        Fri, 03 Feb 2023 20:19:23 -0800 (PST)
Received: from localhost ([98.97.116.12])
        by smtp.gmail.com with ESMTPSA id ja21-20020a170902efd500b001965540395fsm2415875plb.105.2023.02.03.20.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 20:19:23 -0800 (PST)
Date:   Fri, 03 Feb 2023 20:19:21 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hsin-Wei Hung <hsinweih@uci.edu>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <63dddcc92fc31_6bb15208e9@john.notmuch>
In-Reply-To: <CABcoxUbyxuEaciKLpSeGN-0xnf8H1w1CV9BDZi8++cWhKtQQXw@mail.gmail.com>
References: <CABcoxUbyxuEaciKLpSeGN-0xnf8H1w1CV9BDZi8++cWhKtQQXw@mail.gmail.com>
Subject: RE: A potential deadlock in sockhash map
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hsin-Wei Hung wrote:
> Hi,
> 
> Our bpf runtime fuzzer (a customized syzkaller) triggered a lockdep warning
> in the bpf subsystem indicating a potential deadlock. We are able to
> trigger this bug on v5.15.25 and v5.19. The following code is a BPF PoC,
> and the lockdep warning is attached at the end.

Thanks, but can you test the latest kernel?

Or at least latest 5.15 stable, 5.15.25 is a bit old and is missing lots of
fixes. And 5.19 is not even a LTS so wouldn't have many fixes.

Ideally if possible testing bpf tree would be the most helpful.

 https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/

I believe we fixed a similar bug already so hoping this is just hitting an
already fixed bug. But, would be best to confirm thanks.

Thanks,
John
