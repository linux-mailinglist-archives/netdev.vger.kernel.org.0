Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6775A5EDD
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 03:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfICBbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 21:31:31 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42745 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfICBbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 21:31:31 -0400
Received: by mail-qt1-f193.google.com with SMTP id t12so17645231qtp.9;
        Mon, 02 Sep 2019 18:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UwfO+YyQXoTyVzMx90F96mSPWuwdM6gxPcenlQOzb7s=;
        b=rfEhZ1swlCxLLcAcrI/RiUzsX7yz34sSM372gxHOVSN4u5COAAUNx0TJfGBUrd5DU+
         gQyK2sZYyS2eCJEKaxCCteoYN472IyDBoM/jERah3GcJMNokTBnDsglCfXRqk8Ip4tPy
         lcKJC3erLp+GgIOH/9qgGJZXq6PG8CSaGUGXle03L5daejojhjytdJ7uY29Jqbpb9DEn
         2WzZkFR9E2QB3oenYw5KGdbP3tRqSgvoTL1qj7JaA8wbfWWSBwnY5FDy2HsEs8x6OR5Q
         Zz1VAZ9xu/X6AZh3+Mkq/xeXpko0tPrXzwgNx5V4lLsEPsm1gpu//YOSyNXVc5uys94p
         VskQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UwfO+YyQXoTyVzMx90F96mSPWuwdM6gxPcenlQOzb7s=;
        b=OePH2uvnYEsQwTmtE14mQUjFCyDeII6ZLxkbMCKNp9j5J+JHlApS+TcwhNivb9T9dJ
         M2LV9gLPQpp1qX67clIaCzgE9jHNLOrB7gP8qHM1rk0JWyQwvG1Ven93gm+yh/q2C9Tl
         3MnGpjlXVOgK675jKIvCl9Px8Mj3EU4qPBL0Gm3xWNVLPiIN5YSJ1VXqLbZdKAepyJ+T
         SnfZnMP6IWu61tH2vuuDCpO+TJ88saZv/OLRqi2IYYrqyCt0510OHkPrilVpbF8GjhVW
         Hl+ek428m06RbfPWoChCCj2FNAamEIgwvqtZgID8qQS7NnfuDYBNQKFCbctefJ1zoMz3
         0O4Q==
X-Gm-Message-State: APjAAAXrZqg5Kt+gqsrxXylvIOJA4OSu9t4a8ukjEjAqf2fcB6rm/BlS
        SjrRRGddFnB2/lBMTE5O94o=
X-Google-Smtp-Source: APXvYqzfap68Uje8NBUXn3htdXGKp406ezTiZfe1anThp8t6xj0nFtku7VxJVCi5M2axyHKYSRQfZQ==
X-Received: by 2002:aed:3c52:: with SMTP id u18mr12783150qte.194.1567474289891;
        Mon, 02 Sep 2019 18:31:29 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:f7da:37d1:dcc1:ef78:a481])
        by smtp.gmail.com with ESMTPSA id u28sm8958197qtu.22.2019.09.02.18.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 18:31:29 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 96F7FC0D97; Mon,  2 Sep 2019 22:31:26 -0300 (-03)
Date:   Mon, 2 Sep 2019 22:31:26 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: use transport pf_retrans in
 sctp_do_8_2_transport_strike
Message-ID: <20190903013126.GA3499@localhost.localdomain>
References: <41769d6033d27d629798e060671a3b21f22e2a21.1567437861.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41769d6033d27d629798e060671a3b21f22e2a21.1567437861.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
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

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

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
