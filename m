Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D092F57E2E2
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 16:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbiGVOQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 10:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiGVOQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 10:16:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D1529827;
        Fri, 22 Jul 2022 07:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658499371; x=1690035371;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JlSYn4Mui826wm1Nd6hs9+Zfxu0wkADT0Nu/bb94P5I=;
  b=AhbEYXv0vCAkFU8E3g9f6mkocgPWBz80ttHZMwWV/Oz6dVgmwGzafOw5
   kwm6Uy4MhgfOxdB3c0hwpnEvB2dse4VPlLrUvfsfR/oEVXAMKNQ9u+Gjz
   RY33XsMnmhrR/B8mU//P7zGwSlR+jtjwqVMi2DZ4gPk1lSOpgA4eERmS9
   xOAr8uwh8MUuCpPZ8c1SOByApHGRP23QkZM2UZJPyh4fJ0vFkc+LJ6sYg
   ZK4Yuk0oaGJC1Ynzo2Kqal5VsJv22z8i2nd6ocDfbCxtVpsThxeJzCsNY
   wrT3WhQwrrakJKZ9kKIwi5zhZ5WF0hVA+Rtn6nYZxOqTfRP3mfNcWZugj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="373618694"
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="373618694"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 07:16:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="574179214"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga006.jf.intel.com with ESMTP; 22 Jul 2022 07:16:08 -0700
Date:   Fri, 22 Jul 2022 16:16:07 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Shibin Koikkara Reeny <shibin.koikkara.reeny@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org, andrii@kernel.org,
        ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next] selftests: xsk: Update poll test cases
Message-ID: <YtqxJ4f1osDc1Rtg@boxer>
References: <20220718095712.588513-1-shibin.koikkara.reeny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718095712.588513-1-shibin.koikkara.reeny@intel.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 09:57:12AM +0000, Shibin Koikkara Reeny wrote:
> Poll test case was not testing all the functionality
> of the poll feature in the testsuite. This patch
> update the poll test case with 2 more testcases to
> check the timeout features.
> 
> Poll test case have 4 sub test cases:

Hi Shibin,

Kinda not clear with count of added test cases, at first you say you add 2
more but then you mention something about 4 sub test cases.

To me these are separate test cases.

> 
> 1. TEST_TYPE_RX_POLL:
> Check if POLLIN function work as expect.
> 
> 2. TEST_TYPE_TX_POLL:
> Check if POLLOUT function work as expect.

From run_pkt_test, I don't see any difference between 1 and 2. Why split
then?

> 
> 3. TEST_TYPE_POLL_RXQ_EMPTY:

3 and 4 don't match with the code here (TEST_TYPE_POLL_{R,T}XQ_TMOUT)

> call poll function with parameter POLLIN on empty rx queue
> will cause timeout.If return timeout then test case is pass.
> 
> 4. TEST_TYPE_POLL_TXQ_FULL:
> When txq is filled and packets are not cleaned by the
> kernel then if we invoke the poll function with POLLOUT
> then it should trigger timeout.If return timeout then
> test case is pass.
> 
> Signed-off-by: Shibin Koikkara Reeny <shibin.koikkara.reeny@intel.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 173 +++++++++++++++++------
>  tools/testing/selftests/bpf/xskxceiver.h |  10 +-
>  2 files changed, 139 insertions(+), 44 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 74d56d971baf..8ecab3a47c9e 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -424,6 +424,8 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
>  
>  		ifobj->xsk = &ifobj->xsk_arr[0];
>  		ifobj->use_poll = false;
> +		ifobj->skip_rx = false;
> +		ifobj->skip_tx = false;

Any chances of trying to avoid these booleans? Not that it's a hard nack,
but the less booleans we spread around in this code the better.

>  		ifobj->use_fill_ring = true;
>  		ifobj->release_rx = true;
>  		ifobj->pkt_stream = test->pkt_stream_default;
> @@ -589,6 +591,19 @@ static struct pkt_stream *pkt_stream_clone(struct xsk_umem_info *umem,
>  	return pkt_stream_generate(umem, pkt_stream->nb_pkts, pkt_stream->pkts[0].len);
>  }
>  
> +static void pkt_stream_invalid(struct test_spec *test, u32 nb_pkts, u32 pkt_len)
> +{
> +	struct pkt_stream *pkt_stream;
> +	u32 i;
> +
> +	pkt_stream = pkt_stream_generate(test->ifobj_tx->umem, nb_pkts, pkt_len);
> +	for (i = 0; i < nb_pkts; i++)
> +		pkt_stream->pkts[i].valid = false;
> +
> +	test->ifobj_tx->pkt_stream = pkt_stream;
> +	test->ifobj_rx->pkt_stream = pkt_stream;
> +}

Please explain how this work, e.g. why you need to have to have invalid
pkt stream + avoiding launching rx thread and why one of them is not
enough.

Personally I think this is not needed. When calling pkt_stream_generate(),
validity of pkt is set based on length of packet vs frame size:

		if (pkt_len > umem->frame_size)
			pkt_stream->pkts[i].valid = false;

so couldn't you use 2k frame size and bigger length of a packet?

> +
>  static void pkt_stream_replace(struct test_spec *test, u32 nb_pkts, u32 pkt_len)
>  {
>  	struct pkt_stream *pkt_stream;
> @@ -817,9 +832,9 @@ static int complete_pkts(struct xsk_socket_info *xsk, int batch_size)
>  	return TEST_PASS;
>  }
>  
> -static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
> +static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds, bool skip_tx)
>  {
> -	struct timeval tv_end, tv_now, tv_timeout = {RECV_TMOUT, 0};
> +	struct timeval tv_end, tv_now, tv_timeout = {THREAD_TMOUT, 0};
>  	u32 idx_rx = 0, idx_fq = 0, rcvd, i, pkts_sent = 0;
>  	struct pkt_stream *pkt_stream = ifobj->pkt_stream;
>  	struct xsk_socket_info *xsk = ifobj->xsk;
> @@ -843,17 +858,28 @@ static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
>  		}
>  
>  		kick_rx(xsk);
> +		if (ifobj->use_poll) {
> +			ret = poll(fds, 1, POLL_TMOUT);
> +			if (ret < 0)
> +				exit_with_error(-ret);
> +
> +			if (!ret) {
> +				if (skip_tx)
> +					return TEST_PASS;
> +
> +				ksft_print_msg("ERROR: [%s] Poll timed out\n", __func__);
> +				return TEST_FAILURE;
>  
> -		rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> -		if (!rcvd) {
> -			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {

So now we don't check if fq needs to be woken up in non-poll case?
I believe this is still needed so we get to the driver and pick fq
entries. Prove me wrong of course if I'm missing something.

> -				ret = poll(fds, 1, POLL_TMOUT);
> -				if (ret < 0)
> -					exit_with_error(-ret);
>  			}
> -			continue;
> +
> +			if (!(fds->revents & POLLIN))
> +				continue;
>  		}
>  
> +		rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> +		if (!rcvd)
> +			continue;
> +
>  		if (ifobj->use_fill_ring) {
>  			ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
>  			while (ret != rcvd) {
> @@ -863,6 +889,7 @@ static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
>  					ret = poll(fds, 1, POLL_TMOUT);
>  					if (ret < 0)
>  						exit_with_error(-ret);
> +					continue;

Why continue here?

>  				}
>  				ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
>  			}
> @@ -900,13 +927,34 @@ static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
>  	return TEST_PASS;
>  }
>  
> -static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
> +static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, bool use_poll,
> +		       struct pollfd *fds, bool timeout)
>  {
>  	struct xsk_socket_info *xsk = ifobject->xsk;
> -	u32 i, idx, valid_pkts = 0;
> +	u32 i, idx, ret, valid_pkts = 0;
> +
> +	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH_SIZE) {
> +		if (use_poll) {
> +			ret = poll(fds, 1, POLL_TMOUT);
> +			if (timeout) {
> +				if (ret < 0) {
> +					ksft_print_msg("DEBUG: [%s] Poll error %d\n",
> +						       __func__, ret);
> +					return TEST_FAILURE;
> +				}
> +				if (ret == 0)
> +					return TEST_PASS;
> +				break;
> +			}
> +			if (ret <= 0) {
> +				ksft_print_msg("DEBUG: [%s] Poll error %d\n",
> +					       __func__, ret);
> +				return TEST_FAILURE;
> +			}
> +		}
>  
> -	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH_SIZE)
>  		complete_pkts(xsk, BATCH_SIZE);
> +	}
>  
>  	for (i = 0; i < BATCH_SIZE; i++) {
>  		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx + i);
> @@ -933,11 +981,27 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
>  
>  	xsk_ring_prod__submit(&xsk->tx, i);
>  	xsk->outstanding_tx += valid_pkts;
> -	if (complete_pkts(xsk, i))
> -		return TEST_FAILURE;
>  
> -	usleep(10);
> -	return TEST_PASS;
> +	if (use_poll) {
> +		ret = poll(fds, 1, POLL_TMOUT);
> +		if (ret <= 0) {
> +			if (ret == 0 && timeout)
> +				return TEST_PASS;
> +
> +			ksft_print_msg("DEBUG: [%s] Poll error %d\n", __func__, ret);
> +			return TEST_FAILURE;
> +		}
> +	}
> +
> +	if (!timeout) {
> +		if (complete_pkts(xsk, i))
> +			return TEST_FAILURE;
> +
> +		usleep(10);
> +		return TEST_PASS;
> +	}
> +
> +	return TEST_CONTINUE;

Why do you need this?

>  }
>  
>  static void wait_for_tx_completion(struct xsk_socket_info *xsk)
> @@ -948,29 +1012,33 @@ static void wait_for_tx_completion(struct xsk_socket_info *xsk)
>  
>  static int send_pkts(struct test_spec *test, struct ifobject *ifobject)
>  {
> +	struct timeval tv_end, tv_now, tv_timeout = {THREAD_TMOUT, 0};
> +	bool timeout = test->ifobj_rx->skip_rx;
>  	struct pollfd fds = { };
> -	u32 pkt_cnt = 0;
> +	u32 pkt_cnt = 0, ret;
>  
>  	fds.fd = xsk_socket__fd(ifobject->xsk->xsk);
>  	fds.events = POLLOUT;
>  
> -	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
> -		int err;
> -
> -		if (ifobject->use_poll) {
> -			int ret;
> -
> -			ret = poll(&fds, 1, POLL_TMOUT);
> -			if (ret <= 0)
> -				continue;
> +	ret = gettimeofday(&tv_now, NULL);
> +	if (ret)
> +		exit_with_error(errno);
> +	timeradd(&tv_now, &tv_timeout, &tv_end);

This logic of timer on Tx side is not mentioned anywhere in the commit
message. Please try your best to describe all of the changes you're
proposing.

Also, couldn't this be a separate patch?

>  
> -			if (!(fds.revents & POLLOUT))
> -				continue;
> +	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
> +		ret = gettimeofday(&tv_now, NULL);
> +		if (ret)
> +			exit_with_error(errno);
> +		if (timercmp(&tv_now, &tv_end, >)) {
> +			ksft_print_msg("ERROR: [%s] Send loop timed out\n", __func__);
> +			return TEST_FAILURE;
>  		}
>  
> -		err = __send_pkts(ifobject, &pkt_cnt);
> -		if (err || test->fail)
> +		ret = __send_pkts(ifobject, &pkt_cnt, ifobject->use_poll, &fds, timeout);
> +		if ((ret || test->fail) && !timeout)
>  			return TEST_FAILURE;
> +		else if (ret == TEST_PASS && timeout)
> +			return ret;
>  	}
>  
>  	wait_for_tx_completion(ifobject->xsk);
> @@ -1235,8 +1303,7 @@ static void *worker_testapp_validate_rx(void *arg)
>  
>  	pthread_barrier_wait(&barr);
>  
> -	err = receive_pkts(ifobject, &fds);
> -
> +	err = receive_pkts(ifobject, &fds, test->ifobj_tx->skip_tx);
>  	if (!err && ifobject->validation_func)
>  		err = ifobject->validation_func(ifobject);
>  	if (err) {
> @@ -1265,17 +1332,21 @@ static int testapp_validate_traffic(struct test_spec *test)
>  	pkts_in_flight = 0;
>  
>  	/*Spawn RX thread */
> -	pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
> -
> -	pthread_barrier_wait(&barr);
> -	if (pthread_barrier_destroy(&barr))
> -		exit_with_error(errno);
> +	if (!ifobj_rx->skip_rx) {
> +		pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
> +		pthread_barrier_wait(&barr);
> +		if (pthread_barrier_destroy(&barr))
> +			exit_with_error(errno);
> +	}
>  
>  	/*Spawn TX thread */
> -	pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
> +	if (!ifobj_tx->skip_tx) {
> +		pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
> +		pthread_join(t1, NULL);
> +	}
>  
> -	pthread_join(t1, NULL);
> -	pthread_join(t0, NULL);
> +	if (!ifobj_rx->skip_rx)
> +		pthread_join(t0, NULL);

Have you thought of a testapp_validate_traffic() variant with a single
thread, either Tx or Rx? In this case probably would make everything
clearer in the current pthread code. Also, wouldn't this drop the need for
skip booleans?

>  
>  	return !!test->fail;
>  }
> @@ -1548,10 +1619,28 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
>  
>  		pkt_stream_restore_default(test);
>  		break;
> -	case TEST_TYPE_POLL:
> +	case TEST_TYPE_RX_POLL:
> +		test->ifobj_rx->use_poll = true;
> +		test_spec_set_name(test, "POLL_RX");
> +		testapp_validate_traffic(test);
> +		break;
> +	case TEST_TYPE_TX_POLL:
>  		test->ifobj_tx->use_poll = true;
> +		test_spec_set_name(test, "POLL_TX");
> +		testapp_validate_traffic(test);
> +		break;
> +	case TEST_TYPE_POLL_TXQ_TMOUT:
> +		test_spec_set_name(test, "POLL_TXQ_FULL");
> +		test->ifobj_rx->skip_rx = true;
> +		test->ifobj_tx->use_poll = true;
> +		pkt_stream_invalid(test, 2 * DEFAULT_PKT_CNT, PKT_SIZE);
> +		testapp_validate_traffic(test);
> +		pkt_stream_restore_default(test);
> +		break;
> +	case TEST_TYPE_POLL_RXQ_TMOUT:
> +		test_spec_set_name(test, "POLL_RXQ_EMPTY");
> +		test->ifobj_tx->skip_tx = true;
>  		test->ifobj_rx->use_poll = true;
> -		test_spec_set_name(test, "POLL");
>  		testapp_validate_traffic(test);
>  		break;
>  	case TEST_TYPE_ALIGNED_INV_DESC:
> diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
> index 3d17053f98e5..0db7e0acccb2 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.h
> +++ b/tools/testing/selftests/bpf/xskxceiver.h
> @@ -27,6 +27,7 @@
>  
>  #define TEST_PASS 0
>  #define TEST_FAILURE -1
> +#define TEST_CONTINUE 1
>  #define MAX_INTERFACES 2
>  #define MAX_INTERFACE_NAME_CHARS 7
>  #define MAX_INTERFACES_NAMESPACE_CHARS 10
> @@ -48,7 +49,7 @@
>  #define SOCK_RECONF_CTR 10
>  #define BATCH_SIZE 64
>  #define POLL_TMOUT 1000
> -#define RECV_TMOUT 3
> +#define THREAD_TMOUT 3
>  #define DEFAULT_PKT_CNT (4 * 1024)
>  #define DEFAULT_UMEM_BUFFERS (DEFAULT_PKT_CNT / 4)
>  #define UMEM_SIZE (DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE)
> @@ -68,7 +69,10 @@ enum test_type {
>  	TEST_TYPE_RUN_TO_COMPLETION,
>  	TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME,
>  	TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT,
> -	TEST_TYPE_POLL,
> +	TEST_TYPE_RX_POLL,
> +	TEST_TYPE_TX_POLL,
> +	TEST_TYPE_POLL_RXQ_TMOUT,
> +	TEST_TYPE_POLL_TXQ_TMOUT,
>  	TEST_TYPE_UNALIGNED,
>  	TEST_TYPE_ALIGNED_INV_DESC,
>  	TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME,
> @@ -145,6 +149,8 @@ struct ifobject {
>  	bool tx_on;
>  	bool rx_on;
>  	bool use_poll;
> +	bool skip_rx;
> +	bool skip_tx;
>  	bool busy_poll;
>  	bool use_fill_ring;
>  	bool release_rx;
> -- 
> 2.34.1
> 
