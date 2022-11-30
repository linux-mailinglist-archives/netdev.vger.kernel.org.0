Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3631663E434
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 00:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiK3XFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 18:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiK3XFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 18:05:08 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8538894921;
        Wed, 30 Nov 2022 15:05:07 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id bj12so117129ejb.13;
        Wed, 30 Nov 2022 15:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sAPj1OEKh4A63q6py1ZO6zRPXlsc0BcP6GjS55qu28I=;
        b=cxcam8c12sm2fR2HQyP5xusWpcLImVe6SVyw6cBelCRxvI+lrijxd0xW72TDQOUhNJ
         SyAloa/2TqqjtIkVqPTTDed5nOmQPFzaSvI0B9f4QJA9mIINX10UWBelsn1FDZl11lbp
         rIRjp3OcbZfQCaFgd3G1oaf+m0OTudetBUeVsTbxTi6iGTCGvKa6iHfd7zXe3nVSjQRs
         NwuL6YZz7DBLHKB26QlzQ/NIPcUyYHpdx9D5PY5h82BLeaOQVxW9eJMeY5QZwSmMgV88
         nWFcvrEP/YRyMlfNzUUNGrn1obqtYwzCkb+dzNEbHJn8ZpYzP8goCCg3W9KzrgOor7YE
         n0MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sAPj1OEKh4A63q6py1ZO6zRPXlsc0BcP6GjS55qu28I=;
        b=hTX1BpMsgnJnMI+5yZSMucx2Ah5HFQbfsF+kryQvLwoeiARABO0H1VSXpZ7Tm09HRe
         acH6xFMObWyjZuqFhwtq1/9j2eJse7je2XFByX2eldN50dJ9Ci+tclAh+PJHlAIoIZ28
         vqyql80cxkV2Vqu8bH84qB1il1cpUg8eocu63bltSuNZqQdlXvJgU84D02iAKNW8C2K5
         s1BE7CsORFnlroH32rhrec6r+vly39+xKLLPGgfd2G8Sol4Y/J9CmZsmeco2Of03PpuF
         mPrnppSIr5Zpnq2bx/tHs2OoO8qVHriLTFjbGXO3mlhDpTSM4OAV6MpwRTVSTvElukWT
         eZ4Q==
X-Gm-Message-State: ANoB5pkz/yPb3lqsdkflDwB58PnYHuh+YwUrJt5tgn1tyuJ2eURIvCNE
        ozEIpehZiPmTfFFJ4BChhJw=
X-Google-Smtp-Source: AA0mqf5PWBdijLGvRw6jOTQsfQLdPSebW1ObSVZfpfDSqqy8iimaYaRXuVhAt/i7sTD2g7aCs48Law==
X-Received: by 2002:a17:906:9f02:b0:7b5:f5c9:b450 with SMTP id fy2-20020a1709069f0200b007b5f5c9b450mr43140197ejc.65.1669849506093;
        Wed, 30 Nov 2022 15:05:06 -0800 (PST)
Received: from skbuf ([188.26.184.222])
        by smtp.gmail.com with ESMTPSA id sb25-20020a1709076d9900b007ba46867e6asm1138559ejc.16.2022.11.30.15.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 15:05:05 -0800 (PST)
Date:   Thu, 1 Dec 2022 01:05:03 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com
Subject: Re: [Patch net-next v1 01/12] net: dsa: microchip: ptp: add the
 posix clock support
Message-ID: <20221130230503.elc4hbxl6fcemx7y@skbuf>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
 <20221128103227.23171-2-arun.ramadoss@microchip.com>
 <CALs4sv19Efi0oKVqRqRFtF2SCr6Phejh4RFvuRN1UCkdvcKJeg@mail.gmail.com>
 <5639053.DvuYhMxLoT@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5639053.DvuYhMxLoT@n95hx1g2>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 03:56:30PM +0100, Christian Eggers wrote:
> > > +#define PTP_LOAD_TIME                  BIT(3)
> > 
> > PTP_WRITE_TIME sounds more intuitive than PTP_LOAD_TIME?
> 
> PTP_LOAD_TIME has been derived from the data sheet:
> 
> -------------8<--------------
> PTP Clock Load
> --------------
> Setting this bit will cause the PTP clock to be loaded with the time value in
> registers 0x0502 to 0x050B.
> ------------->8--------------
> 
> I would also prefer PTP_WRITE_TIME. But is it ok to deviate from data sheet?

It depends. When the datasheet has succint and uniquely identifiable
names for registers, there's no reason to not use them. Exceptions are
obnoxious things like "BASIC_MODE_CONTROL_REGISTER" or "MDIO_CONTROL_1"
which get abbreviated in kernel code to "BMCR" and "MDIO_CTRL1".

When the register names in the datasheet are literally prose ("PTP Clock Load",
with spaces and all), some divergence from the datasheet will have to
exist no matter what you do. So I guess you can just go for what makes
the most sense and is in line with existing kernel conventions. People
who cross-reference kernel definitions with the datasheet will still
have a hell of a life, but hey, you can tell them it's not your fault
you can't name a C variable "PTP Clock Load".

OTOH, I don't find "PTP_LOAD_TIME" unintuitive, but I won't oppose a
rename if there's agreement from people who care more than me.
