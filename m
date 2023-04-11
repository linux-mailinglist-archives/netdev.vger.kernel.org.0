Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DFD6DE011
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjDKPyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjDKPyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:54:21 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49E84EF4
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:54:04 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id z9so8657266ybs.9
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681228442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YmY3XxKBoee5tSNEufHpb+asjhgZIf113BOS8btoaPc=;
        b=Zh33INvPZp9iyg9CDhs8zUoauAqxXwHtXpFr5TXKaH4f+8y8Gn/6GBcQaoqaCvnimw
         CCqn9wg6yy9Y3EddvV2geHdQh8n+VuLk12wbtQWc7TrM0KzIU1jLkbktFXrvY3JzMb7x
         cJ/TlDlI8pnWrfO+7tiol6Px1f1zbUdlx2p8RU27PngGHw4XlPo4UdIahsdIkYsJJk85
         OaLiuQ92QsYA8nlYwU80VEFtbySJT7hw99ditAo4ZpdOETrVJuMbqRmUS7XVrkf/+NV+
         gDg19OPcr9QFAj49HIdHjWpwRLrTipkUlIzX78yA2f1EvBAmjKYCdH6or8fYnZrGsflQ
         BP8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681228442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YmY3XxKBoee5tSNEufHpb+asjhgZIf113BOS8btoaPc=;
        b=lYlS08/9zaqxY39Aohf6VKvHzumRfow+wdD19NHpXdUeXPUEeo4dyYMnjR19ecohx7
         vQZ4SwIEWLaJKI/HVmeXCd4UCl7tfRapmlFY1ML4Hnzlo9M0PS1NTODLeHrlXCobSHPV
         XUvPhHwK+725M23G6KMqFAhEhxA+9YvGPyc2ompPEoupwFPDMAhq5zp7cmSuMANlBnID
         7CuN7oOyB4D+/C5JhzpyuJ4EhHzYErkKsOzTzT5zyid5TJ5vINkmNHJrM1nRA4LZUJar
         ZypmtvEFfSMFCKOCAsxEfxLYNfr425uQG0O5mVb+HL7n48SmejhfUZwrH6ZG5ioDTp5A
         GUQg==
X-Gm-Message-State: AAQBX9dAA9wwv/mWRkFLmGtuO8qIT2yNIlz8i/+B1V8DfRkr4wSF4EBW
        EoqjwO+vxFpW38Qjd3ffV150vTDnNRRwlObaXzTOUg==
X-Google-Smtp-Source: AKy350YW/wFikWR9+O33jhcnWG/upvdhlWDZoq5gMcq8OnFQ8HvvtnDnkEXuFIbBAWqIXfPYBa7NB262Bj+vSmK9Y9s=
X-Received: by 2002:a25:cac5:0:b0:b8e:d126:c64 with SMTP id
 a188-20020a25cac5000000b00b8ed1260c64mr1912334ybg.4.1681228442267; Tue, 11
 Apr 2023 08:54:02 -0700 (PDT)
MIME-Version: 1.0
References: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk> <ZDWB1zRNlxpTN1IK@shell.armlinux.org.uk>
In-Reply-To: <ZDWB1zRNlxpTN1IK@shell.armlinux.org.uk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 11 Apr 2023 17:53:51 +0200
Message-ID: <CANn89iL5sktWMfVMyBeUH4Mcef0ye-D7tno+HGvA-KF2md+NDQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/6] net: mvneta: reduce size of TSO header allocation
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 5:50=E2=80=AFPM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> Hi,
>
> I think the Turris folk are waiting for me to get this into the kernel
> and backported to stable before they merge it into their tree and we
> therefore end up with it being tested.
>
> We are now at -rc7, and this series is in danger of missing the
> upcoming merge window.
>
> So, I think it's time that I posted a wake-up call here to say that no,
> that's not going to happen until such time that we know whether these
> patches solve the problem that they identified. I'm not bunging patches
> into the kernel for problems people have without those people testing
> the proposed changes.
>
> I think if the Turris folk want to engage with mainline for assistance
> in resolving issues, they need to do their part and find a way to
> provide kernels to test out proposed fixes for their problems.
>

Just make sure to repost the series without the RFC tag :)

Thanks.
