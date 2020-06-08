Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5674C1F1C02
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 17:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbgFHPZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 11:25:27 -0400
Received: from fieldses.org ([173.255.197.46]:34260 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729668AbgFHPZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 11:25:27 -0400
Received: by fieldses.org (Postfix, from userid 2815)
        id D9889878C; Mon,  8 Jun 2020 11:25:25 -0400 (EDT)
Date:   Mon, 8 Jun 2020 11:25:25 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Chen Zhou <chenzhou10@huawei.com>
Cc:     trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        chuck.lever@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] sunrpc: use kmemdup_nul() in gssp_stringify()
Message-ID: <20200608152525.GA30639@fieldses.org>
References: <20200508124000.170708-1-chenzhou10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508124000.170708-1-chenzhou10@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, applied.--b.

On Fri, May 08, 2020 at 08:40:00PM +0800, Chen Zhou wrote:
> It is more efficient to use kmemdup_nul() if the size is known exactly
> .
> 
> According to doc:
> "Note: Use kmemdup_nul() instead if the size is known exactly."
> 
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> ---
>  net/sunrpc/auth_gss/gss_rpc_upcall.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sunrpc/auth_gss/gss_rpc_upcall.c b/net/sunrpc/auth_gss/gss_rpc_upcall.c
> index 0349f455a862..af9c7f43859c 100644
> --- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
> +++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
> @@ -223,7 +223,7 @@ static int gssp_alloc_receive_pages(struct gssx_arg_accept_sec_context *arg)
>  
>  static char *gssp_stringify(struct xdr_netobj *netobj)
>  {
> -	return kstrndup(netobj->data, netobj->len, GFP_KERNEL);
> +	return kmemdup_nul(netobj->data, netobj->len, GFP_KERNEL);
>  }
>  
>  static void gssp_hostbased_service(char **principal)
> -- 
> 2.20.1
