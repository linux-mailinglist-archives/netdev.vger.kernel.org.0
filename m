Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750465A0300
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 22:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240535AbiHXUuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 16:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240515AbiHXUun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 16:50:43 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154DB726AD
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 13:50:42 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id o204so13311341oia.12
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 13:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=KduZjIEyBxkzWgXFN93eLdrigURNo60WLuJ3gbVZ7XY=;
        b=HzD4lZ/6vc6C1WbqLgNeBjsTawvUPrh+Xj9kvCaukUs4HQ4qPkl3iXv/4oz9z8HwXo
         ECVxp5rH4cZomOeGqhdJQD8ko317eSJ1CyxlRlohPXJiVaA5x1hshUDuqSdO4cmtUGMW
         CNqIz6REQRw99lwDp8gd7kPHARUS2DCtzdD4A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=KduZjIEyBxkzWgXFN93eLdrigURNo60WLuJ3gbVZ7XY=;
        b=WhfHXSk20QekwKxaDJXhqa7qg/l7fEW1vTrRj9cR8YFz/5V5AUNRmGFIiERk7bcpKe
         deyIL74AOQrigJCada2wB4ZVc8sPX9QQUG8je3e7+ehd7qB/dGeZ+51nvr3egPFg9YzN
         VAQr29P5W23uqPXMOB5YZxYv8MRdmrw46ByjpqsFdt11SR8ln6b+zQJt838xSGriHtL0
         ies7qSgUGUnL492vNGXEo/+Z5mqD5mMSSFuRaMKbmup92pZwFuVUdYQOJL/jCF4peJAQ
         af1r5PzCNSkkRpQBNi+5xP/n6jo7K79tCdpsDmLc77ZtkCY+7qD5okNQiIiB1PhFvPCC
         lyvA==
X-Gm-Message-State: ACgBeo0QANayT2ziPSdYRQ8z3WhBmT68ADXtNz6DWUIr+rQVX+8WgcMh
        fMq+id1DeIcnsFHszalML9GxJEOdjB59bg==
X-Google-Smtp-Source: AA6agR5Ba7oWnxjbv6H5iROmrBXraYhLnI2rgIcvwVAfA0X5l12n4lNhk8mZSl0mmQ+O2Ew611GnPw==
X-Received: by 2002:a05:6808:220c:b0:344:d71f:6a0c with SMTP id bd12-20020a056808220c00b00344d71f6a0cmr384043oib.153.1661374241134;
        Wed, 24 Aug 2022 13:50:41 -0700 (PDT)
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com. [209.85.160.53])
        by smtp.gmail.com with ESMTPSA id q2-20020a4ad542000000b00448aff53822sm4075966oos.40.2022.08.24.13.50.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 13:50:40 -0700 (PDT)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-11c5505dba2so22352999fac.13
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 13:50:40 -0700 (PDT)
X-Received: by 2002:a05:6808:23c4:b0:344:e426:d2a7 with SMTP id
 bq4-20020a05680823c400b00344e426d2a7mr4087711oib.232.1661373740120; Wed, 24
 Aug 2022 13:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1661252818.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1661252818.git.duoming@zju.edu.cn>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 24 Aug 2022 13:42:09 -0700
X-Gmail-Original-Message-ID: <CA+ASDXNf5JV9mj8mbm1OGZ_zd4d8srFc=E++Amg4MoQjqjS_TA@mail.gmail.com>
Message-ID: <CA+ASDXNf5JV9mj8mbm1OGZ_zd4d8srFc=E++Amg4MoQjqjS_TA@mail.gmail.com>
Subject: Re: [PATCH v8 0/2] Add new APIs of devcoredump and fix bugs
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        amit karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, kvalo@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 4:21 AM Duoming Zhou <duoming@zju.edu.cn> wrote:
>
> The first patch adds new APIs to support migration of users
> from old device coredump related APIs.
>
> The second patch fix sleep in atomic context bugs of mwifiex
> caused by dev_coredumpv().
>
> Duoming Zhou (2):
>   devcoredump: add new APIs to support migration of users from old
>     device coredump related APIs
>   mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv

I would have expected a third patch in here, that actually converts
existing users. Then in the following release cycle, clean up any new
users of the old API that pop up in the meantime and drop the old API.

But I'll defer to the people who would actually be merging your code.
Technically it could also work to simply provide the API this cycle,
and convert everyone in the next.

Brian
