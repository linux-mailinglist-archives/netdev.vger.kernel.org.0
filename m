Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CB34458D1
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhKDRpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbhKDRpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 13:45:33 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD2AC061714;
        Thu,  4 Nov 2021 10:42:54 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k4so8442230plx.8;
        Thu, 04 Nov 2021 10:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oPgoOWiVy0D0tb3kwUPanVVDmcRg1+IqSLXSRyJ8IBk=;
        b=q0vNaQSRPVYGhmZQ5EYt/vy2uwmKcYnqg174tmQRVZG1WmdGFS4TbgEhdABFERZR9w
         b2RED3ckCHnS1UoFwdfYXtcjD9c2LiGXWAkRvNqfOE7OiicDgQlz5fDL2ZwSOeNIBLf/
         UqsUmg+ive3oIoLA5bsQ/5xNTDerB711mNc/kFVPutJbkGqDmReuOGrFNiAIPeI+WpJ7
         IJ0czCTV3wd/yi8ixalcY581Z/VnNpg3IPmYAiLsPUn2EQYiDsj4IH9mM5tuvqL5Odmf
         DQUQNONtgDnjao4bSoFJOjXblV09KCHp5lWIdd/aeb/IqF/LkLT83YeGu8Y3TwfwxKWX
         QXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oPgoOWiVy0D0tb3kwUPanVVDmcRg1+IqSLXSRyJ8IBk=;
        b=Wa0q8cLLWVtsezdh1KU7jp5cgpoqIz1+XEBNKAq7YBcHRf8Mqz4i18WCg/nbPb7CUn
         B6VVmFqsMHAaMB13iwmI5XBn1w9pv7m2c2hfLvy91BWYBCmsfbFPbkFRurmwGa1S+VvU
         xosykXFbfb6B4ta6kLWqFQXMI+aHAZxjouvWIZzqvUBACYLEIVpjtnVrNdlRkZN/b1hK
         Jbw/aYOHEBCgOBEM9CmHUW87IOlvhRJALdrTGXt4sOfUC9jn6USXvg4fGGlf3A567Y1d
         vsYcHWz6BnXh2bIOT+8lzzt7MWA7Zr91H0g86xQM0sE197FxYrmRmalUd6iAT48Gprxc
         yQ4A==
X-Gm-Message-State: AOAM530HMFskbl0I4qor/iyfgqqAvgXPn0rz8LJYnPGu+Y8DUmsSlzHr
        PIuPUEWg+hAzKET5MIcA9fM=
X-Google-Smtp-Source: ABdhPJxqRIRgVf2sLLNWA77T5TlkRLn+wicEAKxd0Pb3L4kqr8zpcCBnNewWgZhsVj7gTA8ZTSmYUQ==
X-Received: by 2002:a17:90b:4b09:: with SMTP id lx9mr10478993pjb.100.1636047774507;
        Thu, 04 Nov 2021 10:42:54 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id o19sm5820445pfu.56.2021.11.04.10.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 10:42:54 -0700 (PDT)
Date:   Thu, 4 Nov 2021 10:42:51 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Martin Kaistra <martin.kaistra@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] net: dsa: b53: Expose PTP timestamping ioctls to
 userspace
Message-ID: <20211104174251.GB32548@hoboy.vegasvil.org>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-8-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104133204.19757-8-martin.kaistra@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 02:32:01PM +0100, Martin Kaistra wrote:
> +static int b53_set_hwtstamp_config(struct b53_device *dev, int port,
> +				   struct hwtstamp_config *config)
> +{
> +	struct b53_port_hwtstamp *ps = &dev->ports[port].port_hwtstamp;
> +	bool tstamp_enable = false;
> +
> +	clear_bit_unlock(B53_HWTSTAMP_ENABLED, &ps->state);
> +
> +	/* Reserved for future extensions */
> +	if (config->flags)
> +		return -EINVAL;
> +
> +	switch (config->tx_type) {
> +	case HWTSTAMP_TX_ON:
> +		tstamp_enable = true;
> +		break;
> +	case HWTSTAMP_TX_OFF:
> +		tstamp_enable = false;
> +		break;
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	switch (config->rx_filter) {
> +	case HWTSTAMP_FILTER_NONE:
> +		tstamp_enable = false;
> +		break;
> +	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> +	case HWTSTAMP_FILTER_PTP_V2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:

This is incorrect.  HWTSTAMP_FILTER_PTP_V2_EVENT includes support for
UDP/IPv4 and UDP/IPv6.  Driver should return error here.

> +	case HWTSTAMP_FILTER_ALL:
> +		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
> +		break;
> +	default:
> +		return -ERANGE;
> +	}

Thanks,
Richard
