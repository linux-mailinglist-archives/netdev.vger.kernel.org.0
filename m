Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED3A1E84FD
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgE2RfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:35:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:13518 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgE2RfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:35:12 -0400
IronPort-SDR: dEATwEBvP1Ei1H4TnBbc9iqK52qAOVbJ1RbjSXaXucvnogxbolCpeyTOsOEAEFSeDErjNKGuI5
 ZtNENU5oK3pg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 10:35:11 -0700
IronPort-SDR: GYNHfmnMIsHCOetwa0qGOxO/jdNNEBxRlIysYySTl6wZaP7VQTOOAiV3GzsZSwXgZfzVjbVBOK
 ixlqt+dfgZ/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,449,1583222400"; 
   d="scan'208";a="257390472"
Received: from aparnash-mobl.amr.corp.intel.com ([10.254.67.112])
  by fmsmga008.fm.intel.com with ESMTP; 29 May 2020 10:35:11 -0700
Date:   Fri, 29 May 2020 10:35:11 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@aparnash-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 1/3] mptcp: fix unblocking connect()
In-Reply-To: <ed95b3e88cd4dfc3efc495c0be646c095aefb975.1590766645.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.22.394.2005291034180.3506@aparnash-mobl.amr.corp.intel.com>
References: <cover.1590766645.git.pabeni@redhat.com> <ed95b3e88cd4dfc3efc495c0be646c095aefb975.1590766645.git.pabeni@redhat.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020, Paolo Abeni wrote:

> Currently unblocking connect() on MPTCP sockets fails frequently.
> If mptcp_stream_connect() is invoked to complete a previously
> attempted unblocking connection, it will still try to create
> the first subflow via __mptcp_socket_create(). If the 3whs is
> completed and the 'can_ack' flag is already set, the latter
> will fail with -EINVAL.
>
> This change addresses the issue checking for pending connect and
> delegating the completion to the first subflow. Additionally
> do msk addresses and sk_state changes only when needed.
>
> Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 20 ++++++++++++++++++--
> 1 file changed, 18 insertions(+), 2 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
