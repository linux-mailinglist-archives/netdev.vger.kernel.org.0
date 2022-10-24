Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE39609DAA
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiJXJPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiJXJPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:15:07 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6DB2AE03
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:14:53 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id p16so7209788iod.6
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xd1FhIjpEt44j4e2jUoeGLAerGtxdBb6aCfK+qFxkt0=;
        b=QQGvtlUqeSMZvOthD+eEdvFNIXaG7bivfsEyojA4AG654KBD3zfCbW0Vg+aBJVOa59
         wYQisMpEYcLX3g9MHCaiRWqQSfMfE2KWadA1FM50sQa7emn6jtnaYEulI9BKbufQhWlo
         bc6yyVY6KV7b9m2uXbcdSCI/Tj9JGJ4F5I8t8EASEgbeqGFaCWaTxFRX/WMC1cm52hUy
         QT0bCtwMVtDLG0Q0AryB5BnaSvfMwuoTwwMoDl6UBU2+LMygCAaPYrgOPxPp1D83lWUw
         coVUt0GbGf9O8BWYWMKq19yOA4rwhgclrR/o4I3epnR1NPxYDvuchzT6IuKDGqDKjX5U
         qJiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xd1FhIjpEt44j4e2jUoeGLAerGtxdBb6aCfK+qFxkt0=;
        b=nBDVYzPXxJLUJWtr1Ol3xyR2DRj9pUmizMSKlDpMQMRvCOvQReNcyhfmhyxd0HkEyl
         FA/TxqebjHlXsQjAKYWGvv6LcHp0urfc383VLRPFoAS6IYEQC5PHk0h836X7FLQBfxEN
         VjyiobmtzLvvnWzsWrPVXsV/dojC3T1CYIDyPL+QmRAQ1t/c2PfAJagmlBbO5owoyKA1
         g+yXC1N1xAu1Os/qO8XZo1FLyIh3bIBAnrGT0/QIYwbnTx1YYSPwNNatadPMKYc6Hel3
         pGk0nTtRw2bXreKke/0xwN7rI9StabsgxzM+Wsr1+Itz9vRIzSzEqEbScXAwNwMYEp5G
         tIuw==
X-Gm-Message-State: ACrzQf2Pk6uVO9ADpss6mF9lL64u44fyxZylbp3ybIOR1cVVDQQGCTdk
        JL28NkTWtNGgrp5+EqHx61A2atcKAKIyLzu9FBF5VAtVrLJIAHM5qFI=
X-Google-Smtp-Source: AMsMyM54ORnnbCzuQAuYpBKHVojCPqFrcw25qlWEPxfQYnwxQSt98cSP7qwiMb9FOOuckcsGHFArzD1jzxpRxPziG+k=
X-Received: by 2002:a05:6602:2ac9:b0:6bc:17dd:3800 with SMTP id
 m9-20020a0566022ac900b006bc17dd3800mr18638994iov.72.1666602881439; Mon, 24
 Oct 2022 02:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20221014093632.8487-1-hdegoede@redhat.com> <CAHNKnsSvvM3_JEdr1znAWTup-LG-A=cuO8h-A8G6Cwf=h_rjNQ@mail.gmail.com>
 <ea022df4-2baf-48ae-e5ed-85a6242a5774@redhat.com>
In-Reply-To: <ea022df4-2baf-48ae-e5ed-85a6242a5774@redhat.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 24 Oct 2022 13:14:39 +0400
Message-ID: <CAHNKnsSaNuU3xcnRpnP2CM8ycOqomaaeT9Tz40FLJbbKFXgTzw@mail.gmail.com>
Subject: Re: [PATCH] net: wwan: iosm: initialize pc_wwan->if_mutex earlier
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org
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

On Mon, Oct 24, 2022 at 12:04 PM Hans de Goede <hdegoede@redhat.com> wrote:
> On 10/15/22 09:55, Sergey Ryazanov wrote:
>> On Fri, Oct 14, 2022 at 1:36 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>> wwan_register_ops() ends up calls ipc_wwan_newlink() before it returns.
>>>
>>> ipc_wwan_newlink() uses pc_wwan->if_mutex, so we must initialize it
>>> before calling wwan_register_ops(). This fixes the following WARN()
>>> when lock-debugging is enabled:
>>>
>>> [skipped]
>>>
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>
>> Should we add a Fixes: tag for this change? Besides this:
>
> This issue was present already in the driver as originally introduced, so:
>
> Fixes: 2a54f2c77934 ("net: iosm: net driver")
>
> I guess?

The wwan_register_ops() call has been here since the driver
introduction. But at that time, this call did not create any
interfaces. The issue was most probably introduced by my change:

83068395bbfc ("net: iosm: create default link via WWAN core")

after which the wwan_register_ops() call was modified in such a way
that it started calling ipc_wwan_newlink() internally.

-- 
Sergey
