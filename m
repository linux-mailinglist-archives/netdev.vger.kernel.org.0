Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8888268A6E8
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 00:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbjBCX0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 18:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbjBCX0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 18:26:52 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D425A6B95;
        Fri,  3 Feb 2023 15:26:51 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id dr8so19475037ejc.12;
        Fri, 03 Feb 2023 15:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rMnBlfXN7CgMdNrNbZ8i+N++BPKPmyAYplYheBgim1M=;
        b=P0dHi7uaZy9vtlDSY06AYKOSBQvTrD9t1RIyHx+rc0PRfXFLwgfyp9xQmipINlSwGP
         c47hThu2WsG7++xgFM4XpEIrAmSy2OzxlVz2CdcwxNCS4lMKZB9ShJPdAhhEpCBl2Cs/
         NzuPIBy908LP6jTW5cYww5QRwPZCez3Hp0vzG/sH+tuAPmauUUOnsR95AuVHiirdd5yY
         765YyBpZCtgiJZHxaFf2wBpc8VukkmnXyZ7SaTSPyZ1RUbZRij5DyLkduL7X5+hsdQQq
         rH2xDAFak/f7VuuNHXMRjDPHiA3VqNl7uVRmzL98H/g2weSL2rMBp698CvEiCp7FcPoM
         5BSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rMnBlfXN7CgMdNrNbZ8i+N++BPKPmyAYplYheBgim1M=;
        b=NkUEukBw2z4dIlOMjnaj/5NuJtmUhfaZWJ6wBTeL1CNjR+YF6cCIWjpavrxU+hs5fp
         VCnWVGK69muEWQpL0HZINomWkYohtgpPguiMQ7eRZ7V77sINCgw3o551PS0wIPzT1j83
         y+dpgHSPTqwPOnwKfXjWrgjEFdbrwHkaGaslt/pMi5Y+q4d9RThwcCBCTAOqwkKJy4ph
         3g22JJoH30QrDV3WaUeUx6yCBXtvXMYXcbT6i8PhsajxpmVSPxbVsRCarrmDPSrMJC0M
         5O0BKUnD7iqMW+skUViLL0E+tpemsiviZBxuviOF3hzb8O7Ju94GPtVJoRs0c/e8UxUC
         WdEw==
X-Gm-Message-State: AO0yUKWOWrRDkG34wresjgaYMwAIpVskI31QGwKukW70L7x8f2fSiAwE
        veNx2k8S6QuNLB+wT4brHS0=
X-Google-Smtp-Source: AK7set9LgIR9mzPBz2C4BO2BK7q7o2vNdyGml7hakvUkITFD8UUtPWJhFS0Mc9j/1NNQsDUr1MmuhQ==
X-Received: by 2002:a17:907:3fa3:b0:88d:ba89:1854 with SMTP id hr35-20020a1709073fa300b0088dba891854mr7698520ejc.37.1675466809357;
        Fri, 03 Feb 2023 15:26:49 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id kg11-20020a17090776eb00b0088519b92074sm1995767ejc.128.2023.02.03.15.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 15:26:49 -0800 (PST)
Date:   Sat, 4 Feb 2023 01:26:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh.Sankaranarayanan@microchip.com
Cc:     andrew@lunn.ch, davem@davemloft.net, linux@armlinux.org.uk,
        Woojung.Huh@microchip.com, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        f.fainelli@gmail.com
Subject: Re: [RFC PATCH net-next 04/11] net: dsa: microchip: lan937x: update
 port number for LAN9373
Message-ID: <20230203232646.fwnvovw5ssbo7cpj@skbuf>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-5-rakesh.sankaranarayanan@microchip.com>
 <Y9vUflgHqpk44oYl@lunn.ch>
 <e4344f16e1c0a87b533ad9d87c2306dc53214308.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e4344f16e1c0a87b533ad9d87c2306dc53214308.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 10:43:40AM +0000, Rakesh.Sankaranarayanan@microchip.com wrote:
> Hi Andrew,
> 
> On Thu, 2023-02-02 at 16:19 +0100, Andrew Lunn wrote:
> > > LAN9373 have total 8 physical ports. Update port_cnt member in
> > > ksz_chip_data structure.
> > 
> > This seems more like a fix. Should it be applied to net, not net-
> > next,
> > and have Fixes: tag?
> > 
> >     Andrew
> 
> Yes, I will update and send it as separate net patch with fixes tag.

What's the story here? Arun must have surely known this isn't a 5 port switch?
