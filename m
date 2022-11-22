Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A874633A9B
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 11:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbiKVKym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 05:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiKVKyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 05:54:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CA62AC71
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669114421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FhojcgZQjkVkxO1IPtc27+RD5uOCkquMJUyVv8stBrg=;
        b=Lx6byxK9GeVqCCdz8oPeRIzDbv12PIc6EIq2QJq/CZ8rgKad1B5M3FR/RJJDoVxebIR3XM
        L9P6Ijt7i/DQoau/RvO0tG9uaR1+BoWKx/Pv+O0JxEGEBUOK+YrYiCSXo2bH5ZUOYS542f
        3+jghR0Rf+O77eIxw6HFYNC5fyfXGD4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-631-f3qwCpBEPLOzkN-iljVbZw-1; Tue, 22 Nov 2022 05:53:40 -0500
X-MC-Unique: f3qwCpBEPLOzkN-iljVbZw-1
Received: by mail-qt1-f198.google.com with SMTP id s14-20020a05622a1a8e00b00397eacd9c1aso14388496qtc.21
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:53:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FhojcgZQjkVkxO1IPtc27+RD5uOCkquMJUyVv8stBrg=;
        b=eeXDE76lFQngGO8ulNQYPE1HjrI8XwYKJiIYkpwIn2sNLyQPM9OSxwvzxcrG5CvBUf
         gO4rP8f8ro9aelnxftK0hOV1pQltHF+ZooeTeyny17i0S4MsiJd/OJ6oodsf5+nsm5h8
         l6YeUP85ZQakXemD7uaoKeNJEg3+q6uGnMV8dfiNs9vGEsahuu+fn5r9HunNfHFRCuup
         2g7Iyc6waeuVisDkI5dePNXs81Ft8afnrmMcqx/se49btcw8iTl5EPMWbXv6GrFIhv9H
         QO3M3/eqdNcqXen4gsocv8vfkKzaojXDlvvHCE0ieaSzQnX4tiyOJQbSmrqPrzxHx0Ot
         1cNA==
X-Gm-Message-State: ANoB5plr+pEPXF+SB47rSmu+18kqHiCK/9GbhRQUtf77r9s5Gym6x7bm
        jUMxeyeU0GHs6T6A2yLqcJNIirQQrHqHcF8uy4iLNxJNL8WtPdv6COiJP9sLvTamVaSQyDzAJs3
        72RbCthuKeaeLSHyV
X-Received: by 2002:a05:620a:c95:b0:6fa:91f9:c84d with SMTP id q21-20020a05620a0c9500b006fa91f9c84dmr19769353qki.724.1669114419838;
        Tue, 22 Nov 2022 02:53:39 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4fjZLayeJGwrYg63tie5JEv6jlPrgp+TO4xKqdUefE2d+RuP2PxLNjvr44FG2kEi4tZsLQOQ==
X-Received: by 2002:a05:620a:c95:b0:6fa:91f9:c84d with SMTP id q21-20020a05620a0c9500b006fa91f9c84dmr19769340qki.724.1669114419549;
        Tue, 22 Nov 2022 02:53:39 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id u36-20020a05622a19a400b0039a55f78792sm8163824qtc.89.2022.11.22.02.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 02:53:39 -0800 (PST)
Message-ID: <ffef78317f06db1025855ad3ef999f241dd03178.camel@redhat.com>
Subject: Re: [PATCH net-next 1/2] selftests: bonding: up/down delay w/ slave
 link flapping
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     Liang Li <liali@redhat.com>, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Date:   Tue, 22 Nov 2022 11:53:34 +0100
In-Reply-To: <314990ea9ee4e475cb200cf32efdf9fc37f4a02a.1668800711.git.jtoppins@redhat.com>
References: <cover.1668800711.git.jtoppins@redhat.com>
         <314990ea9ee4e475cb200cf32efdf9fc37f4a02a.1668800711.git.jtoppins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-11-18 at 15:30 -0500, Jonathan Toppins wrote:
> Verify when a bond is configured with {up,down}delay and the link state
> of slave members flaps if there are no remaining members up the bond
> should immediately select a member to bring up. (from bonding.txt
> section 13.1 paragraph 4)
> 
> Suggested-by: Liang Li <liali@redhat.com>
> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
> ---
>  .../selftests/drivers/net/bonding/Makefile    |   4 +-
>  .../selftests/drivers/net/bonding/lag_lib.sh  | 107 ++++++++++++++++++
>  .../net/bonding/mode-1-recovery-updelay.sh    |  45 ++++++++
>  .../net/bonding/mode-2-recovery-updelay.sh    |  45 ++++++++
>  .../selftests/drivers/net/bonding/settings    |   2 +-
>  5 files changed, 201 insertions(+), 2 deletions(-)
>  create mode 100755 tools/testing/selftests/drivers/net/bonding/mode-1-recovery-updelay.sh
>  create mode 100755 tools/testing/selftests/drivers/net/bonding/mode-2-recovery-updelay.sh
> 
> diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
> index 6b8d2e2f23c2..0f3921908b07 100644
> --- a/tools/testing/selftests/drivers/net/bonding/Makefile
> +++ b/tools/testing/selftests/drivers/net/bonding/Makefile
> @@ -5,7 +5,9 @@ TEST_PROGS := \
>  	bond-arp-interval-causes-panic.sh \
>  	bond-break-lacpdu-tx.sh \
>  	bond-lladdr-target.sh \
> -	dev_addr_lists.sh
> +	dev_addr_lists.sh \
> +	mode-1-recovery-updelay.sh \
> +	mode-2-recovery-updelay.sh
>  
>  TEST_FILES := \
>  	lag_lib.sh \
> diff --git a/tools/testing/selftests/drivers/net/bonding/lag_lib.sh b/tools/testing/selftests/drivers/net/bonding/lag_lib.sh
> index 16c7fb858ac1..6dc9af1f2428 100644
> --- a/tools/testing/selftests/drivers/net/bonding/lag_lib.sh
> +++ b/tools/testing/selftests/drivers/net/bonding/lag_lib.sh
> @@ -1,6 +1,8 @@
>  #!/bin/bash
>  # SPDX-License-Identifier: GPL-2.0
>  
> +NAMESPACES=""
> +
>  # Test that a link aggregation device (bonding, team) removes the hardware
>  # addresses that it adds on its underlying devices.
>  test_LAG_cleanup()
> @@ -59,3 +61,108 @@ test_LAG_cleanup()
>  
>  	log_test "$driver cleanup mode $mode"
>  }
> +
> +# Build a generic 2 node net namespace with 2 connections
> +# between the namespaces
> +#
> +#  +-----------+       +-----------+
> +#  | node1     |       | node2     |
> +#  |           |       |           |
> +#  |           |       |           |
> +#  |      eth0 +-------+ eth0      |
> +#  |           |       |           |
> +#  |      eth1 +-------+ eth1      |
> +#  |           |       |           |
> +#  +-----------+       +-----------+
> +lag_setup2x2()
> +{
> +	local state=${1:-down}
> +	local namespaces="lag_node1 lag_node2"
> +
> +	# create namespaces
> +	for n in ${namespaces}; do
> +		ip netns add ${n}
> +	done
> +
> +	# wire up namespaces
> +	ip link add name lag1 type veth peer name lag1-end
> +	ip link set dev lag1 netns lag_node1 $state name eth0
> +	ip link set dev lag1-end netns lag_node2 $state name eth0
> +
> +	ip link add name lag1 type veth peer name lag1-end
> +	ip link set dev lag1 netns lag_node1 $state name eth1
> +	ip link set dev lag1-end netns lag_node2 $state name eth1
> +
> +	NAMESPACES="${namespaces}"
> +}
> +
> +# cleanup all lag related namespaces and remove the bonding module
> +lag_cleanup()
> +{
> +	for n in ${NAMESPACES}; do
> +		ip netns delete ${n} >/dev/null 2>&1 || true
> +	done
> +	modprobe -r bonding
> +}
> +
> +SWITCH="lag_node1"
> +CLIENT="lag_node2"
> +CLIENTIP="172.20.2.1"
> +SWITCHIP="172.20.2.2"
> +
> +lag_setup_network()
> +{
> +	lag_setup2x2 "down"
> +
> +	# create switch
> +	ip netns exec ${SWITCH} ip link add br0 up type bridge
> +	ip netns exec ${SWITCH} ip link set eth0 master br0 up
> +	ip netns exec ${SWITCH} ip link set eth1 master br0 up
> +	ip netns exec ${SWITCH} ip addr add ${SWITCHIP}/24 dev br0
> +}
> +
> +lag_reset_network()
> +{
> +	ip netns exec ${CLIENT} ip link del bond0
> +	ip netns exec ${SWITCH} ip link set eth0 up
> +	ip netns exec ${SWITCH} ip link set eth1 up
> +}
> +
> +create_bond()
> +{
> +	# create client
> +	ip netns exec ${CLIENT} ip link set eth0 down
> +	ip netns exec ${CLIENT} ip link set eth1 down
> +
> +	ip netns exec ${CLIENT} ip link add bond0 type bond $@
> +	ip netns exec ${CLIENT} ip link set eth0 master bond0
> +	ip netns exec ${CLIENT} ip link set eth1 master bond0
> +	ip netns exec ${CLIENT} ip link set bond0 up
> +	ip netns exec ${CLIENT} ip addr add ${CLIENTIP}/24 dev bond0
> +}
> +
> +test_bond_recovery()
> +{
> +	RET=0
> +
> +	create_bond $@
> +
> +	# verify connectivity
> +	ip netns exec ${CLIENT} ping ${SWITCHIP} -c 5 >/dev/null 2>&1

Minor nit: here and below you reduce the count number, to shorten
significantly the tests runtime.

> +	check_err $? "No connectivity"
> +
> +	# force the links of the bond down
> +	ip netns exec ${SWITCH} ip link set eth0 down
> +	sleep 2
> +	ip netns exec ${SWITCH} ip link set eth0 up
> +	ip netns exec ${SWITCH} ip link set eth1 down
> +
> +	# re-verify connectivity
> +	ip netns exec ${CLIENT} ping ${SWITCHIP} -c 5 >/dev/null 2>&1
> +
> +	local rc=$?
> +	check_err $rc "Bond failed to recover"
> +	log_test "$1 ($2) bond recovery"
> +	lag_reset_network
> +	return 0

Minor nit: the return statement is not needed here.


Cheers,

Paolo

