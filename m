Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F3B5A5908
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 03:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiH3BwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 21:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiH3BwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 21:52:00 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E18F7EFE2
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 18:51:58 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id d15so5480866ilf.0
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 18:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=OLoKGGbh/JXeM0SVwteu/gfmp4MB1YxZQxWOdD1dZV0=;
        b=lg6tdBeJvULT/wbDLC/7iipvm+OZp/DsvtATbiLCXFBRALktRXR7nq+gr1xyqMOJXh
         lp/zAZFIdDHtUiwl65S/Mv/kVSmo69cQz6G44TnTgoku702kmSo36oPDvDMAkPgLnMbK
         1dPAppSHBKKWuDKOrs3sW15aDb9TfFQg4XbiMT5H8dQdYo6d4yt3M8BJduGe3B0kXBcM
         EoI2+9q6VcOB7xYqGviwPuo6cHRFxhU28gCKEgOmZgJmeE4XRv+jjZGYg0YjVMvxlDS/
         br+iZdscYbRxRZCy8Vs3uq8hYM1I05Oai8pClBUZhvs2qQFnkSDTjRE6/c1SXo8Qhte2
         t6Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=OLoKGGbh/JXeM0SVwteu/gfmp4MB1YxZQxWOdD1dZV0=;
        b=TZJOZD/5a5q9kBWOetwdL6jUpI4M4H3YyJasZ/71eEFqEbk2on82VqRe1YtxYYzP0F
         tu3gP/0IAy4Ehmziy8rZGSPZNZwDeqkIgWyanysbCyZ5ltsG4DG3PoAbsFr190N/VS7S
         f3tXCnnW6EzRyEcotXJ12WylS4n/0HUn/fa2Nv/UFXGV5+iODIJ2qbcR7tXPKgv/Tn+o
         Bxn/lYmU4jG1Aj7ZqlU6iJcmhvVK5iMSlMVJdnC1tmwymqPf79hlr6n7Q34kr8OC3cjC
         nQCZ4jXr0GYGEBPbEBSGl1X9RckVYMyguM40i5byla8VADA9hySntUIzkUOxlH9JbzeN
         snqg==
X-Gm-Message-State: ACgBeo2vStOlIrwwtYWBCqntkiouKy2OZsLhB35bCUegElb42l1sVyAU
        V3bgU8kMLbam+QWTA9HchDkYU4kN7Mmr0P8AsGg=
X-Google-Smtp-Source: AA6agR4CqgQeAxhYKapGYWtBzlHvxWLufTrQttGINTTYm7Jf9p8VFEOvLUru+yum4GwPwYnolKMpXixeKS7R4sk9otA=
X-Received: by 2002:a05:6e02:15c9:b0:2da:c33e:49c7 with SMTP id
 q9-20020a056e0215c900b002dac33e49c7mr10776711ilu.26.1661824317750; Mon, 29
 Aug 2022 18:51:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220816042301.2416911-1-m.chetan.kumar@intel.com>
In-Reply-To: <20220816042301.2416911-1-m.chetan.kumar@intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 30 Aug 2022 04:51:43 +0300
Message-ID: <CAHNKnsRWBUFL=ETFu8M3A+-6bocxg18Ny1bWY78+44J70PvM6Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] net: wwan: t7xx: fw flashing & coredump support
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, Aug 16, 2022 at 7:11 AM <m.chetan.kumar@intel.com> wrote:
> This patch series brings-in the support for FM350 wwan device firmware
> flashing & coredump collection using devlink interface.
>
> Below is the high level description of individual patches.
> Refer to individual patch commit message for details.
>
> PATCH1:  Enables AP CLDMA communication for firmware flashing &
> coredump collection.
>
> PATCH2: Enables the infrastructure & queue configuration required
> for early ports enumeration.
>
> PATCH3: Implements device reset and rescan logic required to enter
> or exit fastboot mode.
>
> PATCH4: Implements devlink interface & uses the fastboot protocol for
> fw flashing and coredump collection.
>
> PATCH5: t7xx devlink commands documentation.

Generally the code looks good to me, but needs some cleanup. It also
has a couple of questionable parts:
* implicit fastboot mode entering;
* PCI device reset handling approach.

Please find comments in the corresponding patches.

-- 
Sergey
