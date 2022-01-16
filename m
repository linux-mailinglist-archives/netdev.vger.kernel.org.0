Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A592E48FED0
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 21:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbiAPUXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 15:23:44 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:51612
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231277AbiAPUXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 15:23:43 -0500
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 92C233F17B
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642364620;
        bh=WYjcjKz2V6st99miJHsl96J6U6r5bJVOcDV3lGftWBw=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=feJd6FvYxqF2i9dJTU4FtOz7pEZo4i+iSJPeMMP6c0EZaxkDCtKJEG7w9g+V1LHpX
         zm+Lb/ncAk4/oIY/X6+bCQKzInaZ7QACoc99RTZR1GoumNn1m/00S5pdYSwT1KOCBQ
         QR+Zm6g71AqT999/6ElgsoCRyGIIONgEKqUjPnux6kewzd9OCrkKAA7mKhquGVuzIJ
         dmsuUJ+FxV/f3UFFCKCrnhiKHWzV+xVb2DdUFTp0Uog4DO1rGrKtQM6DL9h7lDeKBL
         621SuFoIGxT8z0nd0ZueMCtgKNmEE5l4v9K9LYgrxD9ZqDqsooe6ndR1gK8pN1LI/l
         4WE+2iOjo3gQA==
Received: by mail-pj1-f72.google.com with SMTP id x1-20020a17090ab00100b001b380b8ed35so13315783pjq.7
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 12:23:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=WYjcjKz2V6st99miJHsl96J6U6r5bJVOcDV3lGftWBw=;
        b=z5gR8fJYdwldmbVfH6JpqAt1prdti5/gw7OtRoPbJCWAgaCWo0ucwnQjvErcjy/B5P
         /oackJhN+6rXOsoJtHl52i2XcQ8vgHVjslKqtTAbbFjw6dEVkvu5OBBRektRNSlmrdDR
         Fak1eazKmBbzOb+0sFpQweI0E8K8yUC0R7i4MPaOpvK4cxEsFUvBQN26hkOOmAjzkljh
         MunchalT/jQtrx0xqqZXlTYWYxzMXh5PqYOD1pte+yuaBXtfc+SpUxqzNDsN1uqRn77f
         ubgiDIvUvgS+P7OuBrlTa8oICj7jFeQY4M6klZdcMEMJ1uqNgRuirypJEG3CzPkWnaF6
         QxZQ==
X-Gm-Message-State: AOAM532KIg8QsXZw81TPadu948C4DpiuAz8eTeCk9U6bXQgxLXzKqScf
        SLGwhUvhz7cOexUp6OkEiWIhW7aGdrcdHNojffNogdI7gJNZL1oJW0udbowpZafdN4OY5mb5U1W
        bZi5zVQbxbPxuDWMGclxeQNnpsDkYuxBNeQ==
X-Received: by 2002:a63:b20d:: with SMTP id x13mr16224344pge.310.1642364619036;
        Sun, 16 Jan 2022 12:23:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwbyrM34sA8pX9jJ/hDLRyjakaxqbCNmSYuxHmTQcq7qCcVYrqnKJaiWn2tmrVhDTxNdxTztQ==
X-Received: by 2002:a63:b20d:: with SMTP id x13mr16224323pge.310.1642364618707;
        Sun, 16 Jan 2022 12:23:38 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id f7sm12274072pfe.210.2022.01.16.12.23.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jan 2022 12:23:38 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 27CBF6093D; Sun, 16 Jan 2022 12:23:37 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 20C51A0B22;
        Sun, 16 Jan 2022 12:23:37 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Moshe Tal <moshet@nvidia.com>
cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jussi Maki <joamaki@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: Re: [PATCH net v2] bonding: Fix extraction of ports from the packet headers
In-reply-to: <20220116173929.6590-1-moshet@nvidia.com>
References: <20220116173929.6590-1-moshet@nvidia.com>
Comments: In-reply-to Moshe Tal <moshet@nvidia.com>
   message dated "Sun, 16 Jan 2022 19:39:29 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3151.1642364617.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Sun, 16 Jan 2022 12:23:37 -0800
Message-ID: <3153.1642364617@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moshe Tal <moshet@nvidia.com> wrote:

>Wrong hash sends single stream to multiple output interfaces.
>
>The offset calculation was relative to skb->head, fix it to be relative
>to skb->data.
>
>Fixes: a815bde56b15 ("net, bonding: Refactor bond_xmit_hash for use with
>xdp_buff")
>Reviewed-by: Jussi Maki <joamaki@gmail.com>
>Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
>Reviewed-by: Gal Pressman <gal@nvidia.com>
>Signed-off-by: Moshe Tal <moshet@nvidia.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

>---
>
>Notes:
>    v2: Change the offset to be relative to skb->data in higher level to
>    handle the case when skb is NULL.
>
> drivers/net/bonding/bond_main.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index fce80b57f15b..ec498ce70f35 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3874,8 +3874,8 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_=
buff *skb)
> 	    skb->l4_hash)
> 		return skb->hash;
> =

>-	return __bond_xmit_hash(bond, skb, skb->head, skb->protocol,
>-				skb->mac_header, skb->network_header,
>+	return __bond_xmit_hash(bond, skb, skb->data, skb->protocol,
>+				skb_mac_offset(skb), skb_network_offset(skb),
> 				skb_headlen(skb));
> }
> =

>-- =

>2.26.2
>
