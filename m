Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E285BF948
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 10:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiIUIbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 04:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiIUIbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 04:31:23 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46AF7DF44;
        Wed, 21 Sep 2022 01:31:18 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id w28so7527896edi.7;
        Wed, 21 Sep 2022 01:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=DEz21CqJnQdDFUCM4krQvks0WhIiWv4YsiIoxyo+oFk=;
        b=JRiStm1KS1kpNMq2xf4Z6FcQk6g+31kMDbOgeBIibakKg7CGg/jXyFc1kIPEnc2vIt
         VRAUSqS7dHNEq7Lwj12HjYWWEGjoSuhjNgtoT/eMjyqOoINCEP85JaQR034Cx6YEd3ld
         Z3Na/oXZ8stQw1jnnBjlb6a2tyxwrhiCpOy/xM0MMjSjx6uaWZNaqyBJeHh76txWK+2t
         QPIJX0xVa4a99mH1l2ZJEjV2dREJzqpI3nwS2Nbqj7XMAP3MoVWkuhJxJoTiIYiUL6TK
         hU/K9MKx4QPFa7Omy5qKz6WnPS3pqlNrZ9MZZd3zo8j1eqU3gh8ob/2CjaFXg2f3Rfwl
         L6sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=DEz21CqJnQdDFUCM4krQvks0WhIiWv4YsiIoxyo+oFk=;
        b=OTfdv5R7wFQfwUBo4LDliVWWmCcXkKci4sDNAQgdPJPEFNpMP369K0EKQ6Sm643tVk
         qyDaLOPOmR/7fjfJbpwno71wI6rUNiyb42fVU9zjn+t89plYSDlwSF6YQ7jxXLU8Ztnj
         UNmKt7MINokiCqUyP3CHJTqM2NGuJ/TgQTkHgQnHrFO9Tfyz405k1+9VLqBG6HGCrweL
         fO4knvmV2uz8USRW9eDIGntZPGurN3PnLpqpc7qO+ITPlWocSQ6NxSW25dGQG4wQhWJC
         BtEPT4OG8wN6lm0iF2cSJ9xzQSlvHRt0SfTx5k+uAL+zr2QkNRe1qK2tPsLOBfPD4J2k
         kaqg==
X-Gm-Message-State: ACrzQf1hqfdwrKCzlU9ZSMnrZAAv5x173r84dOOeYsMToO0YhYXKVzA4
        hAYgnptyT24ZSmjyopPxIr4+CGygnfetczx3gvY=
X-Google-Smtp-Source: AMsMyM6HpN6sWx6pjoW7ofh1gaIlbazcDw/iG+FW6QN+wMRPcsho+idl1BNof/7YAbdjBv6VythbcNK4/vUQqca3gaQ=
X-Received: by 2002:aa7:d51a:0:b0:453:9086:fc37 with SMTP id
 y26-20020aa7d51a000000b004539086fc37mr19860298edq.174.1663749077301; Wed, 21
 Sep 2022 01:31:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220917022602.3843619-1-floridsleeves@gmail.com>
 <20220920113744.64b16924@kernel.org> <CAMEuxRq3YDsCVBrdP78HnPeL7UcFiLWwKt6mEB2D+EVeSWG+pw@mail.gmail.com>
 <20220920124148.58e8aab5@kernel.org>
In-Reply-To: <20220920124148.58e8aab5@kernel.org>
From:   Li Zhong <floridsleeves@gmail.com>
Date:   Wed, 21 Sep 2022 01:31:06 -0700
Message-ID: <CAMEuxRrRJ6RZQ5Pjoxb+5cn1Z5iKZNvZ_ydATBwB1NV5S-pEog@mail.gmail.com>
Subject: Re: [PATCH v1] net/ethtool/tunnels: check the return value of nla_nest_start()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, edumazet@google.com, davem@davemloft.net
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

On Tue, Sep 20, 2022 at 12:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 20 Sep 2022 12:31:29 -0700 Li Zhong wrote:
> > On Tue, Sep 20, 2022 at 11:37 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Fri, 16 Sep 2022 19:26:02 -0700 Li Zhong wrote:
> > > >                       goto err_cancel_table;
> > > >
> > > >               entry = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY);
> > > > +             if (!entry)
> > > > +                     return -EMSGSIZE;
> > >
> > > not even correct, and completely harmless
> >
> > Thanks for your reply. Maybe a more suitable way of error handling is 'goto
> > err_cancel_table;'?
>
> Yes, but you _most_ provide the detailed analysis of the impact
> in the commit message for the patches to be considered for merging.

Thanks for the suggestion. The commit message is updated with more details.
