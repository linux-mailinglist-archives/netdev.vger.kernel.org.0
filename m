Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0416C55A3FA
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 23:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiFXVw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 17:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiFXVw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 17:52:26 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E3E87B58;
        Fri, 24 Jun 2022 14:52:25 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z7so5186753edm.13;
        Fri, 24 Jun 2022 14:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1vw6jDbAQBJV5McJnm/NPAs3IUSFuM5RtJnklI0XcBw=;
        b=fYes7wtj5Vr+nx/Rmneu8OyzNivPtagsx6buJNAs3bhAT4HCNyExMQbYh8UIKMOCv5
         5o78i8Z3k5t7+w3weCmlwLqhTy/keiZSO/4VN/t781DtudxuAZYzuHlpNuShzSU67VJv
         NFRDtIJzYtDSYKDJPx9MgPs5hao3WTZQscxcXSMXqag5xm4b2YCPSC14ljPkgAaTkqVi
         jyl+RulnirAJinlsogKqQmgd9BWAOTNcsG3eI+jdR4se1ty5ncWFpzGXpH7Cy9a65pbo
         zGQ0vP63ru1N0hQMDSSkHosLdYi3rNGJRaMsjKeqXSGepoYE18KmsmdnkHnW+rfYk4V9
         hkXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1vw6jDbAQBJV5McJnm/NPAs3IUSFuM5RtJnklI0XcBw=;
        b=A6NWutPPg6xKW8Xl6EzDO7pnm+ReUqLhah6298eON6U1Zy4Kx+B+UUVH0eS3VQTOyN
         nxHqppNMP6+IlwxjnB3Q8If+FCFnfunfPMsY9wBkDTDBLMKNYzTVsQuvkte0QwixakcZ
         jBjUGUgTJKKzP0t32zd4V4+shpsDvyTE2VHxf0Qg/i3IJzK23/oPU/NJ5V8DWNKNyFXg
         HBdA/XLEnoGONoxgvrgLTpBmkUAJVD+zA+mI81MBkO0PtWTlJcMusk2NAhXALDs4Xm9n
         j+TNO38uBCkL7QKSGd6gYJOoMva+w4rX53DVSYJc316XXPeO7M66AjiqxJIYm2ZQwuJ/
         UMPw==
X-Gm-Message-State: AJIora/d00NG/ZF+1U80wA1UlzIJjlVu5+4bLFHIDY6UB9y18+Oq4y1P
        HodZtc6oWesxnnCx5gFCOU++Qm/EFjA=
X-Google-Smtp-Source: AGRyM1se8rLU7r7f3UM3P4e90AEPT8lPETUD9v+/FYsOBh9hR9GyP4thUByon/gcN/KtEYRQKlMVzg==
X-Received: by 2002:a05:6402:354b:b0:437:60fd:4891 with SMTP id f11-20020a056402354b00b0043760fd4891mr1554559edd.344.1656107543674;
        Fri, 24 Jun 2022 14:52:23 -0700 (PDT)
Received: from skbuf ([188.27.185.253])
        by smtp.gmail.com with ESMTPSA id d6-20020a170906174600b00715705dd23asm1726474eje.89.2022.06.24.14.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 14:52:22 -0700 (PDT)
Date:   Sat, 25 Jun 2022 00:52:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 3/3] net: dsa: microchip: add pause stats
 support
Message-ID: <20220624215221.irniht2xfxftodfw@skbuf>
References: <20220624125902.4068436-1-o.rempel@pengutronix.de>
 <20220624125902.4068436-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624125902.4068436-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Fri, Jun 24, 2022 at 02:59:02PM +0200, Oleksij Rempel wrote:
> Add support for pause specific stats.
> 
> Tested on ksz9477.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

This conflicts with Arun's work:

Applying: net: dsa: add get_pause_stats support
Applying: net: dsa: ar9331: add support for pause stats
Applying: net: dsa: microchip: add pause stats support
Using index info to reconstruct a base tree...
M       drivers/net/dsa/microchip/ksz9477.c
M       drivers/net/dsa/microchip/ksz_common.c
M       drivers/net/dsa/microchip/ksz_common.h
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/dsa/microchip/ksz_common.h
CONFLICT (content): Merge conflict in drivers/net/dsa/microchip/ksz_common.h
Auto-merging drivers/net/dsa/microchip/ksz_common.c
CONFLICT (content): Merge conflict in drivers/net/dsa/microchip/ksz_common.c
Auto-merging drivers/net/dsa/microchip/ksz9477.c
CONFLICT (content): Merge conflict in drivers/net/dsa/microchip/ksz9477.c
error: Failed to merge in the changes.
Patch failed at 0003 net: dsa: microchip: add pause stats support
