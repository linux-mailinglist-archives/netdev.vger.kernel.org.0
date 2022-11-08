Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60060621B62
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 19:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbiKHSCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 13:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234473AbiKHSCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 13:02:10 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE62E5654A
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 10:02:08 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id s4so9102426qtx.6
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 10:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P0Vrqb0dV10ZcDKDMyGy8PmlBFfLVXxuYtbQVL//Jq0=;
        b=5m4zQpr7pvvBisJk52ZcXiS7iceaQyBjJq4K1ZygUmcjudl74qEXu+WlE0WagbOVgh
         le1LtiT0xTvcc1YUvxmUcvxYS4K4ocQLV01A+WtNUoqfHQE+Zno+h2XCQDT4ybc8AVl7
         qtbvjGo2ZzO52aS+yaNu2vEKXTX+RWN7FYxC/kXa4FjNXfrlL+/F22Lixve/lqMiohRf
         Ok5ZL8E7gpozkChiriUTC1adI38mXus30k3ykmyEM35hjnYoc6adziJdWS7S2ziqA9VM
         WzS2te2ucIkO1aOcMzhT3MHC09x6XoPlrdBK0wPoFHpMqAUDAKK44ySyGuskRg+Nosjs
         rETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P0Vrqb0dV10ZcDKDMyGy8PmlBFfLVXxuYtbQVL//Jq0=;
        b=2bIiYIhTN9NSlEoFCav8mNplTgdHvfm0Vd2MTJrZ4uHUNvdP17QgAV10NsGquDYl1T
         YGOq+lexYFiBlJacI/FCMIy5uwzfprx3ZZJO8UiZEEBo+RWfxkyzecYNgdDFB1j4kVkk
         QZJVHRs8bfc8p37T1Z7ZKwuVsjXNtSC3YcM7pJ8IKQjfdiSWAsbZwC0rOmW5vwVU/TbJ
         nn9pAIWvLc++nFRmRbjDvvzGuP+D3WBQN0Ewpjx0CZE+ZrwM9C/U61eGL9sJZcpgZDxB
         fHU/izoduT84uJ/QvR9vI/omPEhbDgwqPH6/8feacNfHvh3to76ore2dAhsdrAOYsTd4
         tg0w==
X-Gm-Message-State: ACrzQf0A5lw/XnviXeFm5UcHEfEZkUtKevA1pGGoUpn4giswungXqVEq
        2BDbdNUFa6mdOgDjdm8nLXTtTA==
X-Google-Smtp-Source: AMsMyM5GaFAFqupNFpt/qtHCvRjyH0aRY/7ewIKqozGJ7dGEOXK2YfENy5jfOxf22H4ykdUEhaylMw==
X-Received: by 2002:a05:622a:250e:b0:3a5:279d:efc2 with SMTP id cm14-20020a05622a250e00b003a5279defc2mr37428703qtb.551.1667930527530;
        Tue, 08 Nov 2022 10:02:07 -0800 (PST)
Received: from [127.0.0.1] ([190.167.198.156])
        by smtp.gmail.com with ESMTPSA id l19-20020a05620a28d300b006ec771d8f89sm10120601qkp.112.2022.11.08.10.02.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 10:02:07 -0800 (PST)
Date:   Tue, 08 Nov 2022 14:02:05 -0400
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org
CC:     Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>, mlxsw@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net-next_03/15=5D_bridge=3A_switchdev=3A_?= =?US-ASCII?Q?Reflect_MAB_bridge_port_flag_to_device_drivers?=
User-Agent: K-9 Mail for Android
In-Reply-To: <2db3f3f1eff65e42c92a8e3a5626d64f46e68edc.1667902754.git.petrm@nvidia.com>
References: <cover.1667902754.git.petrm@nvidia.com> <2db3f3f1eff65e42c92a8e3a5626d64f46e68edc.1667902754.git.petrm@nvidia.com>
Message-ID: <E8F3691A-66B2-49F6-93AB-3C175CC559F1@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,RCVD_IN_SORBS_HTTP,
        RCVD_IN_SORBS_SOCKS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8 November 2022 06:47:09 GMT-04:00, Petr Machata <petrm@nvidia=2Ecom> wr=
ote:
>From: Ido Schimmel <idosch@nvidia=2Ecom>
>
>Reflect the 'BR_PORT_MAB' flag to device drivers so that:
>
>* Drivers that support MAB could act upon the flag being toggled=2E
>* Drivers that do not support MAB will prevent MAB from being enabled=2E
>
>Signed-off-by: Ido Schimmel <idosch@nvidia=2Ecom>
>Reviewed-by: Petr Machata <petrm@nvidia=2Ecom>
>Signed-off-by: Petr Machata <petrm@nvidia=2Ecom>
>---
>
>Notes:
>    v1:
>    * New patch=2E
>
> net/bridge/br_switchdev=2Ec | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>

Acked-by: Nikolay Aleksandrov <razor@blackwall=2Eorg>

>diff --git a/net/bridge/br_switchdev=2Ec b/net/bridge/br_switchdev=2Ec
>index 8a0abe35137d=2E=2E7eb6fd5bb917 100644
>--- a/net/bridge/br_switchdev=2Ec
>+++ b/net/bridge/br_switchdev=2Ec
>@@ -71,7 +71,7 @@ bool nbp_switchdev_allowed_egress(const struct net_brid=
ge_port *p,
> }
>=20
> /* Flags that can be offloaded to hardware */
>-#define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
>+#define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | BR_PORT_MAB |=
 \
> 				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | BR_PORT_LOCKED | \
> 				  BR_HAIRPIN_MODE | BR_ISOLATED | BR_MULTICAST_TO_UNICAST)
>=20

