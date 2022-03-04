Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662754CD59C
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 14:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238833AbiCDN4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 08:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238638AbiCDN4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 08:56:32 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E44E1A3633;
        Fri,  4 Mar 2022 05:55:45 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id q11so7782907pln.11;
        Fri, 04 Mar 2022 05:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=+2Ag8K/blpO/TDuAG0o3dn05J6Gq6o2fRSh54mpEwNc=;
        b=B71XufcFomvBNM9td+bERxkg2FnnNIE9z1nFpYLaic4J1is3LslJm+trITcDpEppZ8
         I0cS8rlQohzdopXi/QsAbtGWrI0JM+Ht5Fu+93Zjd80WJNSh6nLUyXscc3FAdJaJRi8F
         jRb/E1d6oovgk1UYZtWTqRt8Qj7gdKco/+AgYb5y/0z4woLwswXubxhRCM0gNXqx4tR/
         XrHlkDmLSDQEHiph4KOkQWfh4xT0Kalrpx7nR0U1ie1V8JjssCrxz+HqWqLEhNArz3Cf
         FRnix0gcKRlYythQZCI3zd9KWWmOiZQvcOgquPZ0vJPbfLVTFtn7M6Gd53Yeky+D4+u1
         Vbaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=+2Ag8K/blpO/TDuAG0o3dn05J6Gq6o2fRSh54mpEwNc=;
        b=E0T0gEwamddL1kCOofdzJFBqHABy2cgu4TwhS9lLZv0xP5XHK6oYNj3K2Ok07RDSeI
         fibA4hIoG8YNnj1lebdkOkoPTqBqd3js1NmiOoUB+tczYZL30QWvRC+jdMrBdnq/wdjU
         5X1vnRBRKJk55vMh6YAsNIu/VvXqxGJrruEHVb3vT3iI8FOyK6dqMyAeNB+tBvU5x9/z
         BWbGAey9n7OydSJv1asuMJ+lsQdVPNzFyWCsUyueqfX5oxGEGg7axU03RhDX/CysRunt
         +lJdIcGONpKfuJ0oqQtpFgduY3e0V1rUz+4LQo8i++YgDcQrezZEz47NKBTciIXF2kLV
         cHIw==
X-Gm-Message-State: AOAM531MHgbNAhNbcmJFnOIHtMeRZrb2kF+5zT+0aK2sMSwJivtnik0M
        LFkoby9Hy0UR4Lveha/vaD0=
X-Google-Smtp-Source: ABdhPJxa/iKoXGuaImlslpn8S7p8aK0lGXiSONR4kJcxGBaijeonlXy+/ieYTqit5J/nGuCrpHELyA==
X-Received: by 2002:a17:90b:3886:b0:1bf:1a16:25d4 with SMTP id mu6-20020a17090b388600b001bf1a1625d4mr6829177pjb.193.1646402144501;
        Fri, 04 Mar 2022 05:55:44 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q8-20020a056a00088800b004bca31c8e56sm6371367pfj.115.2022.03.04.05.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 05:55:43 -0800 (PST)
Date:   Fri, 4 Mar 2022 05:55:40 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Divya Koppera <Divya.Koppera@microchip.com>,
        netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        madhuri.sripada@microchip.com, manohar.puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220304135540.GD16032@hoboy.vegasvil.org>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-3-Divya.Koppera@microchip.com>
 <YiILJ3tXs9Sba42B@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YiILJ3tXs9Sba42B@lunn.ch>
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

On Fri, Mar 04, 2022 at 01:50:47PM +0100, Andrew Lunn wrote:
> Why does this need to be configured, rather than hard coded? Why would
> the latency for a given speed change? I would of thought though you
> would take the average length of a PTP packet and divide is by the
> link speed.

Latency is unrelated to frame length.

My understanding is that it is VERY tricky to measure PHY latency.
Studies have shown that some PHYs vary by link speed, and some vary
randomly, frame by frame.

So I can understand wanting to configure it.  However, DTS is probably
the wrong place.  The linuxptp user space stack has configuration
variables for this purpose:

       egressLatency
              Specifies  the  difference  in  nanoseconds  between  the actual
              transmission time at the reference plane and the reported trans‐
              mit  time  stamp. This value will be added to egress time stamps
              obtained from the hardware.  The default is 0.

       ingressLatency
              Specifies the difference in nanoseconds between the reported re‐
              ceive  time  stamp  and  the  actual reception time at reference
              plane. This value will be subtracted from  ingress  time  stamps
              obtained from the hardware.  The default is 0.

Thanks,
Richard
