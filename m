Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8B5623637
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 22:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiKIV4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 16:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiKIV4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 16:56:45 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BA06346;
        Wed,  9 Nov 2022 13:56:45 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso3819wmo.1;
        Wed, 09 Nov 2022 13:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OMX4DRvwtEMePU5sRSpDG5gedWnxapEXoFXk22Q8saU=;
        b=Z5eNhi2d30QFuY64nbtXbY1au90WnIkGV+Z6HXlVfActSNG429aEnKHoZI3CejovyN
         72eLffvBdHLN1n/tp83MKaCDHzqnSYEUe1RT3H6tQFzHFASJzY8nOBjU3g4jaeCE3vYZ
         LRSC5cACRX1SkeuyPI/SVEkbq3BQf+ar7+xdfiFNT+XKD2InNRr9PVib8nPmZh9WVXEL
         5ybIhSv7YH0YpQmcM22d/wdnFE7681ZJxCaey/7XfhpbTLoPS+nVXCec3YSMzGndOgsp
         cLJq1205cQSuHMmheVq3DwSKatUVGgGQ72beJtsTc7dtJVPJqlkZBds2ABdNY5PxHHvf
         S55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMX4DRvwtEMePU5sRSpDG5gedWnxapEXoFXk22Q8saU=;
        b=dp7OCAamwthas2hDgG9OI/ZY8IRHAOvcG/Jpl4gyCkkISQHvWQx1RQQdG0dV9L+Lah
         Ra8JPtBu811RFYbXo0eZ+7tB6hj8VkmKEzV+SO9p/xk9TjJZLxnZbdSU3ZW9sD19SVvN
         F1CnkIpJH4aURyxjEXM6kSqqHpM2qhCOARcZV7em5DqeAPI/pErIkHm8h16BTXxjDBjO
         mBKOHviIk0GqZHeM7AQS+Tqj10A8gPnZRLMvbX23jQ8rCaW9Ft7Jc1bu1epY3NyA/OTQ
         utZV9XL8YwSqP4iWO9h++ouwgsDjdXxpEOxsWtB2oS2Ie33NssV6I9JtaPJCfJSk+RsZ
         o/Mg==
X-Gm-Message-State: ACrzQf1l6CUmDRu4FahZWGCyA8dou9AUl3lZZMQA0MfScnctHyDRbaGU
        49Oqk4kOmHOkwG/bDN/yzrY=
X-Google-Smtp-Source: AMsMyM7JdYNHD1k8HwE/oPHPnToLXsSm+MaJFh8hI5qAtMm2kNk3IvdZa/+MFu4pz1UnfuEFVDTutw==
X-Received: by 2002:a05:600c:3488:b0:3cf:88b4:7394 with SMTP id a8-20020a05600c348800b003cf88b47394mr27916168wmq.75.1668031003442;
        Wed, 09 Nov 2022 13:56:43 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id z15-20020a5d4c8f000000b00236a16c00ffsm13833721wrs.43.2022.11.09.13.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 13:56:42 -0800 (PST)
Date:   Wed, 9 Nov 2022 23:56:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Rob Herring <robh@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 08/11] of: property: Add device link support
 for PCS
Message-ID: <20221109215640.snoos6ti62vkxapj@skbuf>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221103210650.2325784-9-sean.anderson@seco.com>
 <20221107201010.GA1525628-robh@kernel.org>
 <20221107202223.ihdk4ubbqpro5w5y@skbuf>
 <7caf2d6a-3be9-4261-9e92-db55fe161f7e@seco.com>
 <CAL_JsqKw=1iP6KUj=c6stgCMo7V6hGO9iB+MgixA5tiackeNnA@mail.gmail.com>
 <CAGETcx-=Z4wo8JaYJN=SjxirbgRoRvobN8zxm+BSHjwouHzeJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-=Z4wo8JaYJN=SjxirbgRoRvobN8zxm+BSHjwouHzeJg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 12:56:15PM -0800, Saravana Kannan wrote:
> > > Last time [1], Saravana suggested to move this to the end of the series to
> > > avoid such problems. FWIW, I just tried booting a LS1046A with the
> > > following patches applied
> > >
> > > 01/11 (compatibles) 05/11 (device) 08/11 (link) 09/11 (consumer)
> > > =================== ============== ============ ================
> > > Y                   N              Y            N
> > > Y                   Y              Y            Y
> > > Y                   Y              Y            N
> > > N                   Y              Y            N
> > > N                   N              Y            N
> > >
> > > and all interfaces probed each time. So maybe it is safe to pick
> > > this patch.
> >
> > Maybe? Just take it with the rest of the series.
> >
> > Acked-by: Rob Herring <robh@kernel.org>
> 
> Let's have Vladimir ack this. I'm not sure if it's fully safe yet. I
> haven't done the necessary fixes for phy-handle yet, but I don't know
> how pcs-handle and pcsphy-handle are used or if none of their uses
> will hit the chicken and egg problem that some uses of phy-handle hit.

I can confirm that on today's net-next, the driver owning the pcs-handle
will probe even if the PCS driver is missing. With the mention that it
only does so after the driver_deferred_probe_timeout, which also in
today's net-next is by default 10 seconds if CONFIG_MODULES=y.
