Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1401F1853FC
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 03:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCNC0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 22:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbgCNC0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 22:26:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B512720663;
        Sat, 14 Mar 2020 02:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584152795;
        bh=AcJjJyWn5ByJbwtEz4BGq+xcuACI0IwUCrM4Q1XGnMI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qT5imk+Rcv0q6OLRfWaLfXPZCf0ymZ01i/IhtVZHGCwljz0IDWJI9COcx3oi5UT5Q
         bW/4Ukk85xOZwWH6vMnWDH+h8vBDQAAS8yN/g7pqrs/Aw6HqDkwJ37fGs9G+PtiWlo
         o7eRZB/q5Z14t+K41rknCavEVQAZcS9wGwEgSD+U=
Date:   Fri, 13 Mar 2020 19:26:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Bersenev <bay@hackerdom.ru>
Cc:     Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cdc_ncm: Fix the build warning
Message-ID: <20200313192632.7900a288@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200313213823.178435-2-bay@hackerdom.ru>
References: <20200313213823.178435-1-bay@hackerdom.ru>
        <20200313213823.178435-2-bay@hackerdom.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Mar 2020 02:38:21 +0500 Alexander Bersenev wrote:
> The ndp32->wLength is two bytes long, so replace cpu_to_le32 with cpu_to_le16.

missing signoff

> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index 5569077bd5b8..8929669b5e6d 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -1172,7 +1172,7 @@ static struct usb_cdc_ncm_ndp32 *cdc_ncm_ndp32(struct cdc_ncm_ctx *ctx, struct s
>  		ndp32 = ctx->delayed_ndp32;
>  
>  	ndp32->dwSignature = sign;
> -	ndp32->wLength = cpu_to_le32(sizeof(struct usb_cdc_ncm_ndp32) + sizeof(struct usb_cdc_ncm_dpe32));
> +	ndp32->wLength = cpu_to_le16(sizeof(struct usb_cdc_ncm_ndp32) + sizeof(struct usb_cdc_ncm_dpe32));
>  	return ndp32;

Isn't this code added in the previous patch? Why not squash them
together?
