Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87505455C5
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 22:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbiFIUiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 16:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345032AbiFIUiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 16:38:02 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F296C4D686
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 13:38:01 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id i1so21147993plg.7
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 13:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tS8OCHXiHrUBOQyp3m+GeOsRq/l4TuuwhQdWQVxHDH4=;
        b=QHBWgVRsaMauO4m7DiMPK7H0u7l9dh/H/moVkr1v3rynk/F/OwSd7PC5Pmq0sfOnC2
         y/57zw1eYIJ7fysTht59MjN3Hf/xx4FfgCw2ylorxCUFsHPExwBiT74PCmX7PDJST56H
         s1hF8HvTm8uUMS6qM5caknJNOskNH4D5ZgrHnU2gmumDCysoy3E7CTF29tm5XrWsQcdY
         GZwQ9nQjd3JURY/2Mr+eynFOy1w1XMHsQ5Nooga4RHiKOICya64DuPPyHb236rC4UJKz
         +him2bzc7x43E9FcLMGIoDPvRo+qrbHvHwadJ5Qa0RLRpHuRQSWsg396YawVDU7/fpoh
         AdTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tS8OCHXiHrUBOQyp3m+GeOsRq/l4TuuwhQdWQVxHDH4=;
        b=ALgxxSp8duwPaJsGGKJXPkkW31Zd+51nkJNCKnX7vRgW4t0r+MsQwfgFmxmjv1lkBD
         O5iYYsjUzlFrPaIrGWQtA1cITPu12tRFojrQQ3Syq6+FcpGdXCyKzyyAmGEWaWX2kAHk
         q7k5mC1SmgxbvQ2GcsX2L+tAvjz8Y0XTp0gbu/R2/H0YazRqiMcExM4x7yrLEarksG2s
         kE10VNt0RcJbGUot2XSTfV3Kkhb8iyYQu5FHD1SLq9+8pBNDhhRBdDiHfHMHxDs1tsey
         WiZ5KSl6p/3AfUHcI/P4Pgu+w0k9D2q976+GlmLp3/3wkzqr7vUJZZ6byqW6Gr/1yEUj
         bb/A==
X-Gm-Message-State: AOAM532zrqz2veHct4XlonQvxBzbIi13w5UeasTMrtvZEiBFmYJPJ3Sr
        QtDF6oFAdhF+q8t9f/KgHlc=
X-Google-Smtp-Source: ABdhPJzic6sHM+JYb3sn7B5ss39CDtLbYiIhrn46YMhkGpEmrV9ej2prr0timIdRjrCX593i0wrk8w==
X-Received: by 2002:a17:902:d64e:b0:163:5074:c130 with SMTP id y14-20020a170902d64e00b001635074c130mr42304972plh.125.1654807081469;
        Thu, 09 Jun 2022 13:38:01 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id v12-20020a17090a458c00b001e6a230c2f5sm108200pjg.34.2022.06.09.13.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 13:38:01 -0700 (PDT)
Date:   Thu, 9 Jun 2022 13:37:58 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lasse Johnsen <l@ssejohnsen.me>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH net-next v6 2/3] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220609203758.GA26115@hoboy.vegasvil.org>
References: <20220608204451.3124320-1-jonathan.lemon@gmail.com>
 <20220608204451.3124320-3-jonathan.lemon@gmail.com>
 <20220608205558.GB16693@hoboy.vegasvil.org>
 <BCC0CDAF-B59D-4A7A-ABDD-7DEBBADAF3A3@gmail.com>
 <20220609040141.GA21971@hoboy.vegasvil.org>
 <85F4D27D-EF7F-4F69-9020-769D2461777D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85F4D27D-EF7F-4F69-9020-769D2461777D@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 12:21:25PM -0700, Jonathan Lemon wrote:
> Seems like the 100000000 ppb max value is in range?

Sounds good. Appreciate the follow up!

Thanks,
Richard
