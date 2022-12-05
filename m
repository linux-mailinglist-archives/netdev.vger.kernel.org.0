Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49982642E09
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 17:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiLEQ6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 11:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiLEQ6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 11:58:49 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6265DEC1
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 08:58:48 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-3704852322fso124466177b3.8
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 08:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b4FnVG9CvMwOaoefk8RFLw+V3FPIDJ4g0+liDDmbBrU=;
        b=b16PKuFraMFTSNgbojgdPURSbayXPJPy05u+7irwPt3hjOo2RnVqEnYsJzaNZ3m3ZF
         URU4m0IWCfslMjoaITU0pqwYhuy6n4hpJCmS12nKpKA6/0slBZMcxXYS3/kyia4zvIvZ
         iv44HSLOjjGdM3mAZWC5RlmeAZXW0KujEJb4QIrt4xtKuTIeMI89hQIu2V+wGuD4Hh5O
         JO9TbbLmL7/TnILGLCrpL6pwl/jrxeoi97IX022mTPrDECKlZd9k5KF87U8nuip4Nv3r
         NAXj9677nzbeDkSsIRGuLJxn2WsI0T2YcgDXwybPC635zh+mKaO9Xxtpa9yyYA8+M0l7
         yd/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b4FnVG9CvMwOaoefk8RFLw+V3FPIDJ4g0+liDDmbBrU=;
        b=EAwW2H6CUBzcazUS7ihp31EHqhRbcMA4lt3IuKbpksPmAfhevgqMjlzCT1D0o3jcVX
         ZSpk47GJVAnwnyPhhqP8mMpTck380bZhcLVMxtJZ60WMzEKYKRSi6TUS2VaKKAgQENPP
         H2xee9TBxWdd5rKCSvs2TWT4rftWlr7tGwG9K39K5n96E0lmiMsPPJ2tsORL0G6Mx04g
         kHhHg3ytrZ0nm5AVmvreZO12zltsCQM80EOJ4OeA6xSNdSDv+D6S5PHTFQMVb/nPuAIT
         pnGYy6QGhTRu8zd1Pcfy8P51x5Pe08G86Yr6pX5R37cOFHQRkFwADIH867QHweKnU/X4
         +nAw==
X-Gm-Message-State: ANoB5pmf6LULxqaxjHCNju+IyJGWbKEx3oc/HzKP7cMjSyEhGJltZClV
        qnbgITeuJyMJ0fOkWdI2Rq6XWbaiQ0NIGevUwfKkKw==
X-Google-Smtp-Source: AA0mqf5v9z+tJTtp/2qQCCKuXN5ds2ulIeWtJJjdQX1jUtI6Usl9dtaZk2dTlf0TUssF27sy9yTFT40I1+4zE71+ZSE=
X-Received: by 2002:a81:d87:0:b0:393:ab0b:5a31 with SMTP id
 129-20020a810d87000000b00393ab0b5a31mr11266197ywn.55.1670259527617; Mon, 05
 Dec 2022 08:58:47 -0800 (PST)
MIME-Version: 1.0
References: <CAEXW_YRW+ZprkN7nE1yJK_g6UhsWBWGUVfzW+gFnjKabgevZWg@mail.gmail.com>
 <21A10014-22D8-4107-8C6C-14102478D19B@joelfernandes.org> <Y43RXNu0cck6wo/0@pc636>
 <CANn89i+RNj0gaJCyNUyrMBpSTsxSgjW1YN_FuRW_pMUOMiQtuQ@mail.gmail.com> <Y44HNfuR5OgfEXxV@pc636>
In-Reply-To: <Y44HNfuR5OgfEXxV@pc636>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 5 Dec 2022 17:58:36 +0100
Message-ID: <CANn89i+8Au1+Wa_F0QGAz2zfA7UYcCF_9a0BqCpdAqMOrNVbsw@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: use 2-arg optimal variant of kfree_rcu()
To:     Uladzislau Rezki <urezki@gmail.com>
Cc:     paulmck@kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Dmitry Safonov <dima@arista.com>,
        rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 5, 2022 at 3:59 PM Uladzislau Rezki <urezki@gmail.com> wrote:

> So it was a typo then. How did you identify that BUG? Simple go through
> the code? Or some test coverage?

Code review. I am the TCP maintainer, in case you do not know.

>
> Thank you!
>
> --
> Uladzislau Rezki
