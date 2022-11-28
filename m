Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C9B63B164
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbiK1SdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiK1Sct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:32:49 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395425FF4
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:30:20 -0800 (PST)
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 777AD3F04D
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 18:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1669660218;
        bh=/GO7SH++KbJUIUnG5/Y56ygpcT75/xWV7eW8Ngsar8Q=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=g1japo+kRYsi6KOx3NwcnarWtHec0xcp2zVqzbqwbL6US8tAikeE3C8zxpTw5sO8i
         y1JDk0Mw5EBEU/oNLExcp4q6GiUTxbOKNrTMdTZSoVlPROVZT43lr3l5nFmxc29o9C
         MPsYun4TbFSh+1w0D9fMmC2onshy2+sDT8fJQdL+TrGbrXyCAjQ8ducSAzuQZhsUVI
         K8YbiwAkZd5z8eLsRq6fPe5GjJbFYjZ1Imp82M+DSA4f+ju0AS+Iaj8oHI6c7YOmn4
         dvBBVscITR34O9MihPHWP/meqljlM5s4+nh/HxxDFLPEExwuHb9kdCWova8dgUm5lX
         krArUl2irO26A==
Received: by mail-pl1-f200.google.com with SMTP id o8-20020a170902d4c800b001898ea5e030so3018349plg.13
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:30:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/GO7SH++KbJUIUnG5/Y56ygpcT75/xWV7eW8Ngsar8Q=;
        b=56GWjtCoeORaG1QrI0hEWqJMjyc9wtPUVyQ/PufL2r34AWW8ltJMb/jQICDr9u4yNW
         T0i6v0TKhoRcB1WZVsnLBDJ9Iih6FVGOADRVK8HqPpe6KUyFpCMBloyc0R3z4VVoEov8
         lEZcZzRkkfJjPqc8VGOuDG6HfpkSYZDgzlWDEfmG5fwpjPXRhuR+V/k0LWuel+EosyN/
         kTpVTWjdnHgPKer1s2UT43FT8PhgkLhqrYHaak7rAOss2xgN7kJeQk7QRS/wGrUODQWa
         0/ijmHiAUPnr9yJgPWVK1i02K480aoakfN15QiLxHNMyZm9bObg+T2FXzeXNEXfn4Plj
         Or2g==
X-Gm-Message-State: ANoB5pkrIYj7g9fLDj5HeLLW9Qb+L0IeU7Dn+9Wa75y8MFWS4vMbow6T
        awc4/zTmEn6veP6iPwfP8IfPfOrVzlOsCOr3oW3sTd5ExEMV2JRJd6tODviU50kXG3Lfo+zxWMN
        fy+RtUu3WN6xUsmr1keGpbvUr/zjLjrXlLg==
X-Received: by 2002:a17:90a:d190:b0:20d:747a:c507 with SMTP id fu16-20020a17090ad19000b0020d747ac507mr56088808pjb.145.1669660216612;
        Mon, 28 Nov 2022 10:30:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7zqlDsN68CVt3siI+SC4+AHykxApsWfGb81G+IfI8hdhkdigCuYQB4/S5+C6y8d2KTXMPDFg==
X-Received: by 2002:a17:90a:d190:b0:20d:747a:c507 with SMTP id fu16-20020a17090ad19000b0020d747ac507mr56088781pjb.145.1669660216382;
        Mon, 28 Nov 2022 10:30:16 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902e88a00b00189240585a7sm9193548plg.173.2022.11.28.10.30.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Nov 2022 10:30:15 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 298365FEAC; Mon, 28 Nov 2022 10:30:15 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 2414AA02BA;
        Mon, 28 Nov 2022 10:30:15 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Dan Carpenter <error27@gmail.com>
cc:     Jonathan Toppins <jtoppins@redhat.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next v2] bonding: uninitialized variable in bond_miimon_inspect()
In-reply-to: <Y4SWJlh3ohJ6EPTL@kili>
References: <Y4SWJlh3ohJ6EPTL@kili>
Comments: In-reply-to Dan Carpenter <error27@gmail.com>
   message dated "Mon, 28 Nov 2022 14:06:14 +0300."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14023.1669660215.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 28 Nov 2022 10:30:15 -0800
Message-ID: <14024.1669660215@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter <error27@gmail.com> wrote:

>The "ignore_updelay" variable needs to be initialized to false.
>
>Fixes: f8a65ab2f3ff ("bonding: fix link recovery in mode 2 when updelay i=
s nonzero")
>Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

>---
>v2: Re-order so the declarations are in reverse Christmas tree order
>
>Don't forget about:
>drivers/net/bonding/bond_main.c:5071 bond_update_slave_arr() warn: missin=
g error code here? 'bond_3ad_get_active_agg_info()' failed. 'ret' =3D '0'

	The code around the cited line is correct.  A -1 return from
bond_3ad_get_active_agg_info is not indicative of an error in the sense
that something has failed, but indicates that there is no active
aggregator.  The code correctly returns 0 from bond_update_slave_arr, as
returning non-zero would cause bond_slave_arr_handler to loop, retrying
the call to bond_update_slave_arr (via workqueue).

	-J

> drivers/net/bonding/bond_main.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index c87481033995..e01bb0412f1c 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -2524,10 +2524,10 @@ static int bond_slave_info_query(struct net_devic=
e *bond_dev, struct ifslave *in
> /* called with rcu_read_lock() */
> static int bond_miimon_inspect(struct bonding *bond)
> {
>+	bool ignore_updelay =3D false;
> 	int link_state, commit =3D 0;
> 	struct list_head *iter;
> 	struct slave *slave;
>-	bool ignore_updelay;
> =

> 	if (BOND_MODE(bond) =3D=3D BOND_MODE_ACTIVEBACKUP) {
> 		ignore_updelay =3D !rcu_dereference(bond->curr_active_slave);
>-- =

>2.35.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
