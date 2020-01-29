Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49E3314CF2C
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 18:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgA2RFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 12:05:53 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46916 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgA2RFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 12:05:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=P4tdL2AHheexdQ9B5SESfpUeciM9EuFDhjx/EaESmDQ=; b=Gncw31nPpEwyn6sh87vDVsfAu
        Th42PYilaZKy4NG1VOcOuAgcr3BpRQ+yC2nsWgAhhYT1AXeYbpAinaQkPqWj2y0S68epAykf/4U2e
        fdeZcanIcX8+8xzOdQnk5F/5Hl8PEp2IS5FcZmfADjlALd/URus0jtYxVsUxDsZLb7zVGNQ24BSTa
        9qMF7eMd9A/7v+W7y8x4Y644QIi/75RklIsoFzBsWdPEkNXpFD1smPqjtxTMuLCFcWg6T/goNrtBM
        H9lur4Yysm/7tWqDYDzyandZUUiuWvWzR2icNSMsTCOrKwL07+wqN6WbDi245MOFZSyzYNkCi+G22
        V6N/fxpHg==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwqml-0008Ix-Ss; Wed, 29 Jan 2020 17:05:51 +0000
Subject: Re: [PATCH] mptcp: Fix build with PROC_FS disabled.
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net
References: <20200129.104052.577025513894647835.davem@davemloft.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <64021ac4-2c13-09d2-5167-0b3fea2bfc4f@infradead.org>
Date:   Wed, 29 Jan 2020 09:05:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200129.104052.577025513894647835.davem@davemloft.net>
Content-Type: text/plain; charset=iso-8859-7
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/29/20 1:40 AM, David Miller wrote:
> 
> net/mptcp/subflow.c: In function ¡mptcp_subflow_create_socket¢:
> net/mptcp/subflow.c:624:25: error: ¡struct netns_core¢ has no member named ¡sock_inuse¢
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> ---
> 
> Applied to 'net'.
> 
>  net/mptcp/subflow.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index 1662e1178949..205dca1c30b7 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -621,7 +621,9 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
>  	 */
>  	sf->sk->sk_net_refcnt = 1;
>  	get_net(net);
> +#ifdef CONFIG_PROC_FS
>  	this_cpu_add(*net->core.sock_inuse, 1);
> +#endif
>  	err = tcp_set_ulp(sf->sk, "mptcp");
>  	release_sock(sf->sk);
>  
> 


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
