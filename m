Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD2AB1C0A
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387779AbfIMLQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:16:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:23912 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387588AbfIMLQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:16:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 04:16:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,500,1559545200"; 
   d="scan'208";a="210317965"
Received: from sjuba-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.54.243])
  by fmsmga004.fm.intel.com with ESMTP; 13 Sep 2019 04:16:38 -0700
Subject: Re: [PATCH bpf-next v2 0/3] AF_XDP fixes for i40e, ixgbe and xdpsock
To:     Ciara Loftus <ciara.loftus@intel.com>, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Cc:     bruce.richardson@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, kevin.laatz@intel.com
References: <20190913103948.32053-1-ciara.loftus@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <03e25d27-fe42-306d-880f-31b3d995afd3@intel.com>
Date:   Fri, 13 Sep 2019 13:16:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190913103948.32053-1-ciara.loftus@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-09-13 12:39, Ciara Loftus wrote:
> This patch set contains some fixes for AF_XDP zero copy in the i40e and
> ixgbe drivers as well as a fix for the 'xdpsock' sample application when
> running in unaligned mode.
> 
> Patches 1 and 2 fix a regression for the i40e and ixgbe drivers which
> caused the umem headroom to be added to the xdp handle twice, resulting in
> an incorrect value being received by the user for the case where the umem
> headroom is non-zero.
> 
> Patch 3 fixes an issue with the xdpsock sample application whereby the
> start of the tx packet data (offset) was not being set correctly when the
> application was being run in unaligned mode.
> 
> This patch set has been applied against commit a2c11b034142 ("kcm: use
> BPF_PROG_RUN")
> 
> ---
> v2:
> - Rearranged local variable order in i40e_run_xdp_zc and ixgbe_run_xdp_zc
> to comply with coding standards.
>

Thanks Ciara!

Acked-by: Björn Töpel <bjorn.topel@intel.com>


> Ciara Loftus (3):
>    i40e: fix xdp handle calculations
>    ixgbe: fix xdp handle calculations
>    samples/bpf: fix xdpsock l2fwd tx for unaligned mode
> 
>   drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 4 ++--
>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 4 ++--
>   samples/bpf/xdpsock_user.c                   | 2 +-
>   3 files changed, 5 insertions(+), 5 deletions(-)
> 
