Return-Path: <netdev+bounces-8983-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5536F72678B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73A7C280FFE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85FE738CAA;
	Wed,  7 Jun 2023 17:39:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709711772E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:39:11 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D435E19BF
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:39:08 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b02d0942caso35658865ad.1
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 10:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686159548; x=1688751548;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jP2AcXP0QL8Ei3RQ2HHM6MpbYckZc8+lVeiaVFUeoF0=;
        b=IpcbE6UBcq+F+n85cdK9BFEo7b2iyx09AYj3OurmUoR0P+FNbuKkdR/BPBJVwz1Pvf
         3PKj7E/SUi+t9mCVOpeJ/NIivwPnLpa18O6RxhWs46qi+epDi6FdQXEI3djtbAa5/V0l
         G3xRVvm3MX1IthawD8Y4liRMaMVcMWQyxCiDw5qZmwtRfOOElD1voS1jzDHni9fMWy5B
         /ua+SOTK3sV7/au4N4erEiRbxQpIv3AlZHREpzybG7lJN9aORx0Xux3rynbKNEwTDCem
         y79o2h7Fsa8TpMwRbwuYs6Jpsg65NF3B+4drSAht3ne6h7P+65erbVeVYsyNQxGNn9cb
         zyjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686159548; x=1688751548;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jP2AcXP0QL8Ei3RQ2HHM6MpbYckZc8+lVeiaVFUeoF0=;
        b=EAaDJMnNfvZPdH2BH8KwORqnnUj5rg2gNE8LafRyYRQtMcLkMFnoIYejfwT5oT/7X/
         2dChdj6P3Uzlte4x+DLVeNdc+jAdwVJeGe1UyB9ChLIKiHkoqufcOqUKLjLvkI7nQDqW
         PFGI1wFTIj2Vff+q4zfi1iVpsiLgQ6OROyjI62C8021ja0rYGkpsKb3JvBPIXNXGAMiI
         FvEWnJtJC0bOjT71LXKp+JQb8XU274Vnc1BVOeKkJe5Wf7PIkmpo3udwlkXCvWAVV7UA
         Wtn+ZPbY40/YeQZY/Nd9zbs/rVAXWIihugoAXK+bn+91P/JqDopSYo07tV3+tXk/YRz2
         VvNg==
X-Gm-Message-State: AC+VfDz67krt+gJZ8VTF9aY9ntfA0+ALY1BAhhjWDgMCOVWsG7FjSzWF
	E9fHnEwWE621eCRO/X1dgDI03/r+i81vRDthqA==
X-Google-Smtp-Source: ACHHUZ7NZDw2raL7RbfM+eZidhGTU01w+0sxMykxT7mkCYEPp+NkBG55uvhp344cQp/vbhEBqb3ggA==
X-Received: by 2002:a17:902:ea0a:b0:1ad:f407:37d1 with SMTP id s10-20020a170902ea0a00b001adf40737d1mr2945641plg.52.1686159548268;
        Wed, 07 Jun 2023 10:39:08 -0700 (PDT)
Received: from thinkpad ([59.92.97.244])
        by smtp.gmail.com with ESMTPSA id a4-20020a170902900400b001aaef9d0102sm10697929plp.197.2023.06.07.10.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 10:39:07 -0700 (PDT)
Date: Wed, 7 Jun 2023 23:09:03 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Jeffrey Hugo <quic_jhugo@quicinc.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, mhi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, loic.poulain@linaro.org
Subject: Re: [PATCH v2 1/2] net: Add MHI Endpoint network driver
Message-ID: <20230607173903.GC109456@thinkpad>
References: <20230607152427.108607-1-manivannan.sadhasivam@linaro.org>
 <20230607152427.108607-2-manivannan.sadhasivam@linaro.org>
 <26a85bae-1a33-dd1f-5e73-0ab6da100abf@quicinc.com>
 <b5cfa726-b61e-90eb-7d4b-d81844189cf6@quicinc.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b5cfa726-b61e-90eb-7d4b-d81844189cf6@quicinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 10:52:54AM -0600, Jeffrey Hugo wrote:
> On 6/7/2023 10:27 AM, Jeffrey Hugo wrote:
> > On 6/7/2023 9:24 AM, Manivannan Sadhasivam wrote:
> > > Add a network driver for the Modem Host Interface (MHI) endpoint devices
> > > that provides network interfaces to the PCIe based Qualcomm endpoint
> > > devices supporting MHI bus. This driver allows the MHI endpoint
> > > devices to
> > > establish IP communication with the host machines (x86, ARM64) over MHI
> > > bus.
> > > 
> > > The driver currently supports only IP_SW0 MHI channel that can be used
> > > to route IP traffic from the endpoint CPU to host machine.
> > > 
> > > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > > ---
> > >   drivers/net/Kconfig      |   9 ++
> > >   drivers/net/Makefile     |   1 +
> > >   drivers/net/mhi_ep_net.c | 331 +++++++++++++++++++++++++++++++++++++++
> > >   3 files changed, 341 insertions(+)
> > >   create mode 100644 drivers/net/mhi_ep_net.c
> > > 
> > > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > > index 368c6f5b327e..36b628e2e49f 100644
> > > --- a/drivers/net/Kconfig
> > > +++ b/drivers/net/Kconfig
> > > @@ -452,6 +452,15 @@ config MHI_NET
> > >         QCOM based WWAN modems for IP or QMAP/rmnet protocol (like
> > > SDX55).
> > >         Say Y or M.
> > > +config MHI_EP_NET
> > > +    tristate "MHI Endpoint network driver"
> > > +    depends on MHI_BUS_EP
> > > +    help
> > > +      This is the network driver for MHI bus implementation in endpoint
> > > +      devices. It is used provide the network interface for QCOM
> > > endpoint
> > > +      devices such as SDX55 modems.
> > > +      Say Y or M.
> > 
> > What will the module be called if "m" is selected?
> > 
> > > +
> > >   endif # NET_CORE
> > >   config SUNGEM_PHY
> > > diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> > > index e26f98f897c5..b8e706a4150e 100644
> > > --- a/drivers/net/Makefile
> > > +++ b/drivers/net/Makefile
> > > @@ -40,6 +40,7 @@ obj-$(CONFIG_NLMON) += nlmon.o
> > >   obj-$(CONFIG_NET_VRF) += vrf.o
> > >   obj-$(CONFIG_VSOCKMON) += vsockmon.o
> > >   obj-$(CONFIG_MHI_NET) += mhi_net.o
> > > +obj-$(CONFIG_MHI_EP_NET) += mhi_ep_net.o
> > >   #
> > >   # Networking Drivers
> > > diff --git a/drivers/net/mhi_ep_net.c b/drivers/net/mhi_ep_net.c
> > > new file mode 100644
> > > index 000000000000..0d7939caefc7
> > > --- /dev/null
> > > +++ b/drivers/net/mhi_ep_net.c
> > > @@ -0,0 +1,331 @@
> > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > +/*
> > > + * MHI Endpoint Network driver
> > > + *
> > > + * Based on drivers/net/mhi_net.c
> > > + *
> > > + * Copyright (c) 2023, Linaro Ltd.
> > > + * Author: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > > + */
> > > +
> > > +#include <linux/if_arp.h>
> > > +#include <linux/mhi_ep.h>
> > > +#include <linux/mod_devicetable.h>
> > > +#include <linux/module.h>
> > > +#include <linux/netdevice.h>
> > > +#include <linux/skbuff.h>
> > > +#include <linux/u64_stats_sync.h>
> > > +
> > > +#define MHI_NET_MIN_MTU        ETH_MIN_MTU
> > > +#define MHI_NET_MAX_MTU        0xffff
> 
> ETH_MAX_MTU ?
> 
> Personal preference thing.  If you think 0xffff is really the superior
> option, so be it.  Personally, it takes me a second to figure out that is
> 64k - 1 and then relate it to the MHI packet size limit.  Also seems really
> odd with this line of code right next to, and related to, ETH_MIN_MTU.
> Feels like a non-magic number here will make things more maintainable.
> 

TBH, I tried to stick to mhi_net, so just carried this macro. And I agree, it
could be made more understandeable.

> Alternatively move MHI_MAX_MTU out of host/internal.h into something that is
> convenient for this driver to include and use?  It is a fundamental constant
> for the MHI protocol, we just haven't yet had a need for it to be used
> outside of the MHI bus implementation code.
> 

At some point I had a patch for moving this macro to mhi.h but it fell into
cracks... Will bring it back.

- Mani

> > > +
> > > +struct mhi_ep_net_stats {
> > > +    u64_stats_t rx_packets;
> > > +    u64_stats_t rx_bytes;
> > > +    u64_stats_t rx_errors;
> > > +    u64_stats_t tx_packets;
> > > +    u64_stats_t tx_bytes;
> > > +    u64_stats_t tx_errors;
> > > +    u64_stats_t tx_dropped;
> > > +    struct u64_stats_sync tx_syncp;
> > > +    struct u64_stats_sync rx_syncp;
> > > +};
> > > +
> > > +struct mhi_ep_net_dev {
> > > +    struct mhi_ep_device *mdev;
> > > +    struct net_device *ndev;
> > > +    struct mhi_ep_net_stats stats;
> > > +    struct workqueue_struct *xmit_wq;
> > > +    struct work_struct xmit_work;
> > > +    struct sk_buff_head tx_buffers;
> > > +    spinlock_t tx_lock; /* Lock for protecting tx_buffers */
> > > +    u32 mru;
> > > +};
> > > +
> > > +static void mhi_ep_net_dev_process_queue_packets(struct work_struct
> > > *work)
> > > +{
> > > +    struct mhi_ep_net_dev *mhi_ep_netdev = container_of(work,
> > > +            struct mhi_ep_net_dev, xmit_work);
> > 
> > Looks like this can fit all on one line to me.
> > 
> > 
> 

-- 
மணிவண்ணன் சதாசிவம்

