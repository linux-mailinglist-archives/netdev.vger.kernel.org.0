Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83E655ADB2
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 02:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbiFZADl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 20:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233433AbiFZADj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 20:03:39 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C9113CC7
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 17:03:38 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id y14so9940005qvs.10
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 17:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uzBv+rLiOMQN1QJ1CAlWRVrSA/M0AyPQIUhJ4NlvMOE=;
        b=DuSHNIG60LiWNKf6jLN1j6RVigzx0qhdEesKDgOV6wCISOLAQI7oQlLZ/pFMrGS7uL
         hfcEwE0OB9CtMtMYxyMiNYaG81IkT4C7Ua/QhOEJnd39panh+4ltOP/BIBAEV3y1R9GA
         gv/uHXrgxGI6bX2M8ODhkxbSUoYXIQKyd3l/SN/UakjuIzb9CfFxYw4rJ1i++aOpA7Ar
         28C4xehBv/LYcrSDI0eWRkL2H7mbfx8qErhO3Q+c3I7RJcgd1K95DRVGNFv533NU9SJR
         LJCRdDJqjgWOpL8hXm0Btn05S45hfiod4wR8rAV4Po2MD/PXo22z8w15OPX/cpr44Fsz
         wgfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uzBv+rLiOMQN1QJ1CAlWRVrSA/M0AyPQIUhJ4NlvMOE=;
        b=ainqOwF9ZbYEST1IKEqEYi9cq8IgJOzNYe/x8xFq90y2Inc1Oh5XE6Vq2PX/mIk5dk
         7UXPURkf0iQsoqow7wiV8CwwGt5lMRykhQx+at4Hh31/0AXu02ueeDJV5o5OXAwKJoD7
         DRP5H0QvA6d6dYV/18W7QmLzDuJRJiuTekvBTX/IwviT8adpcaIxQcfeOnnhiS762oKr
         DVBeh+pbzLMVq2PjP/oy/JnTA20W5YxcGEYDRfyinXn8jvZHZMx98m8kyE/M14R0gDrA
         7S/ocxIyevahC92kR+1KTnTu2gA6t/aOP0qjRH9tzkH9Mq7hCbDKpqaedjfr+kDz4v6s
         MxSA==
X-Gm-Message-State: AJIora+cWVS1/N/7euXyJ0JIVqU71ygIanL4K7zHYSMrevlJaw5FT5F6
        CI2c/QxeDJF5H1/gie/5jD6BvQ==
X-Google-Smtp-Source: AGRyM1tE4BoFBAJJvdfxmP6e/GRmO8k9uiseuk8Afwuboo2RrknpwMgvTsRL6ljMihM8ni/ZMauTrg==
X-Received: by 2002:a05:6214:c2c:b0:470:a060:4543 with SMTP id a12-20020a0562140c2c00b00470a0604543mr4509412qvd.49.1656201817425;
        Sat, 25 Jun 2022 17:03:37 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id h18-20020ac87772000000b002f905347586sm4168554qtu.14.2022.06.25.17.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 17:03:36 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1o5FkV-001s2q-Pc; Sat, 25 Jun 2022 21:03:35 -0300
Date:   Sat, 25 Jun 2022 21:03:35 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Ajay Sharma <sharmaajay@microsoft.com>
Cc:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [EXTERNAL] [Patch v4 12/12] RDMA/mana_ib: Add a driver for
 Microsoft Azure Network Adapter
Message-ID: <20220626000335.GL23621@ziepe.ca>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
 <DM4PR21MB32967BB85B7B022671ECADD1D6B79@DM4PR21MB3296.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM4PR21MB32967BB85B7B022671ECADD1D6B79@DM4PR21MB3296.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 25, 2022 at 04:20:19AM +0000, Ajay Sharma wrote:
> Hello Maintainers,
>  Any idea when these patches would make it into the next kernel release ?

New rdma drivers typically take a long time to get merged due to their
typical huge size. Currently I'm working through ERDMA. Reviewing the
ERDMA submission would be helpful, I generally prefer it if people
proposing new drivers review other new drivers being submitted.

In this case it seems smaller, so you might make this cycle, though I
haven't even opened the userspace portion yet.

Jason
