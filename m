Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E89DA697F
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbfICNQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:16:30 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41623 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbfICNQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:16:29 -0400
Received: from cpe-2606-a000-111b-43ee-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:43ee::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1i58fU-00063D-Tk; Tue, 03 Sep 2019 09:16:25 -0400
Date:   Tue, 3 Sep 2019 09:15:53 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net] sctp: use transport pf_retrans in
 sctp_do_8_2_transport_strike
Message-ID: <20190903131553.GC30429@hmswarspite.think-freely.org>
References: <41769d6033d27d629798e060671a3b21f22e2a21.1567437861.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41769d6033d27d629798e060671a3b21f22e2a21.1567437861.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 02, 2019 at 11:24:21PM +0800, Xin Long wrote:
> Transport should use its own pf_retrans to do the error_count
> check, instead of asoc's. Otherwise, it's meaningless to make
> pf_retrans per transport.
> 
> Fixes: 5aa93bcf66f4 ("sctp: Implement quick failover draft from tsvwg")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/sm_sideeffect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 1cf5bb5..e52b212 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -547,7 +547,7 @@ static void sctp_do_8_2_transport_strike(struct sctp_cmd_seq *commands,
>  	if (net->sctp.pf_enable &&
>  	   (transport->state == SCTP_ACTIVE) &&
>  	   (transport->error_count < transport->pathmaxrxt) &&
> -	   (transport->error_count > asoc->pf_retrans)) {
> +	   (transport->error_count > transport->pf_retrans)) {
>  
>  		sctp_assoc_control_transport(asoc, transport,
>  					     SCTP_TRANSPORT_PF,
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

