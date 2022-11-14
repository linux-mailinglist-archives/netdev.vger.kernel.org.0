Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D3E627A79
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbiKNKaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236330AbiKNKaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:30:16 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE9A13CD5
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:30:14 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id kt23so27142066ejc.7
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UTiCXgB1B6wtLlzmBFhY9pWbKD6k3duRQDCUPfCyj9o=;
        b=t3S9hiNdawTRHw89T0cSvKsLqtfjAs7aOCJpmgqQTBQom28PQJ5aPp0eHJO6aw+dKp
         29UZdTdzkLtxSdDUF8rGeXOfNXGNE5bO9fKdwbwGASSTTJvHr5lndOuiqFf75v1Ck7hi
         +VZZKUQHUvEf89QrBawSmf1ahdBSSrkHvqgR66fqvmrZvaj0KNC3EdFo2tqz3E3F+XFe
         114fgo21+k2mkXxWAP0osslBvD7krcAcOz8fQ8BCT1bDoeAq+eXjR1INCm/MU9exdLyC
         jgTPW3vqrA1LC3LVlHSJlnyjaGgooR9wr955WqFQXlN9Ah4Etu+/TGzxZLzMPCI9EyI9
         RBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UTiCXgB1B6wtLlzmBFhY9pWbKD6k3duRQDCUPfCyj9o=;
        b=iRefiBbSrYv/KEms2pt79dH5AIBTNJjCaSMtpRPEfUrtbCI8OvExLTjH5nR1uXWvqf
         1chxDKMM7ER99sJDDpBdP7noAffcPZYkwM7WdLKXdBSD1GyY3TMuerNrkrO04cZzPbkc
         +r9wnle2JM37exAvAoe9nHgE4+nYIb3yZSHg9gPvI0te12NeEp7GtB0GooP97TQY1WVR
         /Xcsd6VfsEZKXZ1FSmHScNiQi3w8af+VDl1Kw8uZVqWEMBxLpbkBLjyLoPbO8MVjgP5s
         EL4VNMoOVmgfLj2AAFTfij1deG1vE1o5/RBdXTlYnTMzSDRsemZU5CnFeyquMlOaF43a
         d2pA==
X-Gm-Message-State: ANoB5pkclOffINslyRqTUpCKBjzWh3PY22jOgDsSKjBn1lYnZOIOIhiR
        171jozjOwc364ap+jEUfcFk8ag==
X-Google-Smtp-Source: AA0mqf5YFbzY/06ETgYT/ZGfxkpY7/UAl/lmIwtO6YELs9WrL0G1NlpP3QNkGbTmP2dKU+HTkIb2HQ==
X-Received: by 2002:a17:906:348a:b0:78d:85fe:4946 with SMTP id g10-20020a170906348a00b0078d85fe4946mr10443664ejb.268.1668421812683;
        Mon, 14 Nov 2022 02:30:12 -0800 (PST)
Received: from [127.0.0.1] ([149.62.206.2])
        by smtp.gmail.com with ESMTPSA id f7-20020a1709063f4700b0078d0981516esm4068457ejj.38.2022.11.14.02.30.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 02:30:12 -0800 (PST)
Date:   Mon, 14 Nov 2022 11:30:08 +0100
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
CC:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, vladbu@nvidia.com,
        roopa@nvidia.com, mlxsw@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net=5D_bridge=3A_switchdev=3A_Fix_?= =?US-ASCII?Q?memory_leaks_when_changing_VLAN_protocol?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20221114084509.860831-1-idosch@nvidia.com>
References: <20221114084509.860831-1-idosch@nvidia.com>
Message-ID: <8BA53D5E-4B93-4B0D-A6CD-D8067EF6F03B@blackwall.org>
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

On 14 November 2022 09:45:09 CET, Ido Schimmel <idosch@nvidia=2Ecom> wrote:
>The bridge driver can offload VLANs to the underlying hardware either
>via switchdev or the 8021q driver=2E When the former is used, the VLAN is
>marked in the bridge driver with the 'BR_VLFLAG_ADDED_BY_SWITCHDEV'
>private flag=2E
>
>To avoid the memory leaks mentioned in the cited commit, the bridge
>driver will try to delete a VLAN via the 8021q driver if the VLAN is not
>marked with the previously mentioned flag=2E
>
>When the VLAN protocol of the bridge changes, switchdev drivers are
>notified via the 'SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL' attribute, but
>the 8021q driver is also called to add the existing VLANs with the new
>protocol and delete them with the old protocol=2E
>
>In case the VLANs were offloaded via switchdev, the above behavior is
>both redundant and buggy=2E Redundant because the VLANs are already
>programmed in hardware and drivers that support VLAN protocol change
>(currently only mlx5) change the protocol upon the switchdev attribute
>notification=2E Buggy because the 8021q driver is called despite these
>VLANs being marked with 'BR_VLFLAG_ADDED_BY_SWITCHDEV'=2E This leads to
>memory leaks [1] when the VLANs are deleted=2E
>
>Fix by not calling the 8021q driver for VLANs that were already
>programmed via switchdev=2E
>
>[1]
>unreferenced object 0xffff8881f6771200 (size 256):
>  comm "ip", pid 446855, jiffies 4298238841 (age 55=2E240s)
>  hex dump (first 32 bytes):
>    00 00 7f 0e 83 88 ff ff 00 00 00 00 00 00 00 00  =2E=2E=2E=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  =2E=2E=2E=2E=2E=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E=2E
>  backtrace:
>    [<00000000012819ac>] vlan_vid_add+0x437/0x750
>    [<00000000f2281fad>] __br_vlan_set_proto+0x289/0x920
>    [<000000000632b56f>] br_changelink+0x3d6/0x13f0
>    [<0000000089d25f04>] __rtnl_newlink+0x8ae/0x14c0
>    [<00000000f6276baf>] rtnl_newlink+0x5f/0x90
>    [<00000000746dc902>] rtnetlink_rcv_msg+0x336/0xa00
>    [<000000001c2241c0>] netlink_rcv_skb+0x11d/0x340
>    [<0000000010588814>] netlink_unicast+0x438/0x710
>    [<00000000e1a4cd5c>] netlink_sendmsg+0x788/0xc40
>    [<00000000e8992d4e>] sock_sendmsg+0xb0/0xe0
>    [<00000000621b8f91>] ____sys_sendmsg+0x4ff/0x6d0
>    [<000000000ea26996>] ___sys_sendmsg+0x12e/0x1b0
>    [<00000000684f7e25>] __sys_sendmsg+0xab/0x130
>    [<000000004538b104>] do_syscall_64+0x3d/0x90
>    [<0000000091ed9678>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
>Fixes: 279737939a81 ("net: bridge: Fix VLANs memory leak")
>Reported-by: Vlad Buslov <vladbu@nvidia=2Ecom>
>Tested-by: Vlad Buslov <vladbu@nvidia=2Ecom>
>Signed-off-by: Ido Schimmel <idosch@nvidia=2Ecom>
>---
> net/bridge/br_vlan=2Ec | 17 ++++++++++++++---
> 1 file changed, 14 insertions(+), 3 deletions(-)
>

Acked-by: Nikolay Aleksandrov <razor@blackwall=2Eorg>

>diff --git a/net/bridge/br_vlan=2Ec b/net/bridge/br_vlan=2Ec
>index 6e53dc991409=2E=2E9ffd40b8270c 100644
>--- a/net/bridge/br_vlan=2Ec
>+++ b/net/bridge/br_vlan=2Ec
>@@ -959,6 +959,8 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16=
 proto,
> 	list_for_each_entry(p, &br->port_list, list) {
> 		vg =3D nbp_vlan_group(p);
> 		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
>+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
>+				continue;
> 			err =3D vlan_vid_add(p->dev, proto, vlan->vid);
> 			if (err)
> 				goto err_filt;
>@@ -973,8 +975,11 @@ int __br_vlan_set_proto(struct net_bridge *br, __be1=
6 proto,
> 	/* Delete VLANs for the old proto from the device filter=2E */
> 	list_for_each_entry(p, &br->port_list, list) {
> 		vg =3D nbp_vlan_group(p);
>-		list_for_each_entry(vlan, &vg->vlan_list, vlist)
>+		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
>+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
>+				continue;
> 			vlan_vid_del(p->dev, oldproto, vlan->vid);
>+		}
> 	}
>=20
> 	return 0;
>@@ -983,13 +988,19 @@ int __br_vlan_set_proto(struct net_bridge *br, __be=
16 proto,
> 	attr=2Eu=2Evlan_protocol =3D ntohs(oldproto);
> 	switchdev_port_attr_set(br->dev, &attr, NULL);
>=20
>-	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist)
>+	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist) {
>+		if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
>+			continue;
> 		vlan_vid_del(p->dev, proto, vlan->vid);
>+	}
>=20
> 	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
> 		vg =3D nbp_vlan_group(p);
>-		list_for_each_entry(vlan, &vg->vlan_list, vlist)
>+		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
>+			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
>+				continue;
> 			vlan_vid_del(p->dev, proto, vlan->vid);
>+		}
> 	}
>=20
> 	return err;

