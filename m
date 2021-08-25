Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3B33F7C5E
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 20:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241849AbhHYSnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 14:43:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:29739 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241704AbhHYSnh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 14:43:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="217309983"
X-IronPort-AV: E=Sophos;i="5.84,351,1620716400"; 
   d="scan'208";a="217309983"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 11:42:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,351,1620716400"; 
   d="scan'208";a="684612821"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga006.fm.intel.com with ESMTP; 25 Aug 2021 11:42:46 -0700
Date:   Wed, 25 Aug 2021 20:26:56 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: Re: [PATCH bpf-next v3 00/16] selftests: xsk: various simplifications
Message-ID: <20210825182656.GA26792@ranger.igk.intel.com>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825093722.10219-1-magnus.karlsson@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 11:37:06AM +0200, Magnus Karlsson wrote:
> This patch set mainly contains various simplifications to the xsk
> selftests. The only exception is the introduction of packet streams
> that describes what the Tx process should send and what the Rx process
> should receive. If it receives anything else, the test fails. This
> mechanism can be used to produce tests were all packets are not
> received by the Rx thread or modified in some way. An example of this
> is if an XDP program does XDP_PASS on some of the packets.
> 
> This patch set will be followed by another patch set that implements a
> new structure that will facilitate adding new tests. A couple of new
> tests will also be included in that patch set.

I went through the series and besides the typo found by Alexei I have no
objections.

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Looking forward to next set that you mention above :)

> 
> v2 -> v3:
> 
> * Reworked patch 12 so that it now has functions for creating and
>   destroying ifobjects. Simplifies the code. [Maciej]
> * The packet stream now allocates the supplied buffer array length,
>   instead of the default one. [Maciej]
> * pkt_stream_get_pkt() now returns NULL when indexing a non-existing
>   packet. [Maciej]
> * pkt_validate() is now is_pkt_valid(). [Maciej]
> * Slowed down packet sending speed even more in patch 11 so that slow
>   systems do not silenty drop packets in skb mode.
> 
> v1 -> v2:
> 
> * Dropped the patch with per process limit changes as it is not needed
>   [Yonghong]
> * Improved the commit message of patch 1 [Yonghong]
> * Fixed a spelling error in patch 9
> 
> Thanks: Magnus
> 
> Magnus Karlsson (16):
>   selftests: xsk: remove color mode
>   selftests: xsk: remove the num_tx_packets option
>   selftests: xsk: remove unused variables
>   selftests: xsk: return correct error codes
>   selftests: xsk: simplify the retry code
>   selftests: xsk: remove end-of-test packet
>   selftests: xsk: disassociate umem size with packets sent
>   selftests: xsk: rename worker_* functions that are not thread entry
>     points
>   selftests: xsk: simplify packet validation in xsk tests
>   selftests: xsk: validate tx stats on tx thread
>   selftests: xsk: decrease sending speed
>   selftests: xsk: simplify cleanup of ifobjects
>   selftests: xsk: generate packet directly in umem
>   selftests: xsk: generate packets from specification
>   selftests: xsk: make enums lower case
>   selftests: xsk: preface options with opt
> 
>  tools/testing/selftests/bpf/test_xsk.sh    |  10 +-
>  tools/testing/selftests/bpf/xdpxceiver.c   | 681 ++++++++++-----------
>  tools/testing/selftests/bpf/xdpxceiver.h   |  63 +-
>  tools/testing/selftests/bpf/xsk_prereqs.sh |  30 +-
>  4 files changed, 356 insertions(+), 428 deletions(-)
> 
> 
> base-commit: 3bbc8ee7c363a83aa192d796ad37b6bf462a2947
> --
> 2.29.0
