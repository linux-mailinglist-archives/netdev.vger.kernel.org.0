Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC484D2344
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 22:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350440AbiCHV0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 16:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350429AbiCHV03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 16:26:29 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915345044C
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 13:25:31 -0800 (PST)
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E248F3F19E
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 21:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646774729;
        bh=k1EcgWYLYUAyFXD7zaCIFVTgmkFymkNTxJcCjb0ZEck=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=lTd8nFUUmiWtrxG9Mnaxc/qrqGU3u1bhjirtM1rdUtIkcKc8fEfZb1Vs++byi8sxn
         NM6jNaAQ9DmhqVFQLhkpRGQdaBCs2NujbMIlOAgL+CBiQtDthLZCoyvfyYHPmjt9p7
         I/llI5jbTpgPp6Lt9a5gq6igrddMqTbzNZilfJTpYC2NPRiPGV0aEWYeHISvx+Gp7q
         Pr/LKTjwAdf8TmYSCt4N2sXOUlFzWeC2eaKpqDb5vSZVVZF1DxnpoKW0XWVe2feJlI
         8wA7aYO2sJ/dQxd1u+5DSGdXFvtHey3QnYFj22M7ahlnedgmA5krbKJzFjYjB20zKJ
         +bL5Cp9PskvgA==
Received: by mail-pf1-f200.google.com with SMTP id j204-20020a6280d5000000b004e107ad3488so272888pfd.15
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 13:25:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=k1EcgWYLYUAyFXD7zaCIFVTgmkFymkNTxJcCjb0ZEck=;
        b=hU0sJCVhlV6oZHkRts5ERR6uwKW+BC1QUgHOZEipHFq66Bqhr3zG58KcD4NVeZKG1A
         IIQMV2OO8yXYJy0dwRBOi7GvWJC/ia4YNUf6DBrlFZxtcv0QK3bBpYkw21yq4Na6v+r5
         +fSWq/JD9pbZWvtHWFiwgHFR3btNbGdMXsIHDapDLRfRqKWLvseqm8OjdQaz0kV9XJtp
         xXZODai9NtH2VwpZ1VkpeWTZFAoPRJGecpkIUQaUltuio1Iv/xHLz1JUXtkOL3z8D5Aq
         06pzGWjxdO2gT62RqsqIHFLmHdOC1c8bzl1BWt8XLXnNy0ZlAxqlFFmqcEESZ4NHRKg+
         K6oA==
X-Gm-Message-State: AOAM533iqvbnL3amCGJm1hGKO/+0jjhttjLoabEkoD7HEF1DbXOzmTNU
        miDIwz54JH2OkY09Yzdhf54lEFiWfEak1FsVt0IpcEFt+cfT+VUb9B1qxpvgpgFoEt/BOLMpobH
        jQgNj+u3m52HEyRffrNMVO4gUdgLjrCZEsg==
X-Received: by 2002:a17:90b:381:b0:1bf:50c7:a4e9 with SMTP id ga1-20020a17090b038100b001bf50c7a4e9mr900279pjb.239.1646774728498;
        Tue, 08 Mar 2022 13:25:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy39PhTEUw/KyrgGCIEqii3uT4UieXtD6WlB4juAC6T/mMJaO5oCeX6woa94Glhfxi8aOBd5A==
X-Received: by 2002:a17:90b:381:b0:1bf:50c7:a4e9 with SMTP id ga1-20020a17090b038100b001bf50c7a4e9mr900252pjb.239.1646774728086;
        Tue, 08 Mar 2022 13:25:28 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id l2-20020a056a0016c200b004e10af156adsm21415090pfc.190.2022.03.08.13.25.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Mar 2022 13:25:27 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 2682D60DD1; Tue,  8 Mar 2022 13:25:27 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 20FF19FAC3;
        Tue,  8 Mar 2022 13:25:27 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Lianjie Zhang <zhanglianjie@uniontech.com>
cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] bonding: helper macro __ATTR_RO to make code more clear
In-reply-to: <20220307013333.15826-1-zhanglianjie@uniontech.com>
References: <20220307013333.15826-1-zhanglianjie@uniontech.com>
Comments: In-reply-to Lianjie Zhang <zhanglianjie@uniontech.com>
   message dated "Mon, 07 Mar 2022 09:33:33 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2940.1646774727.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 08 Mar 2022 13:25:27 -0800
Message-ID: <2941.1646774727@famine>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lianjie Zhang <zhanglianjie@uniontech.com> wrote:

>From: zhanglianjie <zhanglianjie@uniontech.com>
>
>Delete SLAVE_ATTR macro, use __ATTR_RO replacement,
>make code logic clearer and unified.
>
>Signed-off-by: Lianjie Zhang <zhanglianjie@uniontech.com>
>Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	Please do not add tags that individuals do not explicitly
provide.

	Other than the above, the change seems fine.

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

>diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding=
/bond_sysfs_slave.c
>index 6a6cdd0bb258..69b0a3751dff 100644
>--- a/drivers/net/bonding/bond_sysfs_slave.c
>+++ b/drivers/net/bonding/bond_sysfs_slave.c
>@@ -15,14 +15,8 @@ struct slave_attribute {
> 	ssize_t (*show)(struct slave *, char *);
> };
>
>-#define SLAVE_ATTR(_name, _mode, _show)				\
>-const struct slave_attribute slave_attr_##_name =3D {		\
>-	.attr =3D {.name =3D __stringify(_name),			\
>-		 .mode =3D _mode },				\
>-	.show	=3D _show,					\
>-};
> #define SLAVE_ATTR_RO(_name)					\
>-	SLAVE_ATTR(_name, 0444, _name##_show)
>+const struct slave_attribute slave_attr_##_name =3D __ATTR_RO(_name)
>
> static ssize_t state_show(struct slave *slave, char *buf)
> {
>--
>2.20.1

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
