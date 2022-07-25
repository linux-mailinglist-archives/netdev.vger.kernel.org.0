Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD30D57FD23
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 12:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbiGYKKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 06:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234795AbiGYKKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 06:10:02 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572261836C
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 03:09:58 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id b11so19578674eju.10
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 03:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sLw8Yfzm3c8kou871/a66dUzbZwPUL/eRicOlobjC40=;
        b=rNPx12rA0JA1rhlipxU/3mPh+AskwJ44Bks9qWvCObOesppBf4cnHDrZ2h29VEONx7
         MLC0UOa95uzVUTQu5eiflxrNjY7d4YVXKIvwT2IsnJo+6PrBHyak9XmDpC0Cvm/R/4o/
         HCpIN5cvN+7uTri6ksW3XMcrgjLUmGFJjza/WPrMCSh8PTKJA8RotvW5rraIRFpUoDL2
         +SKrKL1Hczv056hEIAgkBAB+BoCi9BnHvuxtecN8JAPYVzdnBdgKLEC3+rwPZnEMViMW
         8qXn6rIkOTtiYzl1qUmIpX+wxAJCiwOjLwpfj1VlVFetFd/0dgA9oyFTiFm7HeAmlhM3
         W76w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sLw8Yfzm3c8kou871/a66dUzbZwPUL/eRicOlobjC40=;
        b=l2n5GeMfySA1Fphm3AvA9OXiJ2Cq8ekrwBbWb2d69a8R3FGMCXcm8X6odd6h9lwMed
         zI+nLRYNydQpkvBSBGBdKpSNnbiKVDRwqd0Hh11yMGepFgCfL85SjGNUAEXJQS61T9OL
         02wr+OTSufs6DtLvcy/dQ/+7U3mynuZWI6q6h+7alddE3SoUGS3A+p8zIu2cD5GD3GTc
         N3ZuQiW4gfqyTwLwUKOtDmEc7ZRBi/4ccxMrEcklToy7lPvw3SejxO4m6lpZX2bH2OTH
         WnFNiS2mNgmNunGfzUT+akjV6+pn/k2fgNwDd/nXjvUU/qeICeh9qgT14cELqI0yzl+N
         F7ag==
X-Gm-Message-State: AJIora+1FujDs+CYkvJ77R1xZJ0POVI2Fy9FhT2THZD8Hb2iDV+KrG8V
        NIhMwyKuTiu2sg2nG/HTp6SDtwqYZu7PQL9Ubn6s+w==
X-Google-Smtp-Source: AGRyM1v/DspXr7LSCx0zgVSUMOuoILyjQqe7u4bZntAclyVf6lbwv8tujUS1qi3NrDamF82/VHxr1m4z2orqDMaAHsY=
X-Received: by 2002:a17:907:9606:b0:72f:826d:21b4 with SMTP id
 gb6-20020a170907960600b0072f826d21b4mr9600818ejc.510.1658743796375; Mon, 25
 Jul 2022 03:09:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220722182248.1.I20e96c839200bb75cd6af80384f16c8c01498f57@changeid>
 <CABBYNZ+k+ZOVNi+GYgdiK+B+tqKQXTWYp1QG4JSE_7EwZHNBMw@mail.gmail.com>
In-Reply-To: <CABBYNZ+k+ZOVNi+GYgdiK+B+tqKQXTWYp1QG4JSE_7EwZHNBMw@mail.gmail.com>
From:   Archie Pusaka <apusaka@google.com>
Date:   Mon, 25 Jul 2022 18:09:44 +0800
Message-ID: <CAJQfnxFdnjHdPTdfgE+v=ero01H0dE6LsJ9z3K5LCZ28gogYtw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hci_sync: Use safe loop when adding accept list
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Zhengping Jiang <jiangzp@google.com>,
        Michael Sun <michaelfsun@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric and Luiz,

>  "the userspace can still remove devices" is a bit vague.
I mean removing devices via MGMT command.

> It seems that the issue at hand is that hci_le_add_accept_list_sync() can
> move the current item from  pend_le_conns / pend_le_reports lists ?
The issue is, hci_le_add_accept_list_sync() is iterating the lists
when the content is being removed elsewhere.

> Hopefully these lists can not be changed by other threads while
> hci_update_accept_list_sync() is running ?
Probably. Looks like Luiz also thinks the same way.

> Please add a Fixes: tag
Unfortunately I don't know when this is introduced.

> Hmm if this happens it means other threads are actually interfering
> with cmd_sync queue which is something that is probably a bug since
> the whole point of cmd_sync is to serialize the commands making it
> easier to do more complex state updates (such accept+resolve list
> updates)
Thanks, I haven't fully grasped the intention of having hci_sync and
how to properly use it.

> we could perhaps still apply this change as a workaround but
> ultimately I think it would be better to add a mgmt-tester reproducing
> the issue and have a proper fix of the code updating the list from a
> different thread.
Agree. Having said that, I don't think currently I have the time to
invest in writing a test and a proper fix, so my apologies on this.

Best,
Archie
