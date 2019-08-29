Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A4CA29D3
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 00:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfH2Wiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 18:38:51 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42813 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfH2Wiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 18:38:50 -0400
Received: by mail-ed1-f68.google.com with SMTP id m44so5770096edd.9
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 15:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=GziO4dqbZ9ycElwJxUXYN0ba1XFZQ1lHXhs4ceb96vA=;
        b=kD0ybUyTnEtQogj1ZZtEkk0CVF22S4NdzreaUqhKBpCca72489G0IOCx2FA3jtRRTb
         0qRCiOHxk/DhMEDbaFJAz9LA448UAy4C6NdizahnD071xEp1ldwYW9ia5OSkrq+3xI/y
         6K93O4pVYgzliMxupNqm8pMcqnuU9J10yexyKHHAU3VJpWLaVpvIu8Xsw++mxY9NFDBc
         NuDejscuFis2zY7zhbaQi1uGNnGCw7AwOPxMdOJsdlXjK3uwWVDVtwFNUnQMUYlNfxLN
         Gc6ZtOJCiQ6Wj6v/YAXFLxZI+ctsxYgt5TGcqr5U0TieNlog0LJc9N5VnT7ibuaQrI0N
         vaQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=GziO4dqbZ9ycElwJxUXYN0ba1XFZQ1lHXhs4ceb96vA=;
        b=uOMmXCJqNCpDiuJwalrsPyZwU0JYvIc0AAHksajRgE47P1enuw7rHp8F+bCHzaE6W1
         z3B0QuRi1Dm0do61VtqbfoN4n15a5qEHEht6D6C/RCiRKM5Zg8X8LOyt77yvOw12GwmJ
         J+Jz1n9ZqMwlQ+o/QAcHZnCxdFPrr0ktokfbXqnf5Zty3z4uDImqTRVLfDC/DBhrOW7W
         kQbShtCFG9PM7V9Xt9cCbx+l+SWLgvxLGqqUKeaboAAalZ0p102wCo+1GllHAdFj1/vN
         gO8oSXbo5MeQNEHQJOy/V/YeU8S3TlNlSEnHJ5UlfV/OXJ9+VMW+eKmRrq5qBNyuL4YJ
         OzLg==
X-Gm-Message-State: APjAAAWj+9Kz6iENBDL4KaMIwODzdBm0CaOsk/+ikUSL96i53y5T6FYI
        7puCAimaHsneefsdfaGLXOShyg==
X-Google-Smtp-Source: APXvYqxhp/LT9ByyYmRGK0JpCmEKF4L23noNWSfk3swfwyW5/nsu6XqAqzcbYQrmkwwIzxJzjSofwA==
X-Received: by 2002:a17:906:74da:: with SMTP id z26mr10380971ejl.283.1567118329036;
        Thu, 29 Aug 2019 15:38:49 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j26sm481790edq.97.2019.08.29.15.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 15:38:48 -0700 (PDT)
Date:   Thu, 29 Aug 2019 15:38:25 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v6 net-next 02/19] ionic: Add basic framework for IONIC
 Network device driver
Message-ID: <20190829153825.396efbf5@cakuba.netronome.com>
In-Reply-To: <20190829182720.68419-3-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
        <20190829182720.68419-3-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 11:27:03 -0700, Shannon Nelson wrote:
> This patch adds a basic driver framework for the Pensando IONIC
> network device.  There is no functionality right now other than
> the ability to load and unload.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> new file mode 100644
> index 000000000000..6892409cd64b
> --- /dev/null
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
> +
> +#include <linux/module.h>
> +#include <linux/netdevice.h>
> +
> +#include "ionic.h"
> +#include "ionic_bus.h"
> +#include "ionic_devlink.h"
> +
> +static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
> +			     struct netlink_ext_ack *extack)
> +{
> +	devlink_info_driver_name_put(req, IONIC_DRV_NAME);

This may fail, should the error not be propagated?

> +	return 0;
> +}
> +
> +static const struct devlink_ops ionic_dl_ops = {
> +	.info_get	= ionic_dl_info_get,
> +};
> +
> +struct ionic *ionic_devlink_alloc(struct device *dev)
> +{
> +	struct ionic *ionic;
> +	struct devlink *dl;
> +
> +	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic));
> +	if (!dl) {
> +		dev_warn(dev, "devlink_alloc failed");

missing new line at the end of warning, but the warning is unnecessary,
if memory allocation fails kernel will generate a big OOM splat, anyway

> +		return NULL;
> +	}
> +
> +	ionic = devlink_priv(dl);
> +
> +	return ionic;

return devlink_priv(dl);

> +}
> +
> +void ionic_devlink_free(struct ionic *ionic)
> +{
> +	struct devlink *dl = priv_to_devlink(ionic);
> +
> +	devlink_free(dl);
> +}
