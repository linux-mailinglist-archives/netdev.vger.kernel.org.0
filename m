Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FAB63BB8F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiK2I33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiK2I24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:28:56 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAB16145
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:28:14 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id s12so18732110edd.5
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8tKjN8Pr0TOCEiqcL4ygNjCpgur6Un/XBCsGues/Dnc=;
        b=T1SrL2wtoh+dO1FUeIUSLP7iDrLN8bzK1A6qXgwO/336kstN9A+k8zQvtsa4Ps7sWZ
         LDyBxMYCAHdzL+hZrD/BUTv8MLEMAc+ojkA0zmya4fbKQRX3fzaJMvVwNJx7qj+InDrw
         3M0sbE/cn5Q3keMw7bLCRWZB5H/SYiwLWnB7V4VU+Fva5Jr2Ekb0eyaIz51iyfM+zShx
         nHHoTMFv7Co37+xH5MYBN+5wHA/vc7Bn1C8UTFT0oQKByuSxmrZNr+FLyFdSyHoVNUIv
         bcRupknoJs0MQ1N+ppVjc04sl7IbMfDV7CVTbsoepTc2QAYV0rXsJv31xujUc7bTu4xW
         XwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8tKjN8Pr0TOCEiqcL4ygNjCpgur6Un/XBCsGues/Dnc=;
        b=StCtikeoR5LV73udIEvOc7PhT2yZUWBgO302cDAIAVBo4B9RGwxLZWPevl5oQuwEfV
         YXHWChLcqN0be8yVIq596czztUn7YuV0gpXnNa4E59sAzydNfE3uRsZsJxMcaC1V9U4D
         GZfSKwC2FFp3J+/tXHP7X0u6nTMNK9PUEd4TBOsLYrLmPmTjFsQlJkGzC9S9L5KEhDWe
         EGiAyCxlBN+Z0P4cqgTPWguJDIWdyHx6hR04EaYwxkqNxfRbML6dU8EsIMET2v0EC9zV
         NOCeJjJXqOwnOII3N1+M9Yf5Lq9T+kMNyu4TcVggAM1iABMryeVankmjkd/nYbitTFxk
         29lQ==
X-Gm-Message-State: ANoB5plsV4a5PMAHORMthNXJgXd2mCIuCcZtPa+SDbV99dax4Eio5RCb
        AB4nvsE1D3e4Yoo5KyGcYRDy2w==
X-Google-Smtp-Source: AA0mqf7JGE37tAeUkHP3TD4s8FZGd1nRjeRWiVNzSS6CLCo1ROKQ6oloPpK3fYxFvXVscdfHwnEgTg==
X-Received: by 2002:a05:6402:550b:b0:45f:9526:e35a with SMTP id fi11-20020a056402550b00b0045f9526e35amr51424330edb.256.1669710493806;
        Tue, 29 Nov 2022 00:28:13 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id c7-20020a50f607000000b00461e4498666sm6060540edn.11.2022.11.29.00.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 00:28:13 -0800 (PST)
Date:   Tue, 29 Nov 2022 09:28:12 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: devlink: add
 DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER
Message-ID: <Y4XCnAA2hGvqgXh0@nanopsycho>
References: <20221129031406.3849872-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129031406.3849872-1-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 29, 2022 at 04:14:06AM CET, mailhol.vincent@wanadoo.fr wrote:
>As discussed in [1], abbreviating the bootloader to "bl" might not be
>well understood. Instead, a bootloader technically being a firmware,
>name it "fw.bootloader".
>
>Add a new macro to devlink.h to formalize this new info attribute name
>and update the documentation.
>
>[1] https://lore.kernel.org/netdev/20221128142723.2f826d20@kernel.org/
>
>Suggested-by: Jakub Kicinski <kuba@kernel.org>
>Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>---
>* Changelog *
>
>v1 -> v2:
>
>  * update the documentation as well.
>  Link: https://lore.kernel.org/netdev/20221129020151.3842613-1-mailhol.vincent@wanadoo.fr/
>---
> Documentation/networking/devlink/devlink-info.rst | 5 +++++
> include/net/devlink.h                             | 2 ++
> 2 files changed, 7 insertions(+)
>
>diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
>index 7572bf6de5c1..1242b0e6826b 100644
>--- a/Documentation/networking/devlink/devlink-info.rst
>+++ b/Documentation/networking/devlink/devlink-info.rst
>@@ -198,6 +198,11 @@ fw.bundle_id
> 
> Unique identifier of the entire firmware bundle.
> 
>+fw.bootloader
>+-------------
>+
>+Version of the bootloader.
>+
> Future work
> ===========
> 
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 074a79b8933f..2f552b90b5c6 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -621,6 +621,8 @@ enum devlink_param_generic_id {
> #define DEVLINK_INFO_VERSION_GENERIC_FW_ROCE	"fw.roce"
> /* Firmware bundle identifier */
> #define DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID	"fw.bundle_id"
>+/* Bootloader */
>+#define DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER	"fw.bootloader"

You add it and don't use it. You should add only what you use.
