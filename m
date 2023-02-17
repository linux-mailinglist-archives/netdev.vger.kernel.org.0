Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946E169B13D
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjBQQms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjBQQmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:42:46 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32AC6C007;
        Fri, 17 Feb 2023 08:42:31 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id w13so1526600wrl.13;
        Fri, 17 Feb 2023 08:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HP7P5wY5KjXWhTQfhjL/AZ7aXRO3BkcNhUznhmjsZV0=;
        b=D8ECN446+9TLJuw0JpiFgv59YKqRptRXP6CNaG7ffpp78AWHuU3dmVtomBxvyN+TOe
         Mvty0YFegaQQ98QJrcOmcih7o9kki6aI3YcNof7gBwqN6KVcBzAfiZ33PX1Q99yTjrg0
         g/wY6RV3lHvq6zCPUXYwkdq9jUpqquo6UIIjsL222jMltELJvN6gCCjXDXSTPLoQBPzb
         cJPFPzc6a8HtQkRCoeLkjlOm+tMvoMLRAglf4bNN8ZhOAlHhOgTphnFXg4DIeOlkKDC+
         tCBqpy0E/MFYBbMC1qMqAYR1xkHqJR4CTbdyfGLJNUhpT17u3ft1wDtXpy3qBG5goqto
         DTfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HP7P5wY5KjXWhTQfhjL/AZ7aXRO3BkcNhUznhmjsZV0=;
        b=aVerhJBiOTEYs5haNotkRhqC0NL6VYKMHUBcm4xlOAlvxry4NsD3dLGXc+kuoiHYxm
         Zq3hKurRQjAfPb6SJkBHLqCyC1uW8bQQPybDD5cBxcwQDLYVnsJtV11EBWsx1wY1u194
         G3Ip/MNxVvEOm9PSd++g4IP7BlaF+bvsriHlfFcZRhMQjifbqxVgtQaLbrCtQbhIFXEi
         I5vUOSi0ya0fGaBETcp/D9LGi90VbPHUIIH8Ow8uM8y7FE9/pi+g0oFom1SVvW/luouX
         mNSb7ivBiKCMLik6eqPgIJHCClklOAeqQrPziiLyAt0P2l8l/8rRP79i2hxtBadZUw7b
         QbfA==
X-Gm-Message-State: AO0yUKW/7kV8wjjBT3d1IPBVCFRKmIxrjFFlguRiEALZUbCKXlr4wvOq
        iK8BawwC10TXFD9jRvzKOeA=
X-Google-Smtp-Source: AK7set89kf8Gisjvp6/g0zXoIvBpxPPdlcXPzeABXleQ7+aIb1d6SFdUCJBVwr65LQHMKotWY4st4g==
X-Received: by 2002:a5d:60ce:0:b0:2c5:54fd:265e with SMTP id x14-20020a5d60ce000000b002c554fd265emr1038678wrt.70.1676652150181;
        Fri, 17 Feb 2023 08:42:30 -0800 (PST)
Received: from skbuf ([188.25.231.176])
        by smtp.gmail.com with ESMTPSA id n17-20020adff091000000b002c558869934sm4713612wro.81.2023.02.17.08.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 08:42:29 -0800 (PST)
Date:   Fri, 17 Feb 2023 18:42:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 3/5] net: dsa: microchip: add eth mac
 grouping for ethtool statistics
Message-ID: <20230217164227.mw2cyp22bsnvuh6t@skbuf>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
 <20230217110211.433505-4-rakesh.sankaranarayanan@microchip.com>
 <84835bee-a074-eb46-f1e4-03e53cd7f9ec@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84835bee-a074-eb46-f1e4-03e53cd7f9ec@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 04:01:15PM +0100, Alexander Lobakin wrote:
> > +		++mib->cnt_ptr;
> 
> Reason for the pre-increment? :)

because it's kool

Somebody not that long ago suggested that pre-increment is "less resource consuming":
https://patchwork.kernel.org/project/netdevbpf/patch/677a5e37aab97a4f992d35c41329733c5f3082fb.1675407169.git.daniel@makrotopia.org/#25197216

Of course, when pressed to explain more, he stopped responding.
