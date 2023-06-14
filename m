Return-Path: <netdev+bounces-10568-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F7372F180
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:18:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B83A62812D6
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 01:18:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16CA37E;
	Wed, 14 Jun 2023 01:17:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FE57F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 01:17:58 +0000 (UTC)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4576195;
	Tue, 13 Jun 2023 18:17:56 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Qgnbk0V6Nz4x3k;
	Wed, 14 Jun 2023 11:17:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1686705475;
	bh=J9toyfhL4eKZ2nOiRZ1A5QhRm5TKOvzbGRDzh58r3Ks=;
	h=Date:From:To:Cc:Subject:From;
	b=lMN1CmnT2Q6v7a0fcOJuc17JJpUuLOlZ61Nn0PuE2KDXwtm5UQCd4l1KNhtwIne+v
	 bKhzf+tS9vA62DoS0TGwGnhoet4zHONycfH/3BbJBuBeLm7Q5RAjKAvQlyl1F5wRHo
	 YrTCbP0cJLIjbJ3wPdGmXuB6++MCOQPpjkdGCwCH3ud+YtS26hr6YJTU+be8tcJUX+
	 7fACxHpgF0f55HAAXSZIx1Eh1h4XVD/Vx3G30EpmP93SEX1h0ilW2Qb6uyl4tPS7J3
	 qg24grpkVQCcv/ld5t1opVx5AcLDQQJMW0XplJCKtx+Ex4YsLHSO8YbOD5j72YuY/k
	 /1jJPf2JPGPZg==
Date: Wed, 14 Jun 2023 11:17:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: Networking <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>, Mat Martineau
 <martineau@kernel.org>, Matthieu Baerts <matthieu.baerts@tessares.net>,
 Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230614111752.74207e28@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Q/YHspEDIqA.3mwSfqLZWxX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/Q/YHspEDIqA.3mwSfqLZWxX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/net/mptcp/mptcp_join.sh

between commits:

  47867f0a7e83 ("selftests: mptcp: join: skip check if MIB counter not supp=
orted")
  425ba803124b ("selftests: mptcp: join: support RM_ADDR for used endpoints=
 or not")

from the net tree and commits:

  45b1a1227a7a ("mptcp: introduces more address related mibs")
  0639fa230a21 ("selftests: mptcp: add explicit check for new mibs")

from the net-next tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
This is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/testing/selftests/net/mptcp/mptcp_join.sh
index 0ae8cafde439,85474e029784..000000000000
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@@ -1360,27 -1265,23 +1355,25 @@@ chk_fclose_nr(
  	fi
 =20
  	printf "%-${nr_blank}s %s" " " "ctx"
 -	count=3D$(ip netns exec $ns_tx nstat -as | grep MPTcpExtMPFastcloseTx | =
awk '{print $2}')
 -	[ -z "$count" ] && count=3D0
 -	[ "$count" !=3D "$fclose_tx" ] && extra_msg=3D"$extra_msg,tx=3D$count"
 -	if [ "$count" !=3D "$fclose_tx" ]; then
 +	count=3D$(get_counter ${ns_tx} "MPTcpExtMPFastcloseTx")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" !=3D "$fclose_tx" ]; then
 +		extra_msg=3D"$extra_msg,tx=3D$count"
  		echo "[fail] got $count MP_FASTCLOSE[s] TX expected $fclose_tx"
  		fail_test
- 		dump_stats=3D1
  	else
  		echo -n "[ ok ]"
  	fi
 =20
  	echo -n " - fclzrx"
 -	count=3D$(ip netns exec $ns_rx nstat -as | grep MPTcpExtMPFastcloseRx | =
awk '{print $2}')
 -	[ -z "$count" ] && count=3D0
 -	[ "$count" !=3D "$fclose_rx" ] && extra_msg=3D"$extra_msg,rx=3D$count"
 -	if [ "$count" !=3D "$fclose_rx" ]; then
 +	count=3D$(get_counter ${ns_rx} "MPTcpExtMPFastcloseRx")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" !=3D "$fclose_rx" ]; then
 +		extra_msg=3D"$extra_msg,rx=3D$count"
  		echo "[fail] got $count MP_FASTCLOSE[s] RX expected $fclose_rx"
  		fail_test
- 		dump_stats=3D1
  	else
  		echo -n "[ ok ]"
  	fi
@@@ -1408,25 -1306,21 +1398,23 @@@ chk_rst_nr(
  	fi
 =20
  	printf "%-${nr_blank}s %s" " " "rtx"
 -	count=3D$(ip netns exec $ns_tx nstat -as | grep MPTcpExtMPRstTx | awk '{=
print $2}')
 -	[ -z "$count" ] && count=3D0
 -	if [ $count -lt $rst_tx ]; then
 +	count=3D$(get_counter ${ns_tx} "MPTcpExtMPRstTx")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ $count -lt $rst_tx ]; then
  		echo "[fail] got $count MP_RST[s] TX expected $rst_tx"
  		fail_test
- 		dump_stats=3D1
  	else
  		echo -n "[ ok ]"
  	fi
 =20
  	echo -n " - rstrx "
 -	count=3D$(ip netns exec $ns_rx nstat -as | grep MPTcpExtMPRstRx | awk '{=
print $2}')
 -	[ -z "$count" ] && count=3D0
 -	if [ "$count" -lt "$rst_rx" ]; then
 +	count=3D$(get_counter ${ns_rx} "MPTcpExtMPRstRx")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" -lt "$rst_rx" ]; then
  		echo "[fail] got $count MP_RST[s] RX expected $rst_rx"
  		fail_test
- 		dump_stats=3D1
  	else
  		echo -n "[ ok ]"
  	fi
@@@ -1441,28 -1333,23 +1427,25 @@@ chk_infi_nr(
  	local infi_tx=3D$1
  	local infi_rx=3D$2
  	local count
- 	local dump_stats
 =20
  	printf "%-${nr_blank}s %s" " " "itx"
 -	count=3D$(ip netns exec $ns2 nstat -as | grep InfiniteMapTx | awk '{prin=
t $2}')
 -	[ -z "$count" ] && count=3D0
 -	if [ "$count" !=3D "$infi_tx" ]; then
 +	count=3D$(get_counter ${ns2} "MPTcpExtInfiniteMapTx")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" !=3D "$infi_tx" ]; then
  		echo "[fail] got $count infinite map[s] TX expected $infi_tx"
  		fail_test
- 		dump_stats=3D1
  	else
  		echo -n "[ ok ]"
  	fi
 =20
  	echo -n " - infirx"
 -	count=3D$(ip netns exec $ns1 nstat -as | grep InfiniteMapRx | awk '{prin=
t $2}')
 -	[ -z "$count" ] && count=3D0
 -	if [ "$count" !=3D "$infi_rx" ]; then
 +	count=3D$(get_counter ${ns1} "MPTcpExtInfiniteMapRx")
 +	if [ -z "$count" ]; then
 +		echo "[skip]"
 +	elif [ "$count" !=3D "$infi_rx" ]; then
  		echo "[fail] got $count infinite map[s] RX expected $infi_rx"
  		fail_test
- 		dump_stats=3D1
  	else
  		echo "[ ok ]"
  	fi
@@@ -1491,13 -1375,11 +1471,12 @@@ chk_join_nr(
  	fi
 =20
  	printf "%03u %-36s %s" "${TEST_COUNT}" "${title}" "syn"
 -	count=3D$(ip netns exec $ns1 nstat -as | grep MPTcpExtMPJoinSynRx | awk =
'{print $2}')
 -	[ -z "$count" ] && count=3D0
 -	if [ "$count" !=3D "$syn_nr" ]; then
 +	count=3D$(get_counter ${ns1} "MPTcpExtMPJoinSynRx")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" !=3D "$syn_nr" ]; then
  		echo "[fail] got $count JOIN[s] syn expected $syn_nr"
  		fail_test
- 		dump_stats=3D1
  	else
  		echo -n "[ ok ]"
  	fi
@@@ -1523,13 -1403,11 +1501,12 @@@
  	fi
 =20
  	echo -n " - ack"
 -	count=3D$(ip netns exec $ns1 nstat -as | grep MPTcpExtMPJoinAckRx | awk =
'{print $2}')
 -	[ -z "$count" ] && count=3D0
 -	if [ "$count" !=3D "$ack_nr" ]; then
 +	count=3D$(get_counter ${ns1} "MPTcpExtMPJoinAckRx")
 +	if [ -z "$count" ]; then
 +		echo "[skip]"
 +	elif [ "$count" !=3D "$ack_nr" ]; then
  		echo "[fail] got $count JOIN[s] ack expected $ack_nr"
  		fail_test
- 		dump_stats=3D1
  	else
  		echo "[ ok ]"
  	fi
@@@ -1599,40 -1475,35 +1574,37 @@@ chk_add_nr(
  	timeout=3D$(ip netns exec $ns1 sysctl -n net.mptcp.add_addr_timeout)
 =20
  	printf "%-${nr_blank}s %s" " " "add"
 -	count=3D$(ip netns exec $ns2 nstat -as MPTcpExtAddAddr | grep MPTcpExtAd=
dAddr | awk '{print $2}')
 -	[ -z "$count" ] && count=3D0
 -
 +	count=3D$(get_counter ${ns2} "MPTcpExtAddAddr")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
  	# if the test configured a short timeout tolerate greater then expected
  	# add addrs options, due to retransmissions
 -	if [ "$count" !=3D "$add_nr" ] && { [ "$timeout" -gt 1 ] || [ "$count" -=
lt "$add_nr" ]; }; then
 +	elif [ "$count" !=3D "$add_nr" ] && { [ "$timeout" -gt 1 ] || [ "$count"=
 -lt "$add_nr" ]; }; then
  		echo "[fail] got $count ADD_ADDR[s] expected $add_nr"
  		fail_test
- 		dump_stats=3D1
  	else
  		echo -n "[ ok ]"
  	fi
 =20
  	echo -n " - echo  "
 -	count=3D$(ip netns exec $ns1 nstat -as MPTcpExtEchoAdd | grep MPTcpExtEc=
hoAdd | awk '{print $2}')
 -	[ -z "$count" ] && count=3D0
 -	if [ "$count" !=3D "$echo_nr" ]; then
 +	count=3D$(get_counter ${ns1} "MPTcpExtEchoAdd")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" !=3D "$echo_nr" ]; then
  		echo "[fail] got $count ADD_ADDR echo[s] expected $echo_nr"
  		fail_test
- 		dump_stats=3D1
  	else
  		echo -n "[ ok ]"
  	fi
 =20
  	if [ $port_nr -gt 0 ]; then
  		echo -n " - pt "
 -		count=3D$(ip netns exec $ns2 nstat -as | grep MPTcpExtPortAdd | awk '{p=
rint $2}')
 -		[ -z "$count" ] && count=3D0
 -		if [ "$count" !=3D "$port_nr" ]; then
 +		count=3D$(get_counter ${ns2} "MPTcpExtPortAdd")
 +		if [ -z "$count" ]; then
 +			echo "[skip]"
 +		elif [ "$count" !=3D "$port_nr" ]; then
  			echo "[fail] got $count ADD_ADDR[s] with a port-number expected $port_=
nr"
  			fail_test
- 			dump_stats=3D1
  		else
  			echo "[ ok ]"
  		fi
@@@ -1737,13 -1633,11 +1734,12 @@@ chk_rm_nr(
  	fi
 =20
  	printf "%-${nr_blank}s %s" " " "rm "
 -	count=3D$(ip netns exec $addr_ns nstat -as MPTcpExtRmAddr | grep MPTcpEx=
tRmAddr | awk '{print $2}')
 -	[ -z "$count" ] && count=3D0
 -	if [ "$count" !=3D "$rm_addr_nr" ]; then
 +	count=3D$(get_counter ${addr_ns} "MPTcpExtRmAddr")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" !=3D "$rm_addr_nr" ]; then
  		echo "[fail] got $count RM_ADDR[s] expected $rm_addr_nr"
  		fail_test
- 		dump_stats=3D1
  	else
  		echo -n "[ ok ]"
  	fi
@@@ -1767,12 -1661,12 +1763,10 @@@
  		else
  			echo "[fail] got $count RM_SUBFLOW[s] expected in range [$rm_subflow_n=
r:$((rm_subflow_nr*2))]"
  			fail_test
- 			dump_stats=3D1
  		fi
 -		return
 -	fi
 -	if [ "$count" !=3D "$rm_subflow_nr" ]; then
 +	elif [ "$count" !=3D "$rm_subflow_nr" ]; then
  		echo "[fail] got $count RM_SUBFLOW[s] expected $rm_subflow_nr"
  		fail_test
- 		dump_stats=3D1
  	else
  		echo -n "[ ok ]"
  	fi
@@@ -1787,28 -1696,23 +1796,25 @@@ chk_prio_nr(
  	local mp_prio_nr_tx=3D$1
  	local mp_prio_nr_rx=3D$2
  	local count
- 	local dump_stats
 =20
  	printf "%-${nr_blank}s %s" " " "ptx"
 -	count=3D$(ip netns exec $ns1 nstat -as | grep MPTcpExtMPPrioTx | awk '{p=
rint $2}')
 -	[ -z "$count" ] && count=3D0
 -	if [ "$count" !=3D "$mp_prio_nr_tx" ]; then
 +	count=3D$(get_counter ${ns1} "MPTcpExtMPPrioTx")
 +	if [ -z "$count" ]; then
 +		echo -n "[skip]"
 +	elif [ "$count" !=3D "$mp_prio_nr_tx" ]; then
  		echo "[fail] got $count MP_PRIO[s] TX expected $mp_prio_nr_tx"
  		fail_test
- 		dump_stats=3D1
  	else
  		echo -n "[ ok ]"
  	fi
 =20
  	echo -n " - prx   "
 -	count=3D$(ip netns exec $ns1 nstat -as | grep MPTcpExtMPPrioRx | awk '{p=
rint $2}')
 -	[ -z "$count" ] && count=3D0
 -	if [ "$count" !=3D "$mp_prio_nr_rx" ]; then
 +	count=3D$(get_counter ${ns1} "MPTcpExtMPPrioRx")
 +	if [ -z "$count" ]; then
 +		echo "[skip]"
 +	elif [ "$count" !=3D "$mp_prio_nr_rx" ]; then
  		echo "[fail] got $count MP_PRIO[s] RX expected $mp_prio_nr_rx"
  		fail_test
- 		dump_stats=3D1
  	else
  		echo "[ ok ]"
  	fi
@@@ -2394,12 -2290,8 +2399,13 @@@ remove_tests(
  		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
  		run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
  		chk_join_nr 3 3 3
+ 		chk_rm_tx_nr 0
 -		chk_rm_nr 0 3 simult
 +
 +		if mptcp_lib_kversion_ge 5.18; then
 +			chk_rm_nr 0 3 simult
 +		else
 +			chk_rm_nr 3 3
 +		fi
  	fi
 =20
  	# addresses flush

--Sig_/Q/YHspEDIqA.3mwSfqLZWxX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmSJFUAACgkQAVBC80lX
0GyUoAf/fGUwMb0wGRJlKcs1HMK7t6CtPMbVRUoItmxIh6EDlixMkgqWQCkts070
MjmI/pZdFQUbOIe/IwBFKczKJjjVzliBPHLwZUvoRQCLLNM60+3ta5EjVMXhKxj/
Dz/tWcUHWtiE1CjpvyOhqtycprRTOMjg8/7Pr8UdbMRSTn0Fv4cQ6fc1THAgWm6G
VIHU8xcLpzAUNs22iNhGhRWoPR5scHWHqu3Gdf1EF2/Eq7bnsv1aAfW0yNAM9R+2
he6y92YzgFRzime1XOg74Qc/lCx3WevXcc0Gq+jjRJiqnof4M5e2OeCK4nFlIM8B
dR7fFlcFHFQJcAwWy/eUDlZPvF7YQg==
=Hl5+
-----END PGP SIGNATURE-----

--Sig_/Q/YHspEDIqA.3mwSfqLZWxX--

