Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF88F19295C
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 14:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgCYNPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 09:15:39 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44659 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgCYNPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 09:15:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id 142so1119299pgf.11;
        Wed, 25 Mar 2020 06:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t7sQNLDClv/p225mmH86mWwak+RRxG8EEmHT60ENRjM=;
        b=gEY7UqPMftwY/H7TBRSQpBZ6VGvDIckFDkKb6LBage0Y9kIawsp3wCMJighgviDumi
         lHUjUHw52J9Wkd7YGTFQ91NQNQyDT7GhEHixfb0+ALrQQ7QH7nJuBeOLj1KwZQYPCJQQ
         sUTM91E4P0el/7i6/+I+AgVPdz3Tii5bq/fh3jjhQVBMxp4uROnW577YJWWHHNnQl+SH
         x81vgyOAh6aj9iPz0v7g/+hBpTmhhlHQvDliW1XVkHluIjKsGNOByVkxF2iZdiFIHbdN
         PFXDn7OY+XOaO+dr5kuCYs38YgHdxcnCDzWPQ/PwGTcAmQHYkQhn3gB7KiQgLiiFakUC
         hV4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t7sQNLDClv/p225mmH86mWwak+RRxG8EEmHT60ENRjM=;
        b=Ggtq8/waWulpUVQwVhJNwU2Zel0GFVxdmlLBCfUwBlJJzyRZmDRoOSovvdPABFVn8S
         OHGTXLbn0od7W1wqh4h19Mrt/44E5R4ozq89rXkOWPCXTMlNIRjGTKg266rx8JHISrDy
         VjLVDhkyUAjfgiou/NJKb9DZC6Df7+4N44Ts3PRI6/23V6OUenzCFfUgF4MIYFMDeMjN
         kCEIKvYuzd+ww7pH8gjWIziJOelCoWd8yc74kRLivhlmc92wg1FWigSkwwq/FOb0fL/n
         Tksrka3ZHNRVrVCx1sttBNYOamfw3QDYEDP58ll+qMKniyYjy/sjwqsFXyefxW5Xs2Ao
         mObA==
X-Gm-Message-State: ANhLgQ0Zhi4uCBxM2L/qMTweCN6XM4MuFu5X5BsDi44Y/qRitFi4+Osa
        qFAt6IQ4KyorV7Ga0j69fAI=
X-Google-Smtp-Source: ADFU+vvilHHR6n8L12fXH4qqQymhAbkiK4zftRSJoVy3vYU0+i1Shy+Tgkvs22SiIRzwq1SpG1ms6Q==
X-Received: by 2002:a63:5f10:: with SMTP id t16mr3117029pgb.20.1585142137979;
        Wed, 25 Mar 2020 06:15:37 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id w27sm18520140pfq.211.2020.03.25.06.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 06:15:37 -0700 (PDT)
Date:   Wed, 25 Mar 2020 06:15:35 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Message-ID: <20200325131534.GA32284@localhost>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-7-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320103726.32559-7-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 06:37:26PM +0800, Yangbo Lu wrote:
> Support 4 programmable pins for only one function periodic
> signal for now.

For now?

> +static int ocelot_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
> +			     enum ptp_pin_function func, unsigned int chan)
> +{
> +	switch (func) {
> +	case PTP_PF_NONE:
> +	case PTP_PF_PEROUT:
> +		break;

If the functions cannot be changed, then supporting the
PTP_PIN_SETFUNC ioctl does not make sense!

> +	case PTP_PF_EXTTS:
> +	case PTP_PF_PHYSYNC:
> +		return -1;
> +	}
> +	return 0;
> +}

Thanks,
Richard
