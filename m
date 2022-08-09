Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FF458DD49
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 19:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245624AbiHIRhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 13:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245632AbiHIRhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 13:37:07 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5628F205D6
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 10:37:03 -0700 (PDT)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id DCAA83F476
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 17:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660066619;
        bh=dHWwZbknVnNrfBl232bHYGkJha9Eh+i0xa1KVxb2AmQ=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=STbb208+0vMP6iBfgsN1hU1Gidg3Fri9H7rJaBLB6CfZlq4OolLF1Q1/cF8WAq6u1
         lSm5+WLXc3VBcfNmG8niZ79B68t8VX4vUzXoREe9DAi2gJ5AEsHLy2HswhVxb5JZNw
         vlHFrAsEWSvWMiId91k/yJxwlpdua2S3KTodhT+1/YtJE+aaPOZObfLpskJHqNPlXa
         OI8DyMjUBOOIkXdQTObINCGgYjb40h0OcV3AXOHBaEepiic2Hx5E5ylWrmO3qXr/tA
         F4MWMNE2zER5wUjHHd82x2iQiE/sf16m0PscPPwg+yq1ZCIe6bQteNDGbnMkH2HowV
         EEPhmLFbEdlBQ==
Received: by mail-pj1-f72.google.com with SMTP id o6-20020a17090ab88600b001f30b8c11c5so10400848pjr.2
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 10:36:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=dHWwZbknVnNrfBl232bHYGkJha9Eh+i0xa1KVxb2AmQ=;
        b=g6WR3pXe+fur/755XLRW4CixViIWhUOZKVBfKB97VA0c0hQaPqocW2BUq2VVShrgWq
         yy0n2Hp+sKl8rP/TPuqyBFdzaTIaM1vsh70c8luXI9f5gikkdHyk+IaiD1ADImSoKl+6
         FHpt3V6C42vJn/JNsxS5PAE2Z2C1gEbvIW8BlK6uR0o+Z9SP1mbM83D7R7ZMPaFS9+hH
         vEqxWM1Q2kz5xT+mDrbWymUVv/qr7JThAIFAXtDik0LcKj1PmMaTYOHd1x0wdMg3U0jy
         a1PxVwZjZq8OgqT+7eeqabQ3oIDR7bb2rVgBMrXBgDftwAA3N4eg7ZXAMAjdWz7WtZon
         sxOw==
X-Gm-Message-State: ACgBeo3ZP2/gkIr+lKnuRGIb6Towo/VS2hiddUlSf5DcUHeBDbBXHsUw
        Qaztj+4UxRY4TYBU3li3aTPz1NXAoTLoYxQBISeoPZEomu5vdgO5NmXZH4RVTCVM64F3f2CRF9B
        qR+tpyozFUjeAE7w2MM+nZ4VYBiUb4tsbjA==
X-Received: by 2002:a17:902:ecc8:b0:16f:9355:c103 with SMTP id a8-20020a170902ecc800b0016f9355c103mr20538755plh.122.1660066618185;
        Tue, 09 Aug 2022 10:36:58 -0700 (PDT)
X-Google-Smtp-Source: AA6agR58/x06h/nuDPQ+zXvxxDbCbbFZC9gQydDZeZsTN8+GKJWmR+iAFMIACwZtJwUFF+bMKzqsRg==
X-Received: by 2002:a17:902:ecc8:b0:16f:9355:c103 with SMTP id a8-20020a170902ecc800b0016f9355c103mr20538735plh.122.1660066617874;
        Tue, 09 Aug 2022 10:36:57 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id oj7-20020a17090b4d8700b001df264610c4sm4147601pjb.0.2022.08.09.10.36.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Aug 2022 10:36:57 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id E7CF06119B; Tue,  9 Aug 2022 10:36:56 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id DFF339FA79;
        Tue,  9 Aug 2022 10:36:56 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC net] bonding: 802.3ad: fix no transmission of LACPDUs
In-reply-to: <c2f698e6f73e6e78232ab4ded065c3828d245dbd.1660065706.git.jtoppins@redhat.com>
References: <c2f698e6f73e6e78232ab4ded065c3828d245dbd.1660065706.git.jtoppins@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Tue, 09 Aug 2022 13:21:46 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12989.1660066616.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 09 Aug 2022 10:36:56 -0700
Message-ID: <12990.1660066616@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>Running the script in
>`tools/testing/selftests/net/bonding/bond-break-lacpdu-tx.sh` puts
>bonding into a state where it never transmits LACPDUs.
>
>line 53: echo 65535 > /sys/class/net/fbond/bonding/ad_actor_sys_prio
>setting bond param: ad_actor_sys_prio
>given:
>    params.ad_actor_system =3D 0
>call stack:
>    bond_option_ad_actor_sys_prio()
>    -> bond_3ad_update_ad_actor_settings()
>       -> set ad.system.sys_priority =3D bond->params.ad_actor_sys_prio
>       -> ad.system.sys_mac_addr =3D bond->dev->dev_addr; because
>            params.ad_actor_system =3D=3D 0
>results:
>     ad.system.sys_mac_addr =3D bond->dev->dev_addr
>
>line 59: ip link set fbond address 52:54:00:3B:7C:A6
>setting bond MAC addr
>call stack:
>    bond->dev->dev_addr =3D new_mac
>
>line 63: echo 65535 > /sys/class/net/fbond/bonding/ad_actor_sys_prio
>setting bond param: ad_actor_sys_prio
>given:
>    params.ad_actor_system =3D 0
>call stack:
>    bond_option_ad_actor_sys_prio()
>    -> bond_3ad_update_ad_actor_settings()
>       -> set ad.system.sys_priority =3D bond->params.ad_actor_sys_prio
>       -> ad.system.sys_mac_addr =3D bond->dev->dev_addr; because
>            params.ad_actor_system =3D=3D 0
>results:
>     ad.system.sys_mac_addr =3D bond->dev->dev_addr
>
>line 71: ip link set veth1-bond down master fbond
>given:
>    params.ad_actor_system =3D 0
>    params.mode =3D BOND_MODE_8023AD
>    ad.system.sys_mac_addr =3D=3D bond->dev->dev_addr
>call stack:
>    bond_enslave
>    -> bond_3ad_initialize(); because first slave
>       -> if ad.system.sys_mac_addr !=3D bond->dev->dev_addr
>          return
>results:
>     Nothing is run in bond_3ad_initialize() because dev_add equals
>     sys_mac_addr leaving the global ad_ticks_per_sec zero as it is
>     never initialized anywhere else.
>
>Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>---
> MAINTAINERS                                   |  1 +
> drivers/net/bonding/bond_3ad.c                |  2 +-
> .../net/bonding/bond-break-lacpdu-tx.sh       | 88 +++++++++++++++++++
> 3 files changed, 90 insertions(+), 1 deletion(-)
> create mode 100644 tools/testing/selftests/net/bonding/bond-break-lacpdu=
-tx.sh
>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index 386178699ae7..6e7cebc1bca3 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -3636,6 +3636,7 @@ F:	Documentation/networking/bonding.rst
> F:	drivers/net/bonding/
> F:	include/net/bond*
> F:	include/uapi/linux/if_bonding.h
>+F:	tools/testing/selftests/net/bonding/
> =

> BOSCH SENSORTEC BMA400 ACCELEROMETER IIO DRIVER
> M:	Dan Robertson <dan@dlrobertson.com>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3a=
d.c
>index d7fb33c078e8..e357bc6b8e05 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -84,7 +84,7 @@ enum ad_link_speed_type {
> static const u8 null_mac_addr[ETH_ALEN + 2] __long_aligned =3D {
> 	0, 0, 0, 0, 0, 0
> };
>-static u16 ad_ticks_per_sec;
>+static u16 ad_ticks_per_sec =3D 1000/AD_TIMER_INTERVAL;

	How does this resolve the problem?  Does bond_3ad_initialize
actually run, or is this change sort of jump-starting things?

> static const int ad_delta_in_ticks =3D (AD_TIMER_INTERVAL * HZ) / 1000;
> =

> static const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned =3D
>diff --git a/tools/testing/selftests/net/bonding/bond-break-lacpdu-tx.sh =
b/tools/testing/selftests/net/bonding/bond-break-lacpdu-tx.sh
>new file mode 100644
>index 000000000000..be9f1b64e89e
>--- /dev/null
>+++ b/tools/testing/selftests/net/bonding/bond-break-lacpdu-tx.sh
>@@ -0,0 +1,88 @@
>+#!/bin/sh
>+
>+# Regression Test:
>+#   Verify LACPDUs get transmitted after setting the MAC address of
>+#   the bond.
>+#
>+# https://bugzilla.redhat.com/show_bug.cgi?id=3D2020773
>+#
>+#       +---------+
>+#       | fab-br0 |
>+#       +---------+
>+#            |
>+#       +---------+
>+#       |  fbond  |
>+#       +---------+
>+#        |       |
>+#    +------+ +------+
>+#    |veth1 | |veth2 |
>+#    +------+ +------+
>+#
>+# We use veths instead of physical interfaces
>+
>+set -e
>+#set -x
>+tmp=3D$(mktemp -q dump.XXXXXX)
>+cleanup() {
>+	ip link del fab-br0 >/dev/null 2>&1 || :
>+	ip link del fbond  >/dev/null 2>&1 || :
>+	ip link del veth1-bond  >/dev/null 2>&1 || :
>+	ip link del veth2-bond  >/dev/null 2>&1 || :
>+	modprobe -r bonding  >/dev/null 2>&1 || :
>+	rm -f -- ${tmp}
>+}
>+
>+trap cleanup 0 1 2
>+cleanup
>+sleep 1
>+
>+# create the bridge
>+ip link add fab-br0 address 52:54:00:3B:7C:A6 mtu 1500 type bridge \
>+	forward_delay 15
>+
>+# create the bond
>+ip link add fbond type bond
>+ip link set fbond up
>+
>+# set bond sysfs parameters
>+ip link set fbond down
>+echo 802.3ad           > /sys/class/net/fbond/bonding/mode
>+echo 200               > /sys/class/net/fbond/bonding/miimon
>+echo 1                 > /sys/class/net/fbond/bonding/xmit_hash_policy
>+echo 65535             > /sys/class/net/fbond/bonding/ad_actor_sys_prio
>+echo stable            > /sys/class/net/fbond/bonding/ad_select
>+echo slow              > /sys/class/net/fbond/bonding/lacp_rate
>+echo any               > /sys/class/net/fbond/bonding/arp_all_targets

	Having a test case is very nice; would it be possible to avoid
using sysfs, though?  I believe all of these parameters are available
via /sbin/ip.

	Also, is setting "arp_all_targets" necessary for the test?

	-J

>+
>+# set bond address
>+ip link set fbond address 52:54:00:3B:7C:A6
>+ip link set fbond up
>+
>+# set again bond sysfs parameters
>+echo 65535             > /sys/class/net/fbond/bonding/ad_actor_sys_prio
>+
>+# create veths
>+ip link add name veth1-bond type veth peer name veth1-end
>+ip link add name veth2-bond type veth peer name veth2-end
>+
>+# add ports
>+ip link set fbond master fab-br0
>+ip link set veth1-bond down master fbond
>+ip link set veth2-bond down master fbond
>+
>+# bring up
>+ip link set veth1-end up
>+ip link set veth2-end up
>+ip link set fab-br0 up
>+ip link set fbond up
>+ip addr add dev fab-br0 10.0.0.3
>+
>+tcpdump -n -i veth1-end -e ether proto 0x8809 >${tmp} 2>&1 &
>+sleep 60
>+pkill tcpdump >/dev/null 2>&1
>+num=3D$(grep "packets captured" ${tmp} | awk '{print $1}')
>+if test "$num" -gt 0; then
>+	echo "PASS, captured ${num}"
>+else
>+	echo "FAIL"
>+fi
>-- =

>2.31.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
