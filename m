Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA0137B1AE
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 00:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhEKWl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 18:41:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:1706 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEKWl4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 18:41:56 -0400
IronPort-SDR: g35CmSOmJPAiQP7gbSq5NphF5xw2D7vBz97qWBE9G/jSmUsfpiZ+6Is2MEmImA2021DlMwpnBE
 wvTJo+/u5QPQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="285062425"
X-IronPort-AV: E=Sophos;i="5.82,291,1613462400"; 
   d="scan'208";a="285062425"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2021 15:40:49 -0700
IronPort-SDR: tXMX4F55m7VOHQpFeZ6F2ABARtAteqdad3zGtaAZmOVSOjSa+/5NAJuhgA7fOFgcZTLIPVGmZ0
 Uv1SWdtohPMg==
X-IronPort-AV: E=Sophos;i="5.82,291,1613462400"; 
   d="scan'208";a="408991196"
Received: from kcolwell-mobl.amr.corp.intel.com ([10.251.1.71])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2021 15:40:49 -0700
Date:   Tue, 11 May 2021 15:40:49 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.linux.dev,
        Maxim Galaganov <max@internet.ru>
Subject: Re: [PATCH v2 net] mptcp: fix data stream corruption
In-Reply-To: <0c393b7ad78e0bab142f48d53995aaa8636b44d9.1620753167.git.pabeni@redhat.com>
Message-ID: <dae7171b-8e20-bbdc-d697-78baa341e696@linux.intel.com>
References: <0c393b7ad78e0bab142f48d53995aaa8636b44d9.1620753167.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 May 2021, Paolo Abeni wrote:

> Maxim reported several issues when forcing a TCP transparent proxy
> to use the MPTCP protocol for the inbound connections. He also
> provided a clean reproducer.
>
> The problem boils down to 'mptcp_frag_can_collapse_to()' assuming
> that only MPTCP will use the given page_frag.
>
> If others - e.g. the plain TCP protocol - allocate page fragments,
> we can end-up re-using already allocated memory for mptcp_data_frag.
>
> Fix the issue ensuring that the to-be-expanded data fragment is
> located at the current page frag end.
>
> v1 -> v2:
> - added missing fixes tag (Mat)
>
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/178
> Reported-and-tested-by: Maxim Galaganov <max@internet.ru>
> Fixes: 18b683bff89d ("mptcp: queue data for mptcp level retransmission")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 6 ++++++
> 1 file changed, 6 insertions(+)

Paolo -

Thanks for the tag fix. Patch looks good to me:

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>


--
Mat Martineau
Intel
