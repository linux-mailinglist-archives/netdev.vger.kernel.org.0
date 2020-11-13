Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF4F2B1472
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 03:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgKMCxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 21:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgKMCxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 21:53:19 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94089C0613D1;
        Thu, 12 Nov 2020 18:53:14 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id f23so11212705ejk.2;
        Thu, 12 Nov 2020 18:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3cwAkVJBaIm0bznlfwjriii/zWOpkkEBNl8Hcg94gY4=;
        b=LVeWta6Is4i/DIVjF7fVSteM02AKOLjbgTUgQOh3rXCaXqBHwWjsWI6I8dZMq/FCGV
         sA3Hxribgehpa0rXUmpgdLDqd4Y8tIDCzdfLg8cqA8K/kedlkygn7/UYTYrtiRjF3snC
         QgD8g38520PD/dEvWcEmnnO59vvOcZN1avvTSefiSD8bO2UQmWiVpSlrSsBIzi5NlhVQ
         y0xVN7ITB8XqtBdjQeEKX4Q9dfOB4NZw8CBafG8i31sgH4fF0lQmAVIIO43z5ZLG9qNp
         XtW+NypoyR1efvywDQN+DvEcPv3oRe6WjgchE8D9hkDsskpXB1IvBPZacWwOYHX6lKqa
         IegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3cwAkVJBaIm0bznlfwjriii/zWOpkkEBNl8Hcg94gY4=;
        b=dTM7SCfjIBNrdTWpPa2lKyyhjKUc7wKXfITMyPFMivZsYIva8pyL1+kHt8Gtx0D+X1
         8F1TR+LOGc1KSzWja2Jh90iO/PLBYOKB+Db94uyDbpV+x46ZMMQcVU+y7d7mNAGd1DHA
         7IvlFQdQCBSOeQpuEjtfvjD6s4n2mndjJk3VH481CUtqjVHkGASqmuLWGb/WfG/xiKtF
         JKxaiPuDEphptt4TR1A8xR0Sv+cecEz4W6dqsV836e7REvqwdMkZlsfb4+6zRcDoOnA6
         dm4klsqi/nznZn/LV9BXwOQV1HFb9IC70Xm7aq3Ezqz6eOYeErnk234ZWPZ6sJNLGTWq
         PPbw==
X-Gm-Message-State: AOAM533swMuySWMy46ebJV0J6+h4fLxSlcqXRn+Ea4ZKQV/RpDBoPtn9
        FSCnFIgP84WP73kRoYqYwDo=
X-Google-Smtp-Source: ABdhPJyk/cXryyKgDTUq5l04cAjeXQ69dal2ExrmJmWaVri1Kpx0Uc8BPWQNwSKVFGq+IlEuSX0LIQ==
X-Received: by 2002:a17:906:d8b3:: with SMTP id qc19mr20063ejb.222.1605235993343;
        Thu, 12 Nov 2020 18:53:13 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm2824347ejb.77.2020.11.12.18.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 18:53:12 -0800 (PST)
Date:   Fri, 13 Nov 2020 04:53:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 10/11] net: dsa: microchip: ksz9477: add
 Pulse Per Second (PPS) support
Message-ID: <20201113025311.jpkplhmacjz6lkc5@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-11-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112153537.22383-11-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:35:36PM +0100, Christian Eggers wrote:
>  static int ksz9477_ptp_enable(struct ptp_clock_info *ptp, struct ptp_clock_request *req, int on)
>  {
> -	return -ENOTTY;
> +	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
> +	int ret;
> +
> +	switch (req->type) {
> +	case PTP_CLK_REQ_PPS:
> +		mutex_lock(&dev->ptp_mutex);
> +		ret = ksz9477_ptp_enable_pps(dev, on);
> +		mutex_unlock(&dev->ptp_mutex);
> +		return ret;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
>  }

Richard, do you think we can clarify the intended usage of PTP_CLK_REQ_PPS
in the documentation? It doesn't appear to be written anywhere that
PTP_ENABLE_PPS is supposed to enable event generation for the drivers/pps
subsystem. You would sort of have to know before you could find out...
