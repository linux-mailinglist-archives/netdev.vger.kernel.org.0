Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C784D63B88E
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 04:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbiK2DJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 22:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235190AbiK2DJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 22:09:01 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6F52250E;
        Mon, 28 Nov 2022 19:09:00 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id j12so12116480plj.5;
        Mon, 28 Nov 2022 19:09:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OnP/cSsNFQTbxkXyddPmxzdhH2J+Sh0TrPclLTaIN1o=;
        b=Kp6oOV0+Fb66gIi2MEsxZj4jd7/4H6pzvrjoUV+nlzjXl2++bcFcmfM9LncM5ucsl9
         /aKafVODTaR+KpJMxf4aGQo3kWAHX2jd2mvRzapVkFGNvY9+QA+fbAa9U2ZV5OymGeZP
         nVV29+NenF0sC6xXhssNDeCssTHUEIx3e60V2l/4Or/C/iSq/HLv0XvL1K56WFkZcAY8
         1j3WTB8LlRfX86UdBFy0WDyeD5uz+PJ1Gu9mcP0bla7X5dX8PtKLeMvUpF9oQ8zl2aq5
         +mV/wJX/dEr+J51X1xaPb6Zf8DQdki32YBLvnURb2MdME3iJr2QWTsN4AuUUPQTF6BSO
         T6CQ==
X-Gm-Message-State: ANoB5pmWPOx/AqksqiWOCcUv8/cb/5p8DUEU+cN6wNVWb6/sQ+zhy1LF
        DkweaqTMvFhc5TYmO/hdXG1MRmXhxk7AmTbrBeo=
X-Google-Smtp-Source: AA0mqf4jlAYwTXYUbXwME9TCX9WQ3MTWK6Ln45diYwf5FNplHSOA8XpCrhE2AlTtp8PQi+7H7V55SJuzwp+w4UDrA2I=
X-Received: by 2002:a17:90a:8a07:b0:20a:c032:da66 with SMTP id
 w7-20020a17090a8a0700b0020ac032da66mr62123468pjn.19.1669691340166; Mon, 28
 Nov 2022 19:09:00 -0800 (PST)
MIME-Version: 1.0
References: <20221129020151.3842613-1-mailhol.vincent@wanadoo.fr> <20221128181430.2390b238@kernel.org>
In-Reply-To: <20221128181430.2390b238@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 29 Nov 2022 12:08:49 +0900
Message-ID: <CAMZ6RqLQe41eHuZNLZEP93ER-xvfKzK9V8EV1zXfmyKaf_a0aQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: devlink: add DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+CC: Marc and linux-can mailing list.

On Tue. 29 Nov. 2022 at 11:14, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 29 Nov 2022 11:01:51 +0900 Vincent Mailhol wrote:
> > As discussed in [1], abbreviating the bootloader to "bl" might not be
> > well understood. Instead, a bootloader technically being a firmware,
> > name it "fw.bootloader".
> >
> > Add a new macro to devlink.h to formalize this new info attribute
> > name.
> >
> > [1] https://lore.kernel.org/netdev/20221128142723.2f826d20@kernel.org/
> >
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>
> It's okay for this patch to go via the can tree, FWIW.
> It may cause an extra delay for you if you have to wait
> for the define to propagate.

Marc always pulls from net-next before picking patches and it is a
common practice to send to the linux-can mailing list some series
which are based on net-next. So I do not foresee any major delay.

> Either way you should document the meaning of the parameter,
> however obvious it may seem:
>
>  Documentation/networking/devlink/devlink-info.rst

ACK.

I will send the v2 with both the netdev and the linux-can mailing
list. I am fine whoever picks it.
