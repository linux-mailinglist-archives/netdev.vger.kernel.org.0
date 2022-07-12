Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373AE571442
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 10:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbiGLITe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 04:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbiGLITd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 04:19:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39C61313BC
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657613969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iPp5jgjHJIx534pLAzg6KfoArYEXjlp6G9pthy1s5kM=;
        b=heLGPqladlAigJNybKtTs/DEkttCx2/JvhSWZesN4ljl/bRke/dwgcCgojH17uMbRl8zJC
        IIQHw0PzzlO4IxxcspfnhjQt/nMT1qGe60HXkFci0P6QBAkcrlCb7SnniSw2CJkFW3MTsn
        93gIhnB3bbD7xcusZMEhQsDEh+XT0lU=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-SgFghtwZOTq8SE2B0TScfA-1; Tue, 12 Jul 2022 04:19:27 -0400
X-MC-Unique: SgFghtwZOTq8SE2B0TScfA-1
Received: by mail-qv1-f71.google.com with SMTP id q3-20020ad45743000000b004735457f428so1432918qvx.23
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:19:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=iPp5jgjHJIx534pLAzg6KfoArYEXjlp6G9pthy1s5kM=;
        b=KrGVMoE5DU3Jt1AHAF5DEGAkJ6hL84br2LfoyOY24fVk/AyIVUUMLcEujxSbGkwNEA
         ZBRSmuGz8DmPCNhKz4+RFQ9YgXhZnkRTnrCA8FviqcVlLCopV+dNkPKuND2hs3WURnDE
         sTB3oduQpkrSTOU6HqfPmOtlkkkliRqTn8CvqBQtfrszJuFSw+FsKQK70nBdfsMRaYFN
         S8d7ND/p2Zlf7dQ0xbp+3XqJUKXbhEnQADhQ7tuGdhksjsAEJYxaHQsOhiBaxz3b94SZ
         R80nXhVd+zicce66Y8QPTLB8cE5e3VB4VK1ye6I79V6Z93810kD28oAdMNTeYwd/wzlG
         I9qA==
X-Gm-Message-State: AJIora/fmrDHk+gqrwiLBfw0tkXcVYjN3cAFOsLzVyoDtGXItEWhYmLq
        Tb6LJjeKN5/9M3w2kyjDyGjm3kNf6eTgiF0amr7y61JslxGhB3pclDRl3c6a3rulNHG9T6K3SmE
        lAl0hgVYds6EZenVn
X-Received: by 2002:ae9:d8c1:0:b0:6b5:7f9b:d978 with SMTP id u184-20020ae9d8c1000000b006b57f9bd978mr7073495qkf.676.1657613967327;
        Tue, 12 Jul 2022 01:19:27 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vkeQTewSYF2/3C7zXOeUvZi/wu7F3ucX49b3AAYPCCCRjDVLrtqiGu6Q6iScUaU/e2S3hFIQ==
X-Received: by 2002:ae9:d8c1:0:b0:6b5:7f9b:d978 with SMTP id u184-20020ae9d8c1000000b006b57f9bd978mr7073485qkf.676.1657613967058;
        Tue, 12 Jul 2022 01:19:27 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id f17-20020ac84991000000b002f93ece0df3sm6859143qtq.71.2022.07.12.01.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 01:19:26 -0700 (PDT)
Message-ID: <9fb5e3df069db50396799a250c4db761b1505dd3.camel@redhat.com>
Subject: Re: [PATCH net 2/2] selftests/net: test nexthop without gw
From:   Paolo Abeni <pabeni@redhat.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Tue, 12 Jul 2022 10:19:23 +0200
In-Reply-To: <20220706160526.31711-2-nicolas.dichtel@6wind.com>
References: <20220706160526.31711-1-nicolas.dichtel@6wind.com>
         <20220706160526.31711-2-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-07-06 at 18:05 +0200, Nicolas Dichtel wrote:
> This test implement the scenario described in the previous patch.
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  tools/testing/selftests/net/Makefile          |   2 +-
>  .../selftests/net/fib_nexthop_nongw.sh        | 125 ++++++++++++++++++
>  2 files changed, 126 insertions(+), 1 deletion(-)
>  create mode 100755 tools/testing/selftests/net/fib_nexthop_nongw.sh
> 
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index ddad703ace34..db05b3764b77 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -11,7 +11,7 @@ TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
>  TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
>  TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
>  TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh traceroute.sh
> -TEST_PROGS += fin_ack_lat.sh fib_nexthop_multiprefix.sh fib_nexthops.sh
> +TEST_PROGS += fin_ack_lat.sh fib_nexthop_multiprefix.sh fib_nexthops.sh fib_nexthop_nongw.sh
>  TEST_PROGS += altnames.sh icmp.sh icmp_redirect.sh ip6_gre_headroom.sh
>  TEST_PROGS += route_localnet.sh
>  TEST_PROGS += reuseaddr_ports_exhausted.sh
> diff --git a/tools/testing/selftests/net/fib_nexthop_nongw.sh b/tools/testing/selftests/net/fib_nexthop_nongw.sh
> new file mode 100755
> index 000000000000..6e82562eaf4a
> --- /dev/null
> +++ b/tools/testing/selftests/net/fib_nexthop_nongw.sh
> @@ -0,0 +1,125 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# ns: h1               | ns: h2           

Trailing whitespace above

> +#   192.168.0.1/24     |
> +#            eth0      |
> +#                      |       192.168.1.1/32
> +#            veth0 <---|---> veth1        

same here.

> +# Validate source address selection for route without gateway
> +
> +PAUSE_ON_FAIL=no
> +VERBOSE=0
> +ret=0
> +
> +################################################################################
> +# helpers
> +
> +log_test()
> +{
> +	local rc=$1
> +	local expected=$2
> +	local msg="$3"
> +
> +	if [ ${rc} -eq ${expected} ]; then
> +		printf "TEST: %-60s  [ OK ]\n" "${msg}"
> +		nsuccess=$((nsuccess+1))
> +	else
> +		ret=1
> +		nfail=$((nfail+1))
> +		printf "TEST: %-60s  [FAIL]\n" "${msg}"
> +		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
> +			echo
> +			echo "hit enter to continue, 'q' to quit"
> +			read a
> +			[ "$a" = "q" ] && exit 1
> +		fi
> +	fi
> +
> +	[ "$VERBOSE" = "1" ] && echo
> +}
> +
> +run_cmd()
> +{
> +	local cmd="$*"
> +	local out
> +	local rc
> +
> +	if [ "$VERBOSE" = "1" ]; then
> +		echo "COMMAND: $cmd"
> +	fi
> +
> +	out=$(eval $cmd 2>&1)
> +	rc=$?
> +	if [ "$VERBOSE" = "1" -a -n "$out" ]; then
> +		echo "$out"
> +	fi
> +
> +	[ "$VERBOSE" = "1" ] && echo
> +
> +	return $rc
> +}
> +
> +################################################################################
> +# config
> +setup()
> +{
> +	ip netns add h1
> +	ip -n h1 link set lo up
> +	ip netns add h2
> +	ip -n h2 link set lo up
> +	sleep 1

Why is this needed here? same question for the 'sleep 2' after the
setup.

> +
> +	# Add a fake eth0 to support an ip address
> +	ip -n h1 link add name eth0 type dummy
> +	ip -n h1 link set eth0 up
> +	ip -n h1 address add 192.168.0.1/24 dev eth0
> +
> +	# Configure veths (same @mac, arp off)
> +	ip -n h1 link add name veth0 type veth peer name veth1 netns h2
> +	ip -n h1 link set veth0 address 00:09:c0:26:05:82
> +	ip -n h1 link set veth0 arp off

As in the example in the previous commit, I suggest to drop the
apparently not relevant  'arp off'/ static macs 

> +	ip -n h1 link set veth0 up
> +
> +	ip -n h2 link set veth1 address 00:09:c0:26:05:82
> +	ip -n h2 link set veth1 arp off
> +	ip -n h2 link set veth1 up
> +
> +	# Configure @IP in the peer netns
> +	ip -n h2 address add 192.168.1.1/32 dev veth1
> +	ip -n h2 route add default dev veth1
> +
> +	# Add a nexthop without @gw and use it in a route
> +	ip -n h1 nexthop add id 1 dev veth0
> +	ip -n h1 route add 192.168.1.1 nhid 1
> +}
> +
> +cleanup()
> +{
> +	ip netns del h1 2>/dev/null
> +	ip netns del h2 2>/dev/null
> +}

This become more roboust if you add a

trap cleanup EXIT

additionally, with the above you could remove the explicit cleanups
below

> +
> +################################################################################
> +# main
> +
> +while getopts :pv o
> +do
> +	case $o in
> +		p) PAUSE_ON_FAIL=yes;;
> +		v) VERBOSE=1;;
> +	esac
> +done
> +
> +cleanup
> +setup
> +sleep 2
> +
> +run_cmd ip -netns h1 route get 192.168.1.1
> +log_test $? 0 "nexthop: get route with nexthop without gw"
> +run_cmd ip netns exec h1 ping -c1 192.168.1.1
> +log_test $? 0 "nexthop: ping through nexthop without gw"
> +
> +cleanup
> +
> +exit $ret

