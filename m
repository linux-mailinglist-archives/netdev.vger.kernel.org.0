Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC2964C51D
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 09:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237756AbiLNIcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 03:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237733AbiLNIcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 03:32:51 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8B35FE9
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 00:32:50 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id vv4so42742169ejc.2
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 00:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TwUMu2azzipq45IwQjtmcCDGi09cxl5lBCyxvhXvDUI=;
        b=qiDm5J9XGRu+Px/wzUOGgM5s6Nwx/c7lf9skC//hTRRfTOer14reYby3/VSTDZIETg
         h6bYXf6fymtIbh/MAs3KQsrZB8gpvlzuWKTbrUIvrn0HtRNro/cjFt3G7i8hz5puGfTD
         55SMYFcUJDl5TGZdR0IgHvMFcHlxIMCAwYkY9iXK3P5O8BgIRNloFpHQxy9y2Skei/2u
         /wUkeRrRLmAwG1ylwmfypfugptDKxHugbi4d97Nh0jnW4/SIGrbcG5oL2enJrWwcnzT4
         lm72Y6wDPRXZBa+Udu/iF4CLIEdavkkqIJuI/5d8qNP1Tq14MYZSk7Sv3RRwEp0rIrP4
         BrHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TwUMu2azzipq45IwQjtmcCDGi09cxl5lBCyxvhXvDUI=;
        b=kzUFKj+AEZFwFQ/smYLM0CdpBHzAa5rlgW7JKlVvsYW+C80WeUKWC5HmpCuZ+aiaKS
         XZdvuNPmBhXAOpz7vlv52498F0UuaTwYjtdHpPvBW5KuXb2pTWDPCaZiRKnRJekz6JT/
         Q9FEU3HKXu7TOcYdbFthAFN7AiA6G4j99d7QV0+CK1+h4udr1KKYZH9WTSxxYfIDMeAK
         +SIx9cWj8HPiBmFbOMngv2cEUjiZwvmW4VwEf7SMo0BM+Ll3cXgMfvjVPDlNOjAO29f2
         Hjtzda1Ld8ySXfrQkoAwZ1wT5WxpwYQS0/I1NOcYVpNVMScHTBu4v4fLtEQc+K+r9oGL
         OfCQ==
X-Gm-Message-State: ANoB5pl1PWGM9MZQdaWGqT2paUAvYr2HqvOSSK+bO9j+x5rGEBjg4Yj6
        IZ+kT/gC7iOKsXhlINPlqxTIBw==
X-Google-Smtp-Source: AA0mqf4UkhwNzLmopxuJ6G8JXG8IJsRsGhBNWdFj1CJ2U5Y2qlvwvamXR4Vzha9eUI74RaQkj7rdHA==
X-Received: by 2002:a17:906:2bd7:b0:7c1:4c46:30a0 with SMTP id n23-20020a1709062bd700b007c14c4630a0mr15273928ejg.65.1671006768834;
        Wed, 14 Dec 2022 00:32:48 -0800 (PST)
Received: from blmsp ([185.238.219.41])
        by smtp.gmail.com with ESMTPSA id z20-20020a1709060ad400b0077077c62cadsm5539676ejf.31.2022.12.14.00.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 00:32:48 -0800 (PST)
Date:   Wed, 14 Dec 2022 09:32:47 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] can: m_can: Cache tx putidx and transmits in flight
Message-ID: <20221214083247.u7ixomwsu46dbfxm@blmsp>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-4-msp@baylibre.com>
 <20221201111450.fpadmwscjyhefs2u@pengutronix.de>
 <20221202083740.moa7whqd52oasbar@blmsp>
 <20221202144630.l4jil6spb4er5vzk@pengutronix.de>
 <20221213171309.c4nrdhwjj2ivrqim@blmsp>
 <20221213191717.422omlznn2cjjwjz@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221213191717.422omlznn2cjjwjz@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Tue, Dec 13, 2022 at 08:17:17PM +0100, Marc Kleine-Budde wrote:
> On 13.12.2022 18:13:09, Markus Schneider-Pargmann wrote:
> > > > The tcan mram size is limited to 2048 so I would like to avoid limiting
> > > > the possible sizes of the tx fifos.
> > > 
> > > What FIFO sizes are you using currently?
> > 
> > I am currently using 13 for TXB, TXE and RXF0.
> 
> Have you CAN-FD enabled?

yes, it is enabled.

Best,
Markus
