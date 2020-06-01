Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE85A1EAE7F
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbgFASya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgFASy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:54:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFC0C061A0E;
        Mon,  1 Jun 2020 11:54:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C57011D53F8B;
        Mon,  1 Jun 2020 11:54:26 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:54:25 -0700 (PDT)
Message-Id: <20200601.115425.2049687853139691101.davem@davemloft.net>
To:     richard_siegfried@systemli.org
Cc:     gerrit@erg.abdn.ac.uk, dccp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: dccp: Add SIOCOUTQ IOCTL support (send buffer
 fill)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200530163159.932749-1-richard_siegfried@systemli.org>
References: <20200530163159.932749-1-richard_siegfried@systemli.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:54:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Sailer <richard_siegfried@systemli.org>
Date: Sat, 30 May 2020 18:31:59 +0200

> @@ -375,6 +375,14 @@ int dccp_ioctl(struct sock *sk, int cmd, unsigned long arg)
>  		goto out;
>  
>  	switch (cmd) {
> +	case SIOCOUTQ: {
> +		/* Using sk_wmem_alloc here because sk_wmem_queued is not used by DCCP and
> +		 * always 0, comparably to UDP.
> +		 */
> +		int amount = sk_wmem_alloc_get(sk);
> +		rc = put_user(amount, (int __user *)arg);
> +	}
> +		       break;

Please fix this indentation.
