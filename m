Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08815616E06
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 20:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiKBTw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 15:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiKBTw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 15:52:57 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BAA11445;
        Wed,  2 Nov 2022 12:52:57 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e129so17138888pgc.9;
        Wed, 02 Nov 2022 12:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aYp24omPHN0bbvzzSbeOByhwh1045NSDj6myAMlpHzs=;
        b=X0cRKUPXI37K7E3OEd1U5rMMpOGGxC03pJ+1EwjWJdmI5LiX4uczxOBMELWxd9KcAv
         73WNbc7D4Eag/SnB2DUJCJm5RcLvdceBox8LMtCDqSX5Bf3E/+zLJwZuTIud3FmGaqy7
         NqTfck6bQQr7c4vYO5rj8eDmBSjGheN4utrC1tkHmdQebMxpOX9FHCT32HD/whTL8w0p
         r9GyVZDD70+xV8kGpFO2OTmXxj/HD7vTPQ2YeqvoghFMrpH0j6B0hSQfVeH50y+0l0/k
         IU4B3GEIiBDb/pftzMakfIru1eU9oEkWwW46y+Gci90eEvuukNwPmldLYbWGvTuNHByz
         SOVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aYp24omPHN0bbvzzSbeOByhwh1045NSDj6myAMlpHzs=;
        b=HXqTMylk9xB1G2VZJ8hzcC4oP1v2gr68MJbgKxPJvf/KZFUppeAsKF8hcsFKYJ24gf
         gjRFsQDf6JgUKYpjzqWz8/VQQvpyN1c8YCzO1u9Oi1MWDDVL1uUQRYNh79wOn9G4BNfM
         lGa0cqD6+pr9KZn8Yx+g+ZqbgAW9KgyhqLQs4/h7Dx4AVz4x7VWWTzi/Iwh09+toTyjX
         y01/ok2YFLy7HxnmOajULfgQmC5a4b6S39dLdeDnYy6bqFnbxrka4AITsYQjflMWlvrE
         yPYUPqn5gEJFfLN3YzPKIRlUdGf9EgApbLy9F8t0Im2VLN2X7bHOE+jTQqsU1P9q1fUb
         8mCQ==
X-Gm-Message-State: ACrzQf0jTV5XpNKF1Lr0hZuCBAo825e56An0ElbRzpLQmT7tvErv/uMF
        wAJbdlT89ioFiSqd9IFGmqhGYtznkHuhVnwRHBE=
X-Google-Smtp-Source: AMsMyM7jyv2hDc2xFubeC6LWZ79sPVywK7e70UBBaJ8PriKu575coH1OTW9AAD17pG20IROdxSkjMJcCos+BZXAV5HU=
X-Received: by 2002:a63:d905:0:b0:46f:8979:30cf with SMTP id
 r5-20020a63d905000000b0046f897930cfmr21275910pgg.87.1667418776200; Wed, 02
 Nov 2022 12:52:56 -0700 (PDT)
MIME-Version: 1.0
References: <20221023171658.69761-1-michael.lilja@gmail.com>
 <Y1fC5K0EalIYuB7Y@salvia> <381FF5B6-4FEF-45E9-92D6-6FE927A5CC2D@gmail.com>
 <Y1fd+DEPZ8xM2x5B@salvia> <F754AC3A-D89A-4CF7-97AE-CA59B18A758E@gmail.com>
 <Y1kQ9FhrwxCKIdoe@salvia> <25246B91-B5BE-43CA-9D98-67950F17F0A1@gmail.com>
 <03E5D5FA-5A0D-4E5A-BA32-3FE51764C02E@gmail.com> <Y2K8XnFZvZeD4MEg@salvia>
In-Reply-To: <Y2K8XnFZvZeD4MEg@salvia>
From:   Michael Lilja <michael.lilja@gmail.com>
Date:   Wed, 2 Nov 2022 20:52:45 +0100
Message-ID: <CAHgAcbNOCSzQrCScdGumgFD6+X0BjdMgHdCiY4fkanPN_Qg86Q@mail.gmail.com>
Subject: Re: [PATCH] Periodically flow expire from flow offload tables
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

thanks. I have been too busy elsewhere so I have not yet looked at
patching the IPS_OFFLOAD myself. When I quickly looked at it last
week, the IPS_OFFLOAD got set a few places, so I'm not sure there is a
race somewhere still.
