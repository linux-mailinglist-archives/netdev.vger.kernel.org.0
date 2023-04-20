Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535346E9C9F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 21:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjDTTrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 15:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbjDTTrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 15:47:41 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7A94C1A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 12:47:39 -0700 (PDT)
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 4E26E3F433
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 19:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1682020056;
        bh=M4FCx6BymVuyrso6vtbBCIKmxFjfSS9vuoCK0Kf2/mU=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=TUhDjVoM/S5kc0Vyenm7t5eR0pJd/aHiz/e0ns+6SvmmRzVlRm3XPRrplJ2ff4Ekl
         HCsHmhlLJ+3itIm1Kvs+7PKXvwhJxnKvA9MVOiHiyyzZC7qaw+J8LktkXhgVXWNqz6
         AkbdyWJYhLSZahPzJW5G796b66hiNi6CuOfsVLlHUgn/buSnp/mihLHqC1lnVVWKG0
         q4lOPiXNUXsrMb7KsLuLYp7r/2WUdt5JaKrHvOpgqQG8nhIR0AP+AEvAcPKX2u2CX9
         reIcQ2bS+y8F5LkWgv+RBkuE8dARr2dvxl9ZtdkuOxJCECSQvTme3N9Zi+otsw8ipz
         LbVnTUhCjMrzA==
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-51b4a13a49fso858860a12.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 12:47:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682020055; x=1684612055;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M4FCx6BymVuyrso6vtbBCIKmxFjfSS9vuoCK0Kf2/mU=;
        b=GgBrJuOlww9kUpeRycEVHZbHllpWJmzS+7tZRWMVLr4d4ZZdEhxS4+VCXgGFKDk19r
         ey+JcDqjN07XBPNqpKx4H1bpFeUHm2Dh1VA+AtLbrGN0ZOn0fWsFaWNXjtU+EeU9DL+Y
         0XyssfK1/jQk/LGoHL/xX7Mlx2fTuvOgE+0eqS1slow8yPju8/ZmwKwcbgd1wc8rVCus
         pM7szjd/i/B4jkbc7DHjZvR6KxvwzYQPJb9yhrXsqtzSjcfB3LQzgQga5g4HaGwS/JG9
         qO58WofmvmaoNkmn3Ps/QspJavfFDmXaMFeZOCt3Ljivyk4IMigJM2JZ+pmHgXjfxQKk
         bCqQ==
X-Gm-Message-State: AAQBX9fUMvpdpdqOa0IHmeGd0VjyGjETrqJyW8YeVBtuuw6kpBRi80PO
        guTDG2VpXwzCfKHkA5wEbBgo7kRjvvHBCPtIgOpFP95kbWMyKGn0zCy0YIi7up3WkP9BUJwekdO
        CGZXOWLvMVPVPsdPOdG5AuPxJcWfGfcrt1A==
X-Received: by 2002:a05:6a20:8e13:b0:f1:bea6:a319 with SMTP id y19-20020a056a208e1300b000f1bea6a319mr3675513pzj.25.1682020054986;
        Thu, 20 Apr 2023 12:47:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350YI0q5564//cqrWh6580Z1jqDxRivQcBB6jM4QGUYJ+4Oiy1rMnWUfL6jwdLDBZ+4HQGCjauQ==
X-Received: by 2002:a05:6a20:8e13:b0:f1:bea6:a319 with SMTP id y19-20020a056a208e1300b000f1bea6a319mr3675493pzj.25.1682020054613;
        Thu, 20 Apr 2023 12:47:34 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id s11-20020a170902a50b00b001a68986a3d8sm1510650plq.24.2023.04.20.12.47.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Apr 2023 12:47:34 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id CA20B607E6; Thu, 20 Apr 2023 12:47:33 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id C2D2C9FB79;
        Thu, 20 Apr 2023 12:47:33 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Simon Horman <horms@kernel.org>
cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] bonding: Always assign be16 value to vlan_proto
In-reply-to: <20230420-bonding-be-vlan-proto-v1-1-754399f51d01@kernel.org>
References: <20230420-bonding-be-vlan-proto-v1-1-754399f51d01@kernel.org>
Comments: In-reply-to Simon Horman <horms@kernel.org>
   message dated "Thu, 20 Apr 2023 17:29:08 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9835.1682020053.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 20 Apr 2023 12:47:33 -0700
Message-ID: <9836.1682020053@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simon Horman <horms@kernel.org> wrote:

>The type of the vlan_proto field is __be16.
>And most users of the field use it as such.
>
>In the case of setting or testing the field for the
>special VLAN_N_VID value, host byte order is used.
>Which seems incorrect.
>
>Address this issue by converting VLAN_N_VID to __be16.
>
>I don't believe this is a bug because VLAN_N_VID in
>both little-endian (and big-endian) byte order does
>not conflict with any valid values (0 through VLAN_N_VID - 1)
>in big-endian byte order.

	Is that true for all cases, or am I just confused?  Doesn't VLAN
ID 16 match VLAN_N_VID (which is 4096) if byte swapped?

	I.e., on a little endian host, VLAN_N_VID is 0x1000 natively,
and network byte order (big endian) of VLAN ID 16 is also 0x1000.

	Either way, I think the change is fine; VLAN_N_VID is being used
as a sentinel value here, so the only real requirement is that it not
match an actual VLAN ID in network byte order.

	-J

>Reported by sparse as:
>
> .../bond_main.c:2857:26: warning: restricted __be16 degrades to integer
> .../bond_main.c:2863:20: warning: restricted __be16 degrades to integer
> .../bond_main.c:2939:40: warning: incorrect type in assignment (differen=
t base types)
> .../bond_main.c:2939:40:    expected restricted __be16 [usertype] vlan_p=
roto
> .../bond_main.c:2939:40:    got int
>
>No functional changes intended.
>Compile tested only.
>
>Signed-off-by: Simon Horman <horms@kernel.org>
>---
> drivers/net/bonding/bond_main.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index db7e650d9ebb..7f4c75fe58e1 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -2854,13 +2854,13 @@ static bool bond_handle_vlan(struct slave *slave,=
 struct bond_vlan_tag *tags,
> 	struct net_device *slave_dev =3D slave->dev;
> 	struct bond_vlan_tag *outer_tag =3D tags;
> =

>-	if (!tags || tags->vlan_proto =3D=3D VLAN_N_VID)
>+	if (!tags || tags->vlan_proto =3D=3D cpu_to_be16(VLAN_N_VID))
> 		return true;
> =

> 	tags++;
> =

> 	/* Go through all the tags backwards and add them to the packet */
>-	while (tags->vlan_proto !=3D VLAN_N_VID) {
>+	while (tags->vlan_proto !=3D cpu_to_be16(VLAN_N_VID)) {
> 		if (!tags->vlan_id) {
> 			tags++;
> 			continue;
>@@ -2936,7 +2936,7 @@ struct bond_vlan_tag *bond_verify_device_path(struc=
t net_device *start_dev,
> 		tags =3D kcalloc(level + 1, sizeof(*tags), GFP_ATOMIC);
> 		if (!tags)
> 			return ERR_PTR(-ENOMEM);
>-		tags[level].vlan_proto =3D VLAN_N_VID;
>+		tags[level].vlan_proto =3D cpu_to_be16(VLAN_N_VID);
> 		return tags;
> 	}

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
