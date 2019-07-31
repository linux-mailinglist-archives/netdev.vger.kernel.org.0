Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6607BF2E
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 13:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387515AbfGaLUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 07:20:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38667 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfGaLUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 07:20:13 -0400
Received: from cpe-2606-a000-111b-6140-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:6140::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hsmeG-0001W9-GP; Wed, 31 Jul 2019 07:20:05 -0400
Date:   Wed, 31 Jul 2019 07:19:32 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Joe Perches <joe@perches.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sctp: Rename fallthrough label to unhandled
Message-ID: <20190731111932.GA9823@hmswarspite.think-freely.org>
References: <e0dd3af448e38e342c1ac6e7c0c802696eb77fd6.1564549413.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0dd3af448e38e342c1ac6e7c0c802696eb77fd6.1564549413.git.joe@perches.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 10:04:37PM -0700, Joe Perches wrote:
> fallthrough may become a pseudo reserved keyword so this only use of
> fallthrough is better renamed to allow it.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Are you referring to the __attribute__((fallthrough)) statement that gcc
supports?  If so the compiler should by all rights be able to differentiate
between a null statement attribute and a explicit goto and label without the
need for renaming here.  Or are you referring to something else?

Neil

> ---
>  net/sctp/sm_make_chunk.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 36bd8a6e82df..3fdcaa2fbf12 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2152,7 +2152,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
>  	case SCTP_PARAM_SET_PRIMARY:
>  		if (net->sctp.addip_enable)
>  			break;
> -		goto fallthrough;
> +		goto unhandled;
>  
>  	case SCTP_PARAM_HOST_NAME_ADDRESS:
>  		/* Tell the peer, we won't support this param.  */
> @@ -2163,11 +2163,11 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
>  	case SCTP_PARAM_FWD_TSN_SUPPORT:
>  		if (ep->prsctp_enable)
>  			break;
> -		goto fallthrough;
> +		goto unhandled;
>  
>  	case SCTP_PARAM_RANDOM:
>  		if (!ep->auth_enable)
> -			goto fallthrough;
> +			goto unhandled;
>  
>  		/* SCTP-AUTH: Secion 6.1
>  		 * If the random number is not 32 byte long the association
> @@ -2184,7 +2184,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
>  
>  	case SCTP_PARAM_CHUNKS:
>  		if (!ep->auth_enable)
> -			goto fallthrough;
> +			goto unhandled;
>  
>  		/* SCTP-AUTH: Section 3.2
>  		 * The CHUNKS parameter MUST be included once in the INIT or
> @@ -2200,7 +2200,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
>  
>  	case SCTP_PARAM_HMAC_ALGO:
>  		if (!ep->auth_enable)
> -			goto fallthrough;
> +			goto unhandled;
>  
>  		hmacs = (struct sctp_hmac_algo_param *)param.p;
>  		n_elt = (ntohs(param.p->length) -
> @@ -2223,7 +2223,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
>  			retval = SCTP_IERROR_ABORT;
>  		}
>  		break;
> -fallthrough:
> +unhandled:
>  	default:
>  		pr_debug("%s: unrecognized param:%d for chunk:%d\n",
>  			 __func__, ntohs(param.p->type), cid);
> -- 
> 2.15.0
> 
> 
