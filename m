Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2A25C0466
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 18:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiIUQjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 12:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiIUQjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 12:39:06 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1729F774
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 09:25:27 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id q11so4322155qkc.12
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 09:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9ig6i/GBOeBdko1H4go8xlVoGun/eMaDuvW3GtEHqwo=;
        b=X09Qa9KIrji9ljgoXZNT0lIz4PM4m4qJguufulU5AnNrpjF2rCkbku8Y4IG22R+n0A
         2Ym1MFkc+MIbizC84nNoRkSiB3yqnU+jjKOJdqqFUyTRngjmktTbfndyhK0Qi5mMtHvF
         zWrQE9EnFpFiZM16hyJ0UGoFBvZ05PN3C3qMUctOm47eAfvzPC7g+t1mXe1NR7DREdNB
         uViQuFecMrVqGBoFYRAEmrPFsGJTg0y3xXssFW98ud1XiI3Nj9VWAEik3LTzNNWIfXRB
         oPH66oXKmRr4I2NiFhOBiwP37RI+CoFvFdkWNfEGW0KlPliUVeLrc+zLEpp7QOOtGd6o
         GeeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9ig6i/GBOeBdko1H4go8xlVoGun/eMaDuvW3GtEHqwo=;
        b=UXskzhe1fPENI7fiaUvZPME7a3vsSGUlmQLMpPuUh0c2LNXjPvQ+vrScEdtOcvf2Pl
         JDqyD7DEf4zI9eWxNuehma99bX4fEAijLHcKBd0dfyAyjTmMGu1QxjCg9+i8+M14iwb8
         aERviARgCb0+XP8GzPGtnohF9gtL7ZZvOwiiGTrjvoLgFMkbF5yJO0NplLQJcZC+cEL4
         FeFBeqfyrnipGSSV14uWqwxWPsXKqHzCzRC0N864t0kkAO8HrFnBprWqTN0yvXBX6JUx
         Hnps1TIZTno2WcEi0d7CyaMYCeviruLQwZhkDcGx0NahODtB0hWFc+w3ADTT7DUSChRz
         jFdA==
X-Gm-Message-State: ACrzQf2IJ4fzqSQ6gyfkdLUNB/rq6LBgqsMe1DmxYp9eH8/RYnC4ZjLF
        S1h7Sg9AyeoHB05Ibp9qxdtz6A==
X-Google-Smtp-Source: AMsMyM69rR7kyU6kEnuDz4ySPv/zxJW3oVBULCy9dVuaMBuvFPQv6q4sWgK2Q7zQPhqhePDTtDkX/Q==
X-Received: by 2002:a37:2785:0:b0:6ce:7ce6:3d4a with SMTP id n127-20020a372785000000b006ce7ce63d4amr20259485qkn.322.1663777526647;
        Wed, 21 Sep 2022 09:25:26 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id w7-20020ac857c7000000b0035bbb6268e2sm2175247qta.67.2022.09.21.09.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 09:25:25 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1ob2XN-00148f-6F;
        Wed, 21 Sep 2022 13:25:25 -0300
Date:   Wed, 21 Sep 2022 13:25:25 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     longli@microsoft.com
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>, edumazet@google.com,
        shiraz.saleem@intel.com, Ajay Sharma <sharmaajay@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [Patch v6 00/12] Introduce Microsoft Azure Network Adapter
 (MANA) RDMA driver
Message-ID: <Yys69cXCOdYL0LTo@ziepe.ca>
References: <1663723352-598-1-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1663723352-598-1-git-send-email-longli@linuxonhyperv.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 06:22:20PM -0700, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> This patchset implements a RDMA driver for Microsoft Azure Network
> Adapter (MANA). In MANA, the RDMA device is modeled as an auxiliary device
> to the Ethernet device.
> 
> The first 11 patches modify the MANA Ethernet driver to support RDMA driver.
> The last patch implementes the RDMA driver.
> 
> The user-mode of the driver is being reviewed at:
> https://github.com/linux-rdma/rdma-core/pull/1177
> 
> 
> Ajay Sharma (3):
>   net: mana: Set the DMA device max segment size
>   net: mana: Define and process GDMA response code
>     GDMA_STATUS_MORE_ENTRIES
>   net: mana: Define data structures for protection domain and memory
>     registration
> 
> Long Li (9):
>   net: mana: Add support for auxiliary device
>   net: mana: Record the physical address for doorbell page region
>   net: mana: Handle vport sharing between devices
>   net: mana: Add functions for allocating doorbell page from GDMA
>   net: mana: Export Work Queue functions for use by RDMA driver
>   net: mana: Record port number in netdev
>   net: mana: Move header files to a common location
>   net: mana: Define max values for SGL entries
>   RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter

Still some basic checkpatchy stuff:

/tmp/tmpm2fsg47h/0012-RDMA-mana_ib-Add-a-driver-for-Microsoft-Azure-Network-Adapter.patch:412: WARNING: quoted string split across lines
#412: FILE: drivers/infiniband/hw/mana/main.c:70:
+		  "vport handle %llx pdid %x doorbell_id %x "
+		  "tx_shortform_allowed %d tx_vp_offset %u\n",

/tmp/tmpm2fsg47h/0012-RDMA-mana_ib-Add-a-driver-for-Microsoft-Azure-Network-Adapter.patch:540: WARNING: quoted string split across lines
#540: FILE: drivers/infiniband/hw/mana/main.c:198:
+		  "size_dma_region %lu num_pages_total %lu, "
+		  "page_sz 0x%llx offset_in_page %u\n",

And it thinks you should write more for the kconfig symbol, eg why
would someone want to turn it on (hint, to use dpkd on some Azure
instances)

/tmp/tmpm2fsg47h/0012-RDMA-mana_ib-Add-a-driver-for-Microsoft-Azure-Network-Adapter.patch:100: WARNING: please write a help paragraph that fully describes the config symbol
#100: FILE: drivers/infiniband/hw/mana/Kconfig:2:
+config MANA_INFINIBAND
+	tristate "Microsoft Azure Network Adapter support"
+	depends on NETDEVICES && ETHERNET && PCI && MICROSOFT_MANA
+	help
+	  This driver provides low-level RDMA support for
+	  Microsoft Azure Network Adapter (MANA).

I'll put it in linux-next and you can fix the rest of the stuff bots
will usually find.

Jason
