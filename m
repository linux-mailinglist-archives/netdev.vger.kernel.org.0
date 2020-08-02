Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1F8235807
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 17:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgHBPSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 11:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbgHBPSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 11:18:13 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C63C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 08:18:13 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w19so6536061plq.3
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 08:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jZBq3WRnEZsKFCeZzVP3yRVu/sggNmqoYBy/PpOEzf0=;
        b=Dxq1UmrEVS9T8I7V4gSfZZVw2vzIB0Auw2p/xurSdVpQ7e6UUryCS+jHrzDS2xEX6x
         avzOkUSHBo6ivwRcDIzYQxBA/kbXaot/54Kf3zhRnyuFJ3E/4uduv78UzhQWLqvRl/EL
         zgtyJMVq3m6cD4FH2HszSkEsEcB90Jk6f+C3UoKTJRZUvb/905QkNDb3MCLzw8Rvve/o
         WFfY6ha1bXUt26wQBTh+07sjUipP6Gp/+qBs1dAR75zXm8evx6fibBBUT+unzHBS6PD1
         KcJ24TKXGAXWAvdqDShR3tmwDm0ZPfUcVF5qQ3r9wyGpzDZcYhaIza4HTipJSNUPWIjH
         +XxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jZBq3WRnEZsKFCeZzVP3yRVu/sggNmqoYBy/PpOEzf0=;
        b=N4YcRCThREo6x2rsj5PF9fs5gWljqOCcam8TD8qZqZe8fbQNaIJjLa0mbTFT0bCIjp
         3XPFSV+tLvZrg969hvc8FklSVokVnW5maw9KZllPBQlfiOKxnQvAcnUEWc1H+jTB/MXL
         CJTWQZvq4Y2c4X5UvXhB/SvRNi4eKbUCKPHsRn8VY0bnv5c01WWdq2BoW71oa/LI3Xi8
         RGcJS7x6UJnLxoNZy2QB1Vy/GJpus6be3pOPSdkN3JGbpe4ospo3hQPnf79tVsl1dYur
         xem9itXX0jxwNS1RLgtn8LvYLE/AVqyfcZLIQbx0eu/ngjoF9ITQaWJdD3MEuCZqb0Bz
         +qeQ==
X-Gm-Message-State: AOAM532WSgF+tR8huw+XK7EN2G4Dm12koKnHIyklyYyF2Lx9Lh6cAxe4
        3a6KO7OAUIUcXCvrkAqm770=
X-Google-Smtp-Source: ABdhPJw6QybzrRUDYpRU58Ps1jRDQnBDOwhoqjIOwDsgWdjOOCCfF6OiA0dbpHzWFEzcQmZGC/hyBw==
X-Received: by 2002:a17:90b:684:: with SMTP id m4mr345296pjz.4.1596381492515;
        Sun, 02 Aug 2020 08:18:12 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id n13sm9427881pjb.20.2020.08.02.08.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 08:18:11 -0700 (PDT)
Date:   Sun, 2 Aug 2020 08:18:09 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH v3 2/9] ptp: Add generic ptp message type function
Message-ID: <20200802151809.GB14759@hoboy>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-3-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730080048.32553-3-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 10:00:41AM +0200, Kurt Kanzenbach wrote:
> The message type is located at different offsets within the ptp header depending
> on the ptp version (v1 or v2). Therefore, drivers which also deal with ptp v1
> have some code for it.
> 
> Extract this into a helper function for drivers to be used.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Richard Cochran <richardcochran@gmail.com>

CodingStyle nit below...

> ---
>  include/linux/ptp_classify.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
> index 26fd38a4bd67..f4dd42fddc0c 100644
> --- a/include/linux/ptp_classify.h
> +++ b/include/linux/ptp_classify.h
> @@ -90,6 +90,30 @@ unsigned int ptp_classify_raw(const struct sk_buff *skb);
>   */
>  struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type);
>  
> +/**
> + * ptp_get_msgtype - Extract ptp message type from given header
> + * @hdr: ptp header
> + * @type: type of the packet (see ptp_classify_raw())
> + *
> + * This function returns the message type for a given ptp header. It takes care
> + * of the different ptp header versions (v1 or v2).
> + *
> + * Return: The message type
> + */
> +static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
> +				 unsigned int type)
> +{
> +	u8 msgtype;
> +
> +	if (unlikely(type & PTP_CLASS_V1))
> +		/* msg type is located at the control field for ptp v1 */
> +		msgtype = hdr->control;

With the comment, it looks like two statements, and so please use 

	if (...) {
		/**/
		...
	} else {
		...
	}

here.

> +	else
> +		msgtype = hdr->tsmt & 0x0f;
> +
> +	return msgtype;
> +}
> +
>  void __init ptp_classifier_init(void);
>  #else
>  static inline void ptp_classifier_init(void)
> -- 
> 2.20.1
> 
