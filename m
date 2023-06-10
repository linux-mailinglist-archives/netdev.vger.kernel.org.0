Return-Path: <netdev+bounces-9816-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BABC72ACD0
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 18:11:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D0DF2815E9
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 16:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 402D81D2B4;
	Sat, 10 Jun 2023 16:11:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABDF1B91D
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 16:11:49 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AC530E4
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:11:46 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-3094910b150so2772422f8f.0
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686413505; x=1689005505;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uUYYZPcvciNFgnRf680pyk/9lujDfhF8dXOMi/HseDo=;
        b=o1JDm1t71GcXhw/+n0S3+s+Q/mNoFoizM70FRSmPnSYWC96oUKBdNVU1ThNCWIq0Jt
         r9jnK2mPzXAtGCFaTLD32VD18v7d/hsMVidUIAw0CIJUIYPvKrUmJ14D8iU1aYVeXtri
         25DxNXjRICSiDm58ZnTkJEawKb1EEsbcfME12xt1MfXOXGoW5GgvfcAZe6k+b//Y9Mcf
         ixxj/0KeXn53Xvf/YIGOBauWz9EpOFTQGr7/PJ2NExufqff0tq8/nhX9kuEpLkOt6NOB
         KW4AdNW/lSz0UuR6EqfknSlFDRtqRkarSVuEQkPy9/K58ozjgkHT8kvcBkQjTNBZtpgv
         +7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686413505; x=1689005505;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uUYYZPcvciNFgnRf680pyk/9lujDfhF8dXOMi/HseDo=;
        b=MGcZ7smBH2Y17Lr2NBAhlciLE9anKQ7ng0qqONOopKWYFBQDobYfFLbfjHjKR0sD1M
         DaWhxa7YDS5zRxcmpPUHyGkjPAwIlB5se55hqCi+WXVkx7Pux9y7Z22+9ZsdZKaXAYLr
         tO6I9U+iNG059YNfLhjnnpAR1o6XkHOdqaqd+6/qO9aPwNGJziHtpEgTjALxn0Q+pDLW
         cT77FWSsOH10RPuV/3+8a72RCvkX/3kWZ8Gb97nEzlqKmNH7ii3vU+kzlRYHpx+P7kxj
         MQzxI0yfcNO4Q6FtPgTEpobQ2UIZEhxql+EkWob9CSzpELa8J5isf5fC/jTuDezn8FWn
         qevw==
X-Gm-Message-State: AC+VfDxwuKlGV4Me0dXf1yv8CDqpwvBF6YiAcRT1ZEyTngjiuZsfJNR4
	h8PsyL+4lz8NDZVlgkiCQZd5Kg==
X-Google-Smtp-Source: ACHHUZ78sZeLv/CBSLZbakTH8nbekOYxuGkfjeGyB16kAhSNtwf93GHc3AWwxLEwO2GXbt1dQZQSxA==
X-Received: by 2002:adf:f642:0:b0:30d:5f9e:c29f with SMTP id x2-20020adff642000000b0030d5f9ec29fmr1542855wrp.37.1686413504568;
        Sat, 10 Jun 2023 09:11:44 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id u9-20020a5d4349000000b003079c402762sm7431145wrr.19.2023.06.10.09.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 09:11:44 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net 00/17] selftests: mptcp: skip tests not supported by
 old kernels (part 3)
Date: Sat, 10 Jun 2023 18:11:35 +0200
Message-Id: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-0-2896fe2ee8a3@tessares.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALeghGQC/yWOwQ6CMBBEf4Xs2Y0FUhV/xXhYYJFGKJtuISaEf
 7fV47yZzMwOysGxwr3YIfDm1C0+ifJUQDeSfzG6PmmoTFWbi2lwFY2BaUbPEf+0NDhL7ASVpyG
 yRkVdRZYQcZl6fHPwPCkKJVBjfSWy5c1yYy2kmZaUsQ3kuzEPpdqet9x+nsn5nJDAg/v8Tj6yD
 8/j+AKCWJSNuQAAAA==
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>, 
 Davide Caratti <dcaratti@redhat.com>, Christoph Paasch <cpaasch@apple.com>, 
 Geliang Tang <geliangtang@gmail.com>, Geliang Tang <geliang.tang@suse.com>
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 Matthieu Baerts <matthieu.baerts@tessares.net>, stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=15174;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=yqmJ0o+0e/leYDUJ5OFyXMVFfIV2lhXvJPwEAwbinkI=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkhKC9vK4vJe5k9TBdxQQZ9IkPxQqhpmmKG7O/O
 jR6GKIHwpmJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZISgvQAKCRD2t4JPQmmg
 c47dEACD1i+EM9Okzy8Qf+UYRQojaLXQbTMreyA1hiAVpaqBIjKz6NMAiObUHAmhFAhiqsDIO2N
 T7ALbGk/Pk+Jjl4SEhZ95lXjoBKVFlYw4SsGn0UfkOuJcoP+xsxIsDcVOR4znPS3u8xhCOO/xip
 LXAmYQWj7BX/XLa+g3/zjZuUH0PjQ4J7QOwmQUAtFPYe1zRP/UUuOU1Ps2IhW62Wxemr134k88Y
 6xNfUGcYCFjcxgP0YrTGvNPELb6wQLlm/w9LxRk/UxSgKw69ZtppEqbIJvMcnb8eCsVjxvjv+E8
 1GOEv9y/J/HIXNQd0NLrvA0nCJsn6f4SyTAV6JuhzRNN+qF0Q8fH7MsuhawPTN0Ou3RUh+eJL5t
 CgvakH1ifrtgwSdvmQ2/JPstStymo1TejsKCHwx2aF/CBkvu7Usv288WsTm4tYeVt1m379nVTjV
 EutwY3VqwAYaByL7ETDZ9/mgfnb2G9/panSkTdjibDiB5pQKwlVq8dY4cTnbjW3NoKctuEM8FWK
 bp+pYxBmvJ0C7GMBpAt8Dm0BJ8ENLdoY8jcOLTOMihl7Ij0c5QV2s5jdwpeuvYmklB3Hc1uxd1C
 1OgsNcUygb1BKUh953zSHYxFgI1/XHcGF93Pr0YKqKvVdl6OnsfLK7ZIEZexjQS0ojfGDLXf5xb
 OVgP6SEBnq142ww==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

After a few years of increasing test coverage in the MPTCP selftests, we
realised [1] the last version of the selftests is supposed to run on old
kernels without issues.

Supporting older versions is not that easy for this MPTCP case: these
selftests are often validating the internals by checking packets that
are exchanged, when some MIB counters are incremented after some
actions, how connections are getting opened and closed in some cases,
etc. In other words, it is not limited to the socket interface between
the userspace and the kernelspace.

In addition to that, the current MPTCP selftests run a lot of different
sub-tests but the TAP13 protocol used in the selftests don't support
sub-tests: one failure in sub-tests implies that the whole selftest is
seen as failed at the end because sub-tests are not tracked. It is then
important to skip sub-tests not supported by old kernels.

To minimise the modifications and reduce the complexity to support old
versions, the idea is to look at external signs and skip the whole
selftest or just some sub-tests before starting them. This cannot be
applied in all cases.

Similar to the second part, this third one focuses on marking different
sub-tests as skipped if some MPTCP features are not supported. This
time, only in "mptcp_join.sh" selftest, the remaining one, is modified.
Several techniques are used here to achieve this task:

- Before starting some tests:

  - Check if a file (sysctl knob) is present: that's what patch 12/17 is
    doing for the userspace PM feature.

  - Check if a required kernel symbol is present in /proc/kallsyms:
    patches 9, 10, 14 and 15/17 are using this technique.

  - Check if it is possible to setup a particular network environment
    requiring Netfilter or TC: if the preparation step fail, the linked
    sub-test is marked as skipped. Patch 5/17 is doing that.

  - Check if a MIB counter is available: patches 7 and 13/17 do that.

  - Check if the kernel version is newer than a specific one: patch 1/17
    adds some helpers in mptcp_lib.sh to ease its use. That's not ideal
    and it is only used as last resort but as mentioned above, it is
    important to skip tests if they are not supported not to have the
    whole selftest always being marked as failed on old kernels. Patches
    11 and 17/17 are checking the kernel version. An alternative would
    be to ignore the results for some sub-tests but that's not ideal
    too. Note that SELFTESTS_MPTCP_LIB_NO_KVERSION_CHECK env var can be
    set to 1 not to skip these tests if the running kernel doesn't have
    a supported version.

- After having launched the tests:

  - Adapt the expectations depending on the presence of a kernel symbol
    (patch 6/17) or a kernel version (patch 8/17).

  - Check is a MIB counter is available and skip the verification if
    not. Patch 4/17 is using this technique.

Before skipping tests, SELFTESTS_MPTCP_LIB_EXPECT_ALL_FEATURES env var
value is checked: if it is set to 1, the test is marked as "failed"
instead of "skipped". MPTCP public CI expects to have all features
supported and it sets this env var to 1 to catch regressions in these
new checks.

Patch 2/17 uses 'iptables-legacy' if available because it might be
needed when using an older kernel not supporting iptables-nft.

Patch 3/17 adds some helpers used in the other patches mentioned to
easily mark sub-tests as skipped.

Patch 16/17 uniforms MPTCP Join "listener" tests: it was imported code
from userspace_pm.sh but without using the "code style" and ways of
using tools and printing messages from MPTCP Join selftest.

Link: https://lore.kernel.org/stable/CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com/ [1]
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
Note that it is supposed to be the last series on this subject for -net.

Also, this will conflict with commit 0639fa230a21 ("selftests: mptcp:
add explicit check for new mibs") that is currently in net-next but not
in -net. Here is the resolution. It is a bit long but you will see, it
is simple: take the version from -net with get_counter() and for the
last one, move the new call to chk_rm_tx_nr() inside the 'if' statement:

------------------- 8< -------------------
diff --cc tools/testing/selftests/net/mptcp/mptcp_join.sh
index 0ae8cafde439,85474e029784..bd47cdc2bd15
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@@ -1360,27 -1265,23 +1355,25 @@@ chk_fclose_nr(
  	fi
  
  	printf "%-${nr_blank}s %s" " " "ctx"
 -	count=$(ip netns exec $ns_tx nstat -as | grep MPTcpExtMPFastcloseTx | awk '{print $2}')
 -	[ -z "$count" ] && count=0
 -	[ "$count" != "$fclose_tx" ] && extra_msg="$extra_msg,tx=$count"
 -	if [ "$count" != "$fclose_tx" ]; then
 +	count=$(get_counter ${ns_tx} "MPTcpExtMPFastcloseTx")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" != "$fclose_tx" ]; then
 +		extra_msg="$extra_msg,tx=$count"
  		echo "[fail] got $count MP_FASTCLOSE[s] TX expected $fclose_tx"
  		fail_test
- 		dump_stats=1
  	else
  		echo -n "[ ok ]"
  	fi
  
  	echo -n " - fclzrx"
 -	count=$(ip netns exec $ns_rx nstat -as | grep MPTcpExtMPFastcloseRx | awk '{print $2}')
 -	[ -z "$count" ] && count=0
 -	[ "$count" != "$fclose_rx" ] && extra_msg="$extra_msg,rx=$count"
 -	if [ "$count" != "$fclose_rx" ]; then
 +	count=$(get_counter ${ns_rx} "MPTcpExtMPFastcloseRx")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" != "$fclose_rx" ]; then
 +		extra_msg="$extra_msg,rx=$count"
  		echo "[fail] got $count MP_FASTCLOSE[s] RX expected $fclose_rx"
  		fail_test
- 		dump_stats=1
  	else
  		echo -n "[ ok ]"
  	fi
@@@ -1408,25 -1306,21 +1398,23 @@@ chk_rst_nr(
  	fi
  
  	printf "%-${nr_blank}s %s" " " "rtx"
 -	count=$(ip netns exec $ns_tx nstat -as | grep MPTcpExtMPRstTx | awk '{print $2}')
 -	[ -z "$count" ] && count=0
 -	if [ $count -lt $rst_tx ]; then
 +	count=$(get_counter ${ns_tx} "MPTcpExtMPRstTx")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ $count -lt $rst_tx ]; then
  		echo "[fail] got $count MP_RST[s] TX expected $rst_tx"
  		fail_test
- 		dump_stats=1
  	else
  		echo -n "[ ok ]"
  	fi
  
  	echo -n " - rstrx "
 -	count=$(ip netns exec $ns_rx nstat -as | grep MPTcpExtMPRstRx | awk '{print $2}')
 -	[ -z "$count" ] && count=0
 -	if [ "$count" -lt "$rst_rx" ]; then
 +	count=$(get_counter ${ns_rx} "MPTcpExtMPRstRx")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" -lt "$rst_rx" ]; then
  		echo "[fail] got $count MP_RST[s] RX expected $rst_rx"
  		fail_test
- 		dump_stats=1
  	else
  		echo -n "[ ok ]"
  	fi
@@@ -1441,28 -1333,23 +1427,25 @@@ chk_infi_nr(
  	local infi_tx=$1
  	local infi_rx=$2
  	local count
- 	local dump_stats
  
  	printf "%-${nr_blank}s %s" " " "itx"
 -	count=$(ip netns exec $ns2 nstat -as | grep InfiniteMapTx | awk '{print $2}')
 -	[ -z "$count" ] && count=0
 -	if [ "$count" != "$infi_tx" ]; then
 +	count=$(get_counter ${ns2} "MPTcpExtInfiniteMapTx")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" != "$infi_tx" ]; then
  		echo "[fail] got $count infinite map[s] TX expected $infi_tx"
  		fail_test
- 		dump_stats=1
  	else
  		echo -n "[ ok ]"
  	fi
  
  	echo -n " - infirx"
 -	count=$(ip netns exec $ns1 nstat -as | grep InfiniteMapRx | awk '{print $2}')
 -	[ -z "$count" ] && count=0
 -	if [ "$count" != "$infi_rx" ]; then
 +	count=$(get_counter ${ns1} "MPTcpExtInfiniteMapRx")
 +	if [ -z "$count" ]; then
 +		echo "[skip]"
 +	elif [ "$count" != "$infi_rx" ]; then
  		echo "[fail] got $count infinite map[s] RX expected $infi_rx"
  		fail_test
- 		dump_stats=1
  	else
  		echo "[ ok ]"
  	fi
@@@ -1491,13 -1375,11 +1471,12 @@@ chk_join_nr(
  	fi
  
  	printf "%03u %-36s %s" "${TEST_COUNT}" "${title}" "syn"
 -	count=$(ip netns exec $ns1 nstat -as | grep MPTcpExtMPJoinSynRx | awk '{print $2}')
 -	[ -z "$count" ] && count=0
 -	if [ "$count" != "$syn_nr" ]; then
 +	count=$(get_counter ${ns1} "MPTcpExtMPJoinSynRx")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" != "$syn_nr" ]; then
  		echo "[fail] got $count JOIN[s] syn expected $syn_nr"
  		fail_test
- 		dump_stats=1
  	else
  		echo -n "[ ok ]"
  	fi
@@@ -1523,13 -1403,11 +1501,12 @@@
  	fi
  
  	echo -n " - ack"
 -	count=$(ip netns exec $ns1 nstat -as | grep MPTcpExtMPJoinAckRx | awk '{print $2}')
 -	[ -z "$count" ] && count=0
 -	if [ "$count" != "$ack_nr" ]; then
 +	count=$(get_counter ${ns1} "MPTcpExtMPJoinAckRx")
 +	if [ -z "$count" ]; then
 +		echo "[skip]"
 +	elif [ "$count" != "$ack_nr" ]; then
  		echo "[fail] got $count JOIN[s] ack expected $ack_nr"
  		fail_test
- 		dump_stats=1
  	else
  		echo "[ ok ]"
  	fi
@@@ -1599,40 -1475,35 +1574,37 @@@ chk_add_nr(
  	timeout=$(ip netns exec $ns1 sysctl -n net.mptcp.add_addr_timeout)
  
  	printf "%-${nr_blank}s %s" " " "add"
 -	count=$(ip netns exec $ns2 nstat -as MPTcpExtAddAddr | grep MPTcpExtAddAddr | awk '{print $2}')
 -	[ -z "$count" ] && count=0
 -
 +	count=$(get_counter ${ns2} "MPTcpExtAddAddr")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
  	# if the test configured a short timeout tolerate greater then expected
  	# add addrs options, due to retransmissions
 -	if [ "$count" != "$add_nr" ] && { [ "$timeout" -gt 1 ] || [ "$count" -lt "$add_nr" ]; }; then
 +	elif [ "$count" != "$add_nr" ] && { [ "$timeout" -gt 1 ] || [ "$count" -lt "$add_nr" ]; }; then
  		echo "[fail] got $count ADD_ADDR[s] expected $add_nr"
  		fail_test
- 		dump_stats=1
  	else
  		echo -n "[ ok ]"
  	fi
  
  	echo -n " - echo  "
 -	count=$(ip netns exec $ns1 nstat -as MPTcpExtEchoAdd | grep MPTcpExtEchoAdd | awk '{print $2}')
 -	[ -z "$count" ] && count=0
 -	if [ "$count" != "$echo_nr" ]; then
 +	count=$(get_counter ${ns1} "MPTcpExtEchoAdd")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" != "$echo_nr" ]; then
  		echo "[fail] got $count ADD_ADDR echo[s] expected $echo_nr"
  		fail_test
- 		dump_stats=1
  	else
  		echo -n "[ ok ]"
  	fi
  
  	if [ $port_nr -gt 0 ]; then
  		echo -n " - pt "
 -		count=$(ip netns exec $ns2 nstat -as | grep MPTcpExtPortAdd | awk '{print $2}')
 -		[ -z "$count" ] && count=0
 -		if [ "$count" != "$port_nr" ]; then
 +		count=$(get_counter ${ns2} "MPTcpExtPortAdd")
 +		if [ -z "$count" ]; then
 +			echo "[skip]"
 +		elif [ "$count" != "$port_nr" ]; then
  			echo "[fail] got $count ADD_ADDR[s] with a port-number expected $port_nr"
  			fail_test
- 			dump_stats=1
  		else
  			echo "[ ok ]"
  		fi
@@@ -1737,13 -1633,11 +1734,12 @@@ chk_rm_nr(
  	fi
  
  	printf "%-${nr_blank}s %s" " " "rm "
 -	count=$(ip netns exec $addr_ns nstat -as MPTcpExtRmAddr | grep MPTcpExtRmAddr | awk '{print $2}')
 -	[ -z "$count" ] && count=0
 -	if [ "$count" != "$rm_addr_nr" ]; then
 +	count=$(get_counter ${addr_ns} "MPTcpExtRmAddr")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" != "$rm_addr_nr" ]; then
  		echo "[fail] got $count RM_ADDR[s] expected $rm_addr_nr"
  		fail_test
- 		dump_stats=1
  	else
  		echo -n "[ ok ]"
  	fi
@@@ -1767,12 -1661,12 +1763,10 @@@
  		else
  			echo "[fail] got $count RM_SUBFLOW[s] expected in range [$rm_subflow_nr:$((rm_subflow_nr*2))]"
  			fail_test
- 			dump_stats=1
  		fi
 -		return
 -	fi
 -	if [ "$count" != "$rm_subflow_nr" ]; then
 +	elif [ "$count" != "$rm_subflow_nr" ]; then
  		echo "[fail] got $count RM_SUBFLOW[s] expected $rm_subflow_nr"
  		fail_test
- 		dump_stats=1
  	else
  		echo -n "[ ok ]"
  	fi
@@@ -1787,28 -1696,23 +1796,25 @@@ chk_prio_nr(
  	local mp_prio_nr_tx=$1
  	local mp_prio_nr_rx=$2
  	local count
- 	local dump_stats
  
  	printf "%-${nr_blank}s %s" " " "ptx"
 -	count=$(ip netns exec $ns1 nstat -as | grep MPTcpExtMPPrioTx | awk '{print $2}')
 -	[ -z "$count" ] && count=0
 -	if [ "$count" != "$mp_prio_nr_tx" ]; then
 +	count=$(get_counter ${ns1} "MPTcpExtMPPrioTx")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" != "$mp_prio_nr_tx" ]; then
  		echo "[fail] got $count MP_PRIO[s] TX expected $mp_prio_nr_tx"
  		fail_test
- 		dump_stats=1
  	else
  		echo -n "[ ok ]"
  	fi
  
  	echo -n " - prx   "
 -	count=$(ip netns exec $ns1 nstat -as | grep MPTcpExtMPPrioRx | awk '{print $2}')
 -	[ -z "$count" ] && count=0
 -	if [ "$count" != "$mp_prio_nr_rx" ]; then
 +	count=$(get_counter ${ns1} "MPTcpExtMPPrioRx")
 +	if [ -z "$count" ]; then
 +		echo "[skip]"
 +	elif [ "$count" != "$mp_prio_nr_rx" ]; then
  		echo "[fail] got $count MP_PRIO[s] RX expected $mp_prio_nr_rx"
  		fail_test
- 		dump_stats=1
  	else
  		echo "[ ok ]"
  	fi
@@@ -2394,12 -2290,8 +2399,13 @@@ remove_tests(
  		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
  		run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
  		chk_join_nr 3 3 3
 -		chk_rm_tx_nr 0
 -		chk_rm_nr 0 3 simult
 +
 +		if mptcp_lib_kversion_ge 5.18; then
++			chk_rm_tx_nr 0
 +			chk_rm_nr 0 3 simult
 +		else
 +			chk_rm_nr 3 3
 +		fi
  	fi
  
  	# addresses flush
------------------- 8< -------------------

The resolved conflicts are also visible there:

  https://github.com/multipath-tcp/mptcp_net-next/blob/t/DO-NOT-MERGE-git-markup-fixes-net-next/tools/testing/selftests/net/mptcp/mptcp_join.sh

---
Matthieu Baerts (17):
      selftests: mptcp: lib: skip if not below kernel version
      selftests: mptcp: join: use 'iptables-legacy' if available
      selftests: mptcp: join: helpers to skip tests
      selftests: mptcp: join: skip check if MIB counter not supported
      selftests: mptcp: join: skip test if iptables/tc cmds fail
      selftests: mptcp: join: support local endpoint being tracked or not
      selftests: mptcp: join: skip Fastclose tests if not supported
      selftests: mptcp: join: support RM_ADDR for used endpoints or not
      selftests: mptcp: join: skip implicit tests if not supported
      selftests: mptcp: join: skip backup if set flag on ID not supported
      selftests: mptcp: join: skip fullmesh flag tests if not supported
      selftests: mptcp: join: skip userspace PM tests if not supported
      selftests: mptcp: join: skip fail tests if not supported
      selftests: mptcp: join: skip MPC backups tests if not supported
      selftests: mptcp: join: skip PM listener tests if not supported
      selftests: mptcp: join: uniform listener tests
      selftests: mptcp: join: skip mixed tests if not supported

 tools/testing/selftests/net/mptcp/mptcp_join.sh | 513 +++++++++++++++---------
 tools/testing/selftests/net/mptcp/mptcp_lib.sh  |  26 ++
 2 files changed, 354 insertions(+), 185 deletions(-)
---
base-commit: 1b8975f30abffc4f74f1ba049f9042e7d8f646cc
change-id: 20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-37aa5185e955

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>


