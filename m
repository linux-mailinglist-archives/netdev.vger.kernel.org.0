Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588FB4A91BF
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242063AbiBDAul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:50:41 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:56124
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230386AbiBDAuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:50:40 -0500
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A98D23F4B4
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 00:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643935834;
        bh=0tqfuFEZO5OoJYnI+QHMoCp+jUQTwMPUVWWrO24E7TI=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=HsEQrQn6MWaZ2BjLPFiqOOnNvzOenwZdLfM1OUbkjkIcX+ET+jt5lxM2UvGVKwMwy
         Nl9MKj+L8EZLCgQIyxmvS0EVN+O6xcNrbsVUtXyMmw2E6xF309anYDiyB/3s2PxgE+
         9WY0SSLCj7gGJdvOt3dwmbvc3LIVxAjO112m4sLHRPT08lWNx1FqWjsVAp+tQyzEkw
         +BtAcOBUPBBcxVIZVQ7XxtfY9pByysEJ6QqHOH3q9V7Scus32lI50OL+LrkhrNkhTz
         jCaufnhhTdDdTIIXMtsQXrT9goMSuZhYqBuLs+SUzR319591Zahw5tTdgi1WM8vmyX
         OVYZF7u9tvLVQ==
Received: by mail-pj1-f72.google.com with SMTP id p14-20020a17090a2c4e00b001b54165bffeso2883691pjm.0
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:50:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=0tqfuFEZO5OoJYnI+QHMoCp+jUQTwMPUVWWrO24E7TI=;
        b=UI/WePUqWpWW7/4PmtIlRH+zwxUHTzGXj9tBTowZ+Sl7bWh7p/gUGqC5be/vihnk2E
         rywRf6aepAZ41H08bcXlSiFTSma/g2lo7wQc/9uRL2z67cmAm21ndi3NPLrfepM56nyf
         jyLJHqJMgJRU72bz6/UPfOpa2am5cJl1yQ2iGgC2uoxZ7Vrm0XnYhl1VewOj5YTlYNyq
         11vPD0sEdSBfzMHJORfnMfeiiPee/sX0VCsS2wnCWp+Go2qfVxGLSBj0JD5U3WJa276j
         kcgYFCEpAnHqglooAmN+IA6IqTU4TvOW6v586D+RGWA5TJG2bcS12nh6cS3Auw6bbyh4
         mMcQ==
X-Gm-Message-State: AOAM532VG1xiwchElaZeYMLY1hU6sWLeQNkpzjwF34UPE9U4uhebleF7
        bx4NsFyKJXJQ5RiIaiNIX9MYTUVw4gznAY2EPW+Qi2FDw6LD8kVwYzd+/GHl4HZtU7Vd5moAA0T
        W5WvbDe+6aYoXC27IbWYnTP8XFdIa0Ko5xw==
X-Received: by 2002:a17:902:c102:: with SMTP id 2mr761835pli.92.1643935831570;
        Thu, 03 Feb 2022 16:50:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJypEUVGUovI5RowUGRspStozBKpkc38VUsHQznhBYs3iRzOsJm6PXdY2z+njrIyVq8xh3fRbg==
X-Received: by 2002:a17:902:c102:: with SMTP id 2mr761811pli.92.1643935831299;
        Thu, 03 Feb 2022 16:50:31 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id d70sm165080pga.48.2022.02.03.16.50.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:50:30 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 2C8855FDEE; Thu,  3 Feb 2022 16:50:30 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 255CEA0B26;
        Thu,  3 Feb 2022 16:50:30 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Mahesh Bandewar <maheshb@google.com>
cc:     Netdev <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>
Subject: Re: [PATCH v3 net-next] bonding: pair enable_port with slave_arr_updates
In-reply-to: <20220204000653.364358-1-maheshb@google.com>
References: <20220204000653.364358-1-maheshb@google.com>
Comments: In-reply-to Mahesh Bandewar <maheshb@google.com>
   message dated "Thu, 03 Feb 2022 16:06:53 -0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20791.1643935830.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 03 Feb 2022 16:50:30 -0800
Message-ID: <20792.1643935830@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mahesh Bandewar <maheshb@google.com> wrote:

>When 803.2ad mode enables a participating port, it should update
>the slave-array. I have observed that the member links are participating
>and are part of the active aggregator while the traffic is egressing via
>only one member link (in a case where two links are participating). Via
>krpobes I discovered that that slave-arr has only one link added while
>the other participating link wasn't part of the slave-arr.
>
>I couldn't see what caused that situation but the simple code-walk
>through provided me hints that the enable_port wasn't always associated
>with the slave-array update.
>
>Signed-off-by: Mahesh Bandewar <maheshb@google.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

>---
> drivers/net/bonding/bond_3ad.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3a=
d.c
>index 6006c2e8fa2b..9fd1d6cba3cd 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -1021,8 +1021,8 @@ static void ad_mux_machine(struct port *port, bool =
*update_slave_arr)
> 				if (port->aggregator &&
> 				    port->aggregator->is_active &&
> 				    !__port_is_enabled(port)) {
>-
> 					__enable_port(port);
>+					*update_slave_arr =3D true;
> 				}
> 			}
> 			break;
>@@ -1779,6 +1779,7 @@ static void ad_agg_selection_logic(struct aggregato=
r *agg,
> 			     port =3D port->next_port_in_aggregator) {
> 				__enable_port(port);
> 			}
>+			*update_slave_arr =3D true;
> 		}
> 	}
> =

>-- =

>2.35.0.263.gb82422642f-goog
>
