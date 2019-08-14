Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 987A88E19C
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 02:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbfHOAAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 20:00:14 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41358 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbfHOAAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 20:00:14 -0400
Received: by mail-qk1-f194.google.com with SMTP id g17so534021qkk.8
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 17:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Y4fTUPx40q35YEqWGRWtK3na7rHj/0Tbd6xw7RTSoWY=;
        b=MEZGex9+Y8qDb4paUVfDsV7El+MM1D9nPVmDzypzGhyZ1mKNWD+Sf3JZK/oUZKPtBJ
         F+oAnrt0kunqbwlWLqBp+K7mquMmNRt2ou/oKk00IHvxpjxSImGi5lc37JP6XZ4/gkV7
         bCCDEl6Y5Ey8OqrHcev2mIcpZgyXtE8KsTAGKSLu5VDXM6HznnzeHAUtaDqOKEVl2RPk
         bXq1OXF1BOJvBz9HSh5b1CxTyWZjLr03JcCOsR2Uj4+8oRhHKG6dpokPW4esUb5axXqL
         OdQmX0b6CF4hux77yF0nC6Z47Ygmj0sj72RWK3Oncxk2hZ1DXSwNEy1sazHFb5MrxFYS
         TROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Y4fTUPx40q35YEqWGRWtK3na7rHj/0Tbd6xw7RTSoWY=;
        b=QFgRWI4mAhqAZbDyJB0oMMS1VHCw16jdUp+iVaTNuHqJLR8MBpyYad2n87tF+Mku0j
         62XyabF3n3defviI/W9vsIDA2YTKIc2LLTAyZTGnEQqdxJXuhgNG1gaQxHNuxvAZ/1Al
         MBMmQkhE2yqBDjH2mcAit0zMqv6kJMIvAvWxcoFnySWqmqaaTkdLLjvSaNzGCNo9/hZc
         eis6DiZ6Y46ERb7+gaxMyWDd+hv/YW1TaIIlitYcZrYjnfNhdFirvdpxFWtqb+coQx9j
         +/dy0PaUb6+MBhc58tmgU9u3KzlgOopStsjBNcEHbeGxVr+HJbv43wNmOqZ0OdOPsyjZ
         GJEQ==
X-Gm-Message-State: APjAAAV1H5XoWFqT+W2ENK3lc1EYKVSq1ySGgj9/iMqB2yAkR/pInf+F
        OTitFg3/1zFEsveQRrkXQG+gzA==
X-Google-Smtp-Source: APXvYqz4RjI+UOLSTidWTpyzx1ZyaPHkcpODB1LEUj7uqFQcGKiJ5J6l3DuhHwgntlIUgSBttxBeQA==
X-Received: by 2002:a37:c20a:: with SMTP id i10mr1642436qkm.76.1565827213111;
        Wed, 14 Aug 2019 17:00:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 6sm725796qtu.15.2019.08.14.17.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 17:00:12 -0700 (PDT)
Date:   Wed, 14 Aug 2019 16:59:57 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jiri@mellanox.com, toke@redhat.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 11/14] netdevsim: Add devlink-trap support
Message-ID: <20190814165957.0e626f57@cakuba.netronome.com>
In-Reply-To: <20190813075400.11841-12-idosch@idosch.org>
References: <20190813075400.11841-1-idosch@idosch.org>
        <20190813075400.11841-12-idosch@idosch.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Aug 2019 10:53:57 +0300, Ido Schimmel wrote:
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index 08ca59fc189b..2758d95c8d18 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -17,11 +17,21 @@
>  
>  #include <linux/debugfs.h>
>  #include <linux/device.h>
> +#include <linux/etherdevice.h>
> +#include <linux/inet.h>
> +#include <linux/jiffies.h>
> +#include <linux/kernel.h>
>  #include <linux/list.h>
>  #include <linux/mutex.h>
>  #include <linux/random.h>
> +#include <linux/workqueue.h>
> +#include <linux/random.h>
>  #include <linux/rtnetlink.h>
>  #include <net/devlink.h>
> +#include <net/ip.h>
> +#include <uapi/linux/devlink.h>
> +#include <uapi/linux/ip.h>
> +#include <uapi/linux/udp.h>

Please keep includes ordered alphabetically. You're adding
linux/random.h second time.

>  #include "netdevsim.h"

> +static void nsim_dev_trap_report(struct nsim_dev_port *nsim_dev_port)
> +{
> +	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
> +	struct nsim_trap_data *nsim_trap_data = nsim_dev->trap_data;
> +	struct devlink *devlink = priv_to_devlink(nsim_dev);
> +	int i;

reverse christmas tree, please
