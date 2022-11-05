Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984AD61D90B
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 10:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiKEJWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 05:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKEJWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 05:22:10 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26BC2CCA5;
        Sat,  5 Nov 2022 02:22:06 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso10259904pjg.5;
        Sat, 05 Nov 2022 02:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ku7tg7vlTu+0wtrHVbGpGhCA4LfoCHMdGfBR8gpdZlk=;
        b=ENA9IBJJsYC3zZTHu+0cQxuLi2znIha99DuKnef32a5MS2H1mJNuu9E8PLSGoQq+Rl
         jPnxVErqC+8XytlaLlOPADQ0krIDVM068yPfOoafiNudxcOKfdgAmpmLch3XTWddiaK9
         xDcT30qUR33gfdXDSrNcVvw1GTdaiXfDlZry0ZvqyZxRdP9nvDZsROzFeIKMttxfPg4w
         qqW6F9dd3+TtMzzQUhHvbgQBK1iab7670NE+WgaTeivquXTKjxMyLH6uwCWPtTvlFSpe
         CDR/HJ9vELySVeuPLjiW/ZuQ5WHWWLksbRQtDRCmWmSg/EE04s4GALULEJc0S7f6UJLU
         p4Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ku7tg7vlTu+0wtrHVbGpGhCA4LfoCHMdGfBR8gpdZlk=;
        b=tSr1iewXNFls2rFrjJU9R02s6SBKRYc/1EoUpwmM0jw3H1+c+q9Yt2r3H0QRLJkUTS
         XfoYClIJEuKjmWfUnUtDX8bFLfFwKYOMCnfCuqn/KZx/Qx924zDaYpF55fII7U/x+CUv
         E/X2+HjiGCgVdb4wnRgCpEgt/0c1pdRzuM76YB8fuo8UmCg5tTpa9ewd72LsSJpIl1fv
         b/MiOH3/PEswXbEnhDlyJ7KyGfgoePqPA4HzdpCGYMvu0W0gy8GwG7YG2bU5dkcfi+8W
         KhNAFBKRfRU3CDZmOXnrWMrrydooKAi6o+oQWboSGB2arJmTKgwG4sDjqNytQQdZvgg9
         SAqg==
X-Gm-Message-State: ACrzQf1N4V+0KYhuxQtR67E0xnq8/Oa79fQDMf5wWIZmP1xwDWIQDa26
        grspZ/1njI0gQ/KwVN+twKjKGV0pUYASOTGIb5k=
X-Google-Smtp-Source: AMsMyM7QDna4RxuXN+cxHzQ/iih6bfNqu0JekZkVEPHm9VczoWVyueFpgevWVWrBlH3UbyliCLBEKRPgKELRp27lJiQ=
X-Received: by 2002:a17:903:185:b0:187:2430:d39e with SMTP id
 z5-20020a170903018500b001872430d39emr30261014plg.65.1667640126233; Sat, 05
 Nov 2022 02:22:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
 <CAK8P3a1biW1qygRS8Mf0F5n8e6044+W-5v+Gnv+gh+Cyzj-Vjg@mail.gmail.com>
 <8bd1dc3b-e1f0-e7f9-bf65-8d243c65adb5@opensynergy.com> <ed2d2ea7-4a8c-4616-bca4-c78e6f260ba9@app.fastmail.com>
In-Reply-To: <ed2d2ea7-4a8c-4616-bca4-c78e6f260ba9@app.fastmail.com>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Sat, 5 Nov 2022 18:21:55 +0900
Message-ID: <CAMZ6Rq+RjOHaGx-7GLsj-PNAcHd=nGd=JERddqw4FWbNN3sAXA@mail.gmail.com>
Subject: Re: [virtio-dev] [RFC PATCH 1/1] can: virtio: Initial virtio CAN driver.
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Harald Mommer <hmo@opensynergy.com>,
        Harald Mommer <harald.mommer@opensynergy.com>,
        virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Stratos Mailing List <stratos-dev@op-lists.linaro.org>
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

On Fry. 4 nov. 2022 at 20:13, Arnd Bergmann <arnd@kernel.org> wrote:
> On Thu, Nov 3, 2022, at 13:26, Harald Mommer wrote:
> > On 25.08.22 20:21, Arnd Bergmann wrote:
> >>
> ...
> > The messages are not necessarily processed in sequence by the CAN stack.
> > CAN is priority based. The lower the CAN ID the higher the priority. So
> > a message with CAN ID 0x100 can surpass a message with ID 0x123 if the
> > hardware is not just simple basic CAN controller using a single TX
> > mailbox with a FIFO queue on top of it.

Really? I acknowledge that it is priority based *on the bus*, i.e. if
two devices A and B on the same bus try to send CAN ID 0x100 and 0x123
at the same time, then device A will win the CAN arbitration.
However, I am not aware of any devices which reorder their own stack
according to the CAN IDs. If I first send CAN ID 0x123 and then ID
0x100 on the device stack, 0x123 would still go out first, right?

> > Thinking about this the code becomes more complex with the array. What I
> > get from the device when the message has been processed is a pointer to
> > the processed message by virtqueue_get_buf(). I can then simply do a
> > list_del(), free the message and done.
>
> Ok
