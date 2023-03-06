Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65FC46ACCE7
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 19:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjCFSoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 13:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjCFSo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 13:44:29 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C07265475
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 10:44:02 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id h8so11440322plf.10
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 10:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678128241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=365J6Piko6rztWGOR0yLK2bsAIKP4u5eMy2EMrLl6w0=;
        b=tf2EZgbURrgBp9bwac8RT/sGU9/M1fIIhoYFbwBGIZCucpJpms9fV5d0sSKqeeBUTR
         yvA3MbEO79BepXdOrT/5ZFy3mPpPCNjVGV4uIH7nphVdHFPwt7RJ+BtNrWr1SbPTiRpM
         uY2u7IBYkTptpeqmiQatMMbTrSpZ3gugd7v/rhz/5vrB8Nst1NbnfjBC9Q4Gk6XnjT5j
         wAekaMDoTtBVA8LkcCN8xJGcnrSON8plNIUjxVJjwKiM95yYIJ1s0VgQup0G5OntHy1T
         EwlhGVYvgyeuk6OyxFPggK+oOIQ7fOyepEXF1cf1PFMIoRfOhFzWJbzP6+HosX0UcLYw
         QN8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678128241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=365J6Piko6rztWGOR0yLK2bsAIKP4u5eMy2EMrLl6w0=;
        b=iQzU2Mo3XU+bUtYGf9ii5QkuP82TrB8RC7iWr93nC5F2LtROV+lAtgjimfqJFLItZD
         GpzgWbDujp9uRzgeKkzo9zPaSWAhO9n9vYdl00quOH11rw6Km0YkXlaq3Y4+bGDaZqlf
         SAHiGybOV9JOIw3d1q/nd43sJJxKsreYHl5x/HSQh+kB5q5ZWAobVPMCIlaU0kM4LRb0
         +sUu430Es6eAhXQO44tluX9QbJzTkxESmBgOxjJkpIWP9RwkN9bwlMlrTAjnwKHy7CtP
         oNtnSeyMGNRhLHdoZN/wDHzpEFI60554g/cGmkYa85YnVcp5Rd1NF4U+qKKMb9OVs8Yl
         Qw0w==
X-Gm-Message-State: AO0yUKVh26hmbi3nWSsXNJLaagn+nk7fPidx/bcUeMm3Skbtr7fudk9B
        3e0ysPZvMg0n10sprCIzMhSw4w==
X-Google-Smtp-Source: AK7set+/MEIeQEy/F6GN5ZSD5HtwdnA/tFtpDPXbVIG5nrXJuyJNtIIVYf4bU3UboWwix9n+UDkZEw==
X-Received: by 2002:a17:903:246:b0:19c:fd73:5586 with SMTP id j6-20020a170903024600b0019cfd735586mr14251090plh.38.1678128241615;
        Mon, 06 Mar 2023 10:44:01 -0800 (PST)
Received: from p14s ([2604:3d09:148c:c800:e8cc:984:8f0a:efd3])
        by smtp.gmail.com with ESMTPSA id x6-20020a170902ec8600b0019c91d3bdb4sm7010259plg.304.2023.03.06.10.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 10:44:01 -0800 (PST)
Date:   Mon, 6 Mar 2023 11:43:58 -0700
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/6] Introduce PRU platform consumer API
Message-ID: <20230306184358.GA1633717@p14s>
References: <20230306110934.2736465-1-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306110934.2736465-1-danishanwar@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 04:39:28PM +0530, MD Danish Anwar wrote:
> Hi All,
> The Programmable Real-Time Unit and Industrial Communication Subsystem (PRU-ICSS
> or simply PRUSS) on various TI SoCs consists of dual 32-bit RISC cores
> (Programmable Real-Time Units, or PRUs) for program execution.
> 
> There are 3 foundation components for TI PRUSS subsystem: the PRUSS platform
> driver, the PRUSS INTC driver and the PRUSS remoteproc driver. All of them have
> already been merged and can be found under:
> 1) drivers/soc/ti/pruss.c
>    Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml
> 2) drivers/irqchip/irq-pruss-intc.c
>    Documentation/devicetree/bindings/interrupt-controller/ti,pruss-intc.yaml
> 3) drivers/remoteproc/pru_rproc.c
>    Documentation/devicetree/bindings/remoteproc/ti,pru-consumer.yaml
> 
> The programmable nature of the PRUs provide flexibility to implement custom
> peripheral interfaces, fast real-time responses, or specialized data handling.
> Example of a PRU consumer drivers will be: 
>   - Software UART over PRUSS
>   - PRU-ICSS Ethernet EMAC
> 
> In order to make usage of common PRU resources and allow the consumer drivers to
> configure the PRU hardware for specific usage the PRU API is introduced.
> 
> This is the v3 of the old patch series[1]. This doesn't have any functional 
> changes, the old series has been rebased on linux-next (tag: next-20230306).
> 
> This series depends on another series which is already merged in the remoteproc
> tree[2] and is part of v6.3-rc1. This series and the remoteproc series form the
> PRUSS consumer API which can be used by consumer drivers to utilize the PRUs.
> 
> One example of the consumer driver is the PRU-ICSSG ethernet driver [3],which 
> depends on this series and the remoteproc series[2].
> 
> [1] https://lore.kernel.org/all/20220418123004.9332-1-p-mohan@ti.com/
> [2] https://lore.kernel.org/all/20230106121046.886863-1-danishanwar@ti.com/#t
> [3] https://lore.kernel.org/all/20230210114957.2667963-1-danishanwar@ti.com/
> 
> Thanks and Regards,
> Md Danish Anwar
> 
> Andrew F. Davis (1):
>   soc: ti: pruss: Add pruss_{request,release}_mem_region() API
> 
> Suman Anna (3):
>   soc: ti: pruss: Add pruss_cfg_read()/update() API
>   soc: ti: pruss: Add helper functions to set GPI mode, MII_RT_event and
>     XFR
>   soc: ti: pruss: Add helper function to enable OCP master ports
> 
> Tero Kristo (2):
>   soc: ti: pruss: Add pruss_get()/put() API
>   soc: ti: pruss: Add helper functions to get/set PRUSS_CFG_GPMUX
> 
>  drivers/soc/ti/pruss.c           | 257 ++++++++++++++++++++++++++++++-
>  include/linux/pruss_driver.h     |  72 ++++++---
>  include/linux/remoteproc/pruss.h | 221 ++++++++++++++++++++++++++
>  3 files changed, 526 insertions(+), 24 deletions(-)

The last revision of this set was sent out on April 18th 2022... It is always
very difficult to follow-up with a patchset when it has been this long.
Moreover, you added a SoB to patch 1 and 2 but none of the other ones.

Roger had comments on the previous set - I will look at this revision when he
has provided his RB for this entire set.

Thanks,
Mathieu

> 
> -- 
> 2.25.1
> 
