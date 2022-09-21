Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70F75C0435
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 18:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiIUQcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 12:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbiIUQb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 12:31:56 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9987A031E
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 09:12:50 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id mi14so4725470qvb.12
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 09:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=aLY4X7jLe6jyDRz2GTUZzGVaQ/S9bUP0pVCXbM8UVnQ=;
        b=TPua4QONi/9P40ftlbD8dp1zg3rSaSqwpFR9IQzhC+qUz1Fp3XC86DD38Rs/IlQteT
         mhC8Q5Ip34T/drUuWDOAfP1w5Oi+o3MIAt6huHmVSGRHAfvDxMkYPwWMLUYsAoklf+TI
         sxQOINPIDXAzIClL8JUhpvoygyw7Nis8ZOPbHv3tOG/kJziCrdKCGR+zD+16Q7jWBvTx
         b3sq4muQd7s2scTDNZUMlsJKdu+5ZncIwc1pHEMCFOdb7DZbcEEju2zkpk9hHJf5f2Fx
         SDo/2l8RLlcEYe8UX5BENtEoK6jqG3kQdYjEbcER6ehHkpYkrf6sEaflGItWS+Z81gTl
         /TOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=aLY4X7jLe6jyDRz2GTUZzGVaQ/S9bUP0pVCXbM8UVnQ=;
        b=8RZ9HHRwRTmXPOGZEhaRLp2iHM+QQopYM2qMXwnRp+fKXioyWl9r8+z8tJbwpOYLr/
         w3kYW1WuSwLQ3Y5WEZxrgxIPbol/oK+VZOViiz2OfbFz/KsqcgPefP6RymDEV+im4wNA
         tRBrwjN/Ao6yEKsG8xIw0qcpEFT5gjE3Jvtt1myYdOEfdL3+12J7ydPc5O5p2o9W9vAV
         dBiBdIY/+2z08pPG8Iq4/jVyut42TAhde1Yw4yfW0f2H0cxmcknQQXBQlr5H5FraXgBO
         MbL0ApzeWAypEB7b1y0E69k7qbmDwwMAbCca9bSTK2+bb4TNMVvgyBP83sM31ZPXa0G7
         e78w==
X-Gm-Message-State: ACrzQf1icglyxEBK1ALNsw7FR2MZoMmLHKQzx0E9a5wmpFghZAlZBi0B
        dB/3NcvUrCv+Bshsoo9FVDD4Kg==
X-Google-Smtp-Source: AMsMyM456CtmBnPUaHOLnSGIaudSOSiBnahdUvNlkNTz0WVQ9WE8C2u4WZr6oZuKp7Qi+VeOkmaN3g==
X-Received: by 2002:ad4:5f47:0:b0:4ac:b8de:1484 with SMTP id p7-20020ad45f47000000b004acb8de1484mr23810326qvg.77.1663776757853;
        Wed, 21 Sep 2022 09:12:37 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id bs39-20020a05620a472700b006bad7a2964fsm2065622qkb.78.2022.09.21.09.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 09:12:37 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1ob2Ky-000qF4-Lc;
        Wed, 21 Sep 2022 13:12:36 -0300
Date:   Wed, 21 Sep 2022 13:12:36 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [Patch v5 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Message-ID: <Yys39Dfw42XjNA7e@ziepe.ca>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-13-git-send-email-longli@linuxonhyperv.com>
 <SA1PR21MB133500C46963854E242EC976BF4C9@SA1PR21MB1335.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR21MB133500C46963854E242EC976BF4C9@SA1PR21MB1335.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 05:54:19PM +0000, Dexuan Cui wrote:

> > +int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct
> > ib_umem *umem,
> > +				 mana_handle_t *gdma_region, u64 page_sz)
> > +{
> > ...
> > +
> > +if (!err)
> > +	return 0;
> 
> Please add a Tab character to the above 2 lines.

How are we still at the point where we have trivial style errors in
this series at v6?? This is not OK, please handle reviews for this
basic stuff internally.

Jason
