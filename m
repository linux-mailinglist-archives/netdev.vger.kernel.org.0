Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A026179D2B
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 02:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgCEBHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 20:07:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:28998 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgCEBHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 20:07:21 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 17:07:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,516,1574150400"; 
   d="scan'208";a="439322975"
Received: from mlee22-mobl.amr.corp.intel.com ([10.251.30.98])
  by fmsmga005.fm.intel.com with ESMTP; 04 Mar 2020 17:07:20 -0800
Date:   Wed, 4 Mar 2020 17:07:20 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mlee22-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Subject: Re: [PATCH net v2] mptcp: always include dack if possible.
In-Reply-To: <d4f2f87c56fa1662bbc39baaee74b26bc646e141.1583337038.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.22.394.2003041706220.33439@mlee22-mobl.amr.corp.intel.com>
References: <d4f2f87c56fa1662bbc39baaee74b26bc646e141.1583337038.git.pabeni@redhat.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 4 Mar 2020, Paolo Abeni wrote:

> Currently passive MPTCP socket can skip including the DACK
> option - if the peer sends data before accept() completes.
>
> The above happens because the msk 'can_ack' flag is set
> only after the accept() call.
>
> Such missing DACK option may cause - as per RFC spec -
> unwanted fallback to TCP.
>
> This change addresses the issue using the key material
> available in the current subflow, if any, to create a suitable
> dack option when msk ack seq is not yet available.
>
> v1 -> v2:
> - adavance the generated ack after the initial MPC packet
>
> Fixes: d22f4988ffec ("mptcp: process MP_CAPABLE data option")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
