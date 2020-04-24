Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BB21B7DD5
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 20:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgDXSYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 14:24:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:36061 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbgDXSYe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 14:24:34 -0400
IronPort-SDR: VbnNW5SMUItPDt70K0w/f24/PmDo8rlxY/1w5PToYQJBmk0g44bQaEIG+ivhU6l9Hdg/zMYvOo
 AJiQIQvhx6FQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 11:24:33 -0700
IronPort-SDR: 3v3FXAc4OQj7KDT2lyK9gxgYnNfCYjnbWj8jxNowhcJSDjqlbcvuZhcjKG3QMPyzoJAhisUvng
 SKc0b1jqPuRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,313,1583222400"; 
   d="scan'208";a="291669113"
Received: from zzhu12-mobl.amr.corp.intel.com ([10.254.73.142])
  by fmsmga002.fm.intel.com with ESMTP; 24 Apr 2020 11:24:33 -0700
Date:   Fri, 24 Apr 2020 11:24:33 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@zzhu12-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Davide Caratti <dcaratti@redhat.com>, mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: fix race in msk status update
In-Reply-To: <4d5e3c09ca38a0a3ec951fa4f5bfc65d5cd40129.1587725562.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.22.394.2004241123300.64783@zzhu12-mobl.amr.corp.intel.com>
References: <4d5e3c09ca38a0a3ec951fa4f5bfc65d5cd40129.1587725562.git.pabeni@redhat.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 24 Apr 2020, Paolo Abeni wrote:

> Currently subflow_finish_connect() changes unconditionally
> any msk socket status other than TCP_ESTABLISHED.
>
> If an unblocking connect() races with close(), we can end-up
> triggering:
>
> IPv4: Attempt to release TCP socket in state 1 00000000e32b8b7e
>
> when the msk socket is disposed.
>
> Be sure to enter the established status only from SYN_SENT.
>
> Fixes: c3c123d16c0e ("net: mptcp: don't hang in mptcp_sendmsg() after TCP fallback")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---

Thanks Paolo, looks good.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
