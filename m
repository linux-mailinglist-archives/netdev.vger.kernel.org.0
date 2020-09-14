Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3053269451
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgINSED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:04:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:36365 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgINSDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:03:53 -0400
IronPort-SDR: yJuZw2xcFtVluLV0RYaskDozVkgwAMyYFkYi4FmrumVs9Wvcv+yDfiMcYdTeIFdiu6ssHKhQ6g
 rZOJp4s/AeXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="223315422"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="223315422"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:03:47 -0700
IronPort-SDR: d4HEmjIPT8yHg0B6xJ8uDvR3DdknGtrIWIo5mdSsFLzM0JLaTYxuOP38dcJ7wYIJACOfHvybqi
 k1LtuQ99YMWw==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="450980021"
Received: from ningale-mobl.amr.corp.intel.com ([10.255.229.30])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:03:47 -0700
Date:   Mon, 14 Sep 2020 11:03:47 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ningale-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: Re: [MPTCP] [PATCH net-next v2 03/13] mptcp: trigger msk processing
 even for OoO data
In-Reply-To: <2a05880d191b0859f52bbcc002cd694603cd36b8.1599854632.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2009141103170.57764@ningale-mobl.amr.corp.intel.com>
References: <cover.1599854632.git.pabeni@redhat.com> <2a05880d191b0859f52bbcc002cd694603cd36b8.1599854632.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020, Paolo Abeni wrote:

> This is a prerequisite to allow receiving data from multiple
> subflows without re-injection.
>
> Instead of dropping the OoO - "future" data in
> subflow_check_data_avail(), call into __mptcp_move_skbs()
> and let the msk drop that.
>
> To avoid code duplication factor out the mptcp_subflow_discard_data()
> helper.
>
> Note that __mptcp_move_skbs() can now find multiple subflows
> with data avail (comprising to-be-discarded data), so must
> update the byte counter incrementally.
>
> v1 -> v2:
> - fix checkpatch issues (unsigned -> unsigned int)
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 33 +++++++++++++++----
> net/mptcp/protocol.h |  9 ++++-
> net/mptcp/subflow.c  | 78 ++++++++++++++++++++++++--------------------
> 3 files changed, 78 insertions(+), 42 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>


--
Mat Martineau
Intel
