Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90A71D58AF
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 20:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgEOSKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 14:10:06 -0400
Received: from mga07.intel.com ([134.134.136.100]:28169 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgEOSKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 14:10:06 -0400
IronPort-SDR: JKslyVj14zvjdHdZL75aSS0g4qvt2yvL/T9vDZJ9niXFb2m9wt5eQX6SJrdCxMdmc66syLSlOX
 +Geeq6CJ5f4Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 11:10:05 -0700
IronPort-SDR: SMmdOn92NTdQQVKwvADZvBEhjLzaoDOClzYhFFufziH4+UsG+uayQPdIH0I0BtHr11K1x0ePZu
 aq1NmRMRxh6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,396,1583222400"; 
   d="scan'208";a="252107895"
Received: from rasanche-mobl.amr.corp.intel.com ([10.255.228.159])
  by orsmga007.jf.intel.com with ESMTP; 15 May 2020 11:10:05 -0700
Date:   Fri, 15 May 2020 11:10:05 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@rasanche-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 3/3] mptcp: cope better with MP_JOIN
 failure
In-Reply-To: <4dc2d07bafebc2dde162fe1dc1c25f0c4cb602e1.1589558049.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.22.394.2005151109510.36555@rasanche-mobl.amr.corp.intel.com>
References: <cover.1589558049.git.pabeni@redhat.com> <4dc2d07bafebc2dde162fe1dc1c25f0c4cb602e1.1589558049.git.pabeni@redhat.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 15 May 2020, Paolo Abeni wrote:

> Currently, on MP_JOIN failure we reset the child
> socket, but leave the request socket untouched.
>
> tcp_check_req will deal with it according to the
> 'tcp_abort_on_overflow' sysctl value - by default the
> req socket will stay alive.
>
> The above leads to inconsistent behavior on MP JOIN
> failure, and bad listener overflow accounting.
>
> This patch addresses the issue leveraging the infrastructure
> just introduced to ask the TCP stack to drop the req on
> failure.
>
> The child socket is not freed anymore by subflow_syn_recv_sock(),
> instead it's moved to a dead state and will be disposed by the
> next sock_put done by the TCP stack, so that listener overflow
> accounting is not affected by MP JOIN failure.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Reviewed-by: Christoph Paasch <cpaasch@apple.com>
> ---
> net/mptcp/subflow.c | 15 +++++++++------
> 1 file changed, 9 insertions(+), 6 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
