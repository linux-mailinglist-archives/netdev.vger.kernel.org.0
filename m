Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83BBE170D09
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 01:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgB0AMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 19:12:01 -0500
Received: from mga05.intel.com ([192.55.52.43]:38358 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgB0AMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 19:12:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Feb 2020 16:12:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,490,1574150400"; 
   d="scan'208";a="238211736"
Received: from tvtrimel-mobl2.amr.corp.intel.com ([10.251.11.94])
  by orsmga003.jf.intel.com with ESMTP; 26 Feb 2020 16:11:58 -0800
Date:   Wed, 26 Feb 2020 16:11:58 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@tvtrimel-mobl2.amr.corp.intel.com
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 6/7] mptcp: avoid work queue scheduling if
 possible
In-Reply-To: <20200226091452.1116-7-fw@strlen.de>
Message-ID: <alpine.OSX.2.22.394.2002261611420.50710@tvtrimel-mobl2.amr.corp.intel.com>
References: <20200226091452.1116-1-fw@strlen.de> <20200226091452.1116-7-fw@strlen.de>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Feb 2020, Florian Westphal wrote:

> We can't lock_sock() the mptcp socket from the subflow data_ready callback,
> it would result in ABBA deadlock with the subflow socket lock.
>
> We can however grab the spinlock: if that succeeds and the mptcp socket
> is not owned at the moment, we can process the new skbs right away
> without deferring this to the work queue.
>
> This avoids the schedule_work and hence the small delay until the
> work item is processed.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
