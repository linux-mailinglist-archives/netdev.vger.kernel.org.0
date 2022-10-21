Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2502B60821A
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 01:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJUXiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 19:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJUXiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 19:38:05 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9ED434705
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 16:38:03 -0700 (PDT)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id AA932412E5
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 23:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1666395480;
        bh=pn941OvGFxDKPACrQ8rKzh4x6uwFhSh6MF8WKrhH73c=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=EEn6sMCqfwSbIA4rq6wW7qsWrf3jF0PngrUqnzrZ3hWXaawJDyetNJ6fQx3nHZALS
         EWD0m203JStGgPUZTxXobNbnhbyxcr7RusdJUz5rgoE9jF888Ds1u0IR0tVvza6f9S
         wFq6yVZoYwzAoT+YpL9S54rjw5qsSY/9T4htDvcAuLklysL2DOZb5o9Xv74eKkotba
         NIKaB1Rl7sr0thEdUc7WMJcr90W7H75hrxEW6I669KwcjIDkKdv0Nqoo3v9tgtgojn
         jyrukoT/EKBn5V8zm0xtoms2Pfz2iTefOqVG1rqRkrx4AgrFfJVgAt4PXfEs9GB7EY
         OQXn+ESXfg1RA==
Received: by mail-pj1-f72.google.com with SMTP id il7-20020a17090b164700b0020d1029ceaaso4889438pjb.8
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 16:38:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pn941OvGFxDKPACrQ8rKzh4x6uwFhSh6MF8WKrhH73c=;
        b=Q8D/E2e+wDwo/RAN8BQZw0kLwcnNQa6xVtsDQsyor4YJXfLufu301Yvr8cZoKXVQ2Q
         q6HxPo7qxr4RJdkHoYQtUkHCtryTRr6htk3FDZ6VEBwdB07zQyEuwHCVO178sGpzr/6p
         i+grt01SdCCSfrQ+w7t4hAna8TfeShxlG8JU5NCKTyE3PVpxddCwogFHuWNO7bmFgedL
         NYVJQTBXAj9dhKDyRB7ZJVNN0N5znKorSIENk6JWVAFyt05MgDIir/d7Pf8b7mlVPvnQ
         PWFEeCph9D0GKeBJsadAJtwTK8tEBmLwhW9Zcha1Gos3xuVvFebq/z0Hp4CFSq70H729
         kO7g==
X-Gm-Message-State: ACrzQf1h7tKVEvsrbUnckb+ClXKv5ujrto9V8PqbhXcJRxOmzXFfaL0A
        STVFdCrf3/c7L6X6Q2Cbo+YHJFoNF2K1XTOcBRKKhGRzbcH3tWEcoYA1MZSCvqp/xncP351bfFp
        sSxrOnj+zc9pfqBqX6phJf0EBguBxy4WZRg==
X-Received: by 2002:a17:90b:17cf:b0:20d:b274:6f50 with SMTP id me15-20020a17090b17cf00b0020db2746f50mr51158526pjb.231.1666395479106;
        Fri, 21 Oct 2022 16:37:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6RO5rX/ffUKSV2DVbgE3480NCI8atDwsJBo/AGKUQk9T6sAO+ZTOjkgRBT+KETrRSjv4YD5g==
X-Received: by 2002:a17:90b:17cf:b0:20d:b274:6f50 with SMTP id me15-20020a17090b17cf00b0020db2746f50mr51158509pjb.231.1666395478840;
        Fri, 21 Oct 2022 16:37:58 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id l8-20020a170903120800b0016c09a0ef87sm15609809plh.255.2022.10.21.16.37.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Oct 2022 16:37:58 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id B1CF360DBF; Fri, 21 Oct 2022 16:37:57 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id AA0A8A06A7;
        Fri, 21 Oct 2022 16:37:57 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Petr Machata <petrm@nvidia.com>
cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        David Ahern <dsahern@kernel.org>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 3/3] bonding: 3ad: Add support for 800G speed
In-reply-to: <9684b0698215ae746447b2d8b4fd983ad283ce0a.1666277135.git.petrm@nvidia.com>
References: <cover.1666277135.git.petrm@nvidia.com> <9684b0698215ae746447b2d8b4fd983ad283ce0a.1666277135.git.petrm@nvidia.com>
Comments: In-reply-to Petr Machata <petrm@nvidia.com>
   message dated "Thu, 20 Oct 2022 17:20:05 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16040.1666395477.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 21 Oct 2022 16:37:57 -0700
Message-ID: <16041.1666395477@famine>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr Machata <petrm@nvidia.com> wrote:

>From: Amit Cohen <amcohen@nvidia.com>
>
>Add support for 800Gbps speed to allow using 3ad mode with 800G devices.
>
>Signed-off-by: Amit Cohen <amcohen@nvidia.com>
>Reviewed-by: Ido Schimmel <idosch@nvidia.com>
>Signed-off-by: Petr Machata <petrm@nvidia.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


>---
> drivers/net/bonding/bond_3ad.c | 9 +++++++++
> 1 file changed, 9 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3a=
d.c
>index e58a1e0cadd2..455b555275f1 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -75,6 +75,7 @@ enum ad_link_speed_type {
> 	AD_LINK_SPEED_100000MBPS,
> 	AD_LINK_SPEED_200000MBPS,
> 	AD_LINK_SPEED_400000MBPS,
>+	AD_LINK_SPEED_800000MBPS,
> };
> =

> /* compare MAC addresses */
>@@ -251,6 +252,7 @@ static inline int __check_agg_selection_timer(struct =
port *port)
>  *     %AD_LINK_SPEED_100000MBPS
>  *     %AD_LINK_SPEED_200000MBPS
>  *     %AD_LINK_SPEED_400000MBPS
>+ *     %AD_LINK_SPEED_800000MBPS
>  */
> static u16 __get_link_speed(struct port *port)
> {
>@@ -326,6 +328,10 @@ static u16 __get_link_speed(struct port *port)
> 			speed =3D AD_LINK_SPEED_400000MBPS;
> 			break;
> =

>+		case SPEED_800000:
>+			speed =3D AD_LINK_SPEED_800000MBPS;
>+			break;
>+
> 		default:
> 			/* unknown speed value from ethtool. shouldn't happen */
> 			if (slave->speed !=3D SPEED_UNKNOWN)
>@@ -753,6 +759,9 @@ static u32 __get_agg_bandwidth(struct aggregator *agg=
regator)
> 		case AD_LINK_SPEED_400000MBPS:
> 			bandwidth =3D nports * 400000;
> 			break;
>+		case AD_LINK_SPEED_800000MBPS:
>+			bandwidth =3D nports * 800000;
>+			break;
> 		default:
> 			bandwidth =3D 0; /* to silence the compiler */
> 		}
>-- =

>2.35.3
>
