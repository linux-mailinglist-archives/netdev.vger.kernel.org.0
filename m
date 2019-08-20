Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF3EC95BD8
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbfHTKBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:01:10 -0400
Received: from ja.ssi.bg ([178.16.129.10]:38546 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729464AbfHTKBJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 06:01:09 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x7KA0hRv009840;
        Tue, 20 Aug 2019 13:00:44 +0300
Date:   Tue, 20 Aug 2019 13:00:43 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     zhang kai <zhangkaiheb@126.com>
cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ipvs: change type of delta and previous_delta in
 ip_vs_seq.
In-Reply-To: <20190820003718.GA16620@toolchain>
Message-ID: <alpine.LFD.2.21.1908201250440.3332@ja.home.ssi.bg>
References: <20190820003718.GA16620@toolchain>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

	Cc list trimmed...

On Tue, 20 Aug 2019, zhang kai wrote:

> In NAT forwarding mode, Applications may decrease the size of packets,
> and TCP sequences will get smaller, so both of variables will be negetive
> values in this case.

	As long as nobody cares about their sign, the type should not
matter. You can not solve all signed/unsigned mismatches with such
small patch. Or you are seeing some problem, may be in debug?

> 
> Signed-off-by: zhang kai <zhangkaiheb@126.com>
> ---
>  include/net/ip_vs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 3759167f91f5..de7e75063c7c 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -346,8 +346,8 @@ enum ip_vs_sctp_states {
>   */
>  struct ip_vs_seq {
>  	__u32			init_seq;	/* Add delta from this seq */
> -	__u32			delta;		/* Delta in sequence numbers */
> -	__u32			previous_delta;	/* Delta in sequence numbers
> +	__s32			delta;		/* Delta in sequence numbers */
> +	__s32			previous_delta;	/* Delta in sequence numbers
>  						 * before last resized pkt */
>  };
>  
> -- 
> 2.17.1

Regards

--
Julian Anastasov <ja@ssi.bg>
