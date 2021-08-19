Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8873F174A
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 12:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbhHSK32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 06:29:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:7491 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238277AbhHSK3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 06:29:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="216560942"
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="216560942"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 03:28:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="679265716"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga006.fm.intel.com with ESMTP; 19 Aug 2021 03:28:38 -0700
Date:   Thu, 19 Aug 2021 12:13:38 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: Re: [PATCH bpf-next v2 00/16] selftests: xsk: various simplifications
Message-ID: <20210819101338.GD32204@ranger.igk.intel.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 11:27:13AM +0200, Magnus Karlsson wrote:
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
> 
> v1 -> v2:
> 
> * Dropped the patch with per process limit changes as it is not needed
>   [Yonghong]
> * Improved the commit message of patch 1 [Yonghong]
> * Fixed a spelling error in patch 9
> 
> Thanks: Magnus

This is awesome work. Lots of simplification and the pkt stream generation
makes sense to me.

I had little comments on patch 14.

Besides that:
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

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
>   selftests: xsk: decrease batch size
>   selftests: xsk: remove cleanup at end of program
>   selftests: xsk: generate packet directly in umem
>   selftests: xsk: generate packets from specification
>   selftests: xsk: make enums lower case
>   selftests: xsk: preface options with opt
> 
>  tools/testing/selftests/bpf/test_xsk.sh    |  10 +-
>  tools/testing/selftests/bpf/xdpxceiver.c   | 626 +++++++++------------
>  tools/testing/selftests/bpf/xdpxceiver.h   |  61 +-
>  tools/testing/selftests/bpf/xsk_prereqs.sh |  30 +-
>  4 files changed, 310 insertions(+), 417 deletions(-)
> 
> 
> base-commit: 3c3bd542ffbb2ac09631313ede46ae66660ae550
> --
> 2.29.0
