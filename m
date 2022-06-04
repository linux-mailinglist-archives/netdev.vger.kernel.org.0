Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B7A53D4C3
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 04:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244343AbiFDCB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 22:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239693AbiFDCBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 22:01:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B46CC31
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 19:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654308113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P5Z6sqMniESbIA5jCZ/sWFr4MxGC2e9xfA7pFQrjpdE=;
        b=SsAVYCi9o0a2cGCHDRLedrUfODdKbBfXgotum7xnms+FH6pUiLEymfLsgeZulLidD1I+f3
        cEwCL4mHsNmeDLDmqF7Onspf6lHPGsQSaaDLIlMbEpJ82XLzBwX2H8ZpL9Fj2wEWgDExMU
        z3lPDsqrcmcRWcKb8M4dtJb8J+GPi94=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-i1jvokj3MGuFgl1Ca1AuTg-1; Fri, 03 Jun 2022 22:01:50 -0400
X-MC-Unique: i1jvokj3MGuFgl1Ca1AuTg-1
Received: by mail-qk1-f199.google.com with SMTP id o18-20020a05620a2a1200b006a0cc3d8463so7230245qkp.4
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 19:01:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P5Z6sqMniESbIA5jCZ/sWFr4MxGC2e9xfA7pFQrjpdE=;
        b=qRJz0+0hMx3/YKai3xG16Xgz484ouxuBM1U22RERLBUspEWjBbeqJnMEdPwzOGaNmR
         OptAEgHcdWZDzTn5mrypMpWjsqGp2FeBaTh7wuyViOWCQKYLGrxk3T4WfR2SZ13+s9lK
         eQIKDfWdtX9KyMkkygJrutmLD4mL7bVjVroN5i6G/QSpiwFQA/X2ZteFF0wlTm6jcRtw
         mejypJq7Sv/Tq2TKOdMOQMPtHlLe9KfFkW2XdQss2J2xtYZLc937kDIB+Z3YPc02KDPM
         v0CscpC2KXf21b2fmB9iB1XrhLKaptqD+d7DMzY9XYLHoJE01LyTEnFjFILjAza5SSMB
         dmDw==
X-Gm-Message-State: AOAM532FhmDXTAQTD5whbCN2ZpofdZhtg/Bsu6zdFlCiqdtp+Vdm0Xr4
        Ks+gL6XQacaxe2/gu2N+nLQ3rG9d8mNM74ilY68WtdbLuCVf0WGpvB5FlTyEArLVGj5TjlYLxkL
        DnwUY5Nzxa3EdxaPe5qpCEHB6udyl7Xly
X-Received: by 2002:a05:620a:24d1:b0:6a5:99e2:6247 with SMTP id m17-20020a05620a24d100b006a599e26247mr8668801qkn.691.1654308109584;
        Fri, 03 Jun 2022 19:01:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2iy1DM9FV4x370xPca3Rg9fz0NUJGv3a/wqv1A9jVGXtyYlLK468ILY6CWDmgVL+ONfpSjZ48GpzSnx0Hls8=
X-Received: by 2002:a05:620a:24d1:b0:6a5:99e2:6247 with SMTP id
 m17-20020a05620a24d100b006a599e26247mr8668794qkn.691.1654308109395; Fri, 03
 Jun 2022 19:01:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220603182143.692576-1-miquel.raynal@bootlin.com> <20220603182143.692576-2-miquel.raynal@bootlin.com>
In-Reply-To: <20220603182143.692576-2-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Fri, 3 Jun 2022 22:01:38 -0400
Message-ID: <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator interface type
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jun 3, 2022 at 2:34 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> The current enum is wrong. A device can either be an RFD, an RFD-RX, an
> RFD-TX or an FFD. If it is an FFD, it can also be a coordinator. While
> defining a node type might make sense from a strict software point of
> view, opposing node and coordinator seems meaningless in the ieee
> 802.15.4 world. As this enumeration is not used anywhere, let's just
> drop it. We will in a second time add a new "node type" enumeration
> which apply only to nodes, and does differentiates the type of devices
> mentioned above.
>

First you cannot say if this is not used anywhere else. Second I have
a different opinion here that you cannot just "switch" the role from
RFD, FFD, whatever.
You are mixing things here with "role in the network" and what the
transceiver capability (RFD, FFD) is, which are two different things.

You should use those defines and the user needs to create a new
interface type and probably have a different extended address to act
as a coordinator.

- Alex

