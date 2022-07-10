Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F02B56CDC3
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 10:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiGJI1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 04:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJI1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 04:27:05 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B5ACE12;
        Sun, 10 Jul 2022 01:27:04 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b8so1066350pjo.5;
        Sun, 10 Jul 2022 01:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+JGyIrDFKDR5tt3yuLkl9IPyrn5UU1z3xDSAUDC2xz8=;
        b=Tq4n/l75AECE7/QAv0VPvl+liF461bSZkRnNXOUynaeNL4s7NKl6h6QBRjiQVIAM1P
         YqxIwEzXOv8fcKQ2LfV6lyCUGv27comS2RO3UujNeqEAmlCs7Wu6DnYEyYSaJOGny2LI
         7VczYfbrAue3gcw/om1tiDFaoDtgMGeBpM0QEHXnnqHhv5GdLkHWf6ym/KV3mBc4EE+P
         tNg90xgtkD3cm1unJy0YmT7cSqZXW/5gq1xmd2VjYjWK6+9ipzw6tA+bWXBIyk+2tiBV
         ZYLaekeEEIpYKgHPO34nvwiqPVEXQHw7morkKGVF9DqBH71rT2pMitMXWEN2iLpEbLUM
         8kKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+JGyIrDFKDR5tt3yuLkl9IPyrn5UU1z3xDSAUDC2xz8=;
        b=rjNoCwqxt79Tv4eruZpNe0CW8X5RcQTrfMCldaAA8uyHkxOByJ8p4TtO/NmMm0vFJu
         YHbEbTJCH2Aqk8fGqcZIJpLFHLuBxOisYvjO0nYu0wRDSe59WdL9k0uDfWY+AJnsooxk
         lYag5Eg1FA6ouVAbN8Usv2eLn+EUdZpH+wRy2bp238F6aWPFcAJiZhkQfZPFAS23eI+w
         Gh9ozw8oLiuZQdy0If0qbXIXGJkuZhueqPfZtUH4vC5rtwUwUHB1/Hb28YiBw39nbMoQ
         dpAC7F02VQ3sEGU4kasr2wgst+0dZZPDPbqUifgvdRR6wm9WGstZSvNPYzTvxGA16cuF
         /Fmg==
X-Gm-Message-State: AJIora+DU0XcAtPo4oY/xUw5xlOU0Uncw7FL49aA7SFSnyy7HM7PMEXA
        o2ieKvE5nxQ3O+Xpk3CNQSCL6a9Xmenj+A==
X-Google-Smtp-Source: AGRyM1sXYmEdJoJWN5wHdoEyfeBmS2VDuEfDPLxkNS4oSJG/OLbYBSWstHCLd8vOkiPN6ziIdWfp4Q==
X-Received: by 2002:a17:90a:1c02:b0:1e0:df7:31f2 with SMTP id s2-20020a17090a1c0200b001e00df731f2mr10321229pjs.222.1657441623831;
        Sun, 10 Jul 2022 01:27:03 -0700 (PDT)
Received: from cloud-MacBookPro ([2601:646:8201:c2e0:b884:a80c:dca9:4492])
        by smtp.gmail.com with ESMTPSA id rj14-20020a17090b3e8e00b001eab99a42efsm2404469pjb.31.2022.07.10.01.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jul 2022 01:27:03 -0700 (PDT)
Date:   Sun, 10 Jul 2022 01:27:02 -0700
From:   binyi <dantengknight@gmail.com>
To:     Joe Perches <joe@perches.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Fix indentation issue under long for loop
Message-ID: <20220710082702.GA2109@cloud-MacBookPro>
References: <20220710021629.GA11852@cloud-MacBookPro>
 <1827050fdadb6173118fb396ad1fead23cda809f.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1827050fdadb6173118fb396ad1fead23cda809f.camel@perches.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 09, 2022 at 07:23:20PM -0700, Joe Perches wrote:
> On Sat, 2022-07-09 at 19:16 -0700, Binyi Han wrote:
> > Fix indentation issue to adhere to Linux kernel coding style.
> > Issue found by checkpatch.
> > 
> > Signed-off-by: Binyi Han <dantengknight@gmail.com>
> > ---
> >  drivers/staging/qlge/qlge_main.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> []
> > @@ -3009,8 +3009,8 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
> >  
> >  		for (page_entries = 0; page_entries <
> >  			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> 
> Probably better to change the for loop to 3 lines as well.
> 
> 		for (page_entries = 0;
> 		     page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
> 		     page_entries++)
> 
> > @@ -3024,8 +3024,8 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
> >  
> >  		for (page_entries = 0; page_entries <
> >  			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> > -				base_indirect_ptr[page_entries] =
> > -					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> > +			base_indirect_ptr[page_entries] =
> > +				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> 
> etc...
> 

Thanks for the suggestion. Will send a patch v2 in another thread.
