Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B4A603824
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 04:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiJSChQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 22:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiJSChP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 22:37:15 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F5D101FF
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 19:37:15 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cl1so15708653pjb.1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 19:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6IG9/RFyaFOl9Cq+FSbA8wz7vaNcYiGkDaJxfVPNrIg=;
        b=fI7tJ2J5zZQpRI1htK67VCwUCG8MdUyUaqihf222F9NbYdPAIa+cXu4rfL+D7ZI0FY
         fAF46ADAMDakFDLaAZJqgGY/ofz+HJYg+6guPbNvpPzpsmBAPQNA0OF2L1+PATFD/qe7
         14WIIhw016APuN3vEHAVeJdYLBUB3Uu8wPtf+9iIKPGu+VO2y7heieWprlIL+oiQC+sL
         h/nK/80cpVDPC7rEs6QCMcIVqnzAscr6ZMe4uKe6W31UjFlH0S61KNIIqhxqGxJKjTP0
         KbM5EmluAiAZo5ybhhOhIkz4hRJbjYmsuPpZwQfTbHfLJWRDHIykQCNSJn8pwCsXr9pb
         3UbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6IG9/RFyaFOl9Cq+FSbA8wz7vaNcYiGkDaJxfVPNrIg=;
        b=czoxovwACJS3Tqoq1ofjUHZ88Dl1YObC5AVioXGhhSFjM9aOi7NTPpHBG4xaD06FSk
         rDzQGrp+Vu7fihYjlJO4eOmA1CLNtLgK5u/2jyZgVJnSy3mfacOmlq5fWHmi5rVUs85p
         6iclJf0hyTdTjYUhczgaylTrLHTq9l9OydVUrv/PBvhgND/q3EsEsO9R+Olw5KNr16D4
         PFQGjIBKGu45/eXcQ4qcLt2X6iRHbPLHLd7Kk598NycJUggsqMhMzQ/wZlWVJrUwIgAM
         sD52detEFbFDSJEIW0XwrLQjYWgQLf8K171ZefK14ClCr5N2vbUHlU7v5U4MJ1jRA5QD
         mhCQ==
X-Gm-Message-State: ACrzQf2b5/+sA4CThWjhW4uCbwUl7/FuH3ea9i3vI0Y3cWwxTiophEcJ
        xbrDfSXtvSwLGTvlp0UXEL+mSsDbWBM=
X-Google-Smtp-Source: AMsMyM7Ex2Cimry4bYBF4Kw3FOFBlM/ipqcm9KUkHPuwr9heL2IBGtJ9wreLzq/wZjYf1T83XFojHg==
X-Received: by 2002:a17:902:a9c6:b0:178:b2d4:f8b2 with SMTP id b6-20020a170902a9c600b00178b2d4f8b2mr6045670plr.79.1666147034483;
        Tue, 18 Oct 2022 19:37:14 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090264d000b00176e6f553efsm9378315pli.84.2022.10.18.19.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 19:37:13 -0700 (PDT)
Date:   Tue, 18 Oct 2022 19:37:11 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Cc:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>
Subject: Re: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP packets
Message-ID: <Y09i12Wcqr0whToP@hoboy.vegasvil.org>
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
 <Y06RzWQnTw2RJGPr@hoboy.vegasvil.org>
 <SJ1PR11MB618053D058C8171AAC4D3FADB8289@SJ1PR11MB6180.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB618053D058C8171AAC4D3FADB8289@SJ1PR11MB6180.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 02:12:37PM +0000, Zulkifli, Muhammad Husaini wrote:
> > What is the use case for reporting DMA transmit time?

So the use case (mentioned below) is TSN?

> > How is this better than using SOF_TIMESTAMPING_TX_SOFTWARE ?
> 
> The ideal situation is to use SOF TIMESTAMPING TX SOFTWARE. 
> Application side will undoubtedly want to utilize PHY timestamps as much as possible. 

I'm asking about SOFTWARE not hardware time stamps.
 
> But if every application requested the HW Tx timestamp, especially during periods of high load like TSN, 
> in some cases when the controller only supports 1 HW timestamp, it would be a disaster.

But can't you offer 1 HW time stamp with many SW time stamps?

Thanks,
Rihcard

