Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730D4353A1C
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 01:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbhDDXFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 19:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhDDXFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 19:05:35 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0D5C061756
        for <netdev@vger.kernel.org>; Sun,  4 Apr 2021 16:05:30 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so6978068pjb.4
        for <netdev@vger.kernel.org>; Sun, 04 Apr 2021 16:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cTTf1bPN4f4n52llGVek4qFW4dzG3vdiVy5dcO165WE=;
        b=OPrlzii/zxzKPX7Jpv5OnL7b9DTVwyt9OH6Z1qkwq7pbXGwrNWkemGx3OGeVbkZRxi
         nIaPxT6M6DHIuT3HTIkbMnNyKCfYrrBJ3+0fEwBKZdf+olDa74FSHP9bjMqTupBsNaXX
         mcF9mkrfUUWFZ6x51BkFUm0kHdV0yEArKzESbqOJJrUR7oKbmh4rg8ARq4wWY8fEFVqD
         IDqUeMJgWnhzGV22XoK6QzoQZagPucxoI6LfTU6v8chwpcxaKifIaKIN/1GhaoAl9i9l
         GbYPWEj9RJy+4D3nkeCnl/LqMKWI0Gk8tttsCkC3v7BrjuhETzhtHJ+d+eXhqhyXbwD4
         pDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cTTf1bPN4f4n52llGVek4qFW4dzG3vdiVy5dcO165WE=;
        b=h2lsd+v7+/gcyBATBrvpXCGa9kiIy8zzKkfEqN9OxUaW4xQwQrQwK4pUCD1kh28sFy
         2An8gL6zSCI4DOj9FoNF/0RpCQ5FJPvwAkh6z20StpEWG6cLTIdvwrYY+JFhZP81jWfI
         1WeAOtH2TIp7rwwu0CPsg6LDDK7XKc3hGTE7Q93ZdU9zx/NEWjeD/JblvdwLJ5aLSjAi
         qePy3Uc37gK3OH68/k09xU8WdEdQqcmHdyEVilW1T7o3VVolo7hUzHN4e7bhT7osd+xy
         T+X3MOTTb5e6tcsTaYfoVSI+IiTHTseaE2ZXWdb45d7xCjsQzfh1H87rtZ6B6TAtI1n/
         xQqA==
X-Gm-Message-State: AOAM533B+fbAHcCAWN0bXrnnsi/0A5+YDxIpFqv/Z66VGJet9MzoGvLV
        d7JHek4uJGn6wg8f2SCc6KM=
X-Google-Smtp-Source: ABdhPJxvft4lQuXJ+9i5P2pG9k1zvHQumISL/SPTwlmy1uIsjQpm1Vc+gcObPQQ9lWzuRCHns9D5iA==
X-Received: by 2002:a17:903:1cc:b029:e6:f37a:2185 with SMTP id e12-20020a17090301ccb02900e6f37a2185mr21628892plh.67.1617577529255;
        Sun, 04 Apr 2021 16:05:29 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q25sm13302816pfh.34.2021.04.04.16.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 16:05:28 -0700 (PDT)
Date:   Sun, 4 Apr 2021 16:05:26 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
Subject: Re: [PATCH net-next 05/12] ionic: add hw timestamp support files
Message-ID: <20210404230526.GB24720@hoboy.vegasvil.org>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-6-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401175610.44431-6-snelson@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 10:56:03AM -0700, Shannon Nelson wrote:
> @@ -0,0 +1,589 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2017 - 2021 Pensando Systems, Inc */
> +
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +
> +#include "ionic.h"
> +#include "ionic_bus.h"
> +#include "ionic_lif.h"
> +#include "ionic_ethtool.h"
> +
> +static int ionic_hwstamp_tx_mode(int config_tx_type)
> +{
> +	switch (config_tx_type) {
> +	case HWTSTAMP_TX_OFF:
> +		return IONIC_TXSTAMP_OFF;
> +	case HWTSTAMP_TX_ON:
> +		return IONIC_TXSTAMP_ON;
> +	case HWTSTAMP_TX_ONESTEP_SYNC:
> +		return IONIC_TXSTAMP_ONESTEP_SYNC;
> +#ifdef HAVE_HWSTAMP_TX_ONESTEP_P2P
> +	case HWTSTAMP_TX_ONESTEP_P2P:
> +		return IONIC_TXSTAMP_ONESTEP_P2P;
> +#endif

This ifdef is not needed.  (I guess you have to support older kernel
versions, but my understanding of the policy is that new code
shouldn't carry such stuff).

> +	default:
> +		return -ERANGE;
> +	}
> +}


> +int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
> +{
> +	struct ionic *ionic = lif->ionic;
> +	struct hwtstamp_config config;
> +	int tx_mode = 0;
> +	u64 rx_filt = 0;
> +	int err, err2;
> +	bool rx_all;
> +	__le64 mask;
> +
> +	if (!lif->phc || !lif->phc->ptp)
> +		return -EOPNOTSUPP;
> +
> +	if (ifr) {
> +		if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> +			return -EFAULT;
> +	} else {
> +		/* if called with ifr == NULL, behave as if called with the
> +		 * current ts_config from the initial cleared state.
> +		 */

This check is unneeded, because the ioctl layer never passes NULL here.

> +		memcpy(&config, &lif->phc->ts_config, sizeof(config));
> +		memset(&lif->phc->ts_config, 0, sizeof(config));
> +	}

Thanks,
Richard
