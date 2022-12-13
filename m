Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF0564BAB1
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 18:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbiLMRNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 12:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiLMRNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 12:13:13 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8726331
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 09:13:12 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id co23so16365275wrb.4
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 09:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wbQFyaeQ3XEAXhWOdQEYNCmIqs2vEtR7/9/GJv05CpI=;
        b=j4YWBLG15Slcs0Fq+ePqgTHB7thUqj9f5sCRbYQb15sZmW4s9FkW1yZFt19E0CTt0B
         pR97bH1C14/EcQglaA6T0lcZttEOFhYUhL2Idbi+v02h74vYMdw8n14uI5VQgvrJz3AD
         9dM8ve9EDypSt2MzAJrsAtME6KF5qRDSYqpo+rKBAibwjVGYB/EO/9zRMWOyNICOAxbK
         l/4R5a7tQQABMY2lIo+5DkOYEfdwnvrFt5FiZox7KF8oQv1JR6XeWipJ/Fq+qdHT44Al
         NVpKfxqMDMFyLomvAXAAgRv0PQqIM5shQOgQpPOfUvmHUmkoF0OkSaK3gPBdLYXWlZO3
         +kkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wbQFyaeQ3XEAXhWOdQEYNCmIqs2vEtR7/9/GJv05CpI=;
        b=Ib/+zyy8smA4s/0AXzBmOcs/zp3SNqYq9ZCgvFTF9swAOjdVu51TKzssgdxfl0cAEb
         Vqyuhd6nkqyHFIvnoM+nHxzA7Bp+PQNuHXg0oPXcW0L0jEpkFJnCKv5h55EOaNSJ8Z8T
         GOT4CGX0TAv+MU9PrypmPAXuYb5mlJRttvVpxoxr/iBq92ejKTd2aKBOWZ3x/85kDFZG
         cwWB4O8Cp/PRnhaZ08IcQB5OOMjxyQtlUNcBg7MDzRaIRg+gZF7PQMz4zSH8vfSAe9l3
         PHyNnlP+A/a9S5fLLaV7shl5CyIz+a7v5bTFqmmm2yYXR5lCqyqW+jeCOUDPALp3O3US
         8KIQ==
X-Gm-Message-State: ANoB5pmBu0+RlPIh8H9TKpXX6+Sag249JvdvBLb/qB38o8cJtjmIxYDi
        BpKe7apSHHxMZ9xvUogYiuOzdA==
X-Google-Smtp-Source: AA0mqf6fYeERk/XTOqzh5/xmIosQ9hfCjwZ3PblMvKKAa3RzsKqafketngCyk5yYH5iNli7zu1xNpg==
X-Received: by 2002:a5d:5108:0:b0:242:1ce8:c51c with SMTP id s8-20020a5d5108000000b002421ce8c51cmr15560798wrt.45.1670951590848;
        Tue, 13 Dec 2022 09:13:10 -0800 (PST)
Received: from blmsp ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id c2-20020a5d4f02000000b00241cfe6e286sm277400wru.98.2022.12.13.09.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:13:10 -0800 (PST)
Date:   Tue, 13 Dec 2022 18:13:09 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] can: m_can: Cache tx putidx and transmits in flight
Message-ID: <20221213171309.c4nrdhwjj2ivrqim@blmsp>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-4-msp@baylibre.com>
 <20221201111450.fpadmwscjyhefs2u@pengutronix.de>
 <20221202083740.moa7whqd52oasbar@blmsp>
 <20221202144630.l4jil6spb4er5vzk@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221202144630.l4jil6spb4er5vzk@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 03:46:30PM +0100, Marc Kleine-Budde wrote:
> On 02.12.2022 09:37:40, Markus Schneider-Pargmann wrote:
> > Hi Marc,
> > 
> > On Thu, Dec 01, 2022 at 12:14:50PM +0100, Marc Kleine-Budde wrote:
> > > On 16.11.2022 21:52:56, Markus Schneider-Pargmann wrote:
> > > > On peripheral chips every read/write can be costly. Avoid reading easily
> > > > trackable information and cache them internally. This saves multiple
> > > > reads.
> > > > 
> > > > Transmit FIFO put index is cached, this is increased for every time we
> > > > enqueue a transmit request.
> > > > 
> > > > The transmits in flight is cached as well. With each transmit request it
> > > > is increased when reading the finished transmit event it is decreased.
> > > > 
> > > > A submit limit is cached to avoid submitting too many transmits at once,
> > > > either because the TX FIFO or the TXE FIFO is limited. This is currently
> > > > done very conservatively as the minimum of the fifo sizes. This means we
> > > > can reach FIFO full events but won't drop anything.
> > > 
> > > You have a dedicated in_flight variable, which is read-modify-write in 2
> > > different code path, i.e. this looks racy.
> > 
> > True, of course, thank you. Yes I have to redesign this a bit for
> > concurrency.
> > 
> > > If you allow only power-of-two FIFO size, you can use 2 unsigned
> > > variables, i.e. a head and a tail pointer. You can apply a mask to get
> > > the index to the FIFO. The difference between head and tail is the fill
> > > level of the FIFO. See mcp251xfd driver for this.
> > 
> > Maybe that is a trivial question but what's wrong with using atomics
> > instead?
> 
> I think it's Ok to use an atomic for the fill level. The put index
> doesn't need to be. No need to cache the get index, as it's in the same
> register as the fill level.
> 
> As the mcp251xfd benefits from caching both indexes, a head and tail
> pointer felt like the right choice. As both are only written in 1
> location, no need for atomics or locking.
> 
> > The tcan mram size is limited to 2048 so I would like to avoid limiting
> > the possible sizes of the tx fifos.
> 
> What FIFO sizes are you using currently?

I am currently using 13 for TXB, TXE and RXF0.

Best,
Markus
