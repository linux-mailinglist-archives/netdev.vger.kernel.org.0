Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0B1BA3E1A
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 21:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfH3TCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 15:02:33 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44302 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfH3TCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 15:02:32 -0400
Received: by mail-pl1-f193.google.com with SMTP id t14so3744220plr.11
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 12:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=jKoXpiSFhxP7KRugDbkM6XNycfLd1suUVTeXkEdWi2Y=;
        b=sTbRNTbfQjX3SPkwTZ1FE+KTEEfH9ZpfoCsowjGS+CtuINCuD7TJqwD1pykQGVszPa
         cEhgq31Qk4VShiRoEN68j7TtfKIzqzIX55et8MBelHnOJwJA9Rjb6YSAA5GE/0uEwcbq
         rh2qC/QWIm58SBuZEbgZ5WgkpNcHn9VytEcy86wg8FL1Z+BpU7rVbSi1VgAcgHE1ujQN
         JApvhnz5PNIXw77yyOuh7XkuRCAbxcZ+EG7ZSx6y9JvWzP0VA2bcje/3Dlwahui4Llio
         GL4PRYugC2MRWCi4vnSbEQc0v0vp57pfpRr1T0FD0SrwK+TTPI5nIvZFNE9dv7zFqjcQ
         4k8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jKoXpiSFhxP7KRugDbkM6XNycfLd1suUVTeXkEdWi2Y=;
        b=LyVsdWAez1UCdk9T67lJUObeHmcRsQWa7B/MJkeG6d7Jr7yi2A2FejJpKGt/SIbwOZ
         jcfX3i49u5UcW6tVWFYsKUUBiyPsqFB1kp4V6EIJ4jAsSWRa4mNBRkbjpO17fSmNX99I
         loBg5qyxy7FMES7flwPgvCR8ASnGoZJDk4QKjQ3JafaooDkvxC+cwA/YSW3Qs/ikrD0C
         IIWaODYTuOSpXj1ep+1JoYyvE6gKPQ1rRqYQndwUDt3n0tzlBdGsR3yUSEW7S4UERgXS
         xbDGYNqGAWU/rNHK1gMtUCPQ6s6d5tuvcym4Q/xw4gXhLFIRFlbiK8JGWM/BYv8OA1AE
         G2ew==
X-Gm-Message-State: APjAAAVm33mSI/3sZqYXatuocqidO63UcZypK3bOdkMJ7SUNPjvtGLZX
        Q8F5JrV/ewW0SG9WN77J+w/fYg==
X-Google-Smtp-Source: APXvYqwuzEgENf7Ff4XTV/tq4aPNyFEkz1utNEztEMbLGS5WzV6baVTjIlZmPFuJ5oGvStdVqnK18Q==
X-Received: by 2002:a17:902:2d03:: with SMTP id o3mr15799532plb.311.1567191752050;
        Fri, 30 Aug 2019 12:02:32 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id ce7sm5568118pjb.16.2019.08.30.12.02.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 12:02:31 -0700 (PDT)
Subject: Re: [PATCH v6 net-next 02/19] ionic: Add basic framework for IONIC
 Network device driver
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190829182720.68419-1-snelson@pensando.io>
 <20190829182720.68419-3-snelson@pensando.io>
 <20190829153825.396efbf5@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <4e24ca02-48f1-9509-9b6f-1b3e59c04f99@pensando.io>
Date:   Fri, 30 Aug 2019 12:02:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829153825.396efbf5@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/19 3:38 PM, Jakub Kicinski wrote:
> On Thu, 29 Aug 2019 11:27:03 -0700, Shannon Nelson wrote:
>> This patch adds a basic driver framework for the Pensando IONIC
>> network device.  There is no functionality right now other than
>> the ability to load and unload.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>> new file mode 100644
>> index 000000000000..6892409cd64b
>> --- /dev/null
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>> @@ -0,0 +1,44 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>> +
>> +#include <linux/module.h>
>> +#include <linux/netdevice.h>
>> +
>> +#include "ionic.h"
>> +#include "ionic_bus.h"
>> +#include "ionic_devlink.h"
>> +
>> +static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
>> +			     struct netlink_ext_ack *extack)
>> +{
>> +	devlink_info_driver_name_put(req, IONIC_DRV_NAME);
> This may fail, should the error not be propagated?

Will fix

>
>> +	return 0;
>> +}
>> +
>> +static const struct devlink_ops ionic_dl_ops = {
>> +	.info_get	= ionic_dl_info_get,
>> +};
>> +
>> +struct ionic *ionic_devlink_alloc(struct device *dev)
>> +{
>> +	struct ionic *ionic;
>> +	struct devlink *dl;
>> +
>> +	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic));
>> +	if (!dl) {
>> +		dev_warn(dev, "devlink_alloc failed");
> missing new line at the end of warning, but the warning is unnecessary,
> if memory allocation fails kernel will generate a big OOM splat, anyway

yep

>
>> +		return NULL;
>> +	}
>> +
>> +	ionic = devlink_priv(dl);
>> +
>> +	return ionic;
> return devlink_priv(dl);

yep

Thanks,
sln

>
>> +}
>> +
>> +void ionic_devlink_free(struct ionic *ionic)
>> +{
>> +	struct devlink *dl = priv_to_devlink(ionic);
>> +
>> +	devlink_free(dl);
>> +}

