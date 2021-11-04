Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C65445851
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhKDRb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhKDRbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 13:31:25 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00287C061714;
        Thu,  4 Nov 2021 10:28:46 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id g19so500473pfb.8;
        Thu, 04 Nov 2021 10:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lAJP4BDcTPzY4qV1KLF604/5VVqlDPwRKJmv/Gn0qso=;
        b=ef425mHoit6IKvhYTeqn/9uwRdFschSDwcHYppC/x/+ozF2me01Aru6LGpySNHs3/w
         ZMazxLEDs7tOwk0SSG0Fya1Rqlb/YZ4qS6lViN7lHWdwN9KPLOIRDvaf1KOu7mDhfalR
         ookWr5K8zoZ0pUmR9oiqza/mY7aDuNUr7i31Jj43ttErUKyQp9GhnfHHiMn/aAVIt493
         nrcz9YTaVXnVdysCZ/qNOyukCDn6dCZzAeY48v2ECbm/4ao8BWQsKijIoazy3xqlgdSC
         1WMN9rOwvv4xdp++DOE1WWmTN8DLxckmvVp2MrgLyB2ossN3kZUYUn5xTAvYhGQ+BGPG
         h3YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lAJP4BDcTPzY4qV1KLF604/5VVqlDPwRKJmv/Gn0qso=;
        b=r5L0kcfIKnAZlQ985XjbXaUJPRzx/5epnRjshvXxMvAMEDjvWPiL//Y2KJY2GjA9k1
         GbBGvDjwiSsjmdZNot4XThPlrPLTnCTRxH9AxW8xGUHQn3eAXIVl8+CkTjaC+fR2Bz2n
         nt2+G7AG4dX8O1nz5SQzSwQnKxrvvtmkr09xOVs70J9Fejuansn6Q5HUmNsLSnDEOiD+
         jiZafg0x4Tx8dpf9DNDJ16knmEVwlA2wv9EcFVkez3Ao7TULZhVledZEkjnqMi4YCTFG
         g0bvNc40/Jc4KwIuDMGvoaRe3RAfneqB9nS5y8aZwPxHZ3zDGgnAuJicMF8KpBT+oknE
         91Kg==
X-Gm-Message-State: AOAM5321NhRYKUfU6f3wlJ4ymAptHEwKkPES66F4zKTz6v23FufICRgr
        IwT8qpN8avrtXXAH8OwzLVhljUrX43s=
X-Google-Smtp-Source: ABdhPJwKUWi9rgQB00MTTR+60zoRULqYeGG82rxMm345P7hA1naAtrVB3QzV34/p/YMJgumBvAunxg==
X-Received: by 2002:a65:62c4:: with SMTP id m4mr40480126pgv.453.1636046926464;
        Thu, 04 Nov 2021 10:28:46 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id n126sm5428003pfn.6.2021.11.04.10.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 10:28:45 -0700 (PDT)
Date:   Thu, 4 Nov 2021 10:28:43 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Martin Kaistra <martin.kaistra@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/7] net: dsa: b53: Add PHC clock support
Message-ID: <20211104172843.GA32548@hoboy.vegasvil.org>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-5-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104133204.19757-5-martin.kaistra@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 02:31:58PM +0100, Martin Kaistra wrote:

> +static void b53_ptp_overflow_check(struct work_struct *work)
> +{
> +	struct delayed_work *dw = to_delayed_work(work);
> +	struct b53_device *dev =
> +		container_of(dw, struct b53_device, overflow_work);
> +
> +	mutex_lock(&dev->ptp_mutex);
> +	timecounter_read(&dev->tc);
> +	mutex_unlock(&dev->ptp_mutex);
> +
> +	schedule_delayed_work(&dev->overflow_work, B53_PTP_OVERFLOW_PERIOD);
> +}
> +
> +int b53_ptp_init(struct b53_device *dev)
> +{
> +	mutex_init(&dev->ptp_mutex);
> +
> +	INIT_DELAYED_WORK(&dev->overflow_work, b53_ptp_overflow_check);

...

> @@ -97,4 +101,14 @@ struct b53_device {
>  	bool vlan_enabled;
>  	unsigned int num_ports;
>  	struct b53_port *ports;
> +
> +	/* PTP */
> +	bool broadsync_hd;
> +	struct ptp_clock *ptp_clock;
> +	struct ptp_clock_info ptp_clock_info;
> +	struct cyclecounter cc;
> +	struct timecounter tc;
> +	struct mutex ptp_mutex;
> +#define B53_PTP_OVERFLOW_PERIOD (HZ / 2)
> +	struct delayed_work overflow_work;

Instead of generic work, consider implementing
ptp_clock_info::do_aux_work instead.

The advantage is that you get a named kernel thread that can be given
scheduling priority administratively.

Thanks,
Richard
