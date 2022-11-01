Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060B06151E7
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 20:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiKATEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 15:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiKATEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 15:04:31 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB731C416
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 12:04:29 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id a5so23100374edb.11
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 12:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y2EdN1b7RhysOT15RURE5ha+GdNMYogbP0VztCt1Rok=;
        b=XTGZDwzwD7eX7RMU3MkCmQaarNWCP1ZYYsSHu7vW45fUcT6YElvg/pJhJMcK4zhkke
         qQwFyH0ov5WVMiH9ZXUWDumfqZ8qDlx5aFLNULcbNb9O6Yf5/Ek2PXRSf7VOYPSvaPMN
         gZiAevFtKr2P8WU6YvJtC6JvdaLvNeqIq58Y0rOXcSCtQA2p8GDsK2NvRbDVBCIGJRrI
         5MrbcO1HAKRDZ35tDTViDqXeLspHGPf7836l96EwN+aGcheAPrzNwRlOGKU2jKl5jS5U
         5qHWkieGFVY8zYaxR6ld7b9MNDmL7kXy+R0eboXoNsdfvzlB6p/pjqOiD6JZohwAfAhQ
         9EzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y2EdN1b7RhysOT15RURE5ha+GdNMYogbP0VztCt1Rok=;
        b=3jkuynnfBYu/ujgDc74lkRDmpL98gtxGxUkTuwmMp/3W4ZbnpzkQHW40DNoiQx1R0L
         xgbtAmWy6+h6QN2APFgJfu2fzdz2BGun3ffeBiwfDCdMrLPDPAJF9pMhodeH1c7ipZMq
         j51K0a3UMuGKyufYt+Fewo1s/XzyhWeYSWrxNbzIIlZ/fE4/Vf0sAwZcSQm6WkrsMkfk
         JYF8/XOGch855xGIUfz8wrjF61a/pPW89lAKKXjI6DFV89+dvXbXVf2paz7F42JZ5wQx
         YLYCna7+dd+ttSjlqrmikwGXN/uQGDvJnGoFuMoAic8+ug+35Yo0ISPI1tJQASAoyVn6
         OBAw==
X-Gm-Message-State: ACrzQf3OXYal+XhMfyYhSdT1fZ/cb2gv7pVMLBYej8tYS7Eg/R4T+XHC
        chgozAKGTKlwcBg6Nb+aILA5+g==
X-Google-Smtp-Source: AMsMyM5xg3aZpSFCindpi6/QLKLFa41WXgHZBMug6jvZVuRABdIuWRxmhu0V5EYYc/z9lJUrWpBgfw==
X-Received: by 2002:a05:6402:544:b0:463:beae:427f with SMTP id i4-20020a056402054400b00463beae427fmr3672391edx.29.1667329467931;
        Tue, 01 Nov 2022 12:04:27 -0700 (PDT)
Received: from [127.0.0.1] (95-42-27-223.ip.btc-net.bg. [95.42.27.223])
        by smtp.gmail.com with ESMTPSA id g11-20020a170906538b00b0078d9cd0d2d6sm4560459ejo.11.2022.11.01.12.04.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Nov 2022 12:04:27 -0700 (PDT)
Date:   Tue, 01 Nov 2022 21:04:24 +0200
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
CC:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net] bridge: Fix flushing of dynamic FDB entries
User-Agent: K-9 Mail for Android
In-Reply-To: <20221101185753.2120691-1-idosch@nvidia.com>
References: <20221101185753.2120691-1-idosch@nvidia.com>
Message-ID: <FB8BCFAD-D132-4B8A-BE01-859327F22D19@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1 November 2022 20:57:53 EET, Ido Schimmel <idosch@nvidia=2Ecom> wrote:
>The following commands should result in all the dynamic FDB entries
>being flushed, but instead all the non-local (non-permanent) entries are
>flushed:
>
> # bridge fdb add 00:aa:bb:cc:dd:ee dev dummy1 master static
> # bridge fdb add 00:11:22:33:44:55 dev dummy1 master dynamic
> # ip link set dev br0 type bridge fdb_flush
> # bridge fdb show brport dummy1
> 00:00:00:00:00:01 master br0 permanent
> 33:33:00:00:00:01 self permanent
> 01:00:5e:00:00:01 self permanent
>
>This is because br_fdb_flush() works with FDB flags and not the
>corresponding enumerator values=2E Fix by passing the FDB flag instead=2E
>
>After the fix:
>
> # bridge fdb add 00:aa:bb:cc:dd:ee dev dummy1 master static
> # bridge fdb add 00:11:22:33:44:55 dev dummy1 master dynamic
> # ip link set dev br0 type bridge fdb_flush
> # bridge fdb show brport dummy1
> 00:aa:bb:cc:dd:ee master br0 static
> 00:00:00:00:00:01 master br0 permanent
> 33:33:00:00:00:01 self permanent
> 01:00:5e:00:00:01 self permanent
>
>Fixes: 1f78ee14eeac ("net: bridge: fdb: add support for fine-grained flus=
hing")
>Signed-off-by: Ido Schimmel <idosch@nvidia=2Ecom>
>---
> net/bridge/br_netlink=2Ec  | 2 +-
> net/bridge/br_sysfs_br=2Ec | 2 +-
> 2 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/net/bridge/br_netlink=2Ec b/net/bridge/br_netlink=2Ec
>index 5aeb3646e74c=2E=2Ed087fd4c784a 100644
>--- a/net/bridge/br_netlink=2Ec
>+++ b/net/bridge/br_netlink=2Ec
>@@ -1332,7 +1332,7 @@ static int br_changelink(struct net_device *brdev, =
struct nlattr *tb[],
>=20
> 	if (data[IFLA_BR_FDB_FLUSH]) {
> 		struct net_bridge_fdb_flush_desc desc =3D {
>-			=2Eflags_mask =3D BR_FDB_STATIC
>+			=2Eflags_mask =3D BIT(BR_FDB_STATIC)
> 		};
>=20
> 		br_fdb_flush(br, &desc);
>diff --git a/net/bridge/br_sysfs_br=2Ec b/net/bridge/br_sysfs_br=2Ec
>index 612e367fff20=2E=2Eea733542244c 100644
>--- a/net/bridge/br_sysfs_br=2Ec
>+++ b/net/bridge/br_sysfs_br=2Ec
>@@ -345,7 +345,7 @@ static int set_flush(struct net_bridge *br, unsigned =
long val,
> 		     struct netlink_ext_ack *extack)
> {
> 	struct net_bridge_fdb_flush_desc desc =3D {
>-		=2Eflags_mask =3D BR_FDB_STATIC
>+		=2Eflags_mask =3D BIT(BR_FDB_STATIC)
> 	};
>=20
> 	br_fdb_flush(br, &desc);

Oops=2E :)
Acked-by: Nikolay Aleksandrov <razor@blackwall=2Eorg>

