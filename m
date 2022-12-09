Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2626F648486
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiLIPDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiLIPC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:02:57 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4216514D03;
        Fri,  9 Dec 2022 07:02:56 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id b2so12107095eja.7;
        Fri, 09 Dec 2022 07:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n20kjH1TEK8a6jSyYdrJkfLyYfKvxeNJy6e8oQLyrbs=;
        b=HDrvtDDaH9M8Sc9qTw51F9nHnaJbIK954szknV+1YiORLbyzsSFWa+LaYJjbRcChxq
         3hUwVxOJWixJd4UsOoGuweORwil+lOiK+l723wmPlgGaK7JBe0JAjf6RXLdAiE9KloYy
         0VHE2HRRgpVR7gJn4BLwRHciz9NfBVJyabIM4YZj8/Bz+Mz6Kj/1ODSGUWNwfYJzmqWa
         U+DCaWi1Ji5pM2iZaZRTuogMvg+55Oz1e2CuH3wPgYXmSt2RSGiHmz4jOAsCcuSy3QLo
         MgQaCPWceukwFeymZvC7E9dg1x4i97/1rdnbrnnmz7npvYXkUVuk1NAf5uWFNoLj4x5c
         csVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n20kjH1TEK8a6jSyYdrJkfLyYfKvxeNJy6e8oQLyrbs=;
        b=di5ZIgO0bnoYW7GrNgqNDg814FxBimTo3heCidT7IuPKMI3kj+QraGcTE9JXG3p/BW
         g1ZDQSo6CeVZTJMaYAoWFiAgooN5BHJyZYvPq2Sfrv7w3ppNh9ikWMbFGUTkRgHtsYCe
         DpwmEtJzDGoryJRuVapdQYk+AE1LOIgI33luB1MsHGusPsB8Z4A+SEHSHj24fGJD6Z6v
         AP5fmcbHR6Zmvxz5FJU7J3kDPcM2cv4yNOzkNXFWw1rnpDL5pvWLYF6elejMoQ/kNhuh
         xcqrrBTVhPGQfij2NPyI2i5vURYjL0jOCMuBotYK6UqKNdHS1VPbOg8yJ3idGftfObdJ
         eGHg==
X-Gm-Message-State: ANoB5pksNdlGA2lEPyQttHFV4SxuAyDVvCn1uY/Ny7R5GmNckBEr7BOy
        BFE7s0D2HjFqBWoLVOInycE=
X-Google-Smtp-Source: AA0mqf4NIIHK+Ho9aADTkgSglVkAFYHeZDE4zobsdd5ijNvTewoGkumpwcBbTUT5RogdYZalI4uQ8w==
X-Received: by 2002:a17:907:d008:b0:7ad:8a7a:1a44 with SMTP id va8-20020a170907d00800b007ad8a7a1a44mr5706493ejc.47.1670598174607;
        Fri, 09 Dec 2022 07:02:54 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id fu17-20020a170907b01100b007c11e5ac250sm7241ejc.91.2022.12.09.07.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 07:02:54 -0800 (PST)
Date:   Fri, 9 Dec 2022 17:02:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v3 06/13] net: ptp: add helper for one-step P2P
 clocks
Message-ID: <20221209150251.yio23u6pbya7n5ka@skbuf>
References: <20221209072437.18373-1-arun.ramadoss@microchip.com>
 <20221209072437.18373-7-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209072437.18373-7-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 12:54:30PM +0530, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> For P2P delay measurement, the ingress time stamp of the PDelay_Req is
> required for the correction field of the PDelay_Resp. The application
> echoes back the correction field of the PDelay_Req when sending the
> PDelay_Resp.
> 
> Some hardware (like the ZHAW InES PTP time stamping IP core) subtracts
> the ingress timestamp autonomously from the correction field, so that
> the hardware only needs to add the egress timestamp on tx. Other
> hardware (like the Microchip KSZ9563) reports the ingress time stamp via
> an interrupt and requires that the software provides this time stamp via
> tail-tag on tx.
> 
> In order to avoid introducing a further application interface for this,
> the driver can simply emulate the behavior of the InES device and
> subtract the ingress time stamp in software from the correction field.
> 
> On egress, the correction field can either be kept as it is (and the
> time stamp field in the tail-tag is set to zero) or move the value from
> the correction field back to the tail-tag.
> 
> Changing the correction field requires updating the UDP checksum (if UDP
> is used as transport).
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>

Arun, this needs your Signed-off-by: tag too.
Sometimes patchwork catches tags like these and appends them to the
patch automatically when you just reply with them on a new line. Works
with Fixes:, Reviewed-by: and Acked-by: at least.

If there are no other review concerns with this series and it's
otherwise good to go, I suppose you could try that.
