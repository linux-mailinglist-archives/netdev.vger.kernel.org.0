Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465D12A09DD
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgJ3P3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:29:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgJ3P3H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 11:29:07 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADC0D20725;
        Fri, 30 Oct 2020 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604071747;
        bh=VJ0D4N8MvBdVDAdA7jCi+yPAZuB3T0bsLr6EovWmk1c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L/jErUDIERuoe24GRKf5ZbwmQ73DIY+wp6VHzR5WafYs2siqmOIst4Rsv7jjWKJl5
         oK0YjRvxfGtGvaZ8D4FEWsOJ3kgIb/jqoTmk4FhsRtqDEFhpbPIXkIlH60ceDp9eIS
         a3hiBLgqofAXgVLhinZm2FWlt7nHrephjRpCKNJc=
Date:   Fri, 30 Oct 2020 08:29:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mark Deneen <mdeneen@saucontech.com>
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, Klaus Doth <krnl@doth.eu>
Subject: Re: [PATCH net v2] cadence: force nonlinear buffers to be cloned
Message-ID: <20201030082905.78df525f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030125139.613813-1-mdeneen@saucontech.com>
References: <20201030125139.613813-1-mdeneen@saucontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 12:51:39 +0000 Mark Deneen wrote:
> Suggested-by: Klaus Doth <krnl@doth.eu>
> Fixes: 653e92a91 ("macb: add support for padding and fcs computation")

Fixes tag: Fixes: 653e92a91 ("macb: add support for padding and fcs computation")
Has these problem(s):
	- SHA1 should be at least 12 digits long
	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
	  or later) just making sure it is not set (or set to "auto").
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'

>  static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
>  {
> -	bool cloned = skb_cloned(*skb) || skb_header_cloned(*skb);
> +	bool cloned = skb_cloned(*skb) || skb_header_cloned(*skb) ||
> +	              skb_is_nonlinear(*skb);
>  	int padlen = ETH_ZLEN - (*skb)->len;
>  	int headroom = skb_headroom(*skb);
>  	int tailroom = skb_tailroom(*skb);

Checkpatch says:

ERROR: code indent should use tabs where possible
#89: FILE: drivers/net/ethernet/cadence/macb_main.c:1933:
+^I              skb_is_nonlinear(*skb);$
