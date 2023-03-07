Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87FE96AFA3F
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 00:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCGXYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 18:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjCGXYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 18:24:01 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B337C3C7;
        Tue,  7 Mar 2023 15:24:00 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id l25so13763820wrb.3;
        Tue, 07 Mar 2023 15:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678231439;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=G3n79AzFuz7c3iTElQNMr1TqOULwAsJ6IJ0hPCCgpQU=;
        b=ciJy4b/VcwHfnspFBNgsIqlZyln7+5duyARWTz5ql1n5Si8BEPil0cG01YYJOg0kV5
         ANaBgB+UkAiPUgsusEIUtAhOAN7fJNiHStEzPhfTted7lIWm2R7SsNeRJ1h+UTmPWZIn
         ZijswhsyMko93caddvb3hdcseGIYZcEB8al2+RSXq1iEZGvfrh8pG33BCvKSCu5sLkHz
         0um46oHLu56TZJ72FZmMeze42H/HcstTHxPLeEhk/YkoDbZLJshnzQjOttw7of5kGa3s
         yeamvodd8QFwQ5BdHZgF+EsLV7cj1MkUhoEkh8HeMVIyTjXVTqc94UVJiwTybb7U4IpJ
         YS+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678231439;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G3n79AzFuz7c3iTElQNMr1TqOULwAsJ6IJ0hPCCgpQU=;
        b=CsC7ui6dm6tvyWDvf8vwHJLJ/pPTinzeNE6l2BALzNXZPvh695QLUGTHdHjteXL38I
         1xwnBJEb5UqE+fWWgWCoVGOlNlpIHURHas69XPfgd0n2Wl9ebGrw/CXWB5AZ32n3waK9
         9ZrlLJeQgglSMvcMGWngJja+vllih6JpfagstkLrUtoiXrNmwckCfp++pdq8kReLhC52
         UT0f0ATsvcx1mIUzcd2ntSZH5m+imDgXCJzrFACfxa4wfbmd0davZFwA7Cs7zyRKIdiR
         HjCj5387w/sZQkUlRG97FN8T8bU0WE3iwgwSfHpSX6RKpq9rGNOIKJCz9kyzwrz3pw29
         8kvw==
X-Gm-Message-State: AO0yUKV8GSvKtsIy24+ZliT/O9Y4tRRKuvtEqoBHo/3XbKz/GcDwwA0s
        yaVARmbIBgveUYGjxBuDGFU=
X-Google-Smtp-Source: AK7set8fRdFkYTCIBEyyCckKbys8lYaus6jTYlWqAvovvGQ2slx3Dpyp0Yg1lQNnoawIvaok94AYMQ==
X-Received: by 2002:a5d:6111:0:b0:2cd:ddd6:c215 with SMTP id v17-20020a5d6111000000b002cdddd6c215mr11091178wrt.52.1678231438816;
        Tue, 07 Mar 2023 15:23:58 -0800 (PST)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id v28-20020a5d591c000000b002c6e8af1037sm13613253wrd.104.2023.03.07.15.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 15:23:58 -0800 (PST)
Message-ID: <6407c78e.5d0a0220.98d00.4d95@mx.google.com>
X-Google-Original-Message-ID: <ZAd7qLazOCaLpzg9@Ansuel-xps.>
Date:   Tue, 7 Mar 2023 19:00:08 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH 03/11] net: phy: Add a binding for PHY LEDs
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-4-ansuelsmth@gmail.com>
 <7c83540c-ec29-4a2e-b50b-098182b4b68a@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c83540c-ec29-4a2e-b50b-098182b4b68a@lunn.ch>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 12:17:51AM +0100, Andrew Lunn wrote:
> On Tue, Mar 07, 2023 at 06:00:38PM +0100, Christian Marangi wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > 
> > Define common binding parsing for all PHY drivers with LEDs using
> > phylib. Parse the DT as part of the phy_probe and add LEDs to the
> > linux LED class infrastructure. For the moment, provide a dummy
> > brightness function, which will later be replaced with a call into the
> > PHY driver.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> Hi Christian
> 
> Since you are submitting this, you need to add your own Signed-off-by:
> after mine.
> 

Tought it was needed only for patch where I have put any change. (case
of 2 patch in this series where there was a whitespace error and had to
change a binding)

Think I need do to this for every other patch right?

-- 
	Ansuel
