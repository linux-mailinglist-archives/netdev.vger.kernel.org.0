Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4CB6D162C
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 06:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjCaEA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 00:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCaEA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 00:00:26 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55894EC76
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 21:00:25 -0700 (PDT)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B1B073F235
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 04:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680235223;
        bh=GwiURaocYez2zh6XY5BVbkTmVDxUeX2P821vG18oTdk=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=Nak+P4ptWD5vH/zzPPVeCuAhmmifOch7pgzqmzFi9tgVBc02alw5LC+cn1gzN6lw3
         CGmdf/COqq66FcjbOmQ4Fz0T6qYRy9Drq+sBS+O2hTDcD2TzcdR/VYUiEBx6Iq3e0d
         GfsEIcAZute/Xe0oQPFFBc1NZZbPZjyH2ox4QX3gS+lW6Z2Ke7aNsM2mPrfj498vVn
         LZ2Hjy32ez2Js8ktEVIDvcN29zbMQUEyGCshQprp1IfjPj3dN5XZgnMOQPhTPgPWb5
         CvD2QIj8h7U9QnzIgpPqEu9Q9TEqXOpofE7JfFOZV87gjl7AKFihKrXLLQTgC9ge4P
         y5uh49EdY8LfA==
Received: by mail-pj1-f70.google.com with SMTP id d13-20020a17090ad98d00b00240922fdb7cso5909208pjv.6
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 21:00:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680235222;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GwiURaocYez2zh6XY5BVbkTmVDxUeX2P821vG18oTdk=;
        b=f2B4AvZAO5MU40ZPEtX4MQbiiT/VXitke4EhSI7V2AenBfyv1AgvAVXu+It7h39rrE
         TO9OeJaLcs1yvBmqTOQAc4SIkI4g+oNVdvvsuhGpGhR96hydiybAsGh4b2kJ3qB/2lpk
         xPsXivxmrKrP7RaElcwAwu8H2qb8Ep6m6fqOWJruvxTjZeEuDVO9zDIt0jDkYvp76iUt
         tTWElupe7R1JZPBDF0HUS8GmQVYc+9zZrbC5qRicG8LAHKCfFV9i1NsrFFVlW3aAKWIn
         kEp11Am8kM91MrdV0j6gjkVLcFuQtahfWM1v9HtjzWT2gdIGfKCZui6UMlqlr4K0HkQm
         rYHg==
X-Gm-Message-State: AAQBX9csMUhgnm6zRcbebHuwgjuxcjxfv+A6MfUCjKzihsSKpwKKhXGw
        VD+YrQZiM39mILjFmscLk4ugW3pCnnjKZt7JelZjel5BpcmQTp2557k5cIyavpMUhoRfzAsBpHY
        Owcd9KHjj/FCACdAQkUB2h9rGriUQi9HeDQ==
X-Received: by 2002:a17:902:d2cb:b0:1a1:db10:7ba3 with SMTP id n11-20020a170902d2cb00b001a1db107ba3mr35687922plc.2.1680235221910;
        Thu, 30 Mar 2023 21:00:21 -0700 (PDT)
X-Google-Smtp-Source: AKy350bYTmFulhF6P+A2B4Y2ybUhT1SGWj5f1EJu0vexkGqrARqBDN0ROI+CXBnLxn+Vhy2f+3HtKA==
X-Received: by 2002:a17:902:d2cb:b0:1a1:db10:7ba3 with SMTP id n11-20020a170902d2cb00b001a1db107ba3mr35687877plc.2.1680235221423;
        Thu, 30 Mar 2023 21:00:21 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id r3-20020a170902be0300b0019abb539cddsm497121pls.10.2023.03.30.21.00.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Mar 2023 21:00:21 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 8C7FE60080; Thu, 30 Mar 2023 21:00:20 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 847619FB79;
        Thu, 30 Mar 2023 21:00:20 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Liang Li <liali@redhat.com>
Subject: Re: [PATCH net 3/3] selftests: bonding: add arp validate test
In-reply-to: <20230329101859.3458449-4-liuhangbin@gmail.com>
References: <20230329101859.3458449-1-liuhangbin@gmail.com> <20230329101859.3458449-4-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Wed, 29 Mar 2023 18:18:59 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21314.1680235220.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 30 Mar 2023 21:00:20 -0700
Message-ID: <21315.1680235220@famine>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>This patch add bonding arp validate tests with mode active backup,
>monitor arp_ip_target and ns_ip6_target. It also checks mii_status
>to make sure all slaves are UP.
>
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

>---
> .../drivers/net/bonding/bond_options.sh       | 55 +++++++++++++++++++
> 1 file changed, 55 insertions(+)
>
>diff --git a/tools/testing/selftests/drivers/net/bonding/bond_options.sh =
b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
>index 431ce0e45e3c..4909d529210c 100755
>--- a/tools/testing/selftests/drivers/net/bonding/bond_options.sh
>+++ b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
>@@ -5,6 +5,7 @@
> =

> ALL_TESTS=3D"
> 	prio
>+	arp_validate
> "
> =

> REQUIRE_MZ=3Dno
>@@ -207,6 +208,60 @@ prio()
> 	done
> }
> =

>+arp_validate_test()
>+{
>+	local param=3D"$1"
>+	RET=3D0
>+
>+	# create bond
>+	bond_reset "${param}"
>+
>+	bond_check_connection
>+	[ $RET -ne 0 ] && log_test "arp_validate" "$retmsg"
>+
>+	# wait for a while to make sure the mii status stable
>+	sleep 5
>+	for i in $(seq 0 2); do
>+		mii_status=3D$(cmd_jq "ip -n ${s_ns} -j -d link show eth$i" ".[].linki=
nfo.info_slave_data.mii_status")
>+		if [ ${mii_status} !=3D "UP" ]; then
>+			RET=3D1
>+			log_test "arp_validate" "interface eth$i mii_status $mii_status"
>+		fi
>+	done
>+}
>+
>+arp_validate_arp()
>+{
>+	local mode=3D$1
>+	local val
>+	for val in $(seq 0 6); do
>+		arp_validate_test "mode $mode arp_interval 1000 arp_ip_target ${sw_ip4=
} arp_validate $val"
>+		log_test "arp_validate" "mode $mode arp_ip_target arp_validate $val"
>+	done
>+}
>+
>+arp_validate_ns()
>+{
>+	local mode=3D$1
>+	local val
>+
>+	if skip_ns; then
>+		log_test_skip "arp_validate ns" "Current iproute or kernel doesn't sup=
port bond option 'ns_ip6_target'."
>+		return 0
>+	fi
>+
>+	for val in $(seq 0 6); do
>+		arp_validate_test "mode $mode arp_interval 1000 ns_ip6_target ${sw_ip6=
} arp_validate $val"
>+		log_test "arp_validate" "mode $mode ns_ip6_target arp_validate $val"
>+	done
>+}
>+
>+arp_validate()
>+{
>+	arp_validate_arp "active-backup"
>+	arp_validate_ns "active-backup"
>+}
>+
> trap cleanup EXIT
> =

> setup_prepare
>-- =

>2.38.1
>
