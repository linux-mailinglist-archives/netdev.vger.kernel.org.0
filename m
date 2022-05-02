Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989945179D5
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 00:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbiEBWSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 18:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiEBWSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 18:18:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91ED46149;
        Mon,  2 May 2022 15:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651529680; x=1683065680;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=RiXvCB8oh9nqPgcnx8EIB1Wmt/grBN2Os/vtX20nf5g=;
  b=e/MAZMDyueTz6AtkNOA+BMHCCH2j06OvckIBZmoF7X6RbafgwC9dAOzK
   xZjwN9dmCp9d5hc6iUsotci63br6dqfAmBvB6KzubPAZv1hUezbBWBkyV
   83SmTY4aKsQiadNglYax1lJfTIpt2P819KNW7dB+vt4LAKRhwK9N0G9uI
   EA8yhIZknpatG+E1EpnumqfphjALPk7w/z5rhZqzkwMz1QW8QaSwThfbI
   KDliL8P+nZy4C59qCQx1A1VcGR3dr0iA2wFauM2WCOAAckQX9U8dKPI1m
   yBcLt3us6yYludU9dTFW7jqIIDHaSTQZpi2VYIjiuDwfGQFLX8rSz2J9J
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="249323958"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="249323958"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 15:14:40 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="546666530"
Received: from raltenor-mobl.amr.corp.intel.com ([10.212.200.195])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 15:14:40 -0700
Date:   Mon, 2 May 2022 15:14:39 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH bpf-next v3 6/8] selftests: bpf: verify token of struct
 mptcp_sock
In-Reply-To: <20220502211235.142250-7-mathew.j.martineau@linux.intel.com>
Message-ID: <108060a1-8e8c-6d2b-a3a0-a18dab3e409b@linux.intel.com>
References: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com> <20220502211235.142250-7-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 May 2022, Mat Martineau wrote:

> From: Geliang Tang <geliang.tang@suse.com>
>
> This patch verifies the struct member token of struct mptcp_sock. Add a
> new function get_msk_token() to parse the msk token from the output of
> the command 'ip mptcp monitor', and verify it in verify_msk().
>

Daniel, Andrii,

The z15 CI build failed on this commit, not due to any endianness issue 
but because it appears the z15 CI VM has an older iproute2 version (5.5.0) 
than the x86_64 VM (where the build succeeded).

Do you need us (MPTCP) to change anything?

Thanks!

> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
> .../testing/selftests/bpf/bpf_mptcp_helpers.h |  1 +
> .../testing/selftests/bpf/prog_tests/mptcp.c  | 66 +++++++++++++++++++
> .../testing/selftests/bpf/progs/mptcp_sock.c  |  5 ++
> 3 files changed, 72 insertions(+)

--
Mat Martineau
Intel
