Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F355A4D6C1B
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 03:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiCLCti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 21:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiCLCtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 21:49:36 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE65132942;
        Fri, 11 Mar 2022 18:48:32 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id q13so9121553plk.12;
        Fri, 11 Mar 2022 18:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=/QbyG5b+gu58LmSy08Yok7CVH6tbIv8OI8nBcPnh//o=;
        b=VGCvYKe86Qmt0bozZS/+t8wm2hRX+gn0qMv82VM4J+ZgD3yDNbZj/cvmraaFVLXz44
         ST1xhsD5eUCTrFc/seeYdpC1nyr0r2oc9efFLe4As1YPesDY+oNshx9IRMsZWmhedv5f
         roUovRnrMBrWrNKA0OBIQ2YDOETa8qCAOlJzYqgt2A6mW1fMiiOIvvsx7T0hqoGpWm6y
         cgRRSU3Ct0qvbULzQhTKHjBQmzyBDp7ipdjYh8I2/JZd6R4fsaLYcD+mkoQjAaaa0wz2
         1qZ9byifv3byyNRkLuPcyJ8Vzv9dOHn/NHvBFS8SOeuib0wQnIBDiEC9iWFtHMKq3Sda
         askg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=/QbyG5b+gu58LmSy08Yok7CVH6tbIv8OI8nBcPnh//o=;
        b=6Fxhetzk3NpsX9UlDr6p63rYH7ldSpbQtXB58/ERr1lWKDwGomxb/nnmSpCM8L2Vsj
         01IZdRHVcF9QogfFG3U41FIFTzbn61XCGEXsh8C1D/R4E/WDkqvplQTX+yMD4NFEu6U1
         RysDq96gUnzVoxZmVf6pKnw6MzOIspARdaHShzExFMw5wP3lkrsqmXlh54+nqImlzUIi
         ANorpyl68q29pG9WH0iL0sTxhpYHJUmyuRNlUVaNFXgDW8QfX+6i/rK3FLPGp3DRnIzl
         21r1+gEBmV2TgjFb780X2GPIEthYVx/4QfbW/wI+M5GjQZ/F0BEszhOCQxWvVBdbbDWJ
         VFcg==
X-Gm-Message-State: AOAM533cJ+blCBTkBLdT5Z9c4KqSi5WoZjLKn0ocnmzSx9S6uum4rBYK
        /wmf6XBmVxa2hx9Tq8zIag4=
X-Google-Smtp-Source: ABdhPJz3J7O/rNgX0CpFlkzK7uDxO5Fx+Y+H+FeHN0n/8IZsGArnxxnU2d7UsdpojmXRt/YWwQ9p0A==
X-Received: by 2002:a17:90a:8591:b0:1b9:da10:2127 with SMTP id m17-20020a17090a859100b001b9da102127mr25128598pjn.13.1647053311967;
        Fri, 11 Mar 2022 18:48:31 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x18-20020a63b212000000b003807411b89esm9685936pge.54.2022.03.11.18.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 18:48:31 -0800 (PST)
Date:   Fri, 11 Mar 2022 18:48:28 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Woojung.Huh@microchip.com
Cc:     linux@armlinux.org.uk, Horatiu.Vultur@microchip.com,
        andrew@lunn.ch, Divya.Koppera@microchip.com,
        netdev@vger.kernel.org, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com, Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220312024828.GA15046@hoboy.vegasvil.org>
References: <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YidgHT8CLWrmhbTW@lunn.ch>
 <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
 <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
 <20220309195252.GB9663@hoboy.vegasvil.org>
 <BL0PR11MB291347C0E4699E3B202B96DDE70C9@BL0PR11MB2913.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BL0PR11MB291347C0E4699E3B202B96DDE70C9@BL0PR11MB2913.namprd11.prod.outlook.com>
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

On Fri, Mar 11, 2022 at 03:21:58PM +0000, Woojung.Huh@microchip.com wrote:

> If you are referring to the delayAsymmetry of ptp4l,

No, really, I'm not.

       PTP4l(8)                    System Manager's Manual                   PTP4l(8)

       NAME
           ptp4l - PTP Boundary/Ordinary/Transparent Clock

       ...

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

> So, this latency should (hopefully) be not-much-change in the same board after manufactured. 

Please read the papers on this topic.  I posted links in another reply
in this thread.

> Of cause, all values may be small enough to ignore though.
> Do I miss something here?

Yes, you miss the point entirely.  PHY delays are relatively large and
cannot be even measured in some cases.  However, for well behaved
PHYs, the user space stack already covers the configuration.

Thanks,
Richard
