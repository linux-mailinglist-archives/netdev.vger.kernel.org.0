Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D002D17996E
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387969AbgCDUBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:01:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387931AbgCDUBD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:01:03 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5722421556;
        Wed,  4 Mar 2020 20:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583352062;
        bh=I86E2jHnRYDyj8EwcgE8o1k+FAQOOsDkTtDmXH8xLD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G92vwPbW7lENa8i3kfjBaH+aZQElwlaPcQ3rxKfojxSs1028Yx7vwfj3f7+8/ENjj
         6HvDqSKbmx+XRhP+MvASsf7yj3DB0aD20DOLZkA1ZYYmcFdKRaNOm0lEVfmsBRXSoM
         LzOwkBFeqax31bd/nkPxl6lN5kUvXjP9VGw5YJ4U=
Date:   Wed, 4 Mar 2020 12:01:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: rmnet: print error message when
 command fails
Message-ID: <20200304120100.369c6de7@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200304075102.23430-1-ap420073@gmail.com>
References: <20200304075102.23430-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Mar 2020 07:51:02 +0000 Taehee Yoo wrote:
> @@ -263,12 +262,16 @@ static int rmnet_rtnl_validate(struct nlattr *tb[], struct nlattr *data[],
>  {
>  	u16 mux_id;
>  
> -	if (!data || !data[IFLA_RMNET_MUX_ID])
> +	if (!data || !data[IFLA_RMNET_MUX_ID]) {
> +		NL_SET_ERR_MSG_MOD(extack, "MUX ID not specifies");
>  		return -EINVAL;
> +	}

nit: typo in specified ?
