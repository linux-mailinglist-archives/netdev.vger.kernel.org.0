Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958422B7E32
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 14:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgKRNSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 08:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgKRNSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 08:18:51 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2A2C0613D4;
        Wed, 18 Nov 2020 05:18:51 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id g7so1421995pfc.2;
        Wed, 18 Nov 2020 05:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SwgmCoRQqgDi9SwspMTBUmX6vuFIHjell7qTbg11fzE=;
        b=J8LYV8vaid4hvw7F9n9qrI/Ctn5Y9xYMaCpcVdxPTfdxbxhtE3qBy3JowQgQVGYuPB
         GM7Sv5KpvlA9OBnlfOuJcEr/vGmXIlvMix9pYM1xhsQtEA/kS/8/caXJP6xnJPdyPFtH
         xjjtuvbEefrv8MKVAuLy/PUlATfuWp9gqV6eB40LVEVQctNPoYB6VVSeCrLz8qXVRkni
         PHsCz0Na8goCCXC1UCpInTgopvApd0Y47GYFe1EQxraytSZwOQFBt19sU5xoEK+q03z2
         RIOaNlBJETigQXj9aLqZ3h741xJtNqjajlCx+3fDInCFRJPnfzw4LNg6dA3Izo70VjmZ
         BJCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SwgmCoRQqgDi9SwspMTBUmX6vuFIHjell7qTbg11fzE=;
        b=KGmIdevIJQPKIGBBczK29YVejCR/KwCjLtIEIV1wA/zXj+IIukCll5uTro/subcvph
         6p+rjoFVp6oveP8sX7/RJIoudzO1LSFue7WqY2y3856U21HfPt39MeG0Ka7pdrDRd1dP
         GBGsRMypHU3H1bFcjvjGPS/+kDp4n+iRwNmx+sm4hGU9xO3TDFNSYGiLcCmRn22xXk3x
         rnKu95FzKMVvxf4hRzAH9Ikr9LPhQKpvBC2l1IIiRO+TMQsjh5IQJdXG10AHnPHj0UuJ
         XOMv6Vg+r+u8XA4DVi+dNct9Rf1hIuhVXRxXnwaT7bKtIPJ/mE2mMig7k9oE2jrGk9JR
         OudA==
X-Gm-Message-State: AOAM530CWBrS4NW6B65WDJOYuMUEVwM4jLZgn6nzzyecBKcConTPAudw
        vIpvqAUbBjwfyzwSpMCwbaYZtUqjRoA=
X-Google-Smtp-Source: ABdhPJyoqK2ra5D+t5eEXvemIoZnKKGCufzzjUJO7W3OTTnydsIB2jUSBHacZQAWOPrkCZTeODUESw==
X-Received: by 2002:a62:75c6:0:b029:18a:d510:ff60 with SMTP id q189-20020a6275c60000b029018ad510ff60mr4533830pfc.35.1605705531280;
        Wed, 18 Nov 2020 05:18:51 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 131sm10228225pfw.117.2020.11.18.05.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 05:18:50 -0800 (PST)
Date:   Wed, 18 Nov 2020 05:18:47 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net-next 1/4] net: ptp: introduce enum ptp_msg_type
Message-ID: <20201118131847.GE23320@hoboy.vegasvil.org>
References: <20201117193124.9789-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117193124.9789-1-ceggers@arri.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 08:31:21PM +0100, Christian Eggers wrote:
> Using a PTP wide enum will obsolete different driver internal defines
> and uses of magic numbers.

I like the general idea, but ...

> +enum ptp_msg_type {
> +	PTP_MSGTYPE_SYNC        = 0x0,
> +	PTP_MSGTYPE_DELAY_REQ   = 0x1,
> +	PTP_MSGTYPE_PDELAY_REQ  = 0x2,
> +	PTP_MSGTYPE_PDELAY_RESP = 0x3,
> +};

I would argue that these should be #defines.  After all, they are
protocol data fields and not an abstract enumerated types.

For example ...

> @@ -103,10 +110,10 @@ struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type);
>   *
>   * Return: The message type
>   */
> -static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
> +static inline enum ptp_msg_type ptp_get_msgtype(const struct ptp_header *hdr,
>  				 unsigned int type)
>  {
> -	u8 msgtype;
> +	enum ptp_msg_type msgtype;
>  
>  	if (unlikely(type & PTP_CLASS_V1)) {
>  		/* msg type is located at the control field for ptp v1 */

		msgtype = hdr->control;
	} else {
		msgtype = hdr->tsmt & 0x0f;

This assigns directly from protocol data into an enumerated type.

	}

	return msgtype;

Thanks,
Richard

