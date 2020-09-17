Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432A626E3F3
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgIQSij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgIQRSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:18:36 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B82C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:18:36 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id h6so2497017qtd.6
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jfL5I8+SAEaL2OQyBySvbdAEfPXTRZQx7kR/t+e9RqA=;
        b=UgmNS1ftT004DWJhMLLmAaHR2BO1naPrzFegZa5rZnf3rGpWH8LMd1xTTJKbRlPhqt
         5ze07Yq/IeeCzRJkU8FCSG9qU7RVm34s/t37biz6aQFB8nlZATJJz83vJ272XMHqXboE
         RvOhYFgszZRwlejnC4o2y865WVl/4NTQWeYhnVX7pacrsGys8HLaK9NFowueO0pvOP8+
         bgB0BQA3PQNHnQ2s1nzRiqfajZFklpSFbi3PXOxNyYvluJygKcOCGzqQU72aqH2ef6zd
         FApi0ug9pTRrGURqNOZz5Tueh7aalLAgRaDYuAgXIMZOzigN2jCcaDeoLYOY5CpBfEgx
         npSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jfL5I8+SAEaL2OQyBySvbdAEfPXTRZQx7kR/t+e9RqA=;
        b=ZhuLQ7HIdlqgbiP3gM+4PqKtrfDlMeQEMkjcwG6nKHGuUMJoWJOVIKzxepskf061wF
         7jeozgMWrycK5Q6JM/8CoaydLa3b2mlDwo+cYNmSZ3V/OeDVmVZH/IfjcAjEI8Sb29Hn
         FbokFWwwyn7IjYA+0jjALUJD4JDbTY9hCUxltgDQZuFc+SsEu5m2fvjczFFNqTvFBI75
         U+N9n0X8tp6ZBqZVsKiNJsjAW+AO+CAdV6lov7MQKLCeFPbkbzr78hZuyFV753Vf9lXa
         K1YfDnc16X9xj0xl7TXw85RRmP1j6L13HQGW+75Np8pj+k3hoH3DxLljTPv8ewPTTzze
         BZXw==
X-Gm-Message-State: AOAM530A6YktwhSp9+lOfr2vHfqYpovXJzvaUpF/cbQbRPQA5tpuHT/D
        NGGCrUtJTYIVS9xB7Tyt5PQub1n3JVilj4Ji
X-Google-Smtp-Source: ABdhPJxyBiY7E2PwXlRdxQJ94MHJWynfjteZ/S0FWxpEdsMUTXsd97vU2/ByViQ4IYP6HH7MEiQ61g==
X-Received: by 2002:ac8:2383:: with SMTP id q3mr16956309qtq.230.1600363115224;
        Thu, 17 Sep 2020 10:18:35 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id i187sm280659qke.43.2020.09.17.10.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 10:18:34 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kIxYH-000afx-Uu; Thu, 17 Sep 2020 14:18:33 -0300
Date:   Thu, 17 Sep 2020 14:18:33 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200917171833.GJ8409@ziepe.ca>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
 <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 11:46:58PM +0300, Oded Gabbay wrote:
> infrastructure for communication between multiple accelerators. Same
> as Nvidia uses NVlink, we use RDMA that we have inside our ASIC.
> The RDMA implementation we did does NOT support some basic RDMA
> IBverbs (such as MR and PD) and therefore, we can't use the rdma-core
> library or to connect to the rdma infrastructure in the kernel. 

You can't create a parallel RDMA subsystem in netdev, or in misc, and
you can't add random device offloads as IOCTL to nedevs.

RDMA is the proper home for all the networking offloads that don't fit
into netdev.

EFA was able to fit into rdma-core/etc and it isn't even RoCE at
all. I'm sure this can too.

> wanted to do it but when we analyzed it, we saw we wouldn't be able to
> support basic stuff and therefore we had to revert to our IOCTLs.

Try again. Ask for help.

Your patches add CQs, WQ, and other RDMA objects. This is very clearly
not an appropriate functionality for netdev.

> To sum it up, because our NIC is used for intra-communication, we
> don't expose nor intend users to use it as a NIC per-se. However, to
> be able to get statistics and manage them in a standard way, and
> support control plane over Ethernet, we do register each port to the
> net subsystem (i.e. create netdev per port).

Sure, the basic ethernet side is conceptually fine.

> > Please make sure to CC linux-rdma. You clearly stated that the device
> > does RDMA-like transfers.
> 
> We don't use the RDMA infrastructure in the kernel and we can't
> connect to it due to the lack of H/W support we have so I don't see
> why we need to CC linux-rdma.

Because you can't put RDMA like concepts under net.

Jakub, NAK from me on this series.

Jason
