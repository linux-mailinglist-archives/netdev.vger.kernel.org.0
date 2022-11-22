Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEBD633F96
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbiKVO6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbiKVO5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:57:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4BD40477
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669128879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BQhBdYbvNkP0eP2nbbeySm3YiluuN527Uf5Ie/DRhVQ=;
        b=BrX64QPQF6iPEwU4x02UbX10veU9/1EK584oEUpIO7rgF3Nq6kmtlXt3iw4N861MgAaOYx
        zsslmTH8LY3Hlhh6rp8cifEm++CCsWMW1zxAtu7bOHwTfIEJGqI2V0aWcObPA8FlnEouYE
        OZB8CoYgq2zpS/uLbMOX00aB8OvqC/I=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-86-hXviyL7xN5WoXmMEAQIOKw-1; Tue, 22 Nov 2022 09:54:36 -0500
X-MC-Unique: hXviyL7xN5WoXmMEAQIOKw-1
Received: by mail-wr1-f70.google.com with SMTP id v14-20020adf8b4e000000b0024174021277so4370045wra.13
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:54:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BQhBdYbvNkP0eP2nbbeySm3YiluuN527Uf5Ie/DRhVQ=;
        b=GO1TtoNoFId7a2gnF3JR3/Vxx9Rhcx2sZtvAgR+69ju5azPift/CKDrKypgRMwSxRd
         /P25aCNNSQCgpa++mnibaC5zUQTgrHWDQgehzkzORmWz80XHRTqpkpXheLeAa3Ec9e0f
         Kd9pPPIGcUVNGnsQmsJ/16+706IKe/ool/DLZ5mtI3hdpBVqDJ8NC4Gl4GKzcEkLgNG/
         b8bqoGp+kV7/He6ABh7kUFxxIhQmKIO1H4aQ0LXbSq3fbPYbarYDG6BNUkfLEqYi3gNr
         m2HFxNG7JeZyTj5yKPslF9ntddUMPw8bHFBMNCYG+OR2mPjck/I2p1e59ssZLyaYQDf3
         5Vzg==
X-Gm-Message-State: ANoB5pnERCvhu0CAz65n0+S5JTPsPAxI93ilOHLpqUA0XdNpVPXjK+YF
        0pqHcJAuVbMqK7mVWphMfNRKE0r4K+SYWwl12paIWpbWMt3naSFN5axZFEJb8HWjRYPAUan4qFk
        T7t/Ftio39pZecaQg
X-Received: by 2002:adf:fc50:0:b0:241:d2de:b11e with SMTP id e16-20020adffc50000000b00241d2deb11emr6798781wrs.347.1669128875410;
        Tue, 22 Nov 2022 06:54:35 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4XCHIf/w2Z/vFBbJK7QGJPB/tUZZolPFh+8Q0cfmi9UiEJuPJsq20c6J+DsEmyTz3Q+jlxfA==
X-Received: by 2002:adf:fc50:0:b0:241:d2de:b11e with SMTP id e16-20020adffc50000000b00241d2deb11emr6798767wrs.347.1669128875215;
        Tue, 22 Nov 2022 06:54:35 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id m29-20020a05600c3b1d00b003c6b7f5567csm3292531wms.0.2022.11.22.06.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 06:54:34 -0800 (PST)
Message-ID: <927643d6c2e5f681847fd2023ee2dab371ecba12.camel@redhat.com>
Subject: Re: [PATCH v2 net-next 2/3] net: mscc: ocelot: remove unnecessary
 exposure of stats structures
From:   Paolo Abeni <pabeni@redhat.com>
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Date:   Tue, 22 Nov 2022 15:54:33 +0100
In-Reply-To: <20221119231406.3167852-3-colin.foster@in-advantage.com>
References: <20221119231406.3167852-1-colin.foster@in-advantage.com>
         <20221119231406.3167852-3-colin.foster@in-advantage.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-11-19 at 15:14 -0800, Colin Foster wrote:
> Since commit 4d1d157fb6a4 ("net: mscc: ocelot: share the common stat
> definitions between all drivers") there is no longer a need to share the
> stats structures to the world. Relocate these definitions to inside
> ocelot_stats.c instead of a global include header.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

I think it's preferable to keep the moved code verbatim as-is instead
of additionally fixing the checkpatch warning in the same patch.

The mentioned cleanup could be a follow-up patch - togethar with the
trailing empty line removal.

Cheers,

Paolo

