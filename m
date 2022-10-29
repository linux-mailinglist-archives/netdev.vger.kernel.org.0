Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71EE612440
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 17:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJ2PgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 11:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJ2PgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 11:36:01 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93315DF13
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:36:00 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-3691e040abaso72144007b3.9
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aZpFWbfpicbmfGVmOkyYqi7gf0Fq5KnpTb9I9MsZVtM=;
        b=XnIFgzew2Mkne5TXW3jdmzelZtvx0LYP7mRYGrN5ZiviwW19FOhPgz9yQDkPXJ1JHt
         DLIpnrl1dgUaV+dSp4779vDnHbh1Mw297jT7TIQsn97Hes0Balqlrb+hzqAAeFdkPj0T
         mks98l+z467t/ipv9uy924AL1lqtGOtTfsMJ8v1XF6YTIx2DF7CBVo09+gpF9PMq+zK9
         xeyRCT6q9J9k4SIVZ0jr+7zE2l2ax7lG9iIZ7Mwq2/dyM1j961Rplfs6zNhikugIPujb
         TIlXqE0qyhv1dHnfFXK3ONb1RCMzaYu1/C7QZUietR1THFbLHjTJg/B1En14vdN0YYcT
         0TTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aZpFWbfpicbmfGVmOkyYqi7gf0Fq5KnpTb9I9MsZVtM=;
        b=LSSvOJYt2MBJ7lNNkAHZkmpPvM/6qjFCbbXEfg6nAsKHs8h6Z9iwt2r6S7PbwGq/AL
         n5dauTmqv/c7BEHneqP522rIphjJ7Sgn+7Yvfbb+xpnKLIMYn7IKoDbdKbBLcHP+GAAh
         mUbi8tOvG6s+1Lz2Fo4s6JXJkgmfKg8WUbsQGn46q+RNC7P5/YhYYYZNQZJzqoKY7nqx
         tzdVw6Z/+2acd/oUJASSgcVdQTJyfT0pMin3x+UuJXi7Sg90GxnOJeIWnZ/QnfXHhNgJ
         Y2rI/Ts3G8KKt/G3GpUs3beDYE9jYRPLEFsy8OZEj/obBaqg4OdSgATKYcS+1kgfWb40
         7xUw==
X-Gm-Message-State: ACrzQf25GIPbgBh40Ye2aFWZvWrBPTuKnHJYwB+z5iRMUqXH8Bc+w7ZT
        d4gOLvIF7mYwi9n/fo3pIQpgppaQ1BzZdTIFv8k/SA==
X-Google-Smtp-Source: AMsMyM4a28U0XcS5hyYeRFeZQ0wvsiwIzJ/2+bRgRx/rTL+LIdPjAtyd08km0iA6b59guTQfampcB+mymd2P8lbJoOU=
X-Received: by 2002:a81:6084:0:b0:370:10fa:c4ff with SMTP id
 u126-20020a816084000000b0037010fac4ffmr4657052ywb.255.1667057759724; Sat, 29
 Oct 2022 08:35:59 -0700 (PDT)
MIME-Version: 1.0
References: <20221028133043.2312984-1-edumazet@google.com> <20221028133043.2312984-5-edumazet@google.com>
 <20221028222007.3295e789@kernel.org>
In-Reply-To: <20221028222007.3295e789@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 29 Oct 2022 08:35:48 -0700
Message-ID: <CANn89iL1sgV59i00ZV27kV3rh7VmORGHKH0t4NkXdztXXCcSrQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] net: dropreason: add SKB_DROP_REASON_FRAG_REASM_TIMEOUT
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
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

On Fri, Oct 28, 2022 at 10:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 28 Oct 2022 13:30:42 +0000 Eric Dumazet wrote:
> > +     /** @FRAG_REASM_TIMEOUT: fragment reassembly timeout */
> > +     SKB_DROP_REASON_FRAG_REASM_TIMEOUT,
>
> I'm guessing the shortened version of the name in the comment
> is intentional, but kdoc parsing is not on board :S

Right, I will send a V2, thanks !
