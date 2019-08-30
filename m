Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94E48A3FA0
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbfH3VZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:25:15 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41935 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbfH3VZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:25:15 -0400
Received: by mail-pf1-f194.google.com with SMTP id 196so5413025pfz.8
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=hdQCiTme66/xdQBTZtFSjXdNRXhqmRrXcEPPg9oOOhw=;
        b=nIERKyw7AQPJP58wodPd8bE2GM9fQBLOSAQ6J5myCetbAlIxisGKV50SDZTN3zKnRB
         gX0IgNypp+C2sV0wv5trtetdGtTupfxR3j6nlg305zNoLK2V1cZsS6pFzIPpvF53++gN
         GewESd6PckTCEI7T28z0d9IbVUKRdY0ftTY9iKwStv5pq7HhXNF1OwWlzTAILUfBxBxM
         pRDak1US6aNPUP/3QnR3AQpoMc3Bm7/jgY+3KmAtQS9BYc5ufrMUfqJqNDQGRdSijuZG
         OY0hwMYz/xzFkG13/rBoobtnJlepuojczsf6vpRbGpxhjrPg3tWGg9Uvs2+OegI5vST7
         7TQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hdQCiTme66/xdQBTZtFSjXdNRXhqmRrXcEPPg9oOOhw=;
        b=hy15OnMRBwzIdLMRM+sGbjv4lvzthRwf0BUbhlt1LcWOGh86/1f9ysGcPqu7XmGdbl
         BiyIjNL5a6TsZDJ8U95ebI8rynV96KNQIAs/TlvefCgSyxGz6lmG5aHlxbamY7gV8b+Z
         tbLW3Rcv2vZQiFNjXJ4kXZFIMQzR2/4O71iN6c23+RrxtvOqucGXzic3HnDmh5avsEbp
         J1Wleyym0d4xc/wpHSdJy3uUb/NTK2O5crv0KktYLYjwGIbmbPX5Us+mR8Zk+58zx589
         ZZERCmpnkM7Qu8/XZUTHCUKFHMTBtODCyyAfa61N8FHjqBU4QgAterYJbYgEYzvxVtCe
         PTsg==
X-Gm-Message-State: APjAAAXPYs0EpFUf7gQl17KpoReS1zlJW2PQTyVeqiHvSN4jGkH67EXa
        rIqfb+D5c6ikarPU+kTpwzxB5Q==
X-Google-Smtp-Source: APXvYqwSgmZ/tT6dn8lnK5sNe5ukkvCUhPafhpqmLKcbIWp6sulLoNc+5bUwXw0wUccM85w6079pDg==
X-Received: by 2002:aa7:9ab8:: with SMTP id x24mr20023978pfi.98.1567200314836;
        Fri, 30 Aug 2019 14:25:14 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id d2sm7596348pjg.19.2019.08.30.14.25.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 14:25:14 -0700 (PDT)
Subject: Re: [PATCH v6 net-next 14/19] ionic: Add initial ethtool support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190829182720.68419-1-snelson@pensando.io>
 <20190829182720.68419-15-snelson@pensando.io>
 <20190829161029.0676d6f7@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <4c140c92-38b7-7c81-2a82-d23df8d16252@pensando.io>
Date:   Fri, 30 Aug 2019 14:25:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829161029.0676d6f7@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/19 4:10 PM, Jakub Kicinski wrote:
> On Thu, 29 Aug 2019 11:27:15 -0700, Shannon Nelson wrote:
>> +static int ionic_get_module_eeprom(struct net_device *netdev,
>> +				   struct ethtool_eeprom *ee,
>> +				   u8 *data)
>> +{
>> +	struct ionic_lif *lif = netdev_priv(netdev);
>> +	struct ionic_dev *idev = &lif->ionic->idev;
>> +	struct ionic_xcvr_status *xcvr;
>> +	char tbuf[sizeof(xcvr->sprom)];
>> +	int count = 10;
>> +	u32 len;
>> +
>> +	/* The NIC keeps the module prom up-to-date in the DMA space
>> +	 * so we can simply copy the module bytes into the data buffer.
>> +	 */
>> +	xcvr = &idev->port_info->status.xcvr;
>> +	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
>> +
>> +	do {
>> +		memcpy(data, xcvr->sprom, len);
>> +		memcpy(tbuf, xcvr->sprom, len);
>> +
>> +		/* Let's make sure we got a consistent copy */
>> +		if (!memcmp(data, tbuf, len))
>> +			break;
>> +
>> +	} while (--count);
> Should this return an error if the image was never consistent?

Sure, how about -EBUSY?

sln


