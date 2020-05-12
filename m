Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052C01CF840
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgELPCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgELPCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:02:13 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90136C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:02:13 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id i15so15802554wrx.10
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ydbdKIMQJP6kjr/haP6ZiXr8t4WBjlee64hKDk1hENw=;
        b=eAn8Ct+EDePKUEbJaIJ12jJJvUur8YgNIt8uU34URYi4m/SgMxdRPDDjAi0YhMm8tX
         TJ6/vaZyxXm6pxRaog+aC8FaQEmguCwz5FLotqOu8N+j6l1axV0aP2KsokP0AyNa9fi4
         MbbTr8lrEnqW3Q0bGPKXKOazfoKGMtrNogtsfUGhJJj88xrrXVSo9b78bnoDTyr0k1rq
         H2bCfq2hVKhGh1unCNBxKIKoXxEFPY87AKXoDbObGSFeu3yfCsNWKD9xNogXnL9/ZSk/
         ksizk2h+3ctzcYEm4ReSAkAhjng3p5W5YsK1CqRh1OAKBEVG4zMqy25Y1yROSbaC5EDU
         aD2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ydbdKIMQJP6kjr/haP6ZiXr8t4WBjlee64hKDk1hENw=;
        b=tnGm8uzBjtHD3givFdXXnzkSg8H5mAvzKG2dYFYugi6Cm53UmODy3uoqf4L0bRkyLh
         TfY4wBplg6TZYnMU11Kifvb0RHhoSyvhc3g8kMWQ1DPhuI2454dI+tajQfzBBBNAp3S3
         /YZvqx1sgNqj+LrU9eGYY0AUY4fmuru/0voSbl+EAw0+KGmMKSqZKcRT8oz1bNisCECy
         f2tnSpg04w+QjfCKDRXP6sLpQpykR+N7QNaLXG4XuOlqmsg3+dghot5r2ulryCjjMmr4
         m3BexhpOGTulQLWT69pz7iq+wzk2QE1eEKn3KKcg6UzYbfq+ma74G6Hxk32+7H/29IM3
         nzFw==
X-Gm-Message-State: AGi0PuYbCGXrKMlfe7G5l8uFUQx4kDt6+XlRQIUA4qQEWCFYKlweqarK
        28L9PwknBynUwq9uQESUsNv7BQ==
X-Google-Smtp-Source: APiQypJX3YyCVdabEdASob1/43f04fiyu4zh9s0uqZQIQ5EpPUiz5xHkQoNFDCHa/EspbgBI/PINfw==
X-Received: by 2002:adf:a151:: with SMTP id r17mr24748197wrr.161.1589295732207;
        Tue, 12 May 2020 08:02:12 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id c83sm33510118wmd.23.2020.05.12.08.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 08:02:11 -0700 (PDT)
Date:   Tue, 12 May 2020 17:02:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 1/5] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200512150210.GO2245@nanopsycho>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511125723.GI2245@nanopsycho>
 <20200512145037.GB31516@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512145037.GB31516@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 12, 2020 at 04:50:37PM CEST, vadym.kochan@plvision.eu wrote:
>On Mon, May 11, 2020 at 02:57:23PM +0200, Jiri Pirko wrote:
>> [...]
>> 
>
>> >+netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb)
>> 
>> Why this has "rx" in the name??
>This is just a following of a module prefix which is prestera_rxtx_,
>do you think it is better to avoid using of "rx" in "xmit" func ?)

Ah, I see. I think it is okay as it is.

Thanks!

>
>> 
>> 
>> >+{
>> >+	struct prestera_dsa dsa;
>> >+
>> >+	dsa.hw_dev_num = port->dev_id;
>> >+	dsa.port_num = port->hw_id;
>> >+
>> >+	if (skb_cow_head(skb, PRESTERA_DSA_HLEN) < 0)
>> >+		return NET_XMIT_DROP;
>> >+
>> >+	skb_push(skb, PRESTERA_DSA_HLEN);
>> >+	memmove(skb->data, skb->data + PRESTERA_DSA_HLEN, 2 * ETH_ALEN);
>> >+
>> >+	if (prestera_dsa_build(&dsa, skb->data + 2 * ETH_ALEN) != 0)
>> >+		return NET_XMIT_DROP;
>> >+
>> >+	return prestera_sdma_xmit(&port->sw->rxtx->sdma, skb);
>> >+}
>> >diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
>> >new file mode 100644
>> >index 000000000000..bbbadfa5accf
>> >--- /dev/null
>> >+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
>> >@@ -0,0 +1,21 @@
>> >+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
>> >+ *
>> >+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
>> >+ *
>> >+ */
>> >+
>> >+#ifndef _PRESTERA_RXTX_H_
>> >+#define _PRESTERA_RXTX_H_
>> >+
>> >+#include <linux/netdevice.h>
>> >+
>> >+#include "prestera.h"
>> >+
>> >+int prestera_rxtx_switch_init(struct prestera_switch *sw);
>> >+void prestera_rxtx_switch_fini(struct prestera_switch *sw);
>> >+
>> >+int prestera_rxtx_port_init(struct prestera_port *port);
>> >+
>> >+netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb);
>> >+
>> >+#endif /* _PRESTERA_RXTX_H_ */
>> >-- 
>> >2.17.1
>> >
