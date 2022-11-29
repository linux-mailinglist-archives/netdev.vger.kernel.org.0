Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E62263BCEC
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbiK2J3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiK2J25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:28:57 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485B043AE0;
        Tue, 29 Nov 2022 01:28:56 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id g10so12821778plo.11;
        Tue, 29 Nov 2022 01:28:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mWAyxGnGfDBWOO/6cOO40LHqAdd4xJd4z4/3HDguLVQ=;
        b=YHQJvVxPLxmXddoiEuOPQWqn2Ormx76iPImrHMmEg9fQW+ogdRR4srDwZaDG7MXZzf
         dX60ZM/Eu35ZW6QG6vehtwtYHqRae9X+XjPoqsq3UKVC3akeANw+ij2PZN/JLNUN5uXU
         pQevwQDVnbB2dawcZvaGv5omTYlf0wbuz0ujCWLASPv+Okgeu0m+F91YlU9o6LYsbHmx
         yYXZ/cPKC7wVoXWIeWgvqqcJuBtHFme4banpd1ntsYsG5x0ktrIJ9BwGz7oe/IkuX2kg
         vrOlFE5efJabLcoM99A5gnCMzOuQtvyGGGcg2NiB38BITMUXgyjRBQZnEW99tnWZr9OT
         J5dA==
X-Gm-Message-State: ANoB5pmxM+F3fas6wyB49ZdPNd4WXNZeuY1Cf5wyHaG8WpHudXeG3tVD
        zyspc8Y53jCXAtLYhfmbIJ2xPPSq+CpyH8M/fRw=
X-Google-Smtp-Source: AA0mqf620ASVhJcH9VzlQ/gUV/fbrctcX+o6Wio404xHTF++V3JgVh8khWNcKxYRhxiCYTFGN2t+UN8XXV9d2DTbDjQ=
X-Received: by 2002:a17:90a:77cc:b0:219:1747:f19c with SMTP id
 e12-20020a17090a77cc00b002191747f19cmr17832727pjs.222.1669714135683; Tue, 29
 Nov 2022 01:28:55 -0800 (PST)
MIME-Version: 1.0
References: <20221129031406.3849872-1-mailhol.vincent@wanadoo.fr> <Y4XCnAA2hGvqgXh0@nanopsycho>
In-Reply-To: <Y4XCnAA2hGvqgXh0@nanopsycho>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 29 Nov 2022 18:28:44 +0900
Message-ID: <CAMZ6RqJ54rfLfODB1JNaFr_pxWxzHJBoC2UmCKAZ7mSkEbcdzQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: devlink: add DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 29 Nov. 2022 at 17:33, Jiri Pirko <jiri@resnulli.us> wrote:
> Tue, Nov 29, 2022 at 04:14:06AM CET, mailhol.vincent@wanadoo.fr wrote:
> >As discussed in [1], abbreviating the bootloader to "bl" might not be
> >well understood. Instead, a bootloader technically being a firmware,
> >name it "fw.bootloader".
> >
> >Add a new macro to devlink.h to formalize this new info attribute name
> >and update the documentation.
> >
> >[1] https://lore.kernel.org/netdev/20221128142723.2f826d20@kernel.org/
> >
> >Suggested-by: Jakub Kicinski <kuba@kernel.org>
> >Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> >---
> >* Changelog *
> >
> >v1 -> v2:
> >
> >  * update the documentation as well.
> >  Link: https://lore.kernel.org/netdev/20221129020151.3842613-1-mailhol.vincent@wanadoo.fr/
> >---
> > Documentation/networking/devlink/devlink-info.rst | 5 +++++
> > include/net/devlink.h                             | 2 ++
> > 2 files changed, 7 insertions(+)
> >
> >diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
> >index 7572bf6de5c1..1242b0e6826b 100644
> >--- a/Documentation/networking/devlink/devlink-info.rst
> >+++ b/Documentation/networking/devlink/devlink-info.rst
> >@@ -198,6 +198,11 @@ fw.bundle_id
> >
> > Unique identifier of the entire firmware bundle.
> >
> >+fw.bootloader
> >+-------------
> >+
> >+Version of the bootloader.
> >+
> > Future work
> > ===========
> >
> >diff --git a/include/net/devlink.h b/include/net/devlink.h
> >index 074a79b8933f..2f552b90b5c6 100644
> >--- a/include/net/devlink.h
> >+++ b/include/net/devlink.h
> >@@ -621,6 +621,8 @@ enum devlink_param_generic_id {
> > #define DEVLINK_INFO_VERSION_GENERIC_FW_ROCE  "fw.roce"
> > /* Firmware bundle identifier */
> > #define DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID     "fw.bundle_id"
> >+/* Bootloader */
> >+#define DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER    "fw.bootloader"
>
> You add it and don't use it. You should add only what you use.

I will use it in this series for the linux-can tree:
https://lore.kernel.org/netdev/20221126162211.93322-4-mailhol.vincent@wanadoo.fr/

If it is a problem to send this as a standalone patch, I will then
just add it to my series and have the patch go through the linux-can
tree.


Yours sincerely,
Vincent Mailhol
