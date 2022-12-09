Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627656484F9
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiLIPYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiLIPYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:24:37 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63478F65;
        Fri,  9 Dec 2022 07:24:36 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id m18so12265954eji.5;
        Fri, 09 Dec 2022 07:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zBxZmKASujRGXAQwg4AGB2Rb3A92fAIMeJdn8tudd7s=;
        b=pAstSTIGSWebBSqcCm9ACftdx6zeG4YpPXLxDYjTRS0te5Z/MyYFFDIGUaKaG2mTDe
         wEl6eW0QozZI3EQfycUhhcjAlpMxlA6wt9wtEn85VV7Knx0iAabnr7v+dtW3lX7zRtqd
         khg9YXmO2I0liB/Nvc8msQWYQZYOSpJSxui/3IbjZxjcMKZrEa/27tdnejCgiNF5e9p9
         WidQmwISlR+c7Slj5esf9ICvGPTchWZSEajYSJkqkw2lIQVF/W4Qx541uxNqcrFdtIxF
         9VTcpDy2yniDaZTMnETtsMgHjBzPo6DmUPBrEAK6rP18kO0ySLOvE5WcGoqki/zaKMPC
         ABsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zBxZmKASujRGXAQwg4AGB2Rb3A92fAIMeJdn8tudd7s=;
        b=MQu1q+5jPDm03/uuxWUUSSXAeYMMzqeaFgoGVi9lraj68w4WxVuXvxbETbfT2wmh6N
         VojCUR9KvjvmmQQwfLB9scg/twRE7wuJNlXGlNAsycJR+TXe0ahZheis2NA/6dqqOjYB
         OsVKcSXECtNiGKrBOByTiMV9XjMg0kWg80fyaOSnLai8/WzQt8e1IeBk9V4pmmoWOF3q
         7STTxQr1aaNTq+DNToRAFVZwaJHCOVak8M9Q6niQWx56x94byndduKZjAQjEi53KvjRP
         jht68LTxQxU929qBTXaJuAWAIrl1AA9yq1vEH7iTDZ5ywlNuTMGS8eIAfKiOMxoYdLlU
         A2nw==
X-Gm-Message-State: ANoB5pltOw/1VKrdZmu+c6SzVBknV6haOVl5AWucopHlAm+hIwSst2pD
        QqMvhjwsTziU3u31FIw6rDs=
X-Google-Smtp-Source: AA0mqf7mqOqpRcv0MWLL5rVRVffbqJSsoYl1RFMT//Oaiur1xvkXmeVJDwyI4+bF0RS00od0zQrNYw==
X-Received: by 2002:a17:906:c096:b0:7bf:1090:ded4 with SMTP id f22-20020a170906c09600b007bf1090ded4mr5451643ejz.49.1670599474843;
        Fri, 09 Dec 2022 07:24:34 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id s7-20020a056402520700b0046ac017b007sm764258edd.18.2022.12.09.07.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 07:24:34 -0800 (PST)
Date:   Fri, 9 Dec 2022 17:24:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v3 00/13] net: dsa: microchip: add PTP support
 for KSZ9563/KSZ8563 and LAN937x
Message-ID: <20221209152432.pv2bhygt4mqx3bq7@skbuf>
References: <20221209072437.18373-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209072437.18373-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 12:54:24PM +0530, Arun Ramadoss wrote:
> KSZ9563/KSZ8563 and  LAN937x switch are capable for supporting IEEE 1588 PTP
> protocol.  LAN937x has the same PTP register set similar to KSZ9563, hence the
> implementation has been made common for the KSZ switches.  KSZ9563 does not
> support two step timestamping but LAN937x supports both.  Tested the 1step &
> 2step p2p timestamping in LAN937x and p2p1step timestamping in KSZ9563.
> 
> This patch series is based on the Christian Eggers PTP support for KSZ9563.
> Applied the Christian patch and updated as per the latest refactoring of KSZ
> series code. The features added on top are PTP packet Interrupt
> implementation based on nested handler, LAN937x two step timestamping and
> programmable per_out pins.

From my perspective, the DSA API is used correctly and it should be good
to go in the next patchset iteration. API usage is about all I tried to
concentrate upon. I of course encourage Richard and Christian to point out
if there's something out of the ordinary on the protocol side of things.
