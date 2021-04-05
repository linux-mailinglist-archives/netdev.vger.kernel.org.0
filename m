Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FC1354505
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 18:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242300AbhDEQQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 12:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238609AbhDEQQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 12:16:49 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69BEC061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 09:16:41 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mj7-20020a17090b3687b029014d162a65b6so2168645pjb.2
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 09:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=nHuHmOlIJ+PIgYGhfNlagFfMUkgiDdruzOPPyD0VHaw=;
        b=E/B5oWJV4o7YOUaCT1aTlADxp/oVtybys10ilLbE7pI07tOoWPNLL62v7rOT7ySgsK
         /yIydPNPQFj5GwGKPSs617fZN2xIQo8jLxf4H+g16/Co01opJVUpiF87N3JkhcjszoR2
         8MvanShlWsepDj3UKBqQd+Vs0j4bj89C0VGGDtohqPvnQaSP3GolkGNIKQZnC/qxTwzA
         2wm5rsPuSavgx3NmA9WW0q74uCYHOU7u1zZF9N43bL7PMZEUkKJcfX9rfPBew3erQOii
         AjKPJIFZCBvCDAi0pJTM1kPNppKhtiR38uhoJioD82QcsrLFYWPHsnvNPK9OqFROUpid
         XDGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=nHuHmOlIJ+PIgYGhfNlagFfMUkgiDdruzOPPyD0VHaw=;
        b=KGYfzvt81q4zGteWuLC3cCcmZ6J76d9TNlqlDGU3fi/FxiuZZxBfLvuW7nXruzYe30
         HvccMH+Rz2UGnlELj90oT/P5zTfv0Lgx3Q8xq9JsBB83Ns8Alumgp45lQk95ts1dwfFi
         UNeTLHn3sNCtXLH0JcWDbVvHV/WU6Q5s42qiUnn9oMhsl/+xtE+n6/nm7vncB1qe50Gm
         SyM90W+8dIR62eYlRTqZyOCvgpqqHSbNKN8cGHz6vO0ekSD9VgLupsagBZoSUUjPfDX4
         zwFlbtdkf9kUWksxt2aBacmjIl2EwdRl0r9cXjQvK4KDf61H47sQLedcSITKSyq9EAY0
         3Mgw==
X-Gm-Message-State: AOAM532ru3gNFfQd8TS+11sm1nmw9p8RemyTsPy0SO0W28hfPpYPSyfS
        J3sGN+J0FtWoG0rd/KBBTCYgEg==
X-Google-Smtp-Source: ABdhPJyF5T8+h81euSqx9L/Q9XYl9G0B5VcgQ17FemJzuvOSKyO4CGQfdvUVJmLY35l6I1UCjaCQJA==
X-Received: by 2002:a17:90a:a47:: with SMTP id o65mr2765247pjo.179.1617639401426;
        Mon, 05 Apr 2021 09:16:41 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id q5sm15911355pfk.219.2021.04.05.09.16.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 09:16:40 -0700 (PDT)
Subject: Re: [PATCH net-next 05/12] ionic: add hw timestamp support files
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-6-snelson@pensando.io>
 <20210404230526.GB24720@hoboy.vegasvil.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <9b5d20f4-df9f-e9e1-bc6d-d5531b87e8c4@pensando.io>
Date:   Mon, 5 Apr 2021 09:16:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210404230526.GB24720@hoboy.vegasvil.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/4/21 4:05 PM, Richard Cochran wrote:
> On Thu, Apr 01, 2021 at 10:56:03AM -0700, Shannon Nelson wrote:
>> @@ -0,0 +1,589 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2017 - 2021 Pensando Systems, Inc */
>> +
>> +#include <linux/netdevice.h>
>> +#include <linux/etherdevice.h>
>> +
>> +#include "ionic.h"
>> +#include "ionic_bus.h"
>> +#include "ionic_lif.h"
>> +#include "ionic_ethtool.h"
>> +
>> +static int ionic_hwstamp_tx_mode(int config_tx_type)
>> +{
>> +	switch (config_tx_type) {
>> +	case HWTSTAMP_TX_OFF:
>> +		return IONIC_TXSTAMP_OFF;
>> +	case HWTSTAMP_TX_ON:
>> +		return IONIC_TXSTAMP_ON;
>> +	case HWTSTAMP_TX_ONESTEP_SYNC:
>> +		return IONIC_TXSTAMP_ONESTEP_SYNC;
>> +#ifdef HAVE_HWSTAMP_TX_ONESTEP_P2P
>> +	case HWTSTAMP_TX_ONESTEP_P2P:
>> +		return IONIC_TXSTAMP_ONESTEP_P2P;
>> +#endif
> This ifdef is not needed.  (I guess you have to support older kernel
> versions, but my understanding of the policy is that new code
> shouldn't carry such stuff).

Yep, good catch - that's a carry over from our out-of-tree driver. I'll 
follow up with a patch to remove that bit of cruft.

>
>> +	default:
>> +		return -ERANGE;
>> +	}
>> +}
>
>> +int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
>> +{
>> +	struct ionic *ionic = lif->ionic;
>> +	struct hwtstamp_config config;
>> +	int tx_mode = 0;
>> +	u64 rx_filt = 0;
>> +	int err, err2;
>> +	bool rx_all;
>> +	__le64 mask;
>> +
>> +	if (!lif->phc || !lif->phc->ptp)
>> +		return -EOPNOTSUPP;
>> +
>> +	if (ifr) {
>> +		if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
>> +			return -EFAULT;
>> +	} else {
>> +		/* if called with ifr == NULL, behave as if called with the
>> +		 * current ts_config from the initial cleared state.
>> +		 */
> This check is unneeded, because the ioctl layer never passes NULL here.

Yes, the ioctl layer never calls this with NULL, but we call it from 
within the driver when we spin operations back up after a FW reset.

Thanks,
sln

>
>> +		memcpy(&config, &lif->phc->ts_config, sizeof(config));
>> +		memset(&lif->phc->ts_config, 0, sizeof(config));
>> +	}
> Thanks,
> Richard

