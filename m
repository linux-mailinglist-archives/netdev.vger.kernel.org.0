Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D81640EE3
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbiLBUJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLBUJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:09:51 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ABF9E465
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:09:50 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 140so5890954pfz.6
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 12:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QmCmtpYXBuPrWXrEbISl4aha3l2WdlVO+0XKm5l4FME=;
        b=bubaefnjR554rom5A9gIzr05eqJjveaLQ88lZbcHVdHQ3G8euqpRFrqRdGGpZLJmZ5
         3Uzt8inPJkn3npXZmwGu1yXBk/Y2WzphOgH284HJMQN638pdEL96pwY3Sxla3CafJpbF
         uobnVL6vTMAaggQvz9Ok6sVMxGhqPrtpHlz79z528rVlBOtCYikXPPikRIIhc49NHIx3
         6pKcaIOfJpuDY22oQtDm+vAC5Avb2dqRQFl9OrAugj5JHipohfD7hxGjcE8skI1r/mly
         2NLI3Pnf1PzWs41xokyrmZwURSmUM1JZnKfwqrhpackHOBEJyDIOOV5NA+/1o3NAsrEq
         jGbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QmCmtpYXBuPrWXrEbISl4aha3l2WdlVO+0XKm5l4FME=;
        b=T0KVIE6ZfMHO5zFge2dEs6krZWVNsA1TOMTmX6v/RTnaTuUy7+MveEjnvHZv41L2xw
         gMFhGhQzeL30Nz+4m3BHLMSdr50SYwozdjOdpgBC5+BIN8tBtdrCScCMIZ03RvcpdEvI
         jbeB7SqNniWHicgo5LxiZd/FnMm/rIGVip3fKSdEy6ajU0nmROupTRu81xUCI2DP3Szx
         MCWlPsl3xjSm029L/3u6pg/ug2aHOUlf14xhwNb3FvT1gjtQl0hz8hJCIkRAj2JynYaP
         /uYoQ52yCrrWG/gnikrdmARiH7uJmbuMATVU3e8YhizYfjR00bly8NoNeg9tlxMKLE/x
         IbzA==
X-Gm-Message-State: ANoB5pmg/nz2sVruzXQrVg1Ccp2T9MmVvvkl8J/gj0EdQvl/c52KABOm
        fuTf30YAT5xOKWRpvrokCMIu1fw9GlB7OiN53s37faCm6Rw=
X-Google-Smtp-Source: AA0mqf5C3oO19BPId1sVdFP0SARaJpy3L1LQoxXhmEpNrrBYwWaUJweBN4GKnXgcIbmNk6i5V4Wl5gKYAD70+rvAhIw=
X-Received: by 2002:a63:ed4b:0:b0:477:786:b22b with SMTP id
 m11-20020a63ed4b000000b004770786b22bmr49401060pgk.195.1670011789900; Fri, 02
 Dec 2022 12:09:49 -0800 (PST)
MIME-Version: 1.0
References: <e0f9fb60-b09c-30ad-0670-aa77cc3b2e12@gmail.com> <20221202103429.1887d586@kernel.org>
In-Reply-To: <20221202103429.1887d586@kernel.org>
From:   Etienne Champetier <champetier.etienne@gmail.com>
Date:   Fri, 2 Dec 2022 15:09:13 -0500
Message-ID: <CAOdf3goC0eXSqdpdcq_-4wegMTBmYdK_uQOKUpjX7azvTamWDA@mail.gmail.com>
Subject: Re: Multicast packet reordering
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le ven. 2 d=C3=A9c. 2022 =C3=A0 13:34, Jakub Kicinski <kuba@kernel.org> a =
=C3=A9crit :
>
> On Thu, 1 Dec 2022 23:45:53 -0500 Etienne Champetier wrote:
> > Using RPS fixes the issue, but to make it short:
> > - Is it expect to have multicast packet reordering when just tuning buf=
fer sizes ?
> > - Does it make sense to use RPS to fix this issue / anything else / bet=
ter ?
> > - In the case of 2 containers talking using veth + bridge, is it better=
 to keep 1 queue
> > and set rps_cpus to all cpus, or some more complex tuning like 1 queue =
per cpu + rps on 1 cpu only ?
>
> Yes, there are per-cpu queues in various places to help scaling,
> if you don't pin the sender to one CPU and it gets moved you can
> understandably get reordering w/ UDP (both on lo and veth).

Is enabling RPS a workaround that will continue to work in the long term,
or it just fixes this reordering "by accident" ?

And I guess pinning the sender to one CPU is also important when
sending via a real NIC,
not only moving packets internally ?

> As Andrew said that's considered acceptable.
> Unfortunately it's one of those cases where we need to relax
> the requirements / stray from the ideal world if we want parallel
> processing to not suck..
