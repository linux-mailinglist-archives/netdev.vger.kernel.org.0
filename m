Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C0A6A5B79
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjB1PQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjB1PQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:16:29 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F702DE69
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 07:16:28 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so13995317pjb.3
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 07:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0tC5HCISVzkLKp1GvR9hxhPs1xrLED+Ko6Sghw73aeI=;
        b=RjGyeH7war87SnPqhCv8/GAy0kPO87ASG1kCeXv3okJIjF80vpZAv2Wf+6M1df1pKY
         AreIEpL761L9oW2hd2/mZ0n4mzVaMIf5M17+iRsh1YeeqU7OHv6BCeo7dUuZ1vytMYff
         4WRbFqk0jpV3gpiTVhDUo2oNJirsRKaHgeyBHeVITazN+hXDFVd1RyR94IhVY7U7K6Jh
         LejvRWjjzmQ43+fBgWnnOdk1nS8cS3+yirUxSh6HKKxwIPrfwp43OmWZM0RwEZOG8ig4
         14ub5Ooa5h4yi7dfRx/x41XhQBuBRsnKTxla5xyby0XINNjVxbis9BKbaWZ6uMQ+rWVy
         t3Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0tC5HCISVzkLKp1GvR9hxhPs1xrLED+Ko6Sghw73aeI=;
        b=SWBT4FPVxiP6LbzuhVdUmk5nVYfdoxABNHXtoE3sqtd50yHJOfh87tDIubKq5hVBvu
         4ot0N+eCy/LI70lNzkczW6grvitIMZDjyq1lsxzIfXlGn2rP3LzVa7wXKv35Yiz3U3+I
         H87dHbN5ddqVEAoWUabQIbMeeZ7jCJH/9CcMtjoe+JLgnCVpvWcmp1NiKmREVkYX96iw
         YktYoYzQutmCEsWidbCmuNdMo+ief+ollq7lHIw1HViMhCxSRBHDqE2qX2vtGJzPdWfT
         zw+YbUx3Vql4EmnVUSoqvrgzcNV66Ph6msLCPxjGliDJuDM/kPDkm8MEhlOM7Nw1MlEH
         07vA==
X-Gm-Message-State: AO0yUKVJmrH1Smp1p8sr12zCgVVtLkFxhMsLc7vv9UOZMmimBshYhjLA
        2icLW2n2/uPiSqZanKKolZ4QFFAoHhk=
X-Google-Smtp-Source: AK7set+wqWLJVzmrog+jffGq2C84R3iqM8LSJhT+yQWAXxhZSAAlalXWJ1RJTFIpKVvAM2ebjOIhqA==
X-Received: by 2002:a17:90b:70e:b0:237:47b0:30d3 with SMTP id s14-20020a17090b070e00b0023747b030d3mr2861086pjz.4.1677597387696;
        Tue, 28 Feb 2023 07:16:27 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id a15-20020a17090a70cf00b00233df90227fsm8017482pjm.18.2023.02.28.07.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 07:16:27 -0800 (PST)
Date:   Tue, 28 Feb 2023 07:16:24 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>, andrew@lunn.ch,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
 <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
 <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
 <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
 <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
 <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
 <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
 <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 02:16:30PM +0100, Köry Maincent wrote:
> On Tue, 28 Feb 2023 12:07:09 +0000
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> > So yes, it's a nice idea to support multiple hardware timestamps, but
> > I think that's an entirely separate problem to solving the current
> > issue, which is a blocking issue to adding support for PTP on some
> > platforms.
> 
> Alright, Richard can I continue your work on it and send new revisions of your
> patch series or do you prefer to continue on your own?

If you can work this, please do.  I can help review and test.

> Also your series rise the question of which timestamping should be the default,
> MAC or PHY, without breaking any past or future compatibilities.
> There is question of using Kconfig or devicetree but each of them seems to have
> drawbacks:
> https://lore.kernel.org/netdev/ad4a8d3efbeaacf241a19bfbca5976f9@walle.cc/ 
> 
> Do you or Russell have any new thought about it?

The overall default must be PHY, because that is the legacy condition.
The options to change the default are:

1. device tree: Bad because the default is a configuration and does
   not describe the hardware.

2. Kconfig: Override PHY default at compile time.

3. Module Param: Configure default on kernel command line.

4. Letting drivers override PHY at run time.

5. other?

It would be possible to support both 2 and 3, with command line having
the last word.

I don't like #4 because it would cleaner if every time stamping driver
would simply implement the internal APIs, without having special hooks
for various boards.

Thanks,
Richard

