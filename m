Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5B62F3D74
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393126AbhALVkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:40:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:47666 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392968AbhALVkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 16:40:08 -0500
IronPort-SDR: xYKS00vz0lhDZYoJwTMPFwY6G7vV1VNfu3S3E7FSENhrRvgFqzDl3NENftlNvUgZBDX/lBDu1J
 0RUErvd/eJoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="196740362"
X-IronPort-AV: E=Sophos;i="5.79,342,1602572400"; 
   d="scan'208";a="196740362"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 13:38:19 -0800
IronPort-SDR: 2SQCWOzeUZ2/0GfO/qAorddSiUjA6Pb1QsQ/YuGjuNVFz9Q7UhSDsdGXptfWQfnmUeSjBWwkuM
 4lsEwvsE2cxg==
X-IronPort-AV: E=Sophos;i="5.79,342,1602572400"; 
   d="scan'208";a="352009948"
Received: from smakanda-mobl1.gar.corp.intel.com ([10.254.115.163])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 13:38:19 -0800
Date:   Tue, 12 Jan 2021 13:38:18 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [MPTCP] [PATCH net 2/2] mptcp: better msk-level shutdown.
In-Reply-To: <4cd18371d7caa6ee4a4e7ef988b50b45e362e177.1610471474.git.pabeni@redhat.com>
Message-ID: <f3965cdf-a9f8-b36e-cc1a-3d29ce3fadff@linux.intel.com>
References: <cover.1610471474.git.pabeni@redhat.com> <4cd18371d7caa6ee4a4e7ef988b50b45e362e177.1610471474.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021, Paolo Abeni wrote:

> Instead of re-implementing most of inet_shutdown, re-use
> such helper, and implement the MPTCP-specific bits at the
> 'proto' level.
>
> The msk-level disconnect() can now be invoked, lets provide a
> suitable implementation.
>
> As a side effect, this fixes bad state management for listener
> sockets. The latter could lead to division by 0 oops since
> commit ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling").
>
> Fixes: 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state machine")
> Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 62 ++++++++++++--------------------------------
> 1 file changed, 17 insertions(+), 45 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
