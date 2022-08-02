Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3455E5881A9
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 20:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbiHBSIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 14:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbiHBSIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 14:08:20 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C23513D39
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 11:08:18 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id e5so10926771qts.1
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 11:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t/KnfuDsURg9bubxzAvoQj1egBM9mbKPc7JxqT9dzco=;
        b=Ds4m4A4fVZdTvo7C0gRYbAaLtRlWpt7c6XNlee/vm3R7aHbEQLpsCYxPUuNeXI0yYQ
         tgMe3JbtVdcjq7/MK4EaR5SNdfuVVP65dvSYHb945oEcuP3uvZ/GiNA4Q3T91ayPpcj3
         Lhw2OT2cTfDWLpiB1XBsmROV3HuPIEv51PG1t0TQyeTQklPW7SyHAodoWQc2vLW7+kyp
         BHQ3X4FkJ9i9eUPPqGq23DtbMcxJ4dEXzx+RK4SymaBw2Es+sbM8ETE+heb0wn0ZPZRG
         3fd47vQxifFW4EVXSRUn2T3eFnf4hJX74TAyjJpfmlCFDBXwRTkrTJXcBSXuT5+euNsB
         UXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t/KnfuDsURg9bubxzAvoQj1egBM9mbKPc7JxqT9dzco=;
        b=rh4bNHqqfYQVVIyPYomGnJylOxhWpJNnBDJ+uORvvYPPWUUzX+mxdoyadsoWiK10xU
         5SiRsOjis/VeGp5tBr2HKpM8fyMElaJdWWWirvcys98gxmUxYUUiLH1jpLVnhI2qxOef
         QC5269rDpFbypAT5PE1LVL2kITl1RXZjY8zoE+kDAOoOTg9m5zBgjNsPMPJbCeE2Km9v
         EIXT79umBr27SseOFvukUwdeB0f+vaU5R9EZge7wUoLHV/hiTV+mn8UzOBaS5GFlRIPp
         Oli2y4oblbBXng4AG356NcV3nzmsdMh7qCss99BY4+vGsX7SyxJIu/nLi9sTIKPPNqib
         hJVA==
X-Gm-Message-State: AJIora+rk+x9wJeyFcfJbTXuJ1Z81ex1w/1t05n7aZ7j7lba+yLcgK+q
        b8/p6w0pCXyejkrAiPNAPNqUCg==
X-Google-Smtp-Source: AGRyM1vBx1AAs7g0q+4H2p9o5hHXB532RaVLKFmPC/yM+sf9e3QblJLCFbA+RKqR+UnL45hHGSbazw==
X-Received: by 2002:a05:622a:1741:b0:31f:1fa8:2e01 with SMTP id l1-20020a05622a174100b0031f1fa82e01mr20519892qtk.81.1659463697637;
        Tue, 02 Aug 2022 11:08:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id q18-20020a37f712000000b006b5df4d2c81sm10500851qkj.94.2022.08.02.11.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 11:08:16 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oIwJT-000S5E-Vu;
        Tue, 02 Aug 2022 15:08:15 -0300
Date:   Tue, 2 Aug 2022 15:08:15 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Long Li <longli@microsoft.com>
Cc:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
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
Subject: Re: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Message-ID: <YuloD7WkRMs7ZIXk@ziepe.ca>
References: <SN6PR2101MB13272044B91D6E37F7F5124FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
 <PH7PR21MB3263F08C111C5D06C99CC32ACE869@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220720234209.GP5049@ziepe.ca>
 <PH7PR21MB3263F5FD2FA4BA6669C21509CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220721143858.GV5049@ziepe.ca>
 <PH7PR21MB326339501D9CA5ABE69F8AE9CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220721183219.GA6833@ziepe.ca>
 <PH7PR21MB326304834D36451E7609D102CE999@PH7PR21MB3263.namprd21.prod.outlook.com>
 <YuQxIKxGAvUIwVmj@ziepe.ca>
 <PH7PR21MB3263E741EA5AA017A2AB5602CE999@PH7PR21MB3263.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR21MB3263E741EA5AA017A2AB5602CE999@PH7PR21MB3263.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 09:20:05PM +0000, Long Li wrote:
> > > the Mellanox NICs implement the RAW_QP. IMHO, it's better to have the
> > > user explicitly decide whether to use Ethernet or RDMA RAW_QP on a
> > > specific port.
> > 
> > It should all be carefully documented someplace.
> 
> The use case for RAW_QP is from user-mode. Is it acceptable that we
> document the detailed usage in rdma-core?

Yes, but add a suitable comment someplace in the kernel too

Jason
