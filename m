Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C355246CEB3
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244673AbhLHIOo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Dec 2021 03:14:44 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:3350 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235521AbhLHIOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 03:14:44 -0500
X-Greylist: delayed 1186 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Dec 2021 03:14:43 EST
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1murjT-000NdV-52; Wed, 08 Dec 2021 08:51:19 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1murjS-000Tbw-B7; Wed, 08 Dec 2021 08:51:18 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 1D6CA240041;
        Wed,  8 Dec 2021 08:51:18 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id A977B240040;
        Wed,  8 Dec 2021 08:51:17 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 433E22030A;
        Wed,  8 Dec 2021 08:51:17 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date:   Wed, 08 Dec 2021 08:51:17 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     =?UTF-8?Q?J=CE=B5an_Sacren?= <sakiwit@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: x25: drop harmless check of !more
Organization: TDT AG
In-Reply-To: <20211208024732.142541-5-sakiwit@gmail.com>
References: <20211208024732.142541-5-sakiwit@gmail.com>
Message-ID: <591bfc0470ca596995e13337460f99d0@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.17
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: 8BIT
X-purgate: clean
X-purgate-ID: 151534::1638949878-000118D4-7626970E/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-08 08:20, Jεan Sacren wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> 'more' is checked first.  When !more is checked immediately after that,
> it is always true.  We should drop this check.
> 
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> ---
>  net/x25/x25_in.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/x25/x25_in.c b/net/x25/x25_in.c
> index e1c4197af468..b981a4828d08 100644
> --- a/net/x25/x25_in.c
> +++ b/net/x25/x25_in.c
> @@ -41,7 +41,7 @@ static int x25_queue_rx_frame(struct sock *sk,
> struct sk_buff *skb, int more)
>  		return 0;
>  	}
> 
> -	if (!more && x25->fraglen > 0) {	/* End of fragment */
> +	if (x25->fraglen > 0) {	/* End of fragment */
>  		int len = x25->fraglen + skb->len;
> 
>  		if ((skbn = alloc_skb(len, GFP_ATOMIC)) == NULL){

Acked-by: Martin Schiller <ms@dev.tdt.de>
