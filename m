Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7EB8BE82
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 18:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfHMQ1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 12:27:39 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36584 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfHMQ1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 12:27:39 -0400
Received: by mail-qt1-f195.google.com with SMTP id z4so107008824qtc.3;
        Tue, 13 Aug 2019 09:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P67bqGX/vujrcxhG2v/P/v/tGNN/rDOHwlJfjxRN7fo=;
        b=rJ23YYtzBLckV9ZBWZNVxeELgMeqc8wcRoEmnOTwcqgUVjijnBdBaRV9vqDdTg5WGU
         ZxzW8+2R0BdE9zqg/+IEwluBKO/gOlRVu7l6bX/wUGZEEeMRwocG9ankCWAy7qnxzC+R
         qs6NHzwkec+5Pd4w1AVeN43Ao0zrW7WdB5i4OuLwcP+N/Jo3Db7HauUFDTMYnZH8JSyg
         goRlML4SvETAOZ6leAVNlc7rA1GT64kilpfByRDjDaUSjQ+FnUPCxJWztGWd46mwymBu
         hZqLCPKpj8bNfo13IZntP49afxwUIXtw1lb4AyJme42igw06xiCQRxvDK2/CRh4215cN
         HTjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P67bqGX/vujrcxhG2v/P/v/tGNN/rDOHwlJfjxRN7fo=;
        b=T2i21Kms2ayEnjrdUNj5m9CStwnX1E1hraWjDyxbVdEySd6LPgsyhQHLgTYq3EY9EJ
         pyUbPaYonLtRLBX5fCdgbyyvkCJlHQwvH8Y6XfoiDDnErOcT7RbsTWFX7bIr6yAT2Lpi
         XFaV/VEqhaOtZAef+WMv84pSDGvRcsN8oL5DOh92jm6R7u3xHXPy86V3Lvdq9RXY/TPg
         ac2zjQKlCNvxU0w21vsN6ot1qoWGP1SU8NPnBrRjJjP4HrVXx0E0CU0Ws5NId/K2UQSp
         JdZEqEMxlcv1C0AqJH6M75l7sEXEVhzVo7cFBqa94i7wssr/3T9KUW60TLssbHw/9CoE
         S2yw==
X-Gm-Message-State: APjAAAUgh6KqRs2stf6rtI6Wv3NdYFDuw0/kwc4lCAEvcT4zy37FekiD
        uT0GBKZhG4p8crvU9mKAaqZXh0Lx
X-Google-Smtp-Source: APXvYqwBR9+eBYNSeqNNy3tTvnKXfs0t2xGxxIcB8D70nhgj8hgU2y1TZ5HZTywcT3DRljlXZ59ZrQ==
X-Received: by 2002:ac8:13cb:: with SMTP id i11mr23978573qtj.262.1565713658244;
        Tue, 13 Aug 2019 09:27:38 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.117])
        by smtp.gmail.com with ESMTPSA id q73sm35155744qke.90.2019.08.13.09.27.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 09:27:37 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id ED1F2C1628; Tue, 13 Aug 2019 13:27:34 -0300 (-03)
Date:   Tue, 13 Aug 2019 13:27:34 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: fix the transport error_count check
Message-ID: <20190813162734.GA2870@localhost.localdomain>
References: <55b2fe3e5123958ccd7983e0892bc604aa717132.1565614152.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55b2fe3e5123958ccd7983e0892bc604aa717132.1565614152.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 08:49:12PM +0800, Xin Long wrote:
> As the annotation says in sctp_do_8_2_transport_strike():
> 
>   "If the transport error count is greater than the pf_retrans
>    threshold, and less than pathmaxrtx ..."
> 
> It should be transport->error_count checked with pathmaxrxt,
> instead of asoc->pf_retrans.
> 
> Fixes: 5aa93bcf66f4 ("sctp: Implement quick failover draft from tsvwg")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Dave, please consider this one for stable. Thanks.

> ---
>  net/sctp/sm_sideeffect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index a554d6d..1cf5bb5 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -546,7 +546,7 @@ static void sctp_do_8_2_transport_strike(struct sctp_cmd_seq *commands,
>  	 */
>  	if (net->sctp.pf_enable &&
>  	   (transport->state == SCTP_ACTIVE) &&
> -	   (asoc->pf_retrans < transport->pathmaxrxt) &&
> +	   (transport->error_count < transport->pathmaxrxt) &&
>  	   (transport->error_count > asoc->pf_retrans)) {
>  
>  		sctp_assoc_control_transport(asoc, transport,
> -- 
> 2.1.0
> 
