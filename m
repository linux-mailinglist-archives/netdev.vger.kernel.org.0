Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D99269449
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgINSB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:01:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:6401 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgINSBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:01:06 -0400
IronPort-SDR: 91khSUVeA05bbe0oaBpD8Tif0sSCFmdWSqYwIMWdtsi4pWBQCF2RD445gc8JaZJzxUNX5sVvzm
 YzXRZjc+MtWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="146821840"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="146821840"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:00:28 -0700
IronPort-SDR: jk3n9erD5SUvfDIkt+9K7RgVThDeYPLThj4rvBcz7XtFWs6+WKQNRNDEcvATm6sKSVLaj542EG
 MJD1K3KBdmdg==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="450978793"
Received: from ningale-mobl.amr.corp.intel.com ([10.255.229.30])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:00:28 -0700
Date:   Mon, 14 Sep 2020 11:00:26 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ningale-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: Re: [MPTCP] [PATCH net-next v2 01/13] mptcp: rethink 'is writable'
 conditional
In-Reply-To: <ae4a76d7e6c72044d63128689155643e9f888e74.1599854632.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2009141056210.57764@ningale-mobl.amr.corp.intel.com>
References: <cover.1599854632.git.pabeni@redhat.com> <ae4a76d7e6c72044d63128689155643e9f888e74.1599854632.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020, Paolo Abeni wrote:

> Currently, when checking for the 'msk is writable' condition, we
> look at the individual subflows write space.
> That works well while we send data via a single subflow, but will
> not as soon as we will enable concurrent xmit on multiple subflows.
>
> With this change msk becomes writable when the following conditions
> hold:
> - the socket has some free write space
> - there is at least a subflow with write free space
>
> Additionally we need to set the NOSPACE bit on all subflows
> before blocking.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 71 ++++++++++++++++++++++++++++----------------
> net/mptcp/subflow.c  |  6 ++--
> 2 files changed, 50 insertions(+), 27 deletions(-)
>

Thanks for the v2 Paolo. I've reviewed the series and will tag them all 
so patchwork is updated.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
