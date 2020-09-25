Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9CE277CC7
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgIYAUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:20:44 -0400
Received: from mga06.intel.com ([134.134.136.31]:59140 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgIYAUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:20:44 -0400
IronPort-SDR: I8KG/7zn2La+9k0DwiA5OBDZzRBnkk+EW0oN/5/d4DCtGSd6n2uPDtL0UmjZfN89ItgQaDMlAf
 ElO8Zwlu87FQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="222980258"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="222980258"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:20:43 -0700
IronPort-SDR: bSSOUUSSFsLlxDFRWN4PDsnDMW1UOt28+O8rn/liQvSUSyx7QhLMRQm28PTLmbmtfVoHtQzznI
 g8czi/qJAaiA==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="455585735"
Received: from mmahler-mobl1.amr.corp.intel.com ([10.254.96.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:20:43 -0700
Date:   Thu, 24 Sep 2020 17:20:43 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mmahler-mobl1.amr.corp.intel.com
To:     Geliang Tang <geliangtang@gmail.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net-next 08/16] mptcp: remove addr and subflow in
 PM netlink
In-Reply-To: <37f2befac450fb46367f62446a4bb2c9d0a5986a.1600853093.git.geliangtang@gmail.com>
Message-ID: <alpine.OSX.2.23.453.2009241720290.62831@mmahler-mobl1.amr.corp.intel.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <37f2befac450fb46367f62446a4bb2c9d0a5986a.1600853093.git.geliangtang@gmail.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020, Geliang Tang wrote:

> This patch implements the remove announced addr and subflow logic in PM
> netlink.
>
> When the PM netlink removes an address, we traverse all the existing msk
> sockets to find the relevant sockets.
>
> We add a new list named anno_list in mptcp_pm_data, to record all the
> announced addrs. In the traversing, we check if it has been recorded.
> If it has been, we trigger the RM_ADDR signal.
>
> We also check if this address is in conn_list. If it is, we remove the
> subflow which using this local address.
>
> Since we call mptcp_pm_free_anno_list in mptcp_destroy, we need to move
> __mptcp_init_sock before the mptcp_is_enabled check in mptcp_init_sock.
>
> Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
> net/mptcp/pm.c         |   7 ++-
> net/mptcp/pm_netlink.c | 122 +++++++++++++++++++++++++++++++++++++++--
> net/mptcp/protocol.c   |   9 +--
> net/mptcp/protocol.h   |   2 +
> net/mptcp/subflow.c    |   1 +
> 5 files changed, 130 insertions(+), 11 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
