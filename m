Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D843377AC
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 17:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbfFFPTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 11:19:03 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43210 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729015AbfFFPTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 11:19:03 -0400
Received: by mail-pg1-f195.google.com with SMTP id f25so1529856pgv.10
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 08:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CV9bqQMfskAC1dqKTJPAClj4dW5bZBs9VjKWIEFQCKY=;
        b=Ot+plG3jF61T0FMx24pUAzAl0xn19Nub6fnDZmGjqfp76d4TbbOQiz06Qqa7hs9Bwh
         iBrqYDxf74WDy7g9P8Bf0fAQoeQs/IHKWBZlgqO8zqH+uK6NIYV6Qp4r8ts8u7+mtjWq
         1WBNg5xvrDBOx7WlATNbJg2BaSXKhEqIuLZirBuzBNtUSQ/Hq6I97CJOSzn1jbitC+v6
         x9FNFzP3+eJgXa1GXAHytQRPp8y4+fyTqPsmbWYJJG/5ZE/DuwZPkMBuK2iRud+LfHEY
         h76Ljf8MePfEURStyBemOIjAJ/QFl/X2wUYks/ICFpONuyfbubYkyUIugqhsasq6A1Hh
         Y7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CV9bqQMfskAC1dqKTJPAClj4dW5bZBs9VjKWIEFQCKY=;
        b=GZ3NHrzd3ym3szpwI8mXJlde0ww/MnCbPkkSuI4SDgCOO8uBzX6vCSucJ1AILAGZZN
         +TD45uEfJoyAlE2OPJG700BYYwMpDg4kIOqCoyRSzAZKzXYY0RXvx1U6xRT8kfXC7bde
         ZchegxZnaAQguJuFyqpkrXxcAJtWwez5t12WKzU5cgdSkINfFtxZO0qgjwSQ/37ALj3H
         HFPT7dCeZpTW7EuvQsJeLQvB2as1hTi/Ch8EJo2sgPsqS+60q/NFuin3WqJwjVHRPs/8
         8aclprblh8y1D9Z9qC7xFjO/Kl349EoL4KUMKUa+MH7PmKeTR/EtEDSK1ca91cMH3o1c
         zHgg==
X-Gm-Message-State: APjAAAV9Iv+5ML/K09r2ZnuV7oUtxnx0GsODouZecMp5sdJTBiQaGphM
        8KzacZpYGdaanq6lXA/2p1Rdqg==
X-Google-Smtp-Source: APXvYqw6Gijr6xH8tFvlbxkaece80d567CnkJpA1nPve/i0fY53qVS4J/N8aOZdtO3brtmSCdH2sYw==
X-Received: by 2002:a17:90a:c481:: with SMTP id j1mr412780pjt.96.1559834343009;
        Thu, 06 Jun 2019 08:19:03 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q20sm2261577pgq.66.2019.06.06.08.19.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 08:19:02 -0700 (PDT)
Date:   Thu, 6 Jun 2019 08:18:59 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, jiri@mellanox.com
Subject: Re: [PATCH iproute2-next] devlink: Increase bus,device buffer size
 to 64 bytes
Message-ID: <20190606081859.1098a856@hermes.lan>
In-Reply-To: <20190606114919.27811-1-parav@mellanox.com>
References: <20190606114919.27811-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Jun 2019 06:49:19 -0500
Parav Pandit <parav@mellanox.com> wrote:

> Device name on mdev bus is 36 characters long which follow standard uuid
> RFC 4122.
> This is probably the longest name that a kernel will return for a
> device.
> 
> Hence increase the buffer size to 64 bytes.
> 
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> 
> ---
>  devlink/devlink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index 436935f8..559f624e 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -1523,7 +1523,7 @@ static void __pr_out_handle_start(struct dl *dl, struct nlattr **tb,
>  {
>  	const char *bus_name = mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]);
>  	const char *dev_name = mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
> -	char buf[32];
> +	char buf[64];
>  
>  	sprintf(buf, "%s/%s", bus_name, dev_name);
>  
> @@ -1616,7 +1616,7 @@ static void __pr_out_port_handle_start(struct dl *dl, const char *bus_name,
>  				       uint32_t port_index, bool try_nice,
>  				       bool array)
>  {
> -	static char buf[32];
> +	static char buf[64];
>  	char *ifname = NULL;
>  
>  	if (dl->no_nice_names || !try_nice ||

I will take this now no need to wait for next
