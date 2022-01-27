Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAF949EF12
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 00:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344001AbiA0Xyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 18:54:40 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:43124
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229658AbiA0Xyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 18:54:39 -0500
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A7DB53F1C2
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 23:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643327671;
        bh=bOdva2AZJZiNL7yaZKCS3GNPbvit/x1vhYqH6ntbRZY=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=pkndNsgRlWhQFr2MS+tL/izbln8cJxNLD+DjEg0zoGkpJ84ur7HLstdQy6fHa0Dis
         GlSx0QIFImzjnBNHUvW2o8CcXRkoMpPAAx7FAtywvH+gcoKeocpUi5NeGYUL1uUmY+
         zm3V0vvtK7ai2qIMeWjW1ur1mxBruN3YnzcbVAGQ6rIYcH5XE8s6+P9ms2LfJO+vHV
         y0m5BNpoxhIqQWYnvbigVrqQRPRUFW9ulXCF9U8rhYIg9neVm2pd5egQeqpusU1jm5
         6bLwRrBbuBbgGzaHfiiu95m2s3X7nLp2ewFEklT0ZZ/ikId+iMvNLzbT1LNXdKzaDn
         dNNhnhVXlLJzA==
Received: by mail-pj1-f69.google.com with SMTP id a10-20020a17090abe0a00b001b4df1f5a6eso2777901pjs.6
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 15:54:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=bOdva2AZJZiNL7yaZKCS3GNPbvit/x1vhYqH6ntbRZY=;
        b=vkisXovxH5lepoXKnd1cJLz97UsaneMHIUrOt/xuGu4uL5ILUhZxn4EiUZNDWuTWp+
         Fc9OW+UHYsZ8PzZTS4CxSCuLsG+/AuuY0Ch+62jZDWe79d+IIpIKzXoAKSC5yWxkcijJ
         aigZq97X/wO04PA/IH7S8+5FIK5oqiUJkaxiV0U+/Cg3O9U3JTYkX0g98zQ4f/cFc2cD
         Pe5PGL5u2AZ0a9vP19XAdVVY//E2QmCHWTAnniAtdJMxxqc1k/I8t8wP31IysWD3jnu1
         cDrIxfKjuvgbeEzsR/eQX86Qqq2LJVQkn+bUXtA43eWzUC+9WlzChEptNhej/YzyqyDw
         zWfg==
X-Gm-Message-State: AOAM531k2bHfjxULFl+JfC+Qkk9+jC9g+lKb3dNNniHWVt36ZHoyA2Y+
        IRYzzX209UEtyuj7dhLqdnK1rkLR+oP+7Oe+zc/zCWCOwx5UTQqXpyNBehW5xtySZ4sf8DuQA3m
        zBwSiWP0kx2auIACIU4SoMYcohXkgaUV+1w==
X-Received: by 2002:a17:90a:c901:: with SMTP id v1mr16521029pjt.203.1643327670215;
        Thu, 27 Jan 2022 15:54:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz0v0vcCGKDKDGwm6fmWeUs/HHNBuv8vn2TwBJ86NMvPaRW+YROdUWp1weqQr0poUSPAI3wtA==
X-Received: by 2002:a17:90a:c901:: with SMTP id v1mr16521008pjt.203.1643327669949;
        Thu, 27 Jan 2022 15:54:29 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id a38sm6671756pfx.46.2022.01.27.15.54.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jan 2022 15:54:29 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 12EBF60DD1; Thu, 27 Jan 2022 15:54:29 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 0C0AEA0B26;
        Thu, 27 Jan 2022 15:54:29 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Mahesh Bandewar <maheshb@google.com>
cc:     Netdev <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>
Subject: Re: [PATCH next] bonding: pair enable_port with slave_arr_updates
In-reply-to: <20220127002605.4049593-1-maheshb@google.com>
References: <20220127002605.4049593-1-maheshb@google.com>
Comments: In-reply-to Mahesh Bandewar <maheshb@google.com>
   message dated "Wed, 26 Jan 2022 16:26:05 -0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25025.1643327669.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 27 Jan 2022 15:54:29 -0800
Message-ID: <25026.1643327669@famine>
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
>---
> drivers/net/bonding/bond_3ad.c | 4 ++++
> 1 file changed, 4 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3a=
d.c
>index 6006c2e8fa2b..f20bbc18a03f 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -1024,6 +1024,8 @@ static void ad_mux_machine(struct port *port, bool =
*update_slave_arr)
> =

> 					__enable_port(port);
> 				}
>+				/* Slave array needs update */
>+				*update_slave_arr =3D true;
> 			}

	Shouldn't this be in the same block as the __enable_port() call?
If I'm reading the code correctly, as written this will trigger an
update of the array on every pass of the state machine (every 100ms) if
any port is in COLLECTING_DISTRIBUTING state, which is the usual case.

> 			break;
> 		default:
>@@ -1779,6 +1781,8 @@ static void ad_agg_selection_logic(struct aggregato=
r *agg,
> 			     port =3D port->next_port_in_aggregator) {
> 				__enable_port(port);
> 			}
>+			/* Slave array needs update. */
>+			*update_slave_arr =3D true;
> 		}

	I suspect this change would only affect your issue if the port
in question was failing to partner (i.e., the peer wasn't running LACP
or there was some failure in the LACP negotiation).  If the ports in
your test were in the same aggregator, that shouldn't be the case, as I
believe unpartnered ports are always individual (not in an aggregator).

	Do you have a test?

	-J

> 	}
> =

>-- =

>2.35.0.rc0.227.g00780c9af4-goog
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
