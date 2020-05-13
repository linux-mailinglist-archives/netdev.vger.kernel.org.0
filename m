Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452581D1CC4
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390010AbgEMSBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732488AbgEMSBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:01:03 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A771C061A0C;
        Wed, 13 May 2020 11:01:03 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id r8so539668qtm.11;
        Wed, 13 May 2020 11:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=djizPthGumhy0aa82+s6m3Q9KQZDbFYAxoC6yOMwIJE=;
        b=bAlDH4C90L0WzuRWsV4+5Ckq+bqXFHL0YffjYTiIuP49rNtPXi8CvoXPRhlbDCns+x
         gC+7ZNqshiqIAcsWjLCQjmdrO9oOMlgzWJt0Xj3ZekTSDW9iCVFPAciWKXwTtsaX1rZ2
         VXCvvcg46I46jlg7EFLEyU90g8qDy5piGIZW0hen68PREB7hgPLiPfR3hs/JkD6zQYkN
         qhNZuKBqh3uPmvPNqsvUQXsiprnLUtG/XpqeqOiXfQs/5jIJPARkKZ81vF+9uN+yzLI2
         eDKxA7G8EEOFtgRLiqaZBFmhCr8blUDY0MqJ/GRWYF1K7PJ/mlVIvS7rM9jzk67nFQW1
         Y3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=djizPthGumhy0aa82+s6m3Q9KQZDbFYAxoC6yOMwIJE=;
        b=Vb1VY/D7jT5BCbZ9ToaFaOLKaN2+kpXpimp3Zllwigjen1/4Kh5iuQy3ioxPYUI4FG
         wNd/1XtV+Wo3rbN/2hk1jikKtXyvwg5OWFVYSN4xdNXYpU8CxeGF0NLMPUA7pivwR4ac
         B0fGr0pisf/ZE0hZCtyYTNH2vVPbeFSJob1XQCg0pR1Y4qf4W8cLoRC0JzM1xj5PD99h
         eXkGJ/Dee12f9laCXbpDgZZ2kNohfoFTviJI6jgqXy8X9AWuqqCAH0Ql6tnUIOU7b0/u
         eOOFty1laN8gtMZDRpy6uhDZSVcRtItGpbh9QYToLXkYkbo/Ij3/lJArLysFWaUD5sH8
         hL+w==
X-Gm-Message-State: AOAM530bLBHGoPAAvYE8cJ+3dayoO8voLV8QG1tZolYc2Ct4rPCudd2z
        k7Y4idS777sG35MhcS96kz4=
X-Google-Smtp-Source: ABdhPJzqbx3RBTNCuLykPLCx+cM+JeljoJjlYEyBds2uiDxtrploYjJasdpV7X3XZIToMReWEu/bXw==
X-Received: by 2002:ac8:4b67:: with SMTP id g7mr328118qts.346.1589392862149;
        Wed, 13 May 2020 11:01:02 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:f4e9:6bc3:5a0:7baf:1a14])
        by smtp.gmail.com with ESMTPSA id v28sm310105qtb.49.2020.05.13.11.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 11:01:01 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 88707C08DA; Wed, 13 May 2020 15:00:58 -0300 (-03)
Date:   Wed, 13 May 2020 15:00:58 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 27/33] sctp: export sctp_setsockopt_bindx
Message-ID: <20200513180058.GB2491@localhost.localdomain>
References: <20200513062649.2100053-1-hch@lst.de>
 <20200513062649.2100053-28-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513062649.2100053-28-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 08:26:42AM +0200, Christoph Hellwig wrote:
> And call it directly from dlm instead of going through kernel_setsockopt.

The advantage on using kernel_setsockopt here is that sctp module will
only be loaded if dlm actually creates a SCTP socket.  With this
change, sctp will be loaded on setups that may not be actually using
it. It's a quite big module and might expose the system.

I'm okay with the SCTP changes, but I'll defer to DLM folks to whether
that's too bad or what for DLM.

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dlm/lowcomms.c       | 13 ++++++++-----
>  include/net/sctp/sctp.h |  3 +++
>  net/sctp/socket.c       |  5 +++--
>  3 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
> index b722a09a7ca05..e4939d770df53 100644
> --- a/fs/dlm/lowcomms.c
> +++ b/fs/dlm/lowcomms.c
> @@ -1005,14 +1005,17 @@ static int sctp_bind_addrs(struct connection *con, uint16_t port)
>  		memcpy(&localaddr, dlm_local_addr[i], sizeof(localaddr));
>  		make_sockaddr(&localaddr, port, &addr_len);
>  
> -		if (!i)
> +		if (!i) {
>  			result = kernel_bind(con->sock,
>  					     (struct sockaddr *)&localaddr,
>  					     addr_len);
> -		else
> -			result = kernel_setsockopt(con->sock, SOL_SCTP,
> -						   SCTP_SOCKOPT_BINDX_ADD,
> -						   (char *)&localaddr, addr_len);
> +		} else {
> +			lock_sock(con->sock->sk);
> +			result = sctp_setsockopt_bindx(con->sock->sk,
> +					(struct sockaddr *)&localaddr, addr_len,
> +					SCTP_BINDX_ADD_ADDR);
> +			release_sock(con->sock->sk);
> +		}
>  
>  		if (result < 0) {
>  			log_print("Can't bind to %d addr number %d, %d.\n",
> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> index 3ab5c6bbb90bd..f702b14d768ba 100644
> --- a/include/net/sctp/sctp.h
> +++ b/include/net/sctp/sctp.h
> @@ -615,4 +615,7 @@ static inline bool sctp_newsk_ready(const struct sock *sk)
>  	return sock_flag(sk, SOCK_DEAD) || sk->sk_socket;
>  }
>  
> +int sctp_setsockopt_bindx(struct sock *sk, struct sockaddr *kaddrs,
> +		int addrs_size, int op);
> +
>  #endif /* __net_sctp_h__ */
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 1c96b52c4aa28..30c981d9f6158 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -979,8 +979,8 @@ int sctp_asconf_mgmt(struct sctp_sock *sp, struct sctp_sockaddr_entry *addrw)
>   *
>   * Returns 0 if ok, <0 errno code on error.
>   */
> -static int sctp_setsockopt_bindx(struct sock *sk, struct sockaddr *kaddrs,
> -				 int addrs_size, int op)
> +int sctp_setsockopt_bindx(struct sock *sk, struct sockaddr *kaddrs,
> +		int addrs_size, int op)
>  {
>  	int err;
>  	int addrcnt = 0;
> @@ -1032,6 +1032,7 @@ static int sctp_setsockopt_bindx(struct sock *sk, struct sockaddr *kaddrs,
>  		return -EINVAL;
>  	}
>  }
> +EXPORT_SYMBOL(sctp_setsockopt_bindx);
>  
>  static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
>  				 const union sctp_addr *daddr,
> -- 
> 2.26.2
> 
