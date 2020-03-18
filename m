Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92EB01897E0
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbgCRJ0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:26:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:29535 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbgCRJ0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:26:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584523591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1qGXHmo6zQlOJUVGU6+V+s7qzR5Y8nEM9Xk6bPWFSOA=;
        b=WzwUrYxFRWZfp4UFeYOedBPa/jKruYzuGtneMwqrZN1JbS4IbZ2dD0D6UP5iSRUJYnG9cT
        hVlB5yZyHkGVEMMPtYyZvpnfrbgrjQ3vxnP03bBeVIP2bk8fE/0kvAQ/FRX03VaqOqdlwy
        IGT2FCdBvnYMRBJmB/ou3dKoNwfajJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-345NDzGCMeG3TODua96K0g-1; Wed, 18 Mar 2020 05:26:29 -0400
X-MC-Unique: 345NDzGCMeG3TODua96K0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42E2D107ACC7;
        Wed, 18 Mar 2020 09:26:28 +0000 (UTC)
Received: from ovpn-115-29.ams2.redhat.com (ovpn-115-29.ams2.redhat.com [10.36.115.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33E067387B;
        Wed, 18 Mar 2020 09:26:23 +0000 (UTC)
Message-ID: <2a5b1c0194a92bcaa626c071701a399cc85ee0b4.camel@redhat.com>
Subject: Re: [PATCH net-next] mptcp: Remove set but not used variable
 'can_ack'
From:   Paolo Abeni <pabeni@redhat.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Wed, 18 Mar 2020 10:26:22 +0100
In-Reply-To: <20200318020157.178956-1-yuehaibing@huawei.com>
References: <20200318020157.178956-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-03-18 at 02:01 +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> net/mptcp/options.c: In function 'mptcp_established_options_dss':
> net/mptcp/options.c:338:7: warning:
>  variable 'can_ack' set but not used [-Wunused-but-set-variable]
> 
> commit dc093db5cc05 ("mptcp: drop unneeded checks")
> leave behind this unused, remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/mptcp/options.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/net/mptcp/options.c b/net/mptcp/options.c
> index 63c8ee49cef2..8ba34950241c 100644
> --- a/net/mptcp/options.c
> +++ b/net/mptcp/options.c
> @@ -335,7 +335,6 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
>  	struct mptcp_sock *msk;
>  	unsigned int ack_size;
>  	bool ret = false;
> -	bool can_ack;
>  	u8 tcp_fin;
>  
>  	if (skb) {
> @@ -364,7 +363,6 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
>  	/* passive sockets msk will set the 'can_ack' after accept(), even
>  	 * if the first subflow may have the already the remote key handy
>  	 */
> -	can_ack = true;
>  	opts->ext_copy.use_ack = 0;
>  	msk = mptcp_sk(subflow->conn);
>  	if (!READ_ONCE(msk->can_ack)) {

Yep, left-over on my side! Thanks for clearing it!

Acked-by: Paolo Abeni <pabeni@redhat.com>

