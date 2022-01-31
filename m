Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102824A4EBE
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357310AbiAaSpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:45:40 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:38112
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357347AbiAaSpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:45:38 -0500
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A02063F19C
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 18:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643654737;
        bh=rRIMto31EBKAWHmHUDOdPEW+19zWxepmKSVRYr0rOGU=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=QKdoHes3rhJDTbs+2kyesV3xeVShmIz7S5Fj69wKNMG88tTVrgDRhene5UKxuvEee
         4tWKah00Z0BCPfZ60DcT6mbkSnr3TBGtklgYA5gP2rVIxQlNK1GRrxGFk9sCJnY9gf
         QxFYg4S6HDMTj8q+9CqxyZTEDf678Jziin9QpfK8xcdheUNFfjICuhw4kK+8RZESpi
         tq12gEns3//zXkWYgrsU351Tl+lXo6dLGi35cnjIZSBpCnNaAJe2YodPaZgVVrynwj
         oyuR3mdOi69w4fbY570+1boc203RWdblt64LB/i10d/DshuTK/m0KWjcq+aTLPpjVi
         +aSBdMIK4HZuQ==
Received: by mail-pl1-f199.google.com with SMTP id y3-20020a1709029b8300b0014c8bcb70a1so4364893plp.3
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 10:45:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=rRIMto31EBKAWHmHUDOdPEW+19zWxepmKSVRYr0rOGU=;
        b=qpZ/gu6tQRM96tGgW2LtTYQirgC/HTRqefr1I0BJVYqwY5nTndVaSCTN/JukaabqsN
         NzU45eata+N0ajaBq5VrE5kfPo81qcgXiyuCY4rterkS1cuPNazt05a3H9x5x+3Pgv4C
         NQwL8g19kMc17e3cqcWgaploovIo+pER9fE+ymfpvUXq0rnPCOcv4A9oV+1ZhWORHDli
         EjLZhy0JcplgqVp/yKO6PpMHdwQHcYSywD9BEFC05ToHTGNOM0f6CLq+t9+8Eumob/x4
         Epvlfx1ItNdhpOwqxWbWU7EQzKXtytL14vT1SZSq3+8h4T0wUjUZ9utuQBTOjUW+oX0x
         1csA==
X-Gm-Message-State: AOAM53204BH6Vfb9rMmSXFL5SaOTYlFWgpdMGSLo9fbqTFgG9lrVn1SU
        hKI2wPdDmK5GxJI5dKErMrLI+9IscN7uuG1nbx5+bS4jbNjZA/Kw6S2lcbCoIhfZUDJLMV6wy18
        qHnxvww4RURi5Z5Vyn5KQFAWHHXOGd9n++w==
X-Received: by 2002:a63:2a46:: with SMTP id q67mr1921133pgq.595.1643654736424;
        Mon, 31 Jan 2022 10:45:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyj1XUuJdA5NLLdAIfIRnyZPnD/UGuhEbKrN3YnyeQlaJJGva6P6myg4Bkm5naFcI2Oiymk2g==
X-Received: by 2002:a63:2a46:: with SMTP id q67mr1921110pgq.595.1643654736111;
        Mon, 31 Jan 2022 10:45:36 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id g8sm18916240pfc.193.2022.01.31.10.45.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 Jan 2022 10:45:35 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 135E25FDEE; Mon, 31 Jan 2022 10:45:35 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 0D9F8A0B26;
        Mon, 31 Jan 2022 10:45:35 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Mahesh Bandewar <maheshb@google.com>
cc:     Netdev <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>
Subject: Re: [PATCH v2 net-next] bonding: pair enable_port with slave_arr_updates
In-reply-to: <20220129055815.694469-1-maheshb@google.com>
References: <20220129055815.694469-1-maheshb@google.com>
Comments: In-reply-to Mahesh Bandewar <maheshb@google.com>
   message dated "Fri, 28 Jan 2022 21:58:15 -0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15938.1643654735.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 31 Jan 2022 10:45:35 -0800
Message-ID: <15939.1643654735@famine>
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
>Change-Id: I6c9ed91b027d53580734f1198579e71deee60bbf
>Signed-off-by: Mahesh Bandewar <maheshb@google.com>

	Please remove the Change-Id line.

>---
> drivers/net/bonding/bond_3ad.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3a=
d.c
>index 6006c2e8fa2b..4d876bfa0c00 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -1021,8 +1021,9 @@ static void ad_mux_machine(struct port *port, bool =
*update_slave_arr)
> 				if (port->aggregator &&
> 				    port->aggregator->is_active &&
> 				    !__port_is_enabled(port)) {
>-
> 					__enable_port(port);
>+					/* Slave array needs update */
>+					*update_slave_arr =3D true;

	Given the name of the variable here, I think the comment is
superfluous (both here and the change below).

	Functionally, though, I think the change is reasonable.  Could
you fix these two nits and repost?

	-J

> 				}
> 			}
> 			break;
>@@ -1779,6 +1780,8 @@ static void ad_agg_selection_logic(struct aggregato=
r *agg,
> 			     port =3D port->next_port_in_aggregator) {
> 				__enable_port(port);
> 			}
>+			/* Slave array needs update. */
>+			*update_slave_arr =3D true;
> 		}
> 	}
> =

>-- =

>2.35.0.rc2.247.g8bbb082509-goog
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
